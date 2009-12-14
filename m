Return-Path: <linux-kernel-owner+w=401wt.eu-S1755408AbZLNADr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408AbZLNADr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 19:03:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755344AbZLNACo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 19:02:44 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34642 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755176AbZLMX6h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 18:58:37 -0500
From: re.emese@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Emese Revfy <re.emese@gmail.com>, linux@arm.linux.org.uk,
       nicolas.ferre@atmel.com, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: [PATCH 02/10] Constify struct platform_suspend_ops for 2.6.32-git-053fe57ac v2
Date: Mon, 14 Dec 2009 01:00:18 +0100
Message-Id: <154eba77924b4f98b52626a8eabf86342e7ed89b.1260663003.git.re.emese@gmail.com>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <cover.1260663003.git.re.emese@gmail.com>
References: <cover.1260663003.git.re.emese@gmail.com>
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emese Revfy <re.emese@gmail.com>


Signed-off-by: Emese Revfy <re.emese@gmail.com>
---
 arch/arm/mach-at91/pm.c        |    2 +-
 arch/arm/mach-omap1/pm.c       |    2 +-
 arch/arm/mach-omap2/pm24xx.c   |    2 +-
 arch/arm/mach-omap2/pm34xx.c   |    2 +-
 arch/arm/mach-pnx4008/pm.c     |    2 +-
 arch/arm/mach-pxa/pm.c         |    2 +-
 arch/arm/mach-pxa/sharpsl_pm.c |    2 +-
 arch/arm/mach-sa1100/pm.c      |    2 +-
 arch/arm/plat-s3c/pm.c         |    2 +-
 9 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/arm/mach-at91/pm.c b/arch/arm/mach-at91/pm.c
index 6156689..fca5b29 100644
--- a/arch/arm/mach-at91/pm.c
+++ b/arch/arm/mach-at91/pm.c
@@ -294,7 +294,7 @@ static void at91_pm_end(void)
 }
 
 
-static struct platform_suspend_ops at91_pm_ops ={
+static const struct platform_suspend_ops at91_pm_ops ={
 	.valid	= at91_pm_valid_state,
 	.begin	= at91_pm_begin,
 	.enter	= at91_pm_enter,
diff --git a/arch/arm/mach-omap1/pm.c b/arch/arm/mach-omap1/pm.c
index b1d3f9f..6e126ce 100644
--- a/arch/arm/mach-omap1/pm.c
+++ b/arch/arm/mach-omap1/pm.c
@@ -647,7 +647,7 @@ static struct irqaction omap_wakeup_irq = {
 
 
 
-static struct platform_suspend_ops omap_pm_ops ={
+static const struct platform_suspend_ops omap_pm_ops ={
 	.prepare	= omap_pm_prepare,
 	.enter		= omap_pm_enter,
 	.finish		= omap_pm_finish,
diff --git a/arch/arm/mach-omap2/pm24xx.c b/arch/arm/mach-omap2/pm24xx.c
index cba05b9..19585b9 100644
--- a/arch/arm/mach-omap2/pm24xx.c
+++ b/arch/arm/mach-omap2/pm24xx.c
@@ -326,7 +326,7 @@ static void omap2_pm_finish(void)
 	enable_hlt();
 }
 
-static struct platform_suspend_ops omap_pm_ops = {
+static const struct platform_suspend_ops omap_pm_ops = {
 	.prepare	= omap2_pm_prepare,
 	.enter		= omap2_pm_enter,
 	.finish		= omap2_pm_finish,
diff --git a/arch/arm/mach-omap2/pm34xx.c b/arch/arm/mach-omap2/pm34xx.c
index 81ed252..4cac25d 100644
--- a/arch/arm/mach-omap2/pm34xx.c
+++ b/arch/arm/mach-omap2/pm34xx.c
@@ -637,7 +637,7 @@ static void omap3_pm_end(void)
 	return;
 }
 
-static struct platform_suspend_ops omap_pm_ops = {
+static const struct platform_suspend_ops omap_pm_ops = {
 	.begin		= omap3_pm_begin,
 	.end		= omap3_pm_end,
 	.prepare	= omap3_pm_prepare,
diff --git a/arch/arm/mach-pnx4008/pm.c b/arch/arm/mach-pnx4008/pm.c
index b3d8d53..6e68ebc 100644
--- a/arch/arm/mach-pnx4008/pm.c
+++ b/arch/arm/mach-pnx4008/pm.c
@@ -116,7 +116,7 @@ static int pnx4008_pm_valid(suspend_state_t state)
 	       (state == PM_SUSPEND_MEM);
 }
 
-static struct platform_suspend_ops pnx4008_pm_ops = {
+static const struct platform_suspend_ops pnx4008_pm_ops = {
 	.enter = pnx4008_pm_enter,
 	.valid = pnx4008_pm_valid,
 };
diff --git a/arch/arm/mach-pxa/pm.c b/arch/arm/mach-pxa/pm.c
index 7693355..9beb00a 100644
--- a/arch/arm/mach-pxa/pm.c
+++ b/arch/arm/mach-pxa/pm.c
@@ -95,7 +95,7 @@ void pxa_pm_finish(void)
 		pxa_cpu_pm_fns->finish();
 }
 
-static struct platform_suspend_ops pxa_pm_ops = {
+static const struct platform_suspend_ops pxa_pm_ops = {
 	.valid		= pxa_pm_valid,
 	.enter		= pxa_pm_enter,
 	.prepare	= pxa_pm_prepare,
diff --git a/arch/arm/mach-pxa/sharpsl_pm.c b/arch/arm/mach-pxa/sharpsl_pm.c
index 67229a1..c55dd8f 100644
--- a/arch/arm/mach-pxa/sharpsl_pm.c
+++ b/arch/arm/mach-pxa/sharpsl_pm.c
@@ -892,7 +892,7 @@ static void sharpsl_apm_get_power_status(struct apm_power_info *info)
 }
 
 #ifdef CONFIG_PM
-static struct platform_suspend_ops sharpsl_pm_ops = {
+static const struct platform_suspend_ops sharpsl_pm_ops = {
 	.prepare	= pxa_pm_prepare,
 	.finish		= pxa_pm_finish,
 	.enter		= corgi_pxa_pm_enter,
diff --git a/arch/arm/mach-sa1100/pm.c b/arch/arm/mach-sa1100/pm.c
index c83fdc8..ab9fc44 100644
--- a/arch/arm/mach-sa1100/pm.c
+++ b/arch/arm/mach-sa1100/pm.c
@@ -120,7 +120,7 @@ unsigned long sleep_phys_sp(void *sp)
 	return virt_to_phys(sp);
 }
 
-static struct platform_suspend_ops sa11x0_pm_ops = {
+static const struct platform_suspend_ops sa11x0_pm_ops = {
 	.enter		= sa11x0_pm_enter,
 	.valid		= suspend_valid_only_mem,
 };
diff --git a/arch/arm/plat-s3c/pm.c b/arch/arm/plat-s3c/pm.c
index 7674706..4af2ef1 100644
--- a/arch/arm/plat-s3c/pm.c
+++ b/arch/arm/plat-s3c/pm.c
@@ -355,7 +355,7 @@ static void s3c_pm_finish(void)
 	s3c_pm_check_cleanup();
 }
 
-static struct platform_suspend_ops s3c_pm_ops = {
+static const struct platform_suspend_ops s3c_pm_ops = {
 	.enter		= s3c_pm_enter,
 	.prepare	= s3c_pm_prepare,
 	.finish		= s3c_pm_finish,
-- 
1.6.5.3

