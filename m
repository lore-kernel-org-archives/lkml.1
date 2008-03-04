Return-Path: <linux-kernel-owner+w=401wt.eu-S1761904AbYCDDOk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761904AbYCDDOk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 22:14:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759002AbYCDDK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 22:10:29 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:11850 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757860AbYCDDKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 22:10:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=p/vYi++NRSu26dotdZUoDg0y/o+HFBEvBJ9bwWK+U4RuUr73fhbGWw6tlaNQceL65KGC3qHJJU+Ae3FoH6HScAkRWyT25Uzg+UGzl/8SSxnbOJ/APbrAKQ57EYqAybsTc7fKSy/gVLBpJvFPqFQm5AihgVKcZRLUcV13HaSbOKc=
Subject: [PATCH 12/14] video: replace remaining __FUNCTION__ occurrences
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: "v4l-dvb-maintainer@linuxtv.org" <v4l-dvb-maintainer@linuxtv.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <ff8fd021606e7a6f03e9c274230cfcf64eade6d2.1204599636.git.harvey.harrison@gmail.com>
References: <ff8fd021606e7a6f03e9c274230cfcf64eade6d2.1204599636.git.harvey.harrison@gmail.com>
Content-Type: text/plain
Date: Mon, 03 Mar 2008 19:09:52 -0800
Message-Id: <1204600192.22933.92.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/video/amifb.c                   |    2 +-
 drivers/video/aty/aty128fb.c            |    2 +-
 drivers/video/aty/mach64_ct.c           |   16 ++++++------
 drivers/video/bf54x-lq043fb.c           |    6 ++--
 drivers/video/cfbimgblt.c               |    2 +-
 drivers/video/cirrusfb.c                |    4 +-
 drivers/video/console/fbcon.c           |    2 +-
 drivers/video/imsttfb.c                 |    2 +-
 drivers/video/imxfb.c                   |    6 ++--
 drivers/video/matrox/matroxfb_DAC1064.c |   36 +++++++++++++-------------
 drivers/video/matrox/matroxfb_Ti3026.c  |   16 ++++++------
 drivers/video/matrox/matroxfb_accel.c   |   14 +++++-----
 drivers/video/matrox/matroxfb_base.c    |   42 +++++++++++++++---------------
 drivers/video/matrox/matroxfb_crtc2.c   |    2 +-
 drivers/video/matrox/matroxfb_maven.c   |    2 +-
 drivers/video/matrox/matroxfb_misc.c    |   12 ++++----
 drivers/video/modedb.c                  |    2 +-
 drivers/video/nvidia/nvidia.c           |    6 ++--
 drivers/video/pm2fb.c                   |    2 +-
 drivers/video/pm3fb.c                   |    2 +-
 drivers/video/pxafb.c                   |    2 +-
 drivers/video/riva/fbdev.c              |    6 ++--
 drivers/video/s3c2410fb.c               |    6 ++--
 drivers/video/sa1100fb.h                |    2 +-
 drivers/video/sis/sis.h                 |    2 +-
 drivers/video/sstfb.c                   |   10 +++---
 drivers/video/stifb.c                   |    4 +-
 drivers/video/sysimgblt.c               |    2 +-
 drivers/video/tdfxfb.c                  |    2 +-
 29 files changed, 107 insertions(+), 107 deletions(-)

diff --git a/drivers/video/amifb.c b/drivers/video/amifb.c
index 4c9ec3f..e6492c1 100644
--- a/drivers/video/amifb.c
+++ b/drivers/video/amifb.c
@@ -96,7 +96,7 @@
 #endif
 
 #ifdef DEBUG
-#  define DPRINTK(fmt, args...)	printk(KERN_DEBUG "%s: " fmt, __FUNCTION__ , ## args)
+#  define DPRINTK(fmt, args...)	printk(KERN_DEBUG "%s: " fmt, __func__ , ## args)
 #else
 #  define DPRINTK(fmt, args...)
 #endif
diff --git a/drivers/video/aty/aty128fb.c b/drivers/video/aty/aty128fb.c
index cbd3308..d47859f 100644
--- a/drivers/video/aty/aty128fb.c
+++ b/drivers/video/aty/aty128fb.c
@@ -91,7 +91,7 @@
 #undef DEBUG
 
 #ifdef DEBUG
-#define DBG(fmt, args...)		printk(KERN_DEBUG "aty128fb: %s " fmt, __FUNCTION__, ##args);
+#define DBG(fmt, args...)		printk(KERN_DEBUG "aty128fb: %s " fmt, __func__, ##args);
 #else
 #define DBG(fmt, args...)
 #endif
diff --git a/drivers/video/aty/mach64_ct.c b/drivers/video/aty/mach64_ct.c
index cc9e977..c50c7cf 100644
--- a/drivers/video/aty/mach64_ct.c
+++ b/drivers/video/aty/mach64_ct.c
@@ -197,7 +197,7 @@ static int aty_dsp_gt(const struct fb_info *info, u32 bpp, struct pll_ct *pll)
 	pll->dsp_config = (dsp_precision << 20) | (pll->dsp_loop_latency << 16) | dsp_xclks;
 #ifdef DEBUG
 	printk("atyfb(%s): dsp_config 0x%08x, dsp_on_off 0x%08x\n",
-		__FUNCTION__, pll->dsp_config, pll->dsp_on_off);
+		__func__, pll->dsp_config, pll->dsp_on_off);
 #endif
 	return 0;
 }
@@ -225,7 +225,7 @@ static int aty_valid_pll_ct(const struct fb_info *info, u32 vclk_per, struct pll
 		(par->ref_clk_per * pll->pll_ref_div);
 #ifdef DEBUG
 	printk("atyfb(%s): pllvclk=%d MHz, vclk=%d MHz\n",
-		__FUNCTION__, pllvclk, pllvclk / pll->vclk_post_div_real);
+		__func__, pllvclk, pllvclk / pll->vclk_post_div_real);
 #endif
 	pll->pll_vclk_cntl = 0x03; /* VCLK = PLL_VCLK/VCLKx_POST */
 
@@ -269,7 +269,7 @@ static u32 aty_pll_to_var_ct(const struct fb_info *info, const union aty_pll *pl
 	}
 #endif
 #ifdef DEBUG
-	printk("atyfb(%s): calculated 0x%08X(%i)\n", __FUNCTION__, ret, ret);
+	printk("atyfb(%s): calculated 0x%08X(%i)\n", __func__, ret, ret);
 #endif
 	return ret;
 }
@@ -284,11 +284,11 @@ void aty_set_pll_ct(const struct fb_info *info, const union aty_pll *pll)
 #ifdef DEBUG
 	printk("atyfb(%s): about to program:\n"
 		"pll_ext_cntl=0x%02x pll_gen_cntl=0x%02x pll_vclk_cntl=0x%02x\n",
-		__FUNCTION__,
+		__func__,
 		pll->ct.pll_ext_cntl, pll->ct.pll_gen_cntl, pll->ct.pll_vclk_cntl);
 
 	printk("atyfb(%s): setting clock %lu for FeedBackDivider %i, ReferenceDivider %i, PostDivider %i(%i)\n",
-		__FUNCTION__,
+		__func__,
 		par->clk_wr_offset, pll->ct.vclk_fb_div,
 		pll->ct.pll_ref_div, pll->ct.vclk_post_div, pll->ct.vclk_post_div_real);
 #endif
@@ -428,7 +428,7 @@ static int __devinit aty_init_pll_ct(const struct fb_info *info,
 
 #ifdef DEBUG
 	printk("atyfb(%s): mclk_fb_mult=%d, xclk_post_div=%d\n",
-		__FUNCTION__, pll->ct.mclk_fb_mult, pll->ct.xclk_post_div);
+		__func__, pll->ct.mclk_fb_mult, pll->ct.xclk_post_div);
 #endif
 
 	memcntl = aty_ld_le32(MEM_CNTL, par);
@@ -540,7 +540,7 @@ static int __devinit aty_init_pll_ct(const struct fb_info *info,
 	pllmclk = (1000000 * pll->ct.mclk_fb_mult * pll->ct.mclk_fb_div) /
 			(par->ref_clk_per * pll->ct.pll_ref_div);
 	printk("atyfb(%s): pllmclk=%d MHz, xclk=%d MHz\n",
-		__FUNCTION__, pllmclk, pllmclk / pll->ct.xclk_post_div_real);
+		__func__, pllmclk, pllmclk / pll->ct.xclk_post_div_real);
 #endif
 
 	if (M64_HAS(SDRAM_MAGIC_PLL) && (par->ram_type >= SDRAM))
@@ -581,7 +581,7 @@ static int __devinit aty_init_pll_ct(const struct fb_info *info,
 		pllsclk = (1000000 * 2 * pll->ct.sclk_fb_div) /
 			(par->ref_clk_per * pll->ct.pll_ref_div);
 		printk("atyfb(%s): use sclk, pllsclk=%d MHz, sclk=mclk=%d MHz\n",
-			__FUNCTION__, pllsclk, pllsclk / sclk_post_div_real);
+			__func__, pllsclk, pllsclk / sclk_post_div_real);
 #endif
 	}
 
diff --git a/drivers/video/bf54x-lq043fb.c b/drivers/video/bf54x-lq043fb.c
index 0ce791e..07810ed 100644
--- a/drivers/video/bf54x-lq043fb.c
+++ b/drivers/video/bf54x-lq043fb.c
@@ -336,7 +336,7 @@ static int bfin_bf54x_fb_check_var(struct fb_var_screeninfo *var,
 {
 
 	if (var->bits_per_pixel != LCD_BPP) {
-		pr_debug("%s: depth not supported: %u BPP\n", __FUNCTION__,
+		pr_debug("%s: depth not supported: %u BPP\n", __func__,
 			 var->bits_per_pixel);
 		return -EINVAL;
 	}
@@ -345,7 +345,7 @@ static int bfin_bf54x_fb_check_var(struct fb_var_screeninfo *var,
 	    info->var.xres_virtual != var->xres_virtual ||
 	    info->var.yres_virtual != var->yres_virtual) {
 		pr_debug("%s: Resolution not supported: X%u x Y%u \n",
-			 __FUNCTION__, var->xres, var->yres);
+			 __func__, var->xres, var->yres);
 		return -EINVAL;
 	}
 
@@ -355,7 +355,7 @@ static int bfin_bf54x_fb_check_var(struct fb_var_screeninfo *var,
 
 	if ((info->fix.line_length * var->yres_virtual) > info->fix.smem_len) {
 		pr_debug("%s: Memory Limit requested yres_virtual = %u\n",
-			 __FUNCTION__, var->yres_virtual);
+			 __func__, var->yres_virtual);
 		return -ENOMEM;
 	}
 
diff --git a/drivers/video/cfbimgblt.c b/drivers/video/cfbimgblt.c
index f598907..b457d3d 100644
--- a/drivers/video/cfbimgblt.c
+++ b/drivers/video/cfbimgblt.c
@@ -38,7 +38,7 @@
 #define DEBUG
 
 #ifdef DEBUG
-#define DPRINTK(fmt, args...) printk(KERN_DEBUG "%s: " fmt,__FUNCTION__,## args)
+#define DPRINTK(fmt, args...) printk(KERN_DEBUG "%s: " fmt,__func__,## args)
 #else
 #define DPRINTK(fmt, args...)
 #endif
diff --git a/drivers/video/cirrusfb.c b/drivers/video/cirrusfb.c
index f7e2d5a..7ed8bca 100644
--- a/drivers/video/cirrusfb.c
+++ b/drivers/video/cirrusfb.c
@@ -81,7 +81,7 @@
 /* debug output */
 #ifdef CIRRUSFB_DEBUG
 #define DPRINTK(fmt, args...) \
-	printk(KERN_DEBUG "%s: " fmt, __FUNCTION__ , ## args)
+	printk(KERN_DEBUG "%s: " fmt, __func__ , ## args)
 #else
 #define DPRINTK(fmt, args...)
 #endif
@@ -91,7 +91,7 @@
 #define assert(expr) \
 	if (!(expr)) { \
 		printk("Assertion failed! %s,%s,%s,line=%d\n", \
-		#expr, __FILE__, __FUNCTION__, __LINE__); \
+		#expr, __FILE__, __func__, __LINE__); \
 	}
 #else
 #define assert(expr)
diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
index 0222824..29c1358 100644
--- a/drivers/video/console/fbcon.c
+++ b/drivers/video/console/fbcon.c
@@ -92,7 +92,7 @@
 #include "fbcon.h"
 
 #ifdef FBCONDEBUG
-#  define DPRINTK(fmt, args...) printk(KERN_DEBUG "%s: " fmt, __FUNCTION__ , ## args)
+#  define DPRINTK(fmt, args...) printk(KERN_DEBUG "%s: " fmt, __func__ , ## args)
 #else
 #  define DPRINTK(fmt, args...)
 #endif
diff --git a/drivers/video/imsttfb.c b/drivers/video/imsttfb.c
index 3ab91bf..a9a9eab 100644
--- a/drivers/video/imsttfb.c
+++ b/drivers/video/imsttfb.c
@@ -1476,7 +1476,7 @@ imsttfb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	
 	dp = pci_device_to_OF_node(pdev);
 	if(dp)
-		printk(KERN_INFO "%s: OF name %s\n",__FUNCTION__, dp->name);
+		printk(KERN_INFO "%s: OF name %s\n",__func__, dp->name);
 	else
 		printk(KERN_ERR "imsttfb: no OF node for pci device\n");
 #endif /* CONFIG_PPC_OF */
diff --git a/drivers/video/imxfb.c b/drivers/video/imxfb.c
index 1160955..94e4d3a 100644
--- a/drivers/video/imxfb.c
+++ b/drivers/video/imxfb.c
@@ -415,7 +415,7 @@ static void imxfb_setup_gpio(struct imxfb_info *fbi)
 static int imxfb_suspend(struct platform_device *dev, pm_message_t state)
 {
 	struct imxfb_info *fbi = platform_get_drvdata(dev);
-	pr_debug("%s\n",__FUNCTION__);
+	pr_debug("%s\n",__func__);
 
 	imxfb_disable_controller(fbi);
 	return 0;
@@ -424,7 +424,7 @@ static int imxfb_suspend(struct platform_device *dev, pm_message_t state)
 static int imxfb_resume(struct platform_device *dev)
 {
 	struct imxfb_info *fbi = platform_get_drvdata(dev);
-	pr_debug("%s\n",__FUNCTION__);
+	pr_debug("%s\n",__func__);
 
 	imxfb_enable_controller(fbi);
 	return 0;
@@ -440,7 +440,7 @@ static int __init imxfb_init_fbinfo(struct device *dev)
 	struct fb_info *info = dev_get_drvdata(dev);
 	struct imxfb_info *fbi = info->par;
 
-	pr_debug("%s\n",__FUNCTION__);
+	pr_debug("%s\n",__func__);
 
 	info->pseudo_palette = kmalloc( sizeof(u32) * 16, GFP_KERNEL);
 	if (!info->pseudo_palette)
diff --git a/drivers/video/matrox/matroxfb_DAC1064.c b/drivers/video/matrox/matroxfb_DAC1064.c
index c4b570b..0ce3b0a 100644
--- a/drivers/video/matrox/matroxfb_DAC1064.c
+++ b/drivers/video/matrox/matroxfb_DAC1064.c
@@ -37,7 +37,7 @@ static void DAC1064_calcclock(CPMINFO unsigned int freq, unsigned int fmax, unsi
 	unsigned int fvco;
 	unsigned int p;
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 	
 	/* only for devices older than G450 */
 
@@ -83,7 +83,7 @@ static const unsigned char MGA1064_DAC[] = {
 static void DAC1064_setpclk(WPMINFO unsigned long fout) {
 	unsigned int m, n, p;
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	DAC1064_calcclock(PMINFO fout, ACCESS_FBINFO(max_pixel_clock), &m, &n, &p);
 	ACCESS_FBINFO(hw).DACclk[0] = m;
@@ -95,7 +95,7 @@ static void DAC1064_setmclk(WPMINFO int oscinfo, unsigned long fmem) {
 	u_int32_t mx;
 	struct matrox_hw_state* hw = &ACCESS_FBINFO(hw);
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	if (ACCESS_FBINFO(devflags.noinit)) {
 		/* read MCLK and give up... */
@@ -338,7 +338,7 @@ void DAC1064_global_restore(WPMINFO2) {
 static int DAC1064_init_1(WPMINFO struct my_timming* m) {
 	struct matrox_hw_state* hw = &ACCESS_FBINFO(hw);
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	memcpy(hw->DACreg, MGA1064_DAC, sizeof(MGA1064_DAC_regs));
 	switch (ACCESS_FBINFO(fbcon).var.bits_per_pixel) {
@@ -374,7 +374,7 @@ static int DAC1064_init_1(WPMINFO struct my_timming* m) {
 static int DAC1064_init_2(WPMINFO struct my_timming* m) {
 	struct matrox_hw_state* hw = &ACCESS_FBINFO(hw);
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	if (ACCESS_FBINFO(fbcon).var.bits_per_pixel > 16) {	/* 256 entries */
 		int i;
@@ -418,7 +418,7 @@ static void DAC1064_restore_1(WPMINFO2) {
 
 	CRITFLAGS
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	CRITBEGIN
 
@@ -448,7 +448,7 @@ static void DAC1064_restore_2(WPMINFO2) {
 	unsigned int i;
 #endif
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 #ifdef DEBUG
 	dprintk(KERN_DEBUG "DAC1064regs ");
@@ -521,7 +521,7 @@ static struct matrox_altout g450out = {
 static int MGA1064_init(WPMINFO struct my_timming* m) {
 	struct matrox_hw_state* hw = &ACCESS_FBINFO(hw);
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	if (DAC1064_init_1(PMINFO m)) return 1;
 	if (matroxfb_vgaHWinit(PMINFO m)) return 1;
@@ -543,7 +543,7 @@ static int MGA1064_init(WPMINFO struct my_timming* m) {
 static int MGAG100_init(WPMINFO struct my_timming* m) {
 	struct matrox_hw_state* hw = &ACCESS_FBINFO(hw);
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	if (DAC1064_init_1(PMINFO m)) return 1;
 	hw->MXoptionReg &= ~0x2000;
@@ -565,7 +565,7 @@ static int MGAG100_init(WPMINFO struct my_timming* m) {
 #ifdef CONFIG_FB_MATROX_MYSTIQUE
 static void MGA1064_ramdac_init(WPMINFO2) {
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	/* ACCESS_FBINFO(features.DAC1064.vco_freq_min) = 120000; */
 	ACCESS_FBINFO(features.pll.vco_freq_min) = 62000;
@@ -594,7 +594,7 @@ static void MGAG100_progPixClock(CPMINFO int flags, int m, int n, int p) {
 	int selClk;
 	int clk;
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	outDAC1064(PMINFO M1064_XPIXCLKCTRL, inDAC1064(PMINFO M1064_XPIXCLKCTRL) | M1064_XPIXCLKCTRL_DIS |
 		   M1064_XPIXCLKCTRL_PLL_UP);
@@ -636,7 +636,7 @@ static void MGAG100_progPixClock(CPMINFO int flags, int m, int n, int p) {
 static void MGAG100_setPixClock(CPMINFO int flags, int freq) {
 	unsigned int m, n, p;
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	DAC1064_calcclock(PMINFO freq, ACCESS_FBINFO(max_pixel_clock), &m, &n, &p);
 	MGAG100_progPixClock(PMINFO flags, m, n, p);
@@ -650,7 +650,7 @@ static int MGA1064_preinit(WPMINFO2) {
 					     2048,    0};
 	struct matrox_hw_state* hw = &ACCESS_FBINFO(hw);
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	/* ACCESS_FBINFO(capable.cfb4) = 0; ... preinitialized by 0 */
 	ACCESS_FBINFO(capable.text) = 1;
@@ -683,7 +683,7 @@ static int MGA1064_preinit(WPMINFO2) {
 
 static void MGA1064_reset(WPMINFO2) {
 
-	DBG(__FUNCTION__);
+	DBG(__func__);
 
 	MGA1064_ramdac_init(PMINFO2);
 }
@@ -819,7 +819,7 @@ static int MGAG100_preinit(WPMINFO2) {
 	u_int32_t q;
 #endif
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	/* there are some instabilities if in_div > 19 && vco < 61000 */
 	if (ACCESS_FBINFO(devflags.g450dac)) {
@@ -956,7 +956,7 @@ static void MGAG100_reset(WPMINFO2) {
 	u_int8_t b;
 	struct matrox_hw_state* hw = &ACCESS_FBINFO(hw);
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	{
 #ifdef G100_BROKEN_IBM_82351
@@ -1015,7 +1015,7 @@ static void MGA1064_restore(WPMINFO2) {
 
 	CRITFLAGS
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	CRITBEGIN
 
@@ -1041,7 +1041,7 @@ static void MGAG100_restore(WPMINFO2) {
 
 	CRITFLAGS
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	CRITBEGIN
 
diff --git a/drivers/video/matrox/matroxfb_Ti3026.c b/drivers/video/matrox/matroxfb_Ti3026.c
index 9445cdb..1352482 100644
--- a/drivers/video/matrox/matroxfb_Ti3026.c
+++ b/drivers/video/matrox/matroxfb_Ti3026.c
@@ -283,7 +283,7 @@ static int Ti3026_calcclock(CPMINFO unsigned int freq, unsigned int fmax, int* i
 	unsigned int fvco;
 	unsigned int lin, lfeed, lpost;
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	fvco = PLL_calcclock(PMINFO freq, fmax, &lin, &lfeed, &lpost);
 	fvco >>= (*post = lpost);
@@ -297,7 +297,7 @@ static int Ti3026_setpclk(WPMINFO int clk) {
 	unsigned int pixfeed, pixin, pixpost;
 	struct matrox_hw_state* hw = &ACCESS_FBINFO(hw);
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	f_pll = Ti3026_calcclock(PMINFO clk, ACCESS_FBINFO(max_pixel_clock), &pixin, &pixfeed, &pixpost);
 
@@ -365,7 +365,7 @@ static int Ti3026_init(WPMINFO struct my_timming* m) {
 	u_int8_t muxctrl = isInterleave(MINFO) ? TVP3026_XMUXCTRL_MEMORY_64BIT : TVP3026_XMUXCTRL_MEMORY_32BIT;
 	struct matrox_hw_state* hw = &ACCESS_FBINFO(hw);
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	memcpy(hw->DACreg, MGADACbpp32, sizeof(hw->DACreg));
 	switch (ACCESS_FBINFO(fbcon).var.bits_per_pixel) {
@@ -440,7 +440,7 @@ static void ti3026_setMCLK(WPMINFO int fout){
 	unsigned int rfhcnt, mclk_ctl;
 	int tmout;
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	f_pll = Ti3026_calcclock(PMINFO fout, ACCESS_FBINFO(max_pixel_clock), &mclk_n, &mclk_m, &mclk_p);
 
@@ -534,7 +534,7 @@ static void ti3026_setMCLK(WPMINFO int fout){
 
 static void ti3026_ramdac_init(WPMINFO2) {
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	ACCESS_FBINFO(features.pll.vco_freq_min) = 110000;
 	ACCESS_FBINFO(features.pll.ref_freq)	 = 114545;
@@ -554,7 +554,7 @@ static void Ti3026_restore(WPMINFO2) {
 	struct matrox_hw_state* hw = &ACCESS_FBINFO(hw);
 	CRITFLAGS
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 #ifdef DEBUG
 	dprintk(KERN_INFO "EXTVGA regs: ");
@@ -662,7 +662,7 @@ static void Ti3026_restore(WPMINFO2) {
 
 static void Ti3026_reset(WPMINFO2) {
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	ti3026_ramdac_init(PMINFO2);
 }
@@ -680,7 +680,7 @@ static int Ti3026_preinit(WPMINFO2) {
 					  2048, 0};
 	struct matrox_hw_state* hw = &ACCESS_FBINFO(hw);
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	ACCESS_FBINFO(millenium) = 1;
 	ACCESS_FBINFO(milleniumII) = (ACCESS_FBINFO(pcidev)->device != PCI_DEVICE_ID_MATROX_MIL);
diff --git a/drivers/video/matrox/matroxfb_accel.c b/drivers/video/matrox/matroxfb_accel.c
index 3660d26..9c3aeee 100644
--- a/drivers/video/matrox/matroxfb_accel.c
+++ b/drivers/video/matrox/matroxfb_accel.c
@@ -113,7 +113,7 @@ void matrox_cfbX_init(WPMINFO2) {
 	u_int32_t mopmode;
 	int accel;
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	mpitch = ACCESS_FBINFO(fbcon).var.xres_virtual;
 
@@ -199,7 +199,7 @@ static void matrox_accel_bmove(WPMINFO int vxres, int sy, int sx, int dy, int dx
 	int start, end;
 	CRITFLAGS
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	CRITBEGIN
 
@@ -235,7 +235,7 @@ static void matrox_accel_bmove_lin(WPMINFO int vxres, int sy, int sx, int dy, in
 	int start, end;
 	CRITFLAGS
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	CRITBEGIN
 
@@ -287,7 +287,7 @@ static void matroxfb_accel_clear(WPMINFO u_int32_t color, int sy, int sx, int he
 		int width) {
 	CRITFLAGS
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	CRITBEGIN
 
@@ -315,7 +315,7 @@ static void matroxfb_cfb4_clear(WPMINFO u_int32_t bgx, int sy, int sx, int heigh
 	int whattodo;
 	CRITFLAGS
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	CRITBEGIN
 
@@ -388,7 +388,7 @@ static void matroxfb_1bpp_imageblit(WPMINFO u_int32_t fgx, u_int32_t bgx,
 	int easy;
 	CRITFLAGS
 
-	DBG_HEAVY(__FUNCTION__);
+	DBG_HEAVY(__func__);
 
 	step = (width + 7) >> 3;
 	charcell = height * step;
@@ -469,7 +469,7 @@ static void matroxfb_1bpp_imageblit(WPMINFO u_int32_t fgx, u_int32_t bgx,
 static void matroxfb_imageblit(struct fb_info* info, const struct fb_image* image) {
 	MINFO_FROM_INFO(info);
 
-	DBG_HEAVY(__FUNCTION__);
+	DBG_HEAVY(__func__);
 
 	if (image->depth == 1) {
 		u_int32_t fgx, bgx;
diff --git a/drivers/video/matrox/matroxfb_base.c b/drivers/video/matrox/matroxfb_base.c
index b25972a..54e82f3 100644
--- a/drivers/video/matrox/matroxfb_base.c
+++ b/drivers/video/matrox/matroxfb_base.c
@@ -312,7 +312,7 @@ static void matrox_pan_var(WPMINFO struct fb_var_screeninfo *var) {
 
 	CRITFLAGS
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	if (ACCESS_FBINFO(dead))
 		return;
@@ -392,7 +392,7 @@ static int matroxfb_open(struct fb_info *info, int user)
 {
 	MINFO_FROM_INFO(info);
 
-	DBG_LOOP(__FUNCTION__)
+	DBG_LOOP(__func__)
 
 	if (ACCESS_FBINFO(dead)) {
 		return -ENXIO;
@@ -408,7 +408,7 @@ static int matroxfb_release(struct fb_info *info, int user)
 {
 	MINFO_FROM_INFO(info);
 
-	DBG_LOOP(__FUNCTION__)
+	DBG_LOOP(__func__)
 
 	if (user) {
 		if (0 == --ACCESS_FBINFO(userusecount)) {
@@ -425,7 +425,7 @@ static int matroxfb_pan_display(struct fb_var_screeninfo *var,
 		struct fb_info* info) {
 	MINFO_FROM_INFO(info);
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	matrox_pan_var(PMINFO var);
 	return 0;
@@ -434,7 +434,7 @@ static int matroxfb_pan_display(struct fb_var_screeninfo *var,
 static int matroxfb_get_final_bppShift(CPMINFO int bpp) {
 	int bppshft2;
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	bppshft2 = bpp;
 	if (!bppshft2) {
@@ -451,7 +451,7 @@ static int matroxfb_test_and_set_rounding(CPMINFO int xres, int bpp) {
 	int over;
 	int rounding;
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	switch (bpp) {
 		case 0:		return xres;
@@ -482,7 +482,7 @@ static int matroxfb_pitch_adjust(CPMINFO int xres, int bpp) {
 	const int* width;
 	int xres_new;
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	if (!bpp) return xres;
 
@@ -504,7 +504,7 @@ static int matroxfb_pitch_adjust(CPMINFO int xres, int bpp) {
 
 static int matroxfb_get_cmap_len(struct fb_var_screeninfo *var) {
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	switch (var->bits_per_pixel) {
 		case 4:
@@ -548,7 +548,7 @@ static int matroxfb_decode_var(CPMINFO struct fb_var_screeninfo *var, int *visua
 	unsigned int vramlen;
 	unsigned int memlen;
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	switch (bpp) {
 		case 4:	 if (!ACCESS_FBINFO(capable.cfb4)) return -EINVAL;
@@ -648,7 +648,7 @@ static int matroxfb_setcolreg(unsigned regno, unsigned red, unsigned green,
 	struct matrox_fb_info* minfo = container_of(fb_info, struct matrox_fb_info, fbcon);
 #endif
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	/*
 	 *  Set a single color register. The values supplied are
@@ -707,7 +707,7 @@ static int matroxfb_setcolreg(unsigned regno, unsigned red, unsigned green,
 static void matroxfb_init_fix(WPMINFO2)
 {
 	struct fb_fix_screeninfo *fix = &ACCESS_FBINFO(fbcon).fix;
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	strcpy(fix->id,"MATROX");
 
@@ -722,7 +722,7 @@ static void matroxfb_init_fix(WPMINFO2)
 static void matroxfb_update_fix(WPMINFO2)
 {
 	struct fb_fix_screeninfo *fix = &ACCESS_FBINFO(fbcon).fix;
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	fix->smem_start = ACCESS_FBINFO(video.base) + ACCESS_FBINFO(curr.ydstorg.bytes);
 	fix->smem_len = ACCESS_FBINFO(video.len_usable) - ACCESS_FBINFO(curr.ydstorg.bytes);
@@ -753,7 +753,7 @@ static int matroxfb_set_par(struct fb_info *info)
 	struct fb_var_screeninfo *var;
 	MINFO_FROM_INFO(info);
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	if (ACCESS_FBINFO(dead)) {
 		return -ENXIO;
@@ -876,7 +876,7 @@ static int matroxfb_ioctl(struct fb_info *info,
 	void __user *argp = (void __user *)arg;
 	MINFO_FROM_INFO(info);
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	if (ACCESS_FBINFO(dead)) {
 		return -ENXIO;
@@ -1175,7 +1175,7 @@ static int matroxfb_blank(int blank, struct fb_info *info)
 	CRITFLAGS
 	MINFO_FROM_INFO(info);
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	if (ACCESS_FBINFO(dead))
 		return 1;
@@ -1287,7 +1287,7 @@ static int matroxfb_getmemory(WPMINFO unsigned int maxSize, unsigned int *realSi
 	unsigned char bytes[32];
 	unsigned char* tmp;
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	vm = ACCESS_FBINFO(video.vbase);
 	maxSize &= ~0x1FFFFF;	/* must be X*2MB (really it must be 2 or X*4MB) */
@@ -1593,7 +1593,7 @@ static int initMatrox2(WPMINFO struct board* b){
 		{ },
 	};
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	/* set default values... */
 	vesafb_defined.accel_flags = FB_ACCELF_TEXT;
@@ -2006,7 +2006,7 @@ static int matroxfb_probe(struct pci_dev* pdev, const struct pci_device_id* dumm
 #ifndef CONFIG_FB_MATROX_MULTIHEAD
 	static int registered = 0;
 #endif
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	svid = pdev->subsystem_vendor;
 	sid = pdev->subsystem_device;
@@ -2301,7 +2301,7 @@ static void __exit matrox_done(void) {
 static int __init matroxfb_setup(char *options) {
 	char *this_opt;
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	if (!options || !*options)
 		return 0;
@@ -2444,7 +2444,7 @@ static int __init matroxfb_init(void)
 	char *option = NULL;
 	int err = 0;
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	if (fb_get_options("matroxfb", &option))
 		return -ENODEV;
@@ -2556,7 +2556,7 @@ MODULE_PARM_DESC(cmode, "Specify the video depth that should be used (8bit defau
 
 int __init init_module(void){
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	if (disabled)
 		return -ENXIO;
diff --git a/drivers/video/matrox/matroxfb_crtc2.c b/drivers/video/matrox/matroxfb_crtc2.c
index a6ab5b6..7ac4c5f 100644
--- a/drivers/video/matrox/matroxfb_crtc2.c
+++ b/drivers/video/matrox/matroxfb_crtc2.c
@@ -420,7 +420,7 @@ static int matroxfb_dh_ioctl(struct fb_info *info,
 #define m2info (container_of(info, struct matroxfb_dh_fb_info, fbcon))
 	MINFO_FROM(m2info->primary_dev);
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	switch (cmd) {
 		case FBIOGET_VBLANK:
diff --git a/drivers/video/matrox/matroxfb_maven.c b/drivers/video/matrox/matroxfb_maven.c
index 0cd58f8..89da27b 100644
--- a/drivers/video/matrox/matroxfb_maven.c
+++ b/drivers/video/matrox/matroxfb_maven.c
@@ -220,7 +220,7 @@ static int matroxfb_PLL_mavenclock(const struct matrox_pll_features2* pll,
 	unsigned int scrlen;
 	unsigned int fmax;
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	scrlen = htotal * (vtotal - 1);
 	fwant = htotal * vtotal;
diff --git a/drivers/video/matrox/matroxfb_misc.c b/drivers/video/matrox/matroxfb_misc.c
index ab7fb50..aaa3e53 100644
--- a/drivers/video/matrox/matroxfb_misc.c
+++ b/drivers/video/matrox/matroxfb_misc.c
@@ -90,13 +90,13 @@
 #include <linux/matroxfb.h>
 
 void matroxfb_DAC_out(CPMINFO int reg, int val) {
-	DBG_REG(__FUNCTION__)
+	DBG_REG(__func__)
 	mga_outb(M_RAMDAC_BASE+M_X_INDEX, reg);
 	mga_outb(M_RAMDAC_BASE+M_X_DATAREG, val);
 }
 
 int matroxfb_DAC_in(CPMINFO int reg) {
-	DBG_REG(__FUNCTION__)
+	DBG_REG(__func__)
 	mga_outb(M_RAMDAC_BASE+M_X_INDEX, reg);
 	return mga_inb(M_RAMDAC_BASE+M_X_DATAREG);
 }
@@ -104,7 +104,7 @@ int matroxfb_DAC_in(CPMINFO int reg) {
 void matroxfb_var2my(struct fb_var_screeninfo* var, struct my_timming* mt) {
 	unsigned int pixclock = var->pixclock;
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	if (!pixclock) pixclock = 10000;	/* 10ns = 100MHz */
 	mt->pixclock = 1000000000 / pixclock;
@@ -131,7 +131,7 @@ int matroxfb_PLL_calcclock(const struct matrox_pll_features* pll, unsigned int f
 	unsigned int fwant;
 	unsigned int p;
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	fwant = freq;
 
@@ -192,7 +192,7 @@ int matroxfb_vgaHWinit(WPMINFO struct my_timming* m) {
 	int i;
 	struct matrox_hw_state * const hw = &ACCESS_FBINFO(hw);
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	hw->SEQ[0] = 0x00;
 	hw->SEQ[1] = 0x01;	/* or 0x09 */
@@ -336,7 +336,7 @@ void matroxfb_vgaHWrestore(WPMINFO2) {
 	struct matrox_hw_state * const hw = &ACCESS_FBINFO(hw);
 	CRITFLAGS
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	dprintk(KERN_INFO "MiscOutReg: %02X\n", hw->MiscOutReg);
 	dprintk(KERN_INFO "SEQ regs:   ");
diff --git a/drivers/video/modedb.c b/drivers/video/modedb.c
index 08d0725..f89dbaa 100644
--- a/drivers/video/modedb.c
+++ b/drivers/video/modedb.c
@@ -22,7 +22,7 @@
     ((v).xres == (x) && (v).yres == (y))
 
 #ifdef DEBUG
-#define DPRINTK(fmt, args...)	printk("modedb %s: " fmt, __FUNCTION__ , ## args)
+#define DPRINTK(fmt, args...)	printk("modedb %s: " fmt, __func__ , ## args)
 #else
 #define DPRINTK(fmt, args...)
 #endif
diff --git a/drivers/video/nvidia/nvidia.c b/drivers/video/nvidia/nvidia.c
index 596652d..990d435 100644
--- a/drivers/video/nvidia/nvidia.c
+++ b/drivers/video/nvidia/nvidia.c
@@ -43,14 +43,14 @@
 #define NVTRACE          if (0) printk
 #endif
 
-#define NVTRACE_ENTER(...)  NVTRACE("%s START\n", __FUNCTION__)
-#define NVTRACE_LEAVE(...)  NVTRACE("%s END\n", __FUNCTION__)
+#define NVTRACE_ENTER(...)  NVTRACE("%s START\n", __func__)
+#define NVTRACE_LEAVE(...)  NVTRACE("%s END\n", __func__)
 
 #ifdef CONFIG_FB_NVIDIA_DEBUG
 #define assert(expr) \
 	if (!(expr)) { \
 	printk( "Assertion failed! %s,%s,%s,line=%d\n",\
-	#expr,__FILE__,__FUNCTION__,__LINE__); \
+	#expr,__FILE__,__func__,__LINE__); \
 	BUG(); \
 	}
 #else
diff --git a/drivers/video/pm2fb.c b/drivers/video/pm2fb.c
index 30181b5..626e94e 100644
--- a/drivers/video/pm2fb.c
+++ b/drivers/video/pm2fb.c
@@ -56,7 +56,7 @@
 #undef PM2FB_MASTER_DEBUG
 #ifdef PM2FB_MASTER_DEBUG
 #define DPRINTK(a, b...)	\
-	printk(KERN_DEBUG "pm2fb: %s: " a, __FUNCTION__ , ## b)
+	printk(KERN_DEBUG "pm2fb: %s: " a, __func__ , ## b)
 #else
 #define DPRINTK(a, b...)
 #endif
diff --git a/drivers/video/pm3fb.c b/drivers/video/pm3fb.c
index 5dba8cd..35ed763 100644
--- a/drivers/video/pm3fb.c
+++ b/drivers/video/pm3fb.c
@@ -45,7 +45,7 @@
 #undef PM3FB_MASTER_DEBUG
 #ifdef PM3FB_MASTER_DEBUG
 #define DPRINTK(a, b...)	\
-	printk(KERN_DEBUG "pm3fb: %s: " a, __FUNCTION__ , ## b)
+	printk(KERN_DEBUG "pm3fb: %s: " a, __func__ , ## b)
 #else
 #define DPRINTK(a, b...)
 #endif
diff --git a/drivers/video/pxafb.c b/drivers/video/pxafb.c
index 97facb1..7841dd4 100644
--- a/drivers/video/pxafb.c
+++ b/drivers/video/pxafb.c
@@ -1053,7 +1053,7 @@ pxafb_freq_policy(struct notifier_block *nb, unsigned long val, void *data)
 		break;
 #if 0
 	case CPUFREQ_NOTIFY:
-		printk(KERN_ERR "%s: got CPUFREQ_NOTIFY\n", __FUNCTION__);
+		printk(KERN_ERR "%s: got CPUFREQ_NOTIFY\n", __func__);
 		do {} while(0);
 		/* todo: panic if min/max values aren't fulfilled
 		 * [can't really happen unless there's a bug in the
diff --git a/drivers/video/riva/fbdev.c b/drivers/video/riva/fbdev.c
index 5c47968..aafb76e 100644
--- a/drivers/video/riva/fbdev.c
+++ b/drivers/video/riva/fbdev.c
@@ -74,14 +74,14 @@
 #define NVTRACE          if(0) printk
 #endif
 
-#define NVTRACE_ENTER(...)  NVTRACE("%s START\n", __FUNCTION__)
-#define NVTRACE_LEAVE(...)  NVTRACE("%s END\n", __FUNCTION__)
+#define NVTRACE_ENTER(...)  NVTRACE("%s START\n", __func__)
+#define NVTRACE_LEAVE(...)  NVTRACE("%s END\n", __func__)
 
 #ifdef CONFIG_FB_RIVA_DEBUG
 #define assert(expr) \
 	if(!(expr)) { \
 	printk( "Assertion failed! %s,%s,%s,line=%d\n",\
-	#expr,__FILE__,__FUNCTION__,__LINE__); \
+	#expr,__FILE__,__func__,__LINE__); \
 	BUG(); \
 	}
 #else
diff --git a/drivers/video/s3c2410fb.c b/drivers/video/s3c2410fb.c
index 71fa6ed..13b38cb 100644
--- a/drivers/video/s3c2410fb.c
+++ b/drivers/video/s3c2410fb.c
@@ -430,9 +430,9 @@ static void s3c2410fb_activate_var(struct fb_info *info)
 	struct fb_var_screeninfo *var = &info->var;
 	int clkdiv = s3c2410fb_calc_pixclk(fbi, var->pixclock) / 2;
 
-	dprintk("%s: var->xres  = %d\n", __FUNCTION__, var->xres);
-	dprintk("%s: var->yres  = %d\n", __FUNCTION__, var->yres);
-	dprintk("%s: var->bpp   = %d\n", __FUNCTION__, var->bits_per_pixel);
+	dprintk("%s: var->xres  = %d\n", __func__, var->xres);
+	dprintk("%s: var->yres  = %d\n", __func__, var->yres);
+	dprintk("%s: var->bpp   = %d\n", __func__, var->bits_per_pixel);
 
 	if (type == S3C2410_LCDCON1_TFT) {
 		s3c2410fb_calculate_tft_lcd_regs(info, &fbi->regs);
diff --git a/drivers/video/sa1100fb.h b/drivers/video/sa1100fb.h
index 48066ef..f465b27 100644
--- a/drivers/video/sa1100fb.h
+++ b/drivers/video/sa1100fb.h
@@ -132,7 +132,7 @@ struct sa1100fb_info {
  *  Debug macros 
  */
 #if DEBUG
-#  define DPRINTK(fmt, args...)	printk("%s: " fmt, __FUNCTION__ , ## args)
+#  define DPRINTK(fmt, args...)	printk("%s: " fmt, __func__ , ## args)
 #else
 #  define DPRINTK(fmt, args...)
 #endif
diff --git a/drivers/video/sis/sis.h b/drivers/video/sis/sis.h
index 9b05da6..a14e822 100644
--- a/drivers/video/sis/sis.h
+++ b/drivers/video/sis/sis.h
@@ -55,7 +55,7 @@
 #undef SISFBDEBUG
 
 #ifdef SISFBDEBUG
-#define DPRINTK(fmt, args...) printk(KERN_DEBUG "%s: " fmt, __FUNCTION__ , ## args)
+#define DPRINTK(fmt, args...) printk(KERN_DEBUG "%s: " fmt, __func__ , ## args)
 #define TWDEBUG(x) printk(KERN_INFO x "\n");
 #else
 #define DPRINTK(fmt, args...)
diff --git a/drivers/video/sstfb.c b/drivers/video/sstfb.c
index 97784f9..5b11a00 100644
--- a/drivers/video/sstfb.c
+++ b/drivers/video/sstfb.c
@@ -1006,7 +1006,7 @@ static int sst_set_pll_att_ti(struct fb_info *info,
 		break;
 	default:
 		dprintk("%s: wrong clock code '%d'\n",
-		        __FUNCTION__, clock);
+		        __func__, clock);
 		return 0;
 		}
 	udelay(300);
@@ -1048,7 +1048,7 @@ static int sst_set_pll_ics(struct fb_info *info,
 		break;
 	default:
 		dprintk("%s: wrong clock code '%d'\n",
-		        __FUNCTION__, clock);
+		        __func__, clock);
 		return 0;
 		}
 	udelay(300);
@@ -1079,7 +1079,7 @@ static void sst_set_vidmod_att_ti(struct fb_info *info, const int bpp)
 		sst_dac_write(DACREG_RMR, (cr0 & 0x0f) | DACREG_CR0_16BPP);
 		break;
 	default:
-		dprintk("%s: bad depth '%u'\n", __FUNCTION__, bpp);
+		dprintk("%s: bad depth '%u'\n", __func__, bpp);
 		break;
 	}
 }
@@ -1093,7 +1093,7 @@ static void sst_set_vidmod_ics(struct fb_info *info, const int bpp)
 		sst_dac_write(DACREG_ICS_CMD, DACREG_ICS_CMD_16BPP);
 		break;
 	default:
-		dprintk("%s: bad depth '%u'\n", __FUNCTION__, bpp);
+		dprintk("%s: bad depth '%u'\n", __func__, bpp);
 		break;
 	}
 }
@@ -1133,7 +1133,7 @@ static int __devinit sst_detect_dactype(struct fb_info *info, struct sstfb_par *
 	}
 	if (!ret)
 		return 0;
-	f_dprintk("%s found %s\n", __FUNCTION__, dacs[i].name);
+	f_dprintk("%s found %s\n", __func__, dacs[i].name);
 	par->dac_sw = dacs[i];
 	return 1;
 }
diff --git a/drivers/video/stifb.c b/drivers/video/stifb.c
index e7c8db2..6ae359a 100644
--- a/drivers/video/stifb.c
+++ b/drivers/video/stifb.c
@@ -164,11 +164,11 @@ static int __initdata stifb_bpp_pref[MAX_STI_ROMS];
 # define  DEBUG_ON()  debug_on=1
 # define WRITE_BYTE(value,fb,reg)	do { if (debug_on) \
 						printk(KERN_DEBUG "%30s: WRITE_BYTE(0x%06x) = 0x%02x (old=0x%02x)\n", \
-							__FUNCTION__, reg, value, READ_BYTE(fb,reg)); 		  \
+							__func__, reg, value, READ_BYTE(fb,reg)); 		  \
 					gsc_writeb((value),(fb)->info.fix.mmio_start + (reg)); } while (0)
 # define WRITE_WORD(value,fb,reg)	do { if (debug_on) \
 						printk(KERN_DEBUG "%30s: WRITE_WORD(0x%06x) = 0x%08x (old=0x%08x)\n", \
-							__FUNCTION__, reg, value, READ_WORD(fb,reg)); 		  \
+							__func__, reg, value, READ_WORD(fb,reg)); 		  \
 					gsc_writel((value),(fb)->info.fix.mmio_start + (reg)); } while (0)
 #endif /* DEBUG_STIFB_REGS */
 
diff --git a/drivers/video/sysimgblt.c b/drivers/video/sysimgblt.c
index bd7e7e9..252a1a1 100644
--- a/drivers/video/sysimgblt.c
+++ b/drivers/video/sysimgblt.c
@@ -18,7 +18,7 @@
 #define DEBUG
 
 #ifdef DEBUG
-#define DPRINTK(fmt, args...) printk(KERN_DEBUG "%s: " fmt,__FUNCTION__,## args)
+#define DPRINTK(fmt, args...) printk(KERN_DEBUG "%s: " fmt,__func__,## args)
 #else
 #define DPRINTK(fmt, args...)
 #endif
diff --git a/drivers/video/tdfxfb.c b/drivers/video/tdfxfb.c
index 71e179e..ea9f19d 100644
--- a/drivers/video/tdfxfb.c
+++ b/drivers/video/tdfxfb.c
@@ -70,7 +70,7 @@
 
 #include <video/tdfx.h>
 
-#define DPRINTK(a, b...) pr_debug("fb: %s: " a, __FUNCTION__ , ## b)
+#define DPRINTK(a, b...) pr_debug("fb: %s: " a, __func__ , ## b)
 
 #ifdef CONFIG_MTRR
 #include <asm/mtrr.h>
-- 
1.5.4.3.500.g83a2c


