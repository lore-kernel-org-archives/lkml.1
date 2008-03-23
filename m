Return-Path: <linux-kernel-owner+w=401wt.eu-S1763349AbYCWIuv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763349AbYCWIuv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:50:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758457AbYCWILg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:11:36 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2330 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1760073AbYCWILb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:11:31 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 019/148] include/asm-x86/cpufeature.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:01:54 -0700
Message-Id: <1206259443-13210-20-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/cpufeature.h |  232 +++++++++++++++++++++++-------------------
 1 files changed, 125 insertions(+), 107 deletions(-)

diff --git a/include/asm-x86/cpufeature.h b/include/asm-x86/cpufeature.h
index 0d609c8..0c4034d 100644
--- a/include/asm-x86/cpufeature.h
+++ b/include/asm-x86/cpufeature.h
@@ -6,147 +6,165 @@
 
 #include <asm/required-features.h>
 
+#if defined _CF
+#undef _CF
+#endif
+#define _CF(word, bit) ((word) * 32 + (bit))
+
 #define NCAPINTS	8	/* N 32-bit words worth of info */
 
 /* Intel-defined CPU features, CPUID level 0x00000001 (edx), word 0 */
-#define X86_FEATURE_FPU		(0*32+ 0) /* Onboard FPU */
-#define X86_FEATURE_VME		(0*32+ 1) /* Virtual Mode Extensions */
-#define X86_FEATURE_DE		(0*32+ 2) /* Debugging Extensions */
-#define X86_FEATURE_PSE		(0*32+ 3) /* Page Size Extensions */
-#define X86_FEATURE_TSC		(0*32+ 4) /* Time Stamp Counter */
-#define X86_FEATURE_MSR		(0*32+ 5) /* Model-Specific Registers, RDMSR, WRMSR */
-#define X86_FEATURE_PAE		(0*32+ 6) /* Physical Address Extensions */
-#define X86_FEATURE_MCE		(0*32+ 7) /* Machine Check Architecture */
-#define X86_FEATURE_CX8		(0*32+ 8) /* CMPXCHG8 instruction */
-#define X86_FEATURE_APIC	(0*32+ 9) /* Onboard APIC */
-#define X86_FEATURE_SEP		(0*32+11) /* SYSENTER/SYSEXIT */
-#define X86_FEATURE_MTRR	(0*32+12) /* Memory Type Range Registers */
-#define X86_FEATURE_PGE		(0*32+13) /* Page Global Enable */
-#define X86_FEATURE_MCA		(0*32+14) /* Machine Check Architecture */
-#define X86_FEATURE_CMOV	(0*32+15) /* CMOV instruction (FCMOVCC and FCOMI too if FPU present) */
-#define X86_FEATURE_PAT		(0*32+16) /* Page Attribute Table */
-#define X86_FEATURE_PSE36	(0*32+17) /* 36-bit PSEs */
-#define X86_FEATURE_PN		(0*32+18) /* Processor serial number */
-#define X86_FEATURE_CLFLSH	(0*32+19) /* Supports the CLFLUSH instruction */
-#define X86_FEATURE_DS		(0*32+21) /* Debug Store */
-#define X86_FEATURE_ACPI	(0*32+22) /* ACPI via MSR */
-#define X86_FEATURE_MMX		(0*32+23) /* Multimedia Extensions */
-#define X86_FEATURE_FXSR	(0*32+24) /* FXSAVE and FXRSTOR instructions (fast save and restore */
-					  /* of FPU context), and CR4.OSFXSR available */
-#define X86_FEATURE_XMM		(0*32+25) /* Streaming SIMD Extensions */
-#define X86_FEATURE_XMM2	(0*32+26) /* Streaming SIMD Extensions-2 */
-#define X86_FEATURE_SELFSNOOP	(0*32+27) /* CPU self snoop */
-#define X86_FEATURE_HT		(0*32+28) /* Hyper-Threading */
-#define X86_FEATURE_ACC		(0*32+29) /* Automatic clock control */
-#define X86_FEATURE_IA64	(0*32+30) /* IA-64 processor */
+#define X86_FEATURE_FPU          _CF(0, 0)  /* Onboard FPU */
+#define X86_FEATURE_VME          _CF(0, 1)  /* Virtual Mode Extensions */
+#define X86_FEATURE_DE           _CF(0, 2)  /* Debugging Extensions */
+#define X86_FEATURE_PSE          _CF(0, 3)  /* Page Size Extensions */
+#define X86_FEATURE_TSC          _CF(0, 4)  /* Time Stamp Counter */
+#define X86_FEATURE_MSR          _CF(0, 5)  /* Model-Specific Registers,
+					     *  RDMSR, WRMSR */
+#define X86_FEATURE_PAE          _CF(0, 6)  /* Physical Address Extensions */
+#define X86_FEATURE_MCE          _CF(0, 7)  /* Machine Check Architecture */
+#define X86_FEATURE_CX8          _CF(0, 8)  /* CMPXCHG8 instruction */
+#define X86_FEATURE_APIC         _CF(0, 9)  /* Onboard APIC */
+#define X86_FEATURE_SEP          _CF(0, 11) /* SYSENTER/SYSEXIT */
+#define X86_FEATURE_MTRR         _CF(0, 12) /* Memory Type Range Registers */
+#define X86_FEATURE_PGE          _CF(0, 13) /* Page Global Enable */
+#define X86_FEATURE_MCA          _CF(0, 14) /* Machine Check Architecture */
+#define X86_FEATURE_CMOV         _CF(0, 15) /* CMOV instruction
+					     * (FCMOVCC and FCOMI too
+					     * if FPU present) */
+#define X86_FEATURE_PAT          _CF(0, 16) /* Page Attribute Table */
+#define X86_FEATURE_PSE36        _CF(0, 17) /* 36-bit PSEs */
+#define X86_FEATURE_PN           _CF(0, 18) /* Processor serial number */
+#define X86_FEATURE_CLFLSH       _CF(0, 19) /* Supports CLFLUSH instruction */
+#define X86_FEATURE_DS           _CF(0, 21) /* Debug Store */
+#define X86_FEATURE_ACPI         _CF(0, 22) /* ACPI via MSR */
+#define X86_FEATURE_MMX          _CF(0, 23) /* Multimedia Extensions */
+#define X86_FEATURE_FXSR         _CF(0, 24) /* FXSAVE and FXRSTOR instructions
+					     * (fast save and restore of FPU
+					     * context), and CR4.OSFXSR
+					     * available */
+#define X86_FEATURE_XMM          _CF(0, 25) /* Streaming SIMD Extensions */
+#define X86_FEATURE_XMM2         _CF(0, 26) /* Streaming SIMD Extensions-2 */
+#define X86_FEATURE_SELFSNOOP    _CF(0, 27) /* CPU self snoop */
+#define X86_FEATURE_HT           _CF(0, 28) /* Hyper-Threading */
+#define X86_FEATURE_ACC          _CF(0, 29) /* Automatic clock control */
+#define X86_FEATURE_IA64         _CF(0, 30) /* IA-64 processor */
 
 /* AMD-defined CPU features, CPUID level 0x80000001, word 1 */
 /* Don't duplicate feature flags which are redundant with Intel! */
-#define X86_FEATURE_SYSCALL	(1*32+11) /* SYSCALL/SYSRET */
-#define X86_FEATURE_MP		(1*32+19) /* MP Capable. */
-#define X86_FEATURE_NX		(1*32+20) /* Execute Disable */
-#define X86_FEATURE_MMXEXT	(1*32+22) /* AMD MMX extensions */
-#define X86_FEATURE_GBPAGES	(1*32+26) /* GB pages */
-#define X86_FEATURE_RDTSCP	(1*32+27) /* RDTSCP */
-#define X86_FEATURE_LM		(1*32+29) /* Long Mode (x86-64) */
-#define X86_FEATURE_3DNOWEXT	(1*32+30) /* AMD 3DNow! extensions */
-#define X86_FEATURE_3DNOW	(1*32+31) /* 3DNow! */
+#define X86_FEATURE_SYSCALL      _CF(1, 11) /* SYSCALL/SYSRET */
+#define X86_FEATURE_MP           _CF(1, 19) /* MP Capable. */
+#define X86_FEATURE_NX           _CF(1, 20) /* Execute Disable */
+#define X86_FEATURE_MMXEXT       _CF(1, 22) /* AMD MMX extensions */
+#define X86_FEATURE_GBPAGES      _CF(1, 26) /* GB pages */
+#define X86_FEATURE_RDTSCP       _CF(1, 27) /* RDTSCP */
+#define X86_FEATURE_LM           _CF(1, 29) /* Long Mode (x86-64) */
+#define X86_FEATURE_3DNOWEXT     _CF(1, 30) /* AMD 3DNow! extensions */
+#define X86_FEATURE_3DNOW        _CF(1, 31) /* 3DNow! */
 
 /* Transmeta-defined CPU features, CPUID level 0x80860001, word 2 */
-#define X86_FEATURE_RECOVERY	(2*32+ 0) /* CPU in recovery mode */
-#define X86_FEATURE_LONGRUN	(2*32+ 1) /* Longrun power control */
-#define X86_FEATURE_LRTI	(2*32+ 3) /* LongRun table interface */
+#define X86_FEATURE_RECOVERY     _CF(2, 0)  /* CPU in recovery mode */
+#define X86_FEATURE_LONGRUN      _CF(2, 1)  /* Longrun power control */
+#define X86_FEATURE_LRTI         _CF(2, 3)  /* LongRun table interface */
 
 /* Other features, Linux-defined mapping, word 3 */
 /* This range is used for feature bits which conflict or are synthesized */
-#define X86_FEATURE_CXMMX	(3*32+ 0) /* Cyrix MMX extensions */
-#define X86_FEATURE_K6_MTRR	(3*32+ 1) /* AMD K6 nonstandard MTRRs */
-#define X86_FEATURE_CYRIX_ARR	(3*32+ 2) /* Cyrix ARRs (= MTRRs) */
-#define X86_FEATURE_CENTAUR_MCR	(3*32+ 3) /* Centaur MCRs (= MTRRs) */
+#define X86_FEATURE_CXMMX        _CF(3, 0)  /* Cyrix MMX extensions */
+#define X86_FEATURE_K6_MTRR      _CF(3, 1)  /* AMD K6 nonstandard MTRRs */
+#define X86_FEATURE_CYRIX_ARR    _CF(3, 2)  /* Cyrix ARRs (= MTRRs) */
+#define X86_FEATURE_CENTAUR_MCR  _CF(3, 3)  /* Centaur MCRs (= MTRRs) */
 /* cpu types for specific tunings: */
-#define X86_FEATURE_K8		(3*32+ 4) /* Opteron, Athlon64 */
-#define X86_FEATURE_K7		(3*32+ 5) /* Athlon */
-#define X86_FEATURE_P3		(3*32+ 6) /* P3 */
-#define X86_FEATURE_P4		(3*32+ 7) /* P4 */
-#define X86_FEATURE_CONSTANT_TSC (3*32+ 8) /* TSC ticks at a constant rate */
-#define X86_FEATURE_UP		(3*32+ 9) /* smp kernel running on up */
-#define X86_FEATURE_FXSAVE_LEAK (3*32+10) /* FXSAVE leaks FOP/FIP/FOP */
-#define X86_FEATURE_ARCH_PERFMON (3*32+11) /* Intel Architectural PerfMon */
-#define X86_FEATURE_PEBS	(3*32+12)  /* Precise-Event Based Sampling */
-#define X86_FEATURE_BTS		(3*32+13)  /* Branch Trace Store */
-/* 14 free */
-/* 15 free */
-#define X86_FEATURE_REP_GOOD	(3*32+16) /* rep microcode works well on this CPU */
-#define X86_FEATURE_MFENCE_RDTSC (3*32+17) /* Mfence synchronizes RDTSC */
-#define X86_FEATURE_LFENCE_RDTSC (3*32+18) /* Lfence synchronizes RDTSC */
+#define X86_FEATURE_K8           _CF(3, 4)  /* Opteron, Athlon64 */
+#define X86_FEATURE_K7           _CF(3, 5)  /* Athlon */
+#define X86_FEATURE_P3           _CF(3, 6)  /* P3 */
+#define X86_FEATURE_P4           _CF(3, 7)  /* P4 */
+#define X86_FEATURE_CONSTANT_TSC _CF(3, 8)  /* TSC ticks at a constant rate */
+#define X86_FEATURE_UP           _CF(3, 9)  /* smp kernel running on up */
+#define X86_FEATURE_FXSAVE_LEAK  _CF(3, 10) /* FXSAVE leaks FOP/FIP/FOP */
+#define X86_FEATURE_ARCH_PERFMON _CF(3, 11) /* Intel Architectural PerfMon */
+#define X86_FEATURE_PEBS         _CF(3, 12) /* Precise-Event Based Sampling */
+#define X86_FEATURE_BTS          _CF(3, 13) /* Branch Trace Store */
+					    /* 14 free */
+					    /* 15 free */
+#define X86_FEATURE_REP_GOOD     _CF(3, 16) /* rep microcode works well
+					     * on this CPU */
+#define X86_FEATURE_MFENCE_RDTSC _CF(3, 17) /* Mfence synchronizes RDTSC */
+#define X86_FEATURE_LFENCE_RDTSC _CF(3, 18) /* Lfence synchronizes RDTSC */
 
 /* Intel-defined CPU features, CPUID level 0x00000001 (ecx), word 4 */
-#define X86_FEATURE_XMM3	(4*32+ 0) /* Streaming SIMD Extensions-3 */
-#define X86_FEATURE_MWAIT	(4*32+ 3) /* Monitor/Mwait support */
-#define X86_FEATURE_DSCPL	(4*32+ 4) /* CPL Qualified Debug Store */
-#define X86_FEATURE_EST		(4*32+ 7) /* Enhanced SpeedStep */
-#define X86_FEATURE_TM2		(4*32+ 8) /* Thermal Monitor 2 */
-#define X86_FEATURE_CID		(4*32+10) /* Context ID */
-#define X86_FEATURE_CX16	(4*32+13) /* CMPXCHG16B */
-#define X86_FEATURE_XTPR	(4*32+14) /* Send Task Priority Messages */
-#define X86_FEATURE_DCA		(4*32+18) /* Direct Cache Access */
+#define X86_FEATURE_XMM3         _CF(4, 0)  /* Streaming SIMD Extensions-3 */
+#define X86_FEATURE_MWAIT        _CF(4, 3)  /* Monitor/Mwait support */
+#define X86_FEATURE_DSCPL        _CF(4, 4)  /* CPL Qualified Debug Store */
+#define X86_FEATURE_EST          _CF(4, 7)  /* Enhanced SpeedStep */
+#define X86_FEATURE_TM2          _CF(4, 8)  /* Thermal Monitor 2 */
+#define X86_FEATURE_CID          _CF(4, 10) /* Context ID */
+#define X86_FEATURE_CX16         _CF(4, 13) /* CMPXCHG16B */
+#define X86_FEATURE_XTPR         _CF(4, 14) /* Send Task Priority Messages */
+#define X86_FEATURE_DCA          _CF(4, 18) /* Direct Cache Access */
 
 /* VIA/Cyrix/Centaur-defined CPU features, CPUID level 0xC0000001, word 5 */
-#define X86_FEATURE_XSTORE	(5*32+ 2) /* on-CPU RNG present (xstore insn) */
-#define X86_FEATURE_XSTORE_EN	(5*32+ 3) /* on-CPU RNG enabled */
-#define X86_FEATURE_XCRYPT	(5*32+ 6) /* on-CPU crypto (xcrypt insn) */
-#define X86_FEATURE_XCRYPT_EN	(5*32+ 7) /* on-CPU crypto enabled */
-#define X86_FEATURE_ACE2	(5*32+ 8) /* Advanced Cryptography Engine v2 */
-#define X86_FEATURE_ACE2_EN	(5*32+ 9) /* ACE v2 enabled */
-#define X86_FEATURE_PHE		(5*32+ 10) /* PadLock Hash Engine */
-#define X86_FEATURE_PHE_EN	(5*32+ 11) /* PHE enabled */
-#define X86_FEATURE_PMM		(5*32+ 12) /* PadLock Montgomery Multiplier */
-#define X86_FEATURE_PMM_EN	(5*32+ 13) /* PMM enabled */
+#define X86_FEATURE_XSTORE       _CF(5, 2)  /* on-CPU RNG present
+					     * (xstore insn) */
+#define X86_FEATURE_XSTORE_EN    _CF(5, 3)  /* on-CPU RNG enabled */
+#define X86_FEATURE_XCRYPT       _CF(5, 6)  /* on-CPU crypto (xcrypt insn) */
+#define X86_FEATURE_XCRYPT_EN    _CF(5, 7)  /* on-CPU crypto enabled */
+#define X86_FEATURE_ACE2         _CF(5, 8)  /* AdvancedCryptographyEngine v2 */
+#define X86_FEATURE_ACE2_EN      _CF(5, 9)  /* ACE v2 enabled */
+#define X86_FEATURE_PHE          _CF(5, 10) /* PadLock Hash Engine */
+#define X86_FEATURE_PHE_EN       _CF(5, 11) /* PHE enabled */
+#define X86_FEATURE_PMM          _CF(5, 12) /* PadLock Montgomery Multiplier */
+#define X86_FEATURE_PMM_EN       _CF(5, 13) /* PMM enabled */
 
 /* More extended AMD flags: CPUID level 0x80000001, ecx, word 6 */
-#define X86_FEATURE_LAHF_LM	(6*32+ 0) /* LAHF/SAHF in long mode */
-#define X86_FEATURE_CMP_LEGACY	(6*32+ 1) /* If yes HyperThreading not valid */
+#define X86_FEATURE_LAHF_LM      _CF(6, 0)  /* LAHF/SAHF in long mode */
+#define X86_FEATURE_CMP_LEGACY   _CF(6, 1)  /* If yes HyperThreading
+					     * not valid */
 
 /*
  * Auxiliary flags: Linux defined - For features scattered in various
  * CPUID levels like 0x6, 0xA etc
  */
-#define X86_FEATURE_IDA		(7*32+ 0) /* Intel Dynamic Acceleration */
+#define X86_FEATURE_IDA          _CF(7, 0)  /* Intel Dynamic Acceleration */
 
 #if defined(__KERNEL__) && !defined(__ASSEMBLY__)
 
 #include <linux/bitops.h>
 
-extern const char * const x86_cap_flags[NCAPINTS*32];
+extern const char * const x86_cap_flags[NCAPINTS * 32];
 extern const char * const x86_power_flags[32];
 
 #define test_cpu_cap(c, bit)						\
-	 test_bit(bit, (unsigned long *)((c)->x86_capability))
+	test_bit(bit, (unsigned long *)((c)->x86_capability))
 
 #define cpu_has(c, bit)							\
-	(__builtin_constant_p(bit) &&					\
-	 ( (((bit)>>5)==0 && (1UL<<((bit)&31) & REQUIRED_MASK0)) ||	\
-	   (((bit)>>5)==1 && (1UL<<((bit)&31) & REQUIRED_MASK1)) ||	\
-	   (((bit)>>5)==2 && (1UL<<((bit)&31) & REQUIRED_MASK2)) ||	\
-	   (((bit)>>5)==3 && (1UL<<((bit)&31) & REQUIRED_MASK3)) ||	\
-	   (((bit)>>5)==4 && (1UL<<((bit)&31) & REQUIRED_MASK4)) ||	\
-	   (((bit)>>5)==5 && (1UL<<((bit)&31) & REQUIRED_MASK5)) ||	\
-	   (((bit)>>5)==6 && (1UL<<((bit)&31) & REQUIRED_MASK6)) ||	\
-	   (((bit)>>5)==7 && (1UL<<((bit)&31) & REQUIRED_MASK7)) )	\
-	  ? 1 :								\
-	 test_cpu_cap(c, bit))
-
-#define boot_cpu_has(bit)	cpu_has(&boot_cpu_data, bit)
-
-#define set_cpu_cap(c, bit)	set_bit(bit, (unsigned long *)((c)->x86_capability))
-#define clear_cpu_cap(c, bit)	clear_bit(bit, (unsigned long *)((c)->x86_capability))
-#define setup_clear_cpu_cap(bit) do { \
-	clear_cpu_cap(&boot_cpu_data, bit);	\
-	set_bit(bit, cleared_cpu_caps); 	\
+	(__builtin_constant_p((bit)) &&					\
+	 ((((bit) >> 5) == 0 && (1UL << ((bit) & 31) & REQUIRED_MASK0)) || \
+	  (((bit) >> 5) == 1 && (1UL << ((bit) & 31) & REQUIRED_MASK1)) || \
+	  (((bit) >> 5) == 2 && (1UL << ((bit) & 31) & REQUIRED_MASK2)) || \
+	  (((bit) >> 5) == 3 && (1UL << ((bit) & 31) & REQUIRED_MASK3)) || \
+	  (((bit) >> 5) == 4 && (1UL << ((bit) & 31) & REQUIRED_MASK4)) || \
+	  (((bit) >> 5) == 5 && (1UL << ((bit) & 31) & REQUIRED_MASK5)) || \
+	  (((bit) >> 5) == 6 && (1UL << ((bit) & 31) & REQUIRED_MASK6)) || \
+	  (((bit) >> 5) == 7 && (1UL << ((bit) & 31) & REQUIRED_MASK7))) \
+	 ? 1								\
+	 : test_bit((bit), (unsigned long *)((c)->x86_capability)))
+
+#define boot_cpu_has(bit)			\
+	cpu_has(&boot_cpu_data, (bit))
+
+#define set_cpu_cap(c, bit)					\
+	set_bit((bit), (unsigned long *)((c)->x86_capability))
+#define clear_cpu_cap(c, bit)					\
+	clear_bit((bit), (unsigned long *)((c)->x86_capability))
+#define setup_clear_cpu_cap(bit)		\
+do {						\
+	clear_cpu_cap(&boot_cpu_data, (bit));	\
+	set_bit((bit), cleared_cpu_caps);	\
 } while (0)
-#define setup_force_cpu_cap(bit) do { \
-	set_cpu_cap(&boot_cpu_data, bit);	\
-	clear_bit(bit, cleared_cpu_caps); 	\
+#define setup_force_cpu_cap(bit)		\
+do {						\
+	set_cpu_cap(&boot_cpu_data, (bit));	\
+	clear_bit((bit), cleared_cpu_caps);	\
 } while (0)
 
 #define cpu_has_fpu		boot_cpu_has(X86_FEATURE_FPU)
-- 
1.5.4.rc2

