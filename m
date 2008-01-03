Return-Path: <linux-kernel-owner+w=401wt.eu-S1760190AbYACAwP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760190AbYACAwP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 19:52:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759584AbYACAuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 19:50:07 -0500
Received: from mx1.suse.de ([195.135.220.2]:51769 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754886AbYACAuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 19:50:03 -0500
From: Andi Kleen <ak@suse.de>
References: <20080103149.088038000@suse.de>
In-Reply-To: <20080103149.088038000@suse.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] [7/20] x86: Remove the now unused X86_FEATURE_SYNC_RDTSC
Message-Id: <20080103005002.8360014D40@wotan.suse.de>
Date: Thu,  3 Jan 2008 01:50:02 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andi Kleen <ak@suse.de>

---
 include/asm-x86/cpufeature.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/include/asm-x86/cpufeature.h
===================================================================
--- linux.orig/include/asm-x86/cpufeature.h
+++ linux/include/asm-x86/cpufeature.h
@@ -77,7 +77,7 @@
 #define X86_FEATURE_PEBS	(3*32+12)  /* Precise-Event Based Sampling */
 #define X86_FEATURE_BTS		(3*32+13)  /* Branch Trace Store */
 /* 14 free */
-#define X86_FEATURE_SYNC_RDTSC	(3*32+15)  /* RDTSC synchronizes the CPU */
+/* 15 free */
 #define X86_FEATURE_REP_GOOD	(3*32+16) /* rep microcode works well on this CPU */
 #define X86_FEATURE_MFENCE_RDTSC (3*32+17) /* Mfence synchronizes RDTSC */
 #define X86_FEATURE_LFENCE_RDTSC (3*32+18) /* Lfence synchronizes RDTSC */
