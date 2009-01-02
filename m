Return-Path: <linux-kernel-owner+w=401wt.eu-S1759473AbZABVtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759473AbZABVtV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 16:49:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758608AbZABVtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 16:49:12 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37227 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757503AbZABVtJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 16:49:09 -0500
Date: Fri, 2 Jan 2009 22:48:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [git pull] x86 fixes
Message-ID: <20090102214845.GA23722@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus


out-of-topic modifications in x86-fixes-for-linus:
--------------------------------------------------
drivers/pci/hotplug/cpqphp_core.c  # 8248771: x86, pci: move arch/x86/pci/pci.h
drivers/pci/hotplug/cpqphp_pci.c   # 8248771: x86, pci: move arch/x86/pci/pci.h
drivers/pci/hotplug/ibmphp_core.c  # 8248771: x86, pci: move arch/x86/pci/pci.h

 Thanks,

	Ingo

------------------>
Cliff Wickman (1):
      x86, UV: remove erroneous BAU initialization

Cyrill Gorcunov (2):
      x86: mach-default setup.c cleanups
      x86: early_printk - use sizeof instead of hardcoded number

H. Peter Anvin (1):
      x86: unify the implementation of FPU traps

Ingo Brueckl (1):
      x86: convert permanent_kmaps_init() from macro to inline

Ingo Molnar (1):
      x86: clean up comment style in arch/x86/kernel/traps.c

Jaswinder Singh (2):
      x86: reboot.c declare port_cf9_safe before they get used
      x86: apic.c x2apic_preenabled and disable_x2apic should be static

Jaswinder Singh Rajput (17):
      x86: introducing asm/sys_ia32.h
      x86: apic.c declare pic_mode before they get used
      x86: io_apic.c io_apic_sync should be static
      x86: efi.c declare add_efi_memmap before they get used
      x86_64: pci-gart_64.c iommu_fullflush should be static
      x86, pci: move arch/x86/pci/pci.h to arch/x86/include/asm/pci_x86.h
      x86: amd_iommu_init.c: iommu_enable and iommu_enable_event_logging should be static
      x86: amd_iommu.c: prealloc_protection_domains should be static
      x86: genx2apic_phys.c: x2apic_send_IPI_self and init_x2apic_ldr should be static
      x86: bios_uv.c: uv_systab should be static
      x86: apic.c: xapic_icr_read and x2apic_icr_read should be static
      x86: uv_bau.h: fix dubious bitfield
      x86: xsave.c: restore_user_xstate should be static
      x86: cpuid.c fix style problems
      x86: ldt.c fix style problems
      x86: nmi.c fix style problems
      x86: mpparse.c fix style problems

Ravikiran G Thirumalai (1):
      x86: fix incorrect __read_mostly on _boot_cpu_pda

Rusty Russell (1):
      x86: remove impossible test in mtrr/main.c


 arch/x86/ia32/ia32_signal.c                   |    3 +-
 arch/x86/ia32/ipc32.c                         |    1 +
 arch/x86/ia32/sys_ia32.c                      |    2 +-
 arch/x86/include/asm/apic.h                   |    3 +-
 arch/x86/include/asm/efi.h                    |    1 +
 arch/x86/include/asm/mpspec.h                 |    2 +-
 arch/x86/{pci/pci.h => include/asm/pci_x86.h} |   17 +++--
 arch/x86/include/asm/sys_ia32.h               |  101 +++++++++++++++++++++++++
 arch/x86/include/asm/uv/uv_bau.h              |   46 ++++++------
 arch/x86/kernel/amd_iommu.c                   |    2 +-
 arch/x86/kernel/amd_iommu_init.c              |    4 +-
 arch/x86/kernel/apic.c                        |    8 +-
 arch/x86/kernel/bios_uv.c                     |    2 +-
 arch/x86/kernel/cpu/mtrr/main.c               |    6 +-
 arch/x86/kernel/cpuid.c                       |    6 +-
 arch/x86/kernel/early_printk.c                |    2 +-
 arch/x86/kernel/genx2apic_phys.c              |    4 +-
 arch/x86/kernel/head64.c                      |    2 +-
 arch/x86/kernel/io_apic.c                     |    2 +-
 arch/x86/kernel/ldt.c                         |    4 +-
 arch/x86/kernel/mmconf-fam10h_64.c            |    3 +-
 arch/x86/kernel/mpparse.c                     |   10 +-
 arch/x86/kernel/nmi.c                         |    3 +-
 arch/x86/kernel/pci-gart_64.c                 |    2 +-
 arch/x86/kernel/reboot.c                      |    2 +-
 arch/x86/kernel/tlb_uv.c                      |    9 --
 arch/x86/kernel/traps.c                       |   33 +++++----
 arch/x86/kernel/xsave.c                       |    2 +-
 arch/x86/mach-default/setup.c                 |   15 ++--
 arch/x86/pci/acpi.c                           |    2 +-
 arch/x86/pci/amd_bus.c                        |    2 +-
 arch/x86/pci/common.c                         |    3 +-
 arch/x86/pci/direct.c                         |    2 +-
 arch/x86/pci/early.c                          |    2 +-
 arch/x86/pci/fixup.c                          |    3 +-
 arch/x86/pci/i386.c                           |    2 +-
 arch/x86/pci/init.c                           |    2 +-
 arch/x86/pci/irq.c                            |    3 +-
 arch/x86/pci/legacy.c                         |    2 +-
 arch/x86/pci/mmconfig-shared.c                |    3 +-
 arch/x86/pci/mmconfig_32.c                    |    2 +-
 arch/x86/pci/mmconfig_64.c                    |    3 +-
 arch/x86/pci/numaq_32.c                       |    2 +-
 arch/x86/pci/olpc.c                           |    2 +-
 arch/x86/pci/pcbios.c                         |    5 +-
 arch/x86/pci/visws.c                          |    3 +-
 drivers/pci/hotplug/cpqphp_core.c             |    2 +-
 drivers/pci/hotplug/cpqphp_pci.c              |    2 +-
 drivers/pci/hotplug/ibmphp_core.c             |    2 +-
 49 files changed, 217 insertions(+), 129 deletions(-)
 rename arch/x86/{pci/pci.h => include/asm/pci_x86.h} (88%)
 create mode 100644 arch/x86/include/asm/sys_ia32.h

diff --git a/arch/x86/ia32/ia32_signal.c b/arch/x86/ia32/ia32_signal.c
index b195f85..9dabd00 100644
--- a/arch/x86/ia32/ia32_signal.c
+++ b/arch/x86/ia32/ia32_signal.c
@@ -24,15 +24,14 @@
 #include <asm/ucontext.h>
 #include <asm/uaccess.h>
 #include <asm/i387.h>
-#include <asm/ia32.h>
 #include <asm/ptrace.h>
 #include <asm/ia32_unistd.h>
 #include <asm/user32.h>
 #include <asm/sigcontext32.h>
 #include <asm/proto.h>
 #include <asm/vdso.h>
-
 #include <asm/sigframe.h>
+#include <asm/sys_ia32.h>
 
 #define DEBUG_SIG 0
 
diff --git a/arch/x86/ia32/ipc32.c b/arch/x86/ia32/ipc32.c
index d21991c..29cdcd0 100644
--- a/arch/x86/ia32/ipc32.c
+++ b/arch/x86/ia32/ipc32.c
@@ -8,6 +8,7 @@
 #include <linux/shm.h>
 #include <linux/ipc.h>
 #include <linux/compat.h>
+#include <asm/sys_ia32.h>
 
 asmlinkage long sys32_ipc(u32 call, int first, int second, int third,
 			  compat_uptr_t ptr, u32 fifth)
diff --git a/arch/x86/ia32/sys_ia32.c b/arch/x86/ia32/sys_ia32.c
index 2e09dcd..6c0d7f6 100644
--- a/arch/x86/ia32/sys_ia32.c
+++ b/arch/x86/ia32/sys_ia32.c
@@ -44,8 +44,8 @@
 #include <asm/types.h>
 #include <asm/uaccess.h>
 #include <asm/atomic.h>
-#include <asm/ia32.h>
 #include <asm/vgtod.h>
+#include <asm/sys_ia32.h>
 
 #define AA(__x)		((unsigned long)(__x))
 
diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 25caa07..ab1d51a 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -54,7 +54,6 @@ extern int disable_apic;
 extern int is_vsmp_box(void);
 extern void xapic_wait_icr_idle(void);
 extern u32 safe_xapic_wait_icr_idle(void);
-extern u64 xapic_icr_read(void);
 extern void xapic_icr_write(u32, u32);
 extern int setup_profiling_timer(unsigned int);
 
@@ -93,7 +92,7 @@ static inline u32 native_apic_msr_read(u32 reg)
 }
 
 #ifndef CONFIG_X86_32
-extern int x2apic, x2apic_preenabled;
+extern int x2apic;
 extern void check_x2apic(void);
 extern void enable_x2apic(void);
 extern void enable_IR_x2apic(void);
diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index a2e545c..ca5ffb2 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -90,6 +90,7 @@ extern void __iomem *efi_ioremap(unsigned long addr, unsigned long size);
 
 #endif /* CONFIG_X86_32 */
 
+extern int add_efi_memmap;
 extern void efi_reserve_early(void);
 extern void efi_call_phys_prelog(void);
 extern void efi_call_phys_epilog(void);
diff --git a/arch/x86/include/asm/mpspec.h b/arch/x86/include/asm/mpspec.h
index 91885c2..62d14ce 100644
--- a/arch/x86/include/asm/mpspec.h
+++ b/arch/x86/include/asm/mpspec.h
@@ -6,13 +6,13 @@
 #include <asm/mpspec_def.h>
 
 extern int apic_version[MAX_APICS];
+extern int pic_mode;
 
 #ifdef CONFIG_X86_32
 #include <mach_mpspec.h>
 
 extern unsigned int def_to_bigsmp;
 extern u8 apicid_2_node[];
-extern int pic_mode;
 
 #ifdef CONFIG_X86_NUMAQ
 extern int mp_bus_id_to_node[MAX_MP_BUSSES];
diff --git a/arch/x86/pci/pci.h b/arch/x86/include/asm/pci_x86.h
similarity index 88%
rename from arch/x86/pci/pci.h
rename to arch/x86/include/asm/pci_x86.h
index 1959018..e60fd3e 100644
--- a/arch/x86/pci/pci.h
+++ b/arch/x86/include/asm/pci_x86.h
@@ -57,7 +57,8 @@ extern struct pci_ops pci_root_ops;
 struct irq_info {
 	u8 bus, devfn;			/* Bus, device and function */
 	struct {
-		u8 link;		/* IRQ line ID, chipset dependent, 0=not routed */
+		u8 link;		/* IRQ line ID, chipset dependent,
+					   0 = not routed */
 		u16 bitmap;		/* Available IRQs */
 	} __attribute__((packed)) irq[4];
 	u8 slot;			/* Slot number, 0=onboard */
@@ -69,11 +70,13 @@ struct irq_routing_table {
 	u16 version;			/* PIRQ_VERSION */
 	u16 size;			/* Table size in bytes */
 	u8 rtr_bus, rtr_devfn;		/* Where the interrupt router lies */
-	u16 exclusive_irqs;		/* IRQs devoted exclusively to PCI usage */
-	u16 rtr_vendor, rtr_device;	/* Vendor and device ID of interrupt router */
+	u16 exclusive_irqs;		/* IRQs devoted exclusively to
+					   PCI usage */
+	u16 rtr_vendor, rtr_device;	/* Vendor and device ID of
+					   interrupt router */
 	u32 miniport_data;		/* Crap */
 	u8 rfu[11];
-	u8 checksum;			/* Modulo 256 checksum must give zero */
+	u8 checksum;			/* Modulo 256 checksum must give 0 */
 	struct irq_info slots[0];
 } __attribute__((packed));
 
@@ -148,15 +151,15 @@ static inline unsigned int mmio_config_readl(void __iomem *pos)
 
 static inline void mmio_config_writeb(void __iomem *pos, u8 val)
 {
-	asm volatile("movb %%al,(%1)" :: "a" (val), "r" (pos) : "memory");
+	asm volatile("movb %%al,(%1)" : : "a" (val), "r" (pos) : "memory");
 }
 
 static inline void mmio_config_writew(void __iomem *pos, u16 val)
 {
-	asm volatile("movw %%ax,(%1)" :: "a" (val), "r" (pos) : "memory");
+	asm volatile("movw %%ax,(%1)" : : "a" (val), "r" (pos) : "memory");
 }
 
 static inline void mmio_config_writel(void __iomem *pos, u32 val)
 {
-	asm volatile("movl %%eax,(%1)" :: "a" (val), "r" (pos) : "memory");
+	asm volatile("movl %%eax,(%1)" : : "a" (val), "r" (pos) : "memory");
 }
diff --git a/arch/x86/include/asm/sys_ia32.h b/arch/x86/include/asm/sys_ia32.h
new file mode 100644
index 0000000..ffb08be
--- /dev/null
+++ b/arch/x86/include/asm/sys_ia32.h
@@ -0,0 +1,101 @@
+/*
+ * sys_ia32.h - Linux ia32 syscall interfaces
+ *
+ * Copyright (c) 2008 Jaswinder Singh Rajput
+ *
+ * This file is released under the GPLv2.
+ * See the file COPYING for more details.
+ */
+
+#ifndef _ASM_X86_SYS_IA32_H
+#define _ASM_X86_SYS_IA32_H
+
+#include <linux/compiler.h>
+#include <linux/linkage.h>
+#include <linux/types.h>
+#include <linux/signal.h>
+#include <asm/compat.h>
+#include <asm/ia32.h>
+
+/* ia32/sys_ia32.c */
+asmlinkage long sys32_truncate64(char __user *, unsigned long, unsigned long);
+asmlinkage long sys32_ftruncate64(unsigned int, unsigned long, unsigned long);
+
+asmlinkage long sys32_stat64(char __user *, struct stat64 __user *);
+asmlinkage long sys32_lstat64(char __user *, struct stat64 __user *);
+asmlinkage long sys32_fstat64(unsigned int, struct stat64 __user *);
+asmlinkage long sys32_fstatat(unsigned int, char __user *,
+			      struct stat64 __user *, int);
+struct mmap_arg_struct;
+asmlinkage long sys32_mmap(struct mmap_arg_struct __user *);
+asmlinkage long sys32_mprotect(unsigned long, size_t, unsigned long);
+
+asmlinkage long sys32_pipe(int __user *);
+struct sigaction32;
+struct old_sigaction32;
+asmlinkage long sys32_rt_sigaction(int, struct sigaction32 __user *,
+				   struct sigaction32 __user *, unsigned int);
+asmlinkage long sys32_sigaction(int, struct old_sigaction32 __user *,
+				struct old_sigaction32 __user *);
+asmlinkage long sys32_rt_sigprocmask(int, compat_sigset_t __user *,
+				     compat_sigset_t __user *, unsigned int);
+asmlinkage long sys32_alarm(unsigned int);
+
+struct sel_arg_struct;
+asmlinkage long sys32_old_select(struct sel_arg_struct __user *);
+asmlinkage long sys32_waitpid(compat_pid_t, unsigned int *, int);
+asmlinkage long sys32_sysfs(int, u32, u32);
+
+asmlinkage long sys32_sched_rr_get_interval(compat_pid_t,
+					    struct compat_timespec __user *);
+asmlinkage long sys32_rt_sigpending(compat_sigset_t __user *, compat_size_t);
+asmlinkage long sys32_rt_sigqueueinfo(int, int, compat_siginfo_t __user *);
+
+#ifdef CONFIG_SYSCTL_SYSCALL
+struct sysctl_ia32;
+asmlinkage long sys32_sysctl(struct sysctl_ia32 __user *);
+#endif
+
+asmlinkage long sys32_pread(unsigned int, char __user *, u32, u32, u32);
+asmlinkage long sys32_pwrite(unsigned int, char __user *, u32, u32, u32);
+
+asmlinkage long sys32_personality(unsigned long);
+asmlinkage long sys32_sendfile(int, int, compat_off_t __user *, s32);
+
+asmlinkage long sys32_mmap2(unsigned long, unsigned long, unsigned long,
+			    unsigned long, unsigned long, unsigned long);
+
+struct oldold_utsname;
+struct old_utsname;
+asmlinkage long sys32_olduname(struct oldold_utsname __user *);
+long sys32_uname(struct old_utsname __user *);
+
+long sys32_ustat(unsigned, struct ustat32 __user *);
+
+asmlinkage long sys32_execve(char __user *, compat_uptr_t __user *,
+			     compat_uptr_t __user *, struct pt_regs *);
+asmlinkage long sys32_clone(unsigned int, unsigned int, struct pt_regs *);
+
+long sys32_lseek(unsigned int, int, unsigned int);
+long sys32_kill(int, int);
+long sys32_fadvise64_64(int, __u32, __u32, __u32, __u32, int);
+long sys32_vm86_warning(void);
+long sys32_lookup_dcookie(u32, u32, char __user *, size_t);
+
+asmlinkage ssize_t sys32_readahead(int, unsigned, unsigned, size_t);
+asmlinkage long sys32_sync_file_range(int, unsigned, unsigned,
+				      unsigned, unsigned, int);
+asmlinkage long sys32_fadvise64(int, unsigned, unsigned, size_t, int);
+asmlinkage long sys32_fallocate(int, int, unsigned,
+				unsigned, unsigned, unsigned);
+
+/* ia32/ia32_signal.c */
+asmlinkage long sys32_sigsuspend(int, int, old_sigset_t);
+asmlinkage long sys32_sigaltstack(const stack_ia32_t __user *,
+				  stack_ia32_t __user *, struct pt_regs *);
+asmlinkage long sys32_sigreturn(struct pt_regs *);
+asmlinkage long sys32_rt_sigreturn(struct pt_regs *);
+
+/* ia32/ipc32.c */
+asmlinkage long sys32_ipc(u32, int, int, int, compat_uptr_t, u32);
+#endif /* _ASM_X86_SYS_IA32_H */
diff --git a/arch/x86/include/asm/uv/uv_bau.h b/arch/x86/include/asm/uv/uv_bau.h
index e236325..50423c7 100644
--- a/arch/x86/include/asm/uv/uv_bau.h
+++ b/arch/x86/include/asm/uv/uv_bau.h
@@ -133,61 +133,61 @@ struct bau_msg_payload {
  * see table 4.2.3.0.1 in broacast_assist spec.
  */
 struct bau_msg_header {
-	int dest_subnodeid:6;	/* must be zero */
+	unsigned int dest_subnodeid:6;	/* must be zero */
 	/* bits 5:0 */
-	int base_dest_nodeid:15; /* nasid>>1 (pnode) of first bit in node_map */
-	/* bits 20:6 */
-	int command:8;		/* message type */
+	unsigned int base_dest_nodeid:15; /* nasid>>1 (pnode) of */
+	/* bits 20:6 */			  /* first bit in node_map */
+	unsigned int command:8;	/* message type */
 	/* bits 28:21 */
 				/* 0x38: SN3net EndPoint Message */
-	int rsvd_1:3;		/* must be zero */
+	unsigned int rsvd_1:3;	/* must be zero */
 	/* bits 31:29 */
 				/* int will align on 32 bits */
-	int rsvd_2:9;		/* must be zero */
+	unsigned int rsvd_2:9;	/* must be zero */
 	/* bits 40:32 */
 				/* Suppl_A is 56-41 */
-	int payload_2a:8;	/* becomes byte 16 of msg */
+	unsigned int payload_2a:8;/* becomes byte 16 of msg */
 	/* bits 48:41 */	/* not currently using */
-	int payload_2b:8;	/* becomes byte 17 of msg */
+	unsigned int payload_2b:8;/* becomes byte 17 of msg */
 	/* bits 56:49 */	/* not currently using */
 				/* Address field (96:57) is never used as an
 				   address (these are address bits 42:3) */
-	int rsvd_3:1;		/* must be zero */
+	unsigned int rsvd_3:1;	/* must be zero */
 	/* bit 57 */
 				/* address bits 27:4 are payload */
 				/* these 24 bits become bytes 12-14 of msg */
-	int replied_to:1;	/* sent as 0 by the source to byte 12 */
+	unsigned int replied_to:1;/* sent as 0 by the source to byte 12 */
 	/* bit 58 */
 
-	int payload_1a:5;	/* not currently used */
+	unsigned int payload_1a:5;/* not currently used */
 	/* bits 63:59 */
-	int payload_1b:8;	/* not currently used */
+	unsigned int payload_1b:8;/* not currently used */
 	/* bits 71:64 */
-	int payload_1c:8;	/* not currently used */
+	unsigned int payload_1c:8;/* not currently used */
 	/* bits 79:72 */
-	int payload_1d:2;	/* not currently used */
+	unsigned int payload_1d:2;/* not currently used */
 	/* bits 81:80 */
 
-	int rsvd_4:7;		/* must be zero */
+	unsigned int rsvd_4:7;	/* must be zero */
 	/* bits 88:82 */
-	int sw_ack_flag:1;	/* software acknowledge flag */
+	unsigned int sw_ack_flag:1;/* software acknowledge flag */
 	/* bit 89 */
 				/* INTD trasactions at destination are to
 				   wait for software acknowledge */
-	int rsvd_5:6;		/* must be zero */
+	unsigned int rsvd_5:6;	/* must be zero */
 	/* bits 95:90 */
-	int rsvd_6:5;		/* must be zero */
+	unsigned int rsvd_6:5;	/* must be zero */
 	/* bits 100:96 */
-	int int_both:1;		/* if 1, interrupt both sockets on the blade */
+	unsigned int int_both:1;/* if 1, interrupt both sockets on the blade */
 	/* bit 101*/
-	int fairness:3;		/* usually zero */
+	unsigned int fairness:3;/* usually zero */
 	/* bits 104:102 */
-	int multilevel:1;	/* multi-level multicast format */
+	unsigned int multilevel:1;	/* multi-level multicast format */
 	/* bit 105 */
 				/* 0 for TLB: endpoint multi-unicast messages */
-	int chaining:1;		/* next descriptor is part of this activation*/
+	unsigned int chaining:1;/* next descriptor is part of this activation*/
 	/* bit 106 */
-	int rsvd_7:21;		/* must be zero */
+	unsigned int rsvd_7:21;	/* must be zero */
 	/* bits 127:107 */
 };
 
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 2e2da71..658e29e 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -1296,7 +1296,7 @@ static int amd_iommu_dma_supported(struct device *dev, u64 mask)
  * we don't need to preallocate the protection domains anymore.
  * For now we have to.
  */
-void prealloc_protection_domains(void)
+static void prealloc_protection_domains(void)
 {
 	struct pci_dev *dev = NULL;
 	struct dma_ops_domain *dma_dom;
diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index c625800..fb85e8d 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -243,7 +243,7 @@ static void __init iommu_feature_disable(struct amd_iommu *iommu, u8 bit)
 }
 
 /* Function to enable the hardware */
-void __init iommu_enable(struct amd_iommu *iommu)
+static void __init iommu_enable(struct amd_iommu *iommu)
 {
 	printk(KERN_INFO "AMD IOMMU: Enabling IOMMU "
 	       "at %02x:%02x.%x cap 0x%hx\n",
@@ -256,7 +256,7 @@ void __init iommu_enable(struct amd_iommu *iommu)
 }
 
 /* Function to enable IOMMU event logging and event interrupts */
-void __init iommu_enable_event_logging(struct amd_iommu *iommu)
+static void __init iommu_enable_event_logging(struct amd_iommu *iommu)
 {
 	iommu_feature_enable(iommu, CONTROL_EVT_LOG_EN);
 	iommu_feature_enable(iommu, CONTROL_EVT_INT_EN);
diff --git a/arch/x86/kernel/apic.c b/arch/x86/kernel/apic.c
index 6b7f824..d652515 100644
--- a/arch/x86/kernel/apic.c
+++ b/arch/x86/kernel/apic.c
@@ -98,8 +98,8 @@ __setup("apicpmtimer", setup_apicpmtimer);
 #ifdef HAVE_X2APIC
 int x2apic;
 /* x2apic enabled before OS handover */
-int x2apic_preenabled;
-int disable_x2apic;
+static int x2apic_preenabled;
+static int disable_x2apic;
 static __init int setup_nox2apic(char *str)
 {
 	disable_x2apic = 1;
@@ -226,7 +226,7 @@ void xapic_icr_write(u32 low, u32 id)
 	apic_write(APIC_ICR, low);
 }
 
-u64 xapic_icr_read(void)
+static u64 xapic_icr_read(void)
 {
 	u32 icr1, icr2;
 
@@ -266,7 +266,7 @@ void x2apic_icr_write(u32 low, u32 id)
 	wrmsrl(APIC_BASE_MSR + (APIC_ICR >> 4), ((__u64) id) << 32 | low);
 }
 
-u64 x2apic_icr_read(void)
+static u64 x2apic_icr_read(void)
 {
 	unsigned long val;
 
diff --git a/arch/x86/kernel/bios_uv.c b/arch/x86/kernel/bios_uv.c
index 2a0a2a3..f638827 100644
--- a/arch/x86/kernel/bios_uv.c
+++ b/arch/x86/kernel/bios_uv.c
@@ -25,7 +25,7 @@
 #include <asm/uv/bios.h>
 #include <asm/uv/uv_hub.h>
 
-struct uv_systab uv_systab;
+static struct uv_systab uv_systab;
 
 s64 uv_bios_call(enum uv_bios_cmd which, u64 a1, u64 a2, u64 a3, u64 a4, u64 a5)
 {
diff --git a/arch/x86/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/main.c
index d6ec7ec..d259e5d 100644
--- a/arch/x86/kernel/cpu/mtrr/main.c
+++ b/arch/x86/kernel/cpu/mtrr/main.c
@@ -824,16 +824,14 @@ static int enable_mtrr_cleanup __initdata =
 
 static int __init disable_mtrr_cleanup_setup(char *str)
 {
-	if (enable_mtrr_cleanup != -1)
-		enable_mtrr_cleanup = 0;
+	enable_mtrr_cleanup = 0;
 	return 0;
 }
 early_param("disable_mtrr_cleanup", disable_mtrr_cleanup_setup);
 
 static int __init enable_mtrr_cleanup_setup(char *str)
 {
-	if (enable_mtrr_cleanup != -1)
-		enable_mtrr_cleanup = 1;
+	enable_mtrr_cleanup = 1;
 	return 0;
 }
 early_param("enable_mtrr_cleanup", enable_mtrr_cleanup_setup);
diff --git a/arch/x86/kernel/cpuid.c b/arch/x86/kernel/cpuid.c
index 72cefd1..85d28d5 100644
--- a/arch/x86/kernel/cpuid.c
+++ b/arch/x86/kernel/cpuid.c
@@ -39,10 +39,10 @@
 #include <linux/device.h>
 #include <linux/cpu.h>
 #include <linux/notifier.h>
+#include <linux/uaccess.h>
 
 #include <asm/processor.h>
 #include <asm/msr.h>
-#include <asm/uaccess.h>
 #include <asm/system.h>
 
 static struct class *cpuid_class;
@@ -82,7 +82,7 @@ static loff_t cpuid_seek(struct file *file, loff_t offset, int orig)
 }
 
 static ssize_t cpuid_read(struct file *file, char __user *buf,
-			  size_t count, loff_t * ppos)
+			  size_t count, loff_t *ppos)
 {
 	char __user *tmp = buf;
 	struct cpuid_regs cmd;
@@ -117,7 +117,7 @@ static int cpuid_open(struct inode *inode, struct file *file)
 	unsigned int cpu;
 	struct cpuinfo_x86 *c;
 	int ret = 0;
-	
+
 	lock_kernel();
 
 	cpu = iminor(file->f_path.dentry->d_inode);
diff --git a/arch/x86/kernel/early_printk.c b/arch/x86/kernel/early_printk.c
index 23b138e..504ad19 100644
--- a/arch/x86/kernel/early_printk.c
+++ b/arch/x86/kernel/early_printk.c
@@ -886,7 +886,7 @@ asmlinkage void early_printk(const char *fmt, ...)
 	va_list ap;
 
 	va_start(ap, fmt);
-	n = vscnprintf(buf, 512, fmt, ap);
+	n = vscnprintf(buf, sizeof(buf), fmt, ap);
 	early_console->write(early_console, buf, n);
 	va_end(ap);
 }
diff --git a/arch/x86/kernel/genx2apic_phys.c b/arch/x86/kernel/genx2apic_phys.c
index 62895cf..21bcc0e 100644
--- a/arch/x86/kernel/genx2apic_phys.c
+++ b/arch/x86/kernel/genx2apic_phys.c
@@ -161,12 +161,12 @@ static unsigned int phys_pkg_id(int index_msb)
 	return current_cpu_data.initial_apicid >> index_msb;
 }
 
-void x2apic_send_IPI_self(int vector)
+static void x2apic_send_IPI_self(int vector)
 {
 	apic_write(APIC_SELF_IPI, vector);
 }
 
-void init_x2apic_ldr(void)
+static void init_x2apic_ldr(void)
 {
 	return;
 }
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 388e05a..b9a4d8c 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -27,7 +27,7 @@
 #include <asm/trampoline.h>
 
 /* boot cpu pda */
-static struct x8664_pda _boot_cpu_pda __read_mostly;
+static struct x8664_pda _boot_cpu_pda;
 
 #ifdef CONFIG_SMP
 /*
diff --git a/arch/x86/kernel/io_apic.c b/arch/x86/kernel/io_apic.c
index 62ecfc9..6991172 100644
--- a/arch/x86/kernel/io_apic.c
+++ b/arch/x86/kernel/io_apic.c
@@ -706,7 +706,7 @@ static void __unmask_IO_APIC_irq(struct irq_cfg *cfg)
 }
 
 #ifdef CONFIG_X86_64
-void io_apic_sync(struct irq_pin_list *entry)
+static void io_apic_sync(struct irq_pin_list *entry)
 {
 	/*
 	 * Synchronize the IO-APIC and the CPU by doing
diff --git a/arch/x86/kernel/ldt.c b/arch/x86/kernel/ldt.c
index eee32b4..71f1d99 100644
--- a/arch/x86/kernel/ldt.c
+++ b/arch/x86/kernel/ldt.c
@@ -12,8 +12,8 @@
 #include <linux/mm.h>
 #include <linux/smp.h>
 #include <linux/vmalloc.h>
+#include <linux/uaccess.h>
 
-#include <asm/uaccess.h>
 #include <asm/system.h>
 #include <asm/ldt.h>
 #include <asm/desc.h>
@@ -93,7 +93,7 @@ static inline int copy_ldt(mm_context_t *new, mm_context_t *old)
 	if (err < 0)
 		return err;
 
-	for(i = 0; i < old->size; i++)
+	for (i = 0; i < old->size; i++)
 		write_ldt_entry(new->ldt, i, old->ldt + i * LDT_ENTRY_SIZE);
 	return 0;
 }
diff --git a/arch/x86/kernel/mmconf-fam10h_64.c b/arch/x86/kernel/mmconf-fam10h_64.c
index efc2f36..666e43d 100644
--- a/arch/x86/kernel/mmconf-fam10h_64.c
+++ b/arch/x86/kernel/mmconf-fam10h_64.c
@@ -13,8 +13,7 @@
 #include <asm/msr.h>
 #include <asm/acpi.h>
 #include <asm/mmconfig.h>
-
-#include "../pci/pci.h"
+#include <asm/pci_x86.h>
 
 struct pci_hostbridge_probe {
 	u32 bus;
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index 45e3b69..c5c5b8d 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -16,14 +16,14 @@
 #include <linux/bitops.h>
 #include <linux/acpi.h>
 #include <linux/module.h>
+#include <linux/smp.h>
+#include <linux/acpi.h>
 
-#include <asm/smp.h>
 #include <asm/mtrr.h>
 #include <asm/mpspec.h>
 #include <asm/pgalloc.h>
 #include <asm/io_apic.h>
 #include <asm/proto.h>
-#include <asm/acpi.h>
 #include <asm/bios_ebda.h>
 #include <asm/e820.h>
 #include <asm/trampoline.h>
@@ -95,8 +95,8 @@ static void __init MP_bus_info(struct mpc_config_bus *m)
 #endif
 
 	if (strncmp(str, BUSTYPE_ISA, sizeof(BUSTYPE_ISA) - 1) == 0) {
-		 set_bit(m->mpc_busid, mp_bus_not_pci);
-#if defined(CONFIG_EISA) || defined (CONFIG_MCA)
+		set_bit(m->mpc_busid, mp_bus_not_pci);
+#if defined(CONFIG_EISA) || defined(CONFIG_MCA)
 		mp_bus_id_to_type[m->mpc_busid] = MP_BUS_ISA;
 #endif
 	} else if (strncmp(str, BUSTYPE_PCI, sizeof(BUSTYPE_PCI) - 1) == 0) {
@@ -104,7 +104,7 @@ static void __init MP_bus_info(struct mpc_config_bus *m)
 			x86_quirks->mpc_oem_pci_bus(m);
 
 		clear_bit(m->mpc_busid, mp_bus_not_pci);
-#if defined(CONFIG_EISA) || defined (CONFIG_MCA)
+#if defined(CONFIG_EISA) || defined(CONFIG_MCA)
 		mp_bus_id_to_type[m->mpc_busid] = MP_BUS_PCI;
 	} else if (strncmp(str, BUSTYPE_EISA, sizeof(BUSTYPE_EISA) - 1) == 0) {
 		mp_bus_id_to_type[m->mpc_busid] = MP_BUS_EISA;
diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index 8bd1bf9..45a09cc 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -26,11 +26,10 @@
 #include <linux/kernel_stat.h>
 #include <linux/kdebug.h>
 #include <linux/smp.h>
+#include <linux/nmi.h>
 
 #include <asm/i8259.h>
 #include <asm/io_apic.h>
-#include <asm/smp.h>
-#include <asm/nmi.h>
 #include <asm/proto.h>
 #include <asm/timer.h>
 
diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index a35eaa3..00c2bcd 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -52,7 +52,7 @@ static u32 *iommu_gatt_base;		/* Remapping table */
  * to trigger bugs with some popular PCI cards, in particular 3ware (but
  * has been also also seen with Qlogic at least).
  */
-int iommu_fullflush = 1;
+static int iommu_fullflush = 1;
 
 /* Allocation bitmap for the remapping area: */
 static DEFINE_SPINLOCK(iommu_bitmap_lock);
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 39643b1..bf088c6 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -12,6 +12,7 @@
 #include <asm/proto.h>
 #include <asm/reboot_fixups.h>
 #include <asm/reboot.h>
+#include <asm/pci_x86.h>
 #include <asm/virtext.h>
 
 #ifdef CONFIG_X86_32
@@ -24,7 +25,6 @@
 
 #include <mach_ipi.h>
 
-
 /*
  * Power off function, if any
  */
diff --git a/arch/x86/kernel/tlb_uv.c b/arch/x86/kernel/tlb_uv.c
index 6a00e5f..f885023 100644
--- a/arch/x86/kernel/tlb_uv.c
+++ b/arch/x86/kernel/tlb_uv.c
@@ -582,7 +582,6 @@ static int __init uv_ptc_init(void)
 static struct bau_control * __init uv_table_bases_init(int blade, int node)
 {
 	int i;
-	int *ip;
 	struct bau_msg_status *msp;
 	struct bau_control *bau_tabp;
 
@@ -599,13 +598,6 @@ static struct bau_control * __init uv_table_bases_init(int blade, int node)
 		bau_cpubits_clear(&msp->seen_by, (int)
 				  uv_blade_nr_possible_cpus(blade));
 
-	bau_tabp->watching =
-	    kmalloc_node(sizeof(int) * DEST_NUM_RESOURCES, GFP_KERNEL, node);
-	BUG_ON(!bau_tabp->watching);
-
-	for (i = 0, ip = bau_tabp->watching; i < DEST_Q_SIZE; i++, ip++)
-		*ip = 0;
-
 	uv_bau_table_bases[blade] = bau_tabp;
 
 	return bau_tabp;
@@ -628,7 +620,6 @@ uv_table_bases_finish(int blade, int node, int cur_cpu,
 		bcp->bau_msg_head	= bau_tablesp->va_queue_first;
 		bcp->va_queue_first	= bau_tablesp->va_queue_first;
 		bcp->va_queue_last	= bau_tablesp->va_queue_last;
-		bcp->watching		= bau_tablesp->watching;
 		bcp->msg_statuses	= bau_tablesp->msg_statuses;
 		bcp->descriptor_base	= adp;
 	}
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 2d1f4c7..ce6650e 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -292,8 +292,10 @@ dotraplinkage void do_double_fault(struct pt_regs *regs, long error_code)
 	tsk->thread.error_code = error_code;
 	tsk->thread.trap_no = 8;
 
-	/* This is always a kernel trap and never fixable (and thus must
-	   never return). */
+	/*
+	 * This is always a kernel trap and never fixable (and thus must
+	 * never return).
+	 */
 	for (;;)
 		die(str, regs, error_code);
 }
@@ -520,9 +522,11 @@ dotraplinkage void __kprobes do_int3(struct pt_regs *regs, long error_code)
 }
 
 #ifdef CONFIG_X86_64
-/* Help handler running on IST stack to switch back to user stack
-   for scheduling or signal handling. The actual stack switch is done in
-   entry.S */
+/*
+ * Help handler running on IST stack to switch back to user stack
+ * for scheduling or signal handling. The actual stack switch is done in
+ * entry.S
+ */
 asmlinkage __kprobes struct pt_regs *sync_regs(struct pt_regs *eregs)
 {
 	struct pt_regs *regs = eregs;
@@ -532,8 +536,10 @@ asmlinkage __kprobes struct pt_regs *sync_regs(struct pt_regs *eregs)
 	/* Exception from user space */
 	else if (user_mode(eregs))
 		regs = task_pt_regs(current);
-	/* Exception from kernel and interrupts are enabled. Move to
-	   kernel process stack. */
+	/*
+	 * Exception from kernel and interrupts are enabled. Move to
+	 * kernel process stack.
+	 */
 	else if (eregs->flags & X86_EFLAGS_IF)
 		regs = (struct pt_regs *)(eregs->sp -= sizeof(struct pt_regs));
 	if (eregs != regs)
@@ -685,12 +691,7 @@ void math_error(void __user *ip)
 	cwd = get_fpu_cwd(task);
 	swd = get_fpu_swd(task);
 
-	err = swd & ~cwd & 0x3f;
-
-#ifdef CONFIG_X86_32
-	if (!err)
-		return;
-#endif
+	err = swd & ~cwd;
 
 	if (err & 0x001) {	/* Invalid op */
 		/*
@@ -708,7 +709,11 @@ void math_error(void __user *ip)
 	} else if (err & 0x020) { /* Precision */
 		info.si_code = FPE_FLTRES;
 	} else {
-		info.si_code = __SI_FAULT|SI_KERNEL; /* WTF? */
+		/*
+		 * If we're using IRQ 13, or supposedly even some trap 16
+		 * implementations, it's possible we get a spurious trap...
+		 */
+		return;		/* Spurious trap, no error */
 	}
 	force_sig_info(SIGFPE, &info, task);
 }
diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index 15c3e69..2b54fe0 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -159,7 +159,7 @@ int save_i387_xstate(void __user *buf)
  * Restore the extended state if present. Otherwise, restore the FP/SSE
  * state.
  */
-int restore_user_xstate(void __user *buf)
+static int restore_user_xstate(void __user *buf)
 {
 	struct _fpx_sw_bytes fx_sw_user;
 	u64 mask;
diff --git a/arch/x86/mach-default/setup.c b/arch/x86/mach-default/setup.c
index 37b9ae4..df167f2 100644
--- a/arch/x86/mach-default/setup.c
+++ b/arch/x86/mach-default/setup.c
@@ -133,29 +133,28 @@ void __init time_init_hook(void)
  **/
 void mca_nmi_hook(void)
 {
-	/* If I recall correctly, there's a whole bunch of other things that
+	/*
+	 * If I recall correctly, there's a whole bunch of other things that
 	 * we can do to check for NMI problems, but that's all I know about
 	 * at the moment.
 	 */
-
-	printk("NMI generated from unknown source!\n");
+	pr_warning("NMI generated from unknown source!\n");
 }
 #endif
 
 static __init int no_ipi_broadcast(char *str)
 {
 	get_option(&str, &no_broadcast);
-	printk ("Using %s mode\n", no_broadcast ? "No IPI Broadcast" :
-											"IPI Broadcast");
+	pr_info("Using %s mode\n",
+		no_broadcast ? "No IPI Broadcast" : "IPI Broadcast");
 	return 1;
 }
-
 __setup("no_ipi_broadcast=", no_ipi_broadcast);
 
 static int __init print_ipi_mode(void)
 {
-	printk ("Using IPI %s mode\n", no_broadcast ? "No-Shortcut" :
-											"Shortcut");
+	pr_info("Using IPI %s mode\n",
+		no_broadcast ? "No-Shortcut" : "Shortcut");
 	return 0;
 }
 
diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
index 1d88d2b..9e5752f 100644
--- a/arch/x86/pci/acpi.c
+++ b/arch/x86/pci/acpi.c
@@ -4,7 +4,7 @@
 #include <linux/irq.h>
 #include <linux/dmi.h>
 #include <asm/numa.h>
-#include "pci.h"
+#include <asm/pci_x86.h>
 
 struct pci_root_info {
 	char *name;
diff --git a/arch/x86/pci/amd_bus.c b/arch/x86/pci/amd_bus.c
index 22e0576..9bb0982 100644
--- a/arch/x86/pci/amd_bus.c
+++ b/arch/x86/pci/amd_bus.c
@@ -2,7 +2,7 @@
 #include <linux/pci.h>
 #include <linux/topology.h>
 #include <linux/cpu.h>
-#include "pci.h"
+#include <asm/pci_x86.h>
 
 #ifdef CONFIG_X86_64
 #include <asm/pci-direct.h>
diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
index bb1a01f..62ddb73 100644
--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -14,8 +14,7 @@
 #include <asm/segment.h>
 #include <asm/io.h>
 #include <asm/smp.h>
-
-#include "pci.h"
+#include <asm/pci_x86.h>
 
 unsigned int pci_probe = PCI_PROBE_BIOS | PCI_PROBE_CONF1 | PCI_PROBE_CONF2 |
 				PCI_PROBE_MMCONF;
diff --git a/arch/x86/pci/direct.c b/arch/x86/pci/direct.c
index 9a5af6c..bd13c3e 100644
--- a/arch/x86/pci/direct.c
+++ b/arch/x86/pci/direct.c
@@ -5,7 +5,7 @@
 #include <linux/pci.h>
 #include <linux/init.h>
 #include <linux/dmi.h>
-#include "pci.h"
+#include <asm/pci_x86.h>
 
 /*
  * Functions for accessing PCI base (first 256 bytes) and extended
diff --git a/arch/x86/pci/early.c b/arch/x86/pci/early.c
index 86631cc..f6adf2c 100644
--- a/arch/x86/pci/early.c
+++ b/arch/x86/pci/early.c
@@ -2,7 +2,7 @@
 #include <linux/pci.h>
 #include <asm/pci-direct.h>
 #include <asm/io.h>
-#include "pci.h"
+#include <asm/pci_x86.h>
 
 /* Direct PCI access. This is used for PCI accesses in early boot before
    the PCI subsystem works. */
diff --git a/arch/x86/pci/fixup.c b/arch/x86/pci/fixup.c
index 2051dc9..7d388d5 100644
--- a/arch/x86/pci/fixup.c
+++ b/arch/x86/pci/fixup.c
@@ -6,8 +6,7 @@
 #include <linux/dmi.h>
 #include <linux/pci.h>
 #include <linux/init.h>
-#include "pci.h"
-
+#include <asm/pci_x86.h>
 
 static void __devinit pci_fixup_i450nx(struct pci_dev *d)
 {
diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
index 844df0c..e51bf2c 100644
--- a/arch/x86/pci/i386.c
+++ b/arch/x86/pci/i386.c
@@ -34,8 +34,8 @@
 
 #include <asm/pat.h>
 #include <asm/e820.h>
+#include <asm/pci_x86.h>
 
-#include "pci.h"
 
 static int
 skip_isa_ioresource_align(struct pci_dev *dev) {
diff --git a/arch/x86/pci/init.c b/arch/x86/pci/init.c
index d6c950f..bec3b04 100644
--- a/arch/x86/pci/init.c
+++ b/arch/x86/pci/init.c
@@ -1,6 +1,6 @@
 #include <linux/pci.h>
 #include <linux/init.h>
-#include "pci.h"
+#include <asm/pci_x86.h>
 
 /* arch_initcall has too random ordering, so call the initializers
    in the right sequence from here. */
diff --git a/arch/x86/pci/irq.c b/arch/x86/pci/irq.c
index bf69dbe..373b9af 100644
--- a/arch/x86/pci/irq.c
+++ b/arch/x86/pci/irq.c
@@ -16,8 +16,7 @@
 #include <asm/io_apic.h>
 #include <linux/irq.h>
 #include <linux/acpi.h>
-
-#include "pci.h"
+#include <asm/pci_x86.h>
 
 #define PIRQ_SIGNATURE	(('$' << 0) + ('P' << 8) + ('I' << 16) + ('R' << 24))
 #define PIRQ_VERSION 0x0100
diff --git a/arch/x86/pci/legacy.c b/arch/x86/pci/legacy.c
index b722dd4..f1065b1 100644
--- a/arch/x86/pci/legacy.c
+++ b/arch/x86/pci/legacy.c
@@ -3,7 +3,7 @@
  */
 #include <linux/init.h>
 #include <linux/pci.h>
-#include "pci.h"
+#include <asm/pci_x86.h>
 
 /*
  * Discover remaining PCI buses in case there are peer host bridges.
diff --git a/arch/x86/pci/mmconfig-shared.c b/arch/x86/pci/mmconfig-shared.c
index 654a223..89bf924 100644
--- a/arch/x86/pci/mmconfig-shared.c
+++ b/arch/x86/pci/mmconfig-shared.c
@@ -15,8 +15,7 @@
 #include <linux/acpi.h>
 #include <linux/bitmap.h>
 #include <asm/e820.h>
-
-#include "pci.h"
+#include <asm/pci_x86.h>
 
 /* aperture is up to 256MB but BIOS may reserve less */
 #define MMCONFIG_APER_MIN	(2 * 1024*1024)
diff --git a/arch/x86/pci/mmconfig_32.c b/arch/x86/pci/mmconfig_32.c
index f3c761d..8b2d561 100644
--- a/arch/x86/pci/mmconfig_32.c
+++ b/arch/x86/pci/mmconfig_32.c
@@ -13,7 +13,7 @@
 #include <linux/init.h>
 #include <linux/acpi.h>
 #include <asm/e820.h>
-#include "pci.h"
+#include <asm/pci_x86.h>
 
 /* Assume systems with more busses have correct MCFG */
 #define mmcfg_virt_addr ((void __iomem *) fix_to_virt(FIX_PCIE_MCFG))
diff --git a/arch/x86/pci/mmconfig_64.c b/arch/x86/pci/mmconfig_64.c
index a199416..30007ff 100644
--- a/arch/x86/pci/mmconfig_64.c
+++ b/arch/x86/pci/mmconfig_64.c
@@ -10,8 +10,7 @@
 #include <linux/acpi.h>
 #include <linux/bitmap.h>
 #include <asm/e820.h>
-
-#include "pci.h"
+#include <asm/pci_x86.h>
 
 /* Static virtual mapping of the MMCONFIG aperture */
 struct mmcfg_virt {
diff --git a/arch/x86/pci/numaq_32.c b/arch/x86/pci/numaq_32.c
index 1177845..2089354 100644
--- a/arch/x86/pci/numaq_32.c
+++ b/arch/x86/pci/numaq_32.c
@@ -7,7 +7,7 @@
 #include <linux/nodemask.h>
 #include <mach_apic.h>
 #include <asm/mpspec.h>
-#include "pci.h"
+#include <asm/pci_x86.h>
 
 #define XQUAD_PORTIO_BASE 0xfe400000
 #define XQUAD_PORTIO_QUAD 0x40000  /* 256k per quad. */
diff --git a/arch/x86/pci/olpc.c b/arch/x86/pci/olpc.c
index e11e9e8..b889d82 100644
--- a/arch/x86/pci/olpc.c
+++ b/arch/x86/pci/olpc.c
@@ -29,7 +29,7 @@
 #include <linux/init.h>
 #include <asm/olpc.h>
 #include <asm/geode.h>
-#include "pci.h"
+#include <asm/pci_x86.h>
 
 /*
  * In the tables below, the first two line (8 longwords) are the
diff --git a/arch/x86/pci/pcbios.c b/arch/x86/pci/pcbios.c
index 37472fc..b82cae9 100644
--- a/arch/x86/pci/pcbios.c
+++ b/arch/x86/pci/pcbios.c
@@ -6,9 +6,8 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/uaccess.h>
-#include "pci.h"
-#include "pci-functions.h"
-
+#include <asm/pci_x86.h>
+#include <asm/mach-default/pci-functions.h>
 
 /* BIOS32 signature: "_32_" */
 #define BIOS32_SIGNATURE	(('_' << 0) + ('3' << 8) + ('2' << 16) + ('_' << 24))
diff --git a/arch/x86/pci/visws.c b/arch/x86/pci/visws.c
index 42f4cb1..16d0c0e 100644
--- a/arch/x86/pci/visws.c
+++ b/arch/x86/pci/visws.c
@@ -9,11 +9,10 @@
 #include <linux/init.h>
 
 #include <asm/setup.h>
+#include <asm/pci_x86.h>
 #include <asm/visws/cobalt.h>
 #include <asm/visws/lithium.h>
 
-#include "pci.h"
-
 static int pci_visws_enable_irq(struct pci_dev *dev) { return 0; }
 static void pci_visws_disable_irq(struct pci_dev *dev) { }
 
diff --git a/drivers/pci/hotplug/cpqphp_core.c b/drivers/pci/hotplug/cpqphp_core.c
index 8514c3a..c2e1bcb 100644
--- a/drivers/pci/hotplug/cpqphp_core.c
+++ b/drivers/pci/hotplug/cpqphp_core.c
@@ -45,7 +45,7 @@
 
 #include "cpqphp.h"
 #include "cpqphp_nvram.h"
-#include "../../../arch/x86/pci/pci.h"	/* horrible hack showing how processor dependent we are... */
+#include <asm/pci_x86.h>
 
 
 /* Global variables */
diff --git a/drivers/pci/hotplug/cpqphp_pci.c b/drivers/pci/hotplug/cpqphp_pci.c
index 0902193..df146be 100644
--- a/drivers/pci/hotplug/cpqphp_pci.c
+++ b/drivers/pci/hotplug/cpqphp_pci.c
@@ -37,7 +37,7 @@
 #include "../pci.h"
 #include "cpqphp.h"
 #include "cpqphp_nvram.h"
-#include "../../../arch/x86/pci/pci.h"	/* horrible hack showing how processor dependent we are... */
+#include <asm/pci_x86.h>
 
 
 u8 cpqhp_nic_irq;
diff --git a/drivers/pci/hotplug/ibmphp_core.c b/drivers/pci/hotplug/ibmphp_core.c
index 633e743..dd18f85 100644
--- a/drivers/pci/hotplug/ibmphp_core.c
+++ b/drivers/pci/hotplug/ibmphp_core.c
@@ -35,7 +35,7 @@
 #include <linux/delay.h>
 #include <linux/wait.h>
 #include "../pci.h"
-#include "../../../arch/x86/pci/pci.h"	/* for struct irq_routing_table */
+#include <asm/pci_x86.h>		/* for struct irq_routing_table */
 #include "ibmphp.h"
 
 #define attn_on(sl)  ibmphp_hpc_writeslot (sl, HPC_SLOT_ATTNON)
