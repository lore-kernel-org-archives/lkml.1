Return-Path: <linux-kernel-owner+w=401wt.eu-S1760821AbYA2FHf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760821AbYA2FHf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 00:07:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753068AbYA2FGd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 00:06:33 -0500
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:52716 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018AbYA2FGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 00:06:32 -0500
From: Andi Kleen <ak@suse.de>
References: <20080129606.610336873@suse.de>
In-Reply-To: <20080129606.610336873@suse.de>
To: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: [PATCH] [2/9] GBPAGES: Add feature macros for the gbpages cpuid bit
Message-Id: <20080129050630.A22001B416E@basil.firstfloor.org>
Date: Tue, 29 Jan 2008 06:06:30 +0100 (CET)
X-OriginalArrivalTime: 29 Jan 2008 05:00:14.0362 (UTC) FILETIME=[D56D3FA0:01C86233]
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
@@ -175,6 +176,7 @@
 #define cpu_has_pebs		boot_cpu_has(X86_FEATURE_PEBS)
 #define cpu_has_clflush		boot_cpu_has(X86_FEATURE_CLFLSH)
 #define cpu_has_bts		boot_cpu_has(X86_FEATURE_BTS)
+#define cpu_has_gbpages 	boot_cpu_has(X86_FEATURE_GBPAGES)
 
 #if defined(CONFIG_X86_INVLPG) || defined(CONFIG_X86_64)
 # define cpu_has_invlpg		1
