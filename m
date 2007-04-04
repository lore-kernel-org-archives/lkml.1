Return-Path: <linux-kernel-owner+w=401wt.eu-S934075AbXDDSMD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934075AbXDDSMD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 14:12:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934078AbXDDSLf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 14:11:35 -0400
Received: from nlpi001.sbcis.sbc.com ([207.115.36.30]:38531 "EHLO
	nlpi001.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932167AbXDDSLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 14:11:31 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: Tony Lindgren <tony@atomide.com>
Subject: [PATCH 56/90] ARM: OMAP: Make board-palmz71 compile again
Date: Wed,  4 Apr 2007 14:05:35 -0400
Message-Id: <11757101181993-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11757101164151-git-send-email-tony@atomide.com>
References: 11757088953851-git-send-email-tony@atomide.com <11757099691323-git-send-email-tony@atomide.com> <11757099743984-git-send-email-tony@atomide.com> <1175709977545-git-send-email-tony@atomide.com> <1175709988265-git-send-email-tony@atomide.com> <11757099942493-git-send-email-tony@atomide.com> <11757100011056-git-send-email-tony@atomide.com> <1175710003925-git-send-email-tony@atomide.com> <11757100063945-git-send-email-tony@atomide.com> <11757100092910-git-send-email-tony@atomide.com> <11757100112473-git-send-email-tony@atomide.com> <11757100143517-git-send-email-tony@atomide.com> <11757100163760-git-send-email-tony@atomide.com> <11757100181189-git-send-email-tony@atomide.com> <11757100214151-git-send-email-tony@atomide.com> <11757100242980-git-send-email-tony@atomide.com> <1175710026446-git-send-email-tony@atomide.com> <11757100281957-git-send-email-tony@atomide.com> <11757100302964-git-send-email-tony@atomide.com> <1175710033286-git-send-email-tony@atomide.com> <117!
 57100403021-git-send-email-tony@atomide.com> <11757100423982-git-send-email-tony@atomide.com> <117571004562-git-send-email-tony@atomide.com> <11757100491583-git-send-email-tony@atomide.com> <11757100511172-git-send-email-tony@atomide.com> <1175710059333-git-send-email-tony@atomide.com> <11757100623383-git-send-email-tony@atomide.com> <11757100641006-git-send-email-tony@atomide.com> <11757100661228-git-send-email-tony@atomide.com> <11757100691131-git-send-email-tony@atomide.com> <11757100713004-git-send-email-tony@atomide.com> <11757100752021-git-send-email-tony@atomide.com> <11757100781275-git-send-email-tony@atomide.com> <11757100811771-git-send-email-tony@atomide.com> <11757100821353-git-send-email-tony@atomide.com> <11757100853841-git-send-email-tony@atomide.com> <1175710087578-git-send-email-tony@atomide.com> <11757100911247-git-send-email-tony@atomide.com> <1175710093864-git-send-email-tony@atomide.com> <11757100952384-git-send-email-tony@atomide.com> <11757100982726-g!
 it-send-email-tony@atomide.com> <11757101012787-git-send-email-tony@atomide.com> <1175710103340-git-send-email-tony@atomide.com> <11757101072553-git-send-email-tony@atomide.com> <11757101101180-git-send-email-tony@atomide.com> <11757101123620-git-send-email-tony@atomide.com> <11757101141643-git-send-email-tony@atomide.com> <
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Behme <dirk.behme_at_gmail.com>

ARM: OMAP: Fix compilation issues in board-palmz71.c

Signed-off-by: Dirk Behme <dirk.behme_at_gmail.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap1/board-palmz71.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-omap1/board-palmz71.c b/arch/arm/mach-omap1/board-palmz71.c
index b1ef1be..6a53f12 100644
--- a/arch/arm/mach-omap1/board-palmz71.c
+++ b/arch/arm/mach-omap1/board-palmz71.c
@@ -260,7 +260,6 @@ static struct spi_board_info __initdata palmz71_boardinfo[] = { {
 				* 26	/* command + data + overhead */,
 	.bus_num	= 2,
 	.chip_select	= 0,
-	}
 } };
 
 static struct omap_usb_config palmz71_usb_config __initdata = {
@@ -295,7 +294,7 @@ static struct omap_board_config_kernel palmz71_config[] = {
 };
 
 static irqreturn_t
-palmz71_powercable(int irq, void *dev_id, struct pt_regs *regs)
+palmz71_powercable(int irq, void *dev_id)
 {
 	if (omap_get_gpio_datain(PALMZ71_USBDETECT_GPIO)) {
 		printk(KERN_INFO "PM: Power cable connected\n");
@@ -347,7 +346,7 @@ palmz71_gpio_setup(int early)
 				"palmz71-cable", 0))
 			printk(KERN_ERR
 			       "IRQ request for power cable failed!\n");
-		palmz71_powercable(OMAP_GPIO_IRQ(PALMZ71_USBDETECT_GPIO), 0, 0);
+		palmz71_powercable(OMAP_GPIO_IRQ(PALMZ71_USBDETECT_GPIO), 0);
 	}
 }
 
-- 
1.4.4.2

