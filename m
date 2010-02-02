Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757163Ab0BCDp7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 22:45:59 -0500
Received: from buzzloop.caiaq.de ([212.112.241.133]:45789 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754430Ab0BCDpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 22:45:50 -0500
From: Daniel Mack <daniel@caiaq.de>
To: linux-kernel@vger.kernel.org
Cc: Daniel Mack <daniel@caiaq.de>, Jiri Kosina <trivial@kernel.org>,
       Junio C Hamano <gitster@pobox.com>
Subject: [PATCH 06/11] tree-wide: Fix spelling of 'achieve'
Date: Wed,  3 Feb 2010 00:48:22 +0800
Message-Id: <1265129307-18201-6-git-send-email-daniel@caiaq.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1265129307-18201-5-git-send-email-daniel@caiaq.de>
References: <1265129307-18201-1-git-send-email-daniel@caiaq.de>
 <1265129307-18201-2-git-send-email-daniel@caiaq.de>
 <1265129307-18201-3-git-send-email-daniel@caiaq.de>
 <1265129307-18201-4-git-send-email-daniel@caiaq.de>
 <1265129307-18201-5-git-send-email-daniel@caiaq.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc: Jiri Kosina <trivial@kernel.org>
Cc: Junio C Hamano <gitster@pobox.com>
---
 arch/arm/plat-s3c24xx/include/plat/cpu-freq-core.h |    2 +-
 arch/x86/kernel/tsc.c                              |    2 +-
 drivers/char/ip2/i2hw.h                            |    2 +-
 drivers/mfd/sm501.c                                |    8 ++++----
 drivers/video/sm501fb.c                            |    2 +-
 fs/jbd/transaction.c                               |    2 +-
 6 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/arm/plat-s3c24xx/include/plat/cpu-freq-core.h b/arch/arm/plat-s3c24xx/include/plat/cpu-freq-core.h
index 33d421d..d623235 100644
--- a/arch/arm/plat-s3c24xx/include/plat/cpu-freq-core.h
+++ b/arch/arm/plat-s3c24xx/include/plat/cpu-freq-core.h
@@ -135,7 +135,7 @@ struct s3c_cpufreq_config {
  * @locktime_m: The lock-time in uS for the MPLL.
  * @locktime_u: The lock-time in uS for the UPLL.
  * @locttime_bits: The number of bits each LOCKTIME field.
- * @need_pll: Set if this driver needs to change the PLL values to acheive
+ * @need_pll: Set if this driver needs to change the PLL values to achieve
  *	any frequency changes. This is really only need by devices like the
  *	S3C2410 where there is no or limited divider between the PLL and the
  *	ARMCLK.
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 597683a..dec8f68 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -50,7 +50,7 @@ u64 native_sched_clock(void)
 	 *   unstable. We do this because unlike Time Of Day,
 	 *   the scheduler clock tolerates small errors and it's
 	 *   very important for it to be as fast as the platform
-	 *   can achive it. )
+	 *   can achieve it. )
 	 */
 	if (unlikely(tsc_disabled)) {
 		/* No locking but a rare wrong value is not a big deal: */
diff --git a/drivers/char/ip2/i2hw.h b/drivers/char/ip2/i2hw.h
index 8aa6e7a..c0ba6c0 100644
--- a/drivers/char/ip2/i2hw.h
+++ b/drivers/char/ip2/i2hw.h
@@ -559,7 +559,7 @@ Loadware may be sent to the board in two ways:
 
 2) It may be hard-coded into your source by including a .h file (typically
 	supplied by Computone), which declares a data array and initializes every
-	element. This acheives the same result as if an entire loadware file had 
+	element. This achieves the same result as if an entire loadware file had 
 	been read into the array.
 
 	This requires more data space in your program, but access to the file system
diff --git a/drivers/mfd/sm501.c b/drivers/mfd/sm501.c
index 0cc5eef..10491e4 100644
--- a/drivers/mfd/sm501.c
+++ b/drivers/mfd/sm501.c
@@ -523,7 +523,7 @@ unsigned long sm501_set_clock(struct device *dev,
 	unsigned long clock = readl(sm->regs + SM501_CURRENT_CLOCK);
 	unsigned char reg;
 	unsigned int pll_reg = 0;
-	unsigned long sm501_freq; /* the actual frequency acheived */
+	unsigned long sm501_freq; /* the actual frequency achieved */
 
 	struct sm501_clock to;
 
@@ -533,7 +533,7 @@ unsigned long sm501_set_clock(struct device *dev,
 
 	switch (clksrc) {
 	case SM501_CLOCK_P2XCLK:
-		/* This clock is divided in half so to achive the
+		/* This clock is divided in half so to achieve the
 		 * requested frequency the value must be multiplied by
 		 * 2. This clock also has an additional pre divisor */
 
@@ -562,7 +562,7 @@ unsigned long sm501_set_clock(struct device *dev,
 		break;
 
 	case SM501_CLOCK_V2XCLK:
-		/* This clock is divided in half so to achive the
+		/* This clock is divided in half so to achieve the
 		 * requested frequency the value must be multiplied by 2. */
 
 		sm501_freq = (sm501_select_clock(2 * req_freq, &to, 3) / 2);
@@ -648,7 +648,7 @@ unsigned long sm501_find_clock(struct device *dev,
 			       unsigned long req_freq)
 {
 	struct sm501_devdata *sm = dev_get_drvdata(dev);
-	unsigned long sm501_freq; /* the frequency achiveable by the 501 */
+	unsigned long sm501_freq; /* the frequency achieveable by the 501 */
 	struct sm501_clock to;
 
 	switch (clksrc) {
diff --git a/drivers/video/sm501fb.c b/drivers/video/sm501fb.c
index 35370d0..b7dc180 100644
--- a/drivers/video/sm501fb.c
+++ b/drivers/video/sm501fb.c
@@ -411,7 +411,7 @@ static int sm501fb_set_par_common(struct fb_info *info,
 	struct sm501fb_par  *par = info->par;
 	struct sm501fb_info *fbi = par->info;
 	unsigned long pixclock;      /* pixelclock in Hz */
-	unsigned long sm501pixclock; /* pixelclock the 501 can achive in Hz */
+	unsigned long sm501pixclock; /* pixelclock the 501 can achieve in Hz */
 	unsigned int mem_type;
 	unsigned int clock_type;
 	unsigned int head_addr;
diff --git a/fs/jbd/transaction.c b/fs/jbd/transaction.c
index 006f9ad..57ae203 100644
--- a/fs/jbd/transaction.c
+++ b/fs/jbd/transaction.c
@@ -1398,7 +1398,7 @@ int journal_stop(handle_t *handle)
 	 * the case where our storage is so fast that it is more optimal to go
 	 * ahead and force a flush and wait for the transaction to be committed
 	 * than it is to wait for an arbitrary amount of time for new writers to
-	 * join the transaction.  We acheive this by measuring how long it takes
+	 * join the transaction.  We achieve this by measuring how long it takes
 	 * to commit a transaction, and compare it with how long this
 	 * transaction has been running, and if run time < commit time then we
 	 * sleep for the delta and commit.  This greatly helps super fast disks
-- 
1.6.3.3

