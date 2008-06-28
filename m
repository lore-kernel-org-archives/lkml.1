Return-Path: <linux-kernel-owner+w=401wt.eu-S1752391AbYF1MOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752391AbYF1MOc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 08:14:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756000AbYF1MOV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 08:14:21 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:49356 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753562AbYF1MOO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 08:14:14 -0400
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: [PATCH RESEND 3/3] MTD: atmel_nand can be modular
Date: Sat, 28 Jun 2008 14:14:08 +0200
Message-Id: <1214655248-15707-3-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.5.4
In-Reply-To: <1214655248-15707-2-git-send-email-haavard.skinnemoen@atmel.com>
References: <1214655248-15707-1-git-send-email-haavard.skinnemoen@atmel.com>
 <1214655248-15707-2-git-send-email-haavard.skinnemoen@atmel.com>
X-OriginalArrivalTime: 28 Jun 2008 12:13:55.0809 (UTC) FILETIME=[6FCB3510:01C8D918]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

There's no reason to prevent the Atmel NAND driver from
building as a module.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Acked-by: Andrew Victor <linux@maxim.org.za>
---
 drivers/mtd/nand/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/nand/Kconfig b/drivers/mtd/nand/Kconfig
index d8c0d86..71406e5 100644
--- a/drivers/mtd/nand/Kconfig
+++ b/drivers/mtd/nand/Kconfig
@@ -272,7 +272,7 @@ config MTD_NAND_CS553X
 	  If you say "m", the module will be called "cs553x_nand.ko".
 
 config MTD_NAND_ATMEL
-	bool "Support for NAND Flash / SmartMedia on AT91 and AVR32"
+	tristate "Support for NAND Flash / SmartMedia on AT91 and AVR32"
 	depends on ARCH_AT91 || AVR32
 	help
 	  Enables support for NAND Flash / Smart Media Card interface
-- 
1.5.5.4

