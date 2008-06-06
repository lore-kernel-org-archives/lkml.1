Return-Path: <linux-kernel-owner+w=401wt.eu-S1764691AbYFFQON@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764691AbYFFQON (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 12:14:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759602AbYFFQMY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 12:12:24 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:39480 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758131AbYFFQMV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 12:12:21 -0400
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: linux-mtd@lists.infradead.org, kernel@avr32linux.org
Cc: Andrew Victor <avictor.za@gmail.com>,
       Nicolas Ferre <nicolas.ferre@atmel.com>,
       Patrice VILCHEZ <patrice.vilchez@atmel.com>,
       linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: [PATCH 7/8] atmel_nand: make available on AVR32
Date: Fri,  6 Jun 2008 18:04:57 +0200
Message-Id: <1212768298-13614-8-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1212768298-13614-7-git-send-email-haavard.skinnemoen@atmel.com>
References: <1212768298-13614-1-git-send-email-haavard.skinnemoen@atmel.com>
 <1212768298-13614-2-git-send-email-haavard.skinnemoen@atmel.com>
 <1212768298-13614-3-git-send-email-haavard.skinnemoen@atmel.com>
 <1212768298-13614-4-git-send-email-haavard.skinnemoen@atmel.com>
 <1212768298-13614-5-git-send-email-haavard.skinnemoen@atmel.com>
 <1212768298-13614-6-git-send-email-haavard.skinnemoen@atmel.com>
 <1212768298-13614-7-git-send-email-haavard.skinnemoen@atmel.com>
X-OriginalArrivalTime: 06 Jun 2008 16:04:19.0498 (UTC) FILETIME=[FA4440A0:01C8C7EE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the atmel_nand driver selectable on AVR32, and update the Kconfig
help text to reflect this.

Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
---
 drivers/mtd/nand/Kconfig |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/mtd/nand/Kconfig b/drivers/mtd/nand/Kconfig
index 7bbf386..fcbdf87 100644
--- a/drivers/mtd/nand/Kconfig
+++ b/drivers/mtd/nand/Kconfig
@@ -273,18 +273,18 @@ config MTD_NAND_CS553X
 	  If you say "m", the module will be called "cs553x_nand.ko".
 
 config MTD_NAND_ATMEL
-	bool "Support for NAND Flash / SmartMedia on AT91"
-	depends on ARCH_AT91
+	bool "Support for NAND Flash / SmartMedia on AT91 and AVR32"
+	depends on ARCH_AT91 || AVR32
 	help
 	  Enables support for NAND Flash / Smart Media Card interface
-	  on Atmel AT91 processors.
+	  on Atmel AT91 and AVR32 processors.
 choice
-	prompt "ECC management for NAND Flash / SmartMedia on AT91"
+	prompt "ECC management for NAND Flash / SmartMedia on AT91 / AVR32"
 	depends on MTD_NAND_ATMEL
 
 config MTD_NAND_ATMEL_ECC_HW
 	bool "Hardware ECC"
-	depends on ARCH_AT91SAM9263 || ARCH_AT91SAM9260
+	depends on ARCH_AT91SAM9263 || ARCH_AT91SAM9260 || AVR32
 	help
 	  Use hardware ECC instead of software ECC when the chip
 	  supports it.
-- 
1.5.5.1

