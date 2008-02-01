Return-Path: <linux-kernel-owner+w=401wt.eu-S1757885AbYBAJx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757885AbYBAJx3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 04:53:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754434AbYBAJxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 04:53:17 -0500
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:58361 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754202AbYBAJxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 04:53:16 -0500
From: Andi Kleen <ak@suse.de>
References: <200802011053.107168490@suse.de>
In-Reply-To: <200802011053.107168490@suse.de>
To: tglx@linutronix.de, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: [PATCH] [1/12] GBPAGES: Add feature macros for the gbpages cpuid bit
Message-Id: <20080201095314.2E08D1B416F@basil.firstfloor.org>
Date: Fri,  1 Feb 2008 10:53:14 +0100 (CET)
X-OriginalArrivalTime: 01 Feb 2008 09:46:56.0717 (UTC) FILETIME=[62118FD0:01C864B7]
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
