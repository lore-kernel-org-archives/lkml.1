Return-Path: <linux-kernel-owner+w=401wt.eu-S965949AbXDIV13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965949AbXDIV13 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 17:27:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030263AbXDIV0z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 17:26:55 -0400
Received: from nlpi015.sbcis.sbc.com ([207.115.36.44]:29083 "EHLO
	nlpi015.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965931AbXDIVZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 17:25:59 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: Marek Vasut <marek.vasut@gmail.com>, Tony Lindgren <tony@atomide.com>
Subject: [PATCH 1/6] ARM: OMAP: Enable DSP clocks for McBSP on omap310
Date: Mon,  9 Apr 2007 17:25:39 -0400
Message-Id: <1176153948771-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <1176153944991-git-send-email-tony@atomide.com>
References: <1176153944991-git-send-email-tony@atomide.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by alpha.home.local id l39LU1ZJ027028

From: Marek Vasut <marek.vasut@gmail.com>

This patch enables some clock on omap310.

Signed-off-by: Marek Vasut <marek.vasut@gmail.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap1/clock.h |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

--- a/arch/arm/mach-omap1/clock.h
+++ b/arch/arm/mach-omap1/clock.h
@@ -282,7 +282,7 @@ static struct clk arminth_ck16xx = {
 static struct clk dsp_ck = {
 	.name		= "dsp_ck",
 	.parent		= &ck_dpll1,
-	.flags		= CLOCK_IN_OMAP1510 | CLOCK_IN_OMAP16XX |
+	.flags		= CLOCK_IN_OMAP310 | CLOCK_IN_OMAP1510 | CLOCK_IN_OMAP16XX |
 			  RATE_CKCTL,
 	.enable_reg	= (void __iomem *)ARM_CKCTL,
 	.enable_bit	= EN_DSPCK,
@@ -295,7 +295,7 @@ static struct clk dsp_ck = {
 static struct clk dspmmu_ck = {
 	.name		= "dspmmu_ck",
 	.parent		= &ck_dpll1,
-	.flags		= CLOCK_IN_OMAP1510 | CLOCK_IN_OMAP16XX |
+	.flags		= CLOCK_IN_OMAP310 | CLOCK_IN_OMAP1510 | CLOCK_IN_OMAP16XX |
 			  RATE_CKCTL | ALWAYS_ENABLED,
 	.rate_offset	= CKCTL_DSPMMUDIV_OFFSET,
 	.recalc		= &omap1_ckctl_recalc,
@@ -306,7 +306,7 @@ static struct clk dspmmu_ck = {
 static struct clk dspper_ck = {
 	.name		= "dspper_ck",
 	.parent		= &ck_dpll1,
-	.flags		= CLOCK_IN_OMAP1510 | CLOCK_IN_OMAP16XX |
+	.flags		= CLOCK_IN_OMAP310 | CLOCK_IN_OMAP1510 | CLOCK_IN_OMAP16XX |
 			  RATE_CKCTL | VIRTUAL_IO_ADDRESS,
 	.enable_reg	= (void __iomem *)DSP_IDLECT2,
 	.enable_bit	= EN_PERCK,
@@ -320,7 +320,7 @@ static struct clk dspper_ck = {
 static struct clk dspxor_ck = {
 	.name		= "dspxor_ck",
 	.parent		= &ck_ref,
-	.flags		= CLOCK_IN_OMAP1510 | CLOCK_IN_OMAP16XX |
+	.flags		= CLOCK_IN_OMAP310 | CLOCK_IN_OMAP1510 | CLOCK_IN_OMAP16XX |
 			  VIRTUAL_IO_ADDRESS,
 	.enable_reg	= (void __iomem *)DSP_IDLECT2,
 	.enable_bit	= EN_XORPCK,
@@ -332,7 +332,7 @@ static struct clk dspxor_ck = {
 static struct clk dsptim_ck = {
 	.name		= "dsptim_ck",
 	.parent		= &ck_ref,
-	.flags		= CLOCK_IN_OMAP1510 | CLOCK_IN_OMAP16XX |
+	.flags		= CLOCK_IN_OMAP310 | CLOCK_IN_OMAP1510 | CLOCK_IN_OMAP16XX |
 			  VIRTUAL_IO_ADDRESS,
 	.enable_reg	= (void __iomem *)DSP_IDLECT2,
 	.enable_bit	= EN_DSPTIMCK,
@@ -374,7 +374,7 @@ static struct clk arminth_ck1510 = {
 
 static struct clk tipb_ck = {
 	/* No-idle controlled by "tc_ck" */
-	.name		= "tibp_ck",
+	.name		= "tipb_ck",
 	.parent		= &tc_ck.clk,
 	.flags		= CLOCK_IN_OMAP1510 | CLOCK_IN_OMAP310 |
 			  ALWAYS_ENABLED,
@@ -733,7 +733,7 @@ remains active during MPU idle whenever this is enabled */
 static struct clk i2c_fck = {
 	.name		= "i2c_fck",
 	.id		= 1,
-	.flags		= CLOCK_IN_OMAP1510 | CLOCK_IN_OMAP16XX |
+	.flags		= CLOCK_IN_OMAP310 | CLOCK_IN_OMAP1510 | CLOCK_IN_OMAP16XX |
 			  VIRTUAL_CLOCK | CLOCK_NO_IDLE_PARENT |
 			  ALWAYS_ENABLED,
 	.parent		= &armxor_ck.clk,
-- 
1.4.4.2

