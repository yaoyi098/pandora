#!/bin/bash

PANDORA_ARGS=""
PANDORA_COMMAND="pandora"
USER_CONFIG_DIR="/data"

if [ -n "${PANDORA_PROXY}" ]; then
  PANDORA_ARGS="${PANDORA_ARGS} -p ${PANDORA_PROXY}"
fi

if [ -n "${PANDORA_ACCESS_TOKEN}" ]; then
  mkdir -p "${USER_CONFIG_DIR}"

  echo "${PANDORA_ACCESS_TOKEN}" >"${USER_CONFIG_DIR}/access_token.dat"
fi

if [ -n "${PANDORA_TOKENS_FILE}" ]; then
  PANDORA_ARGS="${PANDORA_ARGS} --tokens_file ${PANDORA_TOKENS_FILE}"
fi

if [ -n "${PANDORA_SERVER}" ]; then
  PANDORA_ARGS="${PANDORA_ARGS} -s ${PANDORA_SERVER}"
fi

if [ -n "${PANDORA_API}" ]; then
  PANDORA_ARGS="${PANDORA_ARGS} -a"
fi

if [ -n "${PANDORA_SENTRY}" ]; then
  PANDORA_ARGS="${PANDORA_ARGS} --sentry"
fi

if [ -n "${PANDORA_VERBOSE}" ]; then
  PANDORA_ARGS="${PANDORA_ARGS} -v"
fi

if [ -n "${PANDORA_THREADS}" ]; then
  PANDORA_ARGS="${PANDORA_ARGS} --threads ${PANDORA_THREADS}"
fi

if [ -n "${PANDORA_CLOUD}" ]; then
  PANDORA_COMMAND="pandora-cloud"
fi

export USER_CONFIG_DIR

# Defines the cleanup operations to be performed when the SIGTERM signal is received.
cleanup() {
  echo "Receive SIGTERM, Closing..."
  exit 0
}

# Register the cleanup function as the handler for SIGTERM signal
trap 'cleanup' SIGTERM

# shellcheck disable=SC2086
$(command -v ${PANDORA_COMMAND}) ${PANDORA_ARGS} &

wait
