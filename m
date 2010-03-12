Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933997Ab0CLOYl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 09:24:41 -0500
Received: from mail-yw0-f184.google.com ([209.85.211.184]:39750 "EHLO
	mail-yw0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933938Ab0CLOYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 09:24:38 -0500
From: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
To: linux@arm.linux.org.uk, mroberto@cpti.cetuc.puc-rio.br
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] ARM: mach-sa1100: fix checkpatch.pl issues in cpu-sa1100.c.
Date: Fri, 12 Mar 2010 11:23:47 -0300
Message-Id: <1268403827-16127-2-git-send-email-mroberto@cpti.cetuc.puc-rio.br>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1268403827-16127-1-git-send-email-mroberto@cpti.cetuc.puc-rio.br>
References: <1268403827-16127-1-git-send-email-mroberto@cpti.cetuc.puc-rio.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes checkpatch.pl issues in cpu-sa1100.c.

Signed-off-by: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
---
 arch/arm/mach-sa1100/cpu-sa1100.c |   51 ++++++++++++++++++-------------------
 1 files changed, 25 insertions(+), 26 deletions(-)

diff --git a/arch/arm/mach-sa1100/cpu-sa1100.c b/arch/arm/mach-sa1100/cpu-sa1100.c
index a98712e..c18b419 100644
--- a/arch/arm/mach-sa1100/cpu-sa1100.c
+++ b/arch/arm/mach-sa1100/cpu-sa1100.c
@@ -94,48 +94,47 @@
 
 #include "generic.h"
 
-typedef struct {
+struct sa1100_dram_regs {
 	int speed;
 	u32 mdcnfg;
 	u32 mdcas0;
 	u32 mdcas1;
 	u32 mdcas2;
-} sa1100_dram_regs_t;
+};
 
 
 static struct cpufreq_driver sa1100_driver;
 
-static sa1100_dram_regs_t sa1100_dram_settings[] =
-{
-	/* speed,     mdcnfg,     mdcas0,     mdcas1,     mdcas2  clock frequency */
-	{  59000, 0x00dc88a3, 0xcccccccf, 0xfffffffc, 0xffffffff }, /*  59.0 MHz */
-	{  73700, 0x011490a3, 0xcccccccf, 0xfffffffc, 0xffffffff }, /*  73.7 MHz */
-	{  88500, 0x014e90a3, 0xcccccccf, 0xfffffffc, 0xffffffff }, /*  88.5 MHz */
-	{ 103200, 0x01889923, 0xcccccccf, 0xfffffffc, 0xffffffff }, /* 103.2 MHz */
-	{ 118000, 0x01c29923, 0x9999998f, 0xfffffff9, 0xffffffff }, /* 118.0 MHz */
-	{ 132700, 0x01fb2123, 0x9999998f, 0xfffffff9, 0xffffffff }, /* 132.7 MHz */
-	{ 147500, 0x02352123, 0x3333330f, 0xfffffff3, 0xffffffff }, /* 147.5 MHz */
-	{ 162200, 0x026b29a3, 0x38e38e1f, 0xfff8e38e, 0xffffffff }, /* 162.2 MHz */
-	{ 176900, 0x02a329a3, 0x71c71c1f, 0xfff1c71c, 0xffffffff }, /* 176.9 MHz */
-	{ 191700, 0x02dd31a3, 0xe38e383f, 0xffe38e38, 0xffffffff }, /* 191.7 MHz */
-	{ 206400, 0x03153223, 0xc71c703f, 0xffc71c71, 0xffffffff }, /* 206.4 MHz */
-	{ 221200, 0x034fba23, 0xc71c703f, 0xffc71c71, 0xffffffff }, /* 221.2 MHz */
-	{ 235900, 0x03853a23, 0xe1e1e07f, 0xe1e1e1e1, 0xffffffe1 }, /* 235.9 MHz */
-	{ 250700, 0x03bf3aa3, 0xc3c3c07f, 0xc3c3c3c3, 0xffffffc3 }, /* 250.7 MHz */
-	{ 265400, 0x03f7c2a3, 0xc3c3c07f, 0xc3c3c3c3, 0xffffffc3 }, /* 265.4 MHz */
-	{ 280200, 0x0431c2a3, 0x878780ff, 0x87878787, 0xffffff87 }, /* 280.2 MHz */
+static struct sa1100_dram_regs sa1100_dram_settings[] = {
+	/*speed,     mdcnfg,     mdcas0,     mdcas1,     mdcas2,   clock freq */
+	{ 59000, 0x00dc88a3, 0xcccccccf, 0xfffffffc, 0xffffffff},/*  59.0 MHz */
+	{ 73700, 0x011490a3, 0xcccccccf, 0xfffffffc, 0xffffffff},/*  73.7 MHz */
+	{ 88500, 0x014e90a3, 0xcccccccf, 0xfffffffc, 0xffffffff},/*  88.5 MHz */
+	{103200, 0x01889923, 0xcccccccf, 0xfffffffc, 0xffffffff},/* 103.2 MHz */
+	{118000, 0x01c29923, 0x9999998f, 0xfffffff9, 0xffffffff},/* 118.0 MHz */
+	{132700, 0x01fb2123, 0x9999998f, 0xfffffff9, 0xffffffff},/* 132.7 MHz */
+	{147500, 0x02352123, 0x3333330f, 0xfffffff3, 0xffffffff},/* 147.5 MHz */
+	{162200, 0x026b29a3, 0x38e38e1f, 0xfff8e38e, 0xffffffff},/* 162.2 MHz */
+	{176900, 0x02a329a3, 0x71c71c1f, 0xfff1c71c, 0xffffffff},/* 176.9 MHz */
+	{191700, 0x02dd31a3, 0xe38e383f, 0xffe38e38, 0xffffffff},/* 191.7 MHz */
+	{206400, 0x03153223, 0xc71c703f, 0xffc71c71, 0xffffffff},/* 206.4 MHz */
+	{221200, 0x034fba23, 0xc71c703f, 0xffc71c71, 0xffffffff},/* 221.2 MHz */
+	{235900, 0x03853a23, 0xe1e1e07f, 0xe1e1e1e1, 0xffffffe1},/* 235.9 MHz */
+	{250700, 0x03bf3aa3, 0xc3c3c07f, 0xc3c3c3c3, 0xffffffc3},/* 250.7 MHz */
+	{265400, 0x03f7c2a3, 0xc3c3c07f, 0xc3c3c3c3, 0xffffffc3},/* 265.4 MHz */
+	{280200, 0x0431c2a3, 0x878780ff, 0x87878787, 0xffffff87},/* 280.2 MHz */
 	{ 0, 0, 0, 0, 0 } /* last entry */
 };
 
 static void sa1100_update_dram_timings(int current_speed, int new_speed)
 {
-	sa1100_dram_regs_t *settings = sa1100_dram_settings;
+	struct sa1100_dram_regs *settings = sa1100_dram_settings;
 
 	/* find speed */
 	while (settings->speed != 0) {
-		if(new_speed == settings->speed)
+		if (new_speed == settings->speed)
 			break;
-		
+
 		settings++;
 	}
 
@@ -149,7 +148,7 @@ static void sa1100_update_dram_timings(int current_speed, int new_speed)
 		/* We're going FASTER, so first relax the memory
 		 * timings before changing the core frequency
 		 */
-		
+
 		/* Half the memory access clock */
 		MDCNFG |= MDCNFG_CDB2;
 
@@ -187,7 +186,7 @@ static int sa1100_target(struct cpufreq_policy *policy,
 	struct cpufreq_freqs freqs;
 
 	new_ppcr = sa11x0_freq_to_ppcr(target_freq);
-	switch(relation){
+	switch (relation) {
 	case CPUFREQ_RELATION_L:
 		if (sa11x0_ppcr_to_freq(new_ppcr) > policy->max)
 			new_ppcr--;
-- 
1.7.0.1

