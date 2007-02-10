Return-Path: <linux-kernel-owner+w=401wt.eu-S1752591AbXBJB2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591AbXBJB2n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 20:28:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752612AbXBJB2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 20:28:43 -0500
Received: from ensim03.bon.m2soft.com ([195.38.20.12]:50830 "EHLO
	ensim03.ffm.m2soft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591AbXBJB2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 20:28:42 -0500
X-Greylist: delayed 525 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Feb 2007 20:28:42 EST
X-ClientAddr: 85.127.190.78
Date: Sat, 10 Feb 2007 02:14:31 +0100
From: Nicolas Kaiser <nikai@nikai.net>
To: linux-kernel@vger.kernel.org
Cc: Ben Dooks <ben-linux@fluff.org>, trivial@kernel.org
Subject: arch/arm: typos in KERN_ERR, KERN_INFO
Message-ID: <20070210021431.21722175@lucky.kitzblitz>
Organization: -
X-Face: "fF&[w2"Nws:JNH4'g|:gVhgGKLhj|X}}&w&V?]0=,7n`jy8D6e[Jh=7+ca|4~t5e[ItpL5
 N'y~Mvi-vJm`"1T5fi1^b!&EG]6nW~C!FN},=$G?^U2t~n[3;u\"5-|~H{-5]IQ2
X-Mailer: Claws-mail (Linux)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-M2Soft-MailScanner-Information: Please contact the ISP for more information
X-M2Soft-MailScanner: Not scanned: please contact your Internet E-Mail Service Provider for details
X-MailScanner-From: nikai@nikai.net
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Typos in KERN_ERR, KERN_INFO.

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---

 arch/arm/mach-imx/dma.c           |    2 +-
 arch/arm/mach-s3c2410/pm-simtec.c |    2 +-
 arch/arm/plat-omap/dma.c          |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff -ur a/arch/arm/mach-imx/dma.c b/arch/arm/mach-imx/dma.c
--- a/arch/arm/mach-imx/dma.c	2006-11-29 22:57:37.000000000 +0100
+++ b/arch/arm/mach-imx/dma.c	2007-02-09 23:42:15.000000000 +0100
@@ -234,7 +234,7 @@
 	imxdma->resbytes = dma_length;
 
 	if (!sg || !sgcount) {
-		printk(KERN_ERR "imxdma%d: imx_dma_setup_sg epty sg list\n",
+		printk(KERN_ERR "imxdma%d: imx_dma_setup_sg empty sg list\n",
 		       dma_ch);
 		return -EINVAL;
 	}
diff -ur a/arch/arm/mach-s3c2410/pm-simtec.c b/arch/arm/mach-s3c2410/pm-simtec.c
--- a/arch/arm/mach-s3c2410/pm-simtec.c	2007-01-21 15:40:56.000000000 +0100
+++ b/arch/arm/mach-s3c2410/pm-simtec.c	2007-02-09 23:40:46.000000000 +0100
@@ -52,7 +52,7 @@
 	    !machine_is_aml_m5900())
 		return 0;
 
-	printk(KERN_INFO "Simtec Board Power Manangement" COPYRIGHT "\n");
+	printk(KERN_INFO "Simtec Board Power Management" COPYRIGHT "\n");
 
 	gstatus4  = (__raw_readl(S3C2410_BANKCON7) & 0x3) << 30;
 	gstatus4 |= (__raw_readl(S3C2410_BANKCON6) & 0x3) << 28;
diff -ur a/arch/arm/plat-omap/dma.c b/arch/arm/plat-omap/dma.c
--- a/arch/arm/plat-omap/dma.c	2006-11-29 22:57:37.000000000 +0100
+++ b/arch/arm/plat-omap/dma.c	2007-02-09 23:39:56.000000000 +0100
@@ -1053,7 +1053,7 @@
 void omap_set_lcd_dma_b1_vxres(unsigned long vxres)
 {
 	if (omap_dma_in_1510_mode()) {
-		printk(KERN_ERR "DMA virtual resulotion is not supported "
+		printk(KERN_ERR "DMA virtual resolution is not supported "
 				"in 1510 mode\n");
 		BUG();
 	}
