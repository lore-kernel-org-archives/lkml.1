Return-Path: <linux-kernel-owner+w=401wt.eu-S1754436AbYFTHs5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754436AbYFTHs5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 03:48:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753777AbYFTHsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 03:48:41 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:47322 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753650AbYFTHsk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 03:48:40 -0400
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Andrew Victor <andrew@sanpeople.com>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: [PATCH 3/3] MTD: atmel_nand can be modular
Date: Fri, 20 Jun 2008 09:48:32 +0200
Message-Id: <1213948112-22348-3-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.5.3
In-Reply-To: <1213948112-22348-2-git-send-email-haavard.skinnemoen@atmel.com>
References: <1213948112-22348-1-git-send-email-haavard.skinnemoen@atmel.com>
 <1213948112-22348-2-git-send-email-haavard.skinnemoen@atmel.com>
X-OriginalArrivalTime: 20 Jun 2008 07:48:03.0644 (UTC) FILETIME=[F841FFC0:01C8D2A9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

There's no reason to prevent the Atmel NAND driver from
building as a module.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
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
1.5.5.3

