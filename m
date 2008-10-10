Return-Path: <linux-kernel-owner+w=401wt.eu-S1762847AbYJJSDC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762847AbYJJSDC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 14:03:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758090AbYJJSCu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 14:02:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48216 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762752AbYJJSCh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 14:02:37 -0400
Date: Fri, 10 Oct 2008 20:02:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [git pull, take 2, part 2] x86 updates for v2.6.28, phase #4,
	x2apic, unify-cpu-detect
Message-ID: <20081010180200.GA21876@elte.hu>
References: <20081010000408.GA5970@elte.hu> <20081010175613.GA20112@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081010175613.GA20112@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > Linus,
> > 
> > Please pull the latest x86-v28-for-linus-phase4 git tree from:
> > 
> > x86/x2apic and x86/unify-cpu-detect topics.
> 
> Linus, please find a new pull request below - relative to 
> x86-v28-for-linus-phase3-B.

and here's x86-v28-for-linus-phase4-C: the second part of 
x86-v28-for-linus-phase3: x86/unify-cpu-detect and its dependent topics. 
Relative to x86-v28-for-linus-phase4-B.

	Ingo

--------------->
Linus,

Please pull the latest x86-v28-for-linus-phase4-C git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-v28-for-linus-phase4-C


out-of-topic modifications in x86-v28-for-linus-phase4-C:
---------------------------------------------------------
include/asm-generic/vmlinux.lds.h  # 63cc8c7: percpu: introduce DEFINE_PER_CPU_
include/linux/ioport.h             # 268364a: IO resources: add reserve_region_
include/linux/percpu.h             # 63cc8c7: percpu: introduce DEFINE_PER_CPU_
kernel/resource.c                  # 268364a: IO resources: add reserve_region_

 Thanks,

	Ingo

------------------>
Andi Kleen (1):
      x86: drop -funroll-loops for csum_partial_64.c

Cihula, Joseph (1):
      x86, e820: add support for AddressRangeUnusuable ACPI memory type

Eric Dumazet (1):
      percpu: introduce DEFINE_PER_CPU_PAGE_ALIGNED() macro

H. Peter Anvin (10):
      x86, xsave: add <asm/xcr.h> header file for XCR registers
      x86, xsave: keep the XSAVE feature mask as an u64
      x86: boot: stub out unimplemented CPU feature words
      x86: add NOPL as a synthetic CPU feature bit
      x86: use X86_FEATURE_NOPL in alternatives
      x86: generate names for /proc/cpuinfo from <asm/cpufeature.h>
      x86: cpufeature: add Intel features from CPUID and AVX specs
      x86: <asm/cpufeature.h>: clean up overlong lines, whitespace
      x86: cpufeature: fix SMX flag
      x86 setup: handle more than 8 CPU flag words

Hans Schou (1):
      x86, debug: print more information about unknown CPUs

Ingo Molnar (9):
      x86, cyrix: debug
      x86: L3 cache index disable for 2.6.26, cleanups
      x86 l3 cache index disable for 2 6 26 fix
      x86: L3 cache index disable for 2.6.26, fix #2
      x86: fix xsave build error
      x86: split e820 reserved entries record to late v4
      x86: cpu/common*.c, merge whitespaces
      x86, init_64.c: cleanup
      x86: cpuid, fix typo

Jan Beulich (1):
      x86-64: add two __cpuinit annotations

Krzysztof Helt (1):
      x86: delay early cpu initialization until cpuid is done

Mark Langsdorf (2):
      x86: L3 cache index disable for 2.6.26
      x86: L3 cache index disable for 2.6.26

Sheng Yang (2):
      x86: move VMX MSRs to msr-index.h
      x86: extended "flags" to show virtualization HW feature in /proc/cpuinfo

Suresh Siddha (16):
      x86, xsave: xsave cpuid feature bits
      x86, xsave: enable xsave/xrstor on cpus with xsave support
      x86, xsave: context switch support using xsave/xrstor
      x86, xsave: dynamically allocate sigframes fpstate instead of static allocation
      x86, xsave: reorganization of signal save/restore fpstate code layout
      x86, xsave: xsave/xrstor specific routines
      x86, xsave: struct _fpstate extensions to include extended state information
      x86, xsave: save/restore the extended state context in sigframe
      x86, xsave: update xsave header bits during ptrace fpregs set
      x86, xsave: remove the redundant access_ok() in setup_rt_frame()
      x86, xsave: clear the user buffer before doing fxsave/xsave
      x86, xsave: use BUG_ON() instead of BUILD_BUG_ON()
      x86: use cpuid vector 0xb when available for detecting cpu topology
      x86: use x2apic id reported by cpuid during topology discovery
      x86: use x2apic id reported by cpuid during topology discovery, fix
      x86: xsave: restore xcr0 during resume

Thomas Petazzoni (3):
      x86: make movsl_mask definition non-CPU specific
      x86: move cmpxchg fallbacks to a generic place
      x86: configuration options to compile out x86 CPU support code

Yinghai Lu (46):
      x86: move dir es7000 to es7000_32.c
      x86: split e820 reserved entries record to late v2
      IO resources: add reserve_region_with_split()
      x86: split e820 reserved entries record to late, v7
      x86: unify using pci_mmcfg_insert_resource
      x86: move mtrr cpu cap setting early in early_init_xxxx
      x86: make (early)_identify_cpu more the same between 32bit and 64 bit
      x86: order functions in cpu/common.c and cpu/common_64.c v2
      x86: remove cpu_vendor_dev
      x86: make 32bit support show_msr like 64 bit
      x86: make get_mode_name of 64bit the same as 32bit
      x86: move 32bit related functions together
      x86: make detect_ht depend on CONFIG_X86_HT
      x86: make header file the same in arch/x86/kernel/cpu/common_xx.c
      x86: same gdt_page with macro
      x86: cpu/common.c, let 64-bit code have 32-bit only functions
      x86: cpu/common*.c, make 32-bit have 64-bit only functions
      x86: cpu/common*.c have same cpu_init(), with copying and #ifdef
      x86: cpu/common*.c, merge switch_to_new_gdt()
      x86: cpu/common.c, merge default_init()
      x86: cpu/common*.c, merge display_cacheinfo()
      x86: cpu/common*.c, merge detect_ht()
      x86: cpu/common.c: merge get_cpu_cap()
      x86: cpu/common*.c, merge early_identify_cpu()
      x86: cpu/common*.c: merge print_cpu_info()
      x86: cpu/common*.c, merge generic_identify()
      x86: cpu/common*.c, merge identify_cpu()
      x86: use cpu/common.c on 64 bit
      x86: move nonx_setup etc from common.c to init_64.c
      x86: remove duplicated get_model_name() calling
      x86, cpu init: call early_init_xxx in init_xxx
      x86: cpu make amd.c more like amd_64.c v2
      x86: remove duplicated force_mwait
      x86: add srat_detect_node for amd64
      x86: merge header in amd_64.c
      x86: make amd.c have 64bit support code
      x86: make amd_64 have 32 bit code
      x86: make 64 bit to use amd.c
      x86: little clean up of intel.c/intel_64.c
      x86: make intel.c have 64-bit support code
      x86: make intel_64.c the same as intel.c
      x86: let intel 64-bit use intel.c
      x86: intel.c put workaround for old cpus together
      x86: centaur_64.c remove duplicated setting of CONSTANT_TSC
      x86: identify_cpu_without_cpuid v2
      x86: move transmeta cap read to early_init_transmeta()


 arch/x86/Kconfig.cpu                               |   54 ++
 arch/x86/boot/cpu.c                                |   17 +-
 arch/x86/boot/mkcpustr.c                           |   40 +-
 arch/x86/es7000/Makefile                           |    5 -
 arch/x86/es7000/es7000.h                           |  114 ---
 arch/x86/ia32/ia32_signal.c                        |   51 +-
 arch/x86/kernel/Makefile                           |    3 +-
 arch/x86/kernel/cpu/Makefile                       |   34 +-
 arch/x86/kernel/cpu/addon_cpuid_features.c         |   88 ++
 arch/x86/kernel/cpu/amd.c                          |  548 +++++++----
 arch/x86/kernel/cpu/amd_64.c                       |  224 -----
 arch/x86/kernel/cpu/centaur.c                      |    4 +-
 arch/x86/kernel/cpu/centaur_64.c                   |    6 +-
 arch/x86/kernel/cpu/cmpxchg.c                      |   72 ++
 arch/x86/kernel/cpu/common.c                       |  973 ++++++++++++++------
 arch/x86/kernel/cpu/common_64.c                    |  765 ---------------
 arch/x86/kernel/cpu/cpu.h                          |   19 +-
 arch/x86/kernel/cpu/cyrix.c                        |   23 +-
 arch/x86/kernel/cpu/feature_names.c                |   84 --
 arch/x86/kernel/cpu/intel.c                        |  364 ++++----
 arch/x86/kernel/cpu/intel_64.c                     |   95 --
 arch/x86/kernel/cpu/intel_cacheinfo.c              |  169 +++-
 arch/x86/kernel/cpu/mcheck/mce_64.c                |    2 +-
 arch/x86/kernel/cpu/mkcapflags.pl                  |   32 +
 arch/x86/kernel/cpu/powerflags.c                   |   20 +
 arch/x86/kernel/cpu/transmeta.c                    |   32 +-
 arch/x86/kernel/cpu/umc.c                          |    3 +-
 arch/x86/kernel/e820.c                             |   28 +-
 .../{es7000/es7000plat.c => kernel/es7000_32.c}    |   85 ++-
 arch/x86/kernel/genx2apic_cluster.c                |    7 +-
 arch/x86/kernel/genx2apic_phys.c                   |    7 +-
 arch/x86/kernel/i387.c                             |  154 +++-
 arch/x86/kernel/process.c                          |    1 -
 arch/x86/kernel/sigframe.h                         |   14 +-
 arch/x86/kernel/signal_32.c                        |   45 +-
 arch/x86/kernel/signal_64.c                        |   95 +--
 arch/x86/kernel/traps_32.c                         |    1 -
 arch/x86/kernel/traps_64.c                         |    6 +-
 arch/x86/kernel/vmlinux_32.lds.S                   |    9 +-
 arch/x86/kernel/vmlinux_64.lds.S                   |    9 +-
 arch/x86/kernel/xsave.c                            |  316 +++++++
 arch/x86/kvm/vmx.h                                 |   15 -
 arch/x86/lib/Makefile                              |    3 -
 arch/x86/lib/usercopy_32.c                         |    7 +
 arch/x86/mach-generic/Makefile                     |    1 -
 arch/x86/mm/init_64.c                              |   56 ++
 arch/x86/pci/i386.c                                |    3 +
 arch/x86/pci/mmconfig-shared.c                     |   12 +-
 arch/x86/power/cpu_32.c                            |    7 +
 arch/x86/power/cpu_64.c                            |    7 +
 include/asm-generic/vmlinux.lds.h                  |    1 +
 include/asm-x86/bugs.h                             |    5 +
 include/asm-x86/cpufeature.h                       |  118 ++-
 include/asm-x86/e820.h                             |    2 +
 include/asm-x86/i387.h                             |   84 ++-
 include/asm-x86/msr-index.h                        |   16 +
 include/asm-x86/processor-cyrix.h                  |    8 +
 include/asm-x86/processor-flags.h                  |    1 +
 include/asm-x86/processor.h                        |   27 +-
 include/asm-x86/sigcontext.h                       |   87 ++-
 include/asm-x86/sigcontext32.h                     |    6 +-
 include/asm-x86/thread_info.h                      |    1 +
 include/asm-x86/ucontext.h                         |    6 +
 include/asm-x86/xcr.h                              |   49 +
 include/asm-x86/xsave.h                            |  118 +++
 include/linux/ioport.h                             |    3 +
 include/linux/percpu.h                             |    7 +
 kernel/resource.c                                  |   68 ++
 68 files changed, 3019 insertions(+), 2317 deletions(-)
 delete mode 100644 arch/x86/es7000/Makefile
 delete mode 100644 arch/x86/es7000/es7000.h
 delete mode 100644 arch/x86/kernel/cpu/amd_64.c
 create mode 100644 arch/x86/kernel/cpu/cmpxchg.c
 delete mode 100644 arch/x86/kernel/cpu/common_64.c
 delete mode 100644 arch/x86/kernel/cpu/feature_names.c
 delete mode 100644 arch/x86/kernel/cpu/intel_64.c
 create mode 100644 arch/x86/kernel/cpu/mkcapflags.pl
 create mode 100644 arch/x86/kernel/cpu/powerflags.c
 rename arch/x86/{es7000/es7000plat.c => kernel/es7000_32.c} (78%)
 create mode 100644 arch/x86/kernel/xsave.c
 create mode 100644 include/asm-x86/xcr.h
 create mode 100644 include/asm-x86/xsave.h

diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index 60a8576..f8843c3 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -419,6 +419,60 @@ config X86_DEBUGCTLMSR
 	def_bool y
 	depends on !(MK6 || MWINCHIPC6 || MWINCHIP2 || MWINCHIP3D || MCYRIXIII || M586MMX || M586TSC || M586 || M486 || M386)
 
+menuconfig PROCESSOR_SELECT
+	default y
+	bool "Supported processor vendors" if EMBEDDED
+	help
+	  This lets you choose what x86 vendor support code your kernel
+	  will include.
+
+config CPU_SUP_INTEL
+	default y
+	bool "Support Intel processors" if PROCESSOR_SELECT
+	help
+	  This enables extended support for Intel processors
+
+config CPU_SUP_CYRIX_32
+	default y
+	bool "Support Cyrix processors" if PROCESSOR_SELECT
+	depends on !64BIT
+	help
+	  This enables extended support for Cyrix processors
+
+config CPU_SUP_AMD
+	default y
+	bool "Support AMD processors" if PROCESSOR_SELECT
+	help
+	  This enables extended support for AMD processors
+
+config CPU_SUP_CENTAUR_32
+	default y
+	bool "Support Centaur processors" if PROCESSOR_SELECT
+	depends on !64BIT
+	help
+	  This enables extended support for Centaur processors
+
+config CPU_SUP_CENTAUR_64
+	default y
+	bool "Support Centaur processors" if PROCESSOR_SELECT
+	depends on 64BIT
+	help
+	  This enables extended support for Centaur processors
+
+config CPU_SUP_TRANSMETA_32
+	default y
+	bool "Support Transmeta processors" if PROCESSOR_SELECT
+	depends on !64BIT
+	help
+	  This enables extended support for Transmeta processors
+
+config CPU_SUP_UMC_32
+	default y
+	bool "Support UMC processors" if PROCESSOR_SELECT
+	depends on !64BIT
+	help
+	  This enables extended support for UMC processors
+
 config X86_DS
 	bool "Debug Store support"
 	default y
diff --git a/arch/x86/boot/cpu.c b/arch/x86/boot/cpu.c
index 75298fe..6ec6bb6 100644
--- a/arch/x86/boot/cpu.c
+++ b/arch/x86/boot/cpu.c
@@ -59,17 +59,18 @@ int validate_cpu(void)
 			u32 e = err_flags[i];
 
 			for (j = 0; j < 32; j++) {
-				int n = (i << 5)+j;
-				if (*msg_strs < n) {
+				if (msg_strs[0] < i ||
+				    (msg_strs[0] == i && msg_strs[1] < j)) {
 					/* Skip to the next string */
-					do {
-						msg_strs++;
-					} while (*msg_strs);
-					msg_strs++;
+					msg_strs += 2;
+					while (*msg_strs++)
+						;
 				}
 				if (e & 1) {
-					if (*msg_strs == n && msg_strs[1])
-						printf("%s ", msg_strs+1);
+					if (msg_strs[0] == i &&
+					    msg_strs[1] == j &&
+					    msg_strs[2])
+						printf("%s ", msg_strs+2);
 					else
 						printf("%d:%d ", i, j);
 				}
diff --git a/arch/x86/boot/mkcpustr.c b/arch/x86/boot/mkcpustr.c
index bbe7695..8ef60f2 100644
--- a/arch/x86/boot/mkcpustr.c
+++ b/arch/x86/boot/mkcpustr.c
@@ -15,33 +15,33 @@
 
 #include <stdio.h>
 
-#include "../kernel/cpu/feature_names.c"
-
-#if NCAPFLAGS > 8
-# error "Need to adjust the boot code handling of CPUID strings"
-#endif
+#include "../kernel/cpu/capflags.c"
 
 int main(void)
 {
-	int i;
+	int i, j;
 	const char *str;
 
 	printf("static const char x86_cap_strs[] = \n");
 
-	for (i = 0; i < NCAPINTS*32; i++) {
-		str = x86_cap_flags[i];
-
-		if (i == NCAPINTS*32-1) {
-			/* The last entry must be unconditional; this
-			   also consumes the compiler-added null character */
-			if (!str)
-				str = "";
-			printf("\t\"\\x%02x\"\"%s\"\n", i, str);
-		} else if (str) {
-			printf("#if REQUIRED_MASK%d & (1 << %d)\n"
-			       "\t\"\\x%02x\"\"%s\\0\"\n"
-			       "#endif\n",
-			       i >> 5, i & 31, i, str);
+	for (i = 0; i < NCAPINTS; i++) {
+		for (j = 0; j < 32; j++) {
+			str = x86_cap_flags[i*32+j];
+
+			if (i == NCAPINTS-1 && j == 31) {
+				/* The last entry must be unconditional; this
+				   also consumes the compiler-added null
+				   character */
+				if (!str)
+					str = "";
+				printf("\t\"\\x%02x\\x%02x\"\"%s\"\n",
+				       i, j, str);
+			} else if (str) {
+				printf("#if REQUIRED_MASK%d & (1 << %d)\n"
+				       "\t\"\\x%02x\\x%02x\"\"%s\\0\"\n"
+				       "#endif\n",
+				       i, j, i, j, str);
+			}
 		}
 	}
 	printf("\t;\n");
diff --git a/arch/x86/es7000/Makefile b/arch/x86/es7000/Makefile
deleted file mode 100644
index 3ef8b43..0000000
--- a/arch/x86/es7000/Makefile
+++ /dev/null
@@ -1,5 +0,0 @@
-#
-# Makefile for the linux kernel.
-#
-
-obj-$(CONFIG_X86_ES7000)	:= es7000plat.o
diff --git a/arch/x86/es7000/es7000.h b/arch/x86/es7000/es7000.h
deleted file mode 100644
index 4e62f6f..0000000
--- a/arch/x86/es7000/es7000.h
+++ /dev/null
@@ -1,114 +0,0 @@
-/*
- * Written by: Garry Forsgren, Unisys Corporation
- *             Natalie Protasevich, Unisys Corporation
- * This file contains the code to configure and interface
- * with Unisys ES7000 series hardware system manager.
- *
- * Copyright (c) 2003 Unisys Corporation.  All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
- *
- * You should have received a copy of the GNU General Public License along
- * with this program; if not, write the Free Software Foundation, Inc., 59
- * Temple Place - Suite 330, Boston MA 02111-1307, USA.
- *
- * Contact information: Unisys Corporation, Township Line & Union Meeting
- * Roads-A, Unisys Way, Blue Bell, Pennsylvania, 19424, or:
- *
- * http://www.unisys.com
- */
-
-/*
- * ES7000 chipsets
- */
-
-#define NON_UNISYS		0
-#define ES7000_CLASSIC		1
-#define ES7000_ZORRO		2
-
-
-#define	MIP_REG			1
-#define	MIP_PSAI_REG		4
-
-#define	MIP_BUSY		1
-#define	MIP_SPIN		0xf0000
-#define	MIP_VALID		0x0100000000000000ULL
-#define	MIP_PORT(VALUE)	((VALUE >> 32) & 0xffff)
-
-#define	MIP_RD_LO(VALUE)	(VALUE & 0xffffffff)
-
-struct mip_reg_info {
-	unsigned long long mip_info;
-	unsigned long long delivery_info;
-	unsigned long long host_reg;
-	unsigned long long mip_reg;
-};
-
-struct part_info {
-	unsigned char type;
-	unsigned char length;
-	unsigned char part_id;
-	unsigned char apic_mode;
-	unsigned long snum;
-	char ptype[16];
-	char sname[64];
-	char pname[64];
-};
-
-struct psai {
-	unsigned long long entry_type;
-	unsigned long long addr;
-	unsigned long long bep_addr;
-};
-
-struct es7000_mem_info {
-	unsigned char type;
-	unsigned char length;
-	unsigned char resv[6];
-	unsigned long long  start;
-	unsigned long long  size;
-};
-
-struct es7000_oem_table {
-	unsigned long long hdr;
-	struct mip_reg_info mip;
-	struct part_info pif;
-	struct es7000_mem_info shm;
-	struct psai psai;
-};
-
-#ifdef CONFIG_ACPI
-
-struct oem_table {
-	struct acpi_table_header Header;
-	u32 OEMTableAddr;
-	u32 OEMTableSize;
-};
-
-extern int find_unisys_acpi_oem_table(unsigned long *oem_addr);
-#endif
-
-struct mip_reg {
-	unsigned long long off_0;
-	unsigned long long off_8;
-	unsigned long long off_10;
-	unsigned long long off_18;
-	unsigned long long off_20;
-	unsigned long long off_28;
-	unsigned long long off_30;
-	unsigned long long off_38;
-};
-
-#define	MIP_SW_APIC		0x1020b
-#define	MIP_FUNC(VALUE)		(VALUE & 0xff)
-
-extern int parse_unisys_oem (char *oemptr);
-extern void setup_unisys(void);
-extern int es7000_start_cpu(int cpu, unsigned long eip);
-extern void es7000_sw_apic(void);
diff --git a/arch/x86/ia32/ia32_signal.c b/arch/x86/ia32/ia32_signal.c
index f1a2ac7..8d64c1b 100644
--- a/arch/x86/ia32/ia32_signal.c
+++ b/arch/x86/ia32/ia32_signal.c
@@ -179,9 +179,10 @@ struct sigframe
 	u32 pretcode;
 	int sig;
 	struct sigcontext_ia32 sc;
-	struct _fpstate_ia32 fpstate;
+	struct _fpstate_ia32 fpstate_unused; /* look at kernel/sigframe.h */
 	unsigned int extramask[_COMPAT_NSIG_WORDS-1];
 	char retcode[8];
+	/* fp state follows here */
 };
 
 struct rt_sigframe
@@ -192,8 +193,8 @@ struct rt_sigframe
 	u32 puc;
 	compat_siginfo_t info;
 	struct ucontext_ia32 uc;
-	struct _fpstate_ia32 fpstate;
 	char retcode[8];
+	/* fp state follows here */
 };
 
 #define COPY(x)		{ 		\
@@ -215,7 +216,7 @@ static int ia32_restore_sigcontext(struct pt_regs *regs,
 				   unsigned int *peax)
 {
 	unsigned int tmpflags, gs, oldgs, err = 0;
-	struct _fpstate_ia32 __user *buf;
+	void __user *buf;
 	u32 tmp;
 
 	/* Always make any pending restarted system calls return -EINTR */
@@ -259,26 +260,12 @@ static int ia32_restore_sigcontext(struct pt_regs *regs,
 
 	err |= __get_user(tmp, &sc->fpstate);
 	buf = compat_ptr(tmp);
-	if (buf) {
-		if (!access_ok(VERIFY_READ, buf, sizeof(*buf)))
-			goto badframe;
-		err |= restore_i387_ia32(buf);
-	} else {
-		struct task_struct *me = current;
-
-		if (used_math()) {
-			clear_fpu(me);
-			clear_used_math();
-		}
-	}
+	err |= restore_i387_xstate_ia32(buf);
 
 	err |= __get_user(tmp, &sc->ax);
 	*peax = tmp;
 
 	return err;
-
-badframe:
-	return 1;
 }
 
 asmlinkage long sys32_sigreturn(struct pt_regs *regs)
@@ -350,7 +337,7 @@ badframe:
  */
 
 static int ia32_setup_sigcontext(struct sigcontext_ia32 __user *sc,
-				 struct _fpstate_ia32 __user *fpstate,
+				 void __user *fpstate,
 				 struct pt_regs *regs, unsigned int mask)
 {
 	int tmp, err = 0;
@@ -380,7 +367,7 @@ static int ia32_setup_sigcontext(struct sigcontext_ia32 __user *sc,
 	err |= __put_user((u32)regs->flags, &sc->flags);
 	err |= __put_user((u32)regs->sp, &sc->sp_at_signal);
 
-	tmp = save_i387_ia32(fpstate);
+	tmp = save_i387_xstate_ia32(fpstate);
 	if (tmp < 0)
 		err = -EFAULT;
 	else {
@@ -401,7 +388,8 @@ static int ia32_setup_sigcontext(struct sigcontext_ia32 __user *sc,
  * Determine which stack to use..
  */
 static void __user *get_sigframe(struct k_sigaction *ka, struct pt_regs *regs,
-				 size_t frame_size)
+				 size_t frame_size,
+				 void **fpstate)
 {
 	unsigned long sp;
 
@@ -420,6 +408,11 @@ static void __user *get_sigframe(struct k_sigaction *ka, struct pt_regs *regs,
 		 ka->sa.sa_restorer)
 		sp = (unsigned long) ka->sa.sa_restorer;
 
+	if (used_math()) {
+		sp = sp - sig_xstate_ia32_size;
+		*fpstate = (struct _fpstate_ia32 *) sp;
+	}
+
 	sp -= frame_size;
 	/* Align the stack pointer according to the i386 ABI,
 	 * i.e. so that on function entry ((sp + 4) & 15) == 0. */
@@ -433,6 +426,7 @@ int ia32_setup_frame(int sig, struct k_sigaction *ka,
 	struct sigframe __user *frame;
 	void __user *restorer;
 	int err = 0;
+	void __user *fpstate = NULL;
 
 	/* copy_to_user optimizes that into a single 8 byte store */
 	static const struct {
@@ -447,7 +441,7 @@ int ia32_setup_frame(int sig, struct k_sigaction *ka,
 		0,
 	};
 
-	frame = get_sigframe(ka, regs, sizeof(*frame));
+	frame = get_sigframe(ka, regs, sizeof(*frame), &fpstate);
 
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
 		goto give_sigsegv;
@@ -456,8 +450,7 @@ int ia32_setup_frame(int sig, struct k_sigaction *ka,
 	if (err)
 		goto give_sigsegv;
 
-	err |= ia32_setup_sigcontext(&frame->sc, &frame->fpstate, regs,
-					set->sig[0]);
+	err |= ia32_setup_sigcontext(&frame->sc, fpstate, regs, set->sig[0]);
 	if (err)
 		goto give_sigsegv;
 
@@ -521,6 +514,7 @@ int ia32_setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	struct rt_sigframe __user *frame;
 	void __user *restorer;
 	int err = 0;
+	void __user *fpstate = NULL;
 
 	/* __copy_to_user optimizes that into a single 8 byte store */
 	static const struct {
@@ -536,7 +530,7 @@ int ia32_setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 		0,
 	};
 
-	frame = get_sigframe(ka, regs, sizeof(*frame));
+	frame = get_sigframe(ka, regs, sizeof(*frame), &fpstate);
 
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
 		goto give_sigsegv;
@@ -549,13 +543,16 @@ int ia32_setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 		goto give_sigsegv;
 
 	/* Create the ucontext.  */
-	err |= __put_user(0, &frame->uc.uc_flags);
+	if (cpu_has_xsave)
+		err |= __put_user(UC_FP_XSTATE, &frame->uc.uc_flags);
+	else
+		err |= __put_user(0, &frame->uc.uc_flags);
 	err |= __put_user(0, &frame->uc.uc_link);
 	err |= __put_user(current->sas_ss_sp, &frame->uc.uc_stack.ss_sp);
 	err |= __put_user(sas_ss_flags(regs->sp),
 			  &frame->uc.uc_stack.ss_flags);
 	err |= __put_user(current->sas_ss_size, &frame->uc.uc_stack.ss_size);
-	err |= ia32_setup_sigcontext(&frame->uc.uc_mcontext, &frame->fpstate,
+	err |= ia32_setup_sigcontext(&frame->uc.uc_mcontext, fpstate,
 				     regs, set->sig[0]);
 	err |= __copy_to_user(&frame->uc.uc_sigmask, set, sizeof(*set));
 	if (err)
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index a07ec14..c9be69f 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -38,7 +38,7 @@ obj-y			+= tsc.o io_delay.o rtc.o
 
 obj-$(CONFIG_X86_TRAMPOLINE)	+= trampoline.o
 obj-y				+= process.o
-obj-y				+= i387.o
+obj-y				+= i387.o xsave.o
 obj-y				+= ptrace.o
 obj-y				+= ds.o
 obj-$(CONFIG_X86_32)		+= tls.o
@@ -69,6 +69,7 @@ obj-$(CONFIG_KEXEC)		+= machine_kexec_$(BITS).o
 obj-$(CONFIG_KEXEC)		+= relocate_kernel_$(BITS).o crash.o
 obj-$(CONFIG_CRASH_DUMP)	+= crash_dump_$(BITS).o
 obj-$(CONFIG_X86_NUMAQ)		+= numaq_32.o
+obj-$(CONFIG_X86_ES7000)	+= es7000_32.o
 obj-$(CONFIG_X86_SUMMIT_NUMA)	+= summit_32.o
 obj-y				+= vsmp_64.o
 obj-$(CONFIG_KPROBES)		+= kprobes.o
diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index ee76eaa..7f0b45a 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -3,22 +3,30 @@
 #
 
 obj-y			:= intel_cacheinfo.o addon_cpuid_features.o
-obj-y			+= proc.o feature_names.o
-
-obj-$(CONFIG_X86_32)	+= common.o bugs.o
-obj-$(CONFIG_X86_64)	+= common_64.o bugs_64.o
-obj-$(CONFIG_X86_32)	+= amd.o
-obj-$(CONFIG_X86_64)	+= amd_64.o
-obj-$(CONFIG_X86_32)	+= cyrix.o
-obj-$(CONFIG_X86_32)	+= centaur.o
-obj-$(CONFIG_X86_64)	+= centaur_64.o
-obj-$(CONFIG_X86_32)	+= transmeta.o
-obj-$(CONFIG_X86_32)	+= intel.o
-obj-$(CONFIG_X86_64)	+= intel_64.o
-obj-$(CONFIG_X86_32)	+= umc.o
+obj-y			+= proc.o capflags.o powerflags.o common.o
+
+obj-$(CONFIG_X86_32)	+= bugs.o cmpxchg.o
+obj-$(CONFIG_X86_64)	+= bugs_64.o
+
+obj-$(CONFIG_CPU_SUP_INTEL)		+= intel.o
+obj-$(CONFIG_CPU_SUP_AMD)		+= amd.o
+obj-$(CONFIG_CPU_SUP_CYRIX_32)		+= cyrix.o
+obj-$(CONFIG_CPU_SUP_CENTAUR_32)	+= centaur.o
+obj-$(CONFIG_CPU_SUP_CENTAUR_64)	+= centaur_64.o
+obj-$(CONFIG_CPU_SUP_TRANSMETA_32)	+= transmeta.o
+obj-$(CONFIG_CPU_SUP_UMC_32)		+= umc.o
 
 obj-$(CONFIG_X86_MCE)	+= mcheck/
 obj-$(CONFIG_MTRR)	+= mtrr/
 obj-$(CONFIG_CPU_FREQ)	+= cpufreq/
 
 obj-$(CONFIG_X86_LOCAL_APIC) += perfctr-watchdog.o
+
+quiet_cmd_mkcapflags = MKCAP   $@
+      cmd_mkcapflags = $(PERL) $(srctree)/$(src)/mkcapflags.pl $< $@
+
+cpufeature = $(src)/../../../../include/asm-x86/cpufeature.h
+
+targets += capflags.c
+$(obj)/capflags.c: $(cpufeature) $(src)/mkcapflags.pl FORCE
+	$(call if_changed,mkcapflags)
diff --git a/arch/x86/kernel/cpu/addon_cpuid_features.c b/arch/x86/kernel/cpu/addon_cpuid_features.c
index a6ef672..0d9c993 100644
--- a/arch/x86/kernel/cpu/addon_cpuid_features.c
+++ b/arch/x86/kernel/cpu/addon_cpuid_features.c
@@ -7,6 +7,8 @@
 #include <asm/pat.h>
 #include <asm/processor.h>
 
+#include <mach_apic.h>
+
 struct cpuid_bit {
 	u16 feature;
 	u8 reg;
@@ -48,6 +50,92 @@ void __cpuinit init_scattered_cpuid_features(struct cpuinfo_x86 *c)
 	}
 }
 
+/* leaf 0xb SMT level */
+#define SMT_LEVEL	0
+
+/* leaf 0xb sub-leaf types */
+#define INVALID_TYPE	0
+#define SMT_TYPE	1
+#define CORE_TYPE	2
+
+#define LEAFB_SUBTYPE(ecx)		(((ecx) >> 8) & 0xff)
+#define BITS_SHIFT_NEXT_LEVEL(eax)	((eax) & 0x1f)
+#define LEVEL_MAX_SIBLINGS(ebx)		((ebx) & 0xffff)
+
+/*
+ * Check for extended topology enumeration cpuid leaf 0xb and if it
+ * exists, use it for populating initial_apicid and cpu topology
+ * detection.
+ */
+void __cpuinit detect_extended_topology(struct cpuinfo_x86 *c)
+{
+#ifdef CONFIG_SMP
+	unsigned int eax, ebx, ecx, edx, sub_index;
+	unsigned int ht_mask_width, core_plus_mask_width;
+	unsigned int core_select_mask, core_level_siblings;
+
+	if (c->cpuid_level < 0xb)
+		return;
+
+	cpuid_count(0xb, SMT_LEVEL, &eax, &ebx, &ecx, &edx);
+
+	/*
+	 * check if the cpuid leaf 0xb is actually implemented.
+	 */
+	if (ebx == 0 || (LEAFB_SUBTYPE(ecx) != SMT_TYPE))
+		return;
+
+	set_cpu_cap(c, X86_FEATURE_XTOPOLOGY);
+
+	/*
+	 * initial apic id, which also represents 32-bit extended x2apic id.
+	 */
+	c->initial_apicid = edx;
+
+	/*
+	 * Populate HT related information from sub-leaf level 0.
+	 */
+	core_level_siblings = smp_num_siblings = LEVEL_MAX_SIBLINGS(ebx);
+	core_plus_mask_width = ht_mask_width = BITS_SHIFT_NEXT_LEVEL(eax);
+
+	sub_index = 1;
+	do {
+		cpuid_count(0xb, sub_index, &eax, &ebx, &ecx, &edx);
+
+		/*
+		 * Check for the Core type in the implemented sub leaves.
+		 */
+		if (LEAFB_SUBTYPE(ecx) == CORE_TYPE) {
+			core_level_siblings = LEVEL_MAX_SIBLINGS(ebx);
+			core_plus_mask_width = BITS_SHIFT_NEXT_LEVEL(eax);
+			break;
+		}
+
+		sub_index++;
+	} while (LEAFB_SUBTYPE(ecx) != INVALID_TYPE);
+
+	core_select_mask = (~(-1 << core_plus_mask_width)) >> ht_mask_width;
+
+#ifdef CONFIG_X86_32
+	c->cpu_core_id = phys_pkg_id(c->initial_apicid, ht_mask_width)
+						 & core_select_mask;
+	c->phys_proc_id = phys_pkg_id(c->initial_apicid, core_plus_mask_width);
+#else
+	c->cpu_core_id = phys_pkg_id(ht_mask_width) & core_select_mask;
+	c->phys_proc_id = phys_pkg_id(core_plus_mask_width);
+#endif
+	c->x86_max_cores = (core_level_siblings / smp_num_siblings);
+
+
+	printk(KERN_INFO  "CPU: Physical Processor ID: %d\n",
+	       c->phys_proc_id);
+	if (c->x86_max_cores > 1)
+		printk(KERN_INFO  "CPU: Processor Core ID: %d\n",
+		       c->cpu_core_id);
+	return;
+#endif
+}
+
 #ifdef CONFIG_X86_PAT
 void __cpuinit validate_pat_support(struct cpuinfo_x86 *c)
 {
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 18514ed..32e7352 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -1,13 +1,22 @@
 #include <linux/init.h>
 #include <linux/bitops.h>
 #include <linux/mm.h>
+
 #include <asm/io.h>
 #include <asm/processor.h>
 #include <asm/apic.h>
 
+#ifdef CONFIG_X86_64
+# include <asm/numa_64.h>
+# include <asm/mmconfig.h>
+# include <asm/cacheflush.h>
+#endif
+
 #include <mach_apic.h>
+
 #include "cpu.h"
 
+#ifdef CONFIG_X86_32
 /*
  *	B step AMD K6 before B 9730xxxx have hardware bugs that can cause
  *	misexecution of code under Linux. Owners of such processors should
@@ -24,26 +33,273 @@
 extern void vide(void);
 __asm__(".align 4\nvide: ret");
 
-static void __cpuinit early_init_amd(struct cpuinfo_x86 *c)
+static void __cpuinit init_amd_k5(struct cpuinfo_x86 *c)
 {
-	if (cpuid_eax(0x80000000) >= 0x80000007) {
-		c->x86_power = cpuid_edx(0x80000007);
-		if (c->x86_power & (1<<8))
-			set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
+/*
+ * General Systems BIOSen alias the cpu frequency registers
+ * of the Elan at 0x000df000. Unfortuantly, one of the Linux
+ * drivers subsequently pokes it, and changes the CPU speed.
+ * Workaround : Remove the unneeded alias.
+ */
+#define CBAR		(0xfffc) /* Configuration Base Address  (32-bit) */
+#define CBAR_ENB	(0x80000000)
+#define CBAR_KEY	(0X000000CB)
+	if (c->x86_model == 9 || c->x86_model == 10) {
+		if (inl (CBAR) & CBAR_ENB)
+			outl (0 | CBAR_KEY, CBAR);
 	}
-
-	/*  Set MTRR capability flag if appropriate */
-	if (c->x86_model == 13 || c->x86_model == 9 ||
-	   (c->x86_model == 8 && c->x86_mask >= 8))
-		set_cpu_cap(c, X86_FEATURE_K6_MTRR);
 }
 
-static void __cpuinit init_amd(struct cpuinfo_x86 *c)
+
+static void __cpuinit init_amd_k6(struct cpuinfo_x86 *c)
 {
 	u32 l, h;
 	int mbytes = num_physpages >> (20-PAGE_SHIFT);
-	int r;
 
+	if (c->x86_model < 6) {
+		/* Based on AMD doc 20734R - June 2000 */
+		if (c->x86_model == 0) {
+			clear_cpu_cap(c, X86_FEATURE_APIC);
+			set_cpu_cap(c, X86_FEATURE_PGE);
+		}
+		return;
+	}
+
+	if (c->x86_model == 6 && c->x86_mask == 1) {
+		const int K6_BUG_LOOP = 1000000;
+		int n;
+		void (*f_vide)(void);
+		unsigned long d, d2;
+
+		printk(KERN_INFO "AMD K6 stepping B detected - ");
+
+		/*
+		 * It looks like AMD fixed the 2.6.2 bug and improved indirect
+		 * calls at the same time.
+		 */
+
+		n = K6_BUG_LOOP;
+		f_vide = vide;
+		rdtscl(d);
+		while (n--)
+			f_vide();
+		rdtscl(d2);
+		d = d2-d;
+
+		if (d > 20*K6_BUG_LOOP)
+			printk("system stability may be impaired when more than 32 MB are used.\n");
+		else
+			printk("probably OK (after B9730xxxx).\n");
+		printk(KERN_INFO "Please see http://membres.lycos.fr/poulot/k6bug.html\n");
+	}
+
+	/* K6 with old style WHCR */
+	if (c->x86_model < 8 ||
+	   (c->x86_model == 8 && c->x86_mask < 8)) {
+		/* We can only write allocate on the low 508Mb */
+		if (mbytes > 508)
+			mbytes = 508;
+
+		rdmsr(MSR_K6_WHCR, l, h);
+		if ((l&0x0000FFFF) == 0) {
+			unsigned long flags;
+			l = (1<<0)|((mbytes/4)<<1);
+			local_irq_save(flags);
+			wbinvd();
+			wrmsr(MSR_K6_WHCR, l, h);
+			local_irq_restore(flags);
+			printk(KERN_INFO "Enabling old style K6 write allocation for %d Mb\n",
+				mbytes);
+		}
+		return;
+	}
+
+	if ((c->x86_model == 8 && c->x86_mask > 7) ||
+	     c->x86_model == 9 || c->x86_model == 13) {
+		/* The more serious chips .. */
+
+		if (mbytes > 4092)
+			mbytes = 4092;
+
+		rdmsr(MSR_K6_WHCR, l, h);
+		if ((l&0xFFFF0000) == 0) {
+			unsigned long flags;
+			l = ((mbytes>>2)<<22)|(1<<16);
+			local_irq_save(flags);
+			wbinvd();
+			wrmsr(MSR_K6_WHCR, l, h);
+			local_irq_restore(flags);
+			printk(KERN_INFO "Enabling new style K6 write allocation for %d Mb\n",
+				mbytes);
+		}
+
+		return;
+	}
+
+	if (c->x86_model == 10) {
+		/* AMD Geode LX is model 10 */
+		/* placeholder for any needed mods */
+		return;
+	}
+}
+
+static void __cpuinit init_amd_k7(struct cpuinfo_x86 *c)
+{
+	u32 l, h;
+
+	/*
+	 * Bit 15 of Athlon specific MSR 15, needs to be 0
+	 * to enable SSE on Palomino/Morgan/Barton CPU's.
+	 * If the BIOS didn't enable it already, enable it here.
+	 */
+	if (c->x86_model >= 6 && c->x86_model <= 10) {
+		if (!cpu_has(c, X86_FEATURE_XMM)) {
+			printk(KERN_INFO "Enabling disabled K7/SSE Support.\n");
+			rdmsr(MSR_K7_HWCR, l, h);
+			l &= ~0x00008000;
+			wrmsr(MSR_K7_HWCR, l, h);
+			set_cpu_cap(c, X86_FEATURE_XMM);
+		}
+	}
+
+	/*
+	 * It's been determined by AMD that Athlons since model 8 stepping 1
+	 * are more robust with CLK_CTL set to 200xxxxx instead of 600xxxxx
+	 * As per AMD technical note 27212 0.2
+	 */
+	if ((c->x86_model == 8 && c->x86_mask >= 1) || (c->x86_model > 8)) {
+		rdmsr(MSR_K7_CLK_CTL, l, h);
+		if ((l & 0xfff00000) != 0x20000000) {
+			printk ("CPU: CLK_CTL MSR was %x. Reprogramming to %x\n", l,
+				((l & 0x000fffff)|0x20000000));
+			wrmsr(MSR_K7_CLK_CTL, (l & 0x000fffff)|0x20000000, h);
+		}
+	}
+
+	set_cpu_cap(c, X86_FEATURE_K7);
+}
+#endif
+
+#if defined(CONFIG_NUMA) && defined(CONFIG_X86_64)
+static int __cpuinit nearby_node(int apicid)
+{
+	int i, node;
+
+	for (i = apicid - 1; i >= 0; i--) {
+		node = apicid_to_node[i];
+		if (node != NUMA_NO_NODE && node_online(node))
+			return node;
+	}
+	for (i = apicid + 1; i < MAX_LOCAL_APIC; i++) {
+		node = apicid_to_node[i];
+		if (node != NUMA_NO_NODE && node_online(node))
+			return node;
+	}
+	return first_node(node_online_map); /* Shouldn't happen */
+}
+#endif
+
+/*
+ * On a AMD dual core setup the lower bits of the APIC id distingush the cores.
+ * Assumes number of cores is a power of two.
+ */
+static void __cpuinit amd_detect_cmp(struct cpuinfo_x86 *c)
+{
+#ifdef CONFIG_X86_HT
+	unsigned bits;
+
+	bits = c->x86_coreid_bits;
+
+	/* Low order bits define the core id (index of core in socket) */
+	c->cpu_core_id = c->initial_apicid & ((1 << bits)-1);
+	/* Convert the initial APIC ID into the socket ID */
+	c->phys_proc_id = c->initial_apicid >> bits;
+#endif
+}
+
+static void __cpuinit srat_detect_node(struct cpuinfo_x86 *c)
+{
+#if defined(CONFIG_NUMA) && defined(CONFIG_X86_64)
+	int cpu = smp_processor_id();
+	int node;
+	unsigned apicid = hard_smp_processor_id();
+
+	node = c->phys_proc_id;
+	if (apicid_to_node[apicid] != NUMA_NO_NODE)
+		node = apicid_to_node[apicid];
+	if (!node_online(node)) {
+		/* Two possibilities here:
+		   - The CPU is missing memory and no node was created.
+		   In that case try picking one from a nearby CPU
+		   - The APIC IDs differ from the HyperTransport node IDs
+		   which the K8 northbridge parsing fills in.
+		   Assume they are all increased by a constant offset,
+		   but in the same order as the HT nodeids.
+		   If that doesn't result in a usable node fall back to the
+		   path for the previous case.  */
+
+		int ht_nodeid = c->initial_apicid;
+
+		if (ht_nodeid >= 0 &&
+		    apicid_to_node[ht_nodeid] != NUMA_NO_NODE)
+			node = apicid_to_node[ht_nodeid];
+		/* Pick a nearby node */
+		if (!node_online(node))
+			node = nearby_node(apicid);
+	}
+	numa_set_node(cpu, node);
+
+	printk(KERN_INFO "CPU %d/%x -> Node %d\n", cpu, apicid, node);
+#endif
+}
+
+static void __cpuinit early_init_amd_mc(struct cpuinfo_x86 *c)
+{
+#ifdef CONFIG_X86_HT
+	unsigned bits, ecx;
+
+	/* Multi core CPU? */
+	if (c->extended_cpuid_level < 0x80000008)
+		return;
+
+	ecx = cpuid_ecx(0x80000008);
+
+	c->x86_max_cores = (ecx & 0xff) + 1;
+
+	/* CPU telling us the core id bits shift? */
+	bits = (ecx >> 12) & 0xF;
+
+	/* Otherwise recompute */
+	if (bits == 0) {
+		while ((1 << bits) < c->x86_max_cores)
+			bits++;
+	}
+
+	c->x86_coreid_bits = bits;
+#endif
+}
+
+static void __cpuinit early_init_amd(struct cpuinfo_x86 *c)
+{
+	early_init_amd_mc(c);
+
+	/* c->x86_power is 8000_0007 edx. Bit 8 is constant TSC */
+	if (c->x86_power & (1<<8))
+		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
+
+#ifdef CONFIG_X86_64
+	set_cpu_cap(c, X86_FEATURE_SYSCALL32);
+#else
+	/*  Set MTRR capability flag if appropriate */
+	if (c->x86 == 5)
+		if (c->x86_model == 13 || c->x86_model == 9 ||
+		    (c->x86_model == 8 && c->x86_mask >= 8))
+			set_cpu_cap(c, X86_FEATURE_K6_MTRR);
+#endif
+}
+
+static void __cpuinit init_amd(struct cpuinfo_x86 *c)
+{
 #ifdef CONFIG_SMP
 	unsigned long long value;
 
@@ -54,7 +310,7 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 	 * Errata 63 for SH-B3 steppings
 	 * Errata 122 for all steppings (F+ have it disabled by default)
 	 */
-	if (c->x86 == 15) {
+	if (c->x86 == 0xf) {
 		rdmsrl(MSR_K7_HWCR, value);
 		value |= 1 << 6;
 		wrmsrl(MSR_K7_HWCR, value);
@@ -64,209 +320,119 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 	early_init_amd(c);
 
 	/*
-	 *	FIXME: We should handle the K5 here. Set up the write
-	 *	range and also turn on MSR 83 bits 4 and 31 (write alloc,
-	 *	no bus pipeline)
-	 */
-
-	/*
 	 * Bit 31 in normal CPUID used for nonstandard 3DNow ID;
 	 * 3DNow is IDd by bit 31 in extended CPUID (1*32+31) anyway
 	 */
 	clear_cpu_cap(c, 0*32+31);
 
-	r = get_model_name(c);
+#ifdef CONFIG_X86_64
+	/* On C+ stepping K8 rep microcode works well for copy/memset */
+	if (c->x86 == 0xf) {
+		u32 level;
 
-	switch (c->x86) {
-	case 4:
-		/*
-		 * General Systems BIOSen alias the cpu frequency registers
-		 * of the Elan at 0x000df000. Unfortuantly, one of the Linux
-		 * drivers subsequently pokes it, and changes the CPU speed.
-		 * Workaround : Remove the unneeded alias.
-		 */
-#define CBAR		(0xfffc) /* Configuration Base Address  (32-bit) */
-#define CBAR_ENB	(0x80000000)
-#define CBAR_KEY	(0X000000CB)
-			if (c->x86_model == 9 || c->x86_model == 10) {
-				if (inl (CBAR) & CBAR_ENB)
-					outl (0 | CBAR_KEY, CBAR);
-			}
-			break;
-	case 5:
-			if (c->x86_model < 6) {
-				/* Based on AMD doc 20734R - June 2000 */
-				if (c->x86_model == 0) {
-					clear_cpu_cap(c, X86_FEATURE_APIC);
-					set_cpu_cap(c, X86_FEATURE_PGE);
-				}
-				break;
-			}
-
-			if (c->x86_model == 6 && c->x86_mask == 1) {
-				const int K6_BUG_LOOP = 1000000;
-				int n;
-				void (*f_vide)(void);
-				unsigned long d, d2;
-
-				printk(KERN_INFO "AMD K6 stepping B detected - ");
-
-				/*
-				 * It looks like AMD fixed the 2.6.2 bug and improved indirect
-				 * calls at the same time.
-				 */
-
-				n = K6_BUG_LOOP;
-				f_vide = vide;
-				rdtscl(d);
-				while (n--)
-					f_vide();
-				rdtscl(d2);
-				d = d2-d;
-
-				if (d > 20*K6_BUG_LOOP)
-					printk("system stability may be impaired when more than 32 MB are used.\n");
-				else
-					printk("probably OK (after B9730xxxx).\n");
-				printk(KERN_INFO "Please see http://membres.lycos.fr/poulot/k6bug.html\n");
-			}
-
-			/* K6 with old style WHCR */
-			if (c->x86_model < 8 ||
-			   (c->x86_model == 8 && c->x86_mask < 8)) {
-				/* We can only write allocate on the low 508Mb */
-				if (mbytes > 508)
-					mbytes = 508;
-
-				rdmsr(MSR_K6_WHCR, l, h);
-				if ((l&0x0000FFFF) == 0) {
-					unsigned long flags;
-					l = (1<<0)|((mbytes/4)<<1);
-					local_irq_save(flags);
-					wbinvd();
-					wrmsr(MSR_K6_WHCR, l, h);
-					local_irq_restore(flags);
-					printk(KERN_INFO "Enabling old style K6 write allocation for %d Mb\n",
-						mbytes);
-				}
-				break;
-			}
-
-			if ((c->x86_model == 8 && c->x86_mask > 7) ||
-			     c->x86_model == 9 || c->x86_model == 13) {
-				/* The more serious chips .. */
-
-				if (mbytes > 4092)
-					mbytes = 4092;
-
-				rdmsr(MSR_K6_WHCR, l, h);
-				if ((l&0xFFFF0000) == 0) {
-					unsigned long flags;
-					l = ((mbytes>>2)<<22)|(1<<16);
-					local_irq_save(flags);
-					wbinvd();
-					wrmsr(MSR_K6_WHCR, l, h);
-					local_irq_restore(flags);
-					printk(KERN_INFO "Enabling new style K6 write allocation for %d Mb\n",
-						mbytes);
-				}
-
-				break;
-			}
-
-			if (c->x86_model == 10) {
-				/* AMD Geode LX is model 10 */
-				/* placeholder for any needed mods */
-				break;
-			}
-			break;
-	case 6: /* An Athlon/Duron */
-
-			/*
-			 * Bit 15 of Athlon specific MSR 15, needs to be 0
-			 * to enable SSE on Palomino/Morgan/Barton CPU's.
-			 * If the BIOS didn't enable it already, enable it here.
-			 */
-			if (c->x86_model >= 6 && c->x86_model <= 10) {
-				if (!cpu_has(c, X86_FEATURE_XMM)) {
-					printk(KERN_INFO "Enabling disabled K7/SSE Support.\n");
-					rdmsr(MSR_K7_HWCR, l, h);
-					l &= ~0x00008000;
-					wrmsr(MSR_K7_HWCR, l, h);
-					set_cpu_cap(c, X86_FEATURE_XMM);
-				}
-			}
-
-			/*
-			 * It's been determined by AMD that Athlons since model 8 stepping 1
-			 * are more robust with CLK_CTL set to 200xxxxx instead of 600xxxxx
-			 * As per AMD technical note 27212 0.2
-			 */
-			if ((c->x86_model == 8 && c->x86_mask >= 1) || (c->x86_model > 8)) {
-				rdmsr(MSR_K7_CLK_CTL, l, h);
-				if ((l & 0xfff00000) != 0x20000000) {
-					printk ("CPU: CLK_CTL MSR was %x. Reprogramming to %x\n", l,
-						((l & 0x000fffff)|0x20000000));
-					wrmsr(MSR_K7_CLK_CTL, (l & 0x000fffff)|0x20000000, h);
-				}
-			}
-			break;
+		level = cpuid_eax(1);
+		if((level >= 0x0f48 && level < 0x0f50) || level >= 0x0f58)
+			set_cpu_cap(c, X86_FEATURE_REP_GOOD);
 	}
+	if (c->x86 == 0x10 || c->x86 == 0x11)
+		set_cpu_cap(c, X86_FEATURE_REP_GOOD);
+#else
+
+	/*
+	 *	FIXME: We should handle the K5 here. Set up the write
+	 *	range and also turn on MSR 83 bits 4 and 31 (write alloc,
+	 *	no bus pipeline)
+	 */
 
 	switch (c->x86) {
-	case 15:
-	/* Use K8 tuning for Fam10h and Fam11h */
-	case 0x10:
-	case 0x11:
-		set_cpu_cap(c, X86_FEATURE_K8);
+	case 4:
+		init_amd_k5(c);
 		break;
-	case 6:
-		set_cpu_cap(c, X86_FEATURE_K7);
+	case 5:
+		init_amd_k6(c);
+		break;
+	case 6: /* An Athlon/Duron */
+		init_amd_k7(c);
 		break;
 	}
+
+	/* K6s reports MCEs but don't actually have all the MSRs */
+	if (c->x86 < 6)
+		clear_cpu_cap(c, X86_FEATURE_MCE);
+#endif
+
+	/* Enable workaround for FXSAVE leak */
 	if (c->x86 >= 6)
 		set_cpu_cap(c, X86_FEATURE_FXSAVE_LEAK);
 
-	display_cacheinfo(c);
-
-	if (cpuid_eax(0x80000000) >= 0x80000008)
-		c->x86_max_cores = (cpuid_ecx(0x80000008) & 0xff) + 1;
+	if (!c->x86_model_id[0]) {
+		switch (c->x86) {
+		case 0xf:
+			/* Should distinguish Models here, but this is only
+			   a fallback anyways. */
+			strcpy(c->x86_model_id, "Hammer");
+			break;
+		}
+	}
 
-#ifdef CONFIG_X86_HT
-	/*
-	 * On a AMD multi core setup the lower bits of the APIC id
-	 * distinguish the cores.
-	 */
-	if (c->x86_max_cores > 1) {
-		int cpu = smp_processor_id();
-		unsigned bits = (cpuid_ecx(0x80000008) >> 12) & 0xf;
+	display_cacheinfo(c);
 
-		if (bits == 0) {
-			while ((1 << bits) < c->x86_max_cores)
-				bits++;
-		}
-		c->cpu_core_id = c->phys_proc_id & ((1<<bits)-1);
-		c->phys_proc_id >>= bits;
-		printk(KERN_INFO "CPU %d(%d) -> Core %d\n",
-		       cpu, c->x86_max_cores, c->cpu_core_id);
+	/* Multi core CPU? */
+	if (c->extended_cpuid_level >= 0x80000008) {
+		amd_detect_cmp(c);
+		srat_detect_node(c);
 	}
+
+#ifdef CONFIG_X86_32
+	detect_ht(c);
 #endif
 
-	if (cpuid_eax(0x80000000) >= 0x80000006) {
-		if ((c->x86 == 0x10) && (cpuid_edx(0x80000006) & 0xf000))
+	if (c->extended_cpuid_level >= 0x80000006) {
+		if ((c->x86 >= 0x0f) && (cpuid_edx(0x80000006) & 0xf000))
 			num_cache_leaves = 4;
 		else
 			num_cache_leaves = 3;
 	}
 
-	/* K6s reports MCEs but don't actually have all the MSRs */
-	if (c->x86 < 6)
-		clear_cpu_cap(c, X86_FEATURE_MCE);
+	if (c->x86 >= 0xf && c->x86 <= 0x11)
+		set_cpu_cap(c, X86_FEATURE_K8);
 
-	if (cpu_has_xmm2)
+	if (cpu_has_xmm2) {
+		/* MFENCE stops RDTSC speculation */
 		set_cpu_cap(c, X86_FEATURE_MFENCE_RDTSC);
+	}
+
+#ifdef CONFIG_X86_64
+	if (c->x86 == 0x10) {
+		/* do this for boot cpu */
+		if (c == &boot_cpu_data)
+			check_enable_amd_mmconf_dmi();
+
+		fam10h_check_enable_mmcfg();
+	}
+
+	if (c == &boot_cpu_data && c->x86 >= 0xf && c->x86 <= 0x11) {
+		unsigned long long tseg;
+
+		/*
+		 * Split up direct mapping around the TSEG SMM area.
+		 * Don't do it for gbpages because there seems very little
+		 * benefit in doing so.
+		 */
+		if (!rdmsrl_safe(MSR_K8_TSEG_ADDR, &tseg)) {
+		    printk(KERN_DEBUG "tseg: %010llx\n", tseg);
+		    if ((tseg>>PMD_SHIFT) <
+				(max_low_pfn_mapped>>(PMD_SHIFT-PAGE_SHIFT)) ||
+			((tseg>>PMD_SHIFT) <
+				(max_pfn_mapped>>(PMD_SHIFT-PAGE_SHIFT)) &&
+			 (tseg>>PMD_SHIFT) >= (1ULL<<(32 - PMD_SHIFT))))
+			set_memory_4k((unsigned long)__va(tseg), 1);
+		}
+	}
+#endif
 }
 
+#ifdef CONFIG_X86_32
 static unsigned int __cpuinit amd_size_cache(struct cpuinfo_x86 *c, unsigned int size)
 {
 	/* AMD errata T13 (order #21922) */
@@ -279,10 +445,12 @@ static unsigned int __cpuinit amd_size_cache(struct cpuinfo_x86 *c, unsigned int
 	}
 	return size;
 }
+#endif
 
 static struct cpu_dev amd_cpu_dev __cpuinitdata = {
 	.c_vendor	= "AMD",
 	.c_ident	= { "AuthenticAMD" },
+#ifdef CONFIG_X86_32
 	.c_models = {
 		{ .vendor = X86_VENDOR_AMD, .family = 4, .model_names =
 		  {
@@ -295,9 +463,11 @@ static struct cpu_dev amd_cpu_dev __cpuinitdata = {
 		  }
 		},
 	},
+	.c_size_cache	= amd_size_cache,
+#endif
 	.c_early_init   = early_init_amd,
 	.c_init		= init_amd,
-	.c_size_cache	= amd_size_cache,
+	.c_x86_vendor	= X86_VENDOR_AMD,
 };
 
-cpu_vendor_dev_register(X86_VENDOR_AMD, &amd_cpu_dev);
+cpu_dev_register(amd_cpu_dev);
diff --git a/arch/x86/kernel/cpu/amd_64.c b/arch/x86/kernel/cpu/amd_64.c
deleted file mode 100644
index d1692b2..0000000
--- a/arch/x86/kernel/cpu/amd_64.c
+++ /dev/null
@@ -1,224 +0,0 @@
-#include <linux/init.h>
-#include <linux/mm.h>
-
-#include <asm/numa_64.h>
-#include <asm/mmconfig.h>
-#include <asm/cacheflush.h>
-
-#include <mach_apic.h>
-
-#include "cpu.h"
-
-int force_mwait __cpuinitdata;
-
-#ifdef CONFIG_NUMA
-static int __cpuinit nearby_node(int apicid)
-{
-	int i, node;
-
-	for (i = apicid - 1; i >= 0; i--) {
-		node = apicid_to_node[i];
-		if (node != NUMA_NO_NODE && node_online(node))
-			return node;
-	}
-	for (i = apicid + 1; i < MAX_LOCAL_APIC; i++) {
-		node = apicid_to_node[i];
-		if (node != NUMA_NO_NODE && node_online(node))
-			return node;
-	}
-	return first_node(node_online_map); /* Shouldn't happen */
-}
-#endif
-
-/*
- * On a AMD dual core setup the lower bits of the APIC id distingush the cores.
- * Assumes number of cores is a power of two.
- */
-static void __cpuinit amd_detect_cmp(struct cpuinfo_x86 *c)
-{
-#ifdef CONFIG_SMP
-	unsigned bits;
-#ifdef CONFIG_NUMA
-	int cpu = smp_processor_id();
-	int node = 0;
-	unsigned apicid = hard_smp_processor_id();
-#endif
-	bits = c->x86_coreid_bits;
-
-	/* Low order bits define the core id (index of core in socket) */
-	c->cpu_core_id = c->initial_apicid & ((1 << bits)-1);
-	/* Convert the initial APIC ID into the socket ID */
-	c->phys_proc_id = c->initial_apicid >> bits;
-
-#ifdef CONFIG_NUMA
-	node = c->phys_proc_id;
-	if (apicid_to_node[apicid] != NUMA_NO_NODE)
-		node = apicid_to_node[apicid];
-	if (!node_online(node)) {
-		/* Two possibilities here:
-		   - The CPU is missing memory and no node was created.
-		   In that case try picking one from a nearby CPU
-		   - The APIC IDs differ from the HyperTransport node IDs
-		   which the K8 northbridge parsing fills in.
-		   Assume they are all increased by a constant offset,
-		   but in the same order as the HT nodeids.
-		   If that doesn't result in a usable node fall back to the
-		   path for the previous case.  */
-
-		int ht_nodeid = c->initial_apicid;
-
-		if (ht_nodeid >= 0 &&
-		    apicid_to_node[ht_nodeid] != NUMA_NO_NODE)
-			node = apicid_to_node[ht_nodeid];
-		/* Pick a nearby node */
-		if (!node_online(node))
-			node = nearby_node(apicid);
-	}
-	numa_set_node(cpu, node);
-
-	printk(KERN_INFO "CPU %d/%x -> Node %d\n", cpu, apicid, node);
-#endif
-#endif
-}
-
-static void __cpuinit early_init_amd_mc(struct cpuinfo_x86 *c)
-{
-#ifdef CONFIG_SMP
-	unsigned bits, ecx;
-
-	/* Multi core CPU? */
-	if (c->extended_cpuid_level < 0x80000008)
-		return;
-
-	ecx = cpuid_ecx(0x80000008);
-
-	c->x86_max_cores = (ecx & 0xff) + 1;
-
-	/* CPU telling us the core id bits shift? */
-	bits = (ecx >> 12) & 0xF;
-
-	/* Otherwise recompute */
-	if (bits == 0) {
-		while ((1 << bits) < c->x86_max_cores)
-			bits++;
-	}
-
-	c->x86_coreid_bits = bits;
-
-#endif
-}
-
-static void __cpuinit early_init_amd(struct cpuinfo_x86 *c)
-{
-	early_init_amd_mc(c);
-
-	/* c->x86_power is 8000_0007 edx. Bit 8 is constant TSC */
-	if (c->x86_power & (1<<8))
-		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
-
-	set_cpu_cap(c, X86_FEATURE_SYSCALL32);
-}
-
-static void __cpuinit init_amd(struct cpuinfo_x86 *c)
-{
-	unsigned level;
-
-#ifdef CONFIG_SMP
-	unsigned long value;
-
-	/*
-	 * Disable TLB flush filter by setting HWCR.FFDIS on K8
-	 * bit 6 of msr C001_0015
-	 *
-	 * Errata 63 for SH-B3 steppings
-	 * Errata 122 for all steppings (F+ have it disabled by default)
-	 */
-	if (c->x86 == 0xf) {
-		rdmsrl(MSR_K8_HWCR, value);
-		value |= 1 << 6;
-		wrmsrl(MSR_K8_HWCR, value);
-	}
-#endif
-
-	/* Bit 31 in normal CPUID used for nonstandard 3DNow ID;
-	   3DNow is IDd by bit 31 in extended CPUID (1*32+31) anyway */
-	clear_cpu_cap(c, 0*32+31);
-
-	/* On C+ stepping K8 rep microcode works well for copy/memset */
-	if (c->x86 == 0xf) {
-		level = cpuid_eax(1);
-		if((level >= 0x0f48 && level < 0x0f50) || level >= 0x0f58)
-			set_cpu_cap(c, X86_FEATURE_REP_GOOD);
-	}
-	if (c->x86 == 0x10 || c->x86 == 0x11)
-		set_cpu_cap(c, X86_FEATURE_REP_GOOD);
-
-	/* Enable workaround for FXSAVE leak */
-	if (c->x86 >= 6)
-		set_cpu_cap(c, X86_FEATURE_FXSAVE_LEAK);
-
-	level = get_model_name(c);
-	if (!level) {
-		switch (c->x86) {
-		case 0xf:
-			/* Should distinguish Models here, but this is only
-			   a fallback anyways. */
-			strcpy(c->x86_model_id, "Hammer");
-			break;
-		}
-	}
-	display_cacheinfo(c);
-
-	/* Multi core CPU? */
-	if (c->extended_cpuid_level >= 0x80000008)
-		amd_detect_cmp(c);
-
-	if (c->extended_cpuid_level >= 0x80000006 &&
-		(cpuid_edx(0x80000006) & 0xf000))
-		num_cache_leaves = 4;
-	else
-		num_cache_leaves = 3;
-
-	if (c->x86 >= 0xf && c->x86 <= 0x11)
-		set_cpu_cap(c, X86_FEATURE_K8);
-
-	/* MFENCE stops RDTSC speculation */
-	set_cpu_cap(c, X86_FEATURE_MFENCE_RDTSC);
-
-	if (c->x86 == 0x10) {
-		/* do this for boot cpu */
-		if (c == &boot_cpu_data)
-			check_enable_amd_mmconf_dmi();
-
-		fam10h_check_enable_mmcfg();
-	}
-
-	if (c == &boot_cpu_data && c->x86 >= 0xf && c->x86 <= 0x11) {
-		unsigned long long tseg;
-
-		/*
-		 * Split up direct mapping around the TSEG SMM area.
-		 * Don't do it for gbpages because there seems very little
-		 * benefit in doing so.
-		 */
-		if (!rdmsrl_safe(MSR_K8_TSEG_ADDR, &tseg)) {
-		    printk(KERN_DEBUG "tseg: %010llx\n", tseg);
-		    if ((tseg>>PMD_SHIFT) <
-				(max_low_pfn_mapped>>(PMD_SHIFT-PAGE_SHIFT)) ||
-			((tseg>>PMD_SHIFT) <
-				(max_pfn_mapped>>(PMD_SHIFT-PAGE_SHIFT)) &&
-			 (tseg>>PMD_SHIFT) >= (1ULL<<(32 - PMD_SHIFT))))
-			set_memory_4k((unsigned long)__va(tseg), 1);
-		}
-	}
-}
-
-static struct cpu_dev amd_cpu_dev __cpuinitdata = {
-	.c_vendor	= "AMD",
-	.c_ident	= { "AuthenticAMD" },
-	.c_early_init   = early_init_amd,
-	.c_init		= init_amd,
-};
-
-cpu_vendor_dev_register(X86_VENDOR_AMD, &amd_cpu_dev);
-
diff --git a/arch/x86/kernel/cpu/centaur.c b/arch/x86/kernel/cpu/centaur.c
index a0534c0..89bfdd9 100644
--- a/arch/x86/kernel/cpu/centaur.c
+++ b/arch/x86/kernel/cpu/centaur.c
@@ -289,7 +289,6 @@ static void __cpuinit init_c3(struct cpuinfo_x86 *c)
 	if (c->x86_model >= 6 && c->x86_model < 9)
 		set_cpu_cap(c, X86_FEATURE_3DNOW);
 
-	get_model_name(c);
 	display_cacheinfo(c);
 }
 
@@ -475,6 +474,7 @@ static struct cpu_dev centaur_cpu_dev __cpuinitdata = {
 	.c_early_init	= early_init_centaur,
 	.c_init		= init_centaur,
 	.c_size_cache	= centaur_size_cache,
+	.c_x86_vendor	= X86_VENDOR_CENTAUR,
 };
 
-cpu_vendor_dev_register(X86_VENDOR_CENTAUR, &centaur_cpu_dev);
+cpu_dev_register(centaur_cpu_dev);
diff --git a/arch/x86/kernel/cpu/centaur_64.c b/arch/x86/kernel/cpu/centaur_64.c
index 1d181c4..a1625f5 100644
--- a/arch/x86/kernel/cpu/centaur_64.c
+++ b/arch/x86/kernel/cpu/centaur_64.c
@@ -16,9 +16,10 @@ static void __cpuinit early_init_centaur(struct cpuinfo_x86 *c)
 
 static void __cpuinit init_centaur(struct cpuinfo_x86 *c)
 {
+	early_init_centaur(c);
+
 	if (c->x86 == 0x6 && c->x86_model >= 0xf) {
 		c->x86_cache_alignment = c->x86_clflush_size * 2;
-		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
 		set_cpu_cap(c, X86_FEATURE_REP_GOOD);
 	}
 	set_cpu_cap(c, X86_FEATURE_LFENCE_RDTSC);
@@ -29,7 +30,8 @@ static struct cpu_dev centaur_cpu_dev __cpuinitdata = {
 	.c_ident	= { "CentaurHauls" },
 	.c_early_init	= early_init_centaur,
 	.c_init		= init_centaur,
+	.c_x86_vendor	= X86_VENDOR_CENTAUR,
 };
 
-cpu_vendor_dev_register(X86_VENDOR_CENTAUR, &centaur_cpu_dev);
+cpu_dev_register(centaur_cpu_dev);
 
diff --git a/arch/x86/kernel/cpu/cmpxchg.c b/arch/x86/kernel/cpu/cmpxchg.c
new file mode 100644
index 0000000..2056ccf
--- /dev/null
+++ b/arch/x86/kernel/cpu/cmpxchg.c
@@ -0,0 +1,72 @@
+/*
+ * cmpxchg*() fallbacks for CPU not supporting these instructions
+ */
+
+#include <linux/kernel.h>
+#include <linux/smp.h>
+#include <linux/module.h>
+
+#ifndef CONFIG_X86_CMPXCHG
+unsigned long cmpxchg_386_u8(volatile void *ptr, u8 old, u8 new)
+{
+	u8 prev;
+	unsigned long flags;
+
+	/* Poor man's cmpxchg for 386. Unsuitable for SMP */
+	local_irq_save(flags);
+	prev = *(u8 *)ptr;
+	if (prev == old)
+		*(u8 *)ptr = new;
+	local_irq_restore(flags);
+	return prev;
+}
+EXPORT_SYMBOL(cmpxchg_386_u8);
+
+unsigned long cmpxchg_386_u16(volatile void *ptr, u16 old, u16 new)
+{
+	u16 prev;
+	unsigned long flags;
+
+	/* Poor man's cmpxchg for 386. Unsuitable for SMP */
+	local_irq_save(flags);
+	prev = *(u16 *)ptr;
+	if (prev == old)
+		*(u16 *)ptr = new;
+	local_irq_restore(flags);
+	return prev;
+}
+EXPORT_SYMBOL(cmpxchg_386_u16);
+
+unsigned long cmpxchg_386_u32(volatile void *ptr, u32 old, u32 new)
+{
+	u32 prev;
+	unsigned long flags;
+
+	/* Poor man's cmpxchg for 386. Unsuitable for SMP */
+	local_irq_save(flags);
+	prev = *(u32 *)ptr;
+	if (prev == old)
+		*(u32 *)ptr = new;
+	local_irq_restore(flags);
+	return prev;
+}
+EXPORT_SYMBOL(cmpxchg_386_u32);
+#endif
+
+#ifndef CONFIG_X86_CMPXCHG64
+unsigned long long cmpxchg_486_u64(volatile void *ptr, u64 old, u64 new)
+{
+	u64 prev;
+	unsigned long flags;
+
+	/* Poor man's cmpxchg8b for 386 and 486. Unsuitable for SMP */
+	local_irq_save(flags);
+	prev = *(u64 *)ptr;
+	if (prev == old)
+		*(u64 *)ptr = new;
+	local_irq_restore(flags);
+	return prev;
+}
+EXPORT_SYMBOL(cmpxchg_486_u64);
+#endif
+
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 4e456bd..7581b62 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1,28 +1,62 @@
 #include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/sched.h>
 #include <linux/string.h>
+#include <linux/bootmem.h>
+#include <linux/bitops.h>
+#include <linux/module.h>
+#include <linux/kgdb.h>
+#include <linux/topology.h>
 #include <linux/delay.h>
 #include <linux/smp.h>
-#include <linux/module.h>
 #include <linux/percpu.h>
-#include <linux/bootmem.h>
-#include <asm/processor.h>
 #include <asm/i387.h>
 #include <asm/msr.h>
 #include <asm/io.h>
+#include <asm/linkage.h>
 #include <asm/mmu_context.h>
 #include <asm/mtrr.h>
 #include <asm/mce.h>
 #include <asm/pat.h>
 #include <asm/asm.h>
+#include <asm/numa.h>
 #ifdef CONFIG_X86_LOCAL_APIC
 #include <asm/mpspec.h>
 #include <asm/apic.h>
 #include <mach_apic.h>
+#include <asm/genapic.h>
 #endif
 
+#include <asm/pda.h>
+#include <asm/pgtable.h>
+#include <asm/processor.h>
+#include <asm/desc.h>
+#include <asm/atomic.h>
+#include <asm/proto.h>
+#include <asm/sections.h>
+#include <asm/setup.h>
+
 #include "cpu.h"
 
+static struct cpu_dev *this_cpu __cpuinitdata;
+
+#ifdef CONFIG_X86_64
+/* We need valid kernel segments for data and code in long mode too
+ * IRET will check the segment types  kkeil 2000/10/28
+ * Also sysret mandates a special GDT layout
+ */
+/* The TLS descriptors are currently at a different place compared to i386.
+   Hopefully nobody expects them at a fixed place (Wine?) */
 DEFINE_PER_CPU(struct gdt_page, gdt_page) = { .gdt = {
+	[GDT_ENTRY_KERNEL32_CS] = { { { 0x0000ffff, 0x00cf9b00 } } },
+	[GDT_ENTRY_KERNEL_CS] = { { { 0x0000ffff, 0x00af9b00 } } },
+	[GDT_ENTRY_KERNEL_DS] = { { { 0x0000ffff, 0x00cf9300 } } },
+	[GDT_ENTRY_DEFAULT_USER32_CS] = { { { 0x0000ffff, 0x00cffb00 } } },
+	[GDT_ENTRY_DEFAULT_USER_DS] = { { { 0x0000ffff, 0x00cff300 } } },
+	[GDT_ENTRY_DEFAULT_USER_CS] = { { { 0x0000ffff, 0x00affb00 } } },
+} };
+#else
+DEFINE_PER_CPU_PAGE_ALIGNED(struct gdt_page, gdt_page) = { .gdt = {
 	[GDT_ENTRY_KERNEL_CS] = { { { 0x0000ffff, 0x00cf9a00 } } },
 	[GDT_ENTRY_KERNEL_DS] = { { { 0x0000ffff, 0x00cf9200 } } },
 	[GDT_ENTRY_DEFAULT_USER_CS] = { { { 0x0000ffff, 0x00cffa00 } } },
@@ -56,17 +90,150 @@ DEFINE_PER_CPU(struct gdt_page, gdt_page) = { .gdt = {
 	[GDT_ENTRY_ESPFIX_SS] = { { { 0x00000000, 0x00c09200 } } },
 	[GDT_ENTRY_PERCPU] = { { { 0x00000000, 0x00000000 } } },
 } };
+#endif
 EXPORT_PER_CPU_SYMBOL_GPL(gdt_page);
 
-__u32 cleared_cpu_caps[NCAPINTS] __cpuinitdata;
-
+#ifdef CONFIG_X86_32
 static int cachesize_override __cpuinitdata = -1;
 static int disable_x86_serial_nr __cpuinitdata = 1;
 
-struct cpu_dev *cpu_devs[X86_VENDOR_NUM] = {};
+static int __init cachesize_setup(char *str)
+{
+	get_option(&str, &cachesize_override);
+	return 1;
+}
+__setup("cachesize=", cachesize_setup);
+
+static int __init x86_fxsr_setup(char *s)
+{
+	setup_clear_cpu_cap(X86_FEATURE_FXSR);
+	setup_clear_cpu_cap(X86_FEATURE_XMM);
+	return 1;
+}
+__setup("nofxsr", x86_fxsr_setup);
+
+static int __init x86_sep_setup(char *s)
+{
+	setup_clear_cpu_cap(X86_FEATURE_SEP);
+	return 1;
+}
+__setup("nosep", x86_sep_setup);
+
+/* Standard macro to see if a specific flag is changeable */
+static inline int flag_is_changeable_p(u32 flag)
+{
+	u32 f1, f2;
+
+	asm("pushfl\n\t"
+	    "pushfl\n\t"
+	    "popl %0\n\t"
+	    "movl %0,%1\n\t"
+	    "xorl %2,%0\n\t"
+	    "pushl %0\n\t"
+	    "popfl\n\t"
+	    "pushfl\n\t"
+	    "popl %0\n\t"
+	    "popfl\n\t"
+	    : "=&r" (f1), "=&r" (f2)
+	    : "ir" (flag));
+
+	return ((f1^f2) & flag) != 0;
+}
+
+/* Probe for the CPUID instruction */
+static int __cpuinit have_cpuid_p(void)
+{
+	return flag_is_changeable_p(X86_EFLAGS_ID);
+}
+
+static void __cpuinit squash_the_stupid_serial_number(struct cpuinfo_x86 *c)
+{
+	if (cpu_has(c, X86_FEATURE_PN) && disable_x86_serial_nr) {
+		/* Disable processor serial number */
+		unsigned long lo, hi;
+		rdmsr(MSR_IA32_BBL_CR_CTL, lo, hi);
+		lo |= 0x200000;
+		wrmsr(MSR_IA32_BBL_CR_CTL, lo, hi);
+		printk(KERN_NOTICE "CPU serial number disabled.\n");
+		clear_cpu_cap(c, X86_FEATURE_PN);
+
+		/* Disabling the serial number may affect the cpuid level */
+		c->cpuid_level = cpuid_eax(0);
+	}
+}
+
+static int __init x86_serial_nr_setup(char *s)
+{
+	disable_x86_serial_nr = 0;
+	return 1;
+}
+__setup("serialnumber", x86_serial_nr_setup);
+#else
+static inline int flag_is_changeable_p(u32 flag)
+{
+	return 1;
+}
+/* Probe for the CPUID instruction */
+static inline int have_cpuid_p(void)
+{
+	return 1;
+}
+static inline void squash_the_stupid_serial_number(struct cpuinfo_x86 *c)
+{
+}
+#endif
+
+/*
+ * Naming convention should be: <Name> [(<Codename>)]
+ * This table only is used unless init_<vendor>() below doesn't set it;
+ * in particular, if CPUID levels 0x80000002..4 are supported, this isn't used
+ *
+ */
+
+/* Look up CPU names by table lookup. */
+static char __cpuinit *table_lookup_model(struct cpuinfo_x86 *c)
+{
+	struct cpu_model_info *info;
+
+	if (c->x86_model >= 16)
+		return NULL;	/* Range check */
+
+	if (!this_cpu)
+		return NULL;
+
+	info = this_cpu->c_models;
+
+	while (info && info->family) {
+		if (info->family == c->x86)
+			return info->model_names[c->x86_model];
+		info++;
+	}
+	return NULL;		/* Not found */
+}
+
+__u32 cleared_cpu_caps[NCAPINTS] __cpuinitdata;
+
+/* Current gdt points %fs at the "master" per-cpu area: after this,
+ * it's on the real one. */
+void switch_to_new_gdt(void)
+{
+	struct desc_ptr gdt_descr;
+
+	gdt_descr.address = (long)get_cpu_gdt_table(smp_processor_id());
+	gdt_descr.size = GDT_SIZE - 1;
+	load_gdt(&gdt_descr);
+#ifdef CONFIG_X86_32
+	asm("mov %0, %%fs" : : "r" (__KERNEL_PERCPU) : "memory");
+#endif
+}
+
+static struct cpu_dev *cpu_devs[X86_VENDOR_NUM] = {};
 
 static void __cpuinit default_init(struct cpuinfo_x86 *c)
 {
+#ifdef CONFIG_X86_64
+	display_cacheinfo(c);
+#else
 	/* Not much we can do here... */
 	/* Check if at least it has cpuid */
 	if (c->cpuid_level == -1) {
@@ -76,28 +243,22 @@ static void __cpuinit default_init(struct cpuinfo_x86 *c)
 		else if (c->x86 == 3)
 			strcpy(c->x86_model_id, "386");
 	}
+#endif
 }
 
 static struct cpu_dev __cpuinitdata default_cpu = {
 	.c_init	= default_init,
 	.c_vendor = "Unknown",
+	.c_x86_vendor = X86_VENDOR_UNKNOWN,
 };
-static struct cpu_dev *this_cpu __cpuinitdata = &default_cpu;
 
-static int __init cachesize_setup(char *str)
-{
-	get_option(&str, &cachesize_override);
-	return 1;
-}
-__setup("cachesize=", cachesize_setup);
-
-int __cpuinit get_model_name(struct cpuinfo_x86 *c)
+static void __cpuinit get_model_name(struct cpuinfo_x86 *c)
 {
 	unsigned int *v;
 	char *p, *q;
 
-	if (cpuid_eax(0x80000000) < 0x80000004)
-		return 0;
+	if (c->extended_cpuid_level < 0x80000004)
+		return;
 
 	v = (unsigned int *) c->x86_model_id;
 	cpuid(0x80000002, &v[0], &v[1], &v[2], &v[3]);
@@ -116,30 +277,34 @@ int __cpuinit get_model_name(struct cpuinfo_x86 *c)
 	     while (q <= &c->x86_model_id[48])
 		  *q++ = '\0';	/* Zero-pad the rest */
 	}
-
-	return 1;
 }
 
-
 void __cpuinit display_cacheinfo(struct cpuinfo_x86 *c)
 {
-	unsigned int n, dummy, ecx, edx, l2size;
+	unsigned int n, dummy, ebx, ecx, edx, l2size;
 
-	n = cpuid_eax(0x80000000);
+	n = c->extended_cpuid_level;
 
 	if (n >= 0x80000005) {
-		cpuid(0x80000005, &dummy, &dummy, &ecx, &edx);
+		cpuid(0x80000005, &dummy, &ebx, &ecx, &edx);
 		printk(KERN_INFO "CPU: L1 I Cache: %dK (%d bytes/line), D cache %dK (%d bytes/line)\n",
-			edx>>24, edx&0xFF, ecx>>24, ecx&0xFF);
-		c->x86_cache_size = (ecx>>24)+(edx>>24);
+				edx>>24, edx&0xFF, ecx>>24, ecx&0xFF);
+		c->x86_cache_size = (ecx>>24) + (edx>>24);
+#ifdef CONFIG_X86_64
+		/* On K8 L1 TLB is inclusive, so don't count it */
+		c->x86_tlbsize = 0;
+#endif
 	}
 
 	if (n < 0x80000006)	/* Some chips just has a large L1. */
 		return;
 
-	ecx = cpuid_ecx(0x80000006);
+	cpuid(0x80000006, &dummy, &ebx, &ecx, &edx);
 	l2size = ecx >> 16;
 
+#ifdef CONFIG_X86_64
+	c->x86_tlbsize += ((ebx >> 16) & 0xfff) + (ebx & 0xfff);
+#else
 	/* do processor-specific cache resizing */
 	if (this_cpu->c_size_cache)
 		l2size = this_cpu->c_size_cache(c, l2size);
@@ -150,116 +315,106 @@ void __cpuinit display_cacheinfo(struct cpuinfo_x86 *c)
 
 	if (l2size == 0)
 		return;		/* Again, no L2 cache is possible */
+#endif
 
 	c->x86_cache_size = l2size;
 
 	printk(KERN_INFO "CPU: L2 Cache: %dK (%d bytes/line)\n",
-	       l2size, ecx & 0xFF);
+			l2size, ecx & 0xFF);
 }
 
-/*
- * Naming convention should be: <Name> [(<Codename>)]
- * This table only is used unless init_<vendor>() below doesn't set it;
- * in particular, if CPUID levels 0x80000002..4 are supported, this isn't used
- *
- */
-
-/* Look up CPU names by table lookup. */
-static char __cpuinit *table_lookup_model(struct cpuinfo_x86 *c)
+void __cpuinit detect_ht(struct cpuinfo_x86 *c)
 {
-	struct cpu_model_info *info;
+#ifdef CONFIG_X86_HT
+	u32 eax, ebx, ecx, edx;
+	int index_msb, core_bits;
 
-	if (c->x86_model >= 16)
-		return NULL;	/* Range check */
+	if (!cpu_has(c, X86_FEATURE_HT))
+		return;
 
-	if (!this_cpu)
-		return NULL;
+	if (cpu_has(c, X86_FEATURE_CMP_LEGACY))
+		goto out;
 
-	info = this_cpu->c_models;
+	if (cpu_has(c, X86_FEATURE_XTOPOLOGY))
+		return;
 
-	while (info && info->family) {
-		if (info->family == c->x86)
-			return info->model_names[c->x86_model];
-		info++;
+	cpuid(1, &eax, &ebx, &ecx, &edx);
+
+	smp_num_siblings = (ebx & 0xff0000) >> 16;
+
+	if (smp_num_siblings == 1) {
+		printk(KERN_INFO  "CPU: Hyper-Threading is disabled\n");
+	} else if (smp_num_siblings > 1) {
+
+		if (smp_num_siblings > NR_CPUS) {
+			printk(KERN_WARNING "CPU: Unsupported number of siblings %d",
+					smp_num_siblings);
+			smp_num_siblings = 1;
+			return;
+		}
+
+		index_msb = get_count_order(smp_num_siblings);
+#ifdef CONFIG_X86_64
+		c->phys_proc_id = phys_pkg_id(index_msb);
+#else
+		c->phys_proc_id = phys_pkg_id(c->initial_apicid, index_msb);
+#endif
+
+		smp_num_siblings = smp_num_siblings / c->x86_max_cores;
+
+		index_msb = get_count_order(smp_num_siblings);
+
+		core_bits = get_count_order(c->x86_max_cores);
+
+#ifdef CONFIG_X86_64
+		c->cpu_core_id = phys_pkg_id(index_msb) &
+					       ((1 << core_bits) - 1);
+#else
+		c->cpu_core_id = phys_pkg_id(c->initial_apicid, index_msb) &
+					       ((1 << core_bits) - 1);
+#endif
 	}
-	return NULL;		/* Not found */
-}
 
+out:
+	if ((c->x86_max_cores * smp_num_siblings) > 1) {
+		printk(KERN_INFO  "CPU: Physical Processor ID: %d\n",
+		       c->phys_proc_id);
+		printk(KERN_INFO  "CPU: Processor Core ID: %d\n",
+		       c->cpu_core_id);
+	}
+#endif
+}
 
-static void __cpuinit get_cpu_vendor(struct cpuinfo_x86 *c, int early)
+static void __cpuinit get_cpu_vendor(struct cpuinfo_x86 *c)
 {
 	char *v = c->x86_vendor_id;
 	int i;
 	static int printed;
 
 	for (i = 0; i < X86_VENDOR_NUM; i++) {
-		if (cpu_devs[i]) {
-			if (!strcmp(v, cpu_devs[i]->c_ident[0]) ||
-			    (cpu_devs[i]->c_ident[1] &&
-			     !strcmp(v, cpu_devs[i]->c_ident[1]))) {
-				c->x86_vendor = i;
-				if (!early)
-					this_cpu = cpu_devs[i];
-				return;
-			}
+		if (!cpu_devs[i])
+			break;
+
+		if (!strcmp(v, cpu_devs[i]->c_ident[0]) ||
+		    (cpu_devs[i]->c_ident[1] &&
+		     !strcmp(v, cpu_devs[i]->c_ident[1]))) {
+			this_cpu = cpu_devs[i];
+			c->x86_vendor = this_cpu->c_x86_vendor;
+			return;
 		}
 	}
+
 	if (!printed) {
 		printed++;
-		printk(KERN_ERR "CPU: Vendor unknown, using generic init.\n");
+		printk(KERN_ERR "CPU: vendor_id '%s' unknown, using generic init.\n", v);
 		printk(KERN_ERR "CPU: Your system may be unstable.\n");
 	}
+
 	c->x86_vendor = X86_VENDOR_UNKNOWN;
 	this_cpu = &default_cpu;
 }
 
-
-static int __init x86_fxsr_setup(char *s)
-{
-	setup_clear_cpu_cap(X86_FEATURE_FXSR);
-	setup_clear_cpu_cap(X86_FEATURE_XMM);
-	return 1;
-}
-__setup("nofxsr", x86_fxsr_setup);
-
-
-static int __init x86_sep_setup(char *s)
-{
-	setup_clear_cpu_cap(X86_FEATURE_SEP);
-	return 1;
-}
-__setup("nosep", x86_sep_setup);
-
-
-/* Standard macro to see if a specific flag is changeable */
-static inline int flag_is_changeable_p(u32 flag)
-{
-	u32 f1, f2;
-
-	asm("pushfl\n\t"
-	    "pushfl\n\t"
-	    "popl %0\n\t"
-	    "movl %0,%1\n\t"
-	    "xorl %2,%0\n\t"
-	    "pushl %0\n\t"
-	    "popfl\n\t"
-	    "pushfl\n\t"
-	    "popl %0\n\t"
-	    "popfl\n\t"
-	    : "=&r" (f1), "=&r" (f2)
-	    : "ir" (flag));
-
-	return ((f1^f2) & flag) != 0;
-}
-
-
-/* Probe for the CPUID instruction */
-static int __cpuinit have_cpuid_p(void)
-{
-	return flag_is_changeable_p(X86_EFLAGS_ID);
-}
-
-void __init cpu_detect(struct cpuinfo_x86 *c)
+void __cpuinit cpu_detect(struct cpuinfo_x86 *c)
 {
 	/* Get vendor name */
 	cpuid(0x00000000, (unsigned int *)&c->cpuid_level,
@@ -268,50 +423,87 @@ void __init cpu_detect(struct cpuinfo_x86 *c)
 	      (unsigned int *)&c->x86_vendor_id[4]);
 
 	c->x86 = 4;
+	/* Intel-defined flags: level 0x00000001 */
 	if (c->cpuid_level >= 0x00000001) {
 		u32 junk, tfms, cap0, misc;
 		cpuid(0x00000001, &tfms, &misc, &junk, &cap0);
-		c->x86 = (tfms >> 8) & 15;
-		c->x86_model = (tfms >> 4) & 15;
+		c->x86 = (tfms >> 8) & 0xf;
+		c->x86_model = (tfms >> 4) & 0xf;
+		c->x86_mask = tfms & 0xf;
 		if (c->x86 == 0xf)
 			c->x86 += (tfms >> 20) & 0xff;
 		if (c->x86 >= 0x6)
-			c->x86_model += ((tfms >> 16) & 0xF) << 4;
-		c->x86_mask = tfms & 15;
+			c->x86_model += ((tfms >> 16) & 0xf) << 4;
 		if (cap0 & (1<<19)) {
-			c->x86_cache_alignment = ((misc >> 8) & 0xff) * 8;
 			c->x86_clflush_size = ((misc >> 8) & 0xff) * 8;
+			c->x86_cache_alignment = c->x86_clflush_size;
 		}
 	}
 }
-static void __cpuinit early_get_cap(struct cpuinfo_x86 *c)
+
+static void __cpuinit get_cpu_cap(struct cpuinfo_x86 *c)
 {
 	u32 tfms, xlvl;
-	unsigned int ebx;
+	u32 ebx;
 
-	memset(&c->x86_capability, 0, sizeof c->x86_capability);
-	if (have_cpuid_p()) {
-		/* Intel-defined flags: level 0x00000001 */
-		if (c->cpuid_level >= 0x00000001) {
-			u32 capability, excap;
-			cpuid(0x00000001, &tfms, &ebx, &excap, &capability);
-			c->x86_capability[0] = capability;
-			c->x86_capability[4] = excap;
-		}
+	/* Intel-defined flags: level 0x00000001 */
+	if (c->cpuid_level >= 0x00000001) {
+		u32 capability, excap;
+		cpuid(0x00000001, &tfms, &ebx, &excap, &capability);
+		c->x86_capability[0] = capability;
+		c->x86_capability[4] = excap;
+	}
 
-		/* AMD-defined flags: level 0x80000001 */
-		xlvl = cpuid_eax(0x80000000);
-		if ((xlvl & 0xffff0000) == 0x80000000) {
-			if (xlvl >= 0x80000001) {
-				c->x86_capability[1] = cpuid_edx(0x80000001);
-				c->x86_capability[6] = cpuid_ecx(0x80000001);
-			}
+	/* AMD-defined flags: level 0x80000001 */
+	xlvl = cpuid_eax(0x80000000);
+	c->extended_cpuid_level = xlvl;
+	if ((xlvl & 0xffff0000) == 0x80000000) {
+		if (xlvl >= 0x80000001) {
+			c->x86_capability[1] = cpuid_edx(0x80000001);
+			c->x86_capability[6] = cpuid_ecx(0x80000001);
 		}
+	}
 
+#ifdef CONFIG_X86_64
+	if (c->extended_cpuid_level >= 0x80000008) {
+		u32 eax = cpuid_eax(0x80000008);
+
+		c->x86_virt_bits = (eax >> 8) & 0xff;
+		c->x86_phys_bits = eax & 0xff;
 	}
+#endif
+
+	if (c->extended_cpuid_level >= 0x80000007)
+		c->x86_power = cpuid_edx(0x80000007);
 
 }
 
+static void __cpuinit identify_cpu_without_cpuid(struct cpuinfo_x86 *c)
+{
+#ifdef CONFIG_X86_32
+	int i;
+
+	/*
+	 * First of all, decide if this is a 486 or higher
+	 * It's a 486 if we can modify the AC flag
+	 */
+	if (flag_is_changeable_p(X86_EFLAGS_AC))
+		c->x86 = 4;
+	else
+		c->x86 = 3;
+
+	for (i = 0; i < X86_VENDOR_NUM; i++)
+		if (cpu_devs[i] && cpu_devs[i]->c_identify) {
+			c->x86_vendor_id[0] = 0;
+			cpu_devs[i]->c_identify(c);
+			if (c->x86_vendor_id[0]) {
+				get_cpu_vendor(c);
+				break;
+			}
+		}
+#endif
+}
+
 /*
  * Do minimum CPU detection early.
  * Fields really needed: vendor, cpuid_level, family, model, mask,
@@ -321,25 +513,61 @@ static void __cpuinit early_get_cap(struct cpuinfo_x86 *c)
  * WARNING: this function is only called on the BP.  Don't add code here
  * that is supposed to run on all CPUs.
  */
-static void __init early_cpu_detect(void)
+static void __init early_identify_cpu(struct cpuinfo_x86 *c)
 {
-	struct cpuinfo_x86 *c = &boot_cpu_data;
-
-	c->x86_cache_alignment = 32;
+#ifdef CONFIG_X86_64
+	c->x86_clflush_size = 64;
+#else
 	c->x86_clflush_size = 32;
+#endif
+	c->x86_cache_alignment = c->x86_clflush_size;
+
+	memset(&c->x86_capability, 0, sizeof c->x86_capability);
+	c->extended_cpuid_level = 0;
 
 	if (!have_cpuid_p())
+		identify_cpu_without_cpuid(c);
+
+	/* cyrix could have cpuid enabled via c_identify()*/
+	if (!have_cpuid_p())
 		return;
 
 	cpu_detect(c);
 
-	get_cpu_vendor(c, 1);
+	get_cpu_vendor(c);
 
-	early_get_cap(c);
+	get_cpu_cap(c);
 
-	if (c->x86_vendor != X86_VENDOR_UNKNOWN &&
-	    cpu_devs[c->x86_vendor]->c_early_init)
-		cpu_devs[c->x86_vendor]->c_early_init(c);
+	if (this_cpu->c_early_init)
+		this_cpu->c_early_init(c);
+
+	validate_pat_support(c);
+}
+
+void __init early_cpu_init(void)
+{
+	struct cpu_dev **cdev;
+	int count = 0;
+
+	printk("KERNEL supported cpus:\n");
+	for (cdev = __x86_cpu_dev_start; cdev < __x86_cpu_dev_end; cdev++) {
+		struct cpu_dev *cpudev = *cdev;
+		unsigned int j;
+
+		if (count >= X86_VENDOR_NUM)
+			break;
+		cpu_devs[count] = cpudev;
+		count++;
+
+		for (j = 0; j < 2; j++) {
+			if (!cpudev->c_ident[j])
+				continue;
+			printk("  %s %s\n", cpudev->c_vendor,
+				cpudev->c_ident[j]);
+		}
+	}
+
+	early_identify_cpu(&boot_cpu_data);
 }
 
 /*
@@ -357,86 +585,41 @@ static void __cpuinit detect_nopl(struct cpuinfo_x86 *c)
 
 static void __cpuinit generic_identify(struct cpuinfo_x86 *c)
 {
-	u32 tfms, xlvl;
-	unsigned int ebx;
-
-	if (have_cpuid_p()) {
-		/* Get vendor name */
-		cpuid(0x00000000, (unsigned int *)&c->cpuid_level,
-		      (unsigned int *)&c->x86_vendor_id[0],
-		      (unsigned int *)&c->x86_vendor_id[8],
-		      (unsigned int *)&c->x86_vendor_id[4]);
-
-		get_cpu_vendor(c, 0);
-		/* Initialize the standard set of capabilities */
-		/* Note that the vendor-specific code below might override */
-		/* Intel-defined flags: level 0x00000001 */
-		if (c->cpuid_level >= 0x00000001) {
-			u32 capability, excap;
-			cpuid(0x00000001, &tfms, &ebx, &excap, &capability);
-			c->x86_capability[0] = capability;
-			c->x86_capability[4] = excap;
-			c->x86 = (tfms >> 8) & 15;
-			c->x86_model = (tfms >> 4) & 15;
-			if (c->x86 == 0xf)
-				c->x86 += (tfms >> 20) & 0xff;
-			if (c->x86 >= 0x6)
-				c->x86_model += ((tfms >> 16) & 0xF) << 4;
-			c->x86_mask = tfms & 15;
-			c->initial_apicid = (ebx >> 24) & 0xFF;
-#ifdef CONFIG_X86_HT
-			c->apicid = phys_pkg_id(c->initial_apicid, 0);
-			c->phys_proc_id = c->initial_apicid;
-#else
-			c->apicid = c->initial_apicid;
-#endif
-			if (test_cpu_cap(c, X86_FEATURE_CLFLSH))
-				c->x86_clflush_size = ((ebx >> 8) & 0xff) * 8;
-		} else {
-			/* Have CPUID level 0 only - unheard of */
-			c->x86 = 4;
-		}
+	c->extended_cpuid_level = 0;
 
-		/* AMD-defined flags: level 0x80000001 */
-		xlvl = cpuid_eax(0x80000000);
-		if ((xlvl & 0xffff0000) == 0x80000000) {
-			if (xlvl >= 0x80000001) {
-				c->x86_capability[1] = cpuid_edx(0x80000001);
-				c->x86_capability[6] = cpuid_ecx(0x80000001);
-			}
-			if (xlvl >= 0x80000004)
-				get_model_name(c); /* Default name */
-		}
+	if (!have_cpuid_p())
+		identify_cpu_without_cpuid(c);
 
-		init_scattered_cpuid_features(c);
-		detect_nopl(c);
-	}
-}
+	/* cyrix could have cpuid enabled via c_identify()*/
+	if (!have_cpuid_p())
+		return;
 
-static void __cpuinit squash_the_stupid_serial_number(struct cpuinfo_x86 *c)
-{
-	if (cpu_has(c, X86_FEATURE_PN) && disable_x86_serial_nr) {
-		/* Disable processor serial number */
-		unsigned long lo, hi;
-		rdmsr(MSR_IA32_BBL_CR_CTL, lo, hi);
-		lo |= 0x200000;
-		wrmsr(MSR_IA32_BBL_CR_CTL, lo, hi);
-		printk(KERN_NOTICE "CPU serial number disabled.\n");
-		clear_cpu_cap(c, X86_FEATURE_PN);
+	cpu_detect(c);
 
-		/* Disabling the serial number may affect the cpuid level */
-		c->cpuid_level = cpuid_eax(0);
-	}
-}
+	get_cpu_vendor(c);
 
-static int __init x86_serial_nr_setup(char *s)
-{
-	disable_x86_serial_nr = 0;
-	return 1;
-}
-__setup("serialnumber", x86_serial_nr_setup);
+	get_cpu_cap(c);
 
+	if (c->cpuid_level >= 0x00000001) {
+		c->initial_apicid = (cpuid_ebx(1) >> 24) & 0xFF;
+#ifdef CONFIG_X86_32
+# ifdef CONFIG_X86_HT
+		c->apicid = phys_pkg_id(c->initial_apicid, 0);
+# else
+		c->apicid = c->initial_apicid;
+# endif
+#endif
 
+#ifdef CONFIG_X86_HT
+		c->phys_proc_id = c->initial_apicid;
+#endif
+	}
+
+	get_model_name(c); /* Default name */
+
+	init_scattered_cpuid_features(c);
+	detect_nopl(c);
+}
 
 /*
  * This does the hard work of actually picking apart the CPU stuff...
@@ -448,30 +631,29 @@ static void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
 	c->loops_per_jiffy = loops_per_jiffy;
 	c->x86_cache_size = -1;
 	c->x86_vendor = X86_VENDOR_UNKNOWN;
-	c->cpuid_level = -1;	/* CPUID not detected */
 	c->x86_model = c->x86_mask = 0;	/* So far unknown... */
 	c->x86_vendor_id[0] = '\0'; /* Unset */
 	c->x86_model_id[0] = '\0';  /* Unset */
 	c->x86_max_cores = 1;
+	c->x86_coreid_bits = 0;
+#ifdef CONFIG_X86_64
+	c->x86_clflush_size = 64;
+#else
+	c->cpuid_level = -1;	/* CPUID not detected */
 	c->x86_clflush_size = 32;
+#endif
+	c->x86_cache_alignment = c->x86_clflush_size;
 	memset(&c->x86_capability, 0, sizeof c->x86_capability);
 
-	if (!have_cpuid_p()) {
-		/*
-		 * First of all, decide if this is a 486 or higher
-		 * It's a 486 if we can modify the AC flag
-		 */
-		if (flag_is_changeable_p(X86_EFLAGS_AC))
-			c->x86 = 4;
-		else
-			c->x86 = 3;
-	}
-
 	generic_identify(c);
 
 	if (this_cpu->c_identify)
 		this_cpu->c_identify(c);
 
+#ifdef CONFIG_X86_64
+	c->apicid = phys_pkg_id(0);
+#endif
+
 	/*
 	 * Vendor-specific initialization.  In this section we
 	 * canonicalize the feature flags, meaning if there are
@@ -505,6 +687,10 @@ static void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
 				c->x86, c->x86_model);
 	}
 
+#ifdef CONFIG_X86_64
+	detect_ht(c);
+#endif
+
 	/*
 	 * On SMP, boot_cpu_data holds the common feature set between
 	 * all CPUs; so make sure that we indicate which features are
@@ -513,7 +699,7 @@ static void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
 	 */
 	if (c != &boot_cpu_data) {
 		/* AND the already accumulated flags with these */
-		for (i = 0 ; i < NCAPINTS ; i++)
+		for (i = 0; i < NCAPINTS; i++)
 			boot_cpu_data.x86_capability[i] &= c->x86_capability[i];
 	}
 
@@ -521,72 +707,79 @@ static void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
 	for (i = 0; i < NCAPINTS; i++)
 		c->x86_capability[i] &= ~cleared_cpu_caps[i];
 
+#ifdef CONFIG_X86_MCE
 	/* Init Machine Check Exception if available. */
 	mcheck_init(c);
+#endif
 
 	select_idle_routine(c);
+
+#if defined(CONFIG_NUMA) && defined(CONFIG_X86_64)
+	numa_add_cpu(smp_processor_id());
+#endif
 }
 
 void __init identify_boot_cpu(void)
 {
 	identify_cpu(&boot_cpu_data);
+#ifdef CONFIG_X86_32
 	sysenter_setup();
 	enable_sep_cpu();
+#endif
 }
 
 void __cpuinit identify_secondary_cpu(struct cpuinfo_x86 *c)
 {
 	BUG_ON(c == &boot_cpu_data);
 	identify_cpu(c);
+#ifdef CONFIG_X86_32
 	enable_sep_cpu();
+#endif
 	mtrr_ap_init();
 }
 
-#ifdef CONFIG_X86_HT
-void __cpuinit detect_ht(struct cpuinfo_x86 *c)
-{
-	u32 	eax, ebx, ecx, edx;
-	int 	index_msb, core_bits;
-
-	cpuid(1, &eax, &ebx, &ecx, &edx);
-
-	if (!cpu_has(c, X86_FEATURE_HT) || cpu_has(c, X86_FEATURE_CMP_LEGACY))
-		return;
-
-	smp_num_siblings = (ebx & 0xff0000) >> 16;
+struct msr_range {
+	unsigned min;
+	unsigned max;
+};
 
-	if (smp_num_siblings == 1) {
-		printk(KERN_INFO  "CPU: Hyper-Threading is disabled\n");
-	} else if (smp_num_siblings > 1) {
+static struct msr_range msr_range_array[] __cpuinitdata = {
+	{ 0x00000000, 0x00000418},
+	{ 0xc0000000, 0xc000040b},
+	{ 0xc0010000, 0xc0010142},
+	{ 0xc0011000, 0xc001103b},
+};
 
-		if (smp_num_siblings > NR_CPUS) {
-			printk(KERN_WARNING "CPU: Unsupported number of the "
-					"siblings %d", smp_num_siblings);
-			smp_num_siblings = 1;
-			return;
+static void __cpuinit print_cpu_msr(void)
+{
+	unsigned index;
+	u64 val;
+	int i;
+	unsigned index_min, index_max;
+
+	for (i = 0; i < ARRAY_SIZE(msr_range_array); i++) {
+		index_min = msr_range_array[i].min;
+		index_max = msr_range_array[i].max;
+		for (index = index_min; index < index_max; index++) {
+			if (rdmsrl_amd_safe(index, &val))
+				continue;
+			printk(KERN_INFO " MSR%08x: %016llx\n", index, val);
 		}
+	}
+}
 
-		index_msb = get_count_order(smp_num_siblings);
-		c->phys_proc_id = phys_pkg_id(c->initial_apicid, index_msb);
-
-		printk(KERN_INFO  "CPU: Physical Processor ID: %d\n",
-		       c->phys_proc_id);
-
-		smp_num_siblings = smp_num_siblings / c->x86_max_cores;
-
-		index_msb = get_count_order(smp_num_siblings) ;
+static int show_msr __cpuinitdata;
+static __init int setup_show_msr(char *arg)
+{
+	int num;
 
-		core_bits = get_count_order(c->x86_max_cores);
+	get_option(&arg, &num);
 
-		c->cpu_core_id = phys_pkg_id(c->initial_apicid, index_msb) &
-					       ((1 << core_bits) - 1);
-
-		if (c->x86_max_cores > 1)
-			printk(KERN_INFO  "CPU: Processor Core ID: %d\n",
-			       c->cpu_core_id);
-	}
+	if (num > 0)
+		show_msr = num;
+	return 1;
 }
-#endif
+__setup("show_msr=", setup_show_msr);
 
 static __init int setup_noclflush(char *arg)
 {
@@ -605,17 +798,25 @@ void __cpuinit print_cpu_info(struct cpuinfo_x86 *c)
 		vendor = c->x86_vendor_id;
 
 	if (vendor && strncmp(c->x86_model_id, vendor, strlen(vendor)))
-		printk("%s ", vendor);
+		printk(KERN_CONT "%s ", vendor);
 
-	if (!c->x86_model_id[0])
-		printk("%d86", c->x86);
+	if (c->x86_model_id[0])
+		printk(KERN_CONT "%s", c->x86_model_id);
 	else
-		printk("%s", c->x86_model_id);
+		printk(KERN_CONT "%d86", c->x86);
 
 	if (c->x86_mask || c->cpuid_level >= 0)
-		printk(" stepping %02x\n", c->x86_mask);
+		printk(KERN_CONT " stepping %02x\n", c->x86_mask);
 	else
-		printk("\n");
+		printk(KERN_CONT "\n");
+
+#ifdef CONFIG_SMP
+	if (c->cpu_index < show_msr)
+		print_cpu_msr();
+#else
+	if (show_msr)
+		print_cpu_msr();
+#endif
 }
 
 static __init int setup_disablecpuid(char *arg)
@@ -631,19 +832,89 @@ __setup("clearcpuid=", setup_disablecpuid);
 
 cpumask_t cpu_initialized __cpuinitdata = CPU_MASK_NONE;
 
-void __init early_cpu_init(void)
+#ifdef CONFIG_X86_64
+struct x8664_pda **_cpu_pda __read_mostly;
+EXPORT_SYMBOL(_cpu_pda);
+
+struct desc_ptr idt_descr = { 256 * 16 - 1, (unsigned long) idt_table };
+
+char boot_cpu_stack[IRQSTACKSIZE] __page_aligned_bss;
+
+void __cpuinit pda_init(int cpu)
+{
+	struct x8664_pda *pda = cpu_pda(cpu);
+
+	/* Setup up data that may be needed in __get_free_pages early */
+	loadsegment(fs, 0);
+	loadsegment(gs, 0);
+	/* Memory clobbers used to order PDA accessed */
+	mb();
+	wrmsrl(MSR_GS_BASE, pda);
+	mb();
+
+	pda->cpunumber = cpu;
+	pda->irqcount = -1;
+	pda->kernelstack = (unsigned long)stack_thread_info() -
+				 PDA_STACKOFFSET + THREAD_SIZE;
+	pda->active_mm = &init_mm;
+	pda->mmu_state = 0;
+
+	if (cpu == 0) {
+		/* others are initialized in smpboot.c */
+		pda->pcurrent = &init_task;
+		pda->irqstackptr = boot_cpu_stack;
+		pda->irqstackptr += IRQSTACKSIZE - 64;
+	} else {
+		if (!pda->irqstackptr) {
+			pda->irqstackptr = (char *)
+				__get_free_pages(GFP_ATOMIC, IRQSTACK_ORDER);
+			if (!pda->irqstackptr)
+				panic("cannot allocate irqstack for cpu %d",
+				      cpu);
+			pda->irqstackptr += IRQSTACKSIZE - 64;
+		}
+
+		if (pda->nodenumber == 0 && cpu_to_node(cpu) != NUMA_NO_NODE)
+			pda->nodenumber = cpu_to_node(cpu);
+	}
+}
+
+char boot_exception_stacks[(N_EXCEPTION_STACKS - 1) * EXCEPTION_STKSZ +
+			   DEBUG_STKSZ] __page_aligned_bss;
+
+extern asmlinkage void ignore_sysret(void);
+
+/* May not be marked __init: used by software suspend */
+void syscall_init(void)
 {
-	struct cpu_vendor_dev *cvdev;
+	/*
+	 * LSTAR and STAR live in a bit strange symbiosis.
+	 * They both write to the same internal register. STAR allows to
+	 * set CS/DS but only a 32bit target. LSTAR sets the 64bit rip.
+	 */
+	wrmsrl(MSR_STAR,  ((u64)__USER32_CS)<<48  | ((u64)__KERNEL_CS)<<32);
+	wrmsrl(MSR_LSTAR, system_call);
+	wrmsrl(MSR_CSTAR, ignore_sysret);
 
-	for (cvdev = __x86cpuvendor_start ;
-	     cvdev < __x86cpuvendor_end   ;
-	     cvdev++)
-		cpu_devs[cvdev->vendor] = cvdev->cpu_dev;
+#ifdef CONFIG_IA32_EMULATION
+	syscall32_cpu_init();
+#endif
 
-	early_cpu_detect();
-	validate_pat_support(&boot_cpu_data);
+	/* Flags to clear on syscall */
+	wrmsrl(MSR_SYSCALL_MASK,
+	       X86_EFLAGS_TF|X86_EFLAGS_DF|X86_EFLAGS_IF|X86_EFLAGS_IOPL);
 }
 
+unsigned long kernel_eflags;
+
+/*
+ * Copies of the original ist values from the tss are only accessed during
+ * debugging, no special alignment required.
+ */
+DEFINE_PER_CPU(struct orig_ist, orig_ist);
+
+#else
+
 /* Make sure %fs is initialized properly in idle threads */
 struct pt_regs * __cpuinit idle_regs(struct pt_regs *regs)
 {
@@ -651,25 +922,136 @@ struct pt_regs * __cpuinit idle_regs(struct pt_regs *regs)
 	regs->fs = __KERNEL_PERCPU;
 	return regs;
 }
-
-/* Current gdt points %fs at the "master" per-cpu area: after this,
- * it's on the real one. */
-void switch_to_new_gdt(void)
-{
-	struct desc_ptr gdt_descr;
-
-	gdt_descr.address = (long)get_cpu_gdt_table(smp_processor_id());
-	gdt_descr.size = GDT_SIZE - 1;
-	load_gdt(&gdt_descr);
-	asm("mov %0, %%fs" : : "r" (__KERNEL_PERCPU) : "memory");
-}
+#endif
 
 /*
  * cpu_init() initializes state that is per-CPU. Some data is already
  * initialized (naturally) in the bootstrap process, such as the GDT
  * and IDT. We reload them nevertheless, this function acts as a
  * 'CPU state barrier', nothing should get across.
+ * A lot of state is already set up in PDA init for 64 bit
  */
+#ifdef CONFIG_X86_64
+void __cpuinit cpu_init(void)
+{
+	int cpu = stack_smp_processor_id();
+	struct tss_struct *t = &per_cpu(init_tss, cpu);
+	struct orig_ist *orig_ist = &per_cpu(orig_ist, cpu);
+	unsigned long v;
+	char *estacks = NULL;
+	struct task_struct *me;
+	int i;
+
+	/* CPU 0 is initialised in head64.c */
+	if (cpu != 0)
+		pda_init(cpu);
+	else
+		estacks = boot_exception_stacks;
+
+	me = current;
+
+	if (cpu_test_and_set(cpu, cpu_initialized))
+		panic("CPU#%d already initialized!\n", cpu);
+
+	printk(KERN_INFO "Initializing CPU#%d\n", cpu);
+
+	clear_in_cr4(X86_CR4_VME|X86_CR4_PVI|X86_CR4_TSD|X86_CR4_DE);
+
+	/*
+	 * Initialize the per-CPU GDT with the boot GDT,
+	 * and set up the GDT descriptor:
+	 */
+
+	switch_to_new_gdt();
+	load_idt((const struct desc_ptr *)&idt_descr);
+
+	memset(me->thread.tls_array, 0, GDT_ENTRY_TLS_ENTRIES * 8);
+	syscall_init();
+
+	wrmsrl(MSR_FS_BASE, 0);
+	wrmsrl(MSR_KERNEL_GS_BASE, 0);
+	barrier();
+
+	check_efer();
+	if (cpu != 0 && x2apic)
+		enable_x2apic();
+
+	/*
+	 * set up and load the per-CPU TSS
+	 */
+	if (!orig_ist->ist[0]) {
+		static const unsigned int order[N_EXCEPTION_STACKS] = {
+		  [0 ... N_EXCEPTION_STACKS - 1] = EXCEPTION_STACK_ORDER,
+		  [DEBUG_STACK - 1] = DEBUG_STACK_ORDER
+		};
+		for (v = 0; v < N_EXCEPTION_STACKS; v++) {
+			if (cpu) {
+				estacks = (char *)__get_free_pages(GFP_ATOMIC, order[v]);
+				if (!estacks)
+					panic("Cannot allocate exception "
+					      "stack %ld %d\n", v, cpu);
+			}
+			estacks += PAGE_SIZE << order[v];
+			orig_ist->ist[v] = t->x86_tss.ist[v] =
+					(unsigned long)estacks;
+		}
+	}
+
+	t->x86_tss.io_bitmap_base = offsetof(struct tss_struct, io_bitmap);
+	/*
+	 * <= is required because the CPU will access up to
+	 * 8 bits beyond the end of the IO permission bitmap.
+	 */
+	for (i = 0; i <= IO_BITMAP_LONGS; i++)
+		t->io_bitmap[i] = ~0UL;
+
+	atomic_inc(&init_mm.mm_count);
+	me->active_mm = &init_mm;
+	if (me->mm)
+		BUG();
+	enter_lazy_tlb(&init_mm, me);
+
+	load_sp0(t, &current->thread);
+	set_tss_desc(cpu, t);
+	load_TR_desc();
+	load_LDT(&init_mm.context);
+
+#ifdef CONFIG_KGDB
+	/*
+	 * If the kgdb is connected no debug regs should be altered.  This
+	 * is only applicable when KGDB and a KGDB I/O module are built
+	 * into the kernel and you are using early debugging with
+	 * kgdbwait. KGDB will control the kernel HW breakpoint registers.
+	 */
+	if (kgdb_connected && arch_kgdb_ops.correct_hw_break)
+		arch_kgdb_ops.correct_hw_break();
+	else {
+#endif
+	/*
+	 * Clear all 6 debug registers:
+	 */
+
+	set_debugreg(0UL, 0);
+	set_debugreg(0UL, 1);
+	set_debugreg(0UL, 2);
+	set_debugreg(0UL, 3);
+	set_debugreg(0UL, 6);
+	set_debugreg(0UL, 7);
+#ifdef CONFIG_KGDB
+	/* If the kgdb is connected no debug regs should be altered. */
+	}
+#endif
+
+	fpu_init();
+
+	raw_local_save_flags(kernel_eflags);
+
+	if (is_uv_system())
+		uv_cpu_init();
+}
+
+#else
+
 void __cpuinit cpu_init(void)
 {
 	int cpu = smp_processor_id();
@@ -723,9 +1105,20 @@ void __cpuinit cpu_init(void)
 	/*
 	 * Force FPU initialization:
 	 */
-	current_thread_info()->status = 0;
+	if (cpu_has_xsave)
+		current_thread_info()->status = TS_XSAVE;
+	else
+		current_thread_info()->status = 0;
 	clear_used_math();
 	mxcsr_feature_mask_init();
+
+	/*
+	 * Boot processor to setup the FP and extended state context info.
+	 */
+	if (!smp_processor_id())
+		init_thread_xstate();
+
+	xsave_init();
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
@@ -739,3 +1132,5 @@ void __cpuinit cpu_uninit(void)
 	per_cpu(cpu_tlbstate, cpu).active_mm = &init_mm;
 }
 #endif
+
+#endif
diff --git a/arch/x86/kernel/cpu/common_64.c b/arch/x86/kernel/cpu/common_64.c
deleted file mode 100644
index 43f1aa5..0000000
--- a/arch/x86/kernel/cpu/common_64.c
+++ /dev/null
@@ -1,765 +0,0 @@
-#include <linux/init.h>
-#include <linux/kernel.h>
-#include <linux/sched.h>
-#include <linux/string.h>
-#include <linux/bootmem.h>
-#include <linux/bitops.h>
-#include <linux/module.h>
-#include <linux/kgdb.h>
-#include <linux/topology.h>
-#include <linux/delay.h>
-#include <linux/smp.h>
-#include <linux/percpu.h>
-#include <asm/i387.h>
-#include <asm/msr.h>
-#include <asm/io.h>
-#include <asm/linkage.h>
-#include <asm/mmu_context.h>
-#include <asm/mtrr.h>
-#include <asm/mce.h>
-#include <asm/pat.h>
-#include <asm/asm.h>
-#include <asm/numa.h>
-#ifdef CONFIG_X86_LOCAL_APIC
-#include <asm/mpspec.h>
-#include <asm/apic.h>
-#include <mach_apic.h>
-#endif
-#include <asm/pda.h>
-#include <asm/pgtable.h>
-#include <asm/processor.h>
-#include <asm/desc.h>
-#include <asm/atomic.h>
-#include <asm/proto.h>
-#include <asm/sections.h>
-#include <asm/setup.h>
-#include <asm/genapic.h>
-
-#include "cpu.h"
-
-/* We need valid kernel segments for data and code in long mode too
- * IRET will check the segment types  kkeil 2000/10/28
- * Also sysret mandates a special GDT layout
- */
-/* The TLS descriptors are currently at a different place compared to i386.
-   Hopefully nobody expects them at a fixed place (Wine?) */
-DEFINE_PER_CPU(struct gdt_page, gdt_page) = { .gdt = {
-	[GDT_ENTRY_KERNEL32_CS] = { { { 0x0000ffff, 0x00cf9b00 } } },
-	[GDT_ENTRY_KERNEL_CS] = { { { 0x0000ffff, 0x00af9b00 } } },
-	[GDT_ENTRY_KERNEL_DS] = { { { 0x0000ffff, 0x00cf9300 } } },
-	[GDT_ENTRY_DEFAULT_USER32_CS] = { { { 0x0000ffff, 0x00cffb00 } } },
-	[GDT_ENTRY_DEFAULT_USER_DS] = { { { 0x0000ffff, 0x00cff300 } } },
-	[GDT_ENTRY_DEFAULT_USER_CS] = { { { 0x0000ffff, 0x00affb00 } } },
-} };
-EXPORT_PER_CPU_SYMBOL_GPL(gdt_page);
-
-__u32 cleared_cpu_caps[NCAPINTS] __cpuinitdata;
-
-/* Current gdt points %fs at the "master" per-cpu area: after this,
- * it's on the real one. */
-void switch_to_new_gdt(void)
-{
-	struct desc_ptr gdt_descr;
-
-	gdt_descr.address = (long)get_cpu_gdt_table(smp_processor_id());
-	gdt_descr.size = GDT_SIZE - 1;
-	load_gdt(&gdt_descr);
-}
-
-struct cpu_dev *cpu_devs[X86_VENDOR_NUM] = {};
-
-static void __cpuinit default_init(struct cpuinfo_x86 *c)
-{
-	display_cacheinfo(c);
-}
-
-static struct cpu_dev __cpuinitdata default_cpu = {
-	.c_init	= default_init,
-	.c_vendor = "Unknown",
-};
-static struct cpu_dev *this_cpu __cpuinitdata = &default_cpu;
-
-int __cpuinit get_model_name(struct cpuinfo_x86 *c)
-{
-	unsigned int *v;
-
-	if (c->extended_cpuid_level < 0x80000004)
-		return 0;
-
-	v = (unsigned int *) c->x86_model_id;
-	cpuid(0x80000002, &v[0], &v[1], &v[2], &v[3]);
-	cpuid(0x80000003, &v[4], &v[5], &v[6], &v[7]);
-	cpuid(0x80000004, &v[8], &v[9], &v[10], &v[11]);
-	c->x86_model_id[48] = 0;
-	return 1;
-}
-
-
-void __cpuinit display_cacheinfo(struct cpuinfo_x86 *c)
-{
-	unsigned int n, dummy, ebx, ecx, edx;
-
-	n = c->extended_cpuid_level;
-
-	if (n >= 0x80000005) {
-		cpuid(0x80000005, &dummy, &ebx, &ecx, &edx);
-		printk(KERN_INFO "CPU: L1 I Cache: %dK (%d bytes/line), "
-		       "D cache %dK (%d bytes/line)\n",
-		       edx>>24, edx&0xFF, ecx>>24, ecx&0xFF);
-		c->x86_cache_size = (ecx>>24) + (edx>>24);
-		/* On K8 L1 TLB is inclusive, so don't count it */
-		c->x86_tlbsize = 0;
-	}
-
-	if (n >= 0x80000006) {
-		cpuid(0x80000006, &dummy, &ebx, &ecx, &edx);
-		ecx = cpuid_ecx(0x80000006);
-		c->x86_cache_size = ecx >> 16;
-		c->x86_tlbsize += ((ebx >> 16) & 0xfff) + (ebx & 0xfff);
-
-		printk(KERN_INFO "CPU: L2 Cache: %dK (%d bytes/line)\n",
-		c->x86_cache_size, ecx & 0xFF);
-	}
-}
-
-void __cpuinit detect_ht(struct cpuinfo_x86 *c)
-{
-#ifdef CONFIG_SMP
-	u32 eax, ebx, ecx, edx;
-	int index_msb, core_bits;
-
-	cpuid(1, &eax, &ebx, &ecx, &edx);
-
-
-	if (!cpu_has(c, X86_FEATURE_HT))
-		return;
-	if (cpu_has(c, X86_FEATURE_CMP_LEGACY))
-		goto out;
-
-	smp_num_siblings = (ebx & 0xff0000) >> 16;
-
-	if (smp_num_siblings == 1) {
-		printk(KERN_INFO  "CPU: Hyper-Threading is disabled\n");
-	} else if (smp_num_siblings > 1) {
-
-		if (smp_num_siblings > NR_CPUS) {
-			printk(KERN_WARNING "CPU: Unsupported number of "
-			       "siblings %d", smp_num_siblings);
-			smp_num_siblings = 1;
-			return;
-		}
-
-		index_msb = get_count_order(smp_num_siblings);
-		c->phys_proc_id = phys_pkg_id(index_msb);
-
-		smp_num_siblings = smp_num_siblings / c->x86_max_cores;
-
-		index_msb = get_count_order(smp_num_siblings);
-
-		core_bits = get_count_order(c->x86_max_cores);
-
-		c->cpu_core_id = phys_pkg_id(index_msb) &
-					       ((1 << core_bits) - 1);
-	}
-out:
-	if ((c->x86_max_cores * smp_num_siblings) > 1) {
-		printk(KERN_INFO  "CPU: Physical Processor ID: %d\n",
-		       c->phys_proc_id);
-		printk(KERN_INFO  "CPU: Processor Core ID: %d\n",
-		       c->cpu_core_id);
-	}
-
-#endif
-}
-
-static void __cpuinit get_cpu_vendor(struct cpuinfo_x86 *c)
-{
-	char *v = c->x86_vendor_id;
-	int i;
-	static int printed;
-
-	for (i = 0; i < X86_VENDOR_NUM; i++) {
-		if (cpu_devs[i]) {
-			if (!strcmp(v, cpu_devs[i]->c_ident[0]) ||
-			    (cpu_devs[i]->c_ident[1] &&
-			    !strcmp(v, cpu_devs[i]->c_ident[1]))) {
-				c->x86_vendor = i;
-				this_cpu = cpu_devs[i];
-				return;
-			}
-		}
-	}
-	if (!printed) {
-		printed++;
-		printk(KERN_ERR "CPU: Vendor unknown, using generic init.\n");
-		printk(KERN_ERR "CPU: Your system may be unstable.\n");
-	}
-	c->x86_vendor = X86_VENDOR_UNKNOWN;
-}
-
-static void __init early_cpu_support_print(void)
-{
-	int i,j;
-	struct cpu_dev *cpu_devx;
-
-	printk("KERNEL supported cpus:\n");
-	for (i = 0; i < X86_VENDOR_NUM; i++) {
-		cpu_devx = cpu_devs[i];
-		if (!cpu_devx)
-			continue;
-		for (j = 0; j < 2; j++) {
-			if (!cpu_devx->c_ident[j])
-				continue;
-			printk("  %s %s\n", cpu_devx->c_vendor,
-				cpu_devx->c_ident[j]);
-		}
-	}
-}
-
-/*
- * The NOPL instruction is supposed to exist on all CPUs with
- * family >= 6, unfortunately, that's not true in practice because
- * of early VIA chips and (more importantly) broken virtualizers that
- * are not easy to detect.  Hence, probe for it based on first
- * principles.
- *
- * Note: no 64-bit chip is known to lack these, but put the code here
- * for consistency with 32 bits, and to make it utterly trivial to
- * diagnose the problem should it ever surface.
- */
-static void __cpuinit detect_nopl(struct cpuinfo_x86 *c)
-{
-	const u32 nopl_signature = 0x888c53b1; /* Random number */
-	u32 has_nopl = nopl_signature;
-
-	clear_cpu_cap(c, X86_FEATURE_NOPL);
-	if (c->x86 >= 6) {
-		asm volatile("\n"
-			     "1:      .byte 0x0f,0x1f,0xc0\n" /* nopl %eax */
-			     "2:\n"
-			     "        .section .fixup,\"ax\"\n"
-			     "3:      xor %0,%0\n"
-			     "        jmp 2b\n"
-			     "        .previous\n"
-			     _ASM_EXTABLE(1b,3b)
-			     : "+a" (has_nopl));
-
-		if (has_nopl == nopl_signature)
-			set_cpu_cap(c, X86_FEATURE_NOPL);
-	}
-}
-
-static void __cpuinit early_identify_cpu(struct cpuinfo_x86 *c);
-
-void __init early_cpu_init(void)
-{
-        struct cpu_vendor_dev *cvdev;
-
-        for (cvdev = __x86cpuvendor_start ;
-             cvdev < __x86cpuvendor_end   ;
-             cvdev++)
-                cpu_devs[cvdev->vendor] = cvdev->cpu_dev;
-	early_cpu_support_print();
-	early_identify_cpu(&boot_cpu_data);
-}
-
-/* Do some early cpuid on the boot CPU to get some parameter that are
-   needed before check_bugs. Everything advanced is in identify_cpu
-   below. */
-static void __cpuinit early_identify_cpu(struct cpuinfo_x86 *c)
-{
-	u32 tfms, xlvl;
-
-	c->loops_per_jiffy = loops_per_jiffy;
-	c->x86_cache_size = -1;
-	c->x86_vendor = X86_VENDOR_UNKNOWN;
-	c->x86_model = c->x86_mask = 0;	/* So far unknown... */
-	c->x86_vendor_id[0] = '\0'; /* Unset */
-	c->x86_model_id[0] = '\0';  /* Unset */
-	c->x86_clflush_size = 64;
-	c->x86_cache_alignment = c->x86_clflush_size;
-	c->x86_max_cores = 1;
-	c->x86_coreid_bits = 0;
-	c->extended_cpuid_level = 0;
-	memset(&c->x86_capability, 0, sizeof c->x86_capability);
-
-	/* Get vendor name */
-	cpuid(0x00000000, (unsigned int *)&c->cpuid_level,
-	      (unsigned int *)&c->x86_vendor_id[0],
-	      (unsigned int *)&c->x86_vendor_id[8],
-	      (unsigned int *)&c->x86_vendor_id[4]);
-
-	get_cpu_vendor(c);
-
-	/* Initialize the standard set of capabilities */
-	/* Note that the vendor-specific code below might override */
-
-	/* Intel-defined flags: level 0x00000001 */
-	if (c->cpuid_level >= 0x00000001) {
-		__u32 misc;
-		cpuid(0x00000001, &tfms, &misc, &c->x86_capability[4],
-		      &c->x86_capability[0]);
-		c->x86 = (tfms >> 8) & 0xf;
-		c->x86_model = (tfms >> 4) & 0xf;
-		c->x86_mask = tfms & 0xf;
-		if (c->x86 == 0xf)
-			c->x86 += (tfms >> 20) & 0xff;
-		if (c->x86 >= 0x6)
-			c->x86_model += ((tfms >> 16) & 0xF) << 4;
-		if (test_cpu_cap(c, X86_FEATURE_CLFLSH))
-			c->x86_clflush_size = ((misc >> 8) & 0xff) * 8;
-	} else {
-		/* Have CPUID level 0 only - unheard of */
-		c->x86 = 4;
-	}
-
-	c->initial_apicid = (cpuid_ebx(1) >> 24) & 0xff;
-#ifdef CONFIG_SMP
-	c->phys_proc_id = c->initial_apicid;
-#endif
-	/* AMD-defined flags: level 0x80000001 */
-	xlvl = cpuid_eax(0x80000000);
-	c->extended_cpuid_level = xlvl;
-	if ((xlvl & 0xffff0000) == 0x80000000) {
-		if (xlvl >= 0x80000001) {
-			c->x86_capability[1] = cpuid_edx(0x80000001);
-			c->x86_capability[6] = cpuid_ecx(0x80000001);
-		}
-		if (xlvl >= 0x80000004)
-			get_model_name(c); /* Default name */
-	}
-
-	/* Transmeta-defined flags: level 0x80860001 */
-	xlvl = cpuid_eax(0x80860000);
-	if ((xlvl & 0xffff0000) == 0x80860000) {
-		/* Don't set x86_cpuid_level here for now to not confuse. */
-		if (xlvl >= 0x80860001)
-			c->x86_capability[2] = cpuid_edx(0x80860001);
-	}
-
-	if (c->extended_cpuid_level >= 0x80000007)
-		c->x86_power = cpuid_edx(0x80000007);
-
-	if (c->extended_cpuid_level >= 0x80000008) {
-		u32 eax = cpuid_eax(0x80000008);
-
-		c->x86_virt_bits = (eax >> 8) & 0xff;
-		c->x86_phys_bits = eax & 0xff;
-	}
-
-	detect_nopl(c);
-
-	if (c->x86_vendor != X86_VENDOR_UNKNOWN &&
-	    cpu_devs[c->x86_vendor]->c_early_init)
-		cpu_devs[c->x86_vendor]->c_early_init(c);
-
-	validate_pat_support(c);
-}
-
-/*
- * This does the hard work of actually picking apart the CPU stuff...
- */
-static void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
-{
-	int i;
-
-	early_identify_cpu(c);
-
-	init_scattered_cpuid_features(c);
-
-	c->apicid = phys_pkg_id(0);
-
-	/*
-	 * Vendor-specific initialization.  In this section we
-	 * canonicalize the feature flags, meaning if there are
-	 * features a certain CPU supports which CPUID doesn't
-	 * tell us, CPUID claiming incorrect flags, or other bugs,
-	 * we handle them here.
-	 *
-	 * At the end of this section, c->x86_capability better
-	 * indicate the features this CPU genuinely supports!
-	 */
-	if (this_cpu->c_init)
-		this_cpu->c_init(c);
-
-	detect_ht(c);
-
-	/*
-	 * On SMP, boot_cpu_data holds the common feature set between
-	 * all CPUs; so make sure that we indicate which features are
-	 * common between the CPUs.  The first time this routine gets
-	 * executed, c == &boot_cpu_data.
-	 */
-	if (c != &boot_cpu_data) {
-		/* AND the already accumulated flags with these */
-		for (i = 0; i < NCAPINTS; i++)
-			boot_cpu_data.x86_capability[i] &= c->x86_capability[i];
-	}
-
-	/* Clear all flags overriden by options */
-	for (i = 0; i < NCAPINTS; i++)
-		c->x86_capability[i] &= ~cleared_cpu_caps[i];
-
-#ifdef CONFIG_X86_MCE
-	mcheck_init(c);
-#endif
-	select_idle_routine(c);
-
-#ifdef CONFIG_NUMA
-	numa_add_cpu(smp_processor_id());
-#endif
-
-}
-
-void __cpuinit identify_boot_cpu(void)
-{
-	identify_cpu(&boot_cpu_data);
-}
-
-void __cpuinit identify_secondary_cpu(struct cpuinfo_x86 *c)
-{
-	BUG_ON(c == &boot_cpu_data);
-	identify_cpu(c);
-	mtrr_ap_init();
-}
-
-static __init int setup_noclflush(char *arg)
-{
-	setup_clear_cpu_cap(X86_FEATURE_CLFLSH);
-	return 1;
-}
-__setup("noclflush", setup_noclflush);
-
-struct msr_range {
-	unsigned min;
-	unsigned max;
-};
-
-static struct msr_range msr_range_array[] __cpuinitdata = {
-	{ 0x00000000, 0x00000418},
-	{ 0xc0000000, 0xc000040b},
-	{ 0xc0010000, 0xc0010142},
-	{ 0xc0011000, 0xc001103b},
-};
-
-static void __cpuinit print_cpu_msr(void)
-{
-	unsigned index;
-	u64 val;
-	int i;
-	unsigned index_min, index_max;
-
-	for (i = 0; i < ARRAY_SIZE(msr_range_array); i++) {
-		index_min = msr_range_array[i].min;
-		index_max = msr_range_array[i].max;
-		for (index = index_min; index < index_max; index++) {
-			if (rdmsrl_amd_safe(index, &val))
-				continue;
-			printk(KERN_INFO " MSR%08x: %016llx\n", index, val);
-		}
-	}
-}
-
-static int show_msr __cpuinitdata;
-static __init int setup_show_msr(char *arg)
-{
-	int num;
-
-	get_option(&arg, &num);
-
-	if (num > 0)
-		show_msr = num;
-	return 1;
-}
-__setup("show_msr=", setup_show_msr);
-
-void __cpuinit print_cpu_info(struct cpuinfo_x86 *c)
-{
-	if (c->x86_model_id[0])
-		printk(KERN_CONT "%s", c->x86_model_id);
-
-	if (c->x86_mask || c->cpuid_level >= 0)
-		printk(KERN_CONT " stepping %02x\n", c->x86_mask);
-	else
-		printk(KERN_CONT "\n");
-
-#ifdef CONFIG_SMP
-	if (c->cpu_index < show_msr)
-		print_cpu_msr();
-#else
-	if (show_msr)
-		print_cpu_msr();
-#endif
-}
-
-static __init int setup_disablecpuid(char *arg)
-{
-	int bit;
-	if (get_option(&arg, &bit) && bit < NCAPINTS*32)
-		setup_clear_cpu_cap(bit);
-	else
-		return 0;
-	return 1;
-}
-__setup("clearcpuid=", setup_disablecpuid);
-
-cpumask_t cpu_initialized __cpuinitdata = CPU_MASK_NONE;
-
-struct x8664_pda **_cpu_pda __read_mostly;
-EXPORT_SYMBOL(_cpu_pda);
-
-struct desc_ptr idt_descr = { 256 * 16 - 1, (unsigned long) idt_table };
-
-char boot_cpu_stack[IRQSTACKSIZE] __page_aligned_bss;
-
-unsigned long __supported_pte_mask __read_mostly = ~0UL;
-EXPORT_SYMBOL_GPL(__supported_pte_mask);
-
-static int do_not_nx __cpuinitdata;
-
-/* noexec=on|off
-Control non executable mappings for 64bit processes.
-
-on	Enable(default)
-off	Disable
-*/
-static int __init nonx_setup(char *str)
-{
-	if (!str)
-		return -EINVAL;
-	if (!strncmp(str, "on", 2)) {
-		__supported_pte_mask |= _PAGE_NX;
-		do_not_nx = 0;
-	} else if (!strncmp(str, "off", 3)) {
-		do_not_nx = 1;
-		__supported_pte_mask &= ~_PAGE_NX;
-	}
-	return 0;
-}
-early_param("noexec", nonx_setup);
-
-int force_personality32;
-
-/* noexec32=on|off
-Control non executable heap for 32bit processes.
-To control the stack too use noexec=off
-
-on	PROT_READ does not imply PROT_EXEC for 32bit processes (default)
-off	PROT_READ implies PROT_EXEC
-*/
-static int __init nonx32_setup(char *str)
-{
-	if (!strcmp(str, "on"))
-		force_personality32 &= ~READ_IMPLIES_EXEC;
-	else if (!strcmp(str, "off"))
-		force_personality32 |= READ_IMPLIES_EXEC;
-	return 1;
-}
-__setup("noexec32=", nonx32_setup);
-
-void pda_init(int cpu)
-{
-	struct x8664_pda *pda = cpu_pda(cpu);
-
-	/* Setup up data that may be needed in __get_free_pages early */
-	loadsegment(fs, 0);
-	loadsegment(gs, 0);
-	/* Memory clobbers used to order PDA accessed */
-	mb();
-	wrmsrl(MSR_GS_BASE, pda);
-	mb();
-
-	pda->cpunumber = cpu;
-	pda->irqcount = -1;
-	pda->kernelstack = (unsigned long)stack_thread_info() -
-				 PDA_STACKOFFSET + THREAD_SIZE;
-	pda->active_mm = &init_mm;
-	pda->mmu_state = 0;
-
-	if (cpu == 0) {
-		/* others are initialized in smpboot.c */
-		pda->pcurrent = &init_task;
-		pda->irqstackptr = boot_cpu_stack;
-		pda->irqstackptr += IRQSTACKSIZE - 64;
-	} else {
-		if (!pda->irqstackptr) {
-			pda->irqstackptr = (char *)
-				__get_free_pages(GFP_ATOMIC, IRQSTACK_ORDER);
-			if (!pda->irqstackptr)
-				panic("cannot allocate irqstack for cpu %d",
-				      cpu);
-			pda->irqstackptr += IRQSTACKSIZE - 64;
-		}
-
-		if (pda->nodenumber == 0 && cpu_to_node(cpu) != NUMA_NO_NODE)
-			pda->nodenumber = cpu_to_node(cpu);
-	}
-}
-
-char boot_exception_stacks[(N_EXCEPTION_STACKS - 1) * EXCEPTION_STKSZ +
-			   DEBUG_STKSZ] __page_aligned_bss;
-
-extern asmlinkage void ignore_sysret(void);
-
-/* May not be marked __init: used by software suspend */
-void syscall_init(void)
-{
-	/*
-	 * LSTAR and STAR live in a bit strange symbiosis.
-	 * They both write to the same internal register. STAR allows to
-	 * set CS/DS but only a 32bit target. LSTAR sets the 64bit rip.
-	 */
-	wrmsrl(MSR_STAR,  ((u64)__USER32_CS)<<48  | ((u64)__KERNEL_CS)<<32);
-	wrmsrl(MSR_LSTAR, system_call);
-	wrmsrl(MSR_CSTAR, ignore_sysret);
-
-#ifdef CONFIG_IA32_EMULATION
-	syscall32_cpu_init();
-#endif
-
-	/* Flags to clear on syscall */
-	wrmsrl(MSR_SYSCALL_MASK,
-	       X86_EFLAGS_TF|X86_EFLAGS_DF|X86_EFLAGS_IF|X86_EFLAGS_IOPL);
-}
-
-void __cpuinit check_efer(void)
-{
-	unsigned long efer;
-
-	rdmsrl(MSR_EFER, efer);
-	if (!(efer & EFER_NX) || do_not_nx)
-		__supported_pte_mask &= ~_PAGE_NX;
-}
-
-unsigned long kernel_eflags;
-
-/*
- * Copies of the original ist values from the tss are only accessed during
- * debugging, no special alignment required.
- */
-DEFINE_PER_CPU(struct orig_ist, orig_ist);
-
-/*
- * cpu_init() initializes state that is per-CPU. Some data is already
- * initialized (naturally) in the bootstrap process, such as the GDT
- * and IDT. We reload them nevertheless, this function acts as a
- * 'CPU state barrier', nothing should get across.
- * A lot of state is already set up in PDA init.
- */
-void __cpuinit cpu_init(void)
-{
-	int cpu = stack_smp_processor_id();
-	struct tss_struct *t = &per_cpu(init_tss, cpu);
-	struct orig_ist *orig_ist = &per_cpu(orig_ist, cpu);
-	unsigned long v;
-	char *estacks = NULL;
-	struct task_struct *me;
-	int i;
-
-	/* CPU 0 is initialised in head64.c */
-	if (cpu != 0)
-		pda_init(cpu);
-	else
-		estacks = boot_exception_stacks;
-
-	me = current;
-
-	if (cpu_test_and_set(cpu, cpu_initialized))
-		panic("CPU#%d already initialized!\n", cpu);
-
-	printk(KERN_INFO "Initializing CPU#%d\n", cpu);
-
-	clear_in_cr4(X86_CR4_VME|X86_CR4_PVI|X86_CR4_TSD|X86_CR4_DE);
-
-	/*
-	 * Initialize the per-CPU GDT with the boot GDT,
-	 * and set up the GDT descriptor:
-	 */
-
-	switch_to_new_gdt();
-	load_idt((const struct desc_ptr *)&idt_descr);
-
-	memset(me->thread.tls_array, 0, GDT_ENTRY_TLS_ENTRIES * 8);
-	syscall_init();
-
-	wrmsrl(MSR_FS_BASE, 0);
-	wrmsrl(MSR_KERNEL_GS_BASE, 0);
-	barrier();
-
-	check_efer();
-	if (cpu != 0 && x2apic)
-		enable_x2apic();
-
-	/*
-	 * set up and load the per-CPU TSS
-	 */
-	if (!orig_ist->ist[0]) {
-		static const unsigned int order[N_EXCEPTION_STACKS] = {
-		  [0 ... N_EXCEPTION_STACKS - 1] = EXCEPTION_STACK_ORDER,
-		  [DEBUG_STACK - 1] = DEBUG_STACK_ORDER
-		};
-		for (v = 0; v < N_EXCEPTION_STACKS; v++) {
-			if (cpu) {
-				estacks = (char *)__get_free_pages(GFP_ATOMIC, order[v]);
-				if (!estacks)
-					panic("Cannot allocate exception "
-					      "stack %ld %d\n", v, cpu);
-			}
-			estacks += PAGE_SIZE << order[v];
-			orig_ist->ist[v] = t->x86_tss.ist[v] =
-					(unsigned long)estacks;
-		}
-	}
-
-	t->x86_tss.io_bitmap_base = offsetof(struct tss_struct, io_bitmap);
-	/*
-	 * <= is required because the CPU will access up to
-	 * 8 bits beyond the end of the IO permission bitmap.
-	 */
-	for (i = 0; i <= IO_BITMAP_LONGS; i++)
-		t->io_bitmap[i] = ~0UL;
-
-	atomic_inc(&init_mm.mm_count);
-	me->active_mm = &init_mm;
-	if (me->mm)
-		BUG();
-	enter_lazy_tlb(&init_mm, me);
-
-	load_sp0(t, &current->thread);
-	set_tss_desc(cpu, t);
-	load_TR_desc();
-	load_LDT(&init_mm.context);
-
-#ifdef CONFIG_KGDB
-	/*
-	 * If the kgdb is connected no debug regs should be altered.  This
-	 * is only applicable when KGDB and a KGDB I/O module are built
-	 * into the kernel and you are using early debugging with
-	 * kgdbwait. KGDB will control the kernel HW breakpoint registers.
-	 */
-	if (kgdb_connected && arch_kgdb_ops.correct_hw_break)
-		arch_kgdb_ops.correct_hw_break();
-	else {
-#endif
-	/*
-	 * Clear all 6 debug registers:
-	 */
-
-	set_debugreg(0UL, 0);
-	set_debugreg(0UL, 1);
-	set_debugreg(0UL, 2);
-	set_debugreg(0UL, 3);
-	set_debugreg(0UL, 6);
-	set_debugreg(0UL, 7);
-#ifdef CONFIG_KGDB
-	/* If the kgdb is connected no debug regs should be altered. */
-	}
-#endif
-
-	fpu_init();
-
-	raw_local_save_flags(kernel_eflags);
-
-	if (is_uv_system())
-		uv_cpu_init();
-}
diff --git a/arch/x86/kernel/cpu/cpu.h b/arch/x86/kernel/cpu/cpu.h
index 4d894e8..de4094a 100644
--- a/arch/x86/kernel/cpu/cpu.h
+++ b/arch/x86/kernel/cpu/cpu.h
@@ -21,23 +21,16 @@ struct cpu_dev {
 	void		(*c_init)(struct cpuinfo_x86 * c);
 	void		(*c_identify)(struct cpuinfo_x86 * c);
 	unsigned int	(*c_size_cache)(struct cpuinfo_x86 * c, unsigned int size);
+	int	c_x86_vendor;
 };
 
-extern struct cpu_dev * cpu_devs [X86_VENDOR_NUM];
+#define cpu_dev_register(cpu_devX) \
+	static struct cpu_dev *__cpu_dev_##cpu_devX __used \
+	__attribute__((__section__(".x86_cpu_dev.init"))) = \
+	&cpu_devX;
 
-struct cpu_vendor_dev {
-	int vendor;
-	struct cpu_dev *cpu_dev;
-};
-
-#define cpu_vendor_dev_register(cpu_vendor_id, cpu_dev) \
-	static struct cpu_vendor_dev __cpu_vendor_dev_##cpu_vendor_id __used \
-	__attribute__((__section__(".x86cpuvendor.init"))) = \
-	{ cpu_vendor_id, cpu_dev }
-
-extern struct cpu_vendor_dev __x86cpuvendor_start[], __x86cpuvendor_end[];
+extern struct cpu_dev *__x86_cpu_dev_start[], *__x86_cpu_dev_end[];
 
-extern int get_model_name(struct cpuinfo_x86 *c);
 extern void display_cacheinfo(struct cpuinfo_x86 *c);
 
 #endif
diff --git a/arch/x86/kernel/cpu/cyrix.c b/arch/x86/kernel/cpu/cyrix.c
index 898a5a2..ffd0f5e 100644
--- a/arch/x86/kernel/cpu/cyrix.c
+++ b/arch/x86/kernel/cpu/cyrix.c
@@ -121,7 +121,7 @@ static void __cpuinit set_cx86_reorder(void)
 	setCx86(CX86_CCR3, (ccr3 & 0x0f) | 0x10); /* enable MAPEN */
 
 	/* Load/Store Serialize to mem access disable (=reorder it) */
-	setCx86(CX86_PCR0, getCx86(CX86_PCR0) & ~0x80);
+	setCx86_old(CX86_PCR0, getCx86_old(CX86_PCR0) & ~0x80);
 	/* set load/store serialize from 1GB to 4GB */
 	ccr3 |= 0xe0;
 	setCx86(CX86_CCR3, ccr3);
@@ -132,11 +132,11 @@ static void __cpuinit set_cx86_memwb(void)
 	printk(KERN_INFO "Enable Memory-Write-back mode on Cyrix/NSC processor.\n");
 
 	/* CCR2 bit 2: unlock NW bit */
-	setCx86(CX86_CCR2, getCx86(CX86_CCR2) & ~0x04);
+	setCx86_old(CX86_CCR2, getCx86_old(CX86_CCR2) & ~0x04);
 	/* set 'Not Write-through' */
 	write_cr0(read_cr0() | X86_CR0_NW);
 	/* CCR2 bit 2: lock NW bit and set WT1 */
-	setCx86(CX86_CCR2, getCx86(CX86_CCR2) | 0x14);
+	setCx86_old(CX86_CCR2, getCx86_old(CX86_CCR2) | 0x14);
 }
 
 /*
@@ -150,14 +150,14 @@ static void __cpuinit geode_configure(void)
 	local_irq_save(flags);
 
 	/* Suspend on halt power saving and enable #SUSP pin */
-	setCx86(CX86_CCR2, getCx86(CX86_CCR2) | 0x88);
+	setCx86_old(CX86_CCR2, getCx86_old(CX86_CCR2) | 0x88);
 
 	ccr3 = getCx86(CX86_CCR3);
 	setCx86(CX86_CCR3, (ccr3 & 0x0f) | 0x10);	/* enable MAPEN */
 
 
 	/* FPU fast, DTE cache, Mem bypass */
-	setCx86(CX86_CCR4, getCx86(CX86_CCR4) | 0x38);
+	setCx86_old(CX86_CCR4, getCx86_old(CX86_CCR4) | 0x38);
 	setCx86(CX86_CCR3, ccr3);			/* disable MAPEN */
 
 	set_cx86_memwb();
@@ -291,7 +291,7 @@ static void __cpuinit init_cyrix(struct cpuinfo_x86 *c)
 		/* GXm supports extended cpuid levels 'ala' AMD */
 		if (c->cpuid_level == 2) {
 			/* Enable cxMMX extensions (GX1 Datasheet 54) */
-			setCx86(CX86_CCR7, getCx86(CX86_CCR7) | 1);
+			setCx86_old(CX86_CCR7, getCx86_old(CX86_CCR7) | 1);
 
 			/*
 			 * GXm : 0x30 ... 0x5f GXm  datasheet 51
@@ -301,7 +301,6 @@ static void __cpuinit init_cyrix(struct cpuinfo_x86 *c)
 			 */
 			if ((0x30 <= dir1 && dir1 <= 0x6f) || (0x80 <= dir1 && dir1 <= 0x8f))
 				geode_configure();
-			get_model_name(c);  /* get CPU marketing name */
 			return;
 		} else { /* MediaGX */
 			Cx86_cb[2] = (dir0_lsn & 1) ? '3' : '4';
@@ -314,7 +313,7 @@ static void __cpuinit init_cyrix(struct cpuinfo_x86 *c)
 		if (dir1 > 7) {
 			dir0_msn++;  /* M II */
 			/* Enable MMX extensions (App note 108) */
-			setCx86(CX86_CCR7, getCx86(CX86_CCR7)|1);
+			setCx86_old(CX86_CCR7, getCx86_old(CX86_CCR7)|1);
 		} else {
 			c->coma_bug = 1;      /* 6x86MX, it has the bug. */
 		}
@@ -429,7 +428,7 @@ static void __cpuinit cyrix_identify(struct cpuinfo_x86 *c)
 			local_irq_save(flags);
 			ccr3 = getCx86(CX86_CCR3);
 			setCx86(CX86_CCR3, (ccr3 & 0x0f) | 0x10);       /* enable MAPEN  */
-			setCx86(CX86_CCR4, getCx86(CX86_CCR4) | 0x80);  /* enable cpuid  */
+			setCx86_old(CX86_CCR4, getCx86_old(CX86_CCR4) | 0x80);  /* enable cpuid  */
 			setCx86(CX86_CCR3, ccr3);                       /* disable MAPEN */
 			local_irq_restore(flags);
 		}
@@ -442,14 +441,16 @@ static struct cpu_dev cyrix_cpu_dev __cpuinitdata = {
 	.c_early_init	= early_init_cyrix,
 	.c_init		= init_cyrix,
 	.c_identify	= cyrix_identify,
+	.c_x86_vendor	= X86_VENDOR_CYRIX,
 };
 
-cpu_vendor_dev_register(X86_VENDOR_CYRIX, &cyrix_cpu_dev);
+cpu_dev_register(cyrix_cpu_dev);
 
 static struct cpu_dev nsc_cpu_dev __cpuinitdata = {
 	.c_vendor	= "NSC",
 	.c_ident	= { "Geode by NSC" },
 	.c_init		= init_nsc,
+	.c_x86_vendor	= X86_VENDOR_NSC,
 };
 
-cpu_vendor_dev_register(X86_VENDOR_NSC, &nsc_cpu_dev);
+cpu_dev_register(nsc_cpu_dev);
diff --git a/arch/x86/kernel/cpu/feature_names.c b/arch/x86/kernel/cpu/feature_names.c
deleted file mode 100644
index b96b695..0000000
--- a/arch/x86/kernel/cpu/feature_names.c
+++ /dev/null
@@ -1,84 +0,0 @@
-/*
- * Strings for the various x86 capability flags.
- *
- * This file must not contain any executable code.
- */
-
-#include <asm/cpufeature.h>
-
-/*
- * These flag bits must match the definitions in <asm/cpufeature.h>.
- * NULL means this bit is undefined or reserved; either way it doesn't
- * have meaning as far as Linux is concerned.  Note that it's important
- * to realize there is a difference between this table and CPUID -- if
- * applications want to get the raw CPUID data, they should access
- * /dev/cpu/<cpu_nr>/cpuid instead.
- */
-const char * const x86_cap_flags[NCAPINTS*32] = {
-	/* Intel-defined */
-	"fpu", "vme", "de", "pse", "tsc", "msr", "pae", "mce",
-	"cx8", "apic", NULL, "sep", "mtrr", "pge", "mca", "cmov",
-	"pat", "pse36", "pn", "clflush", NULL, "dts", "acpi", "mmx",
-	"fxsr", "sse", "sse2", "ss", "ht", "tm", "ia64", "pbe",
-
-	/* AMD-defined */
-	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
-	NULL, NULL, NULL, "syscall", NULL, NULL, NULL, NULL,
-	NULL, NULL, NULL, "mp", "nx", NULL, "mmxext", NULL,
-	NULL, "fxsr_opt", "pdpe1gb", "rdtscp", NULL, "lm",
-	"3dnowext", "3dnow",
-
-	/* Transmeta-defined */
-	"recovery", "longrun", NULL, "lrti", NULL, NULL, NULL, NULL,
-	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
-	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
-	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
-
-	/* Other (Linux-defined) */
-	"cxmmx", "k6_mtrr", "cyrix_arr", "centaur_mcr",
-	NULL, NULL, NULL, NULL,
-	"constant_tsc", "up", NULL, "arch_perfmon",
-	"pebs", "bts", NULL, NULL,
-	"rep_good", NULL, NULL, NULL,
-	"nopl", NULL, NULL, NULL,
-	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
-
-	/* Intel-defined (#2) */
-	"pni", NULL, NULL, "monitor", "ds_cpl", "vmx", "smx", "est",
-	"tm2", "ssse3", "cid", NULL, NULL, "cx16", "xtpr", NULL,
-	NULL, NULL, "dca", "sse4_1", "sse4_2", "x2apic", NULL, "popcnt",
-	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
-
-	/* VIA/Cyrix/Centaur-defined */
-	NULL, NULL, "rng", "rng_en", NULL, NULL, "ace", "ace_en",
-	"ace2", "ace2_en", "phe", "phe_en", "pmm", "pmm_en", NULL, NULL,
-	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
-	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
-
-	/* AMD-defined (#2) */
-	"lahf_lm", "cmp_legacy", "svm", "extapic",
-	"cr8_legacy", "abm", "sse4a", "misalignsse",
-	"3dnowprefetch", "osvw", "ibs", "sse5",
-	"skinit", "wdt", NULL, NULL,
-	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
-	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
-
-	/* Auxiliary (Linux-defined) */
-	"ida", NULL, NULL, NULL, NULL, NULL, NULL, NULL,
-	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
-	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
-	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
-};
-
-const char *const x86_power_flags[32] = {
-	"ts",	/* temperature sensor */
-	"fid",  /* frequency id control */
-	"vid",  /* voltage id control */
-	"ttp",  /* thermal trip */
-	"tm",
-	"stc",
-	"100mhzsteps",
-	"hwpstate",
-	"",	/* tsc invariant mapped to constant_tsc */
-		/* nothing */
-};
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index f113ef4..99468db 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -15,6 +15,11 @@
 #include <asm/ds.h>
 #include <asm/bugs.h>
 
+#ifdef CONFIG_X86_64
+#include <asm/topology.h>
+#include <asm/numa_64.h>
+#endif
+
 #include "cpu.h"
 
 #ifdef CONFIG_X86_LOCAL_APIC
@@ -23,23 +28,22 @@
 #include <mach_apic.h>
 #endif
 
-#ifdef CONFIG_X86_INTEL_USERCOPY
-/*
- * Alignment at which movsl is preferred for bulk memory copies.
- */
-struct movsl_mask movsl_mask __read_mostly;
-#endif
-
 static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
 {
-	/* Netburst reports 64 bytes clflush size, but does IO in 128 bytes */
-	if (c->x86 == 15 && c->x86_cache_alignment == 64)
-		c->x86_cache_alignment = 128;
 	if ((c->x86 == 0xf && c->x86_model >= 0x03) ||
 		(c->x86 == 0x6 && c->x86_model >= 0x0e))
 		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
+
+#ifdef CONFIG_X86_64
+	set_cpu_cap(c, X86_FEATURE_SYSENTER32);
+#else
+	/* Netburst reports 64 bytes clflush size, but does IO in 128 bytes */
+	if (c->x86 == 15 && c->x86_cache_alignment == 64)
+		c->x86_cache_alignment = 128;
+#endif
 }
 
+#ifdef CONFIG_X86_32
 /*
  *	Early probe support logic for ppro memory erratum #50
  *
@@ -59,15 +63,54 @@ int __cpuinit ppro_with_ram_bug(void)
 	return 0;
 }
 
+#ifdef CONFIG_X86_F00F_BUG
+static void __cpuinit trap_init_f00f_bug(void)
+{
+	__set_fixmap(FIX_F00F_IDT, __pa(&idt_table), PAGE_KERNEL_RO);
 
-/*
- * P4 Xeon errata 037 workaround.
- * Hardware prefetcher may cause stale data to be loaded into the cache.
- */
-static void __cpuinit Intel_errata_workarounds(struct cpuinfo_x86 *c)
+	/*
+	 * Update the IDT descriptor and reload the IDT so that
+	 * it uses the read-only mapped virtual address.
+	 */
+	idt_descr.address = fix_to_virt(FIX_F00F_IDT);
+	load_idt(&idt_descr);
+}
+#endif
+
+static void __cpuinit intel_workarounds(struct cpuinfo_x86 *c)
 {
 	unsigned long lo, hi;
 
+#ifdef CONFIG_X86_F00F_BUG
+	/*
+	 * All current models of Pentium and Pentium with MMX technology CPUs
+	 * have the F0 0F bug, which lets nonprivileged users lock up the system.
+	 * Note that the workaround only should be initialized once...
+	 */
+	c->f00f_bug = 0;
+	if (!paravirt_enabled() && c->x86 == 5) {
+		static int f00f_workaround_enabled;
+
+		c->f00f_bug = 1;
+		if (!f00f_workaround_enabled) {
+			trap_init_f00f_bug();
+			printk(KERN_NOTICE "Intel Pentium with F0 0F bug - workaround enabled.\n");
+			f00f_workaround_enabled = 1;
+		}
+	}
+#endif
+
+	/*
+	 * SEP CPUID bug: Pentium Pro reports SEP but doesn't have it until
+	 * model 3 mask 3
+	 */
+	if ((c->x86<<8 | c->x86_model<<4 | c->x86_mask) < 0x633)
+		clear_cpu_cap(c, X86_FEATURE_SEP);
+
+	/*
+	 * P4 Xeon errata 037 workaround.
+	 * Hardware prefetcher may cause stale data to be loaded into the cache.
+	 */
 	if ((c->x86 == 15) && (c->x86_model == 1) && (c->x86_mask == 1)) {
 		rdmsr(MSR_IA32_MISC_ENABLE, lo, hi);
 		if ((lo & (1<<9)) == 0) {
@@ -77,13 +120,68 @@ static void __cpuinit Intel_errata_workarounds(struct cpuinfo_x86 *c)
 			wrmsr (MSR_IA32_MISC_ENABLE, lo, hi);
 		}
 	}
+
+	/*
+	 * See if we have a good local APIC by checking for buggy Pentia,
+	 * i.e. all B steppings and the C2 stepping of P54C when using their
+	 * integrated APIC (see 11AP erratum in "Pentium Processor
+	 * Specification Update").
+	 */
+	if (cpu_has_apic && (c->x86<<8 | c->x86_model<<4) == 0x520 &&
+	    (c->x86_mask < 0x6 || c->x86_mask == 0xb))
+		set_cpu_cap(c, X86_FEATURE_11AP);
+
+
+#ifdef CONFIG_X86_INTEL_USERCOPY
+	/*
+	 * Set up the preferred alignment for movsl bulk memory moves
+	 */
+	switch (c->x86) {
+	case 4:		/* 486: untested */
+		break;
+	case 5:		/* Old Pentia: untested */
+		break;
+	case 6:		/* PII/PIII only like movsl with 8-byte alignment */
+		movsl_mask.mask = 7;
+		break;
+	case 15:	/* P4 is OK down to 8-byte alignment */
+		movsl_mask.mask = 7;
+		break;
+	}
+#endif
+
+#ifdef CONFIG_X86_NUMAQ
+	numaq_tsc_disable();
+#endif
 }
+#else
+static void __cpuinit intel_workarounds(struct cpuinfo_x86 *c)
+{
+}
+#endif
 
+static void __cpuinit srat_detect_node(void)
+{
+#if defined(CONFIG_NUMA) && defined(CONFIG_X86_64)
+	unsigned node;
+	int cpu = smp_processor_id();
+	int apicid = hard_smp_processor_id();
+
+	/* Don't do the funky fallback heuristics the AMD version employs
+	   for now. */
+	node = apicid_to_node[apicid];
+	if (node == NUMA_NO_NODE || !node_online(node))
+		node = first_node(node_online_map);
+	numa_set_node(cpu, node);
+
+	printk(KERN_INFO "CPU %d/%x -> Node %d\n", cpu, apicid, node);
+#endif
+}
 
 /*
  * find out the number of processor cores on the die
  */
-static int __cpuinit num_cpu_cores(struct cpuinfo_x86 *c)
+static int __cpuinit intel_num_cpu_cores(struct cpuinfo_x86 *c)
 {
 	unsigned int eax, ebx, ecx, edx;
 
@@ -98,45 +196,51 @@ static int __cpuinit num_cpu_cores(struct cpuinfo_x86 *c)
 		return 1;
 }
 
-#ifdef CONFIG_X86_F00F_BUG
-static void __cpuinit trap_init_f00f_bug(void)
+static void __cpuinit detect_vmx_virtcap(struct cpuinfo_x86 *c)
 {
-	__set_fixmap(FIX_F00F_IDT, __pa(&idt_table), PAGE_KERNEL_RO);
-
-	/*
-	 * Update the IDT descriptor and reload the IDT so that
-	 * it uses the read-only mapped virtual address.
-	 */
-	idt_descr.address = fix_to_virt(FIX_F00F_IDT);
-	load_idt(&idt_descr);
+	/* Intel VMX MSR indicated features */
+#define X86_VMX_FEATURE_PROC_CTLS_TPR_SHADOW	0x00200000
+#define X86_VMX_FEATURE_PROC_CTLS_VNMI		0x00400000
+#define X86_VMX_FEATURE_PROC_CTLS_2ND_CTLS	0x80000000
+#define X86_VMX_FEATURE_PROC_CTLS2_VIRT_APIC	0x00000001
+#define X86_VMX_FEATURE_PROC_CTLS2_EPT		0x00000002
+#define X86_VMX_FEATURE_PROC_CTLS2_VPID		0x00000020
+
+	u32 vmx_msr_low, vmx_msr_high, msr_ctl, msr_ctl2;
+
+	clear_cpu_cap(c, X86_FEATURE_TPR_SHADOW);
+	clear_cpu_cap(c, X86_FEATURE_VNMI);
+	clear_cpu_cap(c, X86_FEATURE_FLEXPRIORITY);
+	clear_cpu_cap(c, X86_FEATURE_EPT);
+	clear_cpu_cap(c, X86_FEATURE_VPID);
+
+	rdmsr(MSR_IA32_VMX_PROCBASED_CTLS, vmx_msr_low, vmx_msr_high);
+	msr_ctl = vmx_msr_high | vmx_msr_low;
+	if (msr_ctl & X86_VMX_FEATURE_PROC_CTLS_TPR_SHADOW)
+		set_cpu_cap(c, X86_FEATURE_TPR_SHADOW);
+	if (msr_ctl & X86_VMX_FEATURE_PROC_CTLS_VNMI)
+		set_cpu_cap(c, X86_FEATURE_VNMI);
+	if (msr_ctl & X86_VMX_FEATURE_PROC_CTLS_2ND_CTLS) {
+		rdmsr(MSR_IA32_VMX_PROCBASED_CTLS2,
+		      vmx_msr_low, vmx_msr_high);
+		msr_ctl2 = vmx_msr_high | vmx_msr_low;
+		if ((msr_ctl2 & X86_VMX_FEATURE_PROC_CTLS2_VIRT_APIC) &&
+		    (msr_ctl & X86_VMX_FEATURE_PROC_CTLS_TPR_SHADOW))
+			set_cpu_cap(c, X86_FEATURE_FLEXPRIORITY);
+		if (msr_ctl2 & X86_VMX_FEATURE_PROC_CTLS2_EPT)
+			set_cpu_cap(c, X86_FEATURE_EPT);
+		if (msr_ctl2 & X86_VMX_FEATURE_PROC_CTLS2_VPID)
+			set_cpu_cap(c, X86_FEATURE_VPID);
+	}
 }
-#endif
 
 static void __cpuinit init_intel(struct cpuinfo_x86 *c)
 {
 	unsigned int l2 = 0;
-	char *p = NULL;
 
 	early_init_intel(c);
 
-#ifdef CONFIG_X86_F00F_BUG
-	/*
-	 * All current models of Pentium and Pentium with MMX technology CPUs
-	 * have the F0 0F bug, which lets nonprivileged users lock up the system.
-	 * Note that the workaround only should be initialized once...
-	 */
-	c->f00f_bug = 0;
-	if (!paravirt_enabled() && c->x86 == 5) {
-		static int f00f_workaround_enabled;
-
-		c->f00f_bug = 1;
-		if (!f00f_workaround_enabled) {
-			trap_init_f00f_bug();
-			printk(KERN_NOTICE "Intel Pentium with F0 0F bug - workaround enabled.\n");
-			f00f_workaround_enabled = 1;
-		}
-	}
-#endif
+	intel_workarounds(c);
 
 	l2 = init_intel_cacheinfo(c);
 	if (c->cpuid_level > 9) {
@@ -146,16 +250,32 @@ static void __cpuinit init_intel(struct cpuinfo_x86 *c)
 			set_cpu_cap(c, X86_FEATURE_ARCH_PERFMON);
 	}
 
-	/* SEP CPUID bug: Pentium Pro reports SEP but doesn't have it until model 3 mask 3 */
-	if ((c->x86<<8 | c->x86_model<<4 | c->x86_mask) < 0x633)
-		clear_cpu_cap(c, X86_FEATURE_SEP);
+	if (cpu_has_xmm2)
+		set_cpu_cap(c, X86_FEATURE_LFENCE_RDTSC);
+	if (cpu_has_ds) {
+		unsigned int l1;
+		rdmsr(MSR_IA32_MISC_ENABLE, l1, l2);
+		if (!(l1 & (1<<11)))
+			set_cpu_cap(c, X86_FEATURE_BTS);
+		if (!(l1 & (1<<12)))
+			set_cpu_cap(c, X86_FEATURE_PEBS);
+		ds_init_intel(c);
+	}
 
+#ifdef CONFIG_X86_64
+	if (c->x86 == 15)
+		c->x86_cache_alignment = c->x86_clflush_size * 2;
+	if (c->x86 == 6)
+		set_cpu_cap(c, X86_FEATURE_REP_GOOD);
+#else
 	/*
 	 * Names for the Pentium II/Celeron processors
 	 * detectable only by also checking the cache size.
 	 * Dixon is NOT a Celeron.
 	 */
 	if (c->x86 == 6) {
+		char *p = NULL;
+
 		switch (c->x86_model) {
 		case 5:
 			if (c->x86_mask == 0) {
@@ -178,71 +298,41 @@ static void __cpuinit init_intel(struct cpuinfo_x86 *c)
 				p = "Celeron (Coppermine)";
 			break;
 		}
-	}
-
-	if (p)
-		strcpy(c->x86_model_id, p);
-
-	c->x86_max_cores = num_cpu_cores(c);
-
-	detect_ht(c);
 
-	/* Work around errata */
-	Intel_errata_workarounds(c);
-
-#ifdef CONFIG_X86_INTEL_USERCOPY
-	/*
-	 * Set up the preferred alignment for movsl bulk memory moves
-	 */
-	switch (c->x86) {
-	case 4:		/* 486: untested */
-		break;
-	case 5:		/* Old Pentia: untested */
-		break;
-	case 6:		/* PII/PIII only like movsl with 8-byte alignment */
-		movsl_mask.mask = 7;
-		break;
-	case 15:	/* P4 is OK down to 8-byte alignment */
-		movsl_mask.mask = 7;
-		break;
+		if (p)
+			strcpy(c->x86_model_id, p);
 	}
-#endif
 
-	if (cpu_has_xmm2)
-		set_cpu_cap(c, X86_FEATURE_LFENCE_RDTSC);
-	if (c->x86 == 15) {
+	if (c->x86 == 15)
 		set_cpu_cap(c, X86_FEATURE_P4);
-	}
 	if (c->x86 == 6)
 		set_cpu_cap(c, X86_FEATURE_P3);
-	if (cpu_has_ds) {
-		unsigned int l1;
-		rdmsr(MSR_IA32_MISC_ENABLE, l1, l2);
-		if (!(l1 & (1<<11)))
-			set_cpu_cap(c, X86_FEATURE_BTS);
-		if (!(l1 & (1<<12)))
-			set_cpu_cap(c, X86_FEATURE_PEBS);
-		ds_init_intel(c);
-	}
 
 	if (cpu_has_bts)
 		ptrace_bts_init_intel(c);
 
-	/*
-	 * See if we have a good local APIC by checking for buggy Pentia,
-	 * i.e. all B steppings and the C2 stepping of P54C when using their
-	 * integrated APIC (see 11AP erratum in "Pentium Processor
-	 * Specification Update").
-	 */
-	if (cpu_has_apic && (c->x86<<8 | c->x86_model<<4) == 0x520 &&
-	    (c->x86_mask < 0x6 || c->x86_mask == 0xb))
-		set_cpu_cap(c, X86_FEATURE_11AP);
+#endif
 
-#ifdef CONFIG_X86_NUMAQ
-	numaq_tsc_disable();
+	detect_extended_topology(c);
+	if (!cpu_has(c, X86_FEATURE_XTOPOLOGY)) {
+		/*
+		 * let's use the legacy cpuid vector 0x1 and 0x4 for topology
+		 * detection.
+		 */
+		c->x86_max_cores = intel_num_cpu_cores(c);
+#ifdef CONFIG_X86_32
+		detect_ht(c);
 #endif
+	}
+
+	/* Work around errata */
+	srat_detect_node();
+
+	if (cpu_has(c, X86_FEATURE_VMX))
+		detect_vmx_virtcap(c);
 }
 
+#ifdef CONFIG_X86_32
 static unsigned int __cpuinit intel_size_cache(struct cpuinfo_x86 *c, unsigned int size)
 {
 	/*
@@ -255,10 +345,12 @@ static unsigned int __cpuinit intel_size_cache(struct cpuinfo_x86 *c, unsigned i
 		size = 256;
 	return size;
 }
+#endif
 
 static struct cpu_dev intel_cpu_dev __cpuinitdata = {
 	.c_vendor	= "Intel",
 	.c_ident	= { "GenuineIntel" },
+#ifdef CONFIG_X86_32
 	.c_models = {
 		{ .vendor = X86_VENDOR_INTEL, .family = 4, .model_names =
 		  {
@@ -308,76 +400,12 @@ static struct cpu_dev intel_cpu_dev __cpuinitdata = {
 		  }
 		},
 	},
+	.c_size_cache	= intel_size_cache,
+#endif
 	.c_early_init   = early_init_intel,
 	.c_init		= init_intel,
-	.c_size_cache	= intel_size_cache,
+	.c_x86_vendor	= X86_VENDOR_INTEL,
 };
 
-cpu_vendor_dev_register(X86_VENDOR_INTEL, &intel_cpu_dev);
-
-#ifndef CONFIG_X86_CMPXCHG
-unsigned long cmpxchg_386_u8(volatile void *ptr, u8 old, u8 new)
-{
-	u8 prev;
-	unsigned long flags;
-
-	/* Poor man's cmpxchg for 386. Unsuitable for SMP */
-	local_irq_save(flags);
-	prev = *(u8 *)ptr;
-	if (prev == old)
-		*(u8 *)ptr = new;
-	local_irq_restore(flags);
-	return prev;
-}
-EXPORT_SYMBOL(cmpxchg_386_u8);
-
-unsigned long cmpxchg_386_u16(volatile void *ptr, u16 old, u16 new)
-{
-	u16 prev;
-	unsigned long flags;
-
-	/* Poor man's cmpxchg for 386. Unsuitable for SMP */
-	local_irq_save(flags);
-	prev = *(u16 *)ptr;
-	if (prev == old)
-		*(u16 *)ptr = new;
-	local_irq_restore(flags);
-	return prev;
-}
-EXPORT_SYMBOL(cmpxchg_386_u16);
-
-unsigned long cmpxchg_386_u32(volatile void *ptr, u32 old, u32 new)
-{
-	u32 prev;
-	unsigned long flags;
-
-	/* Poor man's cmpxchg for 386. Unsuitable for SMP */
-	local_irq_save(flags);
-	prev = *(u32 *)ptr;
-	if (prev == old)
-		*(u32 *)ptr = new;
-	local_irq_restore(flags);
-	return prev;
-}
-EXPORT_SYMBOL(cmpxchg_386_u32);
-#endif
-
-#ifndef CONFIG_X86_CMPXCHG64
-unsigned long long cmpxchg_486_u64(volatile void *ptr, u64 old, u64 new)
-{
-	u64 prev;
-	unsigned long flags;
-
-	/* Poor man's cmpxchg8b for 386 and 486. Unsuitable for SMP */
-	local_irq_save(flags);
-	prev = *(u64 *)ptr;
-	if (prev == old)
-		*(u64 *)ptr = new;
-	local_irq_restore(flags);
-	return prev;
-}
-EXPORT_SYMBOL(cmpxchg_486_u64);
-#endif
-
-/* arch_initcall(intel_cpu_init); */
+cpu_dev_register(intel_cpu_dev);
 
diff --git a/arch/x86/kernel/cpu/intel_64.c b/arch/x86/kernel/cpu/intel_64.c
deleted file mode 100644
index 1019c58..0000000
--- a/arch/x86/kernel/cpu/intel_64.c
+++ /dev/null
@@ -1,95 +0,0 @@
-#include <linux/init.h>
-#include <linux/smp.h>
-#include <asm/processor.h>
-#include <asm/ptrace.h>
-#include <asm/topology.h>
-#include <asm/numa_64.h>
-
-#include "cpu.h"
-
-static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
-{
-	if ((c->x86 == 0xf && c->x86_model >= 0x03) ||
-	    (c->x86 == 0x6 && c->x86_model >= 0x0e))
-		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
-
-	set_cpu_cap(c, X86_FEATURE_SYSENTER32);
-}
-
-/*
- * find out the number of processor cores on the die
- */
-static int __cpuinit intel_num_cpu_cores(struct cpuinfo_x86 *c)
-{
-	unsigned int eax, t;
-
-	if (c->cpuid_level < 4)
-		return 1;
-
-	cpuid_count(4, 0, &eax, &t, &t, &t);
-
-	if (eax & 0x1f)
-		return ((eax >> 26) + 1);
-	else
-		return 1;
-}
-
-static void __cpuinit srat_detect_node(void)
-{
-#ifdef CONFIG_NUMA
-	unsigned node;
-	int cpu = smp_processor_id();
-	int apicid = hard_smp_processor_id();
-
-	/* Don't do the funky fallback heuristics the AMD version employs
-	   for now. */
-	node = apicid_to_node[apicid];
-	if (node == NUMA_NO_NODE || !node_online(node))
-		node = first_node(node_online_map);
-	numa_set_node(cpu, node);
-
-	printk(KERN_INFO "CPU %d/%x -> Node %d\n", cpu, apicid, node);
-#endif
-}
-
-static void __cpuinit init_intel(struct cpuinfo_x86 *c)
-{
-	init_intel_cacheinfo(c);
-	if (c->cpuid_level > 9) {
-		unsigned eax = cpuid_eax(10);
-		/* Check for version and the number of counters */
-		if ((eax & 0xff) && (((eax>>8) & 0xff) > 1))
-			set_cpu_cap(c, X86_FEATURE_ARCH_PERFMON);
-	}
-
-	if (cpu_has_ds) {
-		unsigned int l1, l2;
-		rdmsr(MSR_IA32_MISC_ENABLE, l1, l2);
-		if (!(l1 & (1<<11)))
-			set_cpu_cap(c, X86_FEATURE_BTS);
-		if (!(l1 & (1<<12)))
-			set_cpu_cap(c, X86_FEATURE_PEBS);
-	}
-
-
-	if (cpu_has_bts)
-		ds_init_intel(c);
-
-	if (c->x86 == 15)
-		c->x86_cache_alignment = c->x86_clflush_size * 2;
-	if (c->x86 == 6)
-		set_cpu_cap(c, X86_FEATURE_REP_GOOD);
-	set_cpu_cap(c, X86_FEATURE_LFENCE_RDTSC);
-	c->x86_max_cores = intel_num_cpu_cores(c);
-
-	srat_detect_node();
-}
-
-static struct cpu_dev intel_cpu_dev __cpuinitdata = {
-	.c_vendor	= "Intel",
-	.c_ident	= { "GenuineIntel" },
-	.c_early_init   = early_init_intel,
-	.c_init		= init_intel,
-};
-cpu_vendor_dev_register(X86_VENDOR_INTEL, &intel_cpu_dev);
-
diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 6b0a10b..3f46afb 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -1,8 +1,8 @@
 /*
- *      Routines to indentify caches on Intel CPU.
+ *	Routines to indentify caches on Intel CPU.
  *
- *      Changes:
- *      Venkatesh Pallipadi	: Adding cache identification through cpuid(4)
+ *	Changes:
+ *	Venkatesh Pallipadi	: Adding cache identification through cpuid(4)
  *		Ashok Raj <ashok.raj@intel.com>: Work with CPU hotplug infrastructure.
  *	Andi Kleen / Andreas Herrmann	: CPUID4 emulation on AMD.
  */
@@ -13,6 +13,7 @@
 #include <linux/compiler.h>
 #include <linux/cpu.h>
 #include <linux/sched.h>
+#include <linux/pci.h>
 
 #include <asm/processor.h>
 #include <asm/smp.h>
@@ -130,9 +131,18 @@ struct _cpuid4_info {
 	union _cpuid4_leaf_ebx ebx;
 	union _cpuid4_leaf_ecx ecx;
 	unsigned long size;
+	unsigned long can_disable;
 	cpumask_t shared_cpu_map;	/* future?: only cpus/node is needed */
 };
 
+#ifdef CONFIG_PCI
+static struct pci_device_id k8_nb_id[] = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, 0x1103) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, 0x1203) },
+	{}
+};
+#endif
+
 unsigned short			num_cache_leaves;
 
 /* AMD doesn't have CPUID4. Emulate it here to report the same
@@ -182,9 +192,10 @@ static unsigned short assocs[] __cpuinitdata = {
 static unsigned char levels[] __cpuinitdata = { 1, 1, 2, 3 };
 static unsigned char types[] __cpuinitdata = { 1, 2, 3, 3 };
 
-static void __cpuinit amd_cpuid4(int leaf, union _cpuid4_leaf_eax *eax,
-		       union _cpuid4_leaf_ebx *ebx,
-		       union _cpuid4_leaf_ecx *ecx)
+static void __cpuinit
+amd_cpuid4(int leaf, union _cpuid4_leaf_eax *eax,
+		     union _cpuid4_leaf_ebx *ebx,
+		     union _cpuid4_leaf_ecx *ecx)
 {
 	unsigned dummy;
 	unsigned line_size, lines_per_tag, assoc, size_in_kb;
@@ -251,27 +262,40 @@ static void __cpuinit amd_cpuid4(int leaf, union _cpuid4_leaf_eax *eax,
 		(ebx->split.ways_of_associativity + 1) - 1;
 }
 
-static int __cpuinit cpuid4_cache_lookup(int index, struct _cpuid4_info *this_leaf)
+static void __cpuinit
+amd_check_l3_disable(int index, struct _cpuid4_info *this_leaf)
+{
+	if (index < 3)
+		return;
+	this_leaf->can_disable = 1;
+}
+
+static int
+__cpuinit cpuid4_cache_lookup(int index, struct _cpuid4_info *this_leaf)
 {
 	union _cpuid4_leaf_eax 	eax;
 	union _cpuid4_leaf_ebx 	ebx;
 	union _cpuid4_leaf_ecx 	ecx;
 	unsigned		edx;
 
-	if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD)
+	if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD) {
 		amd_cpuid4(index, &eax, &ebx, &ecx);
-	else
-		cpuid_count(4, index, &eax.full, &ebx.full, &ecx.full,  &edx);
+		if (boot_cpu_data.x86 >= 0x10)
+			amd_check_l3_disable(index, this_leaf);
+	} else {
+		cpuid_count(4, index, &eax.full, &ebx.full, &ecx.full, &edx);
+	}
+
 	if (eax.split.type == CACHE_TYPE_NULL)
 		return -EIO; /* better error ? */
 
 	this_leaf->eax = eax;
 	this_leaf->ebx = ebx;
 	this_leaf->ecx = ecx;
-	this_leaf->size = (ecx.split.number_of_sets + 1) *
-		(ebx.split.coherency_line_size + 1) *
-		(ebx.split.physical_line_partition + 1) *
-		(ebx.split.ways_of_associativity + 1);
+	this_leaf->size = (ecx.split.number_of_sets          + 1) *
+			  (ebx.split.coherency_line_size     + 1) *
+			  (ebx.split.physical_line_partition + 1) *
+			  (ebx.split.ways_of_associativity   + 1);
 	return 0;
 }
 
@@ -453,7 +477,7 @@ unsigned int __cpuinit init_intel_cacheinfo(struct cpuinfo_x86 *c)
 
 /* pointer to _cpuid4_info array (for each cache leaf) */
 static DEFINE_PER_CPU(struct _cpuid4_info *, cpuid4_info);
-#define CPUID4_INFO_IDX(x, y)    (&((per_cpu(cpuid4_info, x))[y]))
+#define CPUID4_INFO_IDX(x, y)	(&((per_cpu(cpuid4_info, x))[y]))
 
 #ifdef CONFIG_SMP
 static void __cpuinit cache_shared_cpu_map_setup(unsigned int cpu, int index)
@@ -490,7 +514,7 @@ static void __cpuinit cache_remove_shared_cpu_map(unsigned int cpu, int index)
 
 	this_leaf = CPUID4_INFO_IDX(cpu, index);
 	for_each_cpu_mask_nr(sibling, this_leaf->shared_cpu_map) {
-		sibling_leaf = CPUID4_INFO_IDX(sibling, index);	
+		sibling_leaf = CPUID4_INFO_IDX(sibling, index);
 		cpu_clear(cpu, sibling_leaf->shared_cpu_map);
 	}
 }
@@ -572,7 +596,7 @@ struct _index_kobject {
 
 /* pointer to array of kobjects for cpuX/cache/indexY */
 static DEFINE_PER_CPU(struct _index_kobject *, index_kobject);
-#define INDEX_KOBJECT_PTR(x, y)    (&((per_cpu(index_kobject, x))[y]))
+#define INDEX_KOBJECT_PTR(x, y)		(&((per_cpu(index_kobject, x))[y]))
 
 #define show_one_plus(file_name, object, val)				\
 static ssize_t show_##file_name						\
@@ -637,6 +661,99 @@ static ssize_t show_type(struct _cpuid4_info *this_leaf, char *buf) {
 	}
 }
 
+#define to_object(k)	container_of(k, struct _index_kobject, kobj)
+#define to_attr(a)	container_of(a, struct _cache_attr, attr)
+
+#ifdef CONFIG_PCI
+static struct pci_dev *get_k8_northbridge(int node)
+{
+	struct pci_dev *dev = NULL;
+	int i;
+
+	for (i = 0; i <= node; i++) {
+		do {
+			dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev);
+			if (!dev)
+				break;
+		} while (!pci_match_id(&k8_nb_id[0], dev));
+		if (!dev)
+			break;
+	}
+	return dev;
+}
+#else
+static struct pci_dev *get_k8_northbridge(int node)
+{
+	return NULL;
+}
+#endif
+
+static ssize_t show_cache_disable(struct _cpuid4_info *this_leaf, char *buf)
+{
+	int node = cpu_to_node(first_cpu(this_leaf->shared_cpu_map));
+	struct pci_dev *dev = NULL;
+	ssize_t ret = 0;
+	int i;
+
+	if (!this_leaf->can_disable)
+		return sprintf(buf, "Feature not enabled\n");
+
+	dev = get_k8_northbridge(node);
+	if (!dev) {
+		printk(KERN_ERR "Attempting AMD northbridge operation on a system with no northbridge\n");
+		return -EINVAL;
+	}
+
+	for (i = 0; i < 2; i++) {
+		unsigned int reg;
+
+		pci_read_config_dword(dev, 0x1BC + i * 4, &reg);
+
+		ret += sprintf(buf, "%sEntry: %d\n", buf, i);
+		ret += sprintf(buf, "%sReads:  %s\tNew Entries: %s\n",  
+			buf,
+			reg & 0x80000000 ? "Disabled" : "Allowed",
+			reg & 0x40000000 ? "Disabled" : "Allowed");
+		ret += sprintf(buf, "%sSubCache: %x\tIndex: %x\n",
+			buf, (reg & 0x30000) >> 16, reg & 0xfff);
+	}
+	return ret;
+}
+
+static ssize_t
+store_cache_disable(struct _cpuid4_info *this_leaf, const char *buf,
+		    size_t count)
+{
+	int node = cpu_to_node(first_cpu(this_leaf->shared_cpu_map));
+	struct pci_dev *dev = NULL;
+	unsigned int ret, index, val;
+
+	if (!this_leaf->can_disable)
+		return 0;
+
+	if (strlen(buf) > 15)
+		return -EINVAL;
+
+	ret = sscanf(buf, "%x %x", &index, &val);
+	if (ret != 2)
+		return -EINVAL;
+	if (index > 1)
+		return -EINVAL;
+
+	val |= 0xc0000000;
+	dev = get_k8_northbridge(node);
+	if (!dev) {
+		printk(KERN_ERR "Attempting AMD northbridge operation on a system with no northbridge\n");
+		return -EINVAL;
+	}
+
+	pci_write_config_dword(dev, 0x1BC + index * 4, val & ~0x40000000);
+	wbinvd();
+	pci_write_config_dword(dev, 0x1BC + index * 4, val);
+
+	return 1;
+}
+
 struct _cache_attr {
 	struct attribute attr;
 	ssize_t (*show)(struct _cpuid4_info *, char *);
@@ -657,6 +774,8 @@ define_one_ro(size);
 define_one_ro(shared_cpu_map);
 define_one_ro(shared_cpu_list);
 
+static struct _cache_attr cache_disable = __ATTR(cache_disable, 0644, show_cache_disable, store_cache_disable);
+
 static struct attribute * default_attrs[] = {
 	&type.attr,
 	&level.attr,
@@ -667,12 +786,10 @@ static struct attribute * default_attrs[] = {
 	&size.attr,
 	&shared_cpu_map.attr,
 	&shared_cpu_list.attr,
+	&cache_disable.attr,
 	NULL
 };
 
-#define to_object(k) container_of(k, struct _index_kobject, kobj)
-#define to_attr(a) container_of(a, struct _cache_attr, attr)
-
 static ssize_t show(struct kobject * kobj, struct attribute * attr, char * buf)
 {
 	struct _cache_attr *fattr = to_attr(attr);
@@ -682,14 +799,22 @@ static ssize_t show(struct kobject * kobj, struct attribute * attr, char * buf)
 	ret = fattr->show ?
 		fattr->show(CPUID4_INFO_IDX(this_leaf->cpu, this_leaf->index),
 			buf) :
-	       	0;
+		0;
 	return ret;
 }
 
 static ssize_t store(struct kobject * kobj, struct attribute * attr,
 		     const char * buf, size_t count)
 {
-	return 0;
+	struct _cache_attr *fattr = to_attr(attr);
+	struct _index_kobject *this_leaf = to_object(kobj);
+	ssize_t ret;
+
+	ret = fattr->store ?
+		fattr->store(CPUID4_INFO_IDX(this_leaf->cpu, this_leaf->index),
+			buf, count) :
+		0;
+	return ret;
 }
 
 static struct sysfs_ops sysfs_ops = {
diff --git a/arch/x86/kernel/cpu/mcheck/mce_64.c b/arch/x86/kernel/cpu/mcheck/mce_64.c
index 726a5fc..4b031a4 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_64.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_64.c
@@ -860,7 +860,7 @@ error:
 	return err;
 }
 
-static void mce_remove_device(unsigned int cpu)
+static __cpuinit void mce_remove_device(unsigned int cpu)
 {
 	int i;
 
diff --git a/arch/x86/kernel/cpu/mkcapflags.pl b/arch/x86/kernel/cpu/mkcapflags.pl
new file mode 100644
index 0000000..dfea390
--- /dev/null
+++ b/arch/x86/kernel/cpu/mkcapflags.pl
@@ -0,0 +1,32 @@
+#!/usr/bin/perl
+#
+# Generate the x86_cap_flags[] array from include/asm-x86/cpufeature.h
+#
+
+($in, $out) = @ARGV;
+
+open(IN, "< $in\0")   or die "$0: cannot open: $in: $!\n";
+open(OUT, "> $out\0") or die "$0: cannot create: $out: $!\n";
+
+print OUT "#include <asm/cpufeature.h>\n\n";
+print OUT "const char * const x86_cap_flags[NCAPINTS*32] = {\n";
+
+while (defined($line = <IN>)) {
+	if ($line =~ /^\s*\#\s*define\s+(X86_FEATURE_(\S+))\s+(.*)$/) {
+		$macro = $1;
+		$feature = $2;
+		$tail = $3;
+		if ($tail =~ /\/\*\s*\"([^"]*)\".*\*\//) {
+			$feature = $1;
+		}
+
+		if ($feature ne '') {
+			printf OUT "\t%-32s = \"%s\",\n",
+				"[$macro]", "\L$feature";
+		}
+	}
+}
+print OUT "};\n";
+
+close(IN);
+close(OUT);
diff --git a/arch/x86/kernel/cpu/powerflags.c b/arch/x86/kernel/cpu/powerflags.c
new file mode 100644
index 0000000..5abbea2
--- /dev/null
+++ b/arch/x86/kernel/cpu/powerflags.c
@@ -0,0 +1,20 @@
+/*
+ * Strings for the various x86 power flags
+ *
+ * This file must not contain any executable code.
+ */
+
+#include <asm/cpufeature.h>
+
+const char *const x86_power_flags[32] = {
+	"ts",	/* temperature sensor */
+	"fid",  /* frequency id control */
+	"vid",  /* voltage id control */
+	"ttp",  /* thermal trip */
+	"tm",
+	"stc",
+	"100mhzsteps",
+	"hwpstate",
+	"",	/* tsc invariant mapped to constant_tsc */
+		/* nothing */
+};
diff --git a/arch/x86/kernel/cpu/transmeta.c b/arch/x86/kernel/cpu/transmeta.c
index b911a2c..52b3fef 100644
--- a/arch/x86/kernel/cpu/transmeta.c
+++ b/arch/x86/kernel/cpu/transmeta.c
@@ -5,6 +5,18 @@
 #include <asm/msr.h>
 #include "cpu.h"
 
+static void __cpuinit early_init_transmeta(struct cpuinfo_x86 *c)
+{
+	u32 xlvl;
+
+	/* Transmeta-defined flags: level 0x80860001 */
+	xlvl = cpuid_eax(0x80860000);
+	if ((xlvl & 0xffff0000) == 0x80860000) {
+		if (xlvl >= 0x80860001)
+			c->x86_capability[2] = cpuid_edx(0x80860001);
+	}
+}
+
 static void __cpuinit init_transmeta(struct cpuinfo_x86 *c)
 {
 	unsigned int cap_mask, uk, max, dummy;
@@ -12,7 +24,8 @@ static void __cpuinit init_transmeta(struct cpuinfo_x86 *c)
 	unsigned int cpu_rev, cpu_freq = 0, cpu_flags, new_cpu_rev;
 	char cpu_info[65];
 
-	get_model_name(c);	/* Same as AMD/Cyrix */
+	early_init_transmeta(c);
+
 	display_cacheinfo(c);
 
 	/* Print CMS and CPU revision */
@@ -85,23 +98,12 @@ static void __cpuinit init_transmeta(struct cpuinfo_x86 *c)
 #endif
 }
 
-static void __cpuinit transmeta_identify(struct cpuinfo_x86 *c)
-{
-	u32 xlvl;
-
-	/* Transmeta-defined flags: level 0x80860001 */
-	xlvl = cpuid_eax(0x80860000);
-	if ((xlvl & 0xffff0000) == 0x80860000) {
-		if (xlvl >= 0x80860001)
-			c->x86_capability[2] = cpuid_edx(0x80860001);
-	}
-}
-
 static struct cpu_dev transmeta_cpu_dev __cpuinitdata = {
 	.c_vendor	= "Transmeta",
 	.c_ident	= { "GenuineTMx86", "TransmetaCPU" },
+	.c_early_init	= early_init_transmeta,
 	.c_init		= init_transmeta,
-	.c_identify	= transmeta_identify,
+	.c_x86_vendor	= X86_VENDOR_TRANSMETA,
 };
 
-cpu_vendor_dev_register(X86_VENDOR_TRANSMETA, &transmeta_cpu_dev);
+cpu_dev_register(transmeta_cpu_dev);
diff --git a/arch/x86/kernel/cpu/umc.c b/arch/x86/kernel/cpu/umc.c
index b1fc909..e777f79 100644
--- a/arch/x86/kernel/cpu/umc.c
+++ b/arch/x86/kernel/cpu/umc.c
@@ -19,7 +19,8 @@ static struct cpu_dev umc_cpu_dev __cpuinitdata = {
 		  }
 		},
 	},
+	.c_x86_vendor	= X86_VENDOR_UMC,
 };
 
-cpu_vendor_dev_register(X86_VENDOR_UMC, &umc_cpu_dev);
+cpu_dev_register(umc_cpu_dev);
 
diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 66e48aa..78e642f 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -148,6 +148,9 @@ void __init e820_print_map(char *who)
 		case E820_NVS:
 			printk(KERN_CONT "(ACPI NVS)\n");
 			break;
+		case E820_UNUSABLE:
+			printk("(unusable)\n");
+			break;
 		default:
 			printk(KERN_CONT "type %u\n", e820.map[i].type);
 			break;
@@ -1260,6 +1263,7 @@ static inline const char *e820_type_to_string(int e820_type)
 	case E820_RAM:	return "System RAM";
 	case E820_ACPI:	return "ACPI Tables";
 	case E820_NVS:	return "ACPI Non-volatile Storage";
+	case E820_UNUSABLE:	return "Unusable memory";
 	default:	return "reserved";
 	}
 }
@@ -1267,6 +1271,7 @@ static inline const char *e820_type_to_string(int e820_type)
 /*
  * Mark e820 reserved areas as busy for the resource manager.
  */
+static struct resource __initdata *e820_res;
 void __init e820_reserve_resources(void)
 {
 	int i;
@@ -1274,6 +1279,7 @@ void __init e820_reserve_resources(void)
 	u64 end;
 
 	res = alloc_bootmem_low(sizeof(struct resource) * e820.nr_map);
+	e820_res = res;
 	for (i = 0; i < e820.nr_map; i++) {
 		end = e820.map[i].addr + e820.map[i].size - 1;
 #ifndef CONFIG_RESOURCES_64BIT
@@ -1287,7 +1293,14 @@ void __init e820_reserve_resources(void)
 		res->end = end;
 
 		res->flags = IORESOURCE_MEM | IORESOURCE_BUSY;
-		insert_resource(&iomem_resource, res);
+
+		/*
+		 * don't register the region that could be conflicted with
+		 * pci device BAR resource and insert them later in
+		 * pcibios_resource_survey()
+		 */
+		if (e820.map[i].type != E820_RESERVED || res->start < (1ULL<<20))
+			insert_resource(&iomem_resource, res);
 		res++;
 	}
 
@@ -1299,6 +1312,19 @@ void __init e820_reserve_resources(void)
 	}
 }
 
+void __init e820_reserve_resources_late(void)
+{
+	int i;
+	struct resource *res;
+
+	res = e820_res;
+	for (i = 0; i < e820.nr_map; i++) {
+		if (!res->parent && res->end)
+			reserve_region_with_split(&iomem_resource, res->start, res->end, res->name);
+		res++;
+	}
+}
+
 char *__init default_machine_specific_memory_setup(void)
 {
 	char *who = "BIOS-e820";
diff --git a/arch/x86/es7000/es7000plat.c b/arch/x86/kernel/es7000_32.c
similarity index 78%
rename from arch/x86/es7000/es7000plat.c
rename to arch/x86/kernel/es7000_32.c
index 7789fde..849e5cd 100644
--- a/arch/x86/es7000/es7000plat.c
+++ b/arch/x86/kernel/es7000_32.c
@@ -39,10 +39,93 @@
 #include <asm/nmi.h>
 #include <asm/smp.h>
 #include <asm/apicdef.h>
-#include "es7000.h"
 #include <mach_mpparse.h>
 
 /*
+ * ES7000 chipsets
+ */
+
+#define NON_UNISYS		0
+#define ES7000_CLASSIC		1
+#define ES7000_ZORRO		2
+
+
+#define	MIP_REG			1
+#define	MIP_PSAI_REG		4
+
+#define	MIP_BUSY		1
+#define	MIP_SPIN		0xf0000
+#define	MIP_VALID		0x0100000000000000ULL
+#define	MIP_PORT(VALUE)	((VALUE >> 32) & 0xffff)
+
+#define	MIP_RD_LO(VALUE)	(VALUE & 0xffffffff)
+
+struct mip_reg_info {
+	unsigned long long mip_info;
+	unsigned long long delivery_info;
+	unsigned long long host_reg;
+	unsigned long long mip_reg;
+};
+
+struct part_info {
+	unsigned char type;
+	unsigned char length;
+	unsigned char part_id;
+	unsigned char apic_mode;
+	unsigned long snum;
+	char ptype[16];
+	char sname[64];
+	char pname[64];
+};
+
+struct psai {
+	unsigned long long entry_type;
+	unsigned long long addr;
+	unsigned long long bep_addr;
+};
+
+struct es7000_mem_info {
+	unsigned char type;
+	unsigned char length;
+	unsigned char resv[6];
+	unsigned long long  start;
+	unsigned long long  size;
+};
+
+struct es7000_oem_table {
+	unsigned long long hdr;
+	struct mip_reg_info mip;
+	struct part_info pif;
+	struct es7000_mem_info shm;
+	struct psai psai;
+};
+
+#ifdef CONFIG_ACPI
+
+struct oem_table {
+	struct acpi_table_header Header;
+	u32 OEMTableAddr;
+	u32 OEMTableSize;
+};
+
+extern int find_unisys_acpi_oem_table(unsigned long *oem_addr);
+#endif
+
+struct mip_reg {
+	unsigned long long off_0;
+	unsigned long long off_8;
+	unsigned long long off_10;
+	unsigned long long off_18;
+	unsigned long long off_20;
+	unsigned long long off_28;
+	unsigned long long off_30;
+	unsigned long long off_38;
+};
+
+#define	MIP_SW_APIC		0x1020b
+#define	MIP_FUNC(VALUE)		(VALUE & 0xff)
+
+/*
  * ES7000 Globals
  */
 
diff --git a/arch/x86/kernel/genx2apic_cluster.c b/arch/x86/kernel/genx2apic_cluster.c
index fed9f68..e4bf2cc 100644
--- a/arch/x86/kernel/genx2apic_cluster.c
+++ b/arch/x86/kernel/genx2apic_cluster.c
@@ -120,14 +120,9 @@ static unsigned long set_apic_id(unsigned int id)
 	return x;
 }
 
-static unsigned int x2apic_read_id(void)
-{
-	return apic_read(APIC_ID);
-}
-
 static unsigned int phys_pkg_id(int index_msb)
 {
-	return x2apic_read_id() >> index_msb;
+	return current_cpu_data.initial_apicid >> index_msb;
 }
 
 static void x2apic_send_IPI_self(int vector)
diff --git a/arch/x86/kernel/genx2apic_phys.c b/arch/x86/kernel/genx2apic_phys.c
index 958d537..8f1343d 100644
--- a/arch/x86/kernel/genx2apic_phys.c
+++ b/arch/x86/kernel/genx2apic_phys.c
@@ -118,14 +118,9 @@ static unsigned long set_apic_id(unsigned int id)
 	return x;
 }
 
-static unsigned int x2apic_read_id(void)
-{
-	return apic_read(APIC_ID);
-}
-
 static unsigned int phys_pkg_id(int index_msb)
 {
-	return x2apic_read_id() >> index_msb;
+	return current_cpu_data.initial_apicid >> index_msb;
 }
 
 void x2apic_send_IPI_self(int vector)
diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index eb9ddd8..45723f1 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -21,9 +21,12 @@
 # include <asm/sigcontext32.h>
 # include <asm/user32.h>
 #else
-# define save_i387_ia32		save_i387
-# define restore_i387_ia32	restore_i387
+# define save_i387_xstate_ia32		save_i387_xstate
+# define restore_i387_xstate_ia32	restore_i387_xstate
 # define _fpstate_ia32		_fpstate
+# define _xstate_ia32		_xstate
+# define sig_xstate_ia32_size   sig_xstate_size
+# define fx_sw_reserved_ia32	fx_sw_reserved
 # define user_i387_ia32_struct	user_i387_struct
 # define user32_fxsr_struct	user_fxsr_struct
 #endif
@@ -36,6 +39,7 @@
 
 static unsigned int		mxcsr_feature_mask __read_mostly = 0xffffffffu;
 unsigned int xstate_size;
+unsigned int sig_xstate_ia32_size = sizeof(struct _fpstate_ia32);
 static struct i387_fxsave_struct fx_scratch __cpuinitdata;
 
 void __cpuinit mxcsr_feature_mask_init(void)
@@ -61,6 +65,11 @@ void __init init_thread_xstate(void)
 		return;
 	}
 
+	if (cpu_has_xsave) {
+		xsave_cntxt_init();
+		return;
+	}
+
 	if (cpu_has_fxsr)
 		xstate_size = sizeof(struct i387_fxsave_struct);
 #ifdef CONFIG_X86_32
@@ -83,9 +92,19 @@ void __cpuinit fpu_init(void)
 
 	write_cr0(oldcr0 & ~(X86_CR0_TS|X86_CR0_EM)); /* clear TS and EM */
 
+	/*
+	 * Boot processor to setup the FP and extended state context info.
+	 */
+	if (!smp_processor_id())
+		init_thread_xstate();
+	xsave_init();
+
 	mxcsr_feature_mask_init();
 	/* clean state in init */
-	current_thread_info()->status = 0;
+	if (cpu_has_xsave)
+		current_thread_info()->status = TS_XSAVE;
+	else
+		current_thread_info()->status = 0;
 	clear_used_math();
 }
 #endif	/* CONFIG_X86_64 */
@@ -195,6 +214,13 @@ int xfpregs_set(struct task_struct *target, const struct user_regset *regset,
 	 */
 	target->thread.xstate->fxsave.mxcsr &= mxcsr_feature_mask;
 
+	/*
+	 * update the header bits in the xsave header, indicating the
+	 * presence of FP and SSE state.
+	 */
+	if (cpu_has_xsave)
+		target->thread.xstate->xsave.xsave_hdr.xstate_bv |= XSTATE_FPSSE;
+
 	return ret;
 }
 
@@ -395,6 +421,12 @@ int fpregs_set(struct task_struct *target, const struct user_regset *regset,
 	if (!ret)
 		convert_to_fxsr(target, &env);
 
+	/*
+	 * update the header bit in the xsave header, indicating the
+	 * presence of FP.
+	 */
+	if (cpu_has_xsave)
+		target->thread.xstate->xsave.xsave_hdr.xstate_bv |= XSTATE_FP;
 	return ret;
 }
 
@@ -407,7 +439,6 @@ static inline int save_i387_fsave(struct _fpstate_ia32 __user *buf)
 	struct task_struct *tsk = current;
 	struct i387_fsave_struct *fp = &tsk->thread.xstate->fsave;
 
-	unlazy_fpu(tsk);
 	fp->status = fp->swd;
 	if (__copy_to_user(buf, fp, sizeof(struct i387_fsave_struct)))
 		return -1;
@@ -421,8 +452,6 @@ static int save_i387_fxsave(struct _fpstate_ia32 __user *buf)
 	struct user_i387_ia32_struct env;
 	int err = 0;
 
-	unlazy_fpu(tsk);
-
 	convert_from_fxsr(&env, tsk);
 	if (__copy_to_user(buf, &env, sizeof(env)))
 		return -1;
@@ -432,16 +461,40 @@ static int save_i387_fxsave(struct _fpstate_ia32 __user *buf)
 	if (err)
 		return -1;
 
-	if (__copy_to_user(&buf->_fxsr_env[0], fx,
-			   sizeof(struct i387_fxsave_struct)))
+	if (__copy_to_user(&buf->_fxsr_env[0], fx, xstate_size))
 		return -1;
 	return 1;
 }
 
-int save_i387_ia32(struct _fpstate_ia32 __user *buf)
+static int save_i387_xsave(void __user *buf)
+{
+	struct _fpstate_ia32 __user *fx = buf;
+	int err = 0;
+
+	if (save_i387_fxsave(fx) < 0)
+		return -1;
+
+	err = __copy_to_user(&fx->sw_reserved, &fx_sw_reserved_ia32,
+			     sizeof(struct _fpx_sw_bytes));
+	err |= __put_user(FP_XSTATE_MAGIC2,
+			  (__u32 __user *) (buf + sig_xstate_ia32_size
+					    - FP_XSTATE_MAGIC2_SIZE));
+	if (err)
+		return -1;
+
+	return 1;
+}
+
+int save_i387_xstate_ia32(void __user *buf)
 {
+	struct _fpstate_ia32 __user *fp = (struct _fpstate_ia32 __user *) buf;
+	struct task_struct *tsk = current;
+
 	if (!used_math())
 		return 0;
+
+	if (!access_ok(VERIFY_WRITE, buf, sig_xstate_ia32_size))
+		return -EACCES;
 	/*
 	 * This will cause a "finit" to be triggered by the next
 	 * attempted FPU operation by the 'current' process.
@@ -451,13 +504,17 @@ int save_i387_ia32(struct _fpstate_ia32 __user *buf)
 	if (!HAVE_HWFP) {
 		return fpregs_soft_get(current, NULL,
 				       0, sizeof(struct user_i387_ia32_struct),
-				       NULL, buf) ? -1 : 1;
+				       NULL, fp) ? -1 : 1;
 	}
 
+	unlazy_fpu(tsk);
+
+	if (cpu_has_xsave)
+		return save_i387_xsave(fp);
 	if (cpu_has_fxsr)
-		return save_i387_fxsave(buf);
+		return save_i387_fxsave(fp);
 	else
-		return save_i387_fsave(buf);
+		return save_i387_fsave(fp);
 }
 
 static inline int restore_i387_fsave(struct _fpstate_ia32 __user *buf)
@@ -468,14 +525,15 @@ static inline int restore_i387_fsave(struct _fpstate_ia32 __user *buf)
 				sizeof(struct i387_fsave_struct));
 }
 
-static int restore_i387_fxsave(struct _fpstate_ia32 __user *buf)
+static int restore_i387_fxsave(struct _fpstate_ia32 __user *buf,
+			       unsigned int size)
 {
 	struct task_struct *tsk = current;
 	struct user_i387_ia32_struct env;
 	int err;
 
 	err = __copy_from_user(&tsk->thread.xstate->fxsave, &buf->_fxsr_env[0],
-			       sizeof(struct i387_fxsave_struct));
+			       size);
 	/* mxcsr reserved bits must be masked to zero for security reasons */
 	tsk->thread.xstate->fxsave.mxcsr &= mxcsr_feature_mask;
 	if (err || __copy_from_user(&env, buf, sizeof(env)))
@@ -485,14 +543,69 @@ static int restore_i387_fxsave(struct _fpstate_ia32 __user *buf)
 	return 0;
 }
 
-int restore_i387_ia32(struct _fpstate_ia32 __user *buf)
+static int restore_i387_xsave(void __user *buf)
+{
+	struct _fpx_sw_bytes fx_sw_user;
+	struct _fpstate_ia32 __user *fx_user =
+			((struct _fpstate_ia32 __user *) buf);
+	struct i387_fxsave_struct __user *fx =
+		(struct i387_fxsave_struct __user *) &fx_user->_fxsr_env[0];
+	struct xsave_hdr_struct *xsave_hdr =
+				&current->thread.xstate->xsave.xsave_hdr;
+	u64 mask;
+	int err;
+
+	if (check_for_xstate(fx, buf, &fx_sw_user))
+		goto fx_only;
+
+	mask = fx_sw_user.xstate_bv;
+
+	err = restore_i387_fxsave(buf, fx_sw_user.xstate_size);
+
+	xsave_hdr->xstate_bv &= pcntxt_mask;
+	/*
+	 * These bits must be zero.
+	 */
+	xsave_hdr->reserved1[0] = xsave_hdr->reserved1[1] = 0;
+
+	/*
+	 * Init the state that is not present in the memory layout
+	 * and enabled by the OS.
+	 */
+	mask = ~(pcntxt_mask & ~mask);
+	xsave_hdr->xstate_bv &= mask;
+
+	return err;
+fx_only:
+	/*
+	 * Couldn't find the extended state information in the memory
+	 * layout. Restore the FP/SSE and init the other extended state
+	 * enabled by the OS.
+	 */
+	xsave_hdr->xstate_bv = XSTATE_FPSSE;
+	return restore_i387_fxsave(buf, sizeof(struct i387_fxsave_struct));
+}
+
+int restore_i387_xstate_ia32(void __user *buf)
 {
 	int err;
 	struct task_struct *tsk = current;
+	struct _fpstate_ia32 __user *fp = (struct _fpstate_ia32 __user *) buf;
 
 	if (HAVE_HWFP)
 		clear_fpu(tsk);
 
+	if (!buf) {
+		if (used_math()) {
+			clear_fpu(tsk);
+			clear_used_math();
+		}
+
+		return 0;
+	} else
+		if (!access_ok(VERIFY_READ, buf, sig_xstate_ia32_size))
+			return -EACCES;
+
 	if (!used_math()) {
 		err = init_fpu(tsk);
 		if (err)
@@ -500,14 +613,17 @@ int restore_i387_ia32(struct _fpstate_ia32 __user *buf)
 	}
 
 	if (HAVE_HWFP) {
-		if (cpu_has_fxsr)
-			err = restore_i387_fxsave(buf);
+		if (cpu_has_xsave)
+			err = restore_i387_xsave(buf);
+		else if (cpu_has_fxsr)
+			err = restore_i387_fxsave(fp, sizeof(struct
+							   i387_fxsave_struct));
 		else
-			err = restore_i387_fsave(buf);
+			err = restore_i387_fsave(fp);
 	} else {
 		err = fpregs_soft_set(current, NULL,
 				      0, sizeof(struct user_i387_ia32_struct),
-				      NULL, buf) != 0;
+				      NULL, fp) != 0;
 	}
 	set_used_math();
 
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index ec7a2ba..c622772 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -15,7 +15,6 @@ unsigned long idle_nomwait;
 EXPORT_SYMBOL(idle_nomwait);
 
 struct kmem_cache *task_xstate_cachep;
-static int force_mwait __cpuinitdata;
 
 int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src)
 {
diff --git a/arch/x86/kernel/sigframe.h b/arch/x86/kernel/sigframe.h
index 8b4956e..cc673aa 100644
--- a/arch/x86/kernel/sigframe.h
+++ b/arch/x86/kernel/sigframe.h
@@ -3,9 +3,18 @@ struct sigframe {
 	char __user *pretcode;
 	int sig;
 	struct sigcontext sc;
-	struct _fpstate fpstate;
+	/*
+	 * fpstate is unused. fpstate is moved/allocated after
+	 * retcode[] below. This movement allows to have the FP state and the
+	 * future state extensions (xsave) stay together.
+	 * And at the same time retaining the unused fpstate, prevents changing
+	 * the offset of extramask[] in the sigframe and thus prevent any
+	 * legacy application accessing/modifying it.
+	 */
+	struct _fpstate fpstate_unused;
 	unsigned long extramask[_NSIG_WORDS-1];
 	char retcode[8];
+	/* fp state follows here */
 };
 
 struct rt_sigframe {
@@ -15,14 +24,15 @@ struct rt_sigframe {
 	void __user *puc;
 	struct siginfo info;
 	struct ucontext uc;
-	struct _fpstate fpstate;
 	char retcode[8];
+	/* fp state follows here */
 };
 #else
 struct rt_sigframe {
 	char __user *pretcode;
 	struct ucontext uc;
 	struct siginfo info;
+	/* fp state follows here */
 };
 
 int ia32_setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
diff --git a/arch/x86/kernel/signal_32.c b/arch/x86/kernel/signal_32.c
index 2a2435d..b21070e 100644
--- a/arch/x86/kernel/signal_32.c
+++ b/arch/x86/kernel/signal_32.c
@@ -161,28 +161,14 @@ restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc,
 	}
 
 	{
-		struct _fpstate __user *buf;
+		void __user *buf;
 
 		err |= __get_user(buf, &sc->fpstate);
-		if (buf) {
-			if (!access_ok(VERIFY_READ, buf, sizeof(*buf)))
-				goto badframe;
-			err |= restore_i387(buf);
-		} else {
-			struct task_struct *me = current;
-
-			if (used_math()) {
-				clear_fpu(me);
-				clear_used_math();
-			}
-		}
+		err |= restore_i387_xstate(buf);
 	}
 
 	err |= __get_user(*pax, &sc->ax);
 	return err;
-
-badframe:
-	return 1;
 }
 
 asmlinkage unsigned long sys_sigreturn(unsigned long __unused)
@@ -264,7 +250,7 @@ badframe:
  * Set up a signal frame.
  */
 static int
-setup_sigcontext(struct sigcontext __user *sc, struct _fpstate __user *fpstate,
+setup_sigcontext(struct sigcontext __user *sc, void __user *fpstate,
 		 struct pt_regs *regs, unsigned long mask)
 {
 	int tmp, err = 0;
@@ -291,7 +277,7 @@ setup_sigcontext(struct sigcontext __user *sc, struct _fpstate __user *fpstate,
 	err |= __put_user(regs->sp, &sc->sp_at_signal);
 	err |= __put_user(regs->ss, (unsigned int __user *)&sc->ss);
 
-	tmp = save_i387(fpstate);
+	tmp = save_i387_xstate(fpstate);
 	if (tmp < 0)
 		err = 1;
 	else
@@ -308,7 +294,8 @@ setup_sigcontext(struct sigcontext __user *sc, struct _fpstate __user *fpstate,
  * Determine which stack to use..
  */
 static inline void __user *
-get_sigframe(struct k_sigaction *ka, struct pt_regs *regs, size_t frame_size)
+get_sigframe(struct k_sigaction *ka, struct pt_regs *regs, size_t frame_size,
+	     void **fpstate)
 {
 	unsigned long sp;
 
@@ -334,6 +321,11 @@ get_sigframe(struct k_sigaction *ka, struct pt_regs *regs, size_t frame_size)
 			sp = (unsigned long) ka->sa.sa_restorer;
 	}
 
+	if (used_math()) {
+		sp = sp - sig_xstate_size;
+		*fpstate = (struct _fpstate *) sp;
+	}
+
 	sp -= frame_size;
 	/*
 	 * Align the stack pointer according to the i386 ABI,
@@ -352,8 +344,9 @@ setup_frame(int sig, struct k_sigaction *ka, sigset_t *set,
 	void __user *restorer;
 	int err = 0;
 	int usig;
+	void __user *fpstate = NULL;
 
-	frame = get_sigframe(ka, regs, sizeof(*frame));
+	frame = get_sigframe(ka, regs, sizeof(*frame), &fpstate);
 
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
 		goto give_sigsegv;
@@ -368,7 +361,7 @@ setup_frame(int sig, struct k_sigaction *ka, sigset_t *set,
 	if (err)
 		goto give_sigsegv;
 
-	err = setup_sigcontext(&frame->sc, &frame->fpstate, regs, set->sig[0]);
+	err = setup_sigcontext(&frame->sc, fpstate, regs, set->sig[0]);
 	if (err)
 		goto give_sigsegv;
 
@@ -429,8 +422,9 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	void __user *restorer;
 	int err = 0;
 	int usig;
+	void __user *fpstate = NULL;
 
-	frame = get_sigframe(ka, regs, sizeof(*frame));
+	frame = get_sigframe(ka, regs, sizeof(*frame), &fpstate);
 
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
 		goto give_sigsegv;
@@ -449,13 +443,16 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 		goto give_sigsegv;
 
 	/* Create the ucontext.  */
-	err |= __put_user(0, &frame->uc.uc_flags);
+	if (cpu_has_xsave)
+		err |= __put_user(UC_FP_XSTATE, &frame->uc.uc_flags);
+	else
+		err |= __put_user(0, &frame->uc.uc_flags);
 	err |= __put_user(0, &frame->uc.uc_link);
 	err |= __put_user(current->sas_ss_sp, &frame->uc.uc_stack.ss_sp);
 	err |= __put_user(sas_ss_flags(regs->sp),
 			  &frame->uc.uc_stack.ss_flags);
 	err |= __put_user(current->sas_ss_size, &frame->uc.uc_stack.ss_size);
-	err |= setup_sigcontext(&frame->uc.uc_mcontext, &frame->fpstate,
+	err |= setup_sigcontext(&frame->uc.uc_mcontext, fpstate,
 				regs, set->sig[0]);
 	err |= __copy_to_user(&frame->uc.uc_sigmask, set, sizeof(*set));
 	if (err)
diff --git a/arch/x86/kernel/signal_64.c b/arch/x86/kernel/signal_64.c
index 694aa88..823a55b 100644
--- a/arch/x86/kernel/signal_64.c
+++ b/arch/x86/kernel/signal_64.c
@@ -53,69 +53,6 @@ sys_sigaltstack(const stack_t __user *uss, stack_t __user *uoss,
 }
 
 /*
- * Signal frame handlers.
- */
-
-static inline int save_i387(struct _fpstate __user *buf)
-{
-	struct task_struct *tsk = current;
-	int err = 0;
-
-	BUILD_BUG_ON(sizeof(struct user_i387_struct) !=
-			sizeof(tsk->thread.xstate->fxsave));
-
-	if ((unsigned long)buf % 16)
-		printk("save_i387: bad fpstate %p\n", buf);
-
-	if (!used_math())
-		return 0;
-	clear_used_math(); /* trigger finit */
-	if (task_thread_info(tsk)->status & TS_USEDFPU) {
-		err = save_i387_checking((struct i387_fxsave_struct __user *)
-					 buf);
-		if (err)
-			return err;
-		task_thread_info(tsk)->status &= ~TS_USEDFPU;
-		stts();
-	} else {
-		if (__copy_to_user(buf, &tsk->thread.xstate->fxsave,
-				   sizeof(struct i387_fxsave_struct)))
-			return -1;
-	}
-	return 1;
-}
-
-/*
- * This restores directly out of user space. Exceptions are handled.
- */
-static inline int restore_i387(struct _fpstate __user *buf)
-{
-	struct task_struct *tsk = current;
-	int err;
-
-	if (!used_math()) {
-		err = init_fpu(tsk);
-		if (err)
-			return err;
-	}
-
-	if (!(task_thread_info(current)->status & TS_USEDFPU)) {
-		clts();
-		task_thread_info(current)->status |= TS_USEDFPU;
-	}
-	err = restore_fpu_checking((__force struct i387_fxsave_struct *)buf);
-	if (unlikely(err)) {
-		/*
-		 * Encountered an error while doing the restore from the
-		 * user buffer, clear the fpu state.
-		 */
-		clear_fpu(tsk);
-		clear_used_math();
-	}
-	return err;
-}
-
-/*
  * Do a signal return; undo the signal stack.
  */
 static int
@@ -159,25 +96,11 @@ restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc,
 	{
 		struct _fpstate __user *buf;
 		err |= __get_user(buf, &sc->fpstate);
-
-		if (buf) {
-			if (!access_ok(VERIFY_READ, buf, sizeof(*buf)))
-				goto badframe;
-			err |= restore_i387(buf);
-		} else {
-			struct task_struct *me = current;
-			if (used_math()) {
-				clear_fpu(me);
-				clear_used_math();
-			}
-		}
+		err |= restore_i387_xstate(buf);
 	}
 
 	err |= __get_user(*pax, &sc->ax);
 	return err;
-
-badframe:
-	return 1;
 }
 
 asmlinkage long sys_rt_sigreturn(struct pt_regs *regs)
@@ -269,26 +192,23 @@ get_stack(struct k_sigaction *ka, struct pt_regs *regs, unsigned long size)
 			sp = current->sas_ss_sp + current->sas_ss_size;
 	}
 
-	return (void __user *)round_down(sp - size, 16);
+	return (void __user *)round_down(sp - size, 64);
 }
 
 static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 			   sigset_t *set, struct pt_regs *regs)
 {
 	struct rt_sigframe __user *frame;
-	struct _fpstate __user *fp = NULL;
+	void __user *fp = NULL;
 	int err = 0;
 	struct task_struct *me = current;
 
 	if (used_math()) {
-		fp = get_stack(ka, regs, sizeof(struct _fpstate));
+		fp = get_stack(ka, regs, sig_xstate_size);
 		frame = (void __user *)round_down(
 			(unsigned long)fp - sizeof(struct rt_sigframe), 16) - 8;
 
-		if (!access_ok(VERIFY_WRITE, fp, sizeof(struct _fpstate)))
-			goto give_sigsegv;
-
-		if (save_i387(fp) < 0)
+		if (save_i387_xstate(fp) < 0)
 			err |= -1;
 	} else
 		frame = get_stack(ka, regs, sizeof(struct rt_sigframe)) - 8;
@@ -303,7 +223,10 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	}
 
 	/* Create the ucontext.  */
-	err |= __put_user(0, &frame->uc.uc_flags);
+	if (cpu_has_xsave)
+		err |= __put_user(UC_FP_XSTATE, &frame->uc.uc_flags);
+	else
+		err |= __put_user(0, &frame->uc.uc_flags);
 	err |= __put_user(0, &frame->uc.uc_link);
 	err |= __put_user(me->sas_ss_sp, &frame->uc.uc_stack.ss_sp);
 	err |= __put_user(sas_ss_flags(regs->sp),
diff --git a/arch/x86/kernel/traps_32.c b/arch/x86/kernel/traps_32.c
index 03df8e4..da5a596 100644
--- a/arch/x86/kernel/traps_32.c
+++ b/arch/x86/kernel/traps_32.c
@@ -1228,7 +1228,6 @@ void __init trap_init(void)
 
 	set_bit(SYSCALL_VECTOR, used_vectors);
 
-	init_thread_xstate();
 	/*
 	 * Should be a barrier for any external CPU state:
 	 */
diff --git a/arch/x86/kernel/traps_64.c b/arch/x86/kernel/traps_64.c
index 7a31f10..2887a78 100644
--- a/arch/x86/kernel/traps_64.c
+++ b/arch/x86/kernel/traps_64.c
@@ -1138,7 +1138,7 @@ asmlinkage void math_state_restore(void)
 	/*
 	 * Paranoid restore. send a SIGSEGV if we fail to restore the state.
 	 */
-	if (unlikely(restore_fpu_checking(&me->thread.xstate->fxsave))) {
+	if (unlikely(restore_fpu_checking(me))) {
 		stts();
 		force_sig(SIGSEGV, me);
 		return;
@@ -1179,10 +1179,6 @@ void __init trap_init(void)
 	set_system_gate(IA32_SYSCALL_VECTOR, ia32_syscall);
 #endif
 	/*
-	 * initialize the per thread extended state:
-	 */
-	init_thread_xstate();
-	/*
 	 * Should be a barrier for any external CPU state:
 	 */
 	cpu_init();
diff --git a/arch/x86/kernel/vmlinux_32.lds.S b/arch/x86/kernel/vmlinux_32.lds.S
index af5bdad..a9b8560 100644
--- a/arch/x86/kernel/vmlinux_32.lds.S
+++ b/arch/x86/kernel/vmlinux_32.lds.S
@@ -140,10 +140,10 @@ SECTIONS
 	*(.con_initcall.init)
   	__con_initcall_end = .;
   }
-  .x86cpuvendor.init : AT(ADDR(.x86cpuvendor.init) - LOAD_OFFSET) {
-	__x86cpuvendor_start = .;
-	*(.x86cpuvendor.init)
-	__x86cpuvendor_end = .;
+  .x86_cpu_dev.init : AT(ADDR(.x86_cpu_dev.init) - LOAD_OFFSET) {
+	__x86_cpu_dev_start = .;
+	*(.x86_cpu_dev.init)
+	__x86_cpu_dev_end = .;
   }
   SECURITY_INIT
   . = ALIGN(4);
@@ -180,6 +180,7 @@ SECTIONS
   . = ALIGN(PAGE_SIZE);
   .data.percpu  : AT(ADDR(.data.percpu) - LOAD_OFFSET) {
 	__per_cpu_start = .;
+	*(.data.percpu.page_aligned)
 	*(.data.percpu)
 	*(.data.percpu.shared_aligned)
 	__per_cpu_end = .;
diff --git a/arch/x86/kernel/vmlinux_64.lds.S b/arch/x86/kernel/vmlinux_64.lds.S
index 63e5c1a..201e81a 100644
--- a/arch/x86/kernel/vmlinux_64.lds.S
+++ b/arch/x86/kernel/vmlinux_64.lds.S
@@ -168,13 +168,12 @@ SECTIONS
 	*(.con_initcall.init)
   }
   __con_initcall_end = .;
-  . = ALIGN(16);
-  __x86cpuvendor_start = .;
-  .x86cpuvendor.init : AT(ADDR(.x86cpuvendor.init) - LOAD_OFFSET) {
-	*(.x86cpuvendor.init)
+  __x86_cpu_dev_start = .;
+  .x86_cpu_dev.init : AT(ADDR(.x86_cpu_dev.init) - LOAD_OFFSET) {
+	*(.x86_cpu_dev.init)
   }
-  __x86cpuvendor_end = .;
   SECURITY_INIT
+  __x86_cpu_dev_end = .;
 
   . = ALIGN(8);
   .parainstructions : AT(ADDR(.parainstructions) - LOAD_OFFSET) {
diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
new file mode 100644
index 0000000..07713d6
--- /dev/null
+++ b/arch/x86/kernel/xsave.c
@@ -0,0 +1,316 @@
+/*
+ * xsave/xrstor support.
+ *
+ * Author: Suresh Siddha <suresh.b.siddha@intel.com>
+ */
+#include <linux/bootmem.h>
+#include <linux/compat.h>
+#include <asm/i387.h>
+#ifdef CONFIG_IA32_EMULATION
+#include <asm/sigcontext32.h>
+#endif
+#include <asm/xcr.h>
+
+/*
+ * Supported feature mask by the CPU and the kernel.
+ */
+u64 pcntxt_mask;
+
+struct _fpx_sw_bytes fx_sw_reserved;
+#ifdef CONFIG_IA32_EMULATION
+struct _fpx_sw_bytes fx_sw_reserved_ia32;
+#endif
+
+/*
+ * Check for the presence of extended state information in the
+ * user fpstate pointer in the sigcontext.
+ */
+int check_for_xstate(struct i387_fxsave_struct __user *buf,
+		     void __user *fpstate,
+		     struct _fpx_sw_bytes *fx_sw_user)
+{
+	int min_xstate_size = sizeof(struct i387_fxsave_struct) +
+			      sizeof(struct xsave_hdr_struct);
+	unsigned int magic2;
+	int err;
+
+	err = __copy_from_user(fx_sw_user, &buf->sw_reserved[0],
+			       sizeof(struct _fpx_sw_bytes));
+
+	if (err)
+		return err;
+
+	/*
+	 * First Magic check failed.
+	 */
+	if (fx_sw_user->magic1 != FP_XSTATE_MAGIC1)
+		return -1;
+
+	/*
+	 * Check for error scenarios.
+	 */
+	if (fx_sw_user->xstate_size < min_xstate_size ||
+	    fx_sw_user->xstate_size > xstate_size ||
+	    fx_sw_user->xstate_size > fx_sw_user->extended_size)
+		return -1;
+
+	err = __get_user(magic2, (__u32 *) (((void *)fpstate) +
+					    fx_sw_user->extended_size -
+					    FP_XSTATE_MAGIC2_SIZE));
+	/*
+	 * Check for the presence of second magic word at the end of memory
+	 * layout. This detects the case where the user just copied the legacy
+	 * fpstate layout with out copying the extended state information
+	 * in the memory layout.
+	 */
+	if (err || magic2 != FP_XSTATE_MAGIC2)
+		return -1;
+
+	return 0;
+}
+
+#ifdef CONFIG_X86_64
+/*
+ * Signal frame handlers.
+ */
+
+int save_i387_xstate(void __user *buf)
+{
+	struct task_struct *tsk = current;
+	int err = 0;
+
+	if (!access_ok(VERIFY_WRITE, buf, sig_xstate_size))
+		return -EACCES;
+
+	BUG_ON(sig_xstate_size < xstate_size);
+
+	if ((unsigned long)buf % 64)
+		printk("save_i387_xstate: bad fpstate %p\n", buf);
+
+	if (!used_math())
+		return 0;
+	clear_used_math(); /* trigger finit */
+	if (task_thread_info(tsk)->status & TS_USEDFPU) {
+		/*
+	 	 * Start with clearing the user buffer. This will present a
+	 	 * clean context for the bytes not touched by the fxsave/xsave.
+		 */
+		__clear_user(buf, sig_xstate_size);
+
+		if (task_thread_info(tsk)->status & TS_XSAVE)
+			err = xsave_user(buf);
+		else
+			err = fxsave_user(buf);
+
+		if (err)
+			return err;
+		task_thread_info(tsk)->status &= ~TS_USEDFPU;
+		stts();
+	} else {
+		if (__copy_to_user(buf, &tsk->thread.xstate->fxsave,
+				   xstate_size))
+			return -1;
+	}
+
+	if (task_thread_info(tsk)->status & TS_XSAVE) {
+		struct _fpstate __user *fx = buf;
+
+		err = __copy_to_user(&fx->sw_reserved, &fx_sw_reserved,
+				     sizeof(struct _fpx_sw_bytes));
+
+		err |= __put_user(FP_XSTATE_MAGIC2,
+				  (__u32 __user *) (buf + sig_xstate_size
+						    - FP_XSTATE_MAGIC2_SIZE));
+	}
+
+	return 1;
+}
+
+/*
+ * Restore the extended state if present. Otherwise, restore the FP/SSE
+ * state.
+ */
+int restore_user_xstate(void __user *buf)
+{
+	struct _fpx_sw_bytes fx_sw_user;
+	u64 mask;
+	int err;
+
+	if (((unsigned long)buf % 64) ||
+	     check_for_xstate(buf, buf, &fx_sw_user))
+		goto fx_only;
+
+	mask = fx_sw_user.xstate_bv;
+
+	/*
+	 * restore the state passed by the user.
+	 */
+	err = xrestore_user(buf, mask);
+	if (err)
+		return err;
+
+	/*
+	 * init the state skipped by the user.
+	 */
+	mask = pcntxt_mask & ~mask;
+
+	xrstor_state(init_xstate_buf, mask);
+
+	return 0;
+
+fx_only:
+	/*
+	 * couldn't find the extended state information in the
+	 * memory layout. Restore just the FP/SSE and init all
+	 * the other extended state.
+	 */
+	xrstor_state(init_xstate_buf, pcntxt_mask & ~XSTATE_FPSSE);
+	return fxrstor_checking((__force struct i387_fxsave_struct *)buf);
+}
+
+/*
+ * This restores directly out of user space. Exceptions are handled.
+ */
+int restore_i387_xstate(void __user *buf)
+{
+	struct task_struct *tsk = current;
+	int err = 0;
+
+	if (!buf) {
+		if (used_math())
+			goto clear;
+		return 0;
+	} else
+		if (!access_ok(VERIFY_READ, buf, sig_xstate_size))
+			return -EACCES;
+
+	if (!used_math()) {
+		err = init_fpu(tsk);
+		if (err)
+			return err;
+	}
+
+	if (!(task_thread_info(current)->status & TS_USEDFPU)) {
+		clts();
+		task_thread_info(current)->status |= TS_USEDFPU;
+	}
+	if (task_thread_info(tsk)->status & TS_XSAVE)
+		err = restore_user_xstate(buf);
+	else
+		err = fxrstor_checking((__force struct i387_fxsave_struct *)
+				       buf);
+	if (unlikely(err)) {
+		/*
+		 * Encountered an error while doing the restore from the
+		 * user buffer, clear the fpu state.
+		 */
+clear:
+		clear_fpu(tsk);
+		clear_used_math();
+	}
+	return err;
+}
+#endif
+
+/*
+ * Prepare the SW reserved portion of the fxsave memory layout, indicating
+ * the presence of the extended state information in the memory layout
+ * pointed by the fpstate pointer in the sigcontext.
+ * This will be saved when ever the FP and extended state context is
+ * saved on the user stack during the signal handler delivery to the user.
+ */
+void prepare_fx_sw_frame(void)
+{
+	int size_extended = (xstate_size - sizeof(struct i387_fxsave_struct)) +
+			     FP_XSTATE_MAGIC2_SIZE;
+
+	sig_xstate_size = sizeof(struct _fpstate) + size_extended;
+
+#ifdef CONFIG_IA32_EMULATION
+	sig_xstate_ia32_size = sizeof(struct _fpstate_ia32) + size_extended;
+#endif
+
+	memset(&fx_sw_reserved, 0, sizeof(fx_sw_reserved));
+
+	fx_sw_reserved.magic1 = FP_XSTATE_MAGIC1;
+	fx_sw_reserved.extended_size = sig_xstate_size;
+	fx_sw_reserved.xstate_bv = pcntxt_mask;
+	fx_sw_reserved.xstate_size = xstate_size;
+#ifdef CONFIG_IA32_EMULATION
+	memcpy(&fx_sw_reserved_ia32, &fx_sw_reserved,
+	       sizeof(struct _fpx_sw_bytes));
+	fx_sw_reserved_ia32.extended_size = sig_xstate_ia32_size;
+#endif
+}
+
+/*
+ * Represents init state for the supported extended state.
+ */
+struct xsave_struct *init_xstate_buf;
+
+#ifdef CONFIG_X86_64
+unsigned int sig_xstate_size = sizeof(struct _fpstate);
+#endif
+
+/*
+ * Enable the extended processor state save/restore feature
+ */
+void __cpuinit xsave_init(void)
+{
+	if (!cpu_has_xsave)
+		return;
+
+	set_in_cr4(X86_CR4_OSXSAVE);
+
+	/*
+	 * Enable all the features that the HW is capable of
+	 * and the Linux kernel is aware of.
+	 */
+	xsetbv(XCR_XFEATURE_ENABLED_MASK, pcntxt_mask);
+}
+
+/*
+ * setup the xstate image representing the init state
+ */
+void setup_xstate_init(void)
+{
+	init_xstate_buf = alloc_bootmem(xstate_size);
+	init_xstate_buf->i387.mxcsr = MXCSR_DEFAULT;
+}
+
+/*
+ * Enable and initialize the xsave feature.
+ */
+void __init xsave_cntxt_init(void)
+{
+	unsigned int eax, ebx, ecx, edx;
+
+	cpuid_count(0xd, 0, &eax, &ebx, &ecx, &edx);
+	pcntxt_mask = eax + ((u64)edx << 32);
+
+	if ((pcntxt_mask & XSTATE_FPSSE) != XSTATE_FPSSE) {
+		printk(KERN_ERR "FP/SSE not shown under xsave features 0x%llx\n",
+		       pcntxt_mask);
+		BUG();
+	}
+
+	/*
+	 * for now OS knows only about FP/SSE
+	 */
+	pcntxt_mask = pcntxt_mask & XCNTXT_MASK;
+	xsave_init();
+
+	/*
+	 * Recompute the context size for enabled features
+	 */
+	cpuid_count(0xd, 0, &eax, &ebx, &ecx, &edx);
+	xstate_size = ebx;
+
+	prepare_fx_sw_frame();
+
+	setup_xstate_init();
+
+	printk(KERN_INFO "xsave/xrstor: enabled xstate_bv 0x%llx, "
+	       "cntxt size 0x%x\n",
+	       pcntxt_mask, xstate_size);
+}
diff --git a/arch/x86/kvm/vmx.h b/arch/x86/kvm/vmx.h
index 23e8373..17e2599 100644
--- a/arch/x86/kvm/vmx.h
+++ b/arch/x86/kvm/vmx.h
@@ -331,21 +331,6 @@ enum vmcs_field {
 
 #define AR_RESERVD_MASK 0xfffe0f00
 
-#define MSR_IA32_VMX_BASIC                      0x480
-#define MSR_IA32_VMX_PINBASED_CTLS              0x481
-#define MSR_IA32_VMX_PROCBASED_CTLS             0x482
-#define MSR_IA32_VMX_EXIT_CTLS                  0x483
-#define MSR_IA32_VMX_ENTRY_CTLS                 0x484
-#define MSR_IA32_VMX_MISC                       0x485
-#define MSR_IA32_VMX_CR0_FIXED0                 0x486
-#define MSR_IA32_VMX_CR0_FIXED1                 0x487
-#define MSR_IA32_VMX_CR4_FIXED0                 0x488
-#define MSR_IA32_VMX_CR4_FIXED1                 0x489
-#define MSR_IA32_VMX_VMCS_ENUM                  0x48a
-#define MSR_IA32_VMX_PROCBASED_CTLS2            0x48b
-#define MSR_IA32_VMX_EPT_VPID_CAP               0x48c
-
-#define MSR_IA32_FEATURE_CONTROL                0x3a
 #define MSR_IA32_FEATURE_CONTROL_LOCKED         0x1
 #define MSR_IA32_FEATURE_CONTROL_VMXON_ENABLED  0x4
 
diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
index aa3fa41..55e11aa 100644
--- a/arch/x86/lib/Makefile
+++ b/arch/x86/lib/Makefile
@@ -17,9 +17,6 @@ ifeq ($(CONFIG_X86_32),y)
         lib-$(CONFIG_X86_USE_3DNOW) += mmx_32.o
 else
         obj-y += io_64.o iomap_copy_64.o
-
-        CFLAGS_csum-partial_64.o := -funroll-loops
-
         lib-y += csum-partial_64.o csum-copy_64.o csum-wrappers_64.o
         lib-y += thunk_64.o clear_page_64.o copy_page_64.o
         lib-y += memmove_64.o memset_64.o
diff --git a/arch/x86/lib/usercopy_32.c b/arch/x86/lib/usercopy_32.c
index 24e6094..9e68075 100644
--- a/arch/x86/lib/usercopy_32.c
+++ b/arch/x86/lib/usercopy_32.c
@@ -14,6 +14,13 @@
 #include <asm/uaccess.h>
 #include <asm/mmx.h>
 
+#ifdef CONFIG_X86_INTEL_USERCOPY
+/*
+ * Alignment at which movsl is preferred for bulk memory copies.
+ */
+struct movsl_mask movsl_mask __read_mostly;
+#endif
+
 static inline int __movsl_is_ok(unsigned long a1, unsigned long a2, unsigned long n)
 {
 #ifdef CONFIG_X86_INTEL_USERCOPY
diff --git a/arch/x86/mach-generic/Makefile b/arch/x86/mach-generic/Makefile
index 4706de7..6730f4e 100644
--- a/arch/x86/mach-generic/Makefile
+++ b/arch/x86/mach-generic/Makefile
@@ -9,4 +9,3 @@ obj-$(CONFIG_X86_NUMAQ)		+= numaq.o
 obj-$(CONFIG_X86_SUMMIT)	+= summit.o
 obj-$(CONFIG_X86_BIGSMP)	+= bigsmp.o
 obj-$(CONFIG_X86_ES7000)	+= es7000.o
-obj-$(CONFIG_X86_ES7000)	+= ../../x86/es7000/
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index fb30486..83e13f2 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -88,6 +88,62 @@ early_param("gbpages", parse_direct_gbpages_on);
 
 int after_bootmem;
 
+unsigned long __supported_pte_mask __read_mostly = ~0UL;
+EXPORT_SYMBOL_GPL(__supported_pte_mask);
+
+static int do_not_nx __cpuinitdata;
+
+/*
+ * noexec=on|off
+ * Control non-executable mappings for 64-bit processes.
+ *
+ * on	Enable (default)
+ * off	Disable
+ */
+static int __init nonx_setup(char *str)
+{
+	if (!str)
+		return -EINVAL;
+	if (!strncmp(str, "on", 2)) {
+		__supported_pte_mask |= _PAGE_NX;
+		do_not_nx = 0;
+	} else if (!strncmp(str, "off", 3)) {
+		do_not_nx = 1;
+		__supported_pte_mask &= ~_PAGE_NX;
+	}
+	return 0;
+}
+early_param("noexec", nonx_setup);
+
+void __cpuinit check_efer(void)
+{
+	unsigned long efer;
+
+	rdmsrl(MSR_EFER, efer);
+	if (!(efer & EFER_NX) || do_not_nx)
+		__supported_pte_mask &= ~_PAGE_NX;
+}
+
+int force_personality32;
+
+/*
+ * noexec32=on|off
+ * Control non executable heap for 32bit processes.
+ * To control the stack too use noexec=off
+ *
+ * on	PROT_READ does not imply PROT_EXEC for 32-bit processes (default)
+ * off	PROT_READ implies PROT_EXEC
+ */
+static int __init nonx32_setup(char *str)
+{
+	if (!strcmp(str, "on"))
+		force_personality32 &= ~READ_IMPLIES_EXEC;
+	else if (!strcmp(str, "off"))
+		force_personality32 |= READ_IMPLIES_EXEC;
+	return 1;
+}
+__setup("noexec32=", nonx32_setup);
+
 /*
  * NOTE: This function is marked __ref because it calls __init function
  * (alloc_bootmem_pages). It's safe to do it ONLY when after_bootmem == 0.
diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
index 8791fc5..844df0c 100644
--- a/arch/x86/pci/i386.c
+++ b/arch/x86/pci/i386.c
@@ -33,6 +33,7 @@
 #include <linux/bootmem.h>
 
 #include <asm/pat.h>
+#include <asm/e820.h>
 
 #include "pci.h"
 
@@ -227,6 +228,8 @@ void __init pcibios_resource_survey(void)
 	pcibios_allocate_bus_resources(&pci_root_buses);
 	pcibios_allocate_resources(0);
 	pcibios_allocate_resources(1);
+
+	e820_reserve_resources_late();
 }
 
 /**
diff --git a/arch/x86/pci/mmconfig-shared.c b/arch/x86/pci/mmconfig-shared.c
index d963576..654a223 100644
--- a/arch/x86/pci/mmconfig-shared.c
+++ b/arch/x86/pci/mmconfig-shared.c
@@ -209,7 +209,7 @@ static int __init pci_mmcfg_check_hostbridge(void)
 	return name != NULL;
 }
 
-static void __init pci_mmcfg_insert_resources(unsigned long resource_flags)
+static void __init pci_mmcfg_insert_resources(void)
 {
 #define PCI_MMCFG_RESOURCE_NAME_LEN 19
 	int i;
@@ -233,7 +233,7 @@ static void __init pci_mmcfg_insert_resources(unsigned long resource_flags)
 			 cfg->pci_segment);
 		res->start = cfg->address;
 		res->end = res->start + (num_buses << 20) - 1;
-		res->flags = IORESOURCE_MEM | resource_flags;
+		res->flags = IORESOURCE_MEM | IORESOURCE_BUSY;
 		insert_resource(&iomem_resource, res);
 		names += PCI_MMCFG_RESOURCE_NAME_LEN;
 	}
@@ -434,11 +434,9 @@ static void __init __pci_mmcfg_init(int early)
 	    (pci_mmcfg_config[0].address == 0))
 		return;
 
-	if (pci_mmcfg_arch_init()) {
-		if (known_bridge)
-			pci_mmcfg_insert_resources(IORESOURCE_BUSY);
+	if (pci_mmcfg_arch_init())
 		pci_probe = (pci_probe & ~PCI_PROBE_MASK) | PCI_PROBE_MMCONF;
-	} else {
+	else {
 		/*
 		 * Signal not to attempt to insert mmcfg resources because
 		 * the architecture mmcfg setup could not initialize.
@@ -475,7 +473,7 @@ static int __init pci_mmcfg_late_insert_resources(void)
 	 * marked so it won't cause request errors when __request_region is
 	 * called.
 	 */
-	pci_mmcfg_insert_resources(0);
+	pci_mmcfg_insert_resources();
 
 	return 0;
 }
diff --git a/arch/x86/power/cpu_32.c b/arch/x86/power/cpu_32.c
index d3e083d..274d060 100644
--- a/arch/x86/power/cpu_32.c
+++ b/arch/x86/power/cpu_32.c
@@ -11,6 +11,7 @@
 #include <linux/suspend.h>
 #include <asm/mtrr.h>
 #include <asm/mce.h>
+#include <asm/xcr.h>
 
 static struct saved_context saved_context;
 
@@ -126,6 +127,12 @@ static void __restore_processor_state(struct saved_context *ctxt)
 	if (boot_cpu_has(X86_FEATURE_SEP))
 		enable_sep_cpu();
 
+	/*
+	 * restore XCR0 for xsave capable cpu's.
+	 */
+	if (cpu_has_xsave)
+		xsetbv(XCR_XFEATURE_ENABLED_MASK, pcntxt_mask);
+
 	fix_processor_context();
 	do_fpu_end();
 	mtrr_ap_init();
diff --git a/arch/x86/power/cpu_64.c b/arch/x86/power/cpu_64.c
index 66bdfb5..e3b6cf7 100644
--- a/arch/x86/power/cpu_64.c
+++ b/arch/x86/power/cpu_64.c
@@ -14,6 +14,7 @@
 #include <asm/page.h>
 #include <asm/pgtable.h>
 #include <asm/mtrr.h>
+#include <asm/xcr.h>
 
 static void fix_processor_context(void);
 
@@ -122,6 +123,12 @@ static void __restore_processor_state(struct saved_context *ctxt)
 	wrmsrl(MSR_GS_BASE, ctxt->gs_base);
 	wrmsrl(MSR_KERNEL_GS_BASE, ctxt->gs_kernel_base);
 
+	/*
+	 * restore XCR0 for xsave capable cpu's.
+	 */
+	if (cpu_has_xsave)
+		xsetbv(XCR_XFEATURE_ENABLED_MASK, pcntxt_mask);
+
 	fix_processor_context();
 
 	do_fpu_end();
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index cb752ba..7440a0d 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -385,6 +385,7 @@
 	. = ALIGN(align);						\
 	VMLINUX_SYMBOL(__per_cpu_start) = .;				\
 	.data.percpu  : AT(ADDR(.data.percpu) - LOAD_OFFSET) {		\
+		*(.data.percpu.page_aligned)				\
 		*(.data.percpu)						\
 		*(.data.percpu.shared_aligned)				\
 	}								\
diff --git a/include/asm-x86/bugs.h b/include/asm-x86/bugs.h
index 4761c46..dc60498 100644
--- a/include/asm-x86/bugs.h
+++ b/include/asm-x86/bugs.h
@@ -2,6 +2,11 @@
 #define ASM_X86__BUGS_H
 
 extern void check_bugs(void);
+
+#if defined(CONFIG_CPU_SUP_INTEL) && defined(CONFIG_X86_32)
 int ppro_with_ram_bug(void);
+#else
+static inline int ppro_with_ram_bug(void) { return 0; }
+#endif
 
 #endif /* ASM_X86__BUGS_H */
diff --git a/include/asm-x86/cpufeature.h b/include/asm-x86/cpufeature.h
index 065c6a8..adfeae6 100644
--- a/include/asm-x86/cpufeature.h
+++ b/include/asm-x86/cpufeature.h
@@ -6,7 +6,13 @@
 
 #include <asm/required-features.h>
 
-#define NCAPINTS	8	/* N 32-bit words worth of info */
+#define NCAPINTS	9	/* N 32-bit words worth of info */
+
+/*
+ * Note: If the comment begins with a quoted string, that string is used
+ * in /proc/cpuinfo instead of the macro name.  If the string is "",
+ * this feature bit is not displayed in /proc/cpuinfo at all.
+ */
 
 /* Intel-defined CPU features, CPUID level 0x00000001 (edx), word 0 */
 #define X86_FEATURE_FPU		(0*32+ 0) /* Onboard FPU */
@@ -14,7 +20,7 @@
 #define X86_FEATURE_DE		(0*32+ 2) /* Debugging Extensions */
 #define X86_FEATURE_PSE		(0*32+ 3) /* Page Size Extensions */
 #define X86_FEATURE_TSC		(0*32+ 4) /* Time Stamp Counter */
-#define X86_FEATURE_MSR		(0*32+ 5) /* Model-Specific Registers, RDMSR, WRMSR */
+#define X86_FEATURE_MSR		(0*32+ 5) /* Model-Specific Registers */
 #define X86_FEATURE_PAE		(0*32+ 6) /* Physical Address Extensions */
 #define X86_FEATURE_MCE		(0*32+ 7) /* Machine Check Architecture */
 #define X86_FEATURE_CX8		(0*32+ 8) /* CMPXCHG8 instruction */
@@ -23,22 +29,23 @@
 #define X86_FEATURE_MTRR	(0*32+12) /* Memory Type Range Registers */
 #define X86_FEATURE_PGE		(0*32+13) /* Page Global Enable */
 #define X86_FEATURE_MCA		(0*32+14) /* Machine Check Architecture */
-#define X86_FEATURE_CMOV	(0*32+15) /* CMOV instruction (FCMOVCC and FCOMI too if FPU present) */
+#define X86_FEATURE_CMOV	(0*32+15) /* CMOV instructions */
+					  /* (plus FCMOVcc, FCOMI with FPU) */
 #define X86_FEATURE_PAT		(0*32+16) /* Page Attribute Table */
 #define X86_FEATURE_PSE36	(0*32+17) /* 36-bit PSEs */
 #define X86_FEATURE_PN		(0*32+18) /* Processor serial number */
-#define X86_FEATURE_CLFLSH	(0*32+19) /* Supports the CLFLUSH instruction */
-#define X86_FEATURE_DS		(0*32+21) /* Debug Store */
+#define X86_FEATURE_CLFLSH	(0*32+19) /* "clflush" CLFLUSH instruction */
+#define X86_FEATURE_DS		(0*32+21) /* "dts" Debug Store */
 #define X86_FEATURE_ACPI	(0*32+22) /* ACPI via MSR */
 #define X86_FEATURE_MMX		(0*32+23) /* Multimedia Extensions */
-#define X86_FEATURE_FXSR	(0*32+24) /* FXSAVE and FXRSTOR instructions (fast save and restore */
-					  /* of FPU context), and CR4.OSFXSR available */
-#define X86_FEATURE_XMM		(0*32+25) /* Streaming SIMD Extensions */
-#define X86_FEATURE_XMM2	(0*32+26) /* Streaming SIMD Extensions-2 */
-#define X86_FEATURE_SELFSNOOP	(0*32+27) /* CPU self snoop */
+#define X86_FEATURE_FXSR	(0*32+24) /* FXSAVE/FXRSTOR, CR4.OSFXSR */
+#define X86_FEATURE_XMM		(0*32+25) /* "sse" */
+#define X86_FEATURE_XMM2	(0*32+26) /* "sse2" */
+#define X86_FEATURE_SELFSNOOP	(0*32+27) /* "ss" CPU self snoop */
 #define X86_FEATURE_HT		(0*32+28) /* Hyper-Threading */
-#define X86_FEATURE_ACC		(0*32+29) /* Automatic clock control */
+#define X86_FEATURE_ACC		(0*32+29) /* "tm" Automatic clock control */
 #define X86_FEATURE_IA64	(0*32+30) /* IA-64 processor */
+#define X86_FEATURE_PBE		(0*32+31) /* Pending Break Enable */
 
 /* AMD-defined CPU features, CPUID level 0x80000001, word 1 */
 /* Don't duplicate feature flags which are redundant with Intel! */
@@ -46,7 +53,8 @@
 #define X86_FEATURE_MP		(1*32+19) /* MP Capable. */
 #define X86_FEATURE_NX		(1*32+20) /* Execute Disable */
 #define X86_FEATURE_MMXEXT	(1*32+22) /* AMD MMX extensions */
-#define X86_FEATURE_GBPAGES	(1*32+26) /* GB pages */
+#define X86_FEATURE_FXSR_OPT	(1*32+25) /* FXSAVE/FXRSTOR optimizations */
+#define X86_FEATURE_GBPAGES	(1*32+26) /* "pdpe1gb" GB pages */
 #define X86_FEATURE_RDTSCP	(1*32+27) /* RDTSCP */
 #define X86_FEATURE_LM		(1*32+29) /* Long Mode (x86-64) */
 #define X86_FEATURE_3DNOWEXT	(1*32+30) /* AMD 3DNow! extensions */
@@ -64,54 +72,79 @@
 #define X86_FEATURE_CYRIX_ARR	(3*32+ 2) /* Cyrix ARRs (= MTRRs) */
 #define X86_FEATURE_CENTAUR_MCR	(3*32+ 3) /* Centaur MCRs (= MTRRs) */
 /* cpu types for specific tunings: */
-#define X86_FEATURE_K8		(3*32+ 4) /* Opteron, Athlon64 */
-#define X86_FEATURE_K7		(3*32+ 5) /* Athlon */
-#define X86_FEATURE_P3		(3*32+ 6) /* P3 */
-#define X86_FEATURE_P4		(3*32+ 7) /* P4 */
+#define X86_FEATURE_K8		(3*32+ 4) /* "" Opteron, Athlon64 */
+#define X86_FEATURE_K7		(3*32+ 5) /* "" Athlon */
+#define X86_FEATURE_P3		(3*32+ 6) /* "" P3 */
+#define X86_FEATURE_P4		(3*32+ 7) /* "" P4 */
 #define X86_FEATURE_CONSTANT_TSC (3*32+ 8) /* TSC ticks at a constant rate */
 #define X86_FEATURE_UP		(3*32+ 9) /* smp kernel running on up */
-#define X86_FEATURE_FXSAVE_LEAK (3*32+10) /* FXSAVE leaks FOP/FIP/FOP */
+#define X86_FEATURE_FXSAVE_LEAK (3*32+10) /* "" FXSAVE leaks FOP/FIP/FOP */
 #define X86_FEATURE_ARCH_PERFMON (3*32+11) /* Intel Architectural PerfMon */
+#define X86_FEATURE_NOPL	(3*32+20) /* The NOPL (0F 1F) instructions */
 #define X86_FEATURE_PEBS	(3*32+12) /* Precise-Event Based Sampling */
 #define X86_FEATURE_BTS		(3*32+13) /* Branch Trace Store */
-#define X86_FEATURE_SYSCALL32	(3*32+14) /* syscall in ia32 userspace */
-#define X86_FEATURE_SYSENTER32	(3*32+15) /* sysenter in ia32 userspace */
-#define X86_FEATURE_REP_GOOD	(3*32+16) /* rep microcode works well on this CPU */
-#define X86_FEATURE_MFENCE_RDTSC (3*32+17) /* Mfence synchronizes RDTSC */
-#define X86_FEATURE_LFENCE_RDTSC (3*32+18) /* Lfence synchronizes RDTSC */
-#define X86_FEATURE_11AP	(3*32+19) /* Bad local APIC aka 11AP */
+#define X86_FEATURE_SYSCALL32	(3*32+14) /* "" syscall in ia32 userspace */
+#define X86_FEATURE_SYSENTER32	(3*32+15) /* "" sysenter in ia32 userspace */
+#define X86_FEATURE_REP_GOOD	(3*32+16) /* rep microcode works well */
+#define X86_FEATURE_MFENCE_RDTSC (3*32+17) /* "" Mfence synchronizes RDTSC */
+#define X86_FEATURE_LFENCE_RDTSC (3*32+18) /* "" Lfence synchronizes RDTSC */
+#define X86_FEATURE_11AP	(3*32+19) /* "" Bad local APIC aka 11AP */
 #define X86_FEATURE_NOPL	(3*32+20) /* The NOPL (0F 1F) instructions */
 #define X86_FEATURE_AMDC1E	(3*32+21) /* AMD C1E detected */
+#define X86_FEATURE_XTOPOLOGY	(3*32+21) /* cpu topology enum extensions */
 
 /* Intel-defined CPU features, CPUID level 0x00000001 (ecx), word 4 */
-#define X86_FEATURE_XMM3	(4*32+ 0) /* Streaming SIMD Extensions-3 */
-#define X86_FEATURE_MWAIT	(4*32+ 3) /* Monitor/Mwait support */
-#define X86_FEATURE_DSCPL	(4*32+ 4) /* CPL Qualified Debug Store */
+#define X86_FEATURE_XMM3	(4*32+ 0) /* "pni" SSE-3 */
+#define X86_FEATURE_PCLMULQDQ	(4*32+ 1) /* PCLMULQDQ instruction */
+#define X86_FEATURE_DTES64	(4*32+ 2) /* 64-bit Debug Store */
+#define X86_FEATURE_MWAIT	(4*32+ 3) /* "monitor" Monitor/Mwait support */
+#define X86_FEATURE_DSCPL	(4*32+ 4) /* "ds_cpl" CPL Qual. Debug Store */
+#define X86_FEATURE_VMX		(4*32+ 5) /* Hardware virtualization */
+#define X86_FEATURE_SMX		(4*32+ 6) /* Safer mode */
 #define X86_FEATURE_EST		(4*32+ 7) /* Enhanced SpeedStep */
 #define X86_FEATURE_TM2		(4*32+ 8) /* Thermal Monitor 2 */
+#define X86_FEATURE_SSSE3	(4*32+ 9) /* Supplemental SSE-3 */
 #define X86_FEATURE_CID		(4*32+10) /* Context ID */
+#define X86_FEATURE_FMA		(4*32+12) /* Fused multiply-add */
 #define X86_FEATURE_CX16	(4*32+13) /* CMPXCHG16B */
 #define X86_FEATURE_XTPR	(4*32+14) /* Send Task Priority Messages */
+#define X86_FEATURE_PDCM	(4*32+15) /* Performance Capabilities */
 #define X86_FEATURE_DCA		(4*32+18) /* Direct Cache Access */
+#define X86_FEATURE_XMM4_1	(4*32+19) /* "sse4_1" SSE-4.1 */
+#define X86_FEATURE_XMM4_2	(4*32+20) /* "sse4_2" SSE-4.2 */
 #define X86_FEATURE_X2APIC	(4*32+21) /* x2APIC */
-#define X86_FEATURE_XMM4_2	(4*32+20) /* Streaming SIMD Extensions-4.2 */
+#define X86_FEATURE_AES		(4*32+25) /* AES instructions */
+#define X86_FEATURE_XSAVE	(4*32+26) /* XSAVE/XRSTOR/XSETBV/XGETBV */
+#define X86_FEATURE_OSXSAVE	(4*32+27) /* "" XSAVE enabled in the OS */
+#define X86_FEATURE_AVX		(4*32+28) /* Advanced Vector Extensions */
 
 /* VIA/Cyrix/Centaur-defined CPU features, CPUID level 0xC0000001, word 5 */
-#define X86_FEATURE_XSTORE	(5*32+ 2) /* on-CPU RNG present (xstore insn) */
-#define X86_FEATURE_XSTORE_EN	(5*32+ 3) /* on-CPU RNG enabled */
-#define X86_FEATURE_XCRYPT	(5*32+ 6) /* on-CPU crypto (xcrypt insn) */
-#define X86_FEATURE_XCRYPT_EN	(5*32+ 7) /* on-CPU crypto enabled */
+#define X86_FEATURE_XSTORE	(5*32+ 2) /* "rng" RNG present (xstore) */
+#define X86_FEATURE_XSTORE_EN	(5*32+ 3) /* "rng_en" RNG enabled */
+#define X86_FEATURE_XCRYPT	(5*32+ 6) /* "ace" on-CPU crypto (xcrypt) */
+#define X86_FEATURE_XCRYPT_EN	(5*32+ 7) /* "ace_en" on-CPU crypto enabled */
 #define X86_FEATURE_ACE2	(5*32+ 8) /* Advanced Cryptography Engine v2 */
 #define X86_FEATURE_ACE2_EN	(5*32+ 9) /* ACE v2 enabled */
-#define X86_FEATURE_PHE		(5*32+ 10) /* PadLock Hash Engine */
-#define X86_FEATURE_PHE_EN	(5*32+ 11) /* PHE enabled */
-#define X86_FEATURE_PMM		(5*32+ 12) /* PadLock Montgomery Multiplier */
-#define X86_FEATURE_PMM_EN	(5*32+ 13) /* PMM enabled */
+#define X86_FEATURE_PHE		(5*32+10) /* PadLock Hash Engine */
+#define X86_FEATURE_PHE_EN	(5*32+11) /* PHE enabled */
+#define X86_FEATURE_PMM		(5*32+12) /* PadLock Montgomery Multiplier */
+#define X86_FEATURE_PMM_EN	(5*32+13) /* PMM enabled */
 
 /* More extended AMD flags: CPUID level 0x80000001, ecx, word 6 */
 #define X86_FEATURE_LAHF_LM	(6*32+ 0) /* LAHF/SAHF in long mode */
 #define X86_FEATURE_CMP_LEGACY	(6*32+ 1) /* If yes HyperThreading not valid */
-#define X86_FEATURE_IBS		(6*32+ 10) /* Instruction Based Sampling */
+#define X86_FEATURE_SVM		(6*32+ 2) /* Secure virtual machine */
+#define X86_FEATURE_EXTAPIC	(6*32+ 3) /* Extended APIC space */
+#define X86_FEATURE_CR8_LEGACY	(6*32+ 4) /* CR8 in 32-bit mode */
+#define X86_FEATURE_ABM		(6*32+ 5) /* Advanced bit manipulation */
+#define X86_FEATURE_SSE4A	(6*32+ 6) /* SSE-4A */
+#define X86_FEATURE_MISALIGNSSE (6*32+ 7) /* Misaligned SSE mode */
+#define X86_FEATURE_3DNOWPREFETCH (6*32+ 8) /* 3DNow prefetch instructions */
+#define X86_FEATURE_OSVW	(6*32+ 9) /* OS Visible Workaround */
+#define X86_FEATURE_IBS		(6*32+10) /* Instruction Based Sampling */
+#define X86_FEATURE_SSE5	(6*32+11) /* SSE-5 */
+#define X86_FEATURE_SKINIT	(6*32+12) /* SKINIT/STGI instructions */
+#define X86_FEATURE_WDT		(6*32+13) /* Watchdog timer */
 
 /*
  * Auxiliary flags: Linux defined - For features scattered in various
@@ -119,6 +152,13 @@
  */
 #define X86_FEATURE_IDA		(7*32+ 0) /* Intel Dynamic Acceleration */
 
+/* Virtualization flags: Linux defined */
+#define X86_FEATURE_TPR_SHADOW  (8*32+ 0) /* Intel TPR Shadow */
+#define X86_FEATURE_VNMI        (8*32+ 1) /* Intel Virtual NMI */
+#define X86_FEATURE_FLEXPRIORITY (8*32+ 2) /* Intel FlexPriority */
+#define X86_FEATURE_EPT         (8*32+ 3) /* Intel Extended Page Table */
+#define X86_FEATURE_VPID        (8*32+ 4) /* Intel Virtual Processor ID */
+
 #if defined(__KERNEL__) && !defined(__ASSEMBLY__)
 
 #include <linux/bitops.h>
@@ -152,7 +192,7 @@ extern const char * const x86_power_flags[32];
 } while (0)
 #define setup_force_cpu_cap(bit) do { \
 	set_cpu_cap(&boot_cpu_data, bit);	\
-	clear_bit(bit, (unsigned long *)cleared_cpu_caps); 	\
+	clear_bit(bit, (unsigned long *)cleared_cpu_caps);	\
 } while (0)
 
 #define cpu_has_fpu		boot_cpu_has(X86_FEATURE_FPU)
@@ -193,8 +233,10 @@ extern const char * const x86_power_flags[32];
 #define cpu_has_gbpages		boot_cpu_has(X86_FEATURE_GBPAGES)
 #define cpu_has_arch_perfmon	boot_cpu_has(X86_FEATURE_ARCH_PERFMON)
 #define cpu_has_pat		boot_cpu_has(X86_FEATURE_PAT)
-#define cpu_has_x2apic		boot_cpu_has(X86_FEATURE_X2APIC)
+#define cpu_has_xmm4_1		boot_cpu_has(X86_FEATURE_XMM4_1)
 #define cpu_has_xmm4_2		boot_cpu_has(X86_FEATURE_XMM4_2)
+#define cpu_has_x2apic		boot_cpu_has(X86_FEATURE_X2APIC)
+#define cpu_has_xsave		boot_cpu_has(X86_FEATURE_XSAVE)
 
 #if defined(CONFIG_X86_INVLPG) || defined(CONFIG_X86_64)
 # define cpu_has_invlpg		1
diff --git a/include/asm-x86/e820.h b/include/asm-x86/e820.h
index f52daf1..5abbdec 100644
--- a/include/asm-x86/e820.h
+++ b/include/asm-x86/e820.h
@@ -43,6 +43,7 @@
 #define E820_RESERVED	2
 #define E820_ACPI	3
 #define E820_NVS	4
+#define E820_UNUSABLE	5
 
 /* reserved RAM used by kernel itself */
 #define E820_RESERVED_KERN        128
@@ -121,6 +122,7 @@ extern void e820_register_active_regions(int nid, unsigned long start_pfn,
 extern u64 e820_hole_size(u64 start, u64 end);
 extern void finish_e820_parsing(void);
 extern void e820_reserve_resources(void);
+extern void e820_reserve_resources_late(void);
 extern void setup_memory_map(void);
 extern char *default_machine_specific_memory_setup(void);
 extern char *machine_specific_memory_setup(void);
diff --git a/include/asm-x86/i387.h b/include/asm-x86/i387.h
index 1ecdc3e..9ba862a 100644
--- a/include/asm-x86/i387.h
+++ b/include/asm-x86/i387.h
@@ -19,7 +19,9 @@
 #include <asm/sigcontext.h>
 #include <asm/user.h>
 #include <asm/uaccess.h>
+#include <asm/xsave.h>
 
+extern unsigned int sig_xstate_size;
 extern void fpu_init(void);
 extern void mxcsr_feature_mask_init(void);
 extern int init_fpu(struct task_struct *child);
@@ -31,12 +33,18 @@ extern user_regset_active_fn fpregs_active, xfpregs_active;
 extern user_regset_get_fn fpregs_get, xfpregs_get, fpregs_soft_get;
 extern user_regset_set_fn fpregs_set, xfpregs_set, fpregs_soft_set;
 
+extern struct _fpx_sw_bytes fx_sw_reserved;
 #ifdef CONFIG_IA32_EMULATION
+extern unsigned int sig_xstate_ia32_size;
+extern struct _fpx_sw_bytes fx_sw_reserved_ia32;
 struct _fpstate_ia32;
-extern int save_i387_ia32(struct _fpstate_ia32 __user *buf);
-extern int restore_i387_ia32(struct _fpstate_ia32 __user *buf);
+struct _xstate_ia32;
+extern int save_i387_xstate_ia32(void __user *buf);
+extern int restore_i387_xstate_ia32(void __user *buf);
 #endif
 
+#define X87_FSW_ES (1 << 7)	/* Exception Summary */
+
 #ifdef CONFIG_X86_64
 
 /* Ignore delayed exceptions from user space */
@@ -47,7 +55,7 @@ static inline void tolerant_fwait(void)
 		     _ASM_EXTABLE(1b, 2b));
 }
 
-static inline int restore_fpu_checking(struct i387_fxsave_struct *fx)
+static inline int fxrstor_checking(struct i387_fxsave_struct *fx)
 {
 	int err;
 
@@ -67,15 +75,31 @@ static inline int restore_fpu_checking(struct i387_fxsave_struct *fx)
 	return err;
 }
 
-#define X87_FSW_ES (1 << 7)	/* Exception Summary */
+static inline int restore_fpu_checking(struct task_struct *tsk)
+{
+	if (task_thread_info(tsk)->status & TS_XSAVE)
+		return xrstor_checking(&tsk->thread.xstate->xsave);
+	else
+		return fxrstor_checking(&tsk->thread.xstate->fxsave);
+}
 
 /* AMD CPUs don't save/restore FDP/FIP/FOP unless an exception
    is pending. Clear the x87 state here by setting it to fixed
    values. The kernel data segment can be sometimes 0 and sometimes
    new user value. Both should be ok.
    Use the PDA as safe address because it should be already in L1. */
-static inline void clear_fpu_state(struct i387_fxsave_struct *fx)
+static inline void clear_fpu_state(struct task_struct *tsk)
 {
+	struct xsave_struct *xstate = &tsk->thread.xstate->xsave;
+	struct i387_fxsave_struct *fx = &tsk->thread.xstate->fxsave;
+
+	/*
+	 * xsave header may indicate the init state of the FP.
+	 */
+	if ((task_thread_info(tsk)->status & TS_XSAVE) &&
+	    !(xstate->xsave_hdr.xstate_bv & XSTATE_FP))
+		return;
+
 	if (unlikely(fx->swd & X87_FSW_ES))
 		asm volatile("fnclex");
 	alternative_input(ASM_NOP8 ASM_NOP2,
@@ -84,7 +108,7 @@ static inline void clear_fpu_state(struct i387_fxsave_struct *fx)
 			  X86_FEATURE_FXSAVE_LEAK);
 }
 
-static inline int save_i387_checking(struct i387_fxsave_struct __user *fx)
+static inline int fxsave_user(struct i387_fxsave_struct __user *fx)
 {
 	int err;
 
@@ -108,7 +132,7 @@ static inline int save_i387_checking(struct i387_fxsave_struct __user *fx)
 	return err;
 }
 
-static inline void __save_init_fpu(struct task_struct *tsk)
+static inline void fxsave(struct task_struct *tsk)
 {
 	/* Using "rex64; fxsave %0" is broken because, if the memory operand
 	   uses any extended registers for addressing, a second REX prefix
@@ -133,7 +157,16 @@ static inline void __save_init_fpu(struct task_struct *tsk)
 			     : "=m" (tsk->thread.xstate->fxsave)
 			     : "cdaSDb" (&tsk->thread.xstate->fxsave));
 #endif
-	clear_fpu_state(&tsk->thread.xstate->fxsave);
+}
+
+static inline void __save_init_fpu(struct task_struct *tsk)
+{
+	if (task_thread_info(tsk)->status & TS_XSAVE)
+		xsave(tsk);
+	else
+		fxsave(tsk);
+
+	clear_fpu_state(tsk);
 	task_thread_info(tsk)->status &= ~TS_USEDFPU;
 }
 
@@ -148,6 +181,10 @@ static inline void tolerant_fwait(void)
 
 static inline void restore_fpu(struct task_struct *tsk)
 {
+	if (task_thread_info(tsk)->status & TS_XSAVE) {
+		xrstor_checking(&tsk->thread.xstate->xsave);
+		return;
+	}
 	/*
 	 * The "nop" is needed to make the instructions the same
 	 * length.
@@ -173,6 +210,27 @@ static inline void restore_fpu(struct task_struct *tsk)
  */
 static inline void __save_init_fpu(struct task_struct *tsk)
 {
+	if (task_thread_info(tsk)->status & TS_XSAVE) {
+		struct xsave_struct *xstate = &tsk->thread.xstate->xsave;
+		struct i387_fxsave_struct *fx = &tsk->thread.xstate->fxsave;
+
+		xsave(tsk);
+
+		/*
+		 * xsave header may indicate the init state of the FP.
+		 */
+		if (!(xstate->xsave_hdr.xstate_bv & XSTATE_FP))
+			goto end;
+
+		if (unlikely(fx->swd & X87_FSW_ES))
+			asm volatile("fnclex");
+
+		/*
+		 * we can do a simple return here or be paranoid :)
+		 */
+		goto clear_state;
+	}
+
 	/* Use more nops than strictly needed in case the compiler
 	   varies code */
 	alternative_input(
@@ -182,6 +240,7 @@ static inline void __save_init_fpu(struct task_struct *tsk)
 		X86_FEATURE_FXSR,
 		[fx] "m" (tsk->thread.xstate->fxsave),
 		[fsw] "m" (tsk->thread.xstate->fxsave.swd) : "memory");
+clear_state:
 	/* AMD K7/K8 CPUs don't save/restore FDP/FIP/FOP unless an exception
 	   is pending.  Clear the x87 state here by setting it to fixed
 	   values. safe_address is a random variable that should be in L1 */
@@ -191,16 +250,17 @@ static inline void __save_init_fpu(struct task_struct *tsk)
 		"fildl %[addr]", 	/* set F?P to defined value */
 		X86_FEATURE_FXSAVE_LEAK,
 		[addr] "m" (safe_address));
+end:
 	task_thread_info(tsk)->status &= ~TS_USEDFPU;
 }
 
+#endif	/* CONFIG_X86_64 */
+
 /*
  * Signal frame handlers...
  */
-extern int save_i387(struct _fpstate __user *buf);
-extern int restore_i387(struct _fpstate __user *buf);
-
-#endif	/* CONFIG_X86_64 */
+extern int save_i387_xstate(void __user *buf);
+extern int restore_i387_xstate(void __user *buf);
 
 static inline void __unlazy_fpu(struct task_struct *tsk)
 {
diff --git a/include/asm-x86/msr-index.h b/include/asm-x86/msr-index.h
index 3052f05..0bb4330 100644
--- a/include/asm-x86/msr-index.h
+++ b/include/asm-x86/msr-index.h
@@ -176,6 +176,7 @@
 #define MSR_IA32_TSC			0x00000010
 #define MSR_IA32_PLATFORM_ID		0x00000017
 #define MSR_IA32_EBL_CR_POWERON		0x0000002a
+#define MSR_IA32_FEATURE_CONTROL        0x0000003a
 
 #define MSR_IA32_APICBASE		0x0000001b
 #define MSR_IA32_APICBASE_BSP		(1<<8)
@@ -310,4 +311,19 @@
 /* Geode defined MSRs */
 #define MSR_GEODE_BUSCONT_CONF0		0x00001900
 
+/* Intel VT MSRs */
+#define MSR_IA32_VMX_BASIC              0x00000480
+#define MSR_IA32_VMX_PINBASED_CTLS      0x00000481
+#define MSR_IA32_VMX_PROCBASED_CTLS     0x00000482
+#define MSR_IA32_VMX_EXIT_CTLS          0x00000483
+#define MSR_IA32_VMX_ENTRY_CTLS         0x00000484
+#define MSR_IA32_VMX_MISC               0x00000485
+#define MSR_IA32_VMX_CR0_FIXED0         0x00000486
+#define MSR_IA32_VMX_CR0_FIXED1         0x00000487
+#define MSR_IA32_VMX_CR4_FIXED0         0x00000488
+#define MSR_IA32_VMX_CR4_FIXED1         0x00000489
+#define MSR_IA32_VMX_VMCS_ENUM          0x0000048a
+#define MSR_IA32_VMX_PROCBASED_CTLS2    0x0000048b
+#define MSR_IA32_VMX_EPT_VPID_CAP       0x0000048c
+
 #endif /* ASM_X86__MSR_INDEX_H */
diff --git a/include/asm-x86/processor-cyrix.h b/include/asm-x86/processor-cyrix.h
index 97568ad..1198f2a 100644
--- a/include/asm-x86/processor-cyrix.h
+++ b/include/asm-x86/processor-cyrix.h
@@ -28,3 +28,11 @@ static inline void setCx86(u8 reg, u8 data)
 	outb(reg, 0x22);
 	outb(data, 0x23);
 }
+
+#define getCx86_old(reg) ({ outb((reg), 0x22); inb(0x23); })
+
+#define setCx86_old(reg, data) do { \
+	outb((reg), 0x22); \
+	outb((data), 0x23); \
+} while (0)
+
diff --git a/include/asm-x86/processor-flags.h b/include/asm-x86/processor-flags.h
index 5dd7977..dc5f071 100644
--- a/include/asm-x86/processor-flags.h
+++ b/include/asm-x86/processor-flags.h
@@ -59,6 +59,7 @@
 #define X86_CR4_OSFXSR	0x00000200 /* enable fast FPU save and restore */
 #define X86_CR4_OSXMMEXCPT 0x00000400 /* enable unmasked SSE exceptions */
 #define X86_CR4_VMXE	0x00002000 /* enable VMX virtualization */
+#define X86_CR4_OSXSAVE 0x00040000 /* enable xsave and xrestore */
 
 /*
  * x86-64 Task Priority Register, CR8
diff --git a/include/asm-x86/processor.h b/include/asm-x86/processor.h
index 5eaf9bf..c7d3546 100644
--- a/include/asm-x86/processor.h
+++ b/include/asm-x86/processor.h
@@ -76,11 +76,11 @@ struct cpuinfo_x86 {
 	int			 x86_tlbsize;
 	__u8			x86_virt_bits;
 	__u8			x86_phys_bits;
+#endif
 	/* CPUID returned core id bits: */
 	__u8			x86_coreid_bits;
 	/* Max extended CPUID function supported: */
 	__u32			extended_cpuid_level;
-#endif
 	/* Maximum supported CPUID level, -1=no CPUID: */
 	int			cpuid_level;
 	__u32			x86_capability[NCAPINTS];
@@ -166,11 +166,8 @@ extern void init_scattered_cpuid_features(struct cpuinfo_x86 *c);
 extern unsigned int init_intel_cacheinfo(struct cpuinfo_x86 *c);
 extern unsigned short num_cache_leaves;
 
-#if defined(CONFIG_X86_HT) || defined(CONFIG_X86_64)
+extern void detect_extended_topology(struct cpuinfo_x86 *c);
 extern void detect_ht(struct cpuinfo_x86 *c);
-#else
-static inline void detect_ht(struct cpuinfo_x86 *c) {}
-#endif
 
 static inline void native_cpuid(unsigned int *eax, unsigned int *ebx,
 				unsigned int *ecx, unsigned int *edx)
@@ -327,7 +324,12 @@ struct i387_fxsave_struct {
 	/* 16*16 bytes for each XMM-reg = 256 bytes:			*/
 	u32			xmm_space[64];
 
-	u32			padding[24];
+	u32			padding[12];
+
+	union {
+		u32		padding1[12];
+		u32		sw_reserved[12];
+	};
 
 } __attribute__((aligned(16)));
 
@@ -351,10 +353,23 @@ struct i387_soft_struct {
 	u32			entry_eip;
 };
 
+struct xsave_hdr_struct {
+	u64 xstate_bv;
+	u64 reserved1[2];
+	u64 reserved2[5];
+} __attribute__((packed));
+
+struct xsave_struct {
+	struct i387_fxsave_struct i387;
+	struct xsave_hdr_struct xsave_hdr;
+	/* new processor state extensions will go here */
+} __attribute__ ((packed, aligned (64)));
+
 union thread_xstate {
 	struct i387_fsave_struct	fsave;
 	struct i387_fxsave_struct	fxsave;
 	struct i387_soft_struct		soft;
+	struct xsave_struct		xsave;
 };
 
 #ifdef CONFIG_X86_64
diff --git a/include/asm-x86/sigcontext.h b/include/asm-x86/sigcontext.h
index 24879c8..ee813f4 100644
--- a/include/asm-x86/sigcontext.h
+++ b/include/asm-x86/sigcontext.h
@@ -4,6 +4,40 @@
 #include <linux/compiler.h>
 #include <asm/types.h>
 
+#define FP_XSTATE_MAGIC1	0x46505853U
+#define FP_XSTATE_MAGIC2	0x46505845U
+#define FP_XSTATE_MAGIC2_SIZE	sizeof(FP_XSTATE_MAGIC2)
+
+/*
+ * bytes 464..511 in the current 512byte layout of fxsave/fxrstor frame
+ * are reserved for SW usage. On cpu's supporting xsave/xrstor, these bytes
+ * are used to extended the fpstate pointer in the sigcontext, which now
+ * includes the extended state information along with fpstate information.
+ *
+ * Presence of FP_XSTATE_MAGIC1 at the beginning of this SW reserved
+ * area and FP_XSTATE_MAGIC2 at the end of memory layout
+ * (extended_size - FP_XSTATE_MAGIC2_SIZE) indicates the presence of the
+ * extended state information in the memory layout pointed by the fpstate
+ * pointer in sigcontext.
+ */
+struct _fpx_sw_bytes {
+	__u32 magic1;		/* FP_XSTATE_MAGIC1 */
+	__u32 extended_size;	/* total size of the layout referred by
+				 * fpstate pointer in the sigcontext.
+				 */
+	__u64 xstate_bv;
+				/* feature bit mask (including fp/sse/extended
+				 * state) that is present in the memory
+				 * layout.
+				 */
+	__u32 xstate_size;	/* actual xsave state size, based on the
+				 * features saved in the layout.
+				 * 'extended_size' will be greater than
+				 * 'xstate_size'.
+				 */
+	__u32 padding[7];	/*  for future use. */
+};
+
 #ifdef __i386__
 /*
  * As documented in the iBCS2 standard..
@@ -53,7 +87,13 @@ struct _fpstate {
 	unsigned long	reserved;
 	struct _fpxreg	_fxsr_st[8];	/* FXSR FPU reg data is ignored */
 	struct _xmmreg	_xmm[8];
-	unsigned long	padding[56];
+	unsigned long	padding1[44];
+
+	union {
+		unsigned long	padding2[12];
+		struct _fpx_sw_bytes sw_reserved; /* represents the extended
+						   * state info */
+	};
 };
 
 #define X86_FXSR_MAGIC		0x0000
@@ -79,7 +119,15 @@ struct sigcontext {
 	unsigned long flags;
 	unsigned long sp_at_signal;
 	unsigned short ss, __ssh;
-	struct _fpstate __user *fpstate;
+
+	/*
+	 * fpstate is really (struct _fpstate *) or (struct _xstate *)
+	 * depending on the FP_XSTATE_MAGIC1 encoded in the SW reserved
+	 * bytes of (struct _fpstate) and FP_XSTATE_MAGIC2 present at the end
+	 * of extended memory layout. See comments at the defintion of
+	 * (struct _fpx_sw_bytes)
+	 */
+	void __user *fpstate;		/* zero when no FPU/extended context */
 	unsigned long oldmask;
 	unsigned long cr2;
 };
@@ -130,7 +178,12 @@ struct _fpstate {
 	__u32	mxcsr_mask;
 	__u32	st_space[32];	/* 8*16 bytes for each FP-reg */
 	__u32	xmm_space[64];	/* 16*16 bytes for each XMM-reg  */
-	__u32	reserved2[24];
+	__u32	reserved2[12];
+	union {
+		__u32	reserved3[12];
+		struct _fpx_sw_bytes sw_reserved; /* represents the extended
+						   * state information */
+	};
 };
 
 #ifdef __KERNEL__
@@ -161,7 +214,15 @@ struct sigcontext {
 	unsigned long trapno;
 	unsigned long oldmask;
 	unsigned long cr2;
-	struct _fpstate __user *fpstate;	/* zero when no FPU context */
+
+	/*
+	 * fpstate is really (struct _fpstate *) or (struct _xstate *)
+	 * depending on the FP_XSTATE_MAGIC1 encoded in the SW reserved
+	 * bytes of (struct _fpstate) and FP_XSTATE_MAGIC2 present at the end
+	 * of extended memory layout. See comments at the defintion of
+	 * (struct _fpx_sw_bytes)
+	 */
+	void __user *fpstate;		/* zero when no FPU/extended context */
 	unsigned long reserved1[8];
 };
 #else /* __KERNEL__ */
@@ -202,4 +263,22 @@ struct sigcontext {
 
 #endif /* !__i386__ */
 
+struct _xsave_hdr {
+	__u64 xstate_bv;
+	__u64 reserved1[2];
+	__u64 reserved2[5];
+};
+
+/*
+ * Extended state pointed by the fpstate pointer in the sigcontext.
+ * In addition to the fpstate, information encoded in the xstate_hdr
+ * indicates the presence of other extended state information
+ * supported by the processor and OS.
+ */
+struct _xstate {
+	struct _fpstate fpstate;
+	struct _xsave_hdr xstate_hdr;
+	/* new processor state extensions go here */
+};
+
 #endif /* ASM_X86__SIGCONTEXT_H */
diff --git a/include/asm-x86/sigcontext32.h b/include/asm-x86/sigcontext32.h
index 4e2ec73..8c34703 100644
--- a/include/asm-x86/sigcontext32.h
+++ b/include/asm-x86/sigcontext32.h
@@ -40,7 +40,11 @@ struct _fpstate_ia32 {
 	__u32	reserved;
 	struct _fpxreg	_fxsr_st[8];
 	struct _xmmreg	_xmm[8];	/* It's actually 16 */
-	__u32	padding[56];
+	__u32	padding[44];
+	union {
+		__u32 padding2[12];
+		struct _fpx_sw_bytes sw_reserved;
+	};
 };
 
 struct sigcontext_ia32 {
diff --git a/include/asm-x86/thread_info.h b/include/asm-x86/thread_info.h
index 4db0066..3f4e52b 100644
--- a/include/asm-x86/thread_info.h
+++ b/include/asm-x86/thread_info.h
@@ -241,6 +241,7 @@ static inline struct thread_info *stack_thread_info(void)
 #define TS_POLLING		0x0004	/* true if in idle loop
 					   and not sleeping */
 #define TS_RESTORE_SIGMASK	0x0008	/* restore signal mask in do_signal() */
+#define TS_XSAVE		0x0010	/* Use xsave/xrstor */
 
 #define tsk_is_polling(t) (task_thread_info(t)->status & TS_POLLING)
 
diff --git a/include/asm-x86/ucontext.h b/include/asm-x86/ucontext.h
index 9948dd3..89eaa54 100644
--- a/include/asm-x86/ucontext.h
+++ b/include/asm-x86/ucontext.h
@@ -1,6 +1,12 @@
 #ifndef ASM_X86__UCONTEXT_H
 #define ASM_X86__UCONTEXT_H
 
+#define UC_FP_XSTATE	0x1	/* indicates the presence of extended state
+				 * information in the memory layout pointed
+				 * by the fpstate pointer in the ucontext's
+				 * sigcontext struct (uc_mcontext).
+				 */
+
 struct ucontext {
 	unsigned long	  uc_flags;
 	struct ucontext  *uc_link;
diff --git a/include/asm-x86/xcr.h b/include/asm-x86/xcr.h
new file mode 100644
index 0000000..f2cba4e
--- /dev/null
+++ b/include/asm-x86/xcr.h
@@ -0,0 +1,49 @@
+/* -*- linux-c -*- ------------------------------------------------------- *
+ *
+ *   Copyright 2008 rPath, Inc. - All Rights Reserved
+ *
+ *   This file is part of the Linux kernel, and is made available under
+ *   the terms of the GNU General Public License version 2 or (at your
+ *   option) any later version; incorporated herein by reference.
+ *
+ * ----------------------------------------------------------------------- */
+
+/*
+ * asm-x86/xcr.h
+ *
+ * Definitions for the eXtended Control Register instructions
+ */
+
+#ifndef _ASM_X86_XCR_H
+#define _ASM_X86_XCR_H
+
+#define XCR_XFEATURE_ENABLED_MASK	0x00000000
+
+#ifdef __KERNEL__
+# ifndef __ASSEMBLY__
+
+#include <linux/types.h>
+
+static inline u64 xgetbv(u32 index)
+{
+	u32 eax, edx;
+
+	asm volatile(".byte 0x0f,0x01,0xd0" /* xgetbv */
+		     : "=a" (eax), "=d" (edx)
+		     : "c" (index));
+	return eax + ((u64)edx << 32);
+}
+
+static inline void xsetbv(u32 index, u64 value)
+{
+	u32 eax = value;
+	u32 edx = value >> 32;
+
+	asm volatile(".byte 0x0f,0x01,0xd1" /* xsetbv */
+		     : : "a" (eax), "d" (edx), "c" (index));
+}
+
+# endif /* __ASSEMBLY__ */
+#endif /* __KERNEL__ */
+
+#endif /* _ASM_X86_XCR_H */
diff --git a/include/asm-x86/xsave.h b/include/asm-x86/xsave.h
new file mode 100644
index 0000000..08e9a1a
--- /dev/null
+++ b/include/asm-x86/xsave.h
@@ -0,0 +1,118 @@
+#ifndef __ASM_X86_XSAVE_H
+#define __ASM_X86_XSAVE_H
+
+#include <linux/types.h>
+#include <asm/processor.h>
+#include <asm/i387.h>
+
+#define XSTATE_FP	0x1
+#define XSTATE_SSE	0x2
+
+#define XSTATE_FPSSE	(XSTATE_FP | XSTATE_SSE)
+
+#define FXSAVE_SIZE	512
+
+/*
+ * These are the features that the OS can handle currently.
+ */
+#define XCNTXT_MASK	(XSTATE_FP | XSTATE_SSE)
+
+#ifdef CONFIG_X86_64
+#define REX_PREFIX	"0x48, "
+#else
+#define REX_PREFIX
+#endif
+
+extern unsigned int xstate_size;
+extern u64 pcntxt_mask;
+extern struct xsave_struct *init_xstate_buf;
+
+extern void xsave_cntxt_init(void);
+extern void xsave_init(void);
+extern int init_fpu(struct task_struct *child);
+extern int check_for_xstate(struct i387_fxsave_struct __user *buf,
+			    void __user *fpstate,
+			    struct _fpx_sw_bytes *sw);
+
+static inline int xrstor_checking(struct xsave_struct *fx)
+{
+	int err;
+
+	asm volatile("1: .byte " REX_PREFIX "0x0f,0xae,0x2f\n\t"
+		     "2:\n"
+		     ".section .fixup,\"ax\"\n"
+		     "3:  movl $-1,%[err]\n"
+		     "    jmp  2b\n"
+		     ".previous\n"
+		     _ASM_EXTABLE(1b, 3b)
+		     : [err] "=r" (err)
+		     : "D" (fx), "m" (*fx), "a" (-1), "d" (-1), "0" (0)
+		     : "memory");
+
+	return err;
+}
+
+static inline int xsave_user(struct xsave_struct __user *buf)
+{
+	int err;
+	__asm__ __volatile__("1: .byte " REX_PREFIX "0x0f,0xae,0x27\n"
+			     "2:\n"
+			     ".section .fixup,\"ax\"\n"
+			     "3:  movl $-1,%[err]\n"
+			     "    jmp  2b\n"
+			     ".previous\n"
+			     ".section __ex_table,\"a\"\n"
+			     _ASM_ALIGN "\n"
+			     _ASM_PTR "1b,3b\n"
+			     ".previous"
+			     : [err] "=r" (err)
+			     : "D" (buf), "a" (-1), "d" (-1), "0" (0)
+			     : "memory");
+	if (unlikely(err) && __clear_user(buf, xstate_size))
+		err = -EFAULT;
+	/* No need to clear here because the caller clears USED_MATH */
+	return err;
+}
+
+static inline int xrestore_user(struct xsave_struct __user *buf, u64 mask)
+{
+	int err;
+	struct xsave_struct *xstate = ((__force struct xsave_struct *)buf);
+	u32 lmask = mask;
+	u32 hmask = mask >> 32;
+
+	__asm__ __volatile__("1: .byte " REX_PREFIX "0x0f,0xae,0x2f\n"
+			     "2:\n"
+			     ".section .fixup,\"ax\"\n"
+			     "3:  movl $-1,%[err]\n"
+			     "    jmp  2b\n"
+			     ".previous\n"
+			     ".section __ex_table,\"a\"\n"
+			     _ASM_ALIGN "\n"
+			     _ASM_PTR "1b,3b\n"
+			     ".previous"
+			     : [err] "=r" (err)
+			     : "D" (xstate), "a" (lmask), "d" (hmask), "0" (0)
+			     : "memory");	/* memory required? */
+	return err;
+}
+
+static inline void xrstor_state(struct xsave_struct *fx, u64 mask)
+{
+	u32 lmask = mask;
+	u32 hmask = mask >> 32;
+
+	asm volatile(".byte " REX_PREFIX "0x0f,0xae,0x2f\n\t"
+		     : : "D" (fx), "m" (*fx), "a" (lmask), "d" (hmask)
+		     :   "memory");
+}
+
+static inline void xsave(struct task_struct *tsk)
+{
+	/* This, however, we can work around by forcing the compiler to select
+	   an addressing mode that doesn't require extended registers. */
+	__asm__ __volatile__(".byte " REX_PREFIX "0x0f,0xae,0x27"
+			     : : "D" (&(tsk->thread.xstate->xsave)),
+				 "a" (-1), "d"(-1) : "memory");
+}
+#endif
diff --git a/include/linux/ioport.h b/include/linux/ioport.h
index 350033e..ee9bcc6 100644
--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -108,6 +108,9 @@ extern struct resource iomem_resource;
 
 extern int request_resource(struct resource *root, struct resource *new);
 extern int release_resource(struct resource *new);
+extern void reserve_region_with_split(struct resource *root,
+			     resource_size_t start, resource_size_t end,
+			     const char *name);
 extern int insert_resource(struct resource *parent, struct resource *new);
 extern void insert_resource_expand_to_fit(struct resource *root, struct resource *new);
 extern int allocate_resource(struct resource *root, struct resource *new,
diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index fac3337..9f2a375 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -23,12 +23,19 @@
 	__attribute__((__section__(SHARED_ALIGNED_SECTION)))		\
 	PER_CPU_ATTRIBUTES __typeof__(type) per_cpu__##name		\
 	____cacheline_aligned_in_smp
+
+#define DEFINE_PER_CPU_PAGE_ALIGNED(type, name)			\
+	__attribute__((__section__(".data.percpu.page_aligned")))	\
+	PER_CPU_ATTRIBUTES __typeof__(type) per_cpu__##name
 #else
 #define DEFINE_PER_CPU(type, name)					\
 	PER_CPU_ATTRIBUTES __typeof__(type) per_cpu__##name
 
 #define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)		      \
 	DEFINE_PER_CPU(type, name)
+
+#define DEFINE_PER_CPU_PAGE_ALIGNED(type, name)		      \
+	DEFINE_PER_CPU(type, name)
 #endif
 
 #define EXPORT_PER_CPU_SYMBOL(var) EXPORT_SYMBOL(per_cpu__##var)
diff --git a/kernel/resource.c b/kernel/resource.c
index 03d796c..414d6fc 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -516,6 +516,74 @@ int adjust_resource(struct resource *res, resource_size_t start, resource_size_t
 	return result;
 }
 
+static void __init __reserve_region_with_split(struct resource *root,
+		resource_size_t start, resource_size_t end,
+		const char *name)
+{
+	struct resource *parent = root;
+	struct resource *conflict;
+	struct resource *res = kzalloc(sizeof(*res), GFP_KERNEL);
+
+	if (!res)
+		return;
+
+	res->name = name;
+	res->start = start;
+	res->end = end;
+	res->flags = IORESOURCE_BUSY;
+
+	for (;;) {
+		conflict = __request_resource(parent, res);
+		if (!conflict)
+			break;
+		if (conflict != parent) {
+			parent = conflict;
+			if (!(conflict->flags & IORESOURCE_BUSY))
+				continue;
+		}
+
+		/* Uhhuh, that didn't work out.. */
+		kfree(res);
+		res = NULL;
+		break;
+	}
+
+	if (!res) {
+		printk(KERN_DEBUG "    __reserve_region_with_split: (%s) [%llx, %llx], res: (%s) [%llx, %llx]\n",
+			 conflict->name, conflict->start, conflict->end,
+			 name, start, end);
+
+		/* failed, split and try again */
+
+		/* conflict coverred whole area */
+		if (conflict->start <= start && conflict->end >= end)
+			return;
+
+		if (conflict->start > start)
+			__reserve_region_with_split(root, start, conflict->start-1, name);
+		if (!(conflict->flags & IORESOURCE_BUSY)) {
+			resource_size_t common_start, common_end;
+
+			common_start = max(conflict->start, start);
+			common_end = min(conflict->end, end);
+			if (common_start < common_end)
+				__reserve_region_with_split(root, common_start, common_end, name);
+		}
+		if (conflict->end < end)
+			__reserve_region_with_split(root, conflict->end+1, end, name);
+	}
+
+}
+
+void reserve_region_with_split(struct resource *root,
+		resource_size_t start, resource_size_t end,
+		const char *name)
+{
+	write_lock(&resource_lock);
+	__reserve_region_with_split(root, start, end, name);
+	write_unlock(&resource_lock);
+}
+
 EXPORT_SYMBOL(adjust_resource);
 
 /**
