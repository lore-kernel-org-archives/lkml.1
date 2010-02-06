Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933415Ab0BFRtK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Feb 2010 12:49:10 -0500
Received: from cpsmtpm-eml102.kpnxchange.com ([195.121.3.6]:56146 "EHLO
	CPSMTPM-EML102.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932383Ab0BFRr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Feb 2010 12:47:28 -0500
From: Frans Pop <elendil@planet.nl>
To: linux-kernel@vger.kernel.org
Cc: Frans Pop <elendil@planet.nl>, linux-arm-kernel@lists.infradead.org,
       Russell King <linux@arm.linux.org.uk>
Subject: [PATCH 02/16] arm: remove trailing spaces in messages
Date: Sat,  6 Feb 2010 18:47:09 +0100
Message-Id: <1265478443-31072-2-git-send-email-elendil@planet.nl>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <201002061844.45212.elendil@planet.nl>
References: <201002061844.45212.elendil@planet.nl>
X-OriginalArrivalTime: 06 Feb 2010 17:47:26.0118 (UTC) FILETIME=[71C30C60:01CAA754]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also make 'Displaying register contents' messages consistent in
mach-bcmring/csp/{dmac/dmacHw_extra.c,tmr/tmrHw.c}.

Minor checkpatch fixes for mach-lh7a40x/clcd.c and mach-pxa/pxa27x.c.

Signed-off-by: Frans Pop <elendil@planet.nl>
Cc: linux-arm-kernel@lists.infradead.org
Cc: Russell King <linux@arm.linux.org.uk>
---
 arch/arm/mach-bcmring/csp/dmac/dmacHw_extra.c |    2 +-
 arch/arm/mach-bcmring/csp/tmr/tmrHw.c         |    2 +-
 arch/arm/mach-lh7a40x/clcd.c                  |    8 ++++----
 arch/arm/mach-pxa/pxa27x.c                    |    8 ++++----
 arch/arm/mach-pxa/stargate2.c                 |    2 +-
 arch/arm/mach-sa1100/jornada720_ssp.c         |    2 +-
 6 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/arm/mach-bcmring/csp/dmac/dmacHw_extra.c b/arch/arm/mach-bcmring/csp/dmac/dmacHw_extra.c
index ff7b436..6ef32dc 100644
--- a/arch/arm/mach-bcmring/csp/dmac/dmacHw_extra.c
+++ b/arch/arm/mach-bcmring/csp/dmac/dmacHw_extra.c
@@ -73,7 +73,7 @@ static void DisplayRegisterContents(int module,	/*   [ IN ] DMA Controller unit
     ) {
 	int chan;
 
-	(*fpPrint) ("Displaying register content \n\n");
+	(*fpPrint) ("Displaying register contents\n\n");
 	(*fpPrint) ("Module %d: Interrupt raw transfer              0x%X\n",
 		    module, (uint32_t) (dmacHw_REG_INT_RAW_TRAN(module)));
 	(*fpPrint) ("Module %d: Interrupt raw block                 0x%X\n",
diff --git a/arch/arm/mach-bcmring/csp/tmr/tmrHw.c b/arch/arm/mach-bcmring/csp/tmr/tmrHw.c
index 5c1c9a0..b086285 100644
--- a/arch/arm/mach-bcmring/csp/tmr/tmrHw.c
+++ b/arch/arm/mach-bcmring/csp/tmr/tmrHw.c
@@ -498,7 +498,7 @@ tmrHw_ID_t tmrHw_getInterruptSource(void	/*  void */
 void tmrHw_printDebugInfo(tmrHw_ID_t timerId,	/*  [ IN ] Timer id */
 			  int (*fpPrint) (const char *, ...)	/*  [ IN ] Print callback function */
 ) {
-	(*fpPrint) ("Displaying register contents \n\n");
+	(*fpPrint) ("Displaying register contents\n\n");
 	(*fpPrint) ("Timer %d: Load value              0x%X\n", timerId,
 		    pTmrHw[timerId].LoadValue);
 	(*fpPrint) ("Timer %d: Background load value   0x%X\n", timerId,
diff --git a/arch/arm/mach-lh7a40x/clcd.c b/arch/arm/mach-lh7a40x/clcd.c
index c472b9e..231a24a 100644
--- a/arch/arm/mach-lh7a40x/clcd.c
+++ b/arch/arm/mach-lh7a40x/clcd.c
@@ -147,10 +147,10 @@ static int lh7a40x_clcd_setup (struct clcd_fb *fb)
 	fb->fb.screen_base
 		= dma_alloc_writecombine (&fb->dev->dev, len,
 					  &dma, GFP_KERNEL);
-	printk ("CLCD: LCD setup fb virt 0x%p phys 0x%p l %x io 0x%p \n",
+	printk("CLCD: LCD setup fb virt 0x%p phys 0x%p l %x io 0x%p\n",
 		fb->fb.screen_base, (void*) dma, len,
 		(void*) io_p2v (CLCDC_PHYS));
-	printk ("CLCD: pixclock %d\n", lcd_panel.mode.pixclock);
+	printk("CLCD: pixclock %d\n", lcd_panel.mode.pixclock);
 
 	if (!fb->fb.screen_base) {
 		printk(KERN_ERR "CLCD: unable to map framebuffer\n");
@@ -231,10 +231,10 @@ void __init lh7a40x_clcd_init (void)
 {
 	int i;
 	int result;
-	printk ("CLCD: registering amba devices\n");
+	printk("CLCD: registering amba devices\n");
 	for (i = 0; i < ARRAY_SIZE(amba_devs); i++) {
 		struct amba_device *d = amba_devs[i];
 		result = amba_device_register(d, &iomem_resource);
-		printk ("  %d -> %d\n", i ,result);
+		printk("  %d -> %d\n", i, result);
 	}
 }
diff --git a/arch/arm/mach-pxa/pxa27x.c b/arch/arm/mach-pxa/pxa27x.c
index 6a0b731..039f21f 100644
--- a/arch/arm/mach-pxa/pxa27x.c
+++ b/arch/arm/mach-pxa/pxa27x.c
@@ -73,14 +73,14 @@ unsigned int pxa27x_get_clk_frequency_khz(int info)
 	S  = (b) ? L : (L/2);
 
 	if (info) {
-		printk( KERN_INFO "Run Mode clock: %d.%02dMHz (*%d)\n",
+		printk(KERN_INFO "Run Mode clock: %d.%02dMHz (*%d)\n",
 			L / 1000000, (L % 1000000) / 10000, l );
-		printk( KERN_INFO "Turbo Mode clock: %d.%02dMHz (*%d.%d, %sactive)\n",
+		printk(KERN_INFO "Turbo Mode clock: %d.%02dMHz (*%d.%d, %sactive)\n",
 			N / 1000000, (N % 1000000)/10000, n2 / 2, (n2 % 2)*5,
 			(t) ? "" : "in" );
-		printk( KERN_INFO "Memory clock: %d.%02dMHz (/%d)\n",
+		printk(KERN_INFO "Memory clock: %d.%02dMHz (/%d)\n",
 			M / 1000000, (M % 1000000) / 10000, m );
-		printk( KERN_INFO "System bus clock: %d.%02dMHz \n",
+		printk(KERN_INFO "System bus clock: %d.%02dMHz\n",
 			S / 1000000, (S % 1000000) / 10000 );
 	}
 
diff --git a/arch/arm/mach-pxa/stargate2.c b/arch/arm/mach-pxa/stargate2.c
index a98a434..54a041b 100644
--- a/arch/arm/mach-pxa/stargate2.c
+++ b/arch/arm/mach-pxa/stargate2.c
@@ -167,7 +167,7 @@ static int stargate2_reset_bluetooth(void)
 	int err;
 	err = gpio_request(SG2_BT_RESET, "SG2_BT_RESET");
 	if (err) {
-		printk(KERN_ERR "Could not get gpio for bluetooth reset \n");
+		printk(KERN_ERR "Could not get gpio for bluetooth reset\n");
 		return err;
 	}
 	gpio_direction_output(SG2_BT_RESET, 1);
diff --git a/arch/arm/mach-sa1100/jornada720_ssp.c b/arch/arm/mach-sa1100/jornada720_ssp.c
index 506a5e5..3bf34ac 100644
--- a/arch/arm/mach-sa1100/jornada720_ssp.c
+++ b/arch/arm/mach-sa1100/jornada720_ssp.c
@@ -144,7 +144,7 @@ static int __init jornada_ssp_probe(struct platform_device *dev)
 		return ret;
 	}
 
-	printk(KERN_WARNING "SSP: initialization failed, trying non-irq solution \n");
+	printk(KERN_WARNING "SSP: initialization failed, trying non-irq solution\n");
 
 	/* init of Serial 4 port */
 	Ser4MCCR0 = 0;
-- 
1.6.6.1

