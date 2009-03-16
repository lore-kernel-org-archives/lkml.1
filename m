Return-Path: <linux-kernel-owner+w=401wt.eu-S1761336AbZCPVgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761336AbZCPVgh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 17:36:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753811AbZCPVgY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 17:36:24 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:43383 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753063AbZCPVgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 17:36:24 -0400
From: Kevin Hilman <khilman@deeprootsystems.com>
To: linux-kernel@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Kevin Hilman <khilman@deeprootsystems.com>
Subject: [PATCH v3 0/3] new memory_accessor interface and usage
Date: Mon, 16 Mar 2009 14:36:16 -0700
Message-Id: <1237239379-24186-1-git-send-email-khilman@deeprootsystems.com>
X-Mailer: git-send-email 1.6.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds an interface by which other kernel code can read/write
persistent memory such as I2C or SPI EEPROMs, or devices which provide
NVRAM.  Use cases include storage of board-specific configuration data
like Ethernet addresses and sensor calibrations, etc.

David Brownell (1):
  Implement the new memory_accessor interfaces for SPI EEPROMs:

Kevin Hilman (2):
  memory_accessor: new interface for reading/writing persistent memory
  Implement the new memory_accessor interface for I2C EEPROM

 drivers/misc/eeprom/at24.c |   67 +++++++++++++++++++++++++++++++++++--------
 drivers/misc/eeprom/at25.c |   58 +++++++++++++++++++++++++++++---------
 include/linux/i2c/at24.h   |    4 ++
 include/linux/memory.h     |   11 +++++++
 include/linux/spi/eeprom.h |    6 ++++
 5 files changed, 119 insertions(+), 27 deletions(-)

