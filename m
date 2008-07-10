Return-Path: <linux-kernel-owner+w=401wt.eu-S1761558AbYGJSph@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761558AbYGJSph (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 14:45:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758281AbYGJSlx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 14:41:53 -0400
Received: from mga03.intel.com ([143.182.124.21]:15876 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755385AbYGJSlo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 14:41:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,339,1212390000"; 
   d="scan'208";a="11424594"
Message-Id: <20080710182238.203245000@linux-os.sc.intel.com>
References: <20080710181634.764954000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 10 Jul 2008 11:16:50 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
       akpm@linux-foundation.org, arjan@linux.intel.com, andi@firstfloor.org,
       ebiederm@xmission.com, jbarnes@virtuousgeek.org, steiner@sgi.com
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 16/26] x64, x2apic/intr-remap: cpuid bits for x2apic feature
Content-Disposition: inline; filename=x2apic_feature.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpuid feature for x2apic.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

Index: tree-x86/include/asm-x86/cpufeature.h
===================================================================
--- tree-x86.orig/include/asm-x86/cpufeature.h	2008-07-10 09:51:45.000000000 -0700
+++ tree-x86/include/asm-x86/cpufeature.h	2008-07-10 09:52:16.000000000 -0700
@@ -90,6 +90,7 @@
 #define X86_FEATURE_CX16	(4*32+13) /* CMPXCHG16B */
 #define X86_FEATURE_XTPR	(4*32+14) /* Send Task Priority Messages */
 #define X86_FEATURE_DCA		(4*32+18) /* Direct Cache Access */
+#define X86_FEATURE_X2APIC	(4*32+21) /* x2APIC */
 
 /* VIA/Cyrix/Centaur-defined CPU features, CPUID level 0xC0000001, word 5 */
 #define X86_FEATURE_XSTORE	(5*32+ 2) /* on-CPU RNG present (xstore insn) */
@@ -188,6 +189,7 @@
 #define cpu_has_gbpages		boot_cpu_has(X86_FEATURE_GBPAGES)
 #define cpu_has_arch_perfmon	boot_cpu_has(X86_FEATURE_ARCH_PERFMON)
 #define cpu_has_pat		boot_cpu_has(X86_FEATURE_PAT)
+#define cpu_has_x2apic		boot_cpu_has(X86_FEATURE_X2APIC)
 
 #if defined(CONFIG_X86_INVLPG) || defined(CONFIG_X86_64)
 # define cpu_has_invlpg		1
Index: tree-x86/arch/x86/kernel/cpu/feature_names.c
===================================================================
--- tree-x86.orig/arch/x86/kernel/cpu/feature_names.c	2008-07-10 09:51:45.000000000 -0700
+++ tree-x86/arch/x86/kernel/cpu/feature_names.c	2008-07-10 09:52:16.000000000 -0700
@@ -45,7 +45,7 @@
 	/* Intel-defined (#2) */
 	"pni", NULL, NULL, "monitor", "ds_cpl", "vmx", "smx", "est",
 	"tm2", "ssse3", "cid", NULL, NULL, "cx16", "xtpr", NULL,
-	NULL, NULL, "dca", "sse4_1", "sse4_2", NULL, NULL, "popcnt",
+	NULL, NULL, "dca", "sse4_1", "sse4_2", "x2apic", NULL, "popcnt",
 	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
 
 	/* VIA/Cyrix/Centaur-defined */

-- 

