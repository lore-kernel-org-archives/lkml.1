Return-Path: <linux-kernel-owner+w=401wt.eu-S1760945AbXLQTb4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760945AbXLQTb4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 14:31:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757635AbXLQTbW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 14:31:22 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:2931 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757290AbXLQTbV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 14:31:21 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Lennert Buytenhek <kernel@wantstofly.org>,
       Richard Purdie <rpurdie@rpsys.net>
Subject: [PATCH] arch/arm/: Spelling fixes
Date: Mon, 17 Dec 2007 11:30:01 -0800
Message-Id: <1197919875-5288-2-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.3.7.949.g2221a6
Message-Id: <5703e57f925f31fc0eb38873bd7f10fc44f99cb4.1197918889.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/arm/mach-pxa/corgi_ssp.c    |    2 +-
 arch/arm/mach-sa1100/collie_pm.c |    2 +-
 arch/arm/plat-s3c24xx/irq.c      |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-pxa/corgi_ssp.c b/arch/arm/mach-pxa/corgi_ssp.c
index 40dea3d..a6f2105 100644
--- a/arch/arm/mach-pxa/corgi_ssp.c
+++ b/arch/arm/mach-pxa/corgi_ssp.c
@@ -31,7 +31,7 @@ static struct corgissp_machinfo *ssp_machinfo;
 /*
  * There are three devices connected to the SSP interface:
  *   1. A touchscreen controller (TI ADS7846 compatible)
- *   2. An LCD contoller (with some Backlight functionality)
+ *   2. An LCD controller (with some Backlight functionality)
  *   3. A battery monitoring IC (Maxim MAX1111)
  *
  * Each device uses a different speed/mode of communication.
diff --git a/arch/arm/mach-sa1100/collie_pm.c b/arch/arm/mach-sa1100/collie_pm.c
index 1e25b1d..94620be 100644
--- a/arch/arm/mach-sa1100/collie_pm.c
+++ b/arch/arm/mach-sa1100/collie_pm.c
@@ -165,7 +165,7 @@ int collie_read_temp(void)
 
 	ucb1x00_adc_enable(ucb);
 	ucb1x00_io_write(ucb, COLLIE_TC35143_GPIO_TMP_ON, 0);
-	/* >1010 = battery removed, 460 = 22C ?, higer = lower temp ? */
+	/* >1010 = battery removed, 460 = 22C ?, higher = lower temp ? */
 	voltage = ucb1x00_adc_read(ucb, UCB_ADC_INP_AD0, UCB_SYNC);
 	ucb1x00_io_write(ucb, 0, COLLIE_TC35143_GPIO_TMP_ON);
 	ucb1x00_adc_disable(ucb);
diff --git a/arch/arm/plat-s3c24xx/irq.c b/arch/arm/plat-s3c24xx/irq.c
index 8fbc884..194821e 100644
--- a/arch/arm/plat-s3c24xx/irq.c
+++ b/arch/arm/plat-s3c24xx/irq.c
@@ -47,7 +47,7 @@
  *		  Mark IRQ_LCD valid
  *
  *   25-Jul-2005  Ben Dooks
- *		  Split the S3C2440 IRQ code to seperate file
+ *		  Split the S3C2440 IRQ code to separate file
 */
 
 #include <linux/init.h>
-- 
1.5.3.7.949.g2221a6

