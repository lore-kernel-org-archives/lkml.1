Return-Path: <linux-kernel-owner+w=401wt.eu-S1755864AbYASGtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755864AbYASGtX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 01:49:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751454AbYASGsv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 01:48:51 -0500
Received: from mail.suse.de ([195.135.220.2]:33224 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751667AbYASGsb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 01:48:31 -0500
From: Andi Kleen <ak@suse.de>
References: <20080119748.170864000@suse.de>
In-Reply-To: <20080119748.170864000@suse.de>
To: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: [PATCH] [2/8] GBPAGES: Add feature macros for the gbpages cpuid bit
Message-Id: <20080119064830.5B00814EAD@wotan.suse.de>
Date: Sat, 19 Jan 2008 07:48:30 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Andi Kleen <ak@suse.de>

---
 include/asm-x86/cpufeature.h |    2 ++
 1 file changed, 2 insertions(+)

Index: linux/include/asm-x86/cpufeature.h
===================================================================
--- linux.orig/include/asm-x86/cpufeature.h
+++ linux/include/asm-x86/cpufeature.h
@@ -49,6 +49,7 @@
 #define X86_FEATURE_MP		(1*32+19) /* MP Capable. */
 #define X86_FEATURE_NX		(1*32+20) /* Execute Disable */
 #define X86_FEATURE_MMXEXT	(1*32+22) /* AMD MMX extensions */
+#define X86_FEATURE_GBPAGES	(1*32+26) /* GB pages */
 #define X86_FEATURE_RDTSCP	(1*32+27) /* RDTSCP */
 #define X86_FEATURE_LM		(1*32+29) /* Long Mode (x86-64) */
 #define X86_FEATURE_3DNOWEXT	(1*32+30) /* AMD 3DNow! extensions */
@@ -173,6 +174,7 @@
 #define cpu_has_bts		boot_cpu_has(X86_FEATURE_BTS)
 #define cpu_has_pat		boot_cpu_has(X86_FEATURE_PAT)
 #define cpu_has_ss		boot_cpu_has(X86_FEATURE_SELFSNOOP)
+#define cpu_has_gbpages 	boot_cpu_has(X86_FEATURE_GBPAGES)
 
 #if defined(CONFIG_X86_INVLPG) || defined(CONFIG_X86_64)
 # define cpu_has_invlpg 	1
