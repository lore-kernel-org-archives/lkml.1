Return-Path: <linux-kernel-owner+w=401wt.eu-S1767045AbXDEPSp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767045AbXDEPSp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 11:18:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767051AbXDEPSp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 11:18:45 -0400
Received: from nlpi043.sbcis.sbc.com ([207.115.36.72]:26878 "EHLO
	nlpi043.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767045AbXDEPSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 11:18:44 -0400
X-ORBL: [67.117.73.34]
Date: Thu, 5 Apr 2007 11:17:48 -0400
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 56/90] ARM: OMAP: Make board-palmz71 compile again
Message-ID: <20070405151746.GL24297@atomide.com>
References: <11757100952384-git-send-email-tony@atomide.com> <11757100982726-git-send-email-tony@atomide.com> <11757101012787-git-send-email-tony@atomide.com> <1175710103340-git-send-email-tony@atomide.com> <11757101072553-git-send-email-tony@atomide.com> <11757101101180-git-send-email-tony@atomide.com> <11757101123620-git-send-email-tony@atomide.com> <11757101141643-git-send-email-tony@atomide.com> <11757101164151-git-send-email-tony@atomide.com> <11757101181993-git-send-email-tony@atomide.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="EemXnrF2ob+xzFeB"
Content-Disposition: inline
In-Reply-To: <11757101181993-git-send-email-tony@atomide.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--EemXnrF2ob+xzFeB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

* Tony Lindgren <tony@atomide.com> [070404 14:11]:
> From: Dirk Behme <dirk.behme_at_gmail.com>
> 
> ARM: OMAP: Fix compilation issues in board-palmz71.c
> 
> Signed-off-by: Dirk Behme <dirk.behme_at_gmail.com>
> Signed-off-by: Tony Lindgren <tony@atomide.com>

Fixed email address on this one too.

Tony

--EemXnrF2ob+xzFeB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0056-ARM-OMAP-Make-board-palmz71-compile-again.txt"

>From bf43a7b96d16f581bf5d4a382288c8e83ddabede Mon Sep 17 00:00:00 2001
From: Dirk Behme <dirk.behme@gmail.com>
Date: Thu, 25 Jan 2007 16:30:11 -0800
Subject: [PATCH 56/90] ARM: OMAP: Make board-palmz71 compile again

ARM: OMAP: Fix compilation issues in board-palmz71.c

Signed-off-by: Dirk Behme <dirk.behme@gmail.com>
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


--EemXnrF2ob+xzFeB--
