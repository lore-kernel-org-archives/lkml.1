Return-Path: <linux-kernel-owner+w=401wt.eu-S1756599AbYJFXM5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756599AbYJFXM5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 19:12:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754662AbYJFXL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 19:11:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:58227 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754149AbYJFXLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 19:11:53 -0400
Message-Id: <20081006231149.238719380@goodmis.org>
References: <20081006230610.024517480@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 06 Oct 2008 19:06:12 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 2/3] ftrace: rename FTRACE to FUNCTION_TRACER
Content-Disposition: inline; filename=ftrace-rename-function-tracer.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to confusion between the ftrace infrastructure and the gcc profiling
tracer "ftrace", this patch renames the config options from FTRACE to
FUNCTION_TRACER.  The other two names that are offspring from FTRACE
DYNAMIC_FTRACE and FTRACE_MCOUNT_RECORD will stay the same.

This patch was generated mostly by script, and partially by hand.
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 Makefile                                          |    2 +-
 arch/arm/Kconfig                                  |    4 ++--
 arch/arm/boot/compressed/Makefile                 |    2 +-
 arch/arm/configs/eseries_pxa_defconfig            |    4 ++--
 arch/arm/configs/orion5x_defconfig                |    4 ++--
 arch/arm/include/asm/ftrace.h                     |    2 +-
 arch/arm/kernel/armksyms.c                        |    2 +-
 arch/arm/kernel/entry-common.S                    |    4 ++--
 arch/powerpc/Kconfig                              |    2 +-
 arch/powerpc/Makefile                             |    2 +-
 arch/powerpc/configs/40x/ep405_defconfig          |    4 ++--
 arch/powerpc/configs/40x/kilauea_defconfig        |    4 ++--
 arch/powerpc/configs/40x/makalu_defconfig         |    4 ++--
 arch/powerpc/configs/40x/walnut_defconfig         |    4 ++--
 arch/powerpc/configs/44x/bamboo_defconfig         |    4 ++--
 arch/powerpc/configs/44x/canyonlands_defconfig    |    4 ++--
 arch/powerpc/configs/44x/ebony_defconfig          |    4 ++--
 arch/powerpc/configs/44x/katmai_defconfig         |    4 ++--
 arch/powerpc/configs/44x/rainier_defconfig        |    4 ++--
 arch/powerpc/configs/44x/sam440ep_defconfig       |    4 ++--
 arch/powerpc/configs/44x/sequoia_defconfig        |    4 ++--
 arch/powerpc/configs/44x/taishan_defconfig        |    4 ++--
 arch/powerpc/configs/44x/virtex5_defconfig        |    4 ++--
 arch/powerpc/configs/44x/warp_defconfig           |    4 ++--
 arch/powerpc/configs/83xx/asp8347_defconfig       |    4 ++--
 arch/powerpc/configs/83xx/mpc8313_rdb_defconfig   |    4 ++--
 arch/powerpc/configs/83xx/mpc8315_rdb_defconfig   |    4 ++--
 arch/powerpc/configs/83xx/mpc832x_mds_defconfig   |    4 ++--
 arch/powerpc/configs/83xx/mpc832x_rdb_defconfig   |    4 ++--
 arch/powerpc/configs/83xx/mpc834x_itx_defconfig   |    4 ++--
 arch/powerpc/configs/83xx/mpc834x_itxgp_defconfig |    4 ++--
 arch/powerpc/configs/83xx/mpc834x_mds_defconfig   |    4 ++--
 arch/powerpc/configs/83xx/mpc836x_mds_defconfig   |    4 ++--
 arch/powerpc/configs/83xx/mpc836x_rdk_defconfig   |    4 ++--
 arch/powerpc/configs/83xx/mpc837x_mds_defconfig   |    4 ++--
 arch/powerpc/configs/83xx/mpc837x_rdb_defconfig   |    4 ++--
 arch/powerpc/configs/83xx/sbc834x_defconfig       |    4 ++--
 arch/powerpc/configs/85xx/ksi8560_defconfig       |    4 ++--
 arch/powerpc/configs/85xx/mpc8536_ds_defconfig    |    4 ++--
 arch/powerpc/configs/85xx/mpc8540_ads_defconfig   |    4 ++--
 arch/powerpc/configs/85xx/mpc8544_ds_defconfig    |    4 ++--
 arch/powerpc/configs/85xx/mpc8560_ads_defconfig   |    4 ++--
 arch/powerpc/configs/85xx/mpc8568mds_defconfig    |    4 ++--
 arch/powerpc/configs/85xx/mpc8572_ds_defconfig    |    4 ++--
 arch/powerpc/configs/85xx/mpc85xx_cds_defconfig   |    4 ++--
 arch/powerpc/configs/85xx/sbc8548_defconfig       |    4 ++--
 arch/powerpc/configs/85xx/sbc8560_defconfig       |    4 ++--
 arch/powerpc/configs/85xx/stx_gp3_defconfig       |    4 ++--
 arch/powerpc/configs/85xx/tqm8540_defconfig       |    4 ++--
 arch/powerpc/configs/85xx/tqm8541_defconfig       |    4 ++--
 arch/powerpc/configs/85xx/tqm8548_defconfig       |    4 ++--
 arch/powerpc/configs/85xx/tqm8555_defconfig       |    4 ++--
 arch/powerpc/configs/85xx/tqm8560_defconfig       |    4 ++--
 arch/powerpc/configs/adder875_defconfig           |    4 ++--
 arch/powerpc/configs/c2k_defconfig                |    4 ++--
 arch/powerpc/configs/chrp32_defconfig             |    4 ++--
 arch/powerpc/configs/ep8248e_defconfig            |    4 ++--
 arch/powerpc/configs/ep88xc_defconfig             |    4 ++--
 arch/powerpc/configs/g5_defconfig                 |    4 ++--
 arch/powerpc/configs/iseries_defconfig            |    4 ++--
 arch/powerpc/configs/linkstation_defconfig        |    4 ++--
 arch/powerpc/configs/maple_defconfig              |    4 ++--
 arch/powerpc/configs/mpc7448_hpc2_defconfig       |    4 ++--
 arch/powerpc/configs/mpc8272_ads_defconfig        |    4 ++--
 arch/powerpc/configs/mpc83xx_defconfig            |    4 ++--
 arch/powerpc/configs/mpc85xx_defconfig            |    4 ++--
 arch/powerpc/configs/mpc8610_hpcd_defconfig       |    4 ++--
 arch/powerpc/configs/mpc8641_hpcn_defconfig       |    4 ++--
 arch/powerpc/configs/mpc866_ads_defconfig         |    4 ++--
 arch/powerpc/configs/mpc885_ads_defconfig         |    4 ++--
 arch/powerpc/configs/pmac32_defconfig             |    4 ++--
 arch/powerpc/configs/ppc40x_defconfig             |    4 ++--
 arch/powerpc/configs/ppc44x_defconfig             |    4 ++--
 arch/powerpc/configs/ppc64_defconfig              |    4 ++--
 arch/powerpc/configs/ppc6xx_defconfig             |    4 ++--
 arch/powerpc/configs/pq2fads_defconfig            |    4 ++--
 arch/powerpc/configs/prpmc2800_defconfig          |    4 ++--
 arch/powerpc/configs/ps3_defconfig                |    4 ++--
 arch/powerpc/configs/pseries_defconfig            |    4 ++--
 arch/powerpc/configs/sbc8641d_defconfig           |    4 ++--
 arch/powerpc/configs/storcenter_defconfig         |    4 ++--
 arch/powerpc/include/asm/ftrace.h                 |    2 +-
 arch/powerpc/kernel/Makefile                      |    2 +-
 arch/powerpc/kernel/entry_32.S                    |    2 +-
 arch/powerpc/kernel/entry_64.S                    |    2 +-
 arch/powerpc/kernel/ppc_ksyms.c                   |    2 +-
 arch/powerpc/platforms/powermac/Makefile          |    2 +-
 arch/sparc64/Kconfig                              |    2 +-
 arch/sparc64/Kconfig.debug                        |    2 +-
 arch/sparc64/defconfig                            |    4 ++--
 arch/sparc64/lib/mcount.S                         |    4 ++--
 arch/x86/Kconfig                                  |    2 +-
 arch/x86/configs/i386_defconfig                   |    4 ++--
 arch/x86/configs/x86_64_defconfig                 |    4 ++--
 arch/x86/kernel/Makefile                          |    2 +-
 arch/x86/kernel/entry_32.S                        |    4 ++--
 arch/x86/kernel/entry_64.S                        |    4 ++--
 arch/x86/kernel/i386_ksyms_32.c                   |    2 +-
 arch/x86/kernel/x8664_ksyms_64.c                  |    2 +-
 arch/x86/xen/Makefile                             |    2 +-
 include/asm-x86/ftrace.h                          |    4 ++--
 include/linux/ftrace.h                            |   12 ++++++------
 kernel/Makefile                                   |    4 ++--
 kernel/sysctl.c                                   |    2 +-
 kernel/trace/Kconfig                              |   17 +++++++++--------
 kernel/trace/Makefile                             |    6 +++---
 kernel/trace/trace.c                              |    2 +-
 kernel/trace/trace.h                              |    2 +-
 kernel/trace/trace_irqsoff.c                      |    4 ++--
 kernel/trace/trace_sched_wakeup.c                 |    4 ++--
 kernel/trace/trace_selftest.c                     |    4 ++--
 lib/Makefile                                      |    2 +-
 112 files changed, 213 insertions(+), 212 deletions(-)

Index: linux-tip.git/kernel/trace/Kconfig
===================================================================
--- linux-tip.git.orig/kernel/trace/Kconfig	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/kernel/trace/Kconfig	2008-10-06 18:51:09.000000000 -0400
@@ -1,11 +1,12 @@
 #
-# Architectures that offer an FTRACE implementation should select HAVE_FTRACE:
+# Architectures that offer an FUNCTION_TRACER implementation should
+#  select HAVE_FUNCTION_TRACER:
 #
 
 config NOP_TRACER
 	bool
 
-config HAVE_FTRACE
+config HAVE_FUNCTION_TRACER
 	bool
 	select NOP_TRACER
 
@@ -28,9 +29,9 @@ config TRACING
 	select STACKTRACE
 	select TRACEPOINTS
 
-config FTRACE
+config FUNCTION_TRACER
 	bool "Kernel Function Tracer"
-	depends on HAVE_FTRACE
+	depends on HAVE_FUNCTION_TRACER
 	depends on DEBUG_KERNEL
 	select FRAME_POINTER
 	select TRACING
@@ -131,9 +132,9 @@ config BOOT_TRACER
 
 config STACK_TRACER
 	bool "Trace max stack"
-	depends on HAVE_FTRACE
+	depends on HAVE_FUNCTION_TRACER
 	depends on DEBUG_KERNEL
-	select FTRACE
+	select FUNCTION_TRACER
 	select STACKTRACE
 	help
 	  This tracer records the max stack of the kernel, and displays
@@ -141,7 +142,7 @@ config STACK_TRACER
 
 config DYNAMIC_FTRACE
 	bool "enable/disable ftrace tracepoints dynamically"
-	depends on FTRACE
+	depends on FUNCTION_TRACER
 	depends on HAVE_DYNAMIC_FTRACE
 	depends on DEBUG_KERNEL
 	default y
@@ -151,7 +152,7 @@ config DYNAMIC_FTRACE
 	 with a No-Op instruction) as they are called. A table is
 	 created to dynamically enable them again.
 
-	 This way a CONFIG_FTRACE kernel is slightly larger, but otherwise
+	 This way a CONFIG_FUNCTION_TRACER kernel is slightly larger, but otherwise
 	 has native performance as long as no tracing is active.
 
 	 The changes to the code are done by a kernel thread that
Index: linux-tip.git/kernel/trace/Makefile
===================================================================
--- linux-tip.git.orig/kernel/trace/Makefile	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/kernel/trace/Makefile	2008-10-06 18:51:09.000000000 -0400
@@ -1,7 +1,7 @@
 
 # Do not instrument the tracer itself:
 
-ifdef CONFIG_FTRACE
+ifdef CONFIG_FUNCTION_TRACER
 ORIG_CFLAGS := $(KBUILD_CFLAGS)
 KBUILD_CFLAGS = $(subst -pg,,$(ORIG_CFLAGS))
 
@@ -10,13 +10,13 @@ CFLAGS_trace_selftest_dynamic.o = -pg
 obj-y += trace_selftest_dynamic.o
 endif
 
-obj-$(CONFIG_FTRACE) += libftrace.o
+obj-$(CONFIG_FUNCTION_TRACER) += libftrace.o
 obj-$(CONFIG_RING_BUFFER) += ring_buffer.o
 
 obj-$(CONFIG_TRACING) += trace.o
 obj-$(CONFIG_CONTEXT_SWITCH_TRACER) += trace_sched_switch.o
 obj-$(CONFIG_SYSPROF_TRACER) += trace_sysprof.o
-obj-$(CONFIG_FTRACE) += trace_functions.o
+obj-$(CONFIG_FUNCTION_TRACER) += trace_functions.o
 obj-$(CONFIG_IRQSOFF_TRACER) += trace_irqsoff.o
 obj-$(CONFIG_PREEMPT_TRACER) += trace_irqsoff.o
 obj-$(CONFIG_SCHED_TRACER) += trace_sched_wakeup.o
Index: linux-tip.git/Makefile
===================================================================
--- linux-tip.git.orig/Makefile	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/Makefile	2008-10-06 18:51:09.000000000 -0400
@@ -536,7 +536,7 @@ KBUILD_CFLAGS	+= -g
 KBUILD_AFLAGS	+= -gdwarf-2
 endif
 
-ifdef CONFIG_FTRACE
+ifdef CONFIG_FUNCTION_TRACER
 KBUILD_CFLAGS	+= -pg
 endif
 
Index: linux-tip.git/arch/arm/kernel/entry-common.S
===================================================================
--- linux-tip.git.orig/arch/arm/kernel/entry-common.S	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/arm/kernel/entry-common.S	2008-10-06 18:51:09.000000000 -0400
@@ -100,7 +100,7 @@ ENTRY(ret_from_fork)
 #undef CALL
 #define CALL(x) .long x
 
-#ifdef CONFIG_FTRACE
+#ifdef CONFIG_FUNCTION_TRACER
 #ifdef CONFIG_DYNAMIC_FTRACE
 ENTRY(mcount)
 	stmdb sp!, {r0-r3, lr}
@@ -148,7 +148,7 @@ trace:
 ftrace_stub:
 	mov pc, lr
 
-#endif /* CONFIG_FTRACE */
+#endif /* CONFIG_FUNCTION_TRACER */
 
 /*=============================================================================
  * SWI handler
Index: linux-tip.git/arch/arm/Kconfig
===================================================================
--- linux-tip.git.orig/arch/arm/Kconfig	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/arm/Kconfig	2008-10-06 18:51:09.000000000 -0400
@@ -15,8 +15,8 @@ config ARM
 	select HAVE_ARCH_KGDB
 	select HAVE_KPROBES if (!XIP_KERNEL)
 	select HAVE_KRETPROBES if (HAVE_KPROBES)
-	select HAVE_FTRACE if (!XIP_KERNEL)
-	select HAVE_DYNAMIC_FTRACE if (HAVE_FTRACE)
+	select HAVE_FUNCTION_TRACER if (!XIP_KERNEL)
+	select HAVE_DYNAMIC_FTRACE if (HAVE_FUNCTION_TRACER)
 	select HAVE_GENERIC_DMA_COHERENT
 	help
 	  The ARM series is a line of low-power-consumption RISC chip designs
Index: linux-tip.git/arch/arm/boot/compressed/Makefile
===================================================================
--- linux-tip.git.orig/arch/arm/boot/compressed/Makefile	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/arm/boot/compressed/Makefile	2008-10-06 18:51:09.000000000 -0400
@@ -70,7 +70,7 @@ SEDFLAGS	= s/TEXT_START/$(ZTEXTADDR)/;s/
 targets       := vmlinux vmlinux.lds piggy.gz piggy.o font.o font.c \
 		 head.o misc.o $(OBJS)
 
-ifeq ($(CONFIG_FTRACE),y)
+ifeq ($(CONFIG_FUNCTION_TRACER),y)
 ORIG_CFLAGS := $(KBUILD_CFLAGS)
 KBUILD_CFLAGS = $(subst -pg, , $(ORIG_CFLAGS))
 endif
Index: linux-tip.git/arch/arm/configs/eseries_pxa_defconfig
===================================================================
--- linux-tip.git.orig/arch/arm/configs/eseries_pxa_defconfig	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/arm/configs/eseries_pxa_defconfig	2008-10-06 18:51:09.000000000 -0400
@@ -1229,9 +1229,9 @@ CONFIG_FRAME_WARN=1024
 # CONFIG_DEBUG_MEMORY_INIT is not set
 CONFIG_FRAME_POINTER=y
 # CONFIG_LATENCYTOP is not set
-CONFIG_HAVE_FTRACE=y
+CONFIG_HAVE_FUNCTION_TRACER=y
 CONFIG_HAVE_DYNAMIC_FTRACE=y
-# CONFIG_FTRACE is not set
+# CONFIG_FUNCTION_TRACER is not set
 # CONFIG_IRQSOFF_TRACER is not set
 # CONFIG_SCHED_TRACER is not set
 # CONFIG_CONTEXT_SWITCH_TRACER is not set
Index: linux-tip.git/arch/arm/configs/orion5x_defconfig
===================================================================
--- linux-tip.git.orig/arch/arm/configs/orion5x_defconfig	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/arm/configs/orion5x_defconfig	2008-10-06 18:51:09.000000000 -0400
@@ -1417,9 +1417,9 @@ CONFIG_FRAME_POINTER=y
 # CONFIG_FAULT_INJECTION is not set
 CONFIG_LATENCYTOP=y
 CONFIG_SYSCTL_SYSCALL_CHECK=y
-CONFIG_HAVE_FTRACE=y
+CONFIG_HAVE_FUNCTION_TRACER=y
 CONFIG_HAVE_DYNAMIC_FTRACE=y
-# CONFIG_FTRACE is not set
+# CONFIG_FUNCTION_TRACER is not set
 # CONFIG_IRQSOFF_TRACER is not set
 # CONFIG_PREEMPT_TRACER is not set
 # CONFIG_SCHED_TRACER is not set
Index: linux-tip.git/arch/arm/include/asm/ftrace.h
===================================================================
--- linux-tip.git.orig/arch/arm/include/asm/ftrace.h	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/arm/include/asm/ftrace.h	2008-10-06 18:51:09.000000000 -0400
@@ -1,7 +1,7 @@
 #ifndef _ASM_ARM_FTRACE
 #define _ASM_ARM_FTRACE
 
-#ifdef CONFIG_FTRACE
+#ifdef CONFIG_FUNCTION_TRACER
 #define MCOUNT_ADDR		((long)(mcount))
 #define MCOUNT_INSN_SIZE	4 /* sizeof mcount call */
 
Index: linux-tip.git/arch/arm/kernel/armksyms.c
===================================================================
--- linux-tip.git.orig/arch/arm/kernel/armksyms.c	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/arm/kernel/armksyms.c	2008-10-06 18:51:09.000000000 -0400
@@ -183,6 +183,6 @@ EXPORT_SYMBOL(_find_next_bit_be);
 
 EXPORT_SYMBOL(copy_page);
 
-#ifdef CONFIG_FTRACE
+#ifdef CONFIG_FUNCTION_TRACER
 EXPORT_SYMBOL(mcount);
 #endif
Index: linux-tip.git/arch/powerpc/kernel/entry_32.S
===================================================================
--- linux-tip.git.orig/arch/powerpc/kernel/entry_32.S	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/powerpc/kernel/entry_32.S	2008-10-06 18:51:09.000000000 -0400
@@ -1158,7 +1158,7 @@ machine_check_in_rtas:
 
 #endif /* CONFIG_PPC_RTAS */
 
-#ifdef CONFIG_FTRACE
+#ifdef CONFIG_FUNCTION_TRACER
 #ifdef CONFIG_DYNAMIC_FTRACE
 _GLOBAL(mcount)
 _GLOBAL(_mcount)
Index: linux-tip.git/arch/powerpc/kernel/entry_64.S
===================================================================
--- linux-tip.git.orig/arch/powerpc/kernel/entry_64.S	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/powerpc/kernel/entry_64.S	2008-10-06 18:51:09.000000000 -0400
@@ -881,7 +881,7 @@ _GLOBAL(enter_prom)
 	mtlr    r0
         blr
 
-#ifdef CONFIG_FTRACE
+#ifdef CONFIG_FUNCTION_TRACER
 #ifdef CONFIG_DYNAMIC_FTRACE
 _GLOBAL(mcount)
 _GLOBAL(_mcount)
Index: linux-tip.git/arch/powerpc/Kconfig
===================================================================
--- linux-tip.git.orig/arch/powerpc/Kconfig	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/powerpc/Kconfig	2008-10-06 18:51:09.000000000 -0400
@@ -112,7 +112,7 @@ config PPC
 	bool
 	default y
 	select HAVE_DYNAMIC_FTRACE
-	select HAVE_FTRACE
+	select HAVE_FUNCTION_TRACER
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select HAVE_IDE
 	select HAVE_IOREMAP_PROT
Index: linux-tip.git/arch/powerpc/configs/40x/ep405_defconfig
===================================================================
--- linux-tip.git.orig/arch/powerpc/configs/40x/ep405_defconfig	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/powerpc/configs/40x/ep405_defconfig	2008-10-06 18:51:09.000000000 -0400
@@ -941,9 +941,9 @@ CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_BACKTRACE_SELF_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_LATENCYTOP is not set
-CONFIG_HAVE_FTRACE=y
+CONFIG_HAVE_FUNCTION_TRACER=y
 CONFIG_HAVE_DYNAMIC_FTRACE=y
-# CONFIG_FTRACE is not set
+# CONFIG_FUNCTION_TRACER is not set
 # CONFIG_SCHED_TRACER is not set
 # CONFIG_CONTEXT_SWITCH_TRACER is not set
 # CONFIG_SAMPLES is not set
Index: linux-tip.git/arch/powerpc/configs/40x/kilauea_defconfig
===================================================================
--- linux-tip.git.orig/arch/powerpc/configs/40x/kilauea_defconfig	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/powerpc/configs/40x/kilauea_defconfig	2008-10-06 18:51:09.000000000 -0400
@@ -805,9 +805,9 @@ CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_BACKTRACE_SELF_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_LATENCYTOP is not set
-CONFIG_HAVE_FTRACE=y
+CONFIG_HAVE_FUNCTION_TRACER=y
 CONFIG_HAVE_DYNAMIC_FTRACE=y
-# CONFIG_FTRACE is not set
+# CONFIG_FUNCTION_TRACER is not set
 # CONFIG_SCHED_TRACER is not set
 # CONFIG_CONTEXT_SWITCH_TRACER is not set
 # CONFIG_SAMPLES is not set
Index: linux-tip.git/arch/powerpc/configs/40x/makalu_defconfig
===================================================================
--- linux-tip.git.orig/arch/powerpc/configs/40x/makalu_defconfig	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/powerpc/configs/40x/makalu_defconfig	2008-10-06 18:51:09.000000000 -0400
@@ -805,9 +805,9 @@ CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_BACKTRACE_SELF_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_LATENCYTOP is not set
-CONFIG_HAVE_FTRACE=y
+CONFIG_HAVE_FUNCTION_TRACER=y
 CONFIG_HAVE_DYNAMIC_FTRACE=y
-# CONFIG_FTRACE is not set
+# CONFIG_FUNCTION_TRACER is not set
 # CONFIG_SCHED_TRACER is not set
 # CONFIG_CONTEXT_SWITCH_TRACER is not set
 # CONFIG_SAMPLES is not set
Index: linux-tip.git/arch/powerpc/configs/40x/walnut_defconfig
===================================================================
--- linux-tip.git.orig/arch/powerpc/configs/40x/walnut_defconfig	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/powerpc/configs/40x/walnut_defconfig	2008-10-06 18:51:09.000000000 -0400
@@ -856,9 +856,9 @@ CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_BACKTRACE_SELF_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_LATENCYTOP is not set
-CONFIG_HAVE_FTRACE=y
+CONFIG_HAVE_FUNCTION_TRACER=y
 CONFIG_HAVE_DYNAMIC_FTRACE=y
-# CONFIG_FTRACE is not set
+# CONFIG_FUNCTION_TRACER is not set
 # CONFIG_SCHED_TRACER is not set
 # CONFIG_CONTEXT_SWITCH_TRACER is not set
 # CONFIG_SAMPLES is not set
Index: linux-tip.git/arch/powerpc/configs/44x/bamboo_defconfig
===================================================================
--- linux-tip.git.orig/arch/powerpc/configs/44x/bamboo_defconfig	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/powerpc/configs/44x/bamboo_defconfig	2008-10-06 18:51:09.000000000 -0400
@@ -785,9 +785,9 @@ CONFIG_SCHED_DEBUG=y
 # CONFIG_BACKTRACE_SELF_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_LATENCYTOP is not set
-CONFIG_HAVE_FTRACE=y
+CONFIG_HAVE_FUNCTION_TRACER=y
 CONFIG_HAVE_DYNAMIC_FTRACE=y
-# CONFIG_FTRACE is not set
+# CONFIG_FUNCTION_TRACER is not set
 # CONFIG_SCHED_TRACER is not set
 # CONFIG_CONTEXT_SWITCH_TRACER is not set
 # CONFIG_SAMPLES is not set
Index: linux-tip.git/arch/powerpc/configs/44x/canyonlands_defconfig
===================================================================
--- linux-tip.git.orig/arch/powerpc/configs/44x/canyonlands_defconfig	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/powerpc/configs/44x/canyonlands_defconfig	2008-10-06 18:51:09.000000000 -0400
@@ -733,9 +733,9 @@ CONFIG_SCHED_DEBUG=y
 # CONFIG_BACKTRACE_SELF_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_LATENCYTOP is not set
-CONFIG_HAVE_FTRACE=y
+CONFIG_HAVE_FUNCTION_TRACER=y
 CONFIG_HAVE_DYNAMIC_FTRACE=y
-# CONFIG_FTRACE is not set
+# CONFIG_FUNCTION_TRACER is not set
 # CONFIG_SCHED_TRACER is not set
 # CONFIG_CONTEXT_SWITCH_TRACER is not set
 # CONFIG_SAMPLES is not set
Index: linux-tip.git/arch/powerpc/configs/44x/ebony_defconfig
===================================================================
--- linux-tip.git.orig/arch/powerpc/configs/44x/ebony_defconfig	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/powerpc/configs/44x/ebony_defconfig	2008-10-06 18:51:09.000000000 -0400
@@ -872,9 +872,9 @@ CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_BACKTRACE_SELF_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_LATENCYTOP is not set
-CONFIG_HAVE_FTRACE=y
+CONFIG_HAVE_FUNCTION_TRACER=y
 CONFIG_HAVE_DYNAMIC_FTRACE=y
-# CONFIG_FTRACE is not set
+# CONFIG_FUNCTION_TRACER is not set
 # CONFIG_SCHED_TRACER is not set
 # CONFIG_CONTEXT_SWITCH_TRACER is not set
 # CONFIG_SAMPLES is not set
Index: linux-tip.git/arch/powerpc/configs/44x/katmai_defconfig
===================================================================
--- linux-tip.git.orig/arch/powerpc/configs/44x/katmai_defconfig	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/powerpc/configs/44x/katmai_defconfig	2008-10-06 18:51:09.000000000 -0400
@@ -782,9 +782,9 @@ CONFIG_SCHED_DEBUG=y
 # CONFIG_BACKTRACE_SELF_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_LATENCYTOP is not set
-CONFIG_HAVE_FTRACE=y
+CONFIG_HAVE_FUNCTION_TRACER=y
 CONFIG_HAVE_DYNAMIC_FTRACE=y
-# CONFIG_FTRACE is not set
+# CONFIG_FUNCTION_TRACER is not set
 # CONFIG_SCHED_TRACER is not set
 # CONFIG_CONTEXT_SWITCH_TRACER is not set
 # CONFIG_SAMPLES is not set
Index: linux-tip.git/arch/powerpc/configs/44x/rainier_defconfig
===================================================================
--- linux-tip.git.orig/arch/powerpc/configs/44x/rainier_defconfig	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/powerpc/configs/44x/rainier_defconfig	2008-10-06 18:51:09.000000000 -0400
@@ -857,9 +857,9 @@ CONFIG_SCHED_DEBUG=y
 # CONFIG_BACKTRACE_SELF_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_LATENCYTOP is not set
-CONFIG_HAVE_FTRACE=y
+CONFIG_HAVE_FUNCTION_TRACER=y
 CONFIG_HAVE_DYNAMIC_FTRACE=y
-# CONFIG_FTRACE is not set
+# CONFIG_FUNCTION_TRACER is not set
 # CONFIG_SCHED_TRACER is not set
 # CONFIG_CONTEXT_SWITCH_TRACER is not set
 # CONFIG_SAMPLES is not set
Index: linux-tip.git/arch/powerpc/configs/44x/sam440ep_defconfig
===================================================================
--- linux-tip.git.orig/arch/powerpc/configs/44x/sam440ep_defconfig	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/powerpc/configs/44x/sam440ep_defconfig	2008-10-06 18:51:09.000000000 -0400
@@ -1228,9 +1228,9 @@ CONFIG_MAGIC_SYSRQ=y
 # CONFIG_DEBUG_BUGVERBOSE is not set
 # CONFIG_DEBUG_MEMORY_INIT is not set
 # CONFIG_LATENCYTOP is not set
-CONFIG_HAVE_FTRACE=y
+CONFIG_HAVE_FUNCTION_TRACER=y
 CONFIG_HAVE_DYNAMIC_FTRACE=y
-# CONFIG_FTRACE is not set
+# CONFIG_FUNCTION_TRACER is not set
 # CONFIG_SCHED_TRACER is not set
 # CONFIG_CONTEXT_SWITCH_TRACER is not set
 # CONFIG_SAMPLES is not set
Index: linux-tip.git/arch/powerpc/configs/44x/sequoia_defconfig
===================================================================
--- linux-tip.git.orig/arch/powerpc/configs/44x/sequoia_defconfig	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/powerpc/configs/44x/sequoia_defconfig	2008-10-06 18:51:09.000000000 -0400
@@ -874,9 +874,9 @@ CONFIG_SCHED_DEBUG=y
 # CONFIG_BACKTRACE_SELF_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_LATENCYTOP is not set
-CONFIG_HAVE_FTRACE=y
+CONFIG_HAVE_FUNCTION_TRACER=y
 CONFIG_HAVE_DYNAMIC_FTRACE=y
-# CONFIG_FTRACE is not set
+# CONFIG_FUNCTION_TRACER is not set
 # CONFIG_SCHED_TRACER is not set
 # CONFIG_CONTEXT_SWITCH_TRACER is not set
 # CONFIG_SAMPLES is not set
Index: linux-tip.git/arch/powerpc/configs/44x/taishan_defconfig
===================================================================
--- linux-tip.git.orig/arch/powerpc/configs/44x/taishan_defconfig	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/powerpc/configs/44x/taishan_defconfig	2008-10-06 18:51:09.000000000 -0400
@@ -864,9 +864,9 @@ CONFIG_SCHED_DEBUG=y
 # CONFIG_BACKTRACE_SELF_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_LATENCYTOP is not set
-CONFIG_HAVE_FTRACE=y
+CONFIG_HAVE_FUNCTION_TRACER=y
 CONFIG_HAVE_DYNAMIC_FTRACE=y
-# CONFIG_FTRACE is not set
+# CONFIG_FUNCTION_TRACER is not set
 # CONFIG_SCHED_TRACER is not set
 # CONFIG_CONTEXT_SWITCH_TRACER is not set
 # CONFIG_SAMPLES is not set
Index: linux-tip.git/arch/powerpc/configs/44x/virtex5_defconfig
===================================================================
--- linux-tip.git.orig/arch/powerpc/configs/44x/virtex5_defconfig	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/powerpc/configs/44x/virtex5_defconfig	2008-10-06 18:51:09.000000000 -0400
@@ -1053,9 +1053,9 @@ CONFIG_FRAME_WARN=1024
 CONFIG_DEBUG_BUGVERBOSE=y
 CONFIG_DEBUG_MEMORY_INIT=y
 # CONFIG_LATENCYTOP is not set
-CONFIG_HAVE_FTRACE=y
+CONFIG_HAVE_FUNCTION_TRACER=y
 CONFIG_HAVE_DYNAMIC_FTRACE=y
-# CONFIG_FTRACE is not set
+# CONFIG_FUNCTION_TRACER is not set
 # CONFIG_PREEMPT_TRACER is not set
 # CONFIG_SCHED_TRACER is not set
 # CONFIG_CONTEXT_SWITCH_TRACER is not set
Index: linux-tip.git/arch/powerpc/configs/44x/warp_defconfig
===================================================================
--- linux-tip.git.orig/arch/powerpc/configs/44x/warp_defconfig	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/powerpc/configs/44x/warp_defconfig	2008-10-06 18:51:09.000000000 -0400
@@ -1099,9 +1099,9 @@ CONFIG_DEBUG_INFO=y
 # CONFIG_BACKTRACE_SELF_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_LATENCYTOP is not set
-CONFIG_HAVE_FTRACE=y
+CONFIG_HAVE_FUNCTION_TRACER=y
 CONFIG_HAVE_DYNAMIC_FTRACE=y
-# CONFIG_FTRACE is not set
+# CONFIG_FUNCTION_TRACER is not set
 # CONFIG_SCHED_TRACER is not set
 # CONFIG_CONTEXT_SWITCH_TRACER is not set
 # CONFIG_SAMPLES is not set
Index: linux-tip.git/arch/powerpc/configs/83xx/asp8347_defconfig
===================================================================
--- linux-tip.git.orig/arch/powerpc/configs/83xx/asp8347_defconfig	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/powerpc/configs/83xx/asp8347_defconfig	2008-10-06 18:51:09.000000000 -0400
@@ -1231,9 +1231,9 @@ CONFIG_FRAME_WARN=1024
 # CONFIG_DEBUG_MEMORY_INIT is not set
 # CONFIG_LATENCYTOP is not set
 # CONFIG_SYSCTL_SYSCALL_CHECK is not set
-CONFIG_HAVE_FTRACE=y
+CONFIG_HAVE_FUNCTION_TRACER=y
 CONFIG_HAVE_DYNAMIC_FTRACE=y
-# CONFIG_FTRACE is not set
+# CONFIG_FUNCTION_TRACER is not set
 # CONFIG_SCHED_TRACER is not set
 # CONFIG_CONTEXT_SWITCH_TRACER is not set
 # CONFIG_SAMPLES is not set
Index: linux-tip.git/arch/powerpc/configs/83xx/mpc8313_rdb_defconfig
===================================================================
--- linux-tip.git.orig/arch/powerpc/configs/83xx/mpc8313_rdb_defconfig	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/powerpc/configs/83xx/mpc8313_rdb_defconfig	2008-10-06 18:51:09.000000000 -0400
@@ -1431,9 +1431,9 @@ CONFIG_SCHED_DEBUG=y
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_LATENCYTOP is not set
 CONFIG_SYSCTL_SYSCALL_CHECK=y
-CONFIG_HAVE_FTRACE=y
+CONFIG_HAVE_FUNCTION_TRACER=y
 CONFIG_HAVE_DYNAMIC_FTRACE=y
-# CONFIG_FTRACE is not set
+# CONFIG_FUNCTION_TRACER is not set
 # CONFIG_SCHED_TRACER is not set
 # CONFIG_CONTEXT_SWITCH_TRACER is not set
 # CONFIG_SAMPLES is not set
Index: linux-tip.git/arch/powerpc/configs/83xx/mpc8315_rdb_defconfig
===================================================================
--- linux-tip.git.orig/arch/powerpc/configs/83xx/mpc8315_rdb_defconfig	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/powerpc/configs/83xx/mpc8315_rdb_defconfig	2008-10-06 18:51:09.000000000 -0400
@@ -1492,9 +1492,9 @@ CONFIG_SCHED_DEBUG=y
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_LATENCYTOP is not set
 CONFIG_SYSCTL_SYSCALL_CHECK=y
-CONFIG_HAVE_FTRACE=y
+CONFIG_HAVE_FUNCTION_TRACER=y
 CONFIG_HAVE_DYNAMIC_FTRACE=y
-# CONFIG_FTRACE is not set
+# CONFIG_FUNCTION_TRACER is not set
 # CONFIG_SCHED_TRACER is not set
 # CONFIG_CONTEXT_SWITCH_TRACER is not set
 # CONFIG_SAMPLES is not set
Index: linux-tip.git/arch/powerpc/configs/83xx/mpc832x_mds_defconfig
===================================================================
--- linux-tip.git.orig/arch/powerpc/configs/83xx/mpc832x_mds_defconfig	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/powerpc/configs/83xx/mpc832x_mds_defconfig	2008-10-06 18:51:09.000000000 -0400
@@ -1109,9 +1109,9 @@ CONFIG_FRAME_WARN=1024
 # CONFIG_DEBUG_MEMORY_INIT is not set
 # CONFIG_LATENCYTOP is not set
 CONFIG_SYSCTL_SYSCALL_CHECK=y
-CONFIG_HAVE_FTRACE=y
+CONFIG_HAVE_FUNCTION_TRACER=y
 CONFIG_HAVE_DYNAMIC_FTRACE=y
-# CONFIG_FTRACE is not set
+# CONFIG_FUNCTION_TRACER is not set
 # CONFIG_SCHED_TRACER is not set
 # CONFIG_CONTEXT_SWITCH_TRACER is not set
 # CONFIG_SAMPLES is not set
Index: linux-tip.git/arch/powerpc/configs/83xx/mpc832x_rdb_defconfig
===================================================================
--- linux-tip.git.orig/arch/powerpc/configs/83xx/mpc832x_rdb_defconfig	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/powerpc/configs/83xx/mpc832x_rdb_defconfig	2008-10-06 18:51:09.000000000 -0400
@@ -1265,9 +1265,9 @@ CONFIG_FRAME_WARN=1024
 # CONFIG_DEBUG_MEMORY_INIT is not set
 # CONFIG_LATENCYTOP is not set
 CONFIG_SYSCTL_SYSCALL_CHECK=y
-CONFIG_HAVE_FTRACE=y
+CONFIG_HAVE_FUNCTION_TRACER=y
 CONFIG_HAVE_DYNAMIC_FTRACE=y
-# CONFIG_FTRACE is not set
+# CONFIG_FUNCTION_TRACER is not set
 # CONFIG_SCHED_TRACER is not set
 # CONFIG_CONTEXT_SWITCH_TRACER is not set
 # CONFIG_SAMPLES is not set
Index: linux-tip.git/arch/powerpc/configs/83xx/mpc834x_itx_defconfig
===================================================================
--- linux-tip.git.orig/arch/powerpc/configs/83xx/mpc834x_itx_defconfig	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/powerpc/configs/83xx/mpc834x_itx_defconfig	2008-10-06 18:51:09.000000000 -0400
@@ -1324,9 +1324,9 @@ CONFIG_FRAME_WARN=1024
 # CONFIG_DEBUG_MEMORY_INIT is not set
 # CONFIG_LATENCYTOP is not set
 CONFIG_SYSCTL_SYSCALL_CHECK=y
-CONFIG_HAVE_FTRACE=y
+CONFIG_HAVE_FUNCTION_TRACER=y
 CONFIG_HAVE_DYNAMIC_FTRACE=y
-# CONFIG_FTRACE is not set
+# CONFIG_FUNCTION_TRACER is not set
 # CONFIG_SCHED_TRACER is not set
 # CONFIG_CONTEXT_SWITCH_TRACER is not set
 # CONFIG_SAMPLES is not set
Index: linux-tip.git/arch/powerpc/configs/83xx/mpc834x_itxgp_defconfig
===================================================================
--- linux-tip.git.orig/arch/powerpc/configs/83xx/mpc834x_itxgp_defconfig	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/powerpc/configs/83xx/mpc834x_itxgp_defconfig	2008-10-06 18:51:09.000000000 -0400
@@ -1251,9 +1251,9 @@ CONFIG_FRAME_WARN=1024
 # CONFIG_DEBUG_MEMORY_INIT is not set
 # CONFIG_LATENCYTOP is not set
 CONFIG_SYSCTL_SYSCALL_CHECK=y
-CONFIG_HAVE_FTRACE=y
+CONFIG_HAVE_FUNCTION_TRACER=y
 CONFIG_HAVE_DYNAMIC_FTRACE=y
-# CONFIG_FTRACE is not set
+# CONFIG_FUNCTION_TRACER is not set
 # CONFIG_SCHED_TRACER is not set
 # CONFIG_CONTEXT_SWITCH_TRACER is not set
 # CONFIG_SAMPLES is not set
Index: linux-tip.git/arch/powerpc/configs/83xx/mpc834x_mds_defconfig
===================================================================
--- linux-tip.git.orig/arch/powerpc/configs/83xx/mpc834x_mds_defconfig	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/powerpc/configs/83xx/mpc834x_mds_defconfig	2008-10-06 18:51:09.000000000 -0400
@@ -1046,9 +1046,9 @@ CONFIG_FRAME_WARN=1024
 # CONFIG_DEBUG_MEMORY_INIT is not set
 # CONFIG_LATENCYTOP is not set
 CONFIG_SYSCTL_SYSCALL_CHECK=y
-CONFIG_HAVE_FTRACE=y
+CONFIG_HAVE_FUNCTION_TRACER=y
 CONFIG_HAVE_DYNAMIC_FTRACE=y
-# CONFIG_FTRACE is not set
+# CONFIG_FUNCTION_TRACER is not set
 # CONFIG_SCHED_TRACER is not set
 # CONFIG_CONTEXT_SWITCH_TRACER is not set
 # CONFIG_SAMPLES is not set
Index: linux-tip.git/arch/powerpc/configs/83xx/mpc836x_mds_defconfig
===================================================================
--- linux-tip.git.orig/arch/powerpc/configs/83xx/mpc836x_mds_defconfig	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/powerpc/configs/83xx/mpc836x_mds_defconfig	2008-10-06 18:51:09.000000000 -0400
@@ -1107,9 +1107,9 @@ CONFIG_FRAME_WARN=1024
 # CONFIG_DEBUG_MEMORY_INIT is not set
 # CONFIG_LATENCYTOP is not set
 CONFIG_SYSCTL_SYSCALL_CHECK=y
-CONFIG_HAVE_FTRACE=y
+CONFIG_HAVE_FUNCTION_TRACER=y
 CONFIG_HAVE_DYNAMIC_FTRACE=y
-# CONFIG_FTRACE is not set
+# CONFIG_FUNCTION_TRACER is not set
 # CONFIG_SCHED_TRACER is not set
 # CONFIG_CONTEXT_SWITCH_TRACER is not set
 # CONFIG_SAMPLES is not set
Index: linux-tip.git/arch/powerpc/configs/83xx/mpc836x_rdk_defconfig
===================================================================
--- linux-tip.git.orig/arch/powerpc/configs/83xx/mpc836x_rdk_defconfig	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/powerpc/configs/83xx/mpc836x_rdk_defconfig	2008-10-06 18:51:09.000000000 -0400
@@ -1104,9 +1104,9 @@ CONFIG_FRAME_WARN=1024
 # CONFIG_DEBUG_MEMORY_INIT is not set
 # CONFIG_LATENCYTOP is not set
 CONFIG_SYSCTL_SYSCALL_CHECK=y
-CONFIG_HAVE_FTRACE=y
+CONFIG_HAVE_FUNCTION_TRACER=y
 CONFIG_HAVE_DYNAMIC_FTRACE=y
-# CONFIG_FTRACE is not set
+# CONFIG_FUNCTION_TRACER is not set
 # CONFIG_SCHED_TRACER is not set
 # CONFIG_CONTEXT_SWITCH_TRACER is not set
 # CONFIG_SAMPLES is not set
Index: linux-tip.git/arch/powerpc/configs/83xx/mpc837x_mds_defconfig
===================================================================
--- linux-tip.git.orig/arch/powerpc/configs/83xx/mpc837x_mds_defconfig	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/powerpc/configs/83xx/mpc837x_mds_defconfig	2008-10-06 18:51:09.000000000 -0400
@@ -1115,9 +1115,9 @@ CONFIG_FRAME_WARN=1024
 # CONFIG_DEBUG_MEMORY_INIT is not set
 # CONFIG_LATENCYTOP is not set
 CONFIG_SYSCTL_SYSCALL_CHECK=y
-CONFIG_HAVE_FTRACE=y
+CONFIG_HAVE_FUNCTION_TRACER=y
 CONFIG_HAVE_DYNAMIC_FTRACE=y
-# CONFIG_FTRACE is not set
+# CONFIG_FUNCTION_TRACER is not set
 # CONFIG_SCHED_TRACER is not set
 # CONFIG_CONTEXT_SWITCH_TRACER is not set
 # CONFIG_SAMPLES is not set
Index: linux-tip.git/arch/powerpc/configs/83xx/mpc837x_rdb_defconfig
===================================================================
--- linux-tip.git.orig/arch/powerpc/configs/83xx/mpc837x_rdb_defconfig	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/powerpc/configs/83xx/mpc837x_rdb_defconfig	2008-10-06 18:51:09.000000000 -0400
@@ -1203,9 +1203,9 @@ CONFIG_FRAME_WARN=1024
 # CONFIG_DEBUG_MEMORY_INIT is not set
 # CONFIG_LATENCYTOP is not set
 CONFIG_SYSCTL_SYSCALL_CHECK=y
-CONFIG_HAVE_FTRACE=y
+CONFIG_HAVE_FUNCTION_TRACER=y
 CONFIG_HAVE_DYNAMIC_FTRACE=y
-# CONFIG_FTRACE is not set
+# CONFIG_FUNCTION_TRACER is not set
 # CONFIG_SCHED_TRACER is not set
 # CONFIG_CONTEXT_SWITCH_TRACER is not set
 # CONFIG_SAMPLES is not set
Index: linux-tip.git/arch/powerpc/configs/83xx/sbc834x_defconfig
===================================================================
--- linux-tip.git.orig/arch/powerpc/configs/83xx/sbc834x_defconfig	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/powerpc/configs/83xx/sbc834x_defconfig	2008-10-06 18:51:09.000000000 -0400
@@ -932,9 +932,9 @@ CONFIG_FRAME_WARN=1024
 # CONFIG_DEBUG_MEMORY_INIT is not set
 # CONFIG_LATENCYTOP is not set
 CONFIG_SYSCTL_SYSCALL_CHECK=y
-CONFIG_HAVE_FTRACE=y
+CONFIG_HAVE_FUNCTION_TRACER=y
 CONFIG_HAVE_DYNAMIC_FTRACE=y
-# CONFIG_FTRACE is not set
+# CONFIG_FUNCTION_TRACER is not set
 # CONFIG_SCHED_TRACER is not set
 # CONFIG_CONTEXT_SWITCH_TRACER is not set
 # CONFIG_SAMPLES is not set
Index: linux-tip.git/arch/powerpc/configs/85xx/ksi8560_defconfig
===================================================================
--- linux-tip.git.orig/arch/powerpc/configs/85xx/ksi8560_defconfig	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/powerpc/configs/85xx/ksi8560_defconfig	2008-10-06 18:51:09.000000000 -0400
@@ -886,9 +886,9 @@ CONFIG_DEBUG_MUTEXES=y
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_LATENCYTOP is not set
 CONFIG_SYSCTL_SYSCALL_CHECK=y
-CONFIG_HAVE_FTRACE=y
+CONFIG_HAVE_FUNCTION_TRACER=y
 CONFIG_HAVE_DYNAMIC_FTRACE=y
-# CONFIG_FTRACE is not set
+# CONFIG_FUNCTION_TRACER is not set
 # CONFIG_SCHED_TRACER is not set
 # CONFIG_CONTEXT_SWITCH_TRACER is not set
 # CONFIG_SAMPLES is not set
Index: linux-tip.git/arch/powerpc/configs/85xx/mpc8536_ds_defconfig
===================================================================
--- linux-tip.git.orig/arch/powerpc/configs/85xx/mpc8536_ds_defconfig	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/powerpc/configs/85xx/mpc8536_ds_defconfig	2008-10-06 18:51:09.000000000 -0400
@@ -1541,9 +1541,9 @@ CONFIG_DEBUG_INFO=y
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_LATENCYTOP is not set
 CONFIG_SYSCTL_SYSCALL_CHECK=y
-CONFIG_HAVE_FTRACE=y
+CONFIG_HAVE_FUNCTION_TRACER=y
 CONFIG_HAVE_DYNAMIC_FTRACE=y
-# CONFIG_FTRACE is not set
+# CONFIG_FUNCTION_TRACER is not set
 # CONFIG_SCHED_TRACER is not set
 # CONFIG_CONTEXT_SWITCH_TRACER is not set
 # CONFIG_SAMPLES is not set
Index: linux-tip.git/arch/powerpc/configs/85xx/mpc8540_ads_defconfig
===================================================================
--- linux-tip.git.orig/arch/powerpc/configs/85xx/mpc8540_ads_defconfig	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/powerpc/configs/85xx/mpc8540_ads_defconfig	2008-10-06 18:51:09.000000000 -0400
@@ -768,9 +768,9 @@ CONFIG_DEBUG_MUTEXES=y
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_LATENCYTOP is not set
 CONFIG_SYSCTL_SYSCALL_CHECK=y
-CONFIG_HAVE_FTRACE=y
+CONFIG_HAVE_FUNCTION_TRACER=y
 CONFIG_HAVE_DYNAMIC_FTRACE=y
-# CONFIG_FTRACE is not set
+# CONFIG_FUNCTION_TRACER is not set
 # CONFIG_SCHED_TRACER is not set
 # CONFIG_CONTEXT_SWITCH_TRACER is not set
 # CONFIG_SAMPLES is not set
Index: linux-tip.git/arch/powerpc/configs/85xx/mpc8544_ds_defconfig
===================================================================
--- linux-tip.git.orig/arch/powerpc/configs/85xx/mpc8544_ds_defconfig	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/powerpc/configs/85xx/mpc8544_ds_defconfig	2008-10-06 18:51:09.000000000 -0400
@@ -1542,9 +1542,9 @@ CONFIG_DEBUG_INFO=y
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_LATENCYTOP is not set
 CONFIG_SYSCTL_SYSCALL_CHECK=y
-CONFIG_HAVE_FTRACE=y
+CONFIG_HAVE_FUNCTION_TRACER=y
 CONFIG_HAVE_DYNAMIC_FTRACE=y
-# CONFIG_FTRACE is not set
+# CONFIG_FUNCTION_TRACER is not set
 # CONFIG_SCHED_TRACER is not set
 # CONFIG_CONTEXT_SWITCH_TRACER is not set
 # CONFIG_SAMPLES is not set
Index: linux-tip.git/arch/powerpc/configs/85xx/mpc8560_ads_defconfig
===================================================================
--- linux-tip.git.orig/arch/powerpc/configs/85xx/mpc8560_ads_defconfig	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/powerpc/configs/85xx/mpc8560_ads_defconfig	2008-10-06 18:51:09.000000000 -0400
@@ -876,9 +876,9 @@ CONFIG_DEBUG_MUTEXES=y
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_LATENCYTOP is not set
 CONFIG_SYSCTL_SYSCALL_CHECK=y
-CONFIG_HAVE_FTRACE=y
+CONFIG_HAVE_FUNCTION_TRACER=y
 CONFIG_HAVE_DYNAMIC_FTRACE=y
-# CONFIG_FTRACE is not set
+# CONFIG_FUNCTION_TRACER is not set
 # CONFIG_SCHED_TRACER is not set
 # CONFIG_CONTEXT_SWITCH_TRACER is not set
 # CONFIG_SAMPLES is not set
Index: linux-tip.git/arch/powerpc/configs/85xx/mpc8568mds_defconfig
===================================================================
--- linux-tip.git.orig/arch/powerpc/configs/85xx/mpc8568mds_defconfig	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/powerpc/configs/85xx/mpc8568mds_defconfig	2008-10-06 18:51:09.000000000 -0400
@@ -1098,9 +1098,9 @@ CONFIG_SCHED_DEBUG=y
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_LATENCYTOP is not set
 CONFIG_SYSCTL_SYSCALL_CHECK=y
-CONFIG_HAVE_FTRACE=y
+CONFIG_HAVE_FUNCTION_TRACER=y
 CONFIG_HAVE_DYNAMIC_FTRACE=y
-# CONFIG_FTRACE is not set
+# CONFIG_FUNCTION_TRACER is not set
 # CONFIG_SCHED_TRACER is not set
 # CONFIG_CONTEXT_SWITCH_TRACER is not set
 # CONFIG_SAMPLES is not set
Index: linux-tip.git/arch/powerpc/configs/85xx/mpc8572_ds_defconfig
===================================================================
--- linux-tip.git.orig/arch/powerpc/configs/85xx/mpc8572_ds_defconfig	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/powerpc/configs/85xx/mpc8572_ds_defconfig	2008-10-06 18:51:09.000000000 -0400
@@ -1530,9 +1530,9 @@ CONFIG_DEBUG_INFO=y
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_LATENCYTOP is not set
 CONFIG_SYSCTL_SYSCALL_CHECK=y
-CONFIG_HAVE_FTRACE=y
+CONFIG_HAVE_FUNCTION_TRACER=y
 CONFIG_HAVE_DYNAMIC_FTRACE=y
-# CONFIG_FTRACE is not set
+# CONFIG_FUNCTION_TRACER is not set
 # CONFIG_SCHED_TRACER is not set
 # CONFIG_CONTEXT_SWITCH_TRACER is not set
 # CONFIG_SAMPLES is not set
Index: linux-tip.git/arch/powerpc/configs/85xx/mpc85xx_cds_defconfig
===================================================================
--- linux-tip.git.orig/arch/powerpc/configs/85xx/mpc85xx_cds_defconfig	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/powerpc/configs/85xx/mpc85xx_cds_defconfig	2008-10-06 18:51:09.000000000 -0400
@@ -906,9 +906,9 @@ CONFIG_DEBUG_MUTEXES=y
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_LATENCYTOP is not set
 CONFIG_SYSCTL_SYSCALL_CHECK=y
-CONFIG_HAVE_FTRACE=y
+CONFIG_HAVE_FUNCTION_TRACER=y
 CONFIG_HAVE_DYNAMIC_FTRACE=y
-# CONFIG_FTRACE is not set
+# CONFIG_FUNCTION_TRACER is not set
 # CONFIG_SCHED_TRACER is not set
 # CONFIG_CONTEXT_SWITCH_TRACER is not set
 # CONFIG_SAMPLES is not set
Index: linux-tip.git/arch/powerpc/configs/85xx/sbc8548_defconfig
===================================================================
--- linux-tip.git.orig/arch/powerpc/configs/85xx/sbc8548_defconfig	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/powerpc/configs/85xx/sbc8548_defconfig	2008-10-06 18:51:09.000000000 -0400
@@ -783,9 +783,9 @@ CONFIG_FRAME_WARN=1024
 # CONFIG_DEBUG_MEMORY_INIT is not set
 # CONFIG_LATENCYTOP is not set
 CONFIG_SYSCTL_SYSCALL_CHECK=y
-CONFIG_HAVE_FTRACE=y
+CONFIG_HAVE_FUNCTION_TRACER=y
 CONFIG_HAVE_DYNAMIC_FTRACE=y
-# CONFIG_FTRACE is not set
+# CONFIG_FUNCTION_TRACER is not set
 # CONFIG_SCHED_TRACER is not set
 # CONFIG_CONTEXT_SWITCH_TRACER is not set
 # CONFIG_SAMPLES is not set
Index: linux-tip.git/arch/powerpc/configs/85xx/sbc8560_defconfig
===================================================================
--- linux-tip.git.orig/arch/powerpc/configs/85xx/sbc8560_defconfig	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/powerpc/configs/85xx/sbc8560_defconfig	2008-10-06 18:51:09.000000000 -0400
@@ -791,9 +791,9 @@ CONFIG_DEBUG_MUTEXES=y
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_LATENCYTOP is not set
 CONFIG_SYSCTL_SYSCALL_CHECK=y
-CONFIG_HAVE_FTRACE=y
+CONFIG_HAVE_FUNCTION_TRACER=y
 CONFIG_HAVE_DYNAMIC_FTRACE=y
-# CONFIG_FTRACE is not set
+# CONFIG_FUNCTION_TRACER is not set
 # CONFIG_SCHED_TRACER is not set
 # CONFIG_CONTEXT_SWITCH_TRACER is not set
 # CONFIG_SAMPLES is not set
Index: linux-tip.git/arch/powerpc/configs/85xx/stx_gp3_defconfig
===================================================================
--- linux-tip.git.orig/arch/powerpc/configs/85xx/stx_gp3_defconfig	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/powerpc/configs/85xx/stx_gp3_defconfig	2008-10-06 18:51:09.000000000 -0400
@@ -1257,9 +1257,9 @@ CONFIG_SCHED_DEBUG=y
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_LATENCYTOP is not set
 CONFIG_SYSCTL_SYSCALL_CHECK=y
-CONFIG_HAVE_FTRACE=y
+CONFIG_HAVE_FUNCTION_TRACER=y
 CONFIG_HAVE_DYNAMIC_FTRACE=y
-# CONFIG_FTRACE is not set
+# CONFIG_FUNCTION_TRACER is not set
 # CONFIG_SCHED_TRACER is not set
 # CONFIG_CONTEXT_SWITCH_TRACER is not set
 # CONFIG_SAMPLES is not set
Index: linux-tip.git/arch/powerpc/configs/85xx/tqm8540_defconfig
===================================================================
--- linux-tip.git.orig/arch/powerpc/configs/85xx/tqm8540_defconfig	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/powerpc/configs/85xx/tqm8540_defconfig	2008-10-06 18:51:09.000000000 -0400
@@ -1085,9 +1085,9 @@ CONFIG_FRAME_WARN=1024
 # CONFIG_DEBUG_MEMORY_INIT is not set
 # CONFIG_LATENCYTOP is not set
 CONFIG_SYSCTL_SYSCALL_CHECK=y
-CONFIG_HAVE_FTRACE=y
+CONFIG_HAVE_FUNCTION_TRACER=y
 CONFIG_HAVE_DYNAMIC_FTRACE=y
-# CONFIG_FTRACE is not set
+# CONFIG_FUNCTION_TRACER is not set
 # CONFIG_SCHED_TRACER is not set
 # CONFIG_CONTEXT_SWITCH_TRACER is not set
 # CONFIG_SAMPLES is not set
Index: linux-tip.git/arch/powerpc/configs/85xx/tqm8541_defconfig
===================================================================
--- linux-tip.git.orig/arch/powerpc/configs/85xx/tqm8541_defconfig	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/powerpc/configs/85xx/tqm8541_defconfig	2008-10-06 18:51:09.000000000 -0400
@@ -1118,9 +1118,9 @@ CONFIG_FRAME_WARN=1024
 # CONFIG_DEBUG_MEMORY_INIT is not set
 # CONFIG_LATENCYTOP is not set
 CONFIG_SYSCTL_SYSCALL_CHECK=y
-CONFIG_HAVE_FTRACE=y
+CONFIG_HAVE_FUNCTION_TRACER=y
 CONFIG_HAVE_DYNAMIC_FTRACE=y
-# CONFIG_FTRACE is not set
+# CONFIG_FUNCTION_TRACER is not set
 # CONFIG_SCHED_TRACER is not set
 # CONFIG_CONTEXT_SWITCH_TRACER is not set
 # CONFIG_SAMPLES is not set
Index: linux-tip.git/arch/powerpc/configs/85xx/tqm8548_defconfig
===================================================================
--- linux-tip.git.orig/arch/powerpc/configs/85xx/tqm8548_defconfig	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/powerpc/configs/85xx/tqm8548_defconfig	2008-10-06 18:51:09.000000000 -0400
@@ -1166,9 +1166,9 @@ CONFIG_DEBUG_MUTEXES=y
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_LATENCYTOP is not set
 CONFIG_SYSCTL_SYSCALL_CHECK=y
-CONFIG_HAVE_FTRACE=y
+CONFIG_HAVE_FUNCTION_TRACER=y
 CONFIG_HAVE_DYNAMIC_FTRACE=y
-# CONFIG_FTRACE is not set
+# CONFIG_FUNCTION_TRACER is not set
 # CONFIG_SCHED_TRACER is not set
 # CONFIG_CONTEXT_SWITCH_TRACER is not set
 # CONFIG_SAMPLES is not set
Index: linux-tip.git/arch/powerpc/configs/85xx/tqm8555_defconfig
===================================================================
--- linux-tip.git.orig/arch/powerpc/configs/85xx/tqm8555_defconfig	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/powerpc/configs/85xx/tqm8555_defconfig	2008-10-06 18:51:09.000000000 -0400
@@ -1118,9 +1118,9 @@ CONFIG_FRAME_WARN=1024
 # CONFIG_DEBUG_MEMORY_INIT is not set
 # CONFIG_LATENCYTOP is not set
 CONFIG_SYSCTL_SYSCALL_CHECK=y
-CONFIG_HAVE_FTRACE=y
+CONFIG_HAVE_FUNCTION_TRACER=y
 CONFIG_HAVE_DYNAMIC_FTRACE=y
-# CONFIG_FTRACE is not set
+# CONFIG_FUNCTION_TRACER is not set
 # CONFIG_SCHED_TRACER is not set
 # CONFIG_CONTEXT_SWITCH_TRACER is not set
 # CONFIG_SAMPLES is not set
Index: linux-tip.git/arch/powerpc/configs/85xx/tqm8560_defconfig
===================================================================
--- linux-tip.git.orig/arch/powerpc/configs/85xx/tqm8560_defconfig	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/powerpc/configs/85xx/tqm8560_defconfig	2008-10-06 18:51:09.000000000 -0400
@@ -1118,9 +1118,9 @@ CONFIG_FRAME_WARN=1024
 # CONFIG_DEBUG_MEMORY_INIT is not set
 # CONFIG_LATENCYTOP is not set
 CONFIG_SYSCTL_SYSCALL_CHECK=y
-CONFIG_HAVE_FTRACE=y
+CONFIG_HAVE_FUNCTION_TRACER=y
 CONFIG_HAVE_DYNAMIC_FTRACE=y
-# CONFIG_FTRACE is not set
+# CONFIG_FUNCTION_TRACER is not set
 # CONFIG_SCHED_TRACER is not set
 # CONFIG_CONTEXT_SWITCH_TRACER is not set
 # CONFIG_SAMPLES is not set
Index: linux-tip.git/arch/powerpc/configs/adder875_defconfig
===================================================================
--- linux-tip.git.orig/arch/powerpc/configs/adder875_defconfig	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/powerpc/configs/adder875_defconfig	2008-10-06 18:51:09.000000000 -0400
@@ -815,9 +815,9 @@ CONFIG_DEBUG_INFO=y
 # CONFIG_BACKTRACE_SELF_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_LATENCYTOP is not set
-CONFIG_HAVE_FTRACE=y
+CONFIG_HAVE_FUNCTION_TRACER=y
 CONFIG_HAVE_DYNAMIC_FTRACE=y
-# CONFIG_FTRACE is not set
+# CONFIG_FUNCTION_TRACER is not set
 # CONFIG_SCHED_TRACER is not set
 # CONFIG_CONTEXT_SWITCH_TRACER is not set
 # CONFIG_SAMPLES is not set
Index: linux-tip.git/arch/powerpc/configs/c2k_defconfig
===================================================================
--- linux-tip.git.orig/arch/powerpc/configs/c2k_defconfig	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/powerpc/configs/c2k_defconfig	2008-10-06 18:51:09.000000000 -0400
@@ -1713,9 +1713,9 @@ CONFIG_DEBUG_MEMORY_INIT=y
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_LATENCYTOP is not set
 CONFIG_SYSCTL_SYSCALL_CHECK=y
-CONFIG_HAVE_FTRACE=y
+CONFIG_HAVE_FUNCTION_TRACER=y
 CONFIG_HAVE_DYNAMIC_FTRACE=y
-# CONFIG_FTRACE is not set
+# CONFIG_FUNCTION_TRACER is not set
 # CONFIG_SCHED_TRACER is not set
 # CONFIG_CONTEXT_SWITCH_TRACER is not set
 # CONFIG_SAMPLES is not set
Index: linux-tip.git/arch/powerpc/configs/chrp32_defconfig
===================================================================
--- linux-tip.git.orig/arch/powerpc/configs/chrp32_defconfig	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/powerpc/configs/chrp32_defconfig	2008-10-06 18:51:09.000000000 -0400
@@ -1408,9 +1408,9 @@ CONFIG_DEBUG_MEMORY_INIT=y
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_LATENCYTOP is not set
 CONFIG_SYSCTL_SYSCALL_CHECK=y
-CONFIG_HAVE_FTRACE=y
+CONFIG_HAVE_FUNCTION_TRACER=y
 CONFIG_HAVE_DYNAMIC_FTRACE=y
-# CONFIG_FTRACE is not set
+# CONFIG_FUNCTION_TRACER is not set
 # CONFIG_SCHED_TRACER is not set
 # CONFIG_CONTEXT_SWITCH_TRACER is not set
 # CONFIG_SAMPLES is not set
Index: linux-tip.git/arch/powerpc/configs/ep8248e_defconfig
===================================================================
--- linux-tip.git.orig/arch/powerpc/configs/ep8248e_defconfig	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/powerpc/configs/ep8248e_defconfig	2008-10-06 18:51:09.000000000 -0400
@@ -928,9 +928,9 @@ CONFIG_DEBUG_INFO=y
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_LATENCYTOP is not set
 CONFIG_SYSCTL_SYSCALL_CHECK=y
-CONFIG_HAVE_FTRACE=y
+CONFIG_HAVE_FUNCTION_TRACER=y
 CONFIG_HAVE_DYNAMIC_FTRACE=y
-# CONFIG_FTRACE is not set
+# CONFIG_FUNCTION_TRACER is not set
 # CONFIG_SCHED_TRACER is not set
 # CONFIG_CONTEXT_SWITCH_TRACER is not set
 # CONFIG_SAMPLES is not set
Index: linux-tip.git/arch/powerpc/configs/ep88xc_defconfig
===================================================================
--- linux-tip.git.orig/arch/powerpc/configs/ep88xc_defconfig	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/powerpc/configs/ep88xc_defconfig	2008-10-06 18:51:09.000000000 -0400
@@ -771,9 +771,9 @@ CONFIG_DEBUG_INFO=y
 # CONFIG_BACKTRACE_SELF_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_LATENCYTOP is not set
-CONFIG_HAVE_FTRACE=y
+CONFIG_HAVE_FUNCTION_TRACER=y
 CONFIG_HAVE_DYNAMIC_FTRACE=y
-# CONFIG_FTRACE is not set
+# CONFIG_FUNCTION_TRACER is not set
 # CONFIG_SCHED_TRACER is not set
 # CONFIG_CONTEXT_SWITCH_TRACER is not set
 # CONFIG_SAMPLES is not set
Index: linux-tip.git/arch/powerpc/configs/g5_defconfig
===================================================================
--- linux-tip.git.orig/arch/powerpc/configs/g5_defconfig	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/powerpc/configs/g5_defconfig	2008-10-06 18:51:09.000000000 -0400
@@ -1664,9 +1664,9 @@ CONFIG_FRAME_POINTER=y
 # CONFIG_FAULT_INJECTION is not set
 CONFIG_LATENCYTOP=y
 CONFIG_SYSCTL_SYSCALL_CHECK=y
-CONFIG_HAVE_FTRACE=y
+CONFIG_HAVE_FUNCTION_TRACER=y
 CONFIG_HAVE_DYNAMIC_FTRACE=y
-# CONFIG_FTRACE is not set
+# CONFIG_FUNCTION_TRACER is not set
 # CONFIG_IRQSOFF_TRACER is not set
 # CONFIG_SCHED_TRACER is not set
 # CONFIG_CONTEXT_SWITCH_TRACER is not set
Index: linux-tip.git/arch/powerpc/configs/iseries_defconfig
===================================================================
--- linux-tip.git.orig/arch/powerpc/configs/iseries_defconfig	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/powerpc/configs/iseries_defconfig	2008-10-06 18:51:09.000000000 -0400
@@ -1134,9 +1134,9 @@ CONFIG_FRAME_POINTER=y
 # CONFIG_FAULT_INJECTION is not set
 CONFIG_LATENCYTOP=y
 CONFIG_SYSCTL_SYSCALL_CHECK=y
-CONFIG_HAVE_FTRACE=y
+CONFIG_HAVE_FUNCTION_TRACER=y
 CONFIG_HAVE_DYNAMIC_FTRACE=y
-# CONFIG_FTRACE is not set
+# CONFIG_FUNCTION_TRACER is not set
 # CONFIG_IRQSOFF_TRACER is not set
 # CONFIG_SCHED_TRACER is not set
 # CONFIG_CONTEXT_SWITCH_TRACER is not set
Index: linux-tip.git/arch/powerpc/configs/linkstation_defconfig
===================================================================
--- linux-tip.git.orig/arch/powerpc/configs/linkstation_defconfig	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/powerpc/configs/linkstation_defconfig	2008-10-06 18:51:09.000000000 -0400
@@ -1577,9 +1577,9 @@ CONFIG_DEBUG_MEMORY_INIT=y
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_LATENCYTOP is not set
 CONFIG_SYSCTL_SYSCALL_CHECK=y
-CONFIG_HAVE_FTRACE=y
+CONFIG_HAVE_FUNCTION_TRACER=y
 CONFIG_HAVE_DYNAMIC_FTRACE=y
-# CONFIG_FTRACE is not set
+# CONFIG_FUNCTION_TRACER is not set
 # CONFIG_SCHED_TRACER is not set
 # CONFIG_CONTEXT_SWITCH_TRACER is not set
 # CONFIG_SAMPLES is not set
Index: linux-tip.git/arch/powerpc/configs/maple_defconfig
===================================================================
--- linux-tip.git.orig/arch/powerpc/configs/maple_defconfig	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/powerpc/configs/maple_defconfig	2008-10-06 18:51:09.000000000 -0400
@@ -1324,9 +1324,9 @@ CONFIG_FRAME_POINTER=y
 # CONFIG_FAULT_INJECTION is not set
 CONFIG_LATENCYTOP=y
 # CONFIG_SYSCTL_SYSCALL_CHECK is not set
-CONFIG_HAVE_FTRACE=y
+CONFIG_HAVE_FUNCTION_TRACER=y
 CONFIG_HAVE_DYNAMIC_FTRACE=y
-# CONFIG_FTRACE is not set
+# CONFIG_FUNCTION_TRACER is not set
 # CONFIG_IRQSOFF_TRACER is not set
 # CONFIG_SCHED_TRACER is not set
 # CONFIG_CONTEXT_SWITCH_TRACER is not set
Index: linux-tip.git/arch/powerpc/configs/mpc7448_hpc2_defconfig
===================================================================
--- linux-tip.git.orig/arch/powerpc/configs/mpc7448_hpc2_defconfig	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/powerpc/configs/mpc7448_hpc2_defconfig	2008-10-06 18:51:09.000000000 -0400
@@ -974,9 +974,9 @@ CONFIG_FRAME_WARN=1024
 # CONFIG_DEBUG_MEMORY_INIT is not set
 # CONFIG_LATENCYTOP is not set
 CONFIG_SYSCTL_SYSCALL_CHECK=y
-CONFIG_HAVE_FTRACE=y
+CONFIG_HAVE_FUNCTION_TRACER=y
 CONFIG_HAVE_DYNAMIC_FTRACE=y
-# CONFIG_FTRACE is not set
+# CONFIG_FUNCTION_TRACER is not set
 # CONFIG_SCHED_TRACER is not set
 # CONFIG_CONTEXT_SWITCH_TRACER is not set
 # CONFIG_SAMPLES is not set
Index: linux-tip.git/arch/powerpc/configs/mpc8272_ads_defconfig
===================================================================
--- linux-tip.git.orig/arch/powerpc/configs/mpc8272_ads_defconfig	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/powerpc/configs/mpc8272_ads_defconfig	2008-10-06 18:51:09.000000000 -0400
@@ -993,9 +993,9 @@ CONFIG_DEBUG_INFO=y
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_LATENCYTOP is not set
 CONFIG_SYSCTL_SYSCALL_CHECK=y
-CONFIG_HAVE_FTRACE=y
+CONFIG_HAVE_FUNCTION_TRACER=y
 CONFIG_HAVE_DYNAMIC_FTRACE=y
-# CONFIG_FTRACE is not set
+# CONFIG_FUNCTION_TRACER is not set
 # CONFIG_SCHED_TRACER is not set
 # CONFIG_CONTEXT_SWITCH_TRACER is not set
 # CONFIG_SAMPLES is not set
Index: linux-tip.git/arch/powerpc/configs/mpc83xx_defconfig
===================================================================
--- linux-tip.git.orig/arch/powerpc/configs/mpc83xx_defconfig	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/powerpc/configs/mpc83xx_defconfig	2008-10-06 18:51:09.000000000 -0400
@@ -1337,9 +1337,9 @@ CONFIG_FRAME_WARN=1024
 # CONFIG_DEBUG_MEMORY_INIT is not set
 # CONFIG_LATENCYTOP is not set
 CONFIG_SYSCTL_SYSCALL_CHECK=y
-CONFIG_HAVE_FTRACE=y
+CONFIG_HAVE_FUNCTION_TRACER=y
 CONFIG_HAVE_DYNAMIC_FTRACE=y
-# CONFIG_FTRACE is not set
+# CONFIG_FUNCTION_TRACER is not set
 # CONFIG_SCHED_TRACER is not set
 # CONFIG_CONTEXT_SWITCH_TRACER is not set
 # CONFIG_SAMPLES is not set
Index: linux-tip.git/arch/powerpc/configs/mpc85xx_defconfig
===================================================================
--- linux-tip.git.orig/arch/powerpc/configs/mpc85xx_defconfig	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/powerpc/configs/mpc85xx_defconfig	2008-10-06 18:51:09.000000000 -0400
@@ -1583,9 +1583,9 @@ CONFIG_DEBUG_INFO=y
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_LATENCYTOP is not set
 CONFIG_SYSCTL_SYSCALL_CHECK=y
-CONFIG_HAVE_FTRACE=y
+CONFIG_HAVE_FUNCTION_TRACER=y
 CONFIG_HAVE_DYNAMIC_FTRACE=y
-# CONFIG_FTRACE is not set
+# CONFIG_FUNCTION_TRACER is not set
 # CONFIG_SCHED_TRACER is not set
 # CONFIG_CONTEXT_SWITCH_TRACER is not set
 # CONFIG_SAMPLES is not set
Index: linux-tip.git/arch/powerpc/configs/mpc8610_hpcd_defconfig
===================================================================
--- linux-tip.git.orig/arch/powerpc/configs/mpc8610_hpcd_defconfig	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/powerpc/configs/mpc8610_hpcd_defconfig	2008-10-06 18:51:09.000000000 -0400
@@ -1387,9 +1387,9 @@ CONFIG_DEBUG_INFO=y
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_LATENCYTOP is not set
 CONFIG_SYSCTL_SYSCALL_CHECK=y
-CONFIG_HAVE_FTRACE=y
+CONFIG_HAVE_FUNCTION_TRACER=y
 CONFIG_HAVE_DYNAMIC_FTRACE=y
-# CONFIG_FTRACE is not set
+# CONFIG_FUNCTION_TRACER is not set
 # CONFIG_SCHED_TRACER is not set
 # CONFIG_CONTEXT_SWITCH_TRACER is not set
 # CONFIG_SAMPLES is not set
Index: linux-tip.git/arch/powerpc/configs/mpc8641_hpcn_defconfig
===================================================================
--- linux-tip.git.orig/arch/powerpc/configs/mpc8641_hpcn_defconfig	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/powerpc/configs/mpc8641_hpcn_defconfig	2008-10-06 18:51:09.000000000 -0400
@@ -1554,9 +1554,9 @@ CONFIG_DEBUG_INFO=y
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_LATENCYTOP is not set
 CONFIG_SYSCTL_SYSCALL_CHECK=y
-CONFIG_HAVE_FTRACE=y
+CONFIG_HAVE_FUNCTION_TRACER=y
 CONFIG_HAVE_DYNAMIC_FTRACE=y
-# CONFIG_FTRACE is not set
+# CONFIG_FUNCTION_TRACER is not set
 # CONFIG_SCHED_TRACER is not set
 # CONFIG_CONTEXT_SWITCH_TRACER is not set
 # CONFIG_SAMPLES is not set
Index: linux-tip.git/arch/powerpc/configs/mpc866_ads_defconfig
===================================================================
--- linux-tip.git.orig/arch/powerpc/configs/mpc866_ads_defconfig	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/powerpc/configs/mpc866_ads_defconfig	2008-10-06 18:51:09.000000000 -0400
@@ -770,9 +770,9 @@ CONFIG_FRAME_WARN=1024
 # CONFIG_SLUB_STATS is not set
 # CONFIG_DEBUG_MEMORY_INIT is not set
 # CONFIG_LATENCYTOP is not set
-CONFIG_HAVE_FTRACE=y
+CONFIG_HAVE_FUNCTION_TRACER=y
 CONFIG_HAVE_DYNAMIC_FTRACE=y
-# CONFIG_FTRACE is not set
+# CONFIG_FUNCTION_TRACER is not set
 # CONFIG_SCHED_TRACER is not set
 # CONFIG_CONTEXT_SWITCH_TRACER is not set
 # CONFIG_SAMPLES is not set
Index: linux-tip.git/arch/powerpc/configs/mpc885_ads_defconfig
===================================================================
--- linux-tip.git.orig/arch/powerpc/configs/mpc885_ads_defconfig	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/powerpc/configs/mpc885_ads_defconfig	2008-10-06 18:51:09.000000000 -0400
@@ -782,9 +782,9 @@ CONFIG_DEBUG_INFO=y
 # CONFIG_BACKTRACE_SELF_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_LATENCYTOP is not set
-CONFIG_HAVE_FTRACE=y
+CONFIG_HAVE_FUNCTION_TRACER=y
 CONFIG_HAVE_DYNAMIC_FTRACE=y
-# CONFIG_FTRACE is not set
+# CONFIG_FUNCTION_TRACER is not set
 # CONFIG_SCHED_TRACER is not set
 # CONFIG_CONTEXT_SWITCH_TRACER is not set
 # CONFIG_SAMPLES is not set
Index: linux-tip.git/arch/powerpc/configs/pmac32_defconfig
===================================================================
--- linux-tip.git.orig/arch/powerpc/configs/pmac32_defconfig	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/powerpc/configs/pmac32_defconfig	2008-10-06 18:51:09.000000000 -0400
@@ -1934,9 +1934,9 @@ CONFIG_FRAME_POINTER=y
 # CONFIG_FAULT_INJECTION is not set
 CONFIG_LATENCYTOP=y
 CONFIG_SYSCTL_SYSCALL_CHECK=y
-CONFIG_HAVE_FTRACE=y
+CONFIG_HAVE_FUNCTION_TRACER=y
 CONFIG_HAVE_DYNAMIC_FTRACE=y
-# CONFIG_FTRACE is not set
+# CONFIG_FUNCTION_TRACER is not set
 # CONFIG_SCHED_TRACER is not set
 # CONFIG_CONTEXT_SWITCH_TRACER is not set
 # CONFIG_SAMPLES is not set
Index: linux-tip.git/arch/powerpc/configs/ppc40x_defconfig
===================================================================
--- linux-tip.git.orig/arch/powerpc/configs/ppc40x_defconfig	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/powerpc/configs/ppc40x_defconfig	2008-10-06 18:51:09.000000000 -0400
@@ -1026,9 +1026,9 @@ CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_BACKTRACE_SELF_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_LATENCYTOP is not set
-CONFIG_HAVE_FTRACE=y
+CONFIG_HAVE_FUNCTION_TRACER=y
 CONFIG_HAVE_DYNAMIC_FTRACE=y
-# CONFIG_FTRACE is not set
+# CONFIG_FUNCTION_TRACER is not set
 # CONFIG_SCHED_TRACER is not set
 # CONFIG_CONTEXT_SWITCH_TRACER is not set
 # CONFIG_SAMPLES is not set
Index: linux-tip.git/arch/powerpc/configs/ppc44x_defconfig
===================================================================
--- linux-tip.git.orig/arch/powerpc/configs/ppc44x_defconfig	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/powerpc/configs/ppc44x_defconfig	2008-10-06 18:51:09.000000000 -0400
@@ -1176,9 +1176,9 @@ CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_BACKTRACE_SELF_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_LATENCYTOP is not set
-CONFIG_HAVE_FTRACE=y
+CONFIG_HAVE_FUNCTION_TRACER=y
 CONFIG_HAVE_DYNAMIC_FTRACE=y
-# CONFIG_FTRACE is not set
+# CONFIG_FUNCTION_TRACER is not set
 # CONFIG_SCHED_TRACER is not set
 # CONFIG_CONTEXT_SWITCH_TRACER is not set
 # CONFIG_SAMPLES is not set
Index: linux-tip.git/arch/powerpc/configs/ppc64_defconfig
===================================================================
--- linux-tip.git.orig/arch/powerpc/configs/ppc64_defconfig	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/powerpc/configs/ppc64_defconfig	2008-10-06 18:51:09.000000000 -0400
@@ -1936,11 +1936,11 @@ CONFIG_FRAME_POINTER=y
 # CONFIG_FAULT_INJECTION is not set
 CONFIG_LATENCYTOP=y
 CONFIG_SYSCTL_SYSCALL_CHECK=y
-CONFIG_HAVE_FTRACE=y
+CONFIG_HAVE_FUNCTION_TRACER=y
 CONFIG_HAVE_DYNAMIC_FTRACE=y
 CONFIG_TRACER_MAX_TRACE=y
 CONFIG_TRACING=y
-# CONFIG_FTRACE is not set
+# CONFIG_FUNCTION_TRACER is not set
 CONFIG_IRQSOFF_TRACER=y
 CONFIG_SCHED_TRACER=y
 CONFIG_CONTEXT_SWITCH_TRACER=y
Index: linux-tip.git/arch/powerpc/configs/ppc6xx_defconfig
===================================================================
--- linux-tip.git.orig/arch/powerpc/configs/ppc6xx_defconfig	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/powerpc/configs/ppc6xx_defconfig	2008-10-06 18:51:09.000000000 -0400
@@ -3168,11 +3168,11 @@ CONFIG_FAULT_INJECTION_DEBUG_FS=y
 CONFIG_FAULT_INJECTION_STACKTRACE_FILTER=y
 CONFIG_LATENCYTOP=y
 CONFIG_SYSCTL_SYSCALL_CHECK=y
-CONFIG_HAVE_FTRACE=y
+CONFIG_HAVE_FUNCTION_TRACER=y
 CONFIG_HAVE_DYNAMIC_FTRACE=y
 CONFIG_TRACER_MAX_TRACE=y
 CONFIG_TRACING=y
-CONFIG_FTRACE=y
+CONFIG_FUNCTION_TRACER=y
 CONFIG_SCHED_TRACER=y
 CONFIG_CONTEXT_SWITCH_TRACER=y
 CONFIG_DYNAMIC_FTRACE=y
Index: linux-tip.git/arch/powerpc/configs/pq2fads_defconfig
===================================================================
--- linux-tip.git.orig/arch/powerpc/configs/pq2fads_defconfig	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/powerpc/configs/pq2fads_defconfig	2008-10-06 18:51:09.000000000 -0400
@@ -1088,9 +1088,9 @@ CONFIG_DEBUG_INFO=y
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_LATENCYTOP is not set
 CONFIG_SYSCTL_SYSCALL_CHECK=y
-CONFIG_HAVE_FTRACE=y
+CONFIG_HAVE_FUNCTION_TRACER=y
 CONFIG_HAVE_DYNAMIC_FTRACE=y
-# CONFIG_FTRACE is not set
+# CONFIG_FUNCTION_TRACER is not set
 # CONFIG_SCHED_TRACER is not set
 # CONFIG_CONTEXT_SWITCH_TRACER is not set
 # CONFIG_SAMPLES is not set
Index: linux-tip.git/arch/powerpc/configs/prpmc2800_defconfig
===================================================================
--- linux-tip.git.orig/arch/powerpc/configs/prpmc2800_defconfig	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/powerpc/configs/prpmc2800_defconfig	2008-10-06 18:51:09.000000000 -0400
@@ -1372,9 +1372,9 @@ CONFIG_DEBUG_BUGVERBOSE=y
 CONFIG_DEBUG_MEMORY_INIT=y
 # CONFIG_LATENCYTOP is not set
 CONFIG_SYSCTL_SYSCALL_CHECK=y
-CONFIG_HAVE_FTRACE=y
+CONFIG_HAVE_FUNCTION_TRACER=y
 CONFIG_HAVE_DYNAMIC_FTRACE=y
-# CONFIG_FTRACE is not set
+# CONFIG_FUNCTION_TRACER is not set
 # CONFIG_SCHED_TRACER is not set
 # CONFIG_CONTEXT_SWITCH_TRACER is not set
 # CONFIG_SAMPLES is not set
Index: linux-tip.git/arch/powerpc/configs/ps3_defconfig
===================================================================
--- linux-tip.git.orig/arch/powerpc/configs/ps3_defconfig	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/powerpc/configs/ps3_defconfig	2008-10-06 18:51:09.000000000 -0400
@@ -1257,9 +1257,9 @@ CONFIG_FRAME_POINTER=y
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_LATENCYTOP is not set
 CONFIG_SYSCTL_SYSCALL_CHECK=y
-CONFIG_HAVE_FTRACE=y
+CONFIG_HAVE_FUNCTION_TRACER=y
 CONFIG_HAVE_DYNAMIC_FTRACE=y
-# CONFIG_FTRACE is not set
+# CONFIG_FUNCTION_TRACER is not set
 # CONFIG_IRQSOFF_TRACER is not set
 # CONFIG_SCHED_TRACER is not set
 # CONFIG_CONTEXT_SWITCH_TRACER is not set
Index: linux-tip.git/arch/powerpc/configs/pseries_defconfig
===================================================================
--- linux-tip.git.orig/arch/powerpc/configs/pseries_defconfig	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/powerpc/configs/pseries_defconfig	2008-10-06 18:51:09.000000000 -0400
@@ -1586,11 +1586,11 @@ CONFIG_FRAME_POINTER=y
 # CONFIG_FAULT_INJECTION is not set
 CONFIG_LATENCYTOP=y
 CONFIG_SYSCTL_SYSCALL_CHECK=y
-CONFIG_HAVE_FTRACE=y
+CONFIG_HAVE_FUNCTION_TRACER=y
 CONFIG_HAVE_DYNAMIC_FTRACE=y
 CONFIG_TRACER_MAX_TRACE=y
 CONFIG_TRACING=y
-# CONFIG_FTRACE is not set
+# CONFIG_FUNCTION_TRACER is not set
 CONFIG_IRQSOFF_TRACER=y
 CONFIG_SCHED_TRACER=y
 CONFIG_CONTEXT_SWITCH_TRACER=y
Index: linux-tip.git/arch/powerpc/configs/sbc8641d_defconfig
===================================================================
--- linux-tip.git.orig/arch/powerpc/configs/sbc8641d_defconfig	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/powerpc/configs/sbc8641d_defconfig	2008-10-06 18:51:09.000000000 -0400
@@ -1362,9 +1362,9 @@ CONFIG_DEBUG_INFO=y
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_LATENCYTOP is not set
 CONFIG_SYSCTL_SYSCALL_CHECK=y
-CONFIG_HAVE_FTRACE=y
+CONFIG_HAVE_FUNCTION_TRACER=y
 CONFIG_HAVE_DYNAMIC_FTRACE=y
-# CONFIG_FTRACE is not set
+# CONFIG_FUNCTION_TRACER is not set
 # CONFIG_PREEMPT_TRACER is not set
 # CONFIG_SCHED_TRACER is not set
 # CONFIG_CONTEXT_SWITCH_TRACER is not set
Index: linux-tip.git/arch/powerpc/configs/storcenter_defconfig
===================================================================
--- linux-tip.git.orig/arch/powerpc/configs/storcenter_defconfig	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/powerpc/configs/storcenter_defconfig	2008-10-06 18:51:09.000000000 -0400
@@ -1211,9 +1211,9 @@ CONFIG_FRAME_WARN=1024
 # CONFIG_DEBUG_MEMORY_INIT is not set
 # CONFIG_LATENCYTOP is not set
 CONFIG_SYSCTL_SYSCALL_CHECK=y
-CONFIG_HAVE_FTRACE=y
+CONFIG_HAVE_FUNCTION_TRACER=y
 CONFIG_HAVE_DYNAMIC_FTRACE=y
-# CONFIG_FTRACE is not set
+# CONFIG_FUNCTION_TRACER is not set
 # CONFIG_SCHED_TRACER is not set
 # CONFIG_CONTEXT_SWITCH_TRACER is not set
 # CONFIG_SAMPLES is not set
Index: linux-tip.git/arch/sparc64/Kconfig
===================================================================
--- linux-tip.git.orig/arch/sparc64/Kconfig	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/sparc64/Kconfig	2008-10-06 18:51:09.000000000 -0400
@@ -12,7 +12,7 @@ config SPARC64
 	bool
 	default y
 	select HAVE_DYNAMIC_FTRACE
-	select HAVE_FTRACE
+	select HAVE_FUNCTION_TRACER
 	select HAVE_IDE
 	select HAVE_LMB
 	select HAVE_ARCH_KGDB
Index: linux-tip.git/arch/sparc64/defconfig
===================================================================
--- linux-tip.git.orig/arch/sparc64/defconfig	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/sparc64/defconfig	2008-10-06 18:51:09.000000000 -0400
@@ -1416,9 +1416,9 @@ CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_BACKTRACE_SELF_TEST is not set
 # CONFIG_LKDTM is not set
 # CONFIG_FAULT_INJECTION is not set
-CONFIG_HAVE_FTRACE=y
+CONFIG_HAVE_FUNCTION_TRACER=y
 CONFIG_HAVE_DYNAMIC_FTRACE=y
-# CONFIG_FTRACE is not set
+# CONFIG_FUNCTION_TRACER is not set
 # CONFIG_IRQSOFF_TRACER is not set
 # CONFIG_SCHED_TRACER is not set
 # CONFIG_CONTEXT_SWITCH_TRACER is not set
Index: linux-tip.git/arch/x86/Kconfig
===================================================================
--- linux-tip.git.orig/arch/x86/Kconfig	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/x86/Kconfig	2008-10-06 18:51:09.000000000 -0400
@@ -27,7 +27,7 @@ config X86
 	select HAVE_KRETPROBES
 	select HAVE_FTRACE_MCOUNT_RECORD
 	select HAVE_DYNAMIC_FTRACE
-	select HAVE_FTRACE
+	select HAVE_FUNCTION_TRACER
 	select HAVE_KVM if ((X86_32 && !X86_VOYAGER && !X86_VISWS && !X86_NUMAQ) || X86_64)
 	select HAVE_ARCH_KGDB if !X86_VOYAGER
 	select HAVE_ARCH_TRACEHOOK
Index: linux-tip.git/arch/x86/configs/i386_defconfig
===================================================================
--- linux-tip.git.orig/arch/x86/configs/i386_defconfig	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/x86/configs/i386_defconfig	2008-10-06 18:51:09.000000000 -0400
@@ -2079,9 +2079,9 @@ CONFIG_FRAME_POINTER=y
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_LATENCYTOP is not set
 CONFIG_SYSCTL_SYSCALL_CHECK=y
-CONFIG_HAVE_FTRACE=y
+CONFIG_HAVE_FUNCTION_TRACER=y
 CONFIG_HAVE_DYNAMIC_FTRACE=y
-# CONFIG_FTRACE is not set
+# CONFIG_FUNCTION_TRACER is not set
 # CONFIG_IRQSOFF_TRACER is not set
 # CONFIG_SYSPROF_TRACER is not set
 # CONFIG_SCHED_TRACER is not set
Index: linux-tip.git/arch/x86/configs/x86_64_defconfig
===================================================================
--- linux-tip.git.orig/arch/x86/configs/x86_64_defconfig	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/x86/configs/x86_64_defconfig	2008-10-06 18:51:09.000000000 -0400
@@ -2048,9 +2048,9 @@ CONFIG_FRAME_POINTER=y
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_LATENCYTOP is not set
 CONFIG_SYSCTL_SYSCALL_CHECK=y
-CONFIG_HAVE_FTRACE=y
+CONFIG_HAVE_FUNCTION_TRACER=y
 CONFIG_HAVE_DYNAMIC_FTRACE=y
-# CONFIG_FTRACE is not set
+# CONFIG_FUNCTION_TRACER is not set
 # CONFIG_IRQSOFF_TRACER is not set
 # CONFIG_SYSPROF_TRACER is not set
 # CONFIG_SCHED_TRACER is not set
Index: linux-tip.git/arch/powerpc/include/asm/ftrace.h
===================================================================
--- linux-tip.git.orig/arch/powerpc/include/asm/ftrace.h	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/powerpc/include/asm/ftrace.h	2008-10-06 18:51:09.000000000 -0400
@@ -1,7 +1,7 @@
 #ifndef _ASM_POWERPC_FTRACE
 #define _ASM_POWERPC_FTRACE
 
-#ifdef CONFIG_FTRACE
+#ifdef CONFIG_FUNCTION_TRACER
 #define MCOUNT_ADDR		((long)(_mcount))
 #define MCOUNT_INSN_SIZE	4 /* sizeof mcount call */
 
Index: linux-tip.git/arch/powerpc/kernel/Makefile
===================================================================
--- linux-tip.git.orig/arch/powerpc/kernel/Makefile	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/powerpc/kernel/Makefile	2008-10-06 18:51:09.000000000 -0400
@@ -12,7 +12,7 @@ CFLAGS_prom_init.o      += -fPIC
 CFLAGS_btext.o		+= -fPIC
 endif
 
-ifdef CONFIG_FTRACE
+ifdef CONFIG_FUNCTION_TRACER
 # Do not trace early boot code
 CFLAGS_REMOVE_cputable.o = -pg -mno-sched-epilog
 CFLAGS_REMOVE_prom_init.o = -pg -mno-sched-epilog
Index: linux-tip.git/arch/sparc64/lib/mcount.S
===================================================================
--- linux-tip.git.orig/arch/sparc64/lib/mcount.S	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/sparc64/lib/mcount.S	2008-10-06 18:51:09.000000000 -0400
@@ -93,7 +93,7 @@ mcount:
 	 nop
 1:
 #endif
-#ifdef CONFIG_FTRACE
+#ifdef CONFIG_FUNCTION_TRACER
 #ifdef CONFIG_DYNAMIC_FTRACE
 	mov		%o7, %o0
 	.globl		mcount_call
@@ -119,7 +119,7 @@ mcount_call:
 	.size		_mcount,.-_mcount
 	.size		mcount,.-mcount
 
-#ifdef CONFIG_FTRACE
+#ifdef CONFIG_FUNCTION_TRACER
 	.globl		ftrace_stub
 	.type		ftrace_stub,#function
 ftrace_stub:
Index: linux-tip.git/arch/x86/kernel/Makefile
===================================================================
--- linux-tip.git.orig/arch/x86/kernel/Makefile	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/x86/kernel/Makefile	2008-10-06 18:51:09.000000000 -0400
@@ -6,7 +6,7 @@ extra-y                := head_$(BITS).o
 
 CPPFLAGS_vmlinux.lds += -U$(UTS_MACHINE)
 
-ifdef CONFIG_FTRACE
+ifdef CONFIG_FUNCTION_TRACER
 # Do not profile debug and lowlevel utilities
 CFLAGS_REMOVE_tsc.o = -pg
 CFLAGS_REMOVE_rtc.o = -pg
Index: linux-tip.git/arch/x86/kernel/entry_32.S
===================================================================
--- linux-tip.git.orig/arch/x86/kernel/entry_32.S	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/x86/kernel/entry_32.S	2008-10-06 18:51:09.000000000 -0400
@@ -1179,7 +1179,7 @@ ENDPROC(xen_failsafe_callback)
 
 #endif	/* CONFIG_XEN */
 
-#ifdef CONFIG_FTRACE
+#ifdef CONFIG_FUNCTION_TRACER
 #ifdef CONFIG_DYNAMIC_FTRACE
 
 ENTRY(mcount)
@@ -1240,7 +1240,7 @@ trace:
 	jmp ftrace_stub
 END(mcount)
 #endif /* CONFIG_DYNAMIC_FTRACE */
-#endif /* CONFIG_FTRACE */
+#endif /* CONFIG_FUNCTION_TRACER */
 
 .section .rodata,"a"
 #include "syscall_table_32.S"
Index: linux-tip.git/arch/x86/kernel/entry_64.S
===================================================================
--- linux-tip.git.orig/arch/x86/kernel/entry_64.S	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/x86/kernel/entry_64.S	2008-10-06 18:51:09.000000000 -0400
@@ -61,7 +61,7 @@
 
 	.code64
 
-#ifdef CONFIG_FTRACE
+#ifdef CONFIG_FUNCTION_TRACER
 #ifdef CONFIG_DYNAMIC_FTRACE
 ENTRY(mcount)
 	retq
@@ -143,7 +143,7 @@ trace:
 	jmp ftrace_stub
 END(mcount)
 #endif /* CONFIG_DYNAMIC_FTRACE */
-#endif /* CONFIG_FTRACE */
+#endif /* CONFIG_FUNCTION_TRACER */
 
 #define HARDNMI_MASK 0x40000000
 
Index: linux-tip.git/arch/x86/kernel/i386_ksyms_32.c
===================================================================
--- linux-tip.git.orig/arch/x86/kernel/i386_ksyms_32.c	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/x86/kernel/i386_ksyms_32.c	2008-10-06 18:51:09.000000000 -0400
@@ -5,7 +5,7 @@
 #include <asm/desc.h>
 #include <asm/ftrace.h>
 
-#ifdef CONFIG_FTRACE
+#ifdef CONFIG_FUNCTION_TRACER
 /* mcount is defined in assembly */
 EXPORT_SYMBOL(mcount);
 #endif
Index: linux-tip.git/arch/x86/kernel/x8664_ksyms_64.c
===================================================================
--- linux-tip.git.orig/arch/x86/kernel/x8664_ksyms_64.c	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/x86/kernel/x8664_ksyms_64.c	2008-10-06 18:51:09.000000000 -0400
@@ -12,7 +12,7 @@
 #include <asm/desc.h>
 #include <asm/ftrace.h>
 
-#ifdef CONFIG_FTRACE
+#ifdef CONFIG_FUNCTION_TRACER
 /* mcount is defined in assembly */
 EXPORT_SYMBOL(mcount);
 #endif
Index: linux-tip.git/arch/x86/xen/Makefile
===================================================================
--- linux-tip.git.orig/arch/x86/xen/Makefile	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/x86/xen/Makefile	2008-10-06 18:51:09.000000000 -0400
@@ -1,4 +1,4 @@
-ifdef CONFIG_FTRACE
+ifdef CONFIG_FUNCTION_TRACER
 # Do not profile debug and lowlevel utilities
 CFLAGS_REMOVE_spinlock.o = -pg
 CFLAGS_REMOVE_time.o = -pg
Index: linux-tip.git/include/asm-x86/ftrace.h
===================================================================
--- linux-tip.git.orig/include/asm-x86/ftrace.h	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/include/asm-x86/ftrace.h	2008-10-06 18:51:09.000000000 -0400
@@ -1,7 +1,7 @@
 #ifndef ASM_X86__FTRACE_H
 #define ASM_X86__FTRACE_H
 
-#ifdef CONFIG_FTRACE
+#ifdef CONFIG_FUNCTION_TRACER
 #define MCOUNT_ADDR		((long)(mcount))
 #define MCOUNT_INSN_SIZE	5 /* sizeof mcount call */
 
@@ -19,6 +19,6 @@ static inline unsigned long ftrace_call_
 }
 #endif
 
-#endif /* CONFIG_FTRACE */
+#endif /* CONFIG_FUNCTION_TRACER */
 
 #endif /* ASM_X86__FTRACE_H */
Index: linux-tip.git/include/linux/ftrace.h
===================================================================
--- linux-tip.git.orig/include/linux/ftrace.h	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/include/linux/ftrace.h	2008-10-06 18:51:09.000000000 -0400
@@ -8,7 +8,7 @@
 #include <linux/types.h>
 #include <linux/kallsyms.h>
 
-#ifdef CONFIG_FTRACE
+#ifdef CONFIG_FUNCTION_TRACER
 
 extern int ftrace_enabled;
 extern int
@@ -64,12 +64,12 @@ void clear_ftrace_function(void);
 
 extern void ftrace_stub(unsigned long a0, unsigned long a1);
 
-#else /* !CONFIG_FTRACE */
+#else /* !CONFIG_FUNCTION_TRACER */
 # define register_ftrace_function(ops) do { } while (0)
 # define unregister_ftrace_function(ops) do { } while (0)
 # define clear_ftrace_function(ops) do { } while (0)
 static inline void ftrace_kill_atomic(void) { }
-#endif /* CONFIG_FTRACE */
+#endif /* CONFIG_FUNCTION_TRACER */
 
 #ifdef CONFIG_DYNAMIC_FTRACE
 # define FTRACE_HASHBITS	10
@@ -129,7 +129,7 @@ void ftrace_kill_atomic(void);
 
 static inline void tracer_disable(void)
 {
-#ifdef CONFIG_FTRACE
+#ifdef CONFIG_FUNCTION_TRACER
 	ftrace_enabled = 0;
 #endif
 }
@@ -141,7 +141,7 @@ static inline void tracer_disable(void)
  */
 static inline int __ftrace_enabled_save(void)
 {
-#ifdef CONFIG_FTRACE
+#ifdef CONFIG_FUNCTION_TRACER
 	int saved_ftrace_enabled = ftrace_enabled;
 	ftrace_enabled = 0;
 	return saved_ftrace_enabled;
@@ -152,7 +152,7 @@ static inline int __ftrace_enabled_save(
 
 static inline void __ftrace_enabled_restore(int enabled)
 {
-#ifdef CONFIG_FTRACE
+#ifdef CONFIG_FUNCTION_TRACER
 	ftrace_enabled = enabled;
 #endif
 }
Index: linux-tip.git/kernel/Makefile
===================================================================
--- linux-tip.git.orig/kernel/Makefile	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/kernel/Makefile	2008-10-06 18:51:09.000000000 -0400
@@ -13,7 +13,7 @@ obj-y     = sched.o fork.o exec_domain.o
 
 CFLAGS_REMOVE_sched.o = -mno-spe
 
-ifdef CONFIG_FTRACE
+ifdef CONFIG_FUNCTION_TRACER
 # Do not trace debug files and internal ftrace files
 CFLAGS_REMOVE_lockdep.o = -pg
 CFLAGS_REMOVE_lockdep_proc.o = -pg
@@ -86,7 +86,7 @@ obj-$(CONFIG_MARKERS) += marker.o
 obj-$(CONFIG_TRACEPOINTS) += tracepoint.o
 obj-$(CONFIG_LATENCYTOP) += latencytop.o
 obj-$(CONFIG_HAVE_GENERIC_DMA_COHERENT) += dma-coherent.o
-obj-$(CONFIG_FTRACE) += trace/
+obj-$(CONFIG_FUNCTION_TRACER) += trace/
 obj-$(CONFIG_TRACING) += trace/
 obj-$(CONFIG_SMP) += sched_cpupri.o
 
Index: linux-tip.git/kernel/sysctl.c
===================================================================
--- linux-tip.git.orig/kernel/sysctl.c	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/kernel/sysctl.c	2008-10-06 18:51:09.000000000 -0400
@@ -469,7 +469,7 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec,
 	},
-#ifdef CONFIG_FTRACE
+#ifdef CONFIG_FUNCTION_TRACER
 	{
 		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "ftrace_enabled",
Index: linux-tip.git/kernel/trace/trace.c
===================================================================
--- linux-tip.git.orig/kernel/trace/trace.c	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/kernel/trace/trace.c	2008-10-06 18:51:09.000000000 -0400
@@ -856,7 +856,7 @@ ftrace_special(unsigned long arg1, unsig
 	preempt_enable_notrace();
 }
 
-#ifdef CONFIG_FTRACE
+#ifdef CONFIG_FUNCTION_TRACER
 static void
 function_trace_call(unsigned long ip, unsigned long parent_ip)
 {
Index: linux-tip.git/kernel/trace/trace.h
===================================================================
--- linux-tip.git.orig/kernel/trace/trace.h	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/kernel/trace/trace.h	2008-10-06 18:51:09.000000000 -0400
@@ -335,7 +335,7 @@ void update_max_tr_single(struct trace_a
 
 extern cycle_t ftrace_now(int cpu);
 
-#ifdef CONFIG_FTRACE
+#ifdef CONFIG_FUNCTION_TRACER
 void tracing_start_function_trace(void);
 void tracing_stop_function_trace(void);
 #else
Index: linux-tip.git/kernel/trace/trace_irqsoff.c
===================================================================
--- linux-tip.git.orig/kernel/trace/trace_irqsoff.c	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/kernel/trace/trace_irqsoff.c	2008-10-06 18:51:09.000000000 -0400
@@ -63,7 +63,7 @@ irq_trace(void)
  */
 static __cacheline_aligned_in_smp	unsigned long max_sequence;
 
-#ifdef CONFIG_FTRACE
+#ifdef CONFIG_FUNCTION_TRACER
 /*
  * irqsoff uses its own tracer function to keep the overhead down:
  */
@@ -104,7 +104,7 @@ static struct ftrace_ops trace_ops __rea
 {
 	.func = irqsoff_tracer_call,
 };
-#endif /* CONFIG_FTRACE */
+#endif /* CONFIG_FUNCTION_TRACER */
 
 /*
  * Should this new latency be reported/recorded?
Index: linux-tip.git/kernel/trace/trace_sched_wakeup.c
===================================================================
--- linux-tip.git.orig/kernel/trace/trace_sched_wakeup.c	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/kernel/trace/trace_sched_wakeup.c	2008-10-06 18:51:09.000000000 -0400
@@ -31,7 +31,7 @@ static raw_spinlock_t wakeup_lock =
 
 static void __wakeup_reset(struct trace_array *tr);
 
-#ifdef CONFIG_FTRACE
+#ifdef CONFIG_FUNCTION_TRACER
 /*
  * irqsoff uses its own tracer function to keep the overhead down:
  */
@@ -96,7 +96,7 @@ static struct ftrace_ops trace_ops __rea
 {
 	.func = wakeup_tracer_call,
 };
-#endif /* CONFIG_FTRACE */
+#endif /* CONFIG_FUNCTION_TRACER */
 
 /*
  * Should this new latency be reported/recorded?
Index: linux-tip.git/kernel/trace/trace_selftest.c
===================================================================
--- linux-tip.git.orig/kernel/trace/trace_selftest.c	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/kernel/trace/trace_selftest.c	2008-10-06 18:51:09.000000000 -0400
@@ -70,7 +70,7 @@ static int trace_test_buffer(struct trac
 	return ret;
 }
 
-#ifdef CONFIG_FTRACE
+#ifdef CONFIG_FUNCTION_TRACER
 
 #ifdef CONFIG_DYNAMIC_FTRACE
 
@@ -226,7 +226,7 @@ trace_selftest_startup_function(struct t
 
 	return ret;
 }
-#endif /* CONFIG_FTRACE */
+#endif /* CONFIG_FUNCTION_TRACER */
 
 #ifdef CONFIG_IRQSOFF_TRACER
 int
Index: linux-tip.git/lib/Makefile
===================================================================
--- linux-tip.git.orig/lib/Makefile	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/lib/Makefile	2008-10-06 18:51:09.000000000 -0400
@@ -2,7 +2,7 @@
 # Makefile for some libs needed in the kernel.
 #
 
-ifdef CONFIG_FTRACE
+ifdef CONFIG_FUNCTION_TRACER
 ORIG_CFLAGS := $(KBUILD_CFLAGS)
 KBUILD_CFLAGS = $(subst -pg,,$(ORIG_CFLAGS))
 endif
Index: linux-tip.git/arch/sparc64/Kconfig.debug
===================================================================
--- linux-tip.git.orig/arch/sparc64/Kconfig.debug	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/sparc64/Kconfig.debug	2008-10-06 18:51:09.000000000 -0400
@@ -33,7 +33,7 @@ config DEBUG_PAGEALLOC
 
 config MCOUNT
 	bool
-	depends on STACK_DEBUG || FTRACE
+	depends on STACK_DEBUG || FUNCTION_TRACER
 	default y
 
 config FRAME_POINTER
Index: linux-tip.git/arch/powerpc/Makefile
===================================================================
--- linux-tip.git.orig/arch/powerpc/Makefile	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/powerpc/Makefile	2008-10-06 18:51:09.000000000 -0400
@@ -117,7 +117,7 @@ KBUILD_CFLAGS		+= -mcpu=powerpc
 endif
 
 # Work around a gcc code-gen bug with -fno-omit-frame-pointer.
-ifeq ($(CONFIG_FTRACE),y)
+ifeq ($(CONFIG_FUNCTION_TRACER),y)
 KBUILD_CFLAGS		+= -mno-sched-epilog
 endif
 
Index: linux-tip.git/arch/powerpc/kernel/ppc_ksyms.c
===================================================================
--- linux-tip.git.orig/arch/powerpc/kernel/ppc_ksyms.c	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/powerpc/kernel/ppc_ksyms.c	2008-10-06 18:51:09.000000000 -0400
@@ -68,7 +68,7 @@ EXPORT_SYMBOL(single_step_exception);
 EXPORT_SYMBOL(sys_sigreturn);
 #endif
 
-#ifdef CONFIG_FTRACE
+#ifdef CONFIG_FUNCTION_TRACER
 EXPORT_SYMBOL(_mcount);
 #endif
 
Index: linux-tip.git/arch/powerpc/platforms/powermac/Makefile
===================================================================
--- linux-tip.git.orig/arch/powerpc/platforms/powermac/Makefile	2008-10-06 18:50:47.000000000 -0400
+++ linux-tip.git/arch/powerpc/platforms/powermac/Makefile	2008-10-06 18:51:09.000000000 -0400
@@ -1,6 +1,6 @@
 CFLAGS_bootx_init.o  		+= -fPIC
 
-ifdef CONFIG_FTRACE
+ifdef CONFIG_FUNCTION_TRACER
 # Do not trace early boot code
 CFLAGS_REMOVE_bootx_init.o = -pg -mno-sched-epilog
 endif

-- 
