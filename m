Return-Path: <linux-kernel-owner+w=401wt.eu-S1761676AbYJJSqK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761676AbYJJSqK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 14:46:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756053AbYJJSp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 14:45:56 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54115 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755501AbYJJSpx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 14:45:53 -0400
Date: Fri, 10 Oct 2008 20:45:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Robert Richter <robert.richter@amd.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [git pull, take 2] x86 updates for v2.6.28, phase #7, Oprofile
Message-ID: <20081010184537.GD21876@elte.hu>
References: <20081010001016.GA10837@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081010001016.GA10837@elte.hu>
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

> Linus,
> 
> Please pull the latest x86-v28-for-linus-phase7 git tree from:
> 
> Oprofile updates. (Embedded in later topics due to apic unification 
> impact and other ordering constraints.)

please find updated pull request below. Relative to phase-N-1. No 
changes beyond the first pull request, other than what came in via 
phase-N-1.

	Ingo

----------->
Linus,

Please pull the latest x86-v28-for-linus-phase7-B git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-v28-for-linus-phase7-B


out-of-topic modifications in x86-v28-for-linus-phase7-B:
---------------------------------------------------------
arch/Kconfig                       # 852402c: x86/oprofile: add CONFIG_OPROFILE
drivers/oprofile/buffer_sync.c     # 852402c: x86/oprofile: add CONFIG_OPROFILE
                                   # 345c257: x86/oprofile: add IBS support for
                                   # 5e11f98: OProfile: moving increment_tail()
                                   # 73185e0: drivers/oprofile: coding style fi
drivers/oprofile/cpu_buffer.c      # bd17b62: oprofile: fix printk in cpu_buffe
                                   # 852402c: x86/oprofile: add CONFIG_OPROFILE
                                   # 345c257: x86/oprofile: add IBS support for
drivers/oprofile/cpu_buffer.h      # 345c257: x86/oprofile: add IBS support for
include/linux/oprofile.h           # 4c168ea: Revert "Oprofile Multiplexing Pat
                                   # 1a960b4: Oprofile Multiplexing Patch
                                   # ee648bc: OProfile: add IBS code macros

 Thanks,

	Ingo

------------------>
Andrea Righi (1):
      x86, oprofile: BUG: using smp_processor_id() in preemptible code

Barry Kasindorf (3):
      oprofile: Add support for AMD Family 11h
      x86/oprofile: add IBS support for AMD CPUs, IBS buffer handling routines
      x86/oprofile: add IBS support for AMD CPUs, model specific code

Jason Yeh (1):
      Oprofile Multiplexing Patch

Robert Richter (24):
      x86: add PCI IDs for AMD Barcelona PCI devices
      x86: apic_*.c: add description to AMD's extended LVT functions
      x86/oprofile: introduce model specific init/exit functions
      x86/oprofile: Minor changes in op_model_athlon.c
      x86/oprofile: renaming athlon_*() into op_amd_*()
      drivers/oprofile: coding style fixes in buffer_sync.c
      OProfile: moving increment_tail() in buffer_sync.c
      OProfile: add IBS code macros
      x86/oprofile: separating the IBS handler
      OProfile: change IBS interrupt initialization
      OProfile: Fix build error in op_model_athlon.c
      OProfile: on_each_cpu(): kill unused retry parameter
      OProfile: fix setup_ibs_files() function interface
      OProfile: enable IBS for AMD CPUs
      OProfile: fix IBS build error for UP
      x86/oprofile: macro definition cleanup in op_model_athlon.c
      x86/oprofile: op_model_athlon.c: fix counter reset when reenabling IBS OP
      x86: apic: export symbols for extended interrupt LVT functions
      x86: apic: changing export symbols to *_GPL
      x86/oprofile: add CONFIG_OPROFILE_IBS option
      oprofile: fix printk in cpu_buffer.c
      x86/oprofile: reanaming op_model_athlon.c to op_model_amd.c
      x86/oprofile: fix on_each_cpu build error
      Revert "Oprofile Multiplexing Patch"


 arch/Kconfig                        |   14 +
 arch/x86/kernel/apic_32.c           |    4 +
 arch/x86/kernel/apic_64.c           |    4 +
 arch/x86/oprofile/Makefile          |    2 +-
 arch/x86/oprofile/nmi_int.c         |   27 ++-
 arch/x86/oprofile/op_model_amd.c    |  543 +++++++++++++++++++++++++++++++++++
 arch/x86/oprofile/op_model_athlon.c |  190 ------------
 arch/x86/oprofile/op_x86_model.h    |    4 +-
 drivers/oprofile/buffer_sync.c      |  209 +++++++++-----
 drivers/oprofile/cpu_buffer.c       |   74 +++++-
 drivers/oprofile/cpu_buffer.h       |    2 +
 include/linux/oprofile.h            |    2 +
 12 files changed, 809 insertions(+), 266 deletions(-)
 create mode 100644 arch/x86/oprofile/op_model_amd.c
 delete mode 100644 arch/x86/oprofile/op_model_athlon.c

diff --git a/arch/Kconfig b/arch/Kconfig
index 364c6da..0267bab 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -13,6 +13,20 @@ config OPROFILE
 
 	  If unsure, say N.
 
+config OPROFILE_IBS
+	bool "OProfile AMD IBS support (EXPERIMENTAL)"
+	default n
+	depends on OPROFILE && SMP && X86
+	help
+          Instruction-Based Sampling (IBS) is a new profiling
+          technique that provides rich, precise program performance
+          information. IBS is introduced by AMD Family10h processors
+          (AMD Opteron Quad-Core processor “Barcelona”) to overcome
+          the limitations of conventional performance counter
+          sampling.
+
+	  If unsure, say N.
+
 config HAVE_OPROFILE
 	def_bool n
 
diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
index a91c57c..21c831d 100644
--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -295,6 +295,9 @@ static void __setup_APIC_LVTT(unsigned int clocks, int oneshot, int irqen)
  *
  * Vector mappings are hard coded. On K8 only offset 0 (APIC500) and
  * MCE interrupts are supported. Thus MCE offset must be set to 0.
+ *
+ * If mask=1, the LVT entry does not generate interrupts while mask=0
+ * enables the vector. See also the BKDGs.
  */
 
 #define APIC_EILVT_LVTOFF_MCE 0
@@ -319,6 +322,7 @@ u8 setup_APIC_eilvt_ibs(u8 vector, u8 msg_type, u8 mask)
 	setup_APIC_eilvt(APIC_EILVT_LVTOFF_IBS, vector, msg_type, mask);
 	return APIC_EILVT_LVTOFF_IBS;
 }
+EXPORT_SYMBOL_GPL(setup_APIC_eilvt_ibs);
 
 /*
  * Program the next event, relative to now
diff --git a/arch/x86/kernel/apic_64.c b/arch/x86/kernel/apic_64.c
index 53898b6..94ddb69 100644
--- a/arch/x86/kernel/apic_64.c
+++ b/arch/x86/kernel/apic_64.c
@@ -307,6 +307,9 @@ static void __setup_APIC_LVTT(unsigned int clocks, int oneshot, int irqen)
  *
  * Vector mappings are hard coded. On K8 only offset 0 (APIC500) and
  * MCE interrupts are supported. Thus MCE offset must be set to 0.
+ *
+ * If mask=1, the LVT entry does not generate interrupts while mask=0
+ * enables the vector. See also the BKDGs.
  */
 
 #define APIC_EILVT_LVTOFF_MCE 0
@@ -331,6 +334,7 @@ u8 setup_APIC_eilvt_ibs(u8 vector, u8 msg_type, u8 mask)
 	setup_APIC_eilvt(APIC_EILVT_LVTOFF_IBS, vector, msg_type, mask);
 	return APIC_EILVT_LVTOFF_IBS;
 }
+EXPORT_SYMBOL_GPL(setup_APIC_eilvt_ibs);
 
 /*
  * Program the next event, relative to now
diff --git a/arch/x86/oprofile/Makefile b/arch/x86/oprofile/Makefile
index 30f3eb3..446902b 100644
--- a/arch/x86/oprofile/Makefile
+++ b/arch/x86/oprofile/Makefile
@@ -7,6 +7,6 @@ DRIVER_OBJS = $(addprefix ../../../drivers/oprofile/, \
 		timer_int.o )
 
 oprofile-y				:= $(DRIVER_OBJS) init.o backtrace.o
-oprofile-$(CONFIG_X86_LOCAL_APIC) 	+= nmi_int.o op_model_athlon.o \
+oprofile-$(CONFIG_X86_LOCAL_APIC) 	+= nmi_int.o op_model_amd.o \
 					   op_model_ppro.o op_model_p4.o
 oprofile-$(CONFIG_X86_IO_APIC)		+= nmi_timer_int.o
diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index 8a5f161..57f6c90 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -1,10 +1,11 @@
 /**
  * @file nmi_int.c
  *
- * @remark Copyright 2002 OProfile authors
+ * @remark Copyright 2002-2008 OProfile authors
  * @remark Read the file COPYING
  *
  * @author John Levon <levon@movementarian.org>
+ * @author Robert Richter <robert.richter@amd.com>
  */
 
 #include <linux/init.h>
@@ -439,6 +440,7 @@ int __init op_nmi_init(struct oprofile_operations *ops)
 	__u8 vendor = boot_cpu_data.x86_vendor;
 	__u8 family = boot_cpu_data.x86;
 	char *cpu_type;
+	int ret = 0;
 
 	if (!cpu_has_apic)
 		return -ENODEV;
@@ -451,19 +453,23 @@ int __init op_nmi_init(struct oprofile_operations *ops)
 		default:
 			return -ENODEV;
 		case 6:
-			model = &op_athlon_spec;
+			model = &op_amd_spec;
 			cpu_type = "i386/athlon";
 			break;
 		case 0xf:
-			model = &op_athlon_spec;
+			model = &op_amd_spec;
 			/* Actually it could be i386/hammer too, but give
 			 user space an consistent name. */
 			cpu_type = "x86-64/hammer";
 			break;
 		case 0x10:
-			model = &op_athlon_spec;
+			model = &op_amd_spec;
 			cpu_type = "x86-64/family10";
 			break;
+		case 0x11:
+			model = &op_amd_spec;
+			cpu_type = "x86-64/family11h";
+			break;
 		}
 		break;
 
@@ -490,17 +496,24 @@ int __init op_nmi_init(struct oprofile_operations *ops)
 		return -ENODEV;
 	}
 
-	init_sysfs();
 #ifdef CONFIG_SMP
 	register_cpu_notifier(&oprofile_cpu_nb);
 #endif
-	using_nmi = 1;
+	/* default values, can be overwritten by model */
 	ops->create_files = nmi_create_files;
 	ops->setup = nmi_setup;
 	ops->shutdown = nmi_shutdown;
 	ops->start = nmi_start;
 	ops->stop = nmi_stop;
 	ops->cpu_type = cpu_type;
+
+	if (model->init)
+		ret = model->init(ops);
+	if (ret)
+		return ret;
+
+	init_sysfs();
+	using_nmi = 1;
 	printk(KERN_INFO "oprofile: using NMI interrupt.\n");
 	return 0;
 }
@@ -513,4 +526,6 @@ void op_nmi_exit(void)
 		unregister_cpu_notifier(&oprofile_cpu_nb);
 #endif
 	}
+	if (model->exit)
+		model->exit();
 }
diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_amd.c
new file mode 100644
index 0000000..d9faf60
--- /dev/null
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -0,0 +1,543 @@
+/*
+ * @file op_model_amd.c
+ * athlon / K7 / K8 / Family 10h model-specific MSR operations
+ *
+ * @remark Copyright 2002-2008 OProfile authors
+ * @remark Read the file COPYING
+ *
+ * @author John Levon
+ * @author Philippe Elie
+ * @author Graydon Hoare
+ * @author Robert Richter <robert.richter@amd.com>
+ * @author Barry Kasindorf
+*/
+
+#include <linux/oprofile.h>
+#include <linux/device.h>
+#include <linux/pci.h>
+
+#include <asm/ptrace.h>
+#include <asm/msr.h>
+#include <asm/nmi.h>
+
+#include "op_x86_model.h"
+#include "op_counter.h"
+
+#define NUM_COUNTERS 4
+#define NUM_CONTROLS 4
+
+#define CTR_IS_RESERVED(msrs, c) (msrs->counters[(c)].addr ? 1 : 0)
+#define CTR_READ(l, h, msrs, c) do {rdmsr(msrs->counters[(c)].addr, (l), (h)); } while (0)
+#define CTR_WRITE(l, msrs, c) do {wrmsr(msrs->counters[(c)].addr, -(unsigned int)(l), -1); } while (0)
+#define CTR_OVERFLOWED(n) (!((n) & (1U<<31)))
+
+#define CTRL_IS_RESERVED(msrs, c) (msrs->controls[(c)].addr ? 1 : 0)
+#define CTRL_READ(l, h, msrs, c) do {rdmsr(msrs->controls[(c)].addr, (l), (h)); } while (0)
+#define CTRL_WRITE(l, h, msrs, c) do {wrmsr(msrs->controls[(c)].addr, (l), (h)); } while (0)
+#define CTRL_SET_ACTIVE(n) (n |= (1<<22))
+#define CTRL_SET_INACTIVE(n) (n &= ~(1<<22))
+#define CTRL_CLEAR_LO(x) (x &= (1<<21))
+#define CTRL_CLEAR_HI(x) (x &= 0xfffffcf0)
+#define CTRL_SET_ENABLE(val) (val |= 1<<20)
+#define CTRL_SET_USR(val, u) (val |= ((u & 1) << 16))
+#define CTRL_SET_KERN(val, k) (val |= ((k & 1) << 17))
+#define CTRL_SET_UM(val, m) (val |= (m << 8))
+#define CTRL_SET_EVENT_LOW(val, e) (val |= (e & 0xff))
+#define CTRL_SET_EVENT_HIGH(val, e) (val |= ((e >> 8) & 0xf))
+#define CTRL_SET_HOST_ONLY(val, h) (val |= ((h & 1) << 9))
+#define CTRL_SET_GUEST_ONLY(val, h) (val |= ((h & 1) << 8))
+
+static unsigned long reset_value[NUM_COUNTERS];
+
+#ifdef CONFIG_OPROFILE_IBS
+
+/* IbsFetchCtl bits/masks */
+#define IBS_FETCH_HIGH_VALID_BIT	(1UL << 17)	/* bit 49 */
+#define IBS_FETCH_HIGH_ENABLE		(1UL << 16)	/* bit 48 */
+#define IBS_FETCH_LOW_MAX_CNT_MASK	0x0000FFFFUL	/* MaxCnt mask */
+
+/*IbsOpCtl bits */
+#define IBS_OP_LOW_VALID_BIT		(1ULL<<18)	/* bit 18 */
+#define IBS_OP_LOW_ENABLE		(1ULL<<17)	/* bit 17 */
+
+/* Codes used in cpu_buffer.c */
+/* This produces duplicate code, need to be fixed */
+#define IBS_FETCH_BEGIN 3
+#define IBS_OP_BEGIN    4
+
+/* The function interface needs to be fixed, something like add
+   data. Should then be added to linux/oprofile.h. */
+extern void oprofile_add_ibs_sample(struct pt_regs *const regs,
+				    unsigned int * const ibs_sample, u8 code);
+
+struct ibs_fetch_sample {
+	/* MSRC001_1031 IBS Fetch Linear Address Register */
+	unsigned int ibs_fetch_lin_addr_low;
+	unsigned int ibs_fetch_lin_addr_high;
+	/* MSRC001_1030 IBS Fetch Control Register */
+	unsigned int ibs_fetch_ctl_low;
+	unsigned int ibs_fetch_ctl_high;
+	/* MSRC001_1032 IBS Fetch Physical Address Register */
+	unsigned int ibs_fetch_phys_addr_low;
+	unsigned int ibs_fetch_phys_addr_high;
+};
+
+struct ibs_op_sample {
+	/* MSRC001_1034 IBS Op Logical Address Register (IbsRIP) */
+	unsigned int ibs_op_rip_low;
+	unsigned int ibs_op_rip_high;
+	/* MSRC001_1035 IBS Op Data Register */
+	unsigned int ibs_op_data1_low;
+	unsigned int ibs_op_data1_high;
+	/* MSRC001_1036 IBS Op Data 2 Register */
+	unsigned int ibs_op_data2_low;
+	unsigned int ibs_op_data2_high;
+	/* MSRC001_1037 IBS Op Data 3 Register */
+	unsigned int ibs_op_data3_low;
+	unsigned int ibs_op_data3_high;
+	/* MSRC001_1038 IBS DC Linear Address Register (IbsDcLinAd) */
+	unsigned int ibs_dc_linear_low;
+	unsigned int ibs_dc_linear_high;
+	/* MSRC001_1039 IBS DC Physical Address Register (IbsDcPhysAd) */
+	unsigned int ibs_dc_phys_low;
+	unsigned int ibs_dc_phys_high;
+};
+
+/*
+ * unitialize the APIC for the IBS interrupts if needed on AMD Family10h+
+*/
+static void clear_ibs_nmi(void);
+
+static int ibs_allowed;	/* AMD Family10h and later */
+
+struct op_ibs_config {
+	unsigned long op_enabled;
+	unsigned long fetch_enabled;
+	unsigned long max_cnt_fetch;
+	unsigned long max_cnt_op;
+	unsigned long rand_en;
+	unsigned long dispatched_ops;
+};
+
+static struct op_ibs_config ibs_config;
+
+#endif
+
+/* functions for op_amd_spec */
+
+static void op_amd_fill_in_addresses(struct op_msrs * const msrs)
+{
+	int i;
+
+	for (i = 0; i < NUM_COUNTERS; i++) {
+		if (reserve_perfctr_nmi(MSR_K7_PERFCTR0 + i))
+			msrs->counters[i].addr = MSR_K7_PERFCTR0 + i;
+		else
+			msrs->counters[i].addr = 0;
+	}
+
+	for (i = 0; i < NUM_CONTROLS; i++) {
+		if (reserve_evntsel_nmi(MSR_K7_EVNTSEL0 + i))
+			msrs->controls[i].addr = MSR_K7_EVNTSEL0 + i;
+		else
+			msrs->controls[i].addr = 0;
+	}
+}
+
+
+static void op_amd_setup_ctrs(struct op_msrs const * const msrs)
+{
+	unsigned int low, high;
+	int i;
+
+	/* clear all counters */
+	for (i = 0 ; i < NUM_CONTROLS; ++i) {
+		if (unlikely(!CTRL_IS_RESERVED(msrs, i)))
+			continue;
+		CTRL_READ(low, high, msrs, i);
+		CTRL_CLEAR_LO(low);
+		CTRL_CLEAR_HI(high);
+		CTRL_WRITE(low, high, msrs, i);
+	}
+
+	/* avoid a false detection of ctr overflows in NMI handler */
+	for (i = 0; i < NUM_COUNTERS; ++i) {
+		if (unlikely(!CTR_IS_RESERVED(msrs, i)))
+			continue;
+		CTR_WRITE(1, msrs, i);
+	}
+
+	/* enable active counters */
+	for (i = 0; i < NUM_COUNTERS; ++i) {
+		if ((counter_config[i].enabled) && (CTR_IS_RESERVED(msrs, i))) {
+			reset_value[i] = counter_config[i].count;
+
+			CTR_WRITE(counter_config[i].count, msrs, i);
+
+			CTRL_READ(low, high, msrs, i);
+			CTRL_CLEAR_LO(low);
+			CTRL_CLEAR_HI(high);
+			CTRL_SET_ENABLE(low);
+			CTRL_SET_USR(low, counter_config[i].user);
+			CTRL_SET_KERN(low, counter_config[i].kernel);
+			CTRL_SET_UM(low, counter_config[i].unit_mask);
+			CTRL_SET_EVENT_LOW(low, counter_config[i].event);
+			CTRL_SET_EVENT_HIGH(high, counter_config[i].event);
+			CTRL_SET_HOST_ONLY(high, 0);
+			CTRL_SET_GUEST_ONLY(high, 0);
+
+			CTRL_WRITE(low, high, msrs, i);
+		} else {
+			reset_value[i] = 0;
+		}
+	}
+}
+
+#ifdef CONFIG_OPROFILE_IBS
+
+static inline int
+op_amd_handle_ibs(struct pt_regs * const regs,
+		  struct op_msrs const * const msrs)
+{
+	unsigned int low, high;
+	struct ibs_fetch_sample ibs_fetch;
+	struct ibs_op_sample ibs_op;
+
+	if (!ibs_allowed)
+		return 1;
+
+	if (ibs_config.fetch_enabled) {
+		rdmsr(MSR_AMD64_IBSFETCHCTL, low, high);
+		if (high & IBS_FETCH_HIGH_VALID_BIT) {
+			ibs_fetch.ibs_fetch_ctl_high = high;
+			ibs_fetch.ibs_fetch_ctl_low = low;
+			rdmsr(MSR_AMD64_IBSFETCHLINAD, low, high);
+			ibs_fetch.ibs_fetch_lin_addr_high = high;
+			ibs_fetch.ibs_fetch_lin_addr_low = low;
+			rdmsr(MSR_AMD64_IBSFETCHPHYSAD, low, high);
+			ibs_fetch.ibs_fetch_phys_addr_high = high;
+			ibs_fetch.ibs_fetch_phys_addr_low = low;
+
+			oprofile_add_ibs_sample(regs,
+						(unsigned int *)&ibs_fetch,
+						IBS_FETCH_BEGIN);
+
+			/*reenable the IRQ */
+			rdmsr(MSR_AMD64_IBSFETCHCTL, low, high);
+			high &= ~IBS_FETCH_HIGH_VALID_BIT;
+			high |= IBS_FETCH_HIGH_ENABLE;
+			low &= IBS_FETCH_LOW_MAX_CNT_MASK;
+			wrmsr(MSR_AMD64_IBSFETCHCTL, low, high);
+		}
+	}
+
+	if (ibs_config.op_enabled) {
+		rdmsr(MSR_AMD64_IBSOPCTL, low, high);
+		if (low & IBS_OP_LOW_VALID_BIT) {
+			rdmsr(MSR_AMD64_IBSOPRIP, low, high);
+			ibs_op.ibs_op_rip_low = low;
+			ibs_op.ibs_op_rip_high = high;
+			rdmsr(MSR_AMD64_IBSOPDATA, low, high);
+			ibs_op.ibs_op_data1_low = low;
+			ibs_op.ibs_op_data1_high = high;
+			rdmsr(MSR_AMD64_IBSOPDATA2, low, high);
+			ibs_op.ibs_op_data2_low = low;
+			ibs_op.ibs_op_data2_high = high;
+			rdmsr(MSR_AMD64_IBSOPDATA3, low, high);
+			ibs_op.ibs_op_data3_low = low;
+			ibs_op.ibs_op_data3_high = high;
+			rdmsr(MSR_AMD64_IBSDCLINAD, low, high);
+			ibs_op.ibs_dc_linear_low = low;
+			ibs_op.ibs_dc_linear_high = high;
+			rdmsr(MSR_AMD64_IBSDCPHYSAD, low, high);
+			ibs_op.ibs_dc_phys_low = low;
+			ibs_op.ibs_dc_phys_high = high;
+
+			/* reenable the IRQ */
+			oprofile_add_ibs_sample(regs,
+						(unsigned int *)&ibs_op,
+						IBS_OP_BEGIN);
+			rdmsr(MSR_AMD64_IBSOPCTL, low, high);
+			high = 0;
+			low &= ~IBS_OP_LOW_VALID_BIT;
+			low |= IBS_OP_LOW_ENABLE;
+			wrmsr(MSR_AMD64_IBSOPCTL, low, high);
+		}
+	}
+
+	return 1;
+}
+
+#endif
+
+static int op_amd_check_ctrs(struct pt_regs * const regs,
+			     struct op_msrs const * const msrs)
+{
+	unsigned int low, high;
+	int i;
+
+	for (i = 0 ; i < NUM_COUNTERS; ++i) {
+		if (!reset_value[i])
+			continue;
+		CTR_READ(low, high, msrs, i);
+		if (CTR_OVERFLOWED(low)) {
+			oprofile_add_sample(regs, i);
+			CTR_WRITE(reset_value[i], msrs, i);
+		}
+	}
+
+#ifdef CONFIG_OPROFILE_IBS
+	op_amd_handle_ibs(regs, msrs);
+#endif
+
+	/* See op_model_ppro.c */
+	return 1;
+}
+
+static void op_amd_start(struct op_msrs const * const msrs)
+{
+	unsigned int low, high;
+	int i;
+	for (i = 0 ; i < NUM_COUNTERS ; ++i) {
+		if (reset_value[i]) {
+			CTRL_READ(low, high, msrs, i);
+			CTRL_SET_ACTIVE(low);
+			CTRL_WRITE(low, high, msrs, i);
+		}
+	}
+
+#ifdef CONFIG_OPROFILE_IBS
+	if (ibs_allowed && ibs_config.fetch_enabled) {
+		low = (ibs_config.max_cnt_fetch >> 4) & 0xFFFF;
+		high = IBS_FETCH_HIGH_ENABLE;
+		wrmsr(MSR_AMD64_IBSFETCHCTL, low, high);
+	}
+
+	if (ibs_allowed && ibs_config.op_enabled) {
+		low = ((ibs_config.max_cnt_op >> 4) & 0xFFFF) + IBS_OP_LOW_ENABLE;
+		high = 0;
+		wrmsr(MSR_AMD64_IBSOPCTL, low, high);
+	}
+#endif
+}
+
+
+static void op_amd_stop(struct op_msrs const * const msrs)
+{
+	unsigned int low, high;
+	int i;
+
+	/* Subtle: stop on all counters to avoid race with
+	 * setting our pm callback */
+	for (i = 0 ; i < NUM_COUNTERS ; ++i) {
+		if (!reset_value[i])
+			continue;
+		CTRL_READ(low, high, msrs, i);
+		CTRL_SET_INACTIVE(low);
+		CTRL_WRITE(low, high, msrs, i);
+	}
+
+#ifdef CONFIG_OPROFILE_IBS
+	if (ibs_allowed && ibs_config.fetch_enabled) {
+		low = 0;		/* clear max count and enable */
+		high = 0;
+		wrmsr(MSR_AMD64_IBSFETCHCTL, low, high);
+	}
+
+	if (ibs_allowed && ibs_config.op_enabled) {
+		low = 0;		/* clear max count and enable */
+		high = 0;
+		wrmsr(MSR_AMD64_IBSOPCTL, low, high);
+	}
+#endif
+}
+
+static void op_amd_shutdown(struct op_msrs const * const msrs)
+{
+	int i;
+
+	for (i = 0 ; i < NUM_COUNTERS ; ++i) {
+		if (CTR_IS_RESERVED(msrs, i))
+			release_perfctr_nmi(MSR_K7_PERFCTR0 + i);
+	}
+	for (i = 0 ; i < NUM_CONTROLS ; ++i) {
+		if (CTRL_IS_RESERVED(msrs, i))
+			release_evntsel_nmi(MSR_K7_EVNTSEL0 + i);
+	}
+}
+
+#ifndef CONFIG_OPROFILE_IBS
+
+/* no IBS support */
+
+static int op_amd_init(struct oprofile_operations *ops)
+{
+	return 0;
+}
+
+static void op_amd_exit(void) {}
+
+#else
+
+static u8 ibs_eilvt_off;
+
+static inline void apic_init_ibs_nmi_per_cpu(void *arg)
+{
+	ibs_eilvt_off = setup_APIC_eilvt_ibs(0, APIC_EILVT_MSG_NMI, 0);
+}
+
+static inline void apic_clear_ibs_nmi_per_cpu(void *arg)
+{
+	setup_APIC_eilvt_ibs(0, APIC_EILVT_MSG_FIX, 1);
+}
+
+static int pfm_amd64_setup_eilvt(void)
+{
+#define IBSCTL_LVTOFFSETVAL		(1 << 8)
+#define IBSCTL				0x1cc
+	struct pci_dev *cpu_cfg;
+	int nodes;
+	u32 value = 0;
+
+	/* per CPU setup */
+	on_each_cpu(apic_init_ibs_nmi_per_cpu, NULL, 1);
+
+	nodes = 0;
+	cpu_cfg = NULL;
+	do {
+		cpu_cfg = pci_get_device(PCI_VENDOR_ID_AMD,
+					 PCI_DEVICE_ID_AMD_10H_NB_MISC,
+					 cpu_cfg);
+		if (!cpu_cfg)
+			break;
+		++nodes;
+		pci_write_config_dword(cpu_cfg, IBSCTL, ibs_eilvt_off
+				       | IBSCTL_LVTOFFSETVAL);
+		pci_read_config_dword(cpu_cfg, IBSCTL, &value);
+		if (value != (ibs_eilvt_off | IBSCTL_LVTOFFSETVAL)) {
+			printk(KERN_DEBUG "Failed to setup IBS LVT offset, "
+				"IBSCTL = 0x%08x", value);
+			return 1;
+		}
+	} while (1);
+
+	if (!nodes) {
+		printk(KERN_DEBUG "No CPU node configured for IBS");
+		return 1;
+	}
+
+#ifdef CONFIG_NUMA
+	/* Sanity check */
+	/* Works only for 64bit with proper numa implementation. */
+	if (nodes != num_possible_nodes()) {
+		printk(KERN_DEBUG "Failed to setup CPU node(s) for IBS, "
+			"found: %d, expected %d",
+			nodes, num_possible_nodes());
+		return 1;
+	}
+#endif
+	return 0;
+}
+
+/*
+ * initialize the APIC for the IBS interrupts
+ * if available (AMD Family10h rev B0 and later)
+ */
+static void setup_ibs(void)
+{
+	ibs_allowed = boot_cpu_has(X86_FEATURE_IBS);
+
+	if (!ibs_allowed)
+		return;
+
+	if (pfm_amd64_setup_eilvt()) {
+		ibs_allowed = 0;
+		return;
+	}
+
+	printk(KERN_INFO "oprofile: AMD IBS detected\n");
+}
+
+
+/*
+ * unitialize the APIC for the IBS interrupts if needed on AMD Family10h
+ * rev B0 and later */
+static void clear_ibs_nmi(void)
+{
+	if (ibs_allowed)
+		on_each_cpu(apic_clear_ibs_nmi_per_cpu, NULL, 1);
+}
+
+static int (*create_arch_files)(struct super_block * sb, struct dentry * root);
+
+static int setup_ibs_files(struct super_block * sb, struct dentry * root)
+{
+	char buf[12];
+	struct dentry *dir;
+	int ret = 0;
+
+	/* architecture specific files */
+	if (create_arch_files)
+		ret = create_arch_files(sb, root);
+
+	if (ret)
+		return ret;
+
+	if (!ibs_allowed)
+		return ret;
+
+	/* model specific files */
+
+	/* setup some reasonable defaults */
+	ibs_config.max_cnt_fetch = 250000;
+	ibs_config.fetch_enabled = 0;
+	ibs_config.max_cnt_op = 250000;
+	ibs_config.op_enabled = 0;
+	ibs_config.dispatched_ops = 1;
+	snprintf(buf,  sizeof(buf), "ibs_fetch");
+	dir = oprofilefs_mkdir(sb, root, buf);
+	oprofilefs_create_ulong(sb, dir, "rand_enable",
+				&ibs_config.rand_en);
+	oprofilefs_create_ulong(sb, dir, "enable",
+		&ibs_config.fetch_enabled);
+	oprofilefs_create_ulong(sb, dir, "max_count",
+		&ibs_config.max_cnt_fetch);
+	snprintf(buf,  sizeof(buf), "ibs_uops");
+	dir = oprofilefs_mkdir(sb, root, buf);
+	oprofilefs_create_ulong(sb, dir, "enable",
+		&ibs_config.op_enabled);
+	oprofilefs_create_ulong(sb, dir, "max_count",
+		&ibs_config.max_cnt_op);
+	oprofilefs_create_ulong(sb, dir, "dispatched_ops",
+		&ibs_config.dispatched_ops);
+
+	return 0;
+}
+
+static int op_amd_init(struct oprofile_operations *ops)
+{
+	setup_ibs();
+	create_arch_files = ops->create_files;
+	ops->create_files = setup_ibs_files;
+	return 0;
+}
+
+static void op_amd_exit(void)
+{
+	clear_ibs_nmi();
+}
+
+#endif
+
+struct op_x86_model_spec const op_amd_spec = {
+	.init = op_amd_init,
+	.exit = op_amd_exit,
+	.num_counters = NUM_COUNTERS,
+	.num_controls = NUM_CONTROLS,
+	.fill_in_addresses = &op_amd_fill_in_addresses,
+	.setup_ctrs = &op_amd_setup_ctrs,
+	.check_ctrs = &op_amd_check_ctrs,
+	.start = &op_amd_start,
+	.stop = &op_amd_stop,
+	.shutdown = &op_amd_shutdown
+};
diff --git a/arch/x86/oprofile/op_model_athlon.c b/arch/x86/oprofile/op_model_athlon.c
deleted file mode 100644
index 3d53487..0000000
--- a/arch/x86/oprofile/op_model_athlon.c
+++ /dev/null
@@ -1,190 +0,0 @@
-/*
- * @file op_model_athlon.h
- * athlon / K7 / K8 / Family 10h model-specific MSR operations
- *
- * @remark Copyright 2002 OProfile authors
- * @remark Read the file COPYING
- *
- * @author John Levon
- * @author Philippe Elie
- * @author Graydon Hoare
- */
-
-#include <linux/oprofile.h>
-#include <asm/ptrace.h>
-#include <asm/msr.h>
-#include <asm/nmi.h>
-
-#include "op_x86_model.h"
-#include "op_counter.h"
-
-#define NUM_COUNTERS 4
-#define NUM_CONTROLS 4
-
-#define CTR_IS_RESERVED(msrs, c) (msrs->counters[(c)].addr ? 1 : 0)
-#define CTR_READ(l, h, msrs, c) do {rdmsr(msrs->counters[(c)].addr, (l), (h)); } while (0)
-#define CTR_WRITE(l, msrs, c) do {wrmsr(msrs->counters[(c)].addr, -(unsigned int)(l), -1); } while (0)
-#define CTR_OVERFLOWED(n) (!((n) & (1U<<31)))
-
-#define CTRL_IS_RESERVED(msrs, c) (msrs->controls[(c)].addr ? 1 : 0)
-#define CTRL_READ(l, h, msrs, c) do {rdmsr(msrs->controls[(c)].addr, (l), (h)); } while (0)
-#define CTRL_WRITE(l, h, msrs, c) do {wrmsr(msrs->controls[(c)].addr, (l), (h)); } while (0)
-#define CTRL_SET_ACTIVE(n) (n |= (1<<22))
-#define CTRL_SET_INACTIVE(n) (n &= ~(1<<22))
-#define CTRL_CLEAR_LO(x) (x &= (1<<21))
-#define CTRL_CLEAR_HI(x) (x &= 0xfffffcf0)
-#define CTRL_SET_ENABLE(val) (val |= 1<<20)
-#define CTRL_SET_USR(val, u) (val |= ((u & 1) << 16))
-#define CTRL_SET_KERN(val, k) (val |= ((k & 1) << 17))
-#define CTRL_SET_UM(val, m) (val |= (m << 8))
-#define CTRL_SET_EVENT_LOW(val, e) (val |= (e & 0xff))
-#define CTRL_SET_EVENT_HIGH(val, e) (val |= ((e >> 8) & 0xf))
-#define CTRL_SET_HOST_ONLY(val, h) (val |= ((h & 1) << 9))
-#define CTRL_SET_GUEST_ONLY(val, h) (val |= ((h & 1) << 8))
-
-static unsigned long reset_value[NUM_COUNTERS];
-
-static void athlon_fill_in_addresses(struct op_msrs * const msrs)
-{
-	int i;
-
-	for (i = 0; i < NUM_COUNTERS; i++) {
-		if (reserve_perfctr_nmi(MSR_K7_PERFCTR0 + i))
-			msrs->counters[i].addr = MSR_K7_PERFCTR0 + i;
-		else
-			msrs->counters[i].addr = 0;
-	}
-
-	for (i = 0; i < NUM_CONTROLS; i++) {
-		if (reserve_evntsel_nmi(MSR_K7_EVNTSEL0 + i))
-			msrs->controls[i].addr = MSR_K7_EVNTSEL0 + i;
-		else
-			msrs->controls[i].addr = 0;
-	}
-}
-
-
-static void athlon_setup_ctrs(struct op_msrs const * const msrs)
-{
-	unsigned int low, high;
-	int i;
-
-	/* clear all counters */
-	for (i = 0 ; i < NUM_CONTROLS; ++i) {
-		if (unlikely(!CTRL_IS_RESERVED(msrs, i)))
-			continue;
-		CTRL_READ(low, high, msrs, i);
-		CTRL_CLEAR_LO(low);
-		CTRL_CLEAR_HI(high);
-		CTRL_WRITE(low, high, msrs, i);
-	}
-
-	/* avoid a false detection of ctr overflows in NMI handler */
-	for (i = 0; i < NUM_COUNTERS; ++i) {
-		if (unlikely(!CTR_IS_RESERVED(msrs, i)))
-			continue;
-		CTR_WRITE(1, msrs, i);
-	}
-
-	/* enable active counters */
-	for (i = 0; i < NUM_COUNTERS; ++i) {
-		if ((counter_config[i].enabled) && (CTR_IS_RESERVED(msrs, i))) {
-			reset_value[i] = counter_config[i].count;
-
-			CTR_WRITE(counter_config[i].count, msrs, i);
-
-			CTRL_READ(low, high, msrs, i);
-			CTRL_CLEAR_LO(low);
-			CTRL_CLEAR_HI(high);
-			CTRL_SET_ENABLE(low);
-			CTRL_SET_USR(low, counter_config[i].user);
-			CTRL_SET_KERN(low, counter_config[i].kernel);
-			CTRL_SET_UM(low, counter_config[i].unit_mask);
-			CTRL_SET_EVENT_LOW(low, counter_config[i].event);
-			CTRL_SET_EVENT_HIGH(high, counter_config[i].event);
-			CTRL_SET_HOST_ONLY(high, 0);
-			CTRL_SET_GUEST_ONLY(high, 0);
-
-			CTRL_WRITE(low, high, msrs, i);
-		} else {
-			reset_value[i] = 0;
-		}
-	}
-}
-
-
-static int athlon_check_ctrs(struct pt_regs * const regs,
-			     struct op_msrs const * const msrs)
-{
-	unsigned int low, high;
-	int i;
-
-	for (i = 0 ; i < NUM_COUNTERS; ++i) {
-		if (!reset_value[i])
-			continue;
-		CTR_READ(low, high, msrs, i);
-		if (CTR_OVERFLOWED(low)) {
-			oprofile_add_sample(regs, i);
-			CTR_WRITE(reset_value[i], msrs, i);
-		}
-	}
-
-	/* See op_model_ppro.c */
-	return 1;
-}
-
-
-static void athlon_start(struct op_msrs const * const msrs)
-{
-	unsigned int low, high;
-	int i;
-	for (i = 0 ; i < NUM_COUNTERS ; ++i) {
-		if (reset_value[i]) {
-			CTRL_READ(low, high, msrs, i);
-			CTRL_SET_ACTIVE(low);
-			CTRL_WRITE(low, high, msrs, i);
-		}
-	}
-}
-
-
-static void athlon_stop(struct op_msrs const * const msrs)
-{
-	unsigned int low, high;
-	int i;
-
-	/* Subtle: stop on all counters to avoid race with
-	 * setting our pm callback */
-	for (i = 0 ; i < NUM_COUNTERS ; ++i) {
-		if (!reset_value[i])
-			continue;
-		CTRL_READ(low, high, msrs, i);
-		CTRL_SET_INACTIVE(low);
-		CTRL_WRITE(low, high, msrs, i);
-	}
-}
-
-static void athlon_shutdown(struct op_msrs const * const msrs)
-{
-	int i;
-
-	for (i = 0 ; i < NUM_COUNTERS ; ++i) {
-		if (CTR_IS_RESERVED(msrs, i))
-			release_perfctr_nmi(MSR_K7_PERFCTR0 + i);
-	}
-	for (i = 0 ; i < NUM_CONTROLS ; ++i) {
-		if (CTRL_IS_RESERVED(msrs, i))
-			release_evntsel_nmi(MSR_K7_EVNTSEL0 + i);
-	}
-}
-
-struct op_x86_model_spec const op_athlon_spec = {
-	.num_counters = NUM_COUNTERS,
-	.num_controls = NUM_CONTROLS,
-	.fill_in_addresses = &athlon_fill_in_addresses,
-	.setup_ctrs = &athlon_setup_ctrs,
-	.check_ctrs = &athlon_check_ctrs,
-	.start = &athlon_start,
-	.stop = &athlon_stop,
-	.shutdown = &athlon_shutdown
-};
diff --git a/arch/x86/oprofile/op_x86_model.h b/arch/x86/oprofile/op_x86_model.h
index 45b605f..05a0261 100644
--- a/arch/x86/oprofile/op_x86_model.h
+++ b/arch/x86/oprofile/op_x86_model.h
@@ -32,6 +32,8 @@ struct pt_regs;
  * various x86 CPU models' perfctr support.
  */
 struct op_x86_model_spec {
+	int (*init)(struct oprofile_operations *ops);
+	void (*exit)(void);
 	unsigned int const num_counters;
 	unsigned int const num_controls;
 	void (*fill_in_addresses)(struct op_msrs * const msrs);
@@ -46,6 +48,6 @@ struct op_x86_model_spec {
 extern struct op_x86_model_spec const op_ppro_spec;
 extern struct op_x86_model_spec const op_p4_spec;
 extern struct op_x86_model_spec const op_p4_ht2_spec;
-extern struct op_x86_model_spec const op_athlon_spec;
+extern struct op_x86_model_spec const op_amd_spec;
 
 #endif /* OP_X86_MODEL_H */
diff --git a/drivers/oprofile/buffer_sync.c b/drivers/oprofile/buffer_sync.c
index 9304c45..ed98227 100644
--- a/drivers/oprofile/buffer_sync.c
+++ b/drivers/oprofile/buffer_sync.c
@@ -5,6 +5,7 @@
  * @remark Read the file COPYING
  *
  * @author John Levon <levon@movementarian.org>
+ * @author Barry Kasindorf
  *
  * This is the core of the buffer management. Each
  * CPU buffer is processed and entered into the
@@ -33,7 +34,7 @@
 #include "event_buffer.h"
 #include "cpu_buffer.h"
 #include "buffer_sync.h"
- 
+
 static LIST_HEAD(dying_tasks);
 static LIST_HEAD(dead_tasks);
 static cpumask_t marked_cpus = CPU_MASK_NONE;
@@ -48,10 +49,11 @@ static void process_task_mortuary(void);
  * Can be invoked from softirq via RCU callback due to
  * call_rcu() of the task struct, hence the _irqsave.
  */
-static int task_free_notify(struct notifier_block * self, unsigned long val, void * data)
+static int
+task_free_notify(struct notifier_block *self, unsigned long val, void *data)
 {
 	unsigned long flags;
-	struct task_struct * task = data;
+	struct task_struct *task = data;
 	spin_lock_irqsave(&task_mortuary, flags);
 	list_add(&task->tasks, &dying_tasks);
 	spin_unlock_irqrestore(&task_mortuary, flags);
@@ -62,13 +64,14 @@ static int task_free_notify(struct notifier_block * self, unsigned long val, voi
 /* The task is on its way out. A sync of the buffer means we can catch
  * any remaining samples for this task.
  */
-static int task_exit_notify(struct notifier_block * self, unsigned long val, void * data)
+static int
+task_exit_notify(struct notifier_block *self, unsigned long val, void *data)
 {
 	/* To avoid latency problems, we only process the current CPU,
 	 * hoping that most samples for the task are on this CPU
 	 */
 	sync_buffer(raw_smp_processor_id());
-  	return 0;
+	return 0;
 }
 
 
@@ -77,11 +80,12 @@ static int task_exit_notify(struct notifier_block * self, unsigned long val, voi
  * we don't lose any. This does not have to be exact, it's a QoI issue
  * only.
  */
-static int munmap_notify(struct notifier_block * self, unsigned long val, void * data)
+static int
+munmap_notify(struct notifier_block *self, unsigned long val, void *data)
 {
 	unsigned long addr = (unsigned long)data;
-	struct mm_struct * mm = current->mm;
-	struct vm_area_struct * mpnt;
+	struct mm_struct *mm = current->mm;
+	struct vm_area_struct *mpnt;
 
 	down_read(&mm->mmap_sem);
 
@@ -99,11 +103,12 @@ static int munmap_notify(struct notifier_block * self, unsigned long val, void *
 	return 0;
 }
 
- 
+
 /* We need to be told about new modules so we don't attribute to a previously
  * loaded module, or drop the samples on the floor.
  */
-static int module_load_notify(struct notifier_block * self, unsigned long val, void * data)
+static int
+module_load_notify(struct notifier_block *self, unsigned long val, void *data)
 {
 #ifdef CONFIG_MODULES
 	if (val != MODULE_STATE_COMING)
@@ -118,7 +123,7 @@ static int module_load_notify(struct notifier_block * self, unsigned long val, v
 	return 0;
 }
 
- 
+
 static struct notifier_block task_free_nb = {
 	.notifier_call	= task_free_notify,
 };
@@ -135,7 +140,7 @@ static struct notifier_block module_load_nb = {
 	.notifier_call = module_load_notify,
 };
 
- 
+
 static void end_sync(void)
 {
 	end_cpu_work();
@@ -208,14 +213,14 @@ static inline unsigned long fast_get_dcookie(struct path *path)
  * not strictly necessary but allows oprofile to associate
  * shared-library samples with particular applications
  */
-static unsigned long get_exec_dcookie(struct mm_struct * mm)
+static unsigned long get_exec_dcookie(struct mm_struct *mm)
 {
 	unsigned long cookie = NO_COOKIE;
-	struct vm_area_struct * vma;
- 
+	struct vm_area_struct *vma;
+
 	if (!mm)
 		goto out;
- 
+
 	for (vma = mm->mmap; vma; vma = vma->vm_next) {
 		if (!vma->vm_file)
 			continue;
@@ -235,13 +240,14 @@ out:
  * sure to do this lookup before a mm->mmap modification happens so
  * we don't lose track.
  */
-static unsigned long lookup_dcookie(struct mm_struct * mm, unsigned long addr, off_t * offset)
+static unsigned long
+lookup_dcookie(struct mm_struct *mm, unsigned long addr, off_t *offset)
 {
 	unsigned long cookie = NO_COOKIE;
-	struct vm_area_struct * vma;
+	struct vm_area_struct *vma;
 
 	for (vma = find_vma(mm, addr); vma; vma = vma->vm_next) {
- 
+
 		if (addr < vma->vm_start || addr >= vma->vm_end)
 			continue;
 
@@ -263,9 +269,20 @@ static unsigned long lookup_dcookie(struct mm_struct * mm, unsigned long addr, o
 	return cookie;
 }
 
+static void increment_tail(struct oprofile_cpu_buffer *b)
+{
+	unsigned long new_tail = b->tail_pos + 1;
+
+	rmb();	/* be sure fifo pointers are synchromized */
+
+	if (new_tail < b->buffer_size)
+		b->tail_pos = new_tail;
+	else
+		b->tail_pos = 0;
+}
 
 static unsigned long last_cookie = INVALID_COOKIE;
- 
+
 static void add_cpu_switch(int i)
 {
 	add_event_entry(ESCAPE_CODE);
@@ -278,16 +295,16 @@ static void add_kernel_ctx_switch(unsigned int in_kernel)
 {
 	add_event_entry(ESCAPE_CODE);
 	if (in_kernel)
-		add_event_entry(KERNEL_ENTER_SWITCH_CODE); 
+		add_event_entry(KERNEL_ENTER_SWITCH_CODE);
 	else
-		add_event_entry(KERNEL_EXIT_SWITCH_CODE); 
+		add_event_entry(KERNEL_EXIT_SWITCH_CODE);
 }
- 
+
 static void
-add_user_ctx_switch(struct task_struct const * task, unsigned long cookie)
+add_user_ctx_switch(struct task_struct const *task, unsigned long cookie)
 {
 	add_event_entry(ESCAPE_CODE);
-	add_event_entry(CTX_SWITCH_CODE); 
+	add_event_entry(CTX_SWITCH_CODE);
 	add_event_entry(task->pid);
 	add_event_entry(cookie);
 	/* Another code for daemon back-compat */
@@ -296,7 +313,7 @@ add_user_ctx_switch(struct task_struct const * task, unsigned long cookie)
 	add_event_entry(task->tgid);
 }
 
- 
+
 static void add_cookie_switch(unsigned long cookie)
 {
 	add_event_entry(ESCAPE_CODE);
@@ -304,13 +321,78 @@ static void add_cookie_switch(unsigned long cookie)
 	add_event_entry(cookie);
 }
 
- 
+
 static void add_trace_begin(void)
 {
 	add_event_entry(ESCAPE_CODE);
 	add_event_entry(TRACE_BEGIN_CODE);
 }
 
+#ifdef CONFIG_OPROFILE_IBS
+
+#define IBS_FETCH_CODE_SIZE	2
+#define IBS_OP_CODE_SIZE	5
+#define IBS_EIP(offset)				\
+	(((struct op_sample *)&cpu_buf->buffer[(offset)])->eip)
+#define IBS_EVENT(offset)				\
+	(((struct op_sample *)&cpu_buf->buffer[(offset)])->event)
+
+/*
+ * Add IBS fetch and op entries to event buffer
+ */
+static void add_ibs_begin(struct oprofile_cpu_buffer *cpu_buf, int code,
+	int in_kernel, struct mm_struct *mm)
+{
+	unsigned long rip;
+	int i, count;
+	unsigned long ibs_cookie = 0;
+	off_t offset;
+
+	increment_tail(cpu_buf);	/* move to RIP entry */
+
+	rip = IBS_EIP(cpu_buf->tail_pos);
+
+#ifdef __LP64__
+	rip += IBS_EVENT(cpu_buf->tail_pos) << 32;
+#endif
+
+	if (mm) {
+		ibs_cookie = lookup_dcookie(mm, rip, &offset);
+
+		if (ibs_cookie == NO_COOKIE)
+			offset = rip;
+		if (ibs_cookie == INVALID_COOKIE) {
+			atomic_inc(&oprofile_stats.sample_lost_no_mapping);
+			offset = rip;
+		}
+		if (ibs_cookie != last_cookie) {
+			add_cookie_switch(ibs_cookie);
+			last_cookie = ibs_cookie;
+		}
+	} else
+		offset = rip;
+
+	add_event_entry(ESCAPE_CODE);
+	add_event_entry(code);
+	add_event_entry(offset);	/* Offset from Dcookie */
+
+	/* we send the Dcookie offset, but send the raw Linear Add also*/
+	add_event_entry(IBS_EIP(cpu_buf->tail_pos));
+	add_event_entry(IBS_EVENT(cpu_buf->tail_pos));
+
+	if (code == IBS_FETCH_CODE)
+		count = IBS_FETCH_CODE_SIZE;	/*IBS FETCH is 2 int64s*/
+	else
+		count = IBS_OP_CODE_SIZE;	/*IBS OP is 5 int64s*/
+
+	for (i = 0; i < count; i++) {
+		increment_tail(cpu_buf);
+		add_event_entry(IBS_EIP(cpu_buf->tail_pos));
+		add_event_entry(IBS_EVENT(cpu_buf->tail_pos));
+	}
+}
+
+#endif
 
 static void add_sample_entry(unsigned long offset, unsigned long event)
 {
@@ -319,13 +401,13 @@ static void add_sample_entry(unsigned long offset, unsigned long event)
 }
 
 
-static int add_us_sample(struct mm_struct * mm, struct op_sample * s)
+static int add_us_sample(struct mm_struct *mm, struct op_sample *s)
 {
 	unsigned long cookie;
 	off_t offset;
- 
- 	cookie = lookup_dcookie(mm, s->eip, &offset);
- 
+
+	cookie = lookup_dcookie(mm, s->eip, &offset);
+
 	if (cookie == INVALID_COOKIE) {
 		atomic_inc(&oprofile_stats.sample_lost_no_mapping);
 		return 0;
@@ -341,13 +423,13 @@ static int add_us_sample(struct mm_struct * mm, struct op_sample * s)
 	return 1;
 }
 
- 
+
 /* Add a sample to the global event buffer. If possible the
  * sample is converted into a persistent dentry/offset pair
  * for later lookup from userspace.
  */
 static int
-add_sample(struct mm_struct * mm, struct op_sample * s, int in_kernel)
+add_sample(struct mm_struct *mm, struct op_sample *s, int in_kernel)
 {
 	if (in_kernel) {
 		add_sample_entry(s->eip, s->event);
@@ -359,9 +441,9 @@ add_sample(struct mm_struct * mm, struct op_sample * s, int in_kernel)
 	}
 	return 0;
 }
- 
 
-static void release_mm(struct mm_struct * mm)
+
+static void release_mm(struct mm_struct *mm)
 {
 	if (!mm)
 		return;
@@ -370,9 +452,9 @@ static void release_mm(struct mm_struct * mm)
 }
 
 
-static struct mm_struct * take_tasks_mm(struct task_struct * task)
+static struct mm_struct *take_tasks_mm(struct task_struct *task)
 {
-	struct mm_struct * mm = get_task_mm(task);
+	struct mm_struct *mm = get_task_mm(task);
 	if (mm)
 		down_read(&mm->mmap_sem);
 	return mm;
@@ -383,10 +465,10 @@ static inline int is_code(unsigned long val)
 {
 	return val == ESCAPE_CODE;
 }
- 
+
 
 /* "acquire" as many cpu buffer slots as we can */
-static unsigned long get_slots(struct oprofile_cpu_buffer * b)
+static unsigned long get_slots(struct oprofile_cpu_buffer *b)
 {
 	unsigned long head = b->head_pos;
 	unsigned long tail = b->tail_pos;
@@ -412,19 +494,6 @@ static unsigned long get_slots(struct oprofile_cpu_buffer * b)
 }
 
 
-static void increment_tail(struct oprofile_cpu_buffer * b)
-{
-	unsigned long new_tail = b->tail_pos + 1;
-
-	rmb();
-
-	if (new_tail < b->buffer_size)
-		b->tail_pos = new_tail;
-	else
-		b->tail_pos = 0;
-}
-
-
 /* Move tasks along towards death. Any tasks on dead_tasks
  * will definitely have no remaining references in any
  * CPU buffers at this point, because we use two lists,
@@ -435,8 +504,8 @@ static void process_task_mortuary(void)
 {
 	unsigned long flags;
 	LIST_HEAD(local_dead_tasks);
-	struct task_struct * task;
-	struct task_struct * ttask;
+	struct task_struct *task;
+	struct task_struct *ttask;
 
 	spin_lock_irqsave(&task_mortuary, flags);
 
@@ -493,7 +562,7 @@ void sync_buffer(int cpu)
 {
 	struct oprofile_cpu_buffer *cpu_buf = &per_cpu(cpu_buffer, cpu);
 	struct mm_struct *mm = NULL;
-	struct task_struct * new;
+	struct task_struct *new;
 	unsigned long cookie = 0;
 	int in_kernel = 1;
 	unsigned int i;
@@ -501,7 +570,7 @@ void sync_buffer(int cpu)
 	unsigned long available;
 
 	mutex_lock(&buffer_mutex);
- 
+
 	add_cpu_switch(cpu);
 
 	/* Remember, only we can modify tail_pos */
@@ -509,8 +578,8 @@ void sync_buffer(int cpu)
 	available = get_slots(cpu_buf);
 
 	for (i = 0; i < available; ++i) {
-		struct op_sample * s = &cpu_buf->buffer[cpu_buf->tail_pos];
- 
+		struct op_sample *s = &cpu_buf->buffer[cpu_buf->tail_pos];
+
 		if (is_code(s->eip)) {
 			if (s->event <= CPU_IS_KERNEL) {
 				/* kernel/userspace switch */
@@ -521,8 +590,18 @@ void sync_buffer(int cpu)
 			} else if (s->event == CPU_TRACE_BEGIN) {
 				state = sb_bt_start;
 				add_trace_begin();
+#ifdef CONFIG_OPROFILE_IBS
+			} else if (s->event == IBS_FETCH_BEGIN) {
+				state = sb_bt_start;
+				add_ibs_begin(cpu_buf,
+					IBS_FETCH_CODE, in_kernel, mm);
+			} else if (s->event == IBS_OP_BEGIN) {
+				state = sb_bt_start;
+				add_ibs_begin(cpu_buf,
+					IBS_OP_CODE, in_kernel, mm);
+#endif
 			} else {
-				struct mm_struct * oldmm = mm;
+				struct mm_struct *oldmm = mm;
 
 				/* userspace context switch */
 				new = (struct task_struct *)s->event;
@@ -533,13 +612,11 @@ void sync_buffer(int cpu)
 					cookie = get_exec_dcookie(mm);
 				add_user_ctx_switch(new, cookie);
 			}
-		} else {
-			if (state >= sb_bt_start &&
-			    !add_sample(mm, s, in_kernel)) {
-				if (state == sb_bt_start) {
-					state = sb_bt_ignore;
-					atomic_inc(&oprofile_stats.bt_lost_no_mapping);
-				}
+		} else if (state >= sb_bt_start &&
+			   !add_sample(mm, s, in_kernel)) {
+			if (state == sb_bt_start) {
+				state = sb_bt_ignore;
+				atomic_inc(&oprofile_stats.bt_lost_no_mapping);
 			}
 		}
 
diff --git a/drivers/oprofile/cpu_buffer.c b/drivers/oprofile/cpu_buffer.c
index 7ba78e6..e1bd5a9 100644
--- a/drivers/oprofile/cpu_buffer.c
+++ b/drivers/oprofile/cpu_buffer.c
@@ -5,6 +5,7 @@
  * @remark Read the file COPYING
  *
  * @author John Levon <levon@movementarian.org>
+ * @author Barry Kasindorf <barry.kasindorf@amd.com>
  *
  * Each CPU has a local buffer that stores PC value/event
  * pairs. We also log context switches when we notice them.
@@ -209,7 +210,7 @@ static int log_sample(struct oprofile_cpu_buffer * cpu_buf, unsigned long pc,
 	return 1;
 }
 
-static int oprofile_begin_trace(struct oprofile_cpu_buffer * cpu_buf)
+static int oprofile_begin_trace(struct oprofile_cpu_buffer *cpu_buf)
 {
 	if (nr_available_slots(cpu_buf) < 4) {
 		cpu_buf->sample_lost_overflow++;
@@ -254,6 +255,75 @@ void oprofile_add_sample(struct pt_regs * const regs, unsigned long event)
 	oprofile_add_ext_sample(pc, regs, event, is_kernel);
 }
 
+#ifdef CONFIG_OPROFILE_IBS
+
+#define MAX_IBS_SAMPLE_SIZE	14
+static int log_ibs_sample(struct oprofile_cpu_buffer *cpu_buf,
+	unsigned long pc, int is_kernel, unsigned  int *ibs, int ibs_code)
+{
+	struct task_struct *task;
+
+	cpu_buf->sample_received++;
+
+	if (nr_available_slots(cpu_buf) < MAX_IBS_SAMPLE_SIZE) {
+		cpu_buf->sample_lost_overflow++;
+		return 0;
+	}
+
+	is_kernel = !!is_kernel;
+
+	/* notice a switch from user->kernel or vice versa */
+	if (cpu_buf->last_is_kernel != is_kernel) {
+		cpu_buf->last_is_kernel = is_kernel;
+		add_code(cpu_buf, is_kernel);
+	}
+
+	/* notice a task switch */
+	if (!is_kernel) {
+		task = current;
+
+		if (cpu_buf->last_task != task) {
+			cpu_buf->last_task = task;
+			add_code(cpu_buf, (unsigned long)task);
+		}
+	}
+
+	add_code(cpu_buf, ibs_code);
+	add_sample(cpu_buf, ibs[0], ibs[1]);
+	add_sample(cpu_buf, ibs[2], ibs[3]);
+	add_sample(cpu_buf, ibs[4], ibs[5]);
+
+	if (ibs_code == IBS_OP_BEGIN) {
+	add_sample(cpu_buf, ibs[6], ibs[7]);
+	add_sample(cpu_buf, ibs[8], ibs[9]);
+	add_sample(cpu_buf, ibs[10], ibs[11]);
+	}
+
+	return 1;
+}
+
+void oprofile_add_ibs_sample(struct pt_regs *const regs,
+				unsigned int * const ibs_sample, u8 code)
+{
+	int is_kernel = !user_mode(regs);
+	unsigned long pc = profile_pc(regs);
+
+	struct oprofile_cpu_buffer *cpu_buf =
+			 &per_cpu(cpu_buffer, smp_processor_id());
+
+	if (!backtrace_depth) {
+		log_ibs_sample(cpu_buf, pc, is_kernel, ibs_sample, code);
+		return;
+	}
+
+	/* if log_sample() fails we can't backtrace since we lost the source
+	* of this event */
+	if (log_ibs_sample(cpu_buf, pc, is_kernel, ibs_sample, code))
+		oprofile_ops.backtrace(regs, backtrace_depth);
+}
+
+#endif
+
 void oprofile_add_pc(unsigned long pc, int is_kernel, unsigned long event)
 {
 	struct oprofile_cpu_buffer *cpu_buf = &__get_cpu_var(cpu_buffer);
@@ -296,7 +366,7 @@ static void wq_sync_buffer(struct work_struct *work)
 	struct oprofile_cpu_buffer * b =
 		container_of(work, struct oprofile_cpu_buffer, work.work);
 	if (b->cpu != smp_processor_id()) {
-		printk("WQ on CPU%d, prefer CPU%d\n",
+		printk(KERN_DEBUG "WQ on CPU%d, prefer CPU%d\n",
 		       smp_processor_id(), b->cpu);
 	}
 	sync_buffer(b->cpu);
diff --git a/drivers/oprofile/cpu_buffer.h b/drivers/oprofile/cpu_buffer.h
index c3e366b..9c44d00 100644
--- a/drivers/oprofile/cpu_buffer.h
+++ b/drivers/oprofile/cpu_buffer.h
@@ -55,5 +55,7 @@ void cpu_buffer_reset(struct oprofile_cpu_buffer * cpu_buf);
 /* transient events for the CPU buffer -> event buffer */
 #define CPU_IS_KERNEL 1
 #define CPU_TRACE_BEGIN 2
+#define IBS_FETCH_BEGIN 3
+#define IBS_OP_BEGIN    4
 
 #endif /* OPROFILE_CPU_BUFFER_H */
diff --git a/include/linux/oprofile.h b/include/linux/oprofile.h
index 041bb31..bcb8f72 100644
--- a/include/linux/oprofile.h
+++ b/include/linux/oprofile.h
@@ -36,6 +36,8 @@
 #define XEN_ENTER_SWITCH_CODE		10
 #define SPU_PROFILING_CODE		11
 #define SPU_CTX_SWITCH_CODE		12
+#define IBS_FETCH_CODE			13
+#define IBS_OP_CODE			14
 
 struct super_block;
 struct dentry;
