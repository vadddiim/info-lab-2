#!/bin/bash

if [[ $# -ne 1 ]]; then
    echo "Script takes one argument"
    exit 1
fi
IP=$1

declare -a IP_PARTS
IFS="." read -r -a IP_PARTS <<< "$IP"

if [[ ${#IP_PARTS[@]} -ne 4 ]]; then
  echo "IP-adress only includes 4 parts"
  exit 1
fi

declare -a RESULTS
for i in "${!IP_PARTS[@]}"; do
  PART="${IP_PARTS[i]}"
  if  [[ ! "$PART" =~ ^[0-9]+$ ]] || ((PART < 0 || PART > 255)); then
    echo "Parts of IP-address should be numbers between 0 and 255"
    exit 1
  fi

  RESULTS[$i]=$(echo "obase=2; ${IP_PARTS[$i]}" | bc)
done

printf "%08d.%08d.%08d.%08d\n" "${RESULTS[@]}"