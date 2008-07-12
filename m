Return-Path: <linux-kernel-owner+w=401wt.eu-S1755395AbYGLQVK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395AbYGLQVK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 12:21:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754290AbYGLQUs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 12:20:48 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43537 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882AbYGLQUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 12:20:44 -0400
Subject: [PATCH] x86-kernel: fix sparse warnings
From: Jaswinder Singh <jaswinder@infradead.org>
To: LKML <linux-kernel@vger.kernel.org>,
       kernelnewbies <kernelnewbies@nl.linux.org>,
       kernel-janitors <kernel-janitors@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain; charset=utf8
Date: Sat, 12 Jul 2008 21:50:07 +0530
Message-Id: <1215879607.19076.36.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

﻿I am trying to solve following sparse warnings. Please give me feedback
for the Patch. You can also find updated sparse patches from
http://git.infradead.org/users/jaswinder/sparse-2.6.git

CHECK   arch/x86/kernel/process_32.c
arch/x86/kernel/process_32.c:69:1: warning: symbol 'per_cpu__cpu_number' was not declared. Should it be static?
arch/x86/kernel/process_32.c:671:16: warning: symbol 'sys_fork' was not declared. Should it be static?
arch/x86/kernel/process_32.c:676:16: warning: symbol 'sys_clone' was not declared. Should it be static?
arch/x86/kernel/process_32.c:701:16: warning: symbol 'sys_vfork' was not declared. Should it be static?
arch/x86/kernel/process_32.c:709:16: warning: symbol 'sys_execve' was not declared. Should it be static?

CHECK   arch/x86/kernel/signal_32.c
arch/x86/kernel/signal_32.c:49:1: warning: symbol 'sys_sigsuspend' was not declared. Should it be static?
arch/x86/kernel/signal_32.c:66:1: warning: symbol 'sys_sigaction' was not declared. Should it be static?
arch/x86/kernel/signal_32.c:100:16: warning: symbol 'sys_sigaltstack' was not declared. Should it be static?
arch/x86/kernel/signal_32.c:186:26: warning: symbol 'sys_sigreturn' was not declared. Should it be static?
arch/x86/kernel/signal_32.c:229:16: warning: symbol 'sys_rt_sigreturn' was not declared. Should it be static?
arch/x86/kernel/signal_32.c:658:1: warning: symbol 'do_notify_resume' was not declared. Should it be static?

CHECK   arch/x86/kernel/traps_32.c
arch/x86/kernel/traps_32.c:759:24: warning: symbol 'die_nmi' was not declared. Should it be static?
arch/x86/kernel/traps_32.c:974:6: warning: symbol 'math_error' was not declared. Should it be static?
arch/x86/kernel/traps_32.c:1034:6: warning: symbol 'do_coprocessor_error' was not declared. Should it be static?
arch/x86/kernel/traps_32.c:1118:15: warning: symbol 'patch_espfix_desc' was not declared. Should it be static?
arch/x86/kernel/traps_32.c:1176:17: warning: symbol 'math_emulate' was not declared. Should it be static?

CHECK   arch/x86/kernel/time_32.c
arch/x86/kernel/time_32.c:45:5: warning: symbol 'timer_ack' was not declared. Should it be static?
arch/x86/kernel/time_32.c:134:13: warning: symbol 'time_init' was not declared. Should it be static?

CHECK   arch/x86/kernel/ioport.c
arch/x86/kernel/ioport.c:133:17: warning: symbol 'sys_iopl' was not declared. Should it be static?

CHECK   arch/x86/kernel/ldt.c
arch/x86/kernel/ldt.c:241:16: warning: symbol 'sys_modify_ldt' was not declared. Should it be static?

CHECK   arch/x86/kernel/setup_32.c
arch/x86/kernel/setup_32.c:344:16: warning: symbol 'max_low_pfn' shadows an earlier one
include/linux/bootmem.h:14:22: originally declared here
arch/x86/kernel/setup_32.c:761:16: warning: symbol 'max_low_pfn' shadows an earlier one
include/linux/bootmem.h:14:22: originally declared here
arch/x86/kernel/setup_32.c:202:15: warning: symbol 'saved_video_mode' was not declared. Should it be static?
arch/x86/kernel/setup_32.c:240:16: warning: symbol 'user_defined_memmap' was not declared. Should it be static?
arch/x86/kernel/setup_32.c:342:22: warning: symbol 'find_max_low_pfn' was not declared. Should it be static?
arch/x86/kernel/setup_32.c:649:13: warning: symbol 'setup_bootmem_allocator' was not declared. Should it be static?

CHECK   arch/x86/kernel/sys_i386_32.c
arch/x86/kernel/sys_i386_32.c:25:17: warning: symbol 'sys_mmap2' was not declared. Should it be static?
arch/x86/kernel/sys_i386_32.c:66:16: warning: symbol 'old_mmap' was not declared. Should it be static?
arch/x86/kernel/sys_i386_32.c:91:16: warning: symbol 'old_select' was not declared. Should it be static?
arch/x86/kernel/sys_i386_32.c:106:16: warning: symbol 'sys_ipc' was not declared. Should it be static?
arch/x86/kernel/sys_i386_32.c:189:16: warning: symbol 'sys_uname' was not declared. Should it be static?
arch/x86/kernel/sys_i386_32.c:200:16: warning: symbol 'sys_olduname' was not declared. Should it be static?

CHECK   arch/x86/kernel/e820_32.c
arch/x86/kernel/e820_32.c:29:15: warning: symbol 'pci_mem_start' was not declared. Should it be static?

CHECK   arch/x86/kernel/pci-dma.c
arch/x86/kernel/pci-dma.c:35:5: warning: symbol 'iommu_bio_merge' was not declared. Should it be static?
arch/x86/kernel/pci-dma.c:228:26: warning: incorrect type in assignment (different address spaces)
arch/x86/kernel/pci-dma.c:228:26:    expected void *virt_base
arch/x86/kernel/pci-dma.c:228:26:    got void [noderef] <asn:2>*[assigned] mem_base
arch/x86/kernel/pci-dma.c:360:22: warning: symbol 'dma_alloc_pages' was not declared. Should it be static?

CHECK   arch/x86/kernel/pci-nommu.c
arch/x86/kernel/pci-nommu.c:86:30: warning: symbol 'nommu_dma_ops' was not declared. Should it be static?

CHECK   arch/x86/kernel/i387.c
arch/x86/kernel/i387.c:524:5: warning: symbol 'dump_fpu' was not declared. Should it be static?

CHECK   arch/x86/kernel/ptrace.c
arch/x86/kernel/ptrace.c:78:19: warning: incorrect type in return expression (different signedness)
arch/x86/kernel/ptrace.c:78:19:    expected long *
arch/x86/kernel/ptrace.c:78:19:    got unsigned long *
arch/x86/kernel/ptrace.c:1383:5: warning: symbol 'do_syscall_trace' was not declared. Should it be static?

CHECK   arch/x86/kernel/tls.c
arch/x86/kernel/tls.c:92:16: warning: symbol 'sys_set_thread_area' was not declared. Should it be static?
arch/x86/kernel/tls.c:142:16: warning: symbol 'sys_get_thread_area' was not declared. Should it be static?

CHECK   arch/x86/kernel/acpi/boot.c
arch/x86/kernel/acpi/boot.c:341:26: warning: symbol 'mp_ioapic_routing' was not declared. Should it be static?

CHECK   arch/x86/kernel/cpu/proc.c
arch/x86/kernel/cpu/proc.c:178:29: warning: symbol 'cpuinfo_op' was not declared. Should it be static?

CHECK   arch/x86/kernel/cpu/common.c
arch/x86/kernel/cpu/common.c:620:13: warning: symbol 'early_cpu_init' was not declared. Should it be static?
arch/x86/kernel/cpu/common.c:634:16: warning: symbol 'idle_regs' was not declared. Should it be static?

CHECK   arch/x86/kernel/cpu/mtrr/generic.c
arch/x86/kernel/cpu/mtrr/generic.c:216:12: warning: symbol 'lo' shadows an earlier one
arch/x86/kernel/cpu/mtrr/generic.c:198:11: originally declared here

CHECK   arch/x86/kernel/mpparse.c
arch/x86/kernel/mpparse.c:676:13: warning: symbol 'early_get_smp_config' was not declared. Should it be static?
arch/x86/kernel/mpparse.c:783:13: warning: symbol 'early_find_smp_config' was not declared. Should it be static?

CHECK   arch/x86/kernel/apic_32.c
arch/x86/kernel/apic_32.c:603:6: warning: symbol 'smp_apic_timer_interrupt' was not declared. Should it be static?
arch/x86/kernel/apic_32.c:624:5: warning: symbol 'setup_profiling_timer' was not declared. Should it be static?
arch/x86/kernel/apic_32.c:1290:6: warning: symbol 'smp_spurious_interrupt' was not declared. Should it be static?
arch/x86/kernel/apic_32.c:1314:6: warning: symbol 'smp_error_interrupt' was not declared. Should it be static?
arch/x86/kernel/apic_32.c:1470:28: warning: symbol 'maxcpus' was not declared. Should it be static?

CHECK   arch/x86/kernel/vsmp_64.c
arch/x86/kernel/vsmp_64.c:126:5: warning: symbol 'is_vsmp_box' was not declared. Should it be static?
arch/x86/kernel/vsmp_64.c:145:13: warning: symbol 'vsmp_init' was not declared. Should it be static?

CHECK   arch/x86/kernel/vm86_32.c
arch/x86/kernel/vm86_32.c:199:16: warning: symbol 'sys_vm86old' was not declared. Should it be static?
arch/x86/kernel/vm86_32.c:229:16: warning: symbol 'sys_vm86' was not declared. Should it be static?

CHECK   arch/x86/kernel/head32.c
arch/x86/kernel/head32.c:11:13: warning: symbol 'i386_start_kernel' was not declared. Should it be static?

Signed-off-by: Jaswinder Singh <jaswinder@infradead.org>
---
 arch/x86/kernel/cpu/mtrr/generic.c        |    8 ++--
 arch/x86/kernel/head32.c                  |    1 +
 arch/x86/kernel/ldt.c                     |    1 +
 arch/x86/kernel/pci-dma.c                 |    2 +-
 arch/x86/kernel/process_32.c              |    1 +
 arch/x86/kernel/ptrace.c                  |    2 +-
 arch/x86/kernel/setup_32.c                |   22 +++++-----
 arch/x86/kernel/signal_32.c               |    1 +
 arch/x86/kernel/tls.c                     |    1 +
 arch/x86/kernel/vm86_32.c                 |    1 +
 include/asm-x86/apic.h                    |    6 +++
 include/asm-x86/cpu.h                     |    1 +
 include/asm-x86/current_32.h              |    2 +
 include/asm-x86/dma-mapping.h             |    1 +
 include/asm-x86/dma.h                     |    4 +-
 include/asm-x86/e820_32.h                 |    2 +
 include/asm-x86/i387.h                    |    1 +
 include/asm-x86/io_apic.h                 |    2 +
 include/asm-x86/mach-default/mach_traps.h |    9 ++++
 include/asm-x86/mpspec.h                  |    3 +
 include/asm-x86/pci-direct.h              |    4 ++
 include/asm-x86/processor.h               |    5 ++
 include/asm-x86/ptrace.h                  |    2 +
 include/asm-x86/setup.h                   |    8 ++++
 include/asm-x86/signal.h                  |    3 +
 include/asm-x86/syscalls.h                |   58 +++++++++++++++++++++++++++++
 include/asm-x86/time.h                    |    3 +
 include/linux/syscalls.h                  |    4 ++
 28 files changed, 140 insertions(+), 18 deletions(-)
 create mode 100644 include/asm-x86/syscalls.h

diff --git a/arch/x86/kernel/cpu/mtrr/generic.c b/arch/x86/kernel/cpu/mtrr/generic.c
index 5d241ce..c8eb5f6 100644
--- a/arch/x86/kernel/cpu/mtrr/generic.c
+++ b/arch/x86/kernel/cpu/mtrr/generic.c
@@ -213,12 +213,12 @@ void __init get_mtrr_state(void)
 	mtrr_state.enabled = (lo & 0xc00) >> 10;
 
 	if (amd_special_default_mtrr()) {
-		unsigned lo, hi;
+		unsigned mlo, mhi;
 		/* TOP_MEM2 */
-		rdmsr(MSR_K8_TOP_MEM2, lo, hi);
-		tom2 = hi;
+		rdmsr(MSR_K8_TOP_MEM2, mlo, mhi);
+		tom2 = mhi;
 		tom2 <<= 32;
-		tom2 |= lo;
+		tom2 |= mlo;
 		tom2 &= 0xffffff8000000ULL;
 	}
 	if (mtrr_show) {
diff --git a/arch/x86/kernel/head32.c b/arch/x86/kernel/head32.c
index 3db0590..76c002c 100644
--- a/arch/x86/kernel/head32.c
+++ b/arch/x86/kernel/head32.c
@@ -7,6 +7,7 @@
 
 #include <linux/init.h>
 #include <linux/start_kernel.h>
+#include <asm/setup.h>
 
 void __init i386_start_kernel(void)
 {
diff --git a/arch/x86/kernel/ldt.c b/arch/x86/kernel/ldt.c
index 0224c36..40f0de5 100644
--- a/arch/x86/kernel/ldt.c
+++ b/arch/x86/kernel/ldt.c
@@ -12,6 +12,7 @@
 #include <linux/mm.h>
 #include <linux/smp.h>
 #include <linux/vmalloc.h>
+#include <linux/syscalls.h>
 
 #include <asm/uaccess.h>
 #include <asm/system.h>
diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index dc00a13..1ff2dcf 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -225,7 +225,7 @@ int dma_declare_coherent_memory(struct device *dev, dma_addr_t bus_addr,
 	if (!dev->dma_mem->bitmap)
 		goto free1_out;
 
-	dev->dma_mem->virt_base = mem_base;
+	dev->dma_mem->virt_base = (void *)mem_base;
 	dev->dma_mem->device_base = device_addr;
 	dev->dma_mem->size = pages;
 	dev->dma_mem->flags = flags;
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index e2db9ac..136fb73 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -37,6 +37,7 @@
 #include <linux/tick.h>
 #include <linux/percpu.h>
 #include <linux/prctl.h>
+#include <linux/syscalls.h>
 
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index a7835f2..38e6452 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -75,7 +75,7 @@ static long *pt_regs_access(struct pt_regs *regs, unsigned long regno)
 	regno >>= 2;
 	if (regno > FS)
 		--regno;
-	return &regs->bx + regno;
+	return (long *)&regs->bx + regno;
 }
 
 static u16 get_segment_reg(struct task_struct *task, unsigned long offset)
diff --git a/arch/x86/kernel/setup_32.c b/arch/x86/kernel/setup_32.c
index 5a2f8e0..d44c2dc 100644
--- a/arch/x86/kernel/setup_32.c
+++ b/arch/x86/kernel/setup_32.c
@@ -341,10 +341,10 @@ early_param("reservetop", parse_reservetop);
  */
 unsigned long __init find_max_low_pfn(void)
 {
-	unsigned long max_low_pfn;
+	unsigned long maxlow_pfn;
 
-	max_low_pfn = max_pfn;
-	if (max_low_pfn > MAXMEM_PFN) {
+	maxlow_pfn = max_pfn;
+	if (maxlow_pfn > MAXMEM_PFN) {
 		if (highmem_pages == -1)
 			highmem_pages = max_pfn - MAXMEM_PFN;
 		if (highmem_pages + MAXMEM_PFN < max_pfn)
@@ -353,7 +353,7 @@ unsigned long __init find_max_low_pfn(void)
 			printk("only %luMB highmem pages available, ignoring highmem size of %uMB.\n", pages_to_mb(max_pfn - MAXMEM_PFN), pages_to_mb(highmem_pages));
 			highmem_pages = 0;
 		}
-		max_low_pfn = MAXMEM_PFN;
+		maxlow_pfn = MAXMEM_PFN;
 #ifndef CONFIG_HIGHMEM
 		/* Maximum memory usable is what is directly addressable */
 		printk(KERN_WARNING "Warning only %ldMB will be used.\n",
@@ -381,18 +381,19 @@ unsigned long __init find_max_low_pfn(void)
 			highmem_pages = 0;
 		}
 		if (highmem_pages) {
-			if (max_low_pfn-highmem_pages < 64*1024*1024/PAGE_SIZE){
+			if (maxlow_pfn-highmem_pages <
+			    64*1024*1024/PAGE_SIZE){
 				printk(KERN_ERR "highmem size %uMB results in smaller than 64MB lowmem, ignoring it.\n", pages_to_mb(highmem_pages));
 				highmem_pages = 0;
 			}
-			max_low_pfn -= highmem_pages;
+			maxlow_pfn -= highmem_pages;
 		}
 #else
 		if (highmem_pages)
 			printk(KERN_ERR "ignoring highmem size on non-highmem kernel!\n");
 #endif
 	}
-	return max_low_pfn;
+	return maxlow_pfn;
 }
 
 #define BIOS_LOWMEM_KILOBYTES 0x413
@@ -446,7 +447,6 @@ static void __init reserve_ebda_region(void)
 }
 
 #ifndef CONFIG_NEED_MULTIPLE_NODES
-static void __init setup_bootmem_allocator(void);
 static unsigned long __init setup_memory(void)
 {
 	/*
@@ -758,7 +758,7 @@ DEFINE_PER_CPU(int, x86_cpu_to_node_map) = NUMA_NO_NODE;
  */
 void __init setup_arch(char **cmdline_p)
 {
-	unsigned long max_low_pfn;
+	unsigned long smax_low_pfn;
 
 	memcpy(&boot_cpu_data, &new_cpu_data, sizeof(new_cpu_data));
 	pre_setup_arch_hook();
@@ -830,7 +830,7 @@ void __init setup_arch(char **cmdline_p)
 	if (mtrr_trim_uncached_memory(max_pfn))
 		propagate_e820_map();
 
-	max_low_pfn = setup_memory();
+	smax_low_pfn = setup_memory();
 
 #ifdef CONFIG_KVM_CLOCK
 	kvmclock_init();
@@ -838,7 +838,7 @@ void __init setup_arch(char **cmdline_p)
 
 #ifdef CONFIG_VMI
 	/*
-	 * Must be after max_low_pfn is determined, and before kernel
+	 * Must be after smax_low_pfn is determined, and before kernel
 	 * pagetables are setup.
 	 */
 	vmi_init();
diff --git a/arch/x86/kernel/signal_32.c b/arch/x86/kernel/signal_32.c
index d923736..954a3b8 100644
--- a/arch/x86/kernel/signal_32.c
+++ b/arch/x86/kernel/signal_32.c
@@ -20,6 +20,7 @@
 #include <linux/elf.h>
 #include <linux/smp.h>
 #include <linux/mm.h>
+#include <linux/syscalls.h>
 
 #include <asm/processor.h>
 #include <asm/ucontext.h>
diff --git a/arch/x86/kernel/tls.c b/arch/x86/kernel/tls.c
index ab6bf37..90bc24c 100644
--- a/arch/x86/kernel/tls.c
+++ b/arch/x86/kernel/tls.c
@@ -3,6 +3,7 @@
 #include <linux/sched.h>
 #include <linux/user.h>
 #include <linux/regset.h>
+#include <linux/syscalls.h>
 
 #include <asm/uaccess.h>
 #include <asm/desc.h>
diff --git a/arch/x86/kernel/vm86_32.c b/arch/x86/kernel/vm86_32.c
index 38f566f..d77e312 100644
--- a/arch/x86/kernel/vm86_32.c
+++ b/arch/x86/kernel/vm86_32.c
@@ -41,6 +41,7 @@
 #include <linux/ptrace.h>
 #include <linux/audit.h>
 #include <linux/stddef.h>
+#include <linux/syscalls.h>
 
 #include <asm/uaccess.h>
 #include <asm/io.h>
diff --git a/include/asm-x86/apic.h b/include/asm-x86/apic.h
index be9639a..0570bc8 100644
--- a/include/asm-x86/apic.h
+++ b/include/asm-x86/apic.h
@@ -125,6 +125,12 @@ extern void enable_NMI_through_LVT0(void);
  */
 #ifdef CONFIG_X86_64
 extern void early_init_lapic_mapping(void);
+#else
+extern unsigned int __cpuinitdata maxcpus;
+extern void smp_apic_timer_interrupt(struct pt_regs *);
+extern int setup_profiling_timer(unsigned int);
+extern void smp_spurious_interrupt(struct pt_regs *);
+extern void smp_error_interrupt(struct pt_regs *);
 #endif
 
 extern u8 setup_APIC_eilvt_mce(u8 vector, u8 msg_type, u8 mask);
diff --git a/include/asm-x86/cpu.h b/include/asm-x86/cpu.h
index 73f2ea8..3089257 100644
--- a/include/asm-x86/cpu.h
+++ b/include/asm-x86/cpu.h
@@ -17,4 +17,5 @@ extern void arch_unregister_cpu(int);
 #endif
 
 DECLARE_PER_CPU(int, cpu_state);
+
 #endif /* _ASM_I386_CPU_H_ */
diff --git a/include/asm-x86/current_32.h b/include/asm-x86/current_32.h
index 5af9bdb..e48a3ad 100644
--- a/include/asm-x86/current_32.h
+++ b/include/asm-x86/current_32.h
@@ -12,6 +12,8 @@ static __always_inline struct task_struct *get_current(void)
 	return x86_read_percpu(current_task);
 }
 
+DECLARE_PER_CPU(int, cpu_number);
+
 #define current get_current()
 
 #endif /* !(_I386_CURRENT_H) */
diff --git a/include/asm-x86/dma-mapping.h b/include/asm-x86/dma-mapping.h
index a1a4dc7..1c9fc36 100644
--- a/include/asm-x86/dma-mapping.h
+++ b/include/asm-x86/dma-mapping.h
@@ -58,6 +58,7 @@ struct dma_mapping_ops {
 };
 
 extern const struct dma_mapping_ops *dma_ops;
+extern const struct dma_mapping_ops nommu_dma_ops;
 
 static inline int dma_mapping_error(dma_addr_t dma_addr)
 {
diff --git a/include/asm-x86/dma.h b/include/asm-x86/dma.h
index ca1098a..d58cdaa 100644
--- a/include/asm-x86/dma.h
+++ b/include/asm-x86/dma.h
@@ -150,7 +150,9 @@
 
 #define DMA_AUTOINIT		0x10
 
-
+extern int iommu_bio_merge;
+struct device;
+struct page *dma_alloc_pages(struct device *, gfp_t, unsigned);
 extern spinlock_t  dma_spin_lock;
 
 static inline unsigned long claim_dma_lock(void)
diff --git a/include/asm-x86/e820_32.h b/include/asm-x86/e820_32.h
index a9f7c6e..ea5afab 100644
--- a/include/asm-x86/e820_32.h
+++ b/include/asm-x86/e820_32.h
@@ -18,6 +18,8 @@
 
 #ifndef __ASSEMBLY__
 
+extern unsigned long pci_mem_start;
+
 extern struct e820map e820;
 extern void update_e820(void);
 
diff --git a/include/asm-x86/i387.h b/include/asm-x86/i387.h
index 37672f7..4878989 100644
--- a/include/asm-x86/i387.h
+++ b/include/asm-x86/i387.h
@@ -24,6 +24,7 @@ extern void mxcsr_feature_mask_init(void);
 extern int init_fpu(struct task_struct *child);
 extern asmlinkage void math_state_restore(void);
 extern void init_thread_xstate(void);
+extern int dump_fpu(struct pt_regs *, struct user_i387_struct *);
 
 extern user_regset_active_fn fpregs_active, xfpregs_active;
 extern user_regset_get_fn fpregs_get, xfpregs_get, fpregs_soft_get;
diff --git a/include/asm-x86/io_apic.h b/include/asm-x86/io_apic.h
index d593e14..7f0ed6d 100644
--- a/include/asm-x86/io_apic.h
+++ b/include/asm-x86/io_apic.h
@@ -122,6 +122,8 @@ struct mp_ioapic_routing {
 /* I/O APIC entries */
 extern struct mpc_config_ioapic mp_ioapics[MAX_IO_APICS];
 
+extern struct mp_ioapic_routing mp_ioapic_routing[MAX_IO_APICS];
+
 /* # of MP IRQ source entries */
 extern int mp_irq_entries;
 
diff --git a/include/asm-x86/mach-default/mach_traps.h b/include/asm-x86/mach-default/mach_traps.h
index 2fe7705..5e8caf8 100644
--- a/include/asm-x86/mach-default/mach_traps.h
+++ b/include/asm-x86/mach-default/mach_traps.h
@@ -36,4 +36,13 @@ static inline void reassert_nmi(void)
 		unlock_cmos();
 }
 
+/* traps */
+#include <linux/kprobes.h>
+
+void notrace __kprobes die_nmi(struct pt_regs *, const char *);
+void math_error(void __user *);
+void do_coprocessor_error(struct pt_regs *, long);
+unsigned long patch_espfix_desc(unsigned long , unsigned long);
+asmlinkage extern void math_emulate(long);
+
 #endif /* !_MACH_TRAPS_H */
diff --git a/include/asm-x86/mpspec.h b/include/asm-x86/mpspec.h
index 57a991b..e1699ef 100644
--- a/include/asm-x86/mpspec.h
+++ b/include/asm-x86/mpspec.h
@@ -42,6 +42,9 @@ extern unsigned long mp_lapic_addr;
 extern void find_smp_config(void);
 extern void get_smp_config(void);
 
+extern void __init early_get_smp_config(void);
+extern void __init early_find_smp_config(void);
+
 void __cpuinit generic_processor_info(int apicid, int version);
 #ifdef CONFIG_ACPI
 extern void mp_register_ioapic(int id, u32 address, u32 gsi_base);
diff --git a/include/asm-x86/pci-direct.h b/include/asm-x86/pci-direct.h
index 5b21485..76704b3 100644
--- a/include/asm-x86/pci-direct.h
+++ b/include/asm-x86/pci-direct.h
@@ -14,4 +14,8 @@ extern void write_pci_config_byte(u8 bus, u8 slot, u8 func, u8 offset, u8 val);
 
 extern int early_pci_allowed(void);
 
+/* vsmp */
+extern int is_vsmp_box(void);
+extern void __init vsmp_init(void);
+
 #endif
diff --git a/include/asm-x86/processor.h b/include/asm-x86/processor.h
index 5591052..01e3392 100644
--- a/include/asm-x86/processor.h
+++ b/include/asm-x86/processor.h
@@ -128,6 +128,8 @@ struct cpuinfo_x86 {
 extern struct cpuinfo_x86	boot_cpu_data;
 extern struct cpuinfo_x86	new_cpu_data;
 
+extern const struct seq_operations cpuinfo_op;
+
 extern struct tss_struct	doublefault_tss;
 extern __u32			cleared_cpu_caps[NCAPINTS];
 
@@ -140,6 +142,9 @@ DECLARE_PER_CPU(struct cpuinfo_x86, cpu_info);
 #define current_cpu_data	boot_cpu_data
 #endif
 
+extern void __init early_cpu_init(void);
+extern struct pt_regs * __cpuinit idle_regs(struct pt_regs *);
+
 static inline int hlt_works(int cpu)
 {
 #ifdef CONFIG_X86_32
diff --git a/include/asm-x86/ptrace.h b/include/asm-x86/ptrace.h
index 9f922b0..c99e58e 100644
--- a/include/asm-x86/ptrace.h
+++ b/include/asm-x86/ptrace.h
@@ -139,6 +139,8 @@ extern unsigned long profile_pc(struct pt_regs *regs);
 extern unsigned long
 convert_ip_to_linear(struct task_struct *child, struct pt_regs *regs);
 
+int do_syscall_trace(struct pt_regs *, int);
+
 #ifdef CONFIG_X86_32
 extern void send_sigtrap(struct task_struct *tsk, struct pt_regs *regs,
 			 int error_code);
diff --git a/include/asm-x86/setup.h b/include/asm-x86/setup.h
index fa6763a..b9b6494 100644
--- a/include/asm-x86/setup.h
+++ b/include/asm-x86/setup.h
@@ -9,6 +9,14 @@
 void vsmp_init(void);
 
 char *machine_specific_memory_setup(void);
+
+extern unsigned long saved_video_mode;
+extern int user_defined_memmap;
+extern unsigned long find_max_low_pfn(void);
+extern void setup_bootmem_allocator(void);
+
+extern void i386_start_kernel(void);
+
 #ifndef CONFIG_PARAVIRT
 #define paravirt_post_allocator_init()	do {} while (0)
 #endif
diff --git a/include/asm-x86/signal.h b/include/asm-x86/signal.h
index f15186d..ef04025 100644
--- a/include/asm-x86/signal.h
+++ b/include/asm-x86/signal.h
@@ -140,6 +140,9 @@ struct sigaction {
 struct k_sigaction {
 	struct sigaction sa;
 };
+
+void do_notify_resume(struct pt_regs *, void *, __u32);
+
 # else /* __KERNEL__ */
 /* Here we must cater to libcs that poke about in kernel headers.  */
 
diff --git a/include/asm-x86/syscalls.h b/include/asm-x86/syscalls.h
new file mode 100644
index 0000000..5a5b9a6
--- /dev/null
+++ b/include/asm-x86/syscalls.h
@@ -0,0 +1,58 @@
+#ifndef _ASM_X86_SYSCALLS_H
+#define _ASM_X86_SYSCALLS_H
+#ifdef __KERNEL__
+
+#include <linux/compiler.h>
+#include <linux/linkage.h>
+#include <linux/types.h>
+#include <linux/signal.h>
+
+/* kernel/process_32.c */
+asmlinkage int sys_fork(struct pt_regs);
+asmlinkage int sys_clone(struct pt_regs);
+asmlinkage int sys_vfork(struct pt_regs);
+asmlinkage int sys_execve(struct pt_regs);
+
+/* kernel/signal_32.c */
+asmlinkage int sys_sigsuspend(int, int, old_sigset_t);
+asmlinkage int sys_sigaction(int, const struct old_sigaction __user *,
+			     struct old_sigaction __user *);
+asmlinkage int sys_sigaltstack(unsigned long);
+asmlinkage unsigned long sys_sigreturn(unsigned long);
+asmlinkage int sys_rt_sigreturn(unsigned long);
+
+/* kernel/ioport.c */
+asmlinkage long sys_ioperm(unsigned long, unsigned long, int);
+#ifdef CONFIG_X86_32
+asmlinkage long sys_iopl(unsigned long);
+#else
+asmlinkage long sys_iopl(unsigned int, struct pt_regs *);
+#endif
+
+/* kernel/ldt.c */
+asmlinkage int sys_modify_ldt(int, void __user *, unsigned long);
+
+/* kernel/sys_i386_32.c */
+asmlinkage long sys_mmap2(unsigned long, unsigned long,
+			  unsigned long, unsigned long,
+			  unsigned long, unsigned long);
+struct mmap_arg_struct;
+asmlinkage int old_mmap(struct mmap_arg_struct __user *);
+struct sel_arg_struct;
+asmlinkage int old_select(struct sel_arg_struct __user *);
+asmlinkage int sys_ipc(uint, int, int, int, void __user *, long);
+struct old_utsname;
+asmlinkage int sys_uname(struct old_utsname __user *);
+struct oldold_utsname;
+asmlinkage int sys_olduname(struct oldold_utsname __user *);
+
+/* kernel/tls.c */
+asmlinkage int sys_set_thread_area(struct user_desc __user *);
+asmlinkage int sys_get_thread_area(struct user_desc __user *);
+
+/* kernel/vm86_32.c */
+asmlinkage int sys_vm86old(struct pt_regs);
+asmlinkage int sys_vm86(struct pt_regs);
+
+#endif /* __KERNEL__ */
+#endif /* _ASM_X86_SYSCALLS_H */
diff --git a/include/asm-x86/time.h b/include/asm-x86/time.h
index bce72d7..d99caff 100644
--- a/include/asm-x86/time.h
+++ b/include/asm-x86/time.h
@@ -31,6 +31,9 @@ static inline int native_set_wallclock(unsigned long nowtime)
 	return retval;
 }
 
+extern int timer_ack;
+void __init time_init(void);
+
 #else
 extern void native_time_init_hook(void);
 
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 0522f36..dfd6744 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -65,6 +65,10 @@ struct getcpu_cache;
 #include <linux/quota.h>
 #include <linux/key.h>
 
+#ifdef CONFIG_X86
+#include <asm/syscalls.h>
+#endif
+
 asmlinkage long sys_time(time_t __user *tloc);
 asmlinkage long sys_stime(time_t __user *tptr);
 asmlinkage long sys_gettimeofday(struct timeval __user *tv,
-- 
1.5.5.1



