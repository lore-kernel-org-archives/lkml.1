Return-Path: <linux-kernel-owner+w=401wt.eu-S1762930AbXEKTlb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762930AbXEKTlb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 15:41:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762505AbXEKTkk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 15:40:40 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:45913 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762312AbXEKTki (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 15:40:38 -0400
Message-ID: <4644C6A1.1060306@simon.arlott.org.uk>
Date: Fri, 11 May 2007 20:40:17 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, rth@twiddle.net,
       trivial@kernel.org
Subject: [PATCH] spelling fixes: arch/alpha/
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Spelling fixes in arch/alpha/.

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
---
 arch/alpha/kernel/err_marvel.c     |    2 +-
 arch/alpha/kernel/err_titan.c      |    2 +-
 arch/alpha/kernel/osf_sys.c        |    2 +-
 arch/alpha/kernel/smp.c            |    1 -
 arch/alpha/kernel/sys_alcor.c      |    2 +-
 arch/alpha/kernel/sys_sio.c        |    2 +-
 arch/alpha/lib/checksum.c          |    2 +-
 arch/alpha/lib/csum_partial_copy.c |    2 +-
 arch/alpha/mm/init.c               |    2 +-
 arch/alpha/oprofile/op_impl.h      |    2 +-
 10 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/arch/alpha/kernel/err_marvel.c b/arch/alpha/kernel/err_marvel.c
index f2956ac..497877b 100644
--- a/arch/alpha/kernel/err_marvel.c
+++ b/arch/alpha/kernel/err_marvel.c
@@ -1082,7 +1082,7 @@ marvel_machine_check(u64 vector, u64 la_ptr)
 	}	
 
 	/*
-	 * A system event or error has occured, handle it here.
+	 * A system event or error has occurred, handle it here.
 	 *
 	 * Any errors in the logout frame have already been cleared by the
 	 * PALcode, so just parse it.
diff --git a/arch/alpha/kernel/err_titan.c b/arch/alpha/kernel/err_titan.c
index 543d96d..6f38678 100644
--- a/arch/alpha/kernel/err_titan.c
+++ b/arch/alpha/kernel/err_titan.c
@@ -591,7 +591,7 @@ privateer_process_680_frame(struct el_common *mchk_header, int print)
 		(struct el_PRIVATEER_envdata_mcheck *)
 		((unsigned long)mchk_header + mchk_header->sys_offset);
 
-	/* TODO - catagorize errors, for now, no error */
+	/* TODO - categorize errors, for now, no error */
 
 	if (!print)
 		return status;
diff --git a/arch/alpha/kernel/osf_sys.c b/arch/alpha/kernel/osf_sys.c
index ce85715..6413c5f 100644
--- a/arch/alpha/kernel/osf_sys.c
+++ b/arch/alpha/kernel/osf_sys.c
@@ -715,7 +715,7 @@ osf_setsysinfo(unsigned long op, void __user *buffer, unsigned long nbytes,
 		/* 
 		 * Alpha Architecture Handbook 4.7.7.3:
 		 * To be fully IEEE compiant, we must track the current IEEE
-		 * exception state in software, because spurrious bits can be
+		 * exception state in software, because spurious bits can be
 		 * set in the trap shadow of a software-complete insn.
 		 */
 
diff --git a/arch/alpha/kernel/smp.c b/arch/alpha/kernel/smp.c
index 80cfb75..86023e6 100644
--- a/arch/alpha/kernel/smp.c
+++ b/arch/alpha/kernel/smp.c
@@ -438,7 +438,6 @@ setup_smp(void)
 				((char *)cpubase + i*hwrpb->processor_size);
 			if ((cpu->flags & 0x1cc) == 0x1cc) {
 				smp_num_probed++;
-				/* Assume here that "whami" == index */
 				cpu_set(i, cpu_present_map);
 				cpu->pal_revision = boot_cpu_palrev;
 			}
diff --git a/arch/alpha/kernel/sys_alcor.c b/arch/alpha/kernel/sys_alcor.c
index 49bedfb..d187d01 100644
--- a/arch/alpha/kernel/sys_alcor.c
+++ b/arch/alpha/kernel/sys_alcor.c
@@ -138,7 +138,7 @@ alcor_init_irq(void)
 
 	for (i = 16; i < 48; ++i) {
 		/* On Alcor, at least, lines 20..30 are not connected
-		   and can generate spurrious interrupts if we turn them
+		   and can generate spurious interrupts if we turn them
 		   on while IRQ probing.  */
 		if (i >= 16+20 && i <= 16+30)
 			continue;
diff --git a/arch/alpha/kernel/sys_sio.c b/arch/alpha/kernel/sys_sio.c
index 14b5a75..ee7b900 100644
--- a/arch/alpha/kernel/sys_sio.c
+++ b/arch/alpha/kernel/sys_sio.c
@@ -78,7 +78,7 @@ alphabook1_init_arch(void)
  * example, sound boards seem to like using IRQ 9.
  *
  * This is NOT how we should do it. PIRQ0-X should have
- * their own IRQ's, the way intel uses the IO-APIC irq's.
+ * their own IRQs, the way intel uses the IO-APIC IRQs.
  */
 
 static void __init
diff --git a/arch/alpha/lib/checksum.c b/arch/alpha/lib/checksum.c
index ab3761c..690b856 100644
--- a/arch/alpha/lib/checksum.c
+++ b/arch/alpha/lib/checksum.c
@@ -5,7 +5,7 @@
  * in an architecture-specific manner due to speed..
  * Comments in other versions indicate that the algorithms are from RFC1071
  *
- * accellerated versions (and 21264 assembly versions ) contributed by
+ * accelerated versions (and 21264 assembly versions ) contributed by
  *	Rick Gorton	<rick.gorton@alpha-processor.com>
  */
  
diff --git a/arch/alpha/lib/csum_partial_copy.c b/arch/alpha/lib/csum_partial_copy.c
index 4ca75c7..40736da 100644
--- a/arch/alpha/lib/csum_partial_copy.c
+++ b/arch/alpha/lib/csum_partial_copy.c
@@ -2,7 +2,7 @@
  * csum_partial_copy - do IP checksumming and copy
  *
  * (C) Copyright 1996 Linus Torvalds
- * accellerated versions (and 21264 assembly versions ) contributed by
+ * accelerated versions (and 21264 assembly versions ) contributed by
  *	Rick Gorton	<rick.gorton@alpha-processor.com>
  *
  * Don't look at this too closely - you'll go mad. The things
diff --git a/arch/alpha/mm/init.c b/arch/alpha/mm/init.c
index 550f490..d7be31d 100644
--- a/arch/alpha/mm/init.c
+++ b/arch/alpha/mm/init.c
@@ -235,7 +235,7 @@ callback_init(void * kernel_end)
 			unsigned long pfn = crb->map[i].pa >> PAGE_SHIFT;
 			crb->map[i].va = vaddr;
 			for (j = 0; j < crb->map[i].count; ++j) {
-				/* Newer console's (especially on larger
+				/* Newer consoles (especially on larger
 				   systems) may require more pages of
 				   PTEs. Grab additional pages as needed. */
 				if (pmd != pmd_offset(pgd, vaddr)) {
diff --git a/arch/alpha/oprofile/op_impl.h b/arch/alpha/oprofile/op_impl.h
index 6b97893..b2b87ae 100644
--- a/arch/alpha/oprofile/op_impl.h
+++ b/arch/alpha/oprofile/op_impl.h
@@ -38,7 +38,7 @@ struct op_register_config {
 	unsigned long need_reset;
 };
 
-/* Per-architecture configury and hooks.  */
+/* Per-architecture configuration and hooks.  */
 struct op_axp_model {
 	void (*reg_setup) (struct op_register_config *,
 			   struct op_counter_config *,
-- 
1.5.0.1

-- 
Simon Arlott
