Return-Path: <linux-kernel-owner+w=401wt.eu-S1031488AbXEKTv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031488AbXEKTv5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 15:51:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763563AbXEKToM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 15:44:12 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:46646 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763180AbXEKToJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 15:44:09 -0400
Message-ID: <4644C783.3090805@simon.arlott.org.uk>
Date: Fri, 11 May 2007 20:44:03 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       discuss@x86-64.org, trivial@kernel.org
Subject: [PATCH] spelling fixes: arch/x86_64/
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Spelling fixes in arch/x86_64/.

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
---
 arch/x86_64/boot/compressed/misc.c |    4 ++--
 arch/x86_64/kernel/hpet.c          |    2 +-
 arch/x86_64/kernel/io_apic.c       |    4 ++--
 arch/x86_64/kernel/mce.c           |    4 ++--
 arch/x86_64/kernel/signal.c        |    2 +-
 arch/x86_64/kernel/smpboot.c       |    2 +-
 arch/x86_64/kernel/suspend.c       |    7 ++++++-
 arch/x86_64/kernel/traps.c         |    2 +-
 arch/x86_64/kernel/vsyscall.c      |    2 +-
 arch/x86_64/mm/fault.c             |    4 ++--
 arch/x86_64/mm/srat.c              |    2 +-
 11 files changed, 20 insertions(+), 15 deletions(-)

diff --git a/arch/x86_64/boot/compressed/misc.c b/arch/x86_64/boot/compressed/misc.c
index f932b0e..6ea015a 100644
--- a/arch/x86_64/boot/compressed/misc.c
+++ b/arch/x86_64/boot/compressed/misc.c
@@ -25,7 +25,7 @@
 
 /*
  * Getting to provable safe in place decompression is hard.
- * Worst case behaviours need to be analized.
+ * Worst case behaviours need to be analyzed.
  * Background information:
  *
  * The file layout is:
@@ -94,7 +94,7 @@
  * Adding 32768 instead of 32767 just makes for round numbers.
  * Adding the decompressor_size is necessary as it musht live after all
  * of the data as well.  Last I measured the decompressor is about 14K.
- * 10K of actuall data and 4K of bss.
+ * 10K of actual data and 4K of bss.
  *
  */
 
diff --git a/arch/x86_64/kernel/hpet.c b/arch/x86_64/kernel/hpet.c
index b828696..85d914c 100644
--- a/arch/x86_64/kernel/hpet.c
+++ b/arch/x86_64/kernel/hpet.c
@@ -163,7 +163,7 @@ int hpet_arch_init(void)
 	/*
 	 * hpet period is in femto seconds per cycle
 	 * so we need to convert this to ns/cyc units
-	 * aproximated by mult/2^shift
+	 * approximated by mult/2^shift
 	 *
 	 *  fsec/cyc * 1nsec/1000000fsec = nsec/cyc = mult/2^shift
 	 *  fsec/cyc * 1ns/1000000fsec * 2^shift = mult
diff --git a/arch/x86_64/kernel/io_apic.c b/arch/x86_64/kernel/io_apic.c
index d8bfe31..77be3b9 100644
--- a/arch/x86_64/kernel/io_apic.c
+++ b/arch/x86_64/kernel/io_apic.c
@@ -1710,7 +1710,7 @@ __setup("no_timer_check", notimercheck);
 
 /*
  *
- * IRQ's that are handled by the PIC in the MPS IOAPIC case.
+ * IRQs that are handled by the PIC in the MPS IOAPIC case.
  * - IRQ2 is the cascade IRQ, and cannot be a io-apic IRQ.
  *   Linux doesn't really care, as it's not actually used
  *   for any interrupt handling anyway.
@@ -1862,7 +1862,7 @@ void destroy_irq(unsigned int irq)
 }
 
 /*
- * MSI mesage composition
+ * MSI message composition
  */
 #ifdef CONFIG_PCI_MSI
 static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq, struct msi_msg *msg)
diff --git a/arch/x86_64/kernel/mce.c b/arch/x86_64/kernel/mce.c
index a14375d..a401c63 100644
--- a/arch/x86_64/kernel/mce.c
+++ b/arch/x86_64/kernel/mce.c
@@ -298,7 +298,7 @@ void do_machine_check(struct pt_regs * regs, long error_code)
 #ifdef CONFIG_X86_MCE_INTEL
 /***
  * mce_log_therm_throt_event - Logs the thermal throttling event to mcelog
- * @cpu: The CPU on which the event occured.
+ * @cpu: The CPU on which the event occurred.
  * @status: Event status information
  *
  * This function should be called by the thermal interrupt after the
@@ -573,7 +573,7 @@ static int __init mcheck_disable(char *str)
 	return 1;
 }
 
-/* mce=off disables machine check. Note you can reenable it later
+/* mce=off disables machine check. Note you can re-enable it later
    using sysfs.
    mce=TOLERANCELEVEL (number, see above)
    mce=bootlog Log MCEs from before booting. Disabled by default on AMD.
diff --git a/arch/x86_64/kernel/signal.c b/arch/x86_64/kernel/signal.c
index 290f5d8..8f70782 100644
--- a/arch/x86_64/kernel/signal.c
+++ b/arch/x86_64/kernel/signal.c
@@ -411,7 +411,7 @@ static void do_signal(struct pt_regs *regs)
 
 	signr = get_signal_to_deliver(&info, &ka, regs, NULL);
 	if (signr > 0) {
-		/* Reenable any watchpoints before delivering the
+		/* Re-enable any watchpoints before delivering the
 		 * signal to user space. The processor register will
 		 * have been cleared if the watchpoint triggered
 		 * inside the kernel.
diff --git a/arch/x86_64/kernel/smpboot.c b/arch/x86_64/kernel/smpboot.c
index 32f5078..c4b904d 100644
--- a/arch/x86_64/kernel/smpboot.c
+++ b/arch/x86_64/kernel/smpboot.c
@@ -359,7 +359,7 @@ void __cpuinit start_secondary(void)
 	/*
 	 * We need to hold call_lock, so there is no inconsistency
 	 * between the time smp_call_function() determines number of
-	 * IPI receipients, and the time when the determination is made
+	 * IPI recipients, and the time when the determination is made
 	 * for which cpus receive the IPI in genapic_flat.c. Holding this
 	 * lock helps us to not include this cpu in a currently in progress
 	 * smp_call_function().
diff --git a/arch/x86_64/kernel/suspend.c b/arch/x86_64/kernel/suspend.c
index 6a5a98f..e2756b4 100644
--- a/arch/x86_64/kernel/suspend.c
+++ b/arch/x86_64/kernel/suspend.c
@@ -123,7 +123,12 @@ void fix_processor_context(void)
 	int cpu = smp_processor_id();
 	struct tss_struct *t = &per_cpu(init_tss, cpu);
 
-	set_tss_desc(cpu,t);	/* This just modifies memory; should not be neccessary. But... This is neccessary, because 386 hardware has concept of busy TSS or some similar stupidity. */
+	/*
+	 * This just modifies memory; should not be necessary.
+	 * But... This is necessary, because 386 hardware has
+	 * the concept of busy TSS or some similar stupidity.
+	 */
+	set_tss_desc(cpu,t);
 
 	cpu_gdt(cpu)[GDT_ENTRY_TSS].type = 9;
 
diff --git a/arch/x86_64/kernel/traps.c b/arch/x86_64/kernel/traps.c
index d28f013..b3e079d 100644
--- a/arch/x86_64/kernel/traps.c
+++ b/arch/x86_64/kernel/traps.c
@@ -199,7 +199,7 @@ static unsigned long *in_exception_stack(unsigned cpu, unsigned long stack,
 #define MSG(txt) ops->warning(data, txt)
 
 /*
- * x86-64 can have upto three kernel stacks: 
+ * x86-64 can have up to three kernel stacks: 
  * process stack
  * interrupt stack
  * severe exception (double fault, nmi, stack fault, debug, mce) hardware stack
diff --git a/arch/x86_64/kernel/vsyscall.c b/arch/x86_64/kernel/vsyscall.c
index 51d4c6f..7366508 100644
--- a/arch/x86_64/kernel/vsyscall.c
+++ b/arch/x86_64/kernel/vsyscall.c
@@ -54,7 +54,7 @@
 /*
  * vsyscall_gtod_data contains data that is :
  * - readonly from vsyscalls
- * - writen by timer interrupt or systcl (/proc/sys/kernel/vsyscall64)
+ * - written by timer interrupt or systcl (/proc/sys/kernel/vsyscall64)
  * Try to keep this structure as small as possible to avoid cache line ping pongs
  */
 struct vsyscall_gtod_data_t {
diff --git a/arch/x86_64/mm/fault.c b/arch/x86_64/mm/fault.c
index bfb62a1..e93600c 100644
--- a/arch/x86_64/mm/fault.c
+++ b/arch/x86_64/mm/fault.c
@@ -387,7 +387,7 @@ asmlinkage void __kprobes do_page_fault(struct pt_regs *regs,
  again:
 	/* When running in the kernel we expect faults to occur only to
 	 * addresses in user space.  All other faults represent errors in the
-	 * kernel and should generate an OOPS.  Unfortunatly, in the case of an
+	 * kernel and should generate an OOPS.  Unfortunately, in the case of an
 	 * erroneous fault occurring in a code path which already holds mmap_sem
 	 * we will deadlock attempting to validate the fault against the
 	 * address space.  Luckily the kernel only validly references user
@@ -395,7 +395,7 @@ asmlinkage void __kprobes do_page_fault(struct pt_regs *regs,
 	 * exceptions table.
 	 *
 	 * As the vast majority of faults will be valid we will only perform
-	 * the source reference check when there is a possibilty of a deadlock.
+	 * the source reference check when there is a possibility of a deadlock.
 	 * Attempt to lock the address space, if we cannot we then validate the
 	 * source.  If this is invalid we can skip the address space check,
 	 * thus avoiding the deadlock.
diff --git a/arch/x86_64/mm/srat.c b/arch/x86_64/mm/srat.c
index 1e76bb0..4e53550 100644
--- a/arch/x86_64/mm/srat.c
+++ b/arch/x86_64/mm/srat.c
@@ -218,7 +218,7 @@ static inline int save_add_info(void) {return 0;}
 /*
  * Update nodes_add and decide if to include add are in the zone.
  * Both SPARSE and RESERVE need nodes_add infomation.
- * This code supports one contigious hot add area per node.
+ * This code supports one contiguous hot add area per node.
  */
 static int reserve_hotadd(int node, unsigned long start, unsigned long end)
 {
-- 
1.5.0.1

-- 
Simon Arlott
