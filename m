Return-Path: <linux-kernel-owner+w=401wt.eu-S1755139AbYG2RlI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755139AbYG2RlI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 13:41:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752866AbYG2RkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 13:40:23 -0400
Received: from mga14.intel.com ([143.182.124.37]:32501 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752596AbYG2RkW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 13:40:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,273,1215414000"; 
   d="scan'208";a="26651783"
Message-Id: <20080729173157.384491000@linux-os.sc.intel.com>
References: <20080729172917.185593000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Tue, 29 Jul 2008 10:29:18 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       arjan@linux.intel.com, roland@redhat.com, drepper@redhat.com,
       mikpe@it.uu.se, chrisw@sous-sol.org, andi@firstfloor.org
Cc: linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com
Subject: [patch 1/9] x86, xsave: xsave cpuid feature bits
Content-Disposition: inline; filename=xsave_feature_bits.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

Index: tip-0728/arch/x86/kernel/cpu/feature_names.c
===================================================================
--- tip-0728.orig/arch/x86/kernel/cpu/feature_names.c	2008-07-28 18:19:50.000000000 -0700
+++ tip-0728/arch/x86/kernel/cpu/feature_names.c	2008-07-28 18:19:53.000000000 -0700
@@ -46,7 +46,7 @@
 	"pni", NULL, NULL, "monitor", "ds_cpl", "vmx", "smx", "est",
 	"tm2", "ssse3", "cid", NULL, NULL, "cx16", "xtpr", NULL,
 	NULL, NULL, "dca", "sse4_1", "sse4_2", "x2apic", NULL, "popcnt",
-	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
+	NULL, NULL, "xsave", NULL, NULL, NULL, NULL, NULL,
 
 	/* VIA/Cyrix/Centaur-defined */
 	NULL, NULL, "rng", "rng_en", NULL, NULL, "ace", "ace_en",
Index: tip-0728/include/asm-x86/cpufeature.h
===================================================================
--- tip-0728.orig/include/asm-x86/cpufeature.h	2008-07-28 18:19:50.000000000 -0700
+++ tip-0728/include/asm-x86/cpufeature.h	2008-07-28 18:19:53.000000000 -0700
@@ -92,6 +92,7 @@
 #define X86_FEATURE_XTPR	(4*32+14) /* Send Task Priority Messages */
 #define X86_FEATURE_DCA		(4*32+18) /* Direct Cache Access */
 #define X86_FEATURE_X2APIC	(4*32+21) /* x2APIC */
+#define X86_FEATURE_XSAVE	(4*32+26) /* XSAVE */
 
 /* VIA/Cyrix/Centaur-defined CPU features, CPUID level 0xC0000001, word 5 */
 #define X86_FEATURE_XSTORE	(5*32+ 2) /* on-CPU RNG present (xstore insn) */
@@ -191,6 +192,7 @@
 #define cpu_has_arch_perfmon	boot_cpu_has(X86_FEATURE_ARCH_PERFMON)
 #define cpu_has_pat		boot_cpu_has(X86_FEATURE_PAT)
 #define cpu_has_x2apic		boot_cpu_has(X86_FEATURE_X2APIC)
+#define cpu_has_xsave		boot_cpu_has(X86_FEATURE_XSAVE)
 
 #if defined(CONFIG_X86_INVLPG) || defined(CONFIG_X86_64)
 # define cpu_has_invlpg		1

-- 

