Return-Path: <linux-kernel-owner+w=401wt.eu-S1753428AbZHQN5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428AbZHQN5y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 09:57:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753028AbZHQN5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 09:57:54 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:49874 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648AbZHQN5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 09:57:53 -0400
From: Amit Kucheria <amit.kucheria@verdurent.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] MFD: TWL4030: Support for dynamic power switching
Date: Mon, 17 Aug 2009 16:57:49 +0300
Message-Id: <1250517469-15899-1-git-send-email-amit.kucheria@verdurent.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Amit Kucheria <amit.kucheria@verdurent.com>

The TWL4030/5030 family of multifunction devices allow dynamic power
switching based on board-specific applications through power 'scripts'.

Add board-independent core support for this feature and add support for
the RX51 board based on OMAP3.

Amit Kucheria (3):
  MFD: TWL4030: Add support for TWL4030/5030 dynamic power switching
  MFD: TWL4030: print warning for out-of-order script loading
  MFD: TWL4030: OMAP: Board-specifc DPS scripts for RX51 board

 arch/arm/mach-omap2/board-rx51-peripherals.c |  122 +++++++-
 drivers/mfd/Kconfig                          |   13 +
 drivers/mfd/Makefile                         |    1 +
 drivers/mfd/twl4030-core.c                   |   10 +
 drivers/mfd/twl4030-power.c                  |  472 ++++++++++++++++++++++++++
 include/linux/i2c/twl4030.h                  |   94 +++++-
 6 files changed, 700 insertions(+), 12 deletions(-)
 create mode 100644 drivers/mfd/twl4030-power.c

