Return-Path: <linux-kernel-owner+w=401wt.eu-S1753591AbZGHKrm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591AbZGHKrm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 06:47:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752922AbZGHKrd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 06:47:33 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:44116 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307AbZGHKrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 06:47:32 -0400
From: amit.kucheria@canonical.com
To: sameo@linux.intel.com
Cc: dbrownell@users.sourceforge.net, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org, Amit Kucheria <amit.kucheria@verdurent.com>
Subject: [PATCHv2 0/3] MFD: TWL4030: Support for dynamic power switching
Date: Wed,  8 Jul 2009 13:47:26 +0300
Message-Id: <4a547941.11355e0a.6fc4.ffff8ff2@mx.google.com>
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

 arch/arm/mach-omap2/board-rx51-peripherals.c |  122 ++++++++-
 drivers/mfd/Kconfig                          |   13 +
 drivers/mfd/Makefile                         |    1 +
 drivers/mfd/twl4030-core.c                   |   12 +
 drivers/mfd/twl4030-power.c                  |  391 ++++++++++++++++++++++++++
 include/linux/i2c/twl4030.h                  |   91 ++++++-
 6 files changed, 618 insertions(+), 12 deletions(-)
 create mode 100644 drivers/mfd/twl4030-power.c

