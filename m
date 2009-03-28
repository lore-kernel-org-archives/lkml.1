Return-Path: <linux-kernel-owner+w=401wt.eu-S1756230AbZC1Ot6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230AbZC1Ot6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 10:49:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755137AbZC1Ots
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 10:49:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:43405 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753104AbZC1Otp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 10:49:45 -0400
Subject: [git-pull -tip] x86: include inverse Xmas tree patches
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 28 Mar 2009 20:18:50 +0530
Message-Id: <1238251730.2526.2.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 29219683c46cb89edf5c58418b5305b14646d030:
  Ingo Molnar (1):
        Merge branches 'x86/apic', 'x86/cleanups', 'x86/mm', 'x86/pat', 'x86/setup' and 'x86/signal'; commit 'v2.6.29' into x86/core

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-Xmas.git x86/core

Jaswinder Singh Rajput (49):
      x86: process_32.c include inverse Xmas tree effect
      x86: signal.c include inverse Xmas tree effect
      x86: entry_32.S include inverse Xmas tree effect
      x86: traps.c include inverse Xmas tree effect
      x86: irq.c include inverse Xmas tree effect
      x86: irq_32.c include inverse Xmas tree effect
      x86: dumpstack.c include inverse Xmas tree effect
      x86: time_32.c include inverse Xmas tree effect
      x86: ioport.c include inverse Xmas tree effect
      x86: ldt.c include inverse Xmas tree effect
      x86: dumpstack_32.c include inverse Xmas tree effect
      x86: setup.c include inverse Xmas tree effect
      x86: i8259.c include inverse Xmas tree effect
      x86: irqinit_32.c include inverse Xmas tree effect
      x86: probe_roms_32.c include inverse Xmas tree effect
      x86: sys_i386_32.c include inverse Xmas tree effect
      x86: i386_ksyms_32.c include inverse Xmas tree effect
      x86: bootflag.c include inverse Xmas tree effect
      x86: e820.c include inverse Xmas tree effect
      x86: pci-dma.c include inverse Xmas tree effect
      x86: quirks.c include inverse Xmas tree effect
      x86: i8237.c include inverse Xmas tree effect
      x86: alternative.c include inverse Xmas tree effect
      x86: tsc.c include inverse Xmas tree effect
      x86: process.c include inverse Xmas tree effect
      x86: xsave.c include inverse Xmas tree effect
      x86: ptrace.c include inverse Xmas tree effect
      x86: ds.c include inverse Xmas tree effect
      x86: tls.c include inverse Xmas tree effect
      x86: step.c include inverse Xmas tree effect
      x86: stacktrace.c include inverse Xmas tree effect
      x86: reboot.c include inverse Xmas tree effect
      x86: msr.c include inverse Xmas tree effect
      x86: cpuid.c include inverse Xmas tree effect
      x86: early-quirks.c include inverse Xmas tree effect
      x86: smp.c include inverse Xmas tree effect
      x86: smpboot.c include inverse Xmas tree effect
      x86: tsc_sync.c include inverse Xmas tree effect
      x86: setup_percpu.c include inverse Xmas tree effect
      x86: trampoline_32.S include inverse Xmas tree effect
      x86: mpparse.c include inverse Xmas tree effect
      x86: module_32.c include inverse Xmas tree effect
      x86: doublefault_32.c include inverse Xmas tree effect
      x86: vm86_32.c include inverse Xmas tree effect
      ix86: early_printk.c include inverse Xmas tree effect
      x86: pcspeaker.c include inverse Xmas tree effect
      x86: head_32.c include inverse Xmas tree effect
      x86: head.c include inverse Xmas tree effect
      x86: init_task.c include inverse Xmas tree effect

 arch/x86/include/asm/proto.h         |    2 +
 arch/x86/include/asm/sigcontext32.h  |    3 +-
 arch/x86/include/asm/smpboot_hooks.h |    2 +
 arch/x86/include/asm/topology.h      |    2 +
 arch/x86/kernel/alternative.c        |   11 ++--
 arch/x86/kernel/bootflag.c           |   12 ++--
 arch/x86/kernel/cpuid.c              |   17 ++---
 arch/x86/kernel/doublefault_32.c     |    8 +-
 arch/x86/kernel/ds.c                 |   11 +--
 arch/x86/kernel/dumpstack.c          |    5 +-
 arch/x86/kernel/dumpstack_32.c       |    5 +-
 arch/x86/kernel/e820.c               |   21 +++---
 arch/x86/kernel/early-quirks.c       |    9 ++-
 arch/x86/kernel/early_printk.c       |   26 ++++---
 arch/x86/kernel/entry_32.S           |   17 +++--
 arch/x86/kernel/head.c               |    2 +-
 arch/x86/kernel/head_32.S            |   17 +++--
 arch/x86/kernel/i386_ksyms_32.c      |    3 +-
 arch/x86/kernel/i8237.c              |    3 +-
 arch/x86/kernel/i8259.c              |   28 ++++----
 arch/x86/kernel/init_task.c          |    8 +-
 arch/x86/kernel/ioport.c             |   15 ++--
 arch/x86/kernel/irq.c                |   11 ++--
 arch/x86/kernel/irq_32.c             |   10 ++--
 arch/x86/kernel/irqinit_32.c         |   29 ++++----
 arch/x86/kernel/ldt.c                |   14 ++--
 arch/x86/kernel/module_32.c          |    7 +-
 arch/x86/kernel/mpparse.c            |   24 +++---
 arch/x86/kernel/msr.c                |   17 ++---
 arch/x86/kernel/pci-dma.c            |   10 ++--
 arch/x86/kernel/pcspeaker.c          |    2 +-
 arch/x86/kernel/probe_roms_32.c      |   23 +++---
 arch/x86/kernel/process.c            |   19 +++---
 arch/x86/kernel/process_32.c         |   70 +++++++++----------
 arch/x86/kernel/ptrace.c             |   30 ++++----
 arch/x86/kernel/quirks.c             |    4 +-
 arch/x86/kernel/reboot.c             |   30 ++++----
 arch/x86/kernel/setup.c              |  126 ++++++++++++++++------------------
 arch/x86/kernel/setup_percpu.c       |   21 +++---
 arch/x86/kernel/signal.c             |   33 ++++-----
 arch/x86/kernel/smp.c                |   16 ++--
 arch/x86/kernel/smpboot.c            |   33 ++++-----
 arch/x86/kernel/stacktrace.c         |    6 +-
 arch/x86/kernel/step.c               |    3 +-
 arch/x86/kernel/sys_i386_32.c        |   25 +++----
 arch/x86/kernel/time_32.c            |    7 +-
 arch/x86/kernel/tls.c                |   10 ++--
 arch/x86/kernel/trampoline_32.S      |    3 +-
 arch/x86/kernel/traps.c              |   34 +++------
 arch/x86/kernel/tsc.c                |   20 +++---
 arch/x86/kernel/tsc_sync.c           |    2 +-
 arch/x86/kernel/vm86_32.c            |   20 +++---
 arch/x86/kernel/xsave.c              |    5 +-
 53 files changed, 437 insertions(+), 454 deletions(-)

Complete diff:
diff --git a/arch/x86/include/asm/proto.h b/arch/x86/include/asm/proto.h
index 49fb3ec..a8d63be 100644
--- a/arch/x86/include/asm/proto.h
+++ b/arch/x86/include/asm/proto.h
@@ -7,7 +7,9 @@
 
 extern void early_idt_handler(void);
 
+#ifdef CONFIG_X86_64
 extern void system_call(void);
+#endif
 extern void syscall_init(void);
 
 extern void ia32_syscall(void);
diff --git a/arch/x86/include/asm/sigcontext32.h b/arch/x86/include/asm/sigcontext32.h
index ad1478c..f80df2e 100644
--- a/arch/x86/include/asm/sigcontext32.h
+++ b/arch/x86/include/asm/sigcontext32.h
@@ -1,6 +1,7 @@
 #ifndef _ASM_X86_SIGCONTEXT32_H
 #define _ASM_X86_SIGCONTEXT32_H
 
+#ifdef CONFIG_IA32_EMULATION
 #include <linux/types.h>
 
 /* signal context for 32bit programs. */
@@ -73,5 +74,5 @@ struct sigcontext_ia32 {
        unsigned int oldmask;
        unsigned int cr2;
 };
-
+#endif
 #endif /* _ASM_X86_SIGCONTEXT32_H */
diff --git a/arch/x86/include/asm/smpboot_hooks.h b/arch/x86/include/asm/smpboot_hooks.h
index 1def601..dff6e11 100644
--- a/arch/x86/include/asm/smpboot_hooks.h
+++ b/arch/x86/include/asm/smpboot_hooks.h
@@ -1,6 +1,8 @@
 /* two abstractions specific to kernel/smpboot.c, mainly to cater to visws
  * which needs to alter them. */
 
+#include <asm/tlbflush.h>
+
 static inline void smpboot_clear_io_apic_irqs(void)
 {
 #ifdef CONFIG_X86_IO_APIC
diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index 77cfb2c..1f23e58 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -194,10 +194,12 @@ extern int __node_distance(int, int);
 
 #else /* !CONFIG_NUMA */
 
+#if 0
 static inline int numa_node_id(void)
 {
 	return 0;
 }
+#endif
 
 static inline int cpu_to_node(int cpu)
 {
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 4c80f15..51fb5c5 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -1,17 +1,18 @@
+#include <linux/kprobes.h>
+#include <linux/vmalloc.h>
 #include <linux/module.h>
-#include <linux/sched.h>
 #include <linux/mutex.h>
+#include <linux/sched.h>
 #include <linux/list.h>
-#include <linux/kprobes.h>
 #include <linux/mm.h>
-#include <linux/vmalloc.h>
+
 #include <asm/alternative.h>
+#include <asm/cacheflush.h>
 #include <asm/sections.h>
+#include <asm/vsyscall.h>
 #include <asm/pgtable.h>
 #include <asm/mce.h>
 #include <asm/nmi.h>
-#include <asm/vsyscall.h>
-#include <asm/cacheflush.h>
 #include <asm/io.h>
 
 #define MAX_PATCH_LEN (255-1)
diff --git a/arch/x86/kernel/bootflag.c b/arch/x86/kernel/bootflag.c
index 30f25a7..3cbb632 100644
--- a/arch/x86/kernel/bootflag.c
+++ b/arch/x86/kernel/bootflag.c
@@ -1,17 +1,17 @@
 /*
  *	Implement 'Simple Boot Flag Specification 2.0'
  */
-#include <linux/types.h>
+
+#include <linux/mc146818rtc.h>
+#include <linux/spinlock.h>
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/string.h>
-#include <linux/slab.h>
-#include <linux/spinlock.h>
+#include <linux/types.h>
 #include <linux/acpi.h>
+#include <linux/init.h>
+#include <linux/slab.h>
 #include <asm/io.h>
 
-#include <linux/mc146818rtc.h>
-
 #define SBF_RESERVED (0x78)
 #define SBF_PNPOS    (1<<0)
 #define SBF_BOOTING  (1<<1)
diff --git a/arch/x86/kernel/cpuid.c b/arch/x86/kernel/cpuid.c
index 2ac1f0c..7e5caa6 100644
--- a/arch/x86/kernel/cpuid.c
+++ b/arch/x86/kernel/cpuid.c
@@ -25,25 +25,24 @@
  * an SMP box will direct the access to CPU %d.
  */
 
+#include <linux/notifier.h>
+#include <linux/smp_lock.h>
+#include <linux/uaccess.h>
+#include <linux/device.h>
 #include <linux/module.h>
-
-#include <linux/types.h>
 #include <linux/errno.h>
 #include <linux/fcntl.h>
+#include <linux/major.h>
+#include <linux/types.h>
 #include <linux/init.h>
 #include <linux/poll.h>
+#include <linux/cpu.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
-#include <linux/major.h>
 #include <linux/fs.h>
-#include <linux/device.h>
-#include <linux/cpu.h>
-#include <linux/notifier.h>
-#include <linux/uaccess.h>
 
 #include <asm/processor.h>
-#include <asm/msr.h>
 #include <asm/system.h>
+#include <asm/msr.h>
 
 static struct class *cpuid_class;
 
diff --git a/arch/x86/kernel/doublefault_32.c b/arch/x86/kernel/doublefault_32.c
index b4f14c6..2d1f7b7 100644
--- a/arch/x86/kernel/doublefault_32.c
+++ b/arch/x86/kernel/doublefault_32.c
@@ -1,12 +1,12 @@
-#include <linux/mm.h>
+#include <linux/init_task.h>
 #include <linux/sched.h>
 #include <linux/init.h>
-#include <linux/init_task.h>
 #include <linux/fs.h>
+#include <linux/mm.h>
 
-#include <asm/uaccess.h>
-#include <asm/pgtable.h>
 #include <asm/processor.h>
+#include <asm/pgtable.h>
+#include <asm/uaccess.h>
 #include <asm/desc.h>
 
 #define DOUBLEFAULT_STACKSIZE (1024)
diff --git a/arch/x86/kernel/ds.c b/arch/x86/kernel/ds.c
index 87b67e3..fa9b42c 100644
--- a/arch/x86/kernel/ds.c
+++ b/arch/x86/kernel/ds.c
@@ -19,16 +19,13 @@
  * Markus Metzger <markus.t.metzger@intel.com>, 2007-2009
  */
 
-
-#include <asm/ds.h>
-
-#include <linux/errno.h>
+#include <linux/kernel.h>
 #include <linux/string.h>
-#include <linux/slab.h>
+#include <linux/errno.h>
 #include <linux/sched.h>
+#include <linux/slab.h>
 #include <linux/mm.h>
-#include <linux/kernel.h>
-
+#include <asm/ds.h>
 
 /*
  * The configuration for a particular DS hardware implementation.
diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index 87d103d..9c4da7e 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -2,18 +2,19 @@
  *  Copyright (C) 1991, 1992  Linus Torvalds
  *  Copyright (C) 2000, 2001, 2002 Andi Kleen, SuSE Labs
  */
+
 #include <linux/kallsyms.h>
 #include <linux/kprobes.h>
+#include <linux/hardirq.h>
 #include <linux/uaccess.h>
 #include <linux/utsname.h>
-#include <linux/hardirq.h>
 #include <linux/kdebug.h>
 #include <linux/module.h>
 #include <linux/ptrace.h>
 #include <linux/kexec.h>
+#include <linux/sysfs.h>
 #include <linux/bug.h>
 #include <linux/nmi.h>
-#include <linux/sysfs.h>
 
 #include <asm/stacktrace.h>
 
diff --git a/arch/x86/kernel/dumpstack_32.c b/arch/x86/kernel/dumpstack_32.c
index d593cd1..f967111 100644
--- a/arch/x86/kernel/dumpstack_32.c
+++ b/arch/x86/kernel/dumpstack_32.c
@@ -2,18 +2,19 @@
  *  Copyright (C) 1991, 1992  Linus Torvalds
  *  Copyright (C) 2000, 2001, 2002 Andi Kleen, SuSE Labs
  */
+
 #include <linux/kallsyms.h>
+#include <linux/hardirq.h>
 #include <linux/kprobes.h>
 #include <linux/uaccess.h>
 #include <linux/utsname.h>
-#include <linux/hardirq.h>
 #include <linux/kdebug.h>
 #include <linux/module.h>
 #include <linux/ptrace.h>
 #include <linux/kexec.h>
+#include <linux/sysfs.h>
 #include <linux/bug.h>
 #include <linux/nmi.h>
-#include <linux/sysfs.h>
 
 #include <asm/stacktrace.h>
 
diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index fb638d9..8232b2b 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -8,25 +8,26 @@
  *  Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
  *
  */
-#include <linux/kernel.h>
-#include <linux/types.h>
-#include <linux/init.h>
+
+#include <linux/firmware-map.h>
 #include <linux/bootmem.h>
+#include <linux/suspend.h>
 #include <linux/ioport.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
 #include <linux/string.h>
 #include <linux/kexec.h>
-#include <linux/module.h>
-#include <linux/mm.h>
+#include <linux/types.h>
+#include <linux/init.h>
 #include <linux/pfn.h>
-#include <linux/suspend.h>
-#include <linux/firmware-map.h>
+#include <linux/mm.h>
 
+#include <asm/trampoline.h>
 #include <asm/pgtable.h>
-#include <asm/page.h>
-#include <asm/e820.h>
 #include <asm/proto.h>
 #include <asm/setup.h>
-#include <asm/trampoline.h>
+#include <asm/e820.h>
+#include <asm/page.h>
 
 /*
  * The e820 map is the map that gets modified e.g. with command line parameters
diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
index 76b8cd9..c4acdfd 100644
--- a/arch/x86/kernel/early-quirks.c
+++ b/arch/x86/kernel/early-quirks.c
@@ -9,15 +9,16 @@
    Mainboard specific bugs should be handled by DMI entries.
    CPU specific bugs in setup.c */
 
-#include <linux/pci.h>
-#include <linux/acpi.h>
 #include <linux/pci_ids.h>
+#include <linux/acpi.h>
+#include <linux/pci.h>
+
 #include <asm/pci-direct.h>
-#include <asm/dma.h>
 #include <asm/io_apic.h>
-#include <asm/apic.h>
 #include <asm/iommu.h>
+#include <asm/apic.h>
 #include <asm/gart.h>
+#include <asm/dma.h>
 
 static void __init fix_hypertransport_config(int num, int slot, int func)
 {
diff --git a/arch/x86/kernel/early_printk.c b/arch/x86/kernel/early_printk.c
index 335f049..57a1ab3 100644
--- a/arch/x86/kernel/early_printk.c
+++ b/arch/x86/kernel/early_printk.c
@@ -1,21 +1,25 @@
-#include <linux/console.h>
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/string.h>
+#include <linux/spinlock_types.h>
 #include <linux/screen_info.h>
-#include <linux/usb/ch9.h>
 #include <linux/pci_regs.h>
+#include <linux/console.h>
 #include <linux/pci_ids.h>
+#include <linux/kernel.h>
+#include <linux/string.h>
 #include <linux/errno.h>
-#include <asm/io.h>
-#include <asm/processor.h>
-#include <asm/fcntl.h>
-#include <asm/setup.h>
+#include <linux/init.h>
+
+#include <linux/usb/ehci_def.h>
+#include <linux/usb/ch9.h>
+
 #include <xen/hvc-console.h>
+
 #include <asm/pci-direct.h>
-#include <asm/fixmap.h>
+#include <asm/processor.h>
 #include <asm/pgtable.h>
-#include <linux/usb/ehci_def.h>
+#include <asm/fixmap.h>
+#include <asm/fcntl.h>
+#include <asm/setup.h>
+#include <asm/io.h>
 
 /* Simple VGA output */
 #define VGABASE		(__ISA_IO_base + 0xb8000)
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index c929add..5f1c934 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -42,21 +42,22 @@
  */
 
 #include <linux/linkage.h>
+#include <linux/elf-em.h>
+
+#include <asm/processor-flags.h>
+#include <asm/irq_vectors.h>
 #include <asm/thread_info.h>
+#include <asm/page_types.h>
 #include <asm/irqflags.h>
-#include <asm/errno.h>
 #include <asm/segment.h>
-#include <asm/smp.h>
-#include <asm/page_types.h>
-#include <asm/desc.h>
-#include <asm/percpu.h>
 #include <asm/dwarf2.h>
-#include <asm/processor-flags.h>
 #include <asm/ftrace.h>
-#include <asm/irq_vectors.h>
+#include <asm/percpu.h>
+#include <asm/errno.h>
+#include <asm/desc.h>
+#include <asm/smp.h>
 
 /* Avoid __ASSEMBLER__'ifying <linux/audit.h> just for this.  */
-#include <linux/elf-em.h>
 #define AUDIT_ARCH_I386		(EM_386|__AUDIT_ARCH_LE)
 #define __AUDIT_ARCH_LE	   0x40000000
 
diff --git a/arch/x86/kernel/head.c b/arch/x86/kernel/head.c
index 3e66bd3..685811a 100644
--- a/arch/x86/kernel/head.c
+++ b/arch/x86/kernel/head.c
@@ -1,8 +1,8 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 
-#include <asm/setup.h>
 #include <asm/bios_ebda.h>
+#include <asm/setup.h>
 
 #define BIOS_LOWMEM_KILOBYTES 0x413
 
diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index 3068388..3dd22b3 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -7,19 +7,20 @@
  */
 
 .text
+#include <linux/linkage.h>
 #include <linux/threads.h>
 #include <linux/init.h>
-#include <linux/linkage.h>
-#include <asm/segment.h>
-#include <asm/page_types.h>
+
+#include <asm/processor-flags.h>
 #include <asm/pgtable_types.h>
-#include <asm/desc.h>
-#include <asm/cache.h>
-#include <asm/thread_info.h>
 #include <asm/asm-offsets.h>
-#include <asm/setup.h>
-#include <asm/processor-flags.h>
+#include <asm/thread_info.h>
+#include <asm/page_types.h>
+#include <asm/segment.h>
 #include <asm/percpu.h>
+#include <asm/cache.h>
+#include <asm/setup.h>
+#include <asm/desc.h>
 
 /* Physical address */
 #define pa(X) ((X) - __PAGE_OFFSET)
diff --git a/arch/x86/kernel/i386_ksyms_32.c b/arch/x86/kernel/i386_ksyms_32.c
index 43cec6b..87616ff 100644
--- a/arch/x86/kernel/i386_ksyms_32.c
+++ b/arch/x86/kernel/i386_ksyms_32.c
@@ -1,9 +1,8 @@
 #include <linux/module.h>
-
 #include <asm/checksum.h>
 #include <asm/pgtable.h>
-#include <asm/desc.h>
 #include <asm/ftrace.h>
+#include <asm/desc.h>
 
 #ifdef CONFIG_FUNCTION_TRACER
 /* mcount is defined in assembly */
diff --git a/arch/x86/kernel/i8237.c b/arch/x86/kernel/i8237.c
index b42ca69..bc043f7 100644
--- a/arch/x86/kernel/i8237.c
+++ b/arch/x86/kernel/i8237.c
@@ -9,9 +9,8 @@
  * your option) any later version.
  */
 
-#include <linux/init.h>
 #include <linux/sysdev.h>
-
+#include <linux/init.h>
 #include <asm/dma.h>
 
 /*
diff --git a/arch/x86/kernel/i8259.c b/arch/x86/kernel/i8259.c
index df89102..e9e6df1 100644
--- a/arch/x86/kernel/i8259.c
+++ b/arch/x86/kernel/i8259.c
@@ -1,28 +1,28 @@
+#include <linux/kernel_stat.h>
+#include <linux/interrupt.h>
 #include <linux/linkage.h>
-#include <linux/errno.h>
-#include <linux/signal.h>
-#include <linux/sched.h>
+#include <linux/bitops.h>
 #include <linux/ioport.h>
-#include <linux/interrupt.h>
-#include <linux/timex.h>
-#include <linux/slab.h>
 #include <linux/random.h>
-#include <linux/init.h>
-#include <linux/kernel_stat.h>
+#include <linux/signal.h>
 #include <linux/sysdev.h>
-#include <linux/bitops.h>
+#include <linux/delay.h>
+#include <linux/errno.h>
+#include <linux/sched.h>
+#include <linux/timex.h>
 #include <linux/acpi.h>
+#include <linux/init.h>
+#include <linux/slab.h>
 #include <linux/io.h>
-#include <linux/delay.h>
 
+#include <asm/pgtable.h>
 #include <asm/atomic.h>
+#include <asm/hw_irq.h>
 #include <asm/system.h>
+#include <asm/i8259.h>
 #include <asm/timer.h>
-#include <asm/hw_irq.h>
-#include <asm/pgtable.h>
-#include <asm/desc.h>
 #include <asm/apic.h>
-#include <asm/i8259.h>
+#include <asm/desc.h>
 
 /*
  * This is the 'legacy' 8259A Programmable Interrupt Controller,
diff --git a/arch/x86/kernel/init_task.c b/arch/x86/kernel/init_task.c
index df3bf26..c53d699 100644
--- a/arch/x86/kernel/init_task.c
+++ b/arch/x86/kernel/init_task.c
@@ -1,13 +1,13 @@
-#include <linux/mm.h>
+#include <linux/init_task.h>
 #include <linux/module.h>
+#include <linux/mqueue.h>
 #include <linux/sched.h>
 #include <linux/init.h>
-#include <linux/init_task.h>
 #include <linux/fs.h>
-#include <linux/mqueue.h>
+#include <linux/mm.h>
 
-#include <asm/uaccess.h>
 #include <asm/pgtable.h>
+#include <asm/uaccess.h>
 #include <asm/desc.h>
 
 static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
diff --git a/arch/x86/kernel/ioport.c b/arch/x86/kernel/ioport.c
index 99c4d30..fb498da 100644
--- a/arch/x86/kernel/ioport.c
+++ b/arch/x86/kernel/ioport.c
@@ -3,17 +3,18 @@
  * by Linus. 32/64 bits code unification by Miguel Botón.
  */
 
-#include <linux/sched.h>
-#include <linux/kernel.h>
+#include <linux/thread_info.h>
 #include <linux/capability.h>
-#include <linux/errno.h>
-#include <linux/types.h>
+#include <linux/syscalls.h>
 #include <linux/ioport.h>
-#include <linux/smp.h>
+#include <linux/kernel.h>
 #include <linux/stddef.h>
+#include <linux/errno.h>
+#include <linux/sched.h>
+#include <linux/types.h>
 #include <linux/slab.h>
-#include <linux/thread_info.h>
-#include <linux/syscalls.h>
+#include <linux/smp.h>
+
 #include <asm/syscalls.h>
 
 /* Set EXTENT bits starting at BASE in BITMAP to value TURN_ON. */
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index b8ac3b6..c1c484f 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -1,17 +1,18 @@
 /*
  * Common interrupt code for 32 and 64 bit
  */
-#include <linux/cpu.h>
-#include <linux/interrupt.h>
+
 #include <linux/kernel_stat.h>
+#include <linux/interrupt.h>
 #include <linux/seq_file.h>
-#include <linux/smp.h>
 #include <linux/ftrace.h>
+#include <linux/cpu.h>
+#include <linux/smp.h>
 
-#include <asm/apic.h>
 #include <asm/io_apic.h>
-#include <asm/irq.h>
 #include <asm/idle.h>
+#include <asm/apic.h>
+#include <asm/irq.h>
 
 atomic_t irq_err_count;
 
diff --git a/arch/x86/kernel/irq_32.c b/arch/x86/kernel/irq_32.c
index 3b09634..08bde3c 100644
--- a/arch/x86/kernel/irq_32.c
+++ b/arch/x86/kernel/irq_32.c
@@ -8,15 +8,15 @@
  * io_apic.c.)
  */
 
-#include <linux/module.h>
-#include <linux/seq_file.h>
-#include <linux/interrupt.h>
 #include <linux/kernel_stat.h>
+#include <linux/interrupt.h>
 #include <linux/notifier.h>
-#include <linux/cpu.h>
-#include <linux/delay.h>
+#include <linux/seq_file.h>
 #include <linux/uaccess.h>
+#include <linux/module.h>
 #include <linux/percpu.h>
+#include <linux/delay.h>
+#include <linux/cpu.h>
 
 #include <asm/apic.h>
 
diff --git a/arch/x86/kernel/irqinit_32.c b/arch/x86/kernel/irqinit_32.c
index bc13261..fcb54ac 100644
--- a/arch/x86/kernel/irqinit_32.c
+++ b/arch/x86/kernel/irqinit_32.c
@@ -1,27 +1,26 @@
-#include <linux/errno.h>
-#include <linux/signal.h>
-#include <linux/sched.h>
-#include <linux/ioport.h>
+#include <linux/kernel_stat.h>
 #include <linux/interrupt.h>
-#include <linux/slab.h>
+#include <linux/bitops.h>
+#include <linux/ioport.h>
 #include <linux/random.h>
-#include <linux/init.h>
-#include <linux/kernel_stat.h>
+#include <linux/signal.h>
 #include <linux/sysdev.h>
-#include <linux/bitops.h>
-#include <linux/io.h>
 #include <linux/delay.h>
+#include <linux/errno.h>
+#include <linux/sched.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/io.h>
 
+#include <asm/pgtable.h>
 #include <asm/atomic.h>
 #include <asm/system.h>
-#include <asm/timer.h>
-#include <asm/pgtable.h>
-#include <asm/desc.h>
-#include <asm/apic.h>
-#include <asm/setup.h>
 #include <asm/i8259.h>
+#include <asm/setup.h>
+#include <asm/timer.h>
 #include <asm/traps.h>
-
+#include <asm/apic.h>
+#include <asm/desc.h>
 
 /*
  * Note that on a 486, we don't want to do a SIGFPE on an irq13
diff --git a/arch/x86/kernel/ldt.c b/arch/x86/kernel/ldt.c
index 71f1d99..08ad4c5 100644
--- a/arch/x86/kernel/ldt.c
+++ b/arch/x86/kernel/ldt.c
@@ -6,19 +6,19 @@
  * This handles calls from both 32bit and 64bit mode.
  */
 
+#include <linux/uaccess.h>
+#include <linux/vmalloc.h>
+#include <linux/string.h>
 #include <linux/errno.h>
 #include <linux/sched.h>
-#include <linux/string.h>
-#include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/vmalloc.h>
-#include <linux/uaccess.h>
+#include <linux/mm.h>
 
-#include <asm/system.h>
-#include <asm/ldt.h>
-#include <asm/desc.h>
 #include <asm/mmu_context.h>
 #include <asm/syscalls.h>
+#include <asm/system.h>
+#include <asm/desc.h>
+#include <asm/ldt.h>
 
 #ifdef CONFIG_SMP
 static void flush_ldt(void *current_mm)
diff --git a/arch/x86/kernel/module_32.c b/arch/x86/kernel/module_32.c
index 0edd819..0f8dede 100644
--- a/arch/x86/kernel/module_32.c
+++ b/arch/x86/kernel/module_32.c
@@ -15,13 +15,14 @@
     along with this program; if not, write to the Free Software
     Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */
+
 #include <linux/moduleloader.h>
-#include <linux/elf.h>
 #include <linux/vmalloc.h>
-#include <linux/fs.h>
-#include <linux/string.h>
 #include <linux/kernel.h>
+#include <linux/string.h>
 #include <linux/bug.h>
+#include <linux/elf.h>
+#include <linux/fs.h>
 
 #if 0
 #define DEBUGP printk
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index dce99dc..f604897 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -7,29 +7,29 @@
  *      (c) 2008 Alexey Starikovskiy <astarikovskiy@suse.de>
  */
 
-#include <linux/mm.h>
-#include <linux/init.h>
-#include <linux/delay.h>
-#include <linux/bootmem.h>
 #include <linux/kernel_stat.h>
 #include <linux/mc146818rtc.h>
+#include <linux/bootmem.h>
 #include <linux/bitops.h>
-#include <linux/acpi.h>
 #include <linux/module.h>
+#include <linux/delay.h>
+#include <linux/acpi.h>
+#include <linux/init.h>
 #include <linux/smp.h>
+#include <linux/mm.h>
 
-#include <asm/mtrr.h>
-#include <asm/mpspec.h>
-#include <asm/pgalloc.h>
+#include <asm/trampoline.h>
+#include <asm/bios_ebda.h>
 #include <asm/io_apic.h>
+#include <asm/pgalloc.h>
+#include <asm/mpspec.h>
 #include <asm/proto.h>
-#include <asm/bios_ebda.h>
-#include <asm/e820.h>
-#include <asm/trampoline.h>
 #include <asm/setup.h>
+#include <asm/apic.h>
+#include <asm/e820.h>
+#include <asm/mtrr.h>
 #include <asm/smp.h>
 
-#include <asm/apic.h>
 /*
  * Checksum an MP configuration block.
  */
diff --git a/arch/x86/kernel/msr.c b/arch/x86/kernel/msr.c
index 3cf3413..1828fe0 100644
--- a/arch/x86/kernel/msr.c
+++ b/arch/x86/kernel/msr.c
@@ -21,25 +21,24 @@
  * an SMP box will direct the access to CPU %d.
  */
 
+#include <linux/notifier.h>
+#include <linux/smp_lock.h>
+#include <linux/uaccess.h>
+#include <linux/device.h>
 #include <linux/module.h>
-
-#include <linux/types.h>
 #include <linux/errno.h>
 #include <linux/fcntl.h>
+#include <linux/major.h>
+#include <linux/types.h>
 #include <linux/init.h>
 #include <linux/poll.h>
+#include <linux/cpu.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
-#include <linux/major.h>
 #include <linux/fs.h>
-#include <linux/device.h>
-#include <linux/cpu.h>
-#include <linux/notifier.h>
-#include <linux/uaccess.h>
 
 #include <asm/processor.h>
-#include <asm/msr.h>
 #include <asm/system.h>
+#include <asm/msr.h>
 
 static struct class *msr_class;
 
diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index b254285..b4a3a61 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -1,14 +1,14 @@
 #include <linux/dma-mapping.h>
-#include <linux/dmar.h>
 #include <linux/bootmem.h>
+#include <linux/dmar.h>
 #include <linux/pci.h>
 
-#include <asm/proto.h>
-#include <asm/dma.h>
+#include <asm/amd_iommu.h>
+#include <asm/calgary.h>
 #include <asm/iommu.h>
+#include <asm/proto.h>
 #include <asm/gart.h>
-#include <asm/calgary.h>
-#include <asm/amd_iommu.h>
+#include <asm/dma.h>
 
 static int forbid_dac __read_mostly;
 
diff --git a/arch/x86/kernel/pcspeaker.c b/arch/x86/kernel/pcspeaker.c
index a311ffc..d5047ca 100644
--- a/arch/x86/kernel/pcspeaker.c
+++ b/arch/x86/kernel/pcspeaker.c
@@ -1,6 +1,6 @@
 #include <linux/platform_device.h>
-#include <linux/err.h>
 #include <linux/init.h>
+#include <linux/err.h>
 
 static __init int add_pcspkr(void)
 {
diff --git a/arch/x86/kernel/probe_roms_32.c b/arch/x86/kernel/probe_roms_32.c
index 071e7fe..9ddad2a 100644
--- a/arch/x86/kernel/probe_roms_32.c
+++ b/arch/x86/kernel/probe_roms_32.c
@@ -1,24 +1,23 @@
-#include <linux/sched.h>
-#include <linux/mm.h>
-#include <linux/uaccess.h>
-#include <linux/mmzone.h>
-#include <linux/ioport.h>
 #include <linux/seq_file.h>
 #include <linux/console.h>
+#include <linux/uaccess.h>
+#include <linux/ioport.h>
+#include <linux/mmzone.h>
+#include <linux/sched.h>
 #include <linux/init.h>
-#include <linux/edd.h>
 #include <linux/dmi.h>
-#include <linux/pfn.h>
+#include <linux/edd.h>
 #include <linux/pci.h>
-#include <asm/pci-direct.h>
-
+#include <linux/pfn.h>
+#include <linux/mm.h>
 
-#include <asm/e820.h>
+#include <asm/pci-direct.h>
+#include <asm/setup_arch.h>
+#include <asm/sections.h>
 #include <asm/mmzone.h>
 #include <asm/setup.h>
-#include <asm/sections.h>
+#include <asm/e820.h>
 #include <asm/io.h>
-#include <asm/setup_arch.h>
 
 static struct resource system_rom_resource = {
 	.name	= "System ROM",
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 156f875..e508d97 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -1,19 +1,20 @@
-#include <linux/errno.h>
+#include <linux/clockchips.h>
+#include <linux/ftrace.h>
 #include <linux/kernel.h>
-#include <linux/mm.h>
-#include <linux/smp.h>
+#include <linux/module.h>
+#include <linux/errno.h>
 #include <linux/prctl.h>
-#include <linux/slab.h>
 #include <linux/sched.h>
-#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/smp.h>
+#include <linux/mm.h>
 #include <linux/pm.h>
-#include <linux/clockchips.h>
-#include <linux/ftrace.h>
+
+#include <asm/uaccess.h>
 #include <asm/system.h>
 #include <asm/apic.h>
-#include <asm/idle.h>
-#include <asm/uaccess.h>
 #include <asm/i387.h>
+#include <asm/idle.h>
 
 unsigned long idle_halt;
 EXPORT_SYMBOL(idle_halt);
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 14014d7..6822436 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -9,59 +9,55 @@
  * This file handles the architecture-dependent parts of process handling..
  */
 
-#include <stdarg.h>
-
 #include <linux/stackprotector.h>
-#include <linux/cpu.h>
-#include <linux/errno.h>
-#include <linux/sched.h>
-#include <linux/fs.h>
-#include <linux/kernel.h>
-#include <linux/mm.h>
-#include <linux/elfcore.h>
-#include <linux/smp.h>
-#include <linux/stddef.h>
-#include <linux/slab.h>
-#include <linux/vmalloc.h>
-#include <linux/user.h>
+#include <linux/mc146818rtc.h>
+#include <linux/personality.h>
 #include <linux/interrupt.h>
+#include <linux/kallsyms.h>
+#include <linux/elfcore.h>
+#include <linux/uaccess.h>
 #include <linux/utsname.h>
-#include <linux/delay.h>
-#include <linux/reboot.h>
-#include <linux/init.h>
-#include <linux/mc146818rtc.h>
+#include <linux/vmalloc.h>
+#include <linux/ftrace.h>
+#include <linux/kdebug.h>
+#include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/kallsyms.h>
+#include <linux/percpu.h>
 #include <linux/ptrace.h>
 #include <linux/random.h>
-#include <linux/personality.h>
-#include <linux/tick.h>
-#include <linux/percpu.h>
+#include <linux/reboot.h>
+#include <linux/stddef.h>
+#include <linux/delay.h>
+#include <linux/errno.h>
 #include <linux/prctl.h>
+#include <linux/sched.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/tick.h>
+#include <linux/user.h>
+#include <linux/cpu.h>
 #include <linux/dmi.h>
-#include <linux/ftrace.h>
-#include <linux/uaccess.h>
+#include <linux/err.h>
+#include <linux/smp.h>
+#include <linux/fs.h>
 #include <linux/io.h>
-#include <linux/kdebug.h>
+#include <linux/mm.h>
 
-#include <asm/pgtable.h>
-#include <asm/system.h>
-#include <asm/ldt.h>
 #include <asm/processor.h>
-#include <asm/i387.h>
-#include <asm/desc.h>
-#ifdef CONFIG_MATH_EMULATION
 #include <asm/math_emu.h>
-#endif
-
-#include <linux/err.h>
-
+#include <asm/syscalls.h>
 #include <asm/tlbflush.h>
-#include <asm/cpu.h>
+#include <asm/pgtable.h>
+#include <asm/system.h>
+#include <asm/desc.h>
+#include <asm/i387.h>
 #include <asm/idle.h>
-#include <asm/syscalls.h>
+#include <asm/cpu.h>
+#include <asm/ldt.h>
 #include <asm/ds.h>
 
+#include <stdarg.h>
+
 asmlinkage void ret_from_fork(void) __asm__("ret_from_fork");
 
 DEFINE_PER_CPU(struct task_struct *, current_task) = &init_task;
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 1937871..8a33d61 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -7,31 +7,31 @@
  *	Markus Metzger <markus.t.metzger@intel.com>, Dec 2007
  */
 
+#include <linux/tracehook.h>
+#include <linux/security.h>
+#include <linux/seccomp.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
-#include <linux/mm.h>
-#include <linux/smp.h>
-#include <linux/errno.h>
 #include <linux/ptrace.h>
 #include <linux/regset.h>
-#include <linux/tracehook.h>
+#include <linux/signal.h>
+#include <linux/audit.h>
+#include <linux/errno.h>
+#include <linux/sched.h>
 #include <linux/user.h>
 #include <linux/elf.h>
-#include <linux/security.h>
-#include <linux/audit.h>
-#include <linux/seccomp.h>
-#include <linux/signal.h>
+#include <linux/smp.h>
+#include <linux/mm.h>
 
-#include <asm/uaccess.h>
-#include <asm/pgtable.h>
-#include <asm/system.h>
 #include <asm/processor.h>
-#include <asm/i387.h>
 #include <asm/debugreg.h>
-#include <asm/ldt.h>
-#include <asm/desc.h>
+#include <asm/pgtable.h>
+#include <asm/uaccess.h>
+#include <asm/system.h>
 #include <asm/prctl.h>
 #include <asm/proto.h>
+#include <asm/desc.h>
+#include <asm/i387.h>
+#include <asm/ldt.h>
 #include <asm/ds.h>
 
 #include "tls.h"
diff --git a/arch/x86/kernel/quirks.c b/arch/x86/kernel/quirks.c
index 6a5a297..303c6d3 100644
--- a/arch/x86/kernel/quirks.c
+++ b/arch/x86/kernel/quirks.c
@@ -1,9 +1,9 @@
 /*
  * This file contains work-arounds for x86 and x86_64 platform bugs.
  */
-#include <linux/pci.h>
-#include <linux/irq.h>
 
+#include <linux/irq.h>
+#include <linux/pci.h>
 #include <asm/hpet.h>
 
 #if defined(CONFIG_X86_IO_APIC) && defined(CONFIG_SMP) && defined(CONFIG_PCI)
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 2aef36d..fbe594b 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -1,28 +1,26 @@
+#include <linux/mc146818rtc.h>
 #include <linux/module.h>
 #include <linux/reboot.h>
+#include <linux/ctype.h>
 #include <linux/init.h>
-#include <linux/pm.h>
+#include <linux/dmi.h>
 #include <linux/efi.h>
+#include <linux/pm.h>
+
 #include <acpi/reboot.h>
-#include <asm/io.h>
-#include <asm/apic.h>
-#include <asm/desc.h>
-#include <asm/hpet.h>
-#include <asm/pgtable.h>
-#include <asm/proto.h>
+
 #include <asm/reboot_fixups.h>
-#include <asm/reboot.h>
 #include <asm/pci_x86.h>
+#include <asm/pgtable.h>
 #include <asm/virtext.h>
+#include <asm/reboot.h>
+#include <asm/iommu.h>
+#include <asm/proto.h>
+#include <asm/apic.h>
+#include <asm/desc.h>
+#include <asm/hpet.h>
 #include <asm/cpu.h>
-
-#ifdef CONFIG_X86_32
-# include <linux/dmi.h>
-# include <linux/ctype.h>
-# include <linux/mc146818rtc.h>
-#else
-# include <asm/iommu.h>
-#endif
+#include <asm/io.h>
 
 /*
  * Power off function, if any
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index a0d2623..5693f1e 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -21,92 +21,84 @@
  * This file handles the architecture-dependent parts of initialization
  */
 
-#include <linux/sched.h>
-#include <linux/mm.h>
-#include <linux/mmzone.h>
+#include <linux/init_ohci1394_dma.h>
+#include <linux/dma-mapping.h>
 #include <linux/screen_info.h>
-#include <linux/ioport.h>
-#include <linux/acpi.h>
+#include <linux/crash_dump.h>
+#include <linux/iscsi_ibft.h>
 #include <linux/apm_bios.h>
-#include <linux/initrd.h>
-#include <linux/bootmem.h>
+#include <linux/kallsyms.h>
+#include <linux/kvm_para.h>
+#include <linux/nodemask.h>
+#include <linux/root_dev.h>
 #include <linux/seq_file.h>
+#include <linux/bootmem.h>
 #include <linux/console.h>
-#include <linux/mca.h>
-#include <linux/root_dev.h>
+#include <linux/cpufreq.h>
 #include <linux/highmem.h>
-#include <linux/module.h>
-#include <linux/efi.h>
-#include <linux/init.h>
-#include <linux/edd.h>
-#include <linux/iscsi_ibft.h>
-#include <linux/nodemask.h>
-#include <linux/kexec.h>
-#include <linux/dmi.h>
-#include <linux/pfn.h>
-#include <linux/pci.h>
-#include <asm/pci-direct.h>
-#include <linux/init_ohci1394_dma.h>
-#include <linux/kvm_para.h>
-
-#include <linux/errno.h>
+#include <linux/uaccess.h>
+#include <linux/ioport.h>
+#include <linux/initrd.h>
 #include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/mmzone.h>
+#include <linux/percpu.h>
+#include <linux/ptrace.h>
 #include <linux/stddef.h>
 #include <linux/unistd.h>
-#include <linux/ptrace.h>
+#include <linux/ctype.h>
+#include <linux/delay.h>
+#include <linux/errno.h>
+#include <linux/kexec.h>
+#include <linux/sched.h>
+#include <linux/acpi.h>
+#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/user.h>
-#include <linux/delay.h>
-
-#include <linux/kallsyms.h>
-#include <linux/cpufreq.h>
-#include <linux/dma-mapping.h>
-#include <linux/ctype.h>
-#include <linux/uaccess.h>
-
-#include <linux/percpu.h>
-#include <linux/crash_dump.h>
+#include <linux/edd.h>
+#include <linux/efi.h>
+#include <linux/dmi.h>
+#include <linux/pci.h>
+#include <linux/pfn.h>
+#include <linux/mca.h>
+#include <linux/mm.h>
 
 #include <video/edid.h>
 
-#include <asm/mtrr.h>
-#include <asm/apic.h>
-#include <asm/e820.h>
-#include <asm/mpspec.h>
-#include <asm/setup.h>
-#include <asm/efi.h>
-#include <asm/timer.h>
-#include <asm/i8259.h>
-#include <asm/sections.h>
-#include <asm/dmi.h>
-#include <asm/io_apic.h>
-#include <asm/ist.h>
-#include <asm/vmi.h>
+#include <asm/mmu_context.h>
+#include <asm/cacheflush.h>
+#include <asm/hypervisor.h>
+#include <asm/pci-direct.h>
 #include <asm/setup_arch.h>
 #include <asm/bios_ebda.h>
-#include <asm/cacheflush.h>
 #include <asm/processor.h>
-#include <asm/bugs.h>
-
-#include <asm/system.h>
-#include <asm/vsyscall.h>
-#include <asm/cpu.h>
-#include <asm/desc.h>
-#include <asm/dma.h>
-#include <asm/iommu.h>
-#include <asm/gart.h>
-#include <asm/mmu_context.h>
-#include <asm/proto.h>
-
 #include <asm/paravirt.h>
-#include <asm/hypervisor.h>
-
-#include <asm/percpu.h>
+#include <asm/sections.h>
 #include <asm/topology.h>
+#include <asm/vsyscall.h>
 #include <asm/apicdef.h>
-#ifdef CONFIG_X86_64
-#include <asm/numa_64.h>
-#endif
+#include <asm/io_apic.h>
+#include <asm/mpspec.h>
+#include <asm/percpu.h>
+#include <asm/system.h>
+#include <asm/i8259.h>
+#include <asm/iommu.h>
+#include <asm/proto.h>
+#include <asm/setup.h>
+#include <asm/timer.h>
+#include <asm/apic.h>
+#include <asm/bugs.h>
+#include <asm/desc.h>
+#include <asm/e820.h>
+#include <asm/gart.h>
+#include <asm/mtrr.h>
+#include <asm/numa.h>
+#include <asm/cpu.h>
+#include <asm/dma.h>
+#include <asm/dmi.h>
+#include <asm/efi.h>
+#include <asm/ist.h>
+#include <asm/vmi.h>
 
 #ifndef ARCH_SETUP
 #define ARCH_SETUP
diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index 400331b..85e84b4 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -1,23 +1,24 @@
+#include <linux/crash_dump.h>
+#include <linux/topology.h>
+#include <linux/bootmem.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
-#include <linux/bootmem.h>
 #include <linux/percpu.h>
 #include <linux/kexec.h>
-#include <linux/crash_dump.h>
-#include <linux/smp.h>
-#include <linux/topology.h>
+#include <linux/init.h>
 #include <linux/pfn.h>
-#include <asm/sections.h>
+#include <linux/smp.h>
+
+#include <asm/stackprotector.h>
 #include <asm/processor.h>
-#include <asm/setup.h>
-#include <asm/mpspec.h>
+#include <asm/sections.h>
 #include <asm/apicdef.h>
+#include <asm/cpumask.h>
 #include <asm/highmem.h>
+#include <asm/mpspec.h>
 #include <asm/proto.h>
-#include <asm/cpumask.h>
+#include <asm/setup.h>
 #include <asm/cpu.h>
-#include <asm/stackprotector.h>
 
 #ifdef CONFIG_DEBUG_PER_CPU_MAPS
 # define DBG(x...) printk(KERN_DEBUG x)
diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index dfcc74a..e12975d 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -7,35 +7,30 @@
  *  2000-2002   x86-64 support by Andi Kleen
  */
 
-#include <linux/sched.h>
-#include <linux/mm.h>
-#include <linux/smp.h>
+#include <linux/personality.h>
+#include <linux/tracehook.h>
+#include <linux/uaccess.h>
 #include <linux/kernel.h>
+#include <linux/ptrace.h>
 #include <linux/signal.h>
+#include <linux/stddef.h>
+#include <linux/unistd.h>
 #include <linux/errno.h>
+#include <linux/sched.h>
 #include <linux/wait.h>
-#include <linux/ptrace.h>
-#include <linux/tracehook.h>
-#include <linux/unistd.h>
-#include <linux/stddef.h>
-#include <linux/personality.h>
-#include <linux/uaccess.h>
+#include <linux/smp.h>
+#include <linux/mm.h>
 
+#include <asm/ia32_unistd.h>
 #include <asm/processor.h>
+#include <asm/sigframe.h>
+#include <asm/syscalls.h>
 #include <asm/ucontext.h>
+#include <asm/syscall.h>
+#include <asm/proto.h>
 #include <asm/i387.h>
 #include <asm/vdso.h>
-
-#ifdef CONFIG_X86_64
-#include <asm/proto.h>
-#include <asm/ia32_unistd.h>
 #include <asm/mce.h>
-#endif /* CONFIG_X86_64 */
-
-#include <asm/syscall.h>
-#include <asm/syscalls.h>
-
-#include <asm/sigframe.h>
 
 #define _BLOCKABLE (~(sigmask(SIGKILL) | sigmask(SIGSTOP)))
 
diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index 13f33ea..d881655 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -11,22 +11,22 @@
  *	later.
  */
 
-#include <linux/init.h>
-
-#include <linux/mm.h>
-#include <linux/delay.h>
-#include <linux/spinlock.h>
 #include <linux/kernel_stat.h>
 #include <linux/mc146818rtc.h>
-#include <linux/cache.h>
 #include <linux/interrupt.h>
+#include <linux/spinlock.h>
+#include <linux/cache.h>
+#include <linux/delay.h>
+#include <linux/init.h>
 #include <linux/cpu.h>
+#include <linux/mm.h>
 
-#include <asm/mtrr.h>
-#include <asm/tlbflush.h>
 #include <asm/mmu_context.h>
+#include <asm/tlbflush.h>
 #include <asm/proto.h>
 #include <asm/apic.h>
+#include <asm/mtrr.h>
+
 /*
  *	Some notes on x86 processor bugs affecting SMP operation:
  *
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index ef7d101..60f6dde 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -39,33 +39,32 @@
  *	Glauber Costa		:	i386 and x86_64 integration
  */
 
-#include <linux/init.h>
-#include <linux/smp.h>
+#include <linux/mc146818rtc.h>
+#include <linux/bootmem.h>
 #include <linux/module.h>
-#include <linux/sched.h>
 #include <linux/percpu.h>
-#include <linux/bootmem.h>
+#include <linux/sched.h>
+#include <linux/init.h>
 #include <linux/err.h>
 #include <linux/nmi.h>
+#include <linux/smp.h>
 
+#include <asm/smpboot_hooks.h>
+#include <asm/trampoline.h>
+#include <asm/tlbflush.h>
+#include <asm/pgtable.h>
+#include <asm/setup.h>
+#include <asm/uv/uv.h>
 #include <asm/acpi.h>
+#include <asm/apic.h>
 #include <asm/desc.h>
-#include <asm/nmi.h>
-#include <asm/irq.h>
 #include <asm/idle.h>
-#include <asm/trampoline.h>
-#include <asm/cpu.h>
-#include <asm/numa.h>
-#include <asm/pgtable.h>
-#include <asm/tlbflush.h>
 #include <asm/mtrr.h>
+#include <asm/numa.h>
+#include <asm/cpu.h>
+#include <asm/irq.h>
+#include <asm/nmi.h>
 #include <asm/vmi.h>
-#include <asm/apic.h>
-#include <asm/setup.h>
-#include <asm/uv/uv.h>
-#include <linux/mc146818rtc.h>
-
-#include <asm/smpboot_hooks.h>
 
 #ifdef CONFIG_X86_32
 u8 apicid_2_node[MAX_APICID];
diff --git a/arch/x86/kernel/stacktrace.c b/arch/x86/kernel/stacktrace.c
index f7bddc2..397eb1f 100644
--- a/arch/x86/kernel/stacktrace.c
+++ b/arch/x86/kernel/stacktrace.c
@@ -3,10 +3,12 @@
  *
  *  Copyright (C) 2006-2009 Red Hat, Inc., Ingo Molnar <mingo@redhat.com>
  */
-#include <linux/sched.h>
+
 #include <linux/stacktrace.h>
-#include <linux/module.h>
 #include <linux/uaccess.h>
+#include <linux/module.h>
+#include <linux/sched.h>
+
 #include <asm/stacktrace.h>
 
 static void save_stack_warning(void *data, char *msg)
diff --git a/arch/x86/kernel/step.c b/arch/x86/kernel/step.c
index e8b9863..caa27d3 100644
--- a/arch/x86/kernel/step.c
+++ b/arch/x86/kernel/step.c
@@ -1,9 +1,10 @@
 /*
  * x86 single-step support code, common to 32-bit and 64-bit.
  */
+
+#include <linux/ptrace.h>
 #include <linux/sched.h>
 #include <linux/mm.h>
-#include <linux/ptrace.h>
 
 unsigned long convert_ip_to_linear(struct task_struct *child, struct pt_regs *regs)
 {
diff --git a/arch/x86/kernel/sys_i386_32.c b/arch/x86/kernel/sys_i386_32.c
index 1884a8d..287fa4b 100644
--- a/arch/x86/kernel/sys_i386_32.c
+++ b/arch/x86/kernel/sys_i386_32.c
@@ -4,23 +4,22 @@
  * platform.
  */
 
+#include <linux/syscalls.h>
+#include <linux/uaccess.h>
+#include <linux/utsname.h>
+#include <linux/unistd.h>
 #include <linux/errno.h>
 #include <linux/sched.h>
-#include <linux/mm.h>
-#include <linux/fs.h>
-#include <linux/smp.h>
-#include <linux/sem.h>
-#include <linux/msg.h>
-#include <linux/shm.h>
-#include <linux/stat.h>
-#include <linux/syscalls.h>
-#include <linux/mman.h>
 #include <linux/file.h>
-#include <linux/utsname.h>
+#include <linux/mman.h>
+#include <linux/stat.h>
 #include <linux/ipc.h>
-
-#include <linux/uaccess.h>
-#include <linux/unistd.h>
+#include <linux/msg.h>
+#include <linux/sem.h>
+#include <linux/shm.h>
+#include <linux/smp.h>
+#include <linux/fs.h>
+#include <linux/mm.h>
 
 #include <asm/syscalls.h>
 
diff --git a/arch/x86/kernel/time_32.c b/arch/x86/kernel/time_32.c
index 5c5d87f..5ce14b9 100644
--- a/arch/x86/kernel/time_32.c
+++ b/arch/x86/kernel/time_32.c
@@ -28,17 +28,16 @@
  *	serialize accesses to xtime/lost_ticks).
  */
 
-#include <linux/init.h>
 #include <linux/interrupt.h>
+#include <linux/init.h>
 #include <linux/time.h>
 #include <linux/mca.h>
 
+#include <asm/do_timer.h>
 #include <asm/setup.h>
+#include <asm/timer.h>
 #include <asm/hpet.h>
 #include <asm/time.h>
-#include <asm/timer.h>
-
-#include <asm/do_timer.h>
 
 int timer_ack;
 
diff --git a/arch/x86/kernel/tls.c b/arch/x86/kernel/tls.c
index 6bb7b85..944b8ed 100644
--- a/arch/x86/kernel/tls.c
+++ b/arch/x86/kernel/tls.c
@@ -1,16 +1,16 @@
 #include <linux/kernel.h>
+#include <linux/regset.h>
 #include <linux/errno.h>
 #include <linux/sched.h>
 #include <linux/user.h>
-#include <linux/regset.h>
 
+#include <asm/processor.h>
+#include <asm/syscalls.h>
 #include <asm/uaccess.h>
-#include <asm/desc.h>
 #include <asm/system.h>
-#include <asm/ldt.h>
-#include <asm/processor.h>
 #include <asm/proto.h>
-#include <asm/syscalls.h>
+#include <asm/desc.h>
+#include <asm/ldt.h>
 
 #include "tls.h"
 
diff --git a/arch/x86/kernel/trampoline_32.S b/arch/x86/kernel/trampoline_32.S
index 66d874e..9fa45df 100644
--- a/arch/x86/kernel/trampoline_32.S
+++ b/arch/x86/kernel/trampoline_32.S
@@ -28,8 +28,9 @@
  */
 
 #include <linux/linkage.h>
-#include <asm/segment.h>
+
 #include <asm/page_types.h>
+#include <asm/segment.h>
 
 /* We can free up trampoline after bootup if cpu hotplug is not supported. */
 #ifndef CONFIG_HOTPLUG_CPU
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index a1d2883..4f1e6cf 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -15,6 +15,7 @@
 #include <linux/kprobes.h>
 #include <linux/uaccess.h>
 #include <linux/utsname.h>
+#include <linux/ioport.h>
 #include <linux/kdebug.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -25,47 +26,34 @@
 #include <linux/kexec.h>
 #include <linux/sched.h>
 #include <linux/timer.h>
+#include <linux/edac.h>
+#include <linux/eisa.h>
 #include <linux/init.h>
 #include <linux/bug.h>
+#include <linux/mca.h>
 #include <linux/nmi.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
 #include <linux/io.h>
 
-#ifdef CONFIG_EISA
-#include <linux/ioport.h>
-#include <linux/eisa.h>
-#endif
-
-#ifdef CONFIG_MCA
-#include <linux/mca.h>
-#endif
-
-#if defined(CONFIG_EDAC)
-#include <linux/edac.h>
-#endif
-
+#include <asm/processor-flags.h>
+#include <asm/mach_traps.h>
 #include <asm/stacktrace.h>
 #include <asm/processor.h>
 #include <asm/debugreg.h>
+#include <asm/pgalloc.h>
 #include <asm/atomic.h>
 #include <asm/system.h>
-#include <asm/traps.h>
-#include <asm/desc.h>
-#include <asm/i387.h>
-
-#include <asm/mach_traps.h>
-
-#ifdef CONFIG_X86_64
-#include <asm/pgalloc.h>
 #include <asm/proto.h>
-#else
-#include <asm/processor-flags.h>
 #include <asm/setup.h>
 #include <asm/traps.h>
+#include <asm/desc.h>
+#include <asm/i387.h>
 
 #include "cpu/mcheck/mce.h"
 
+#ifndef CONFIG_X86_64
+
 asmlinkage int system_call(void);
 
 /* Do we ignore FPU interrupts ? */
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 462b9ba..6598ef0 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -1,21 +1,21 @@
+#include <linux/clocksource.h>
+#include <linux/acpi_pmtmr.h>
+#include <linux/cpufreq.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
-#include <linux/init.h>
 #include <linux/module.h>
+#include <linux/percpu.h>
+#include <linux/delay.h>
+#include <linux/sched.h>
 #include <linux/timer.h>
-#include <linux/acpi_pmtmr.h>
-#include <linux/cpufreq.h>
+#include <linux/init.h>
 #include <linux/dmi.h>
-#include <linux/delay.h>
-#include <linux/clocksource.h>
-#include <linux/percpu.h>
 
-#include <asm/hpet.h>
+#include <asm/hypervisor.h>
+#include <asm/delay.h>
 #include <asm/timer.h>
 #include <asm/vgtod.h>
+#include <asm/hpet.h>
 #include <asm/time.h>
-#include <asm/delay.h>
-#include <asm/hypervisor.h>
 
 unsigned int cpu_khz;           /* TSC clocks / usec, not used here */
 EXPORT_SYMBOL(cpu_khz);
diff --git a/arch/x86/kernel/tsc_sync.c b/arch/x86/kernel/tsc_sync.c
index bf36328..0bac99f 100644
--- a/arch/x86/kernel/tsc_sync.c
+++ b/arch/x86/kernel/tsc_sync.c
@@ -17,8 +17,8 @@
 #include <linux/spinlock.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
-#include <linux/smp.h>
 #include <linux/nmi.h>
+#include <linux/smp.h>
 #include <asm/tsc.h>
 
 /*
diff --git a/arch/x86/kernel/vm86_32.c b/arch/x86/kernel/vm86_32.c
index d7ac84e..c05a2c1 100644
--- a/arch/x86/kernel/vm86_32.c
+++ b/arch/x86/kernel/vm86_32.c
@@ -29,24 +29,24 @@
  */
 
 #include <linux/capability.h>
-#include <linux/errno.h>
 #include <linux/interrupt.h>
-#include <linux/sched.h>
+#include <linux/highmem.h>
 #include <linux/kernel.h>
+#include <linux/ptrace.h>
 #include <linux/signal.h>
+#include <linux/stddef.h>
 #include <linux/string.h>
-#include <linux/mm.h>
-#include <linux/smp.h>
-#include <linux/highmem.h>
-#include <linux/ptrace.h>
 #include <linux/audit.h>
-#include <linux/stddef.h>
+#include <linux/errno.h>
+#include <linux/sched.h>
+#include <linux/smp.h>
+#include <linux/mm.h>
 
-#include <asm/uaccess.h>
-#include <asm/io.h>
+#include <asm/syscalls.h>
 #include <asm/tlbflush.h>
+#include <asm/uaccess.h>
 #include <asm/irq.h>
-#include <asm/syscalls.h>
+#include <asm/io.h>
 
 /*
  * Known problems:
diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index 2b54fe0..778ed67 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -3,12 +3,11 @@
  *
  * Author: Suresh Siddha <suresh.b.siddha@intel.com>
  */
+
+#include <asm/sigcontext32.h>
 #include <linux/bootmem.h>
 #include <linux/compat.h>
 #include <asm/i387.h>
-#ifdef CONFIG_IA32_EMULATION
-#include <asm/sigcontext32.h>
-#endif
 #include <asm/xcr.h>
 
 /*


