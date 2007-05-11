Return-Path: <linux-kernel-owner+w=401wt.eu-S934057AbXEKTtq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934057AbXEKTtq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 15:49:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030634AbXEKTng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 15:43:36 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:45982 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030503AbXEKTne (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 15:43:34 -0400
Message-ID: <4644C760.8050007@simon.arlott.org.uk>
Date: Fri, 11 May 2007 20:43:28 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       sparclinux@vger.kernel.org, trivial@kernel.org
Subject: [PATCH] spelling fixes: arch/sparc/
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Spelling fixes in arch/sparc/.

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
---
 arch/sparc/kernel/auxio.c     |    2 +-
 arch/sparc/kernel/ioport.c    |    2 +-
 arch/sparc/kernel/irq.c       |    8 ++++----
 arch/sparc/kernel/pcic.c      |    4 ++--
 arch/sparc/kernel/process.c   |    2 +-
 arch/sparc/kernel/sun4d_irq.c |    2 +-
 arch/sparc/kernel/sun4m_irq.c |    2 +-
 arch/sparc/prom/printf.c      |    2 +-
 8 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/sparc/kernel/auxio.c b/arch/sparc/kernel/auxio.c
index 118f3ec..baf4ed3 100644
--- a/arch/sparc/kernel/auxio.c
+++ b/arch/sparc/kernel/auxio.c
@@ -88,7 +88,7 @@ void set_auxio(unsigned char bits_on, unsigned char bits_off)
 		break;
 	case sun4m:
 		if(!auxio_register)
-			break;     /* VME chassic sun4m, no auxio. */
+			break;     /* VME chassis sun4m, no auxio. */
 		regval = sbus_readb(auxio_register);
 		sbus_writeb(((regval | bits_on) & ~bits_off) | AUXIO_ORMEIN4M,
 			auxio_register);
diff --git a/arch/sparc/kernel/ioport.c b/arch/sparc/kernel/ioport.c
index 987ec67..62182d2 100644
--- a/arch/sparc/kernel/ioport.c
+++ b/arch/sparc/kernel/ioport.c
@@ -617,7 +617,7 @@ void *pci_alloc_consistent(struct pci_dev *pdev, size_t len, dma_addr_t *pba)
  * size must be the same as what as passed into pci_alloc_consistent,
  * and likewise dma_addr must be the same as what *dma_addrp was set to.
  *
- * References to the memory and mappings assosciated with cpu_addr/dma_addr
+ * References to the memory and mappings associated with cpu_addr/dma_addr
  * past this call are illegal.
  */
 void pci_free_consistent(struct pci_dev *pdev, size_t n, void *p, dma_addr_t ba)
diff --git a/arch/sparc/kernel/irq.c b/arch/sparc/kernel/irq.c
index bdbefa8..f257a67 100644
--- a/arch/sparc/kernel/irq.c
+++ b/arch/sparc/kernel/irq.c
@@ -1,6 +1,6 @@
 /*  $Id: irq.c,v 1.114 2001/12/11 04:55:51 davem Exp $
  *  arch/sparc/kernel/irq.c:  Interrupt request handling routines. On the
- *                            Sparc the IRQ's are basically 'cast in stone'
+ *                            Sparc the IRQs are basically 'cast in stone'
  *                            and you are supposed to probe the prom's device
  *                            node trees to find out who's got which IRQ.
  *
@@ -330,7 +330,7 @@ void handler_irq(int irq, struct pt_regs * regs)
 	irq_enter();
 	disable_pil_irq(irq);
 #ifdef CONFIG_SMP
-	/* Only rotate on lower priority IRQ's (scsi, ethernet, etc.). */
+	/* Only rotate on lower priority IRQs (scsi, ethernet, etc.). */
 	if((sparc_cpu_model==sun4m) && (irq < 10))
 		smp4m_irq_rotate(cpu);
 #endif
@@ -371,7 +371,7 @@ void sparc_floppy_irq(int irq, void *dev_id, struct pt_regs *regs)
 }
 #endif
 
-/* Fast IRQ's on the Sparc can only have one routine attached to them,
+/* Fast IRQs on the Sparc can only have one routine attached to them,
  * thus no sharing possible.
  */
 int request_fast_irq(unsigned int irq,
@@ -608,7 +608,7 @@ void __init init_IRQ(void)
 		break;
 
 	default:
-		prom_printf("Cannot initialize IRQ's on this Sun machine...");
+		prom_printf("Cannot initialize IRQs on this Sun machine...");
 		break;
 	}
 	btfixup();
diff --git a/arch/sparc/kernel/pcic.c b/arch/sparc/kernel/pcic.c
index 5ca7e8f..7917711 100644
--- a/arch/sparc/kernel/pcic.c
+++ b/arch/sparc/kernel/pcic.c
@@ -755,7 +755,7 @@ void __init pci_time_init(void)
 static __inline__ unsigned long do_gettimeoffset(void)
 {
 	/*
-	 * We devide all to 100
+	 * We divide all by 100
 	 * to have microsecond resolution and to avoid overflow
 	 */
 	unsigned long count =
@@ -956,7 +956,7 @@ EXPORT_SYMBOL(pci_device_to_OF_node);
  * Also, think for a moment about likes of floppy.c that
  * include architecture specific parts. They may want to redefine ins/outs.
  *
- * We do not use horroble macroses here because we want to
+ * We do not use horrible macros here because we want to
  * advance pointer by sizeof(size).
  */
 void outsb(unsigned long addr, const void *src, unsigned long count)
diff --git a/arch/sparc/kernel/process.c b/arch/sparc/kernel/process.c
index 2940d2c..8c37f8f 100644
--- a/arch/sparc/kernel/process.c
+++ b/arch/sparc/kernel/process.c
@@ -683,7 +683,7 @@ out:
  * NOTE! Only a kernel-only process(ie the swapper or direct descendants
  * who haven't done an "execve()") should use this: it will work within
  * a system call from a "real" process, but the process memory space will
- * not be free'd until both the parent and the child have exited.
+ * not be freed until both the parent and the child have exited.
  */
 pid_t kernel_thread(int (*fn)(void *), void * arg, unsigned long flags)
 {
diff --git a/arch/sparc/kernel/sun4d_irq.c b/arch/sparc/kernel/sun4d_irq.c
index 116d6a2..396797e 100644
--- a/arch/sparc/kernel/sun4d_irq.c
+++ b/arch/sparc/kernel/sun4d_irq.c
@@ -521,7 +521,7 @@ static void __init sun4d_init_timers(irq_handler_t counter_fn)
 		lvl14_save[2] += smp4d_ticker - real_irq_entry;
 
 		/* For SMP we use the level 14 ticker, however the bootup code
-		 * has copied the firmwares level 14 vector into boot cpu's
+		 * has copied the firmware's level 14 vector into the boot cpu's
 		 * trap table, we must fix this now or we get squashed.
 		 */
 		local_irq_save(flags);
diff --git a/arch/sparc/kernel/sun4m_irq.c b/arch/sparc/kernel/sun4m_irq.c
index a654c16..91a803e 100644
--- a/arch/sparc/kernel/sun4m_irq.c
+++ b/arch/sparc/kernel/sun4m_irq.c
@@ -299,7 +299,7 @@ static void __init sun4m_init_timers(irq_handler_t counter_fn)
 		struct tt_entry *trap_table = &sparc_ttable[SP_TRAP_IRQ1 + (14 - 1)];
 
 		/* For SMP we use the level 14 ticker, however the bootup code
-		 * has copied the firmwares level 14 vector into boot cpu's
+		 * has copied the firmware's level 14 vector into the boot cpu's
 		 * trap table, we must fix this now or we get squashed.
 		 */
 		local_irq_save(flags);
diff --git a/arch/sparc/prom/printf.c b/arch/sparc/prom/printf.c
index dc8b598..27fdac9 100644
--- a/arch/sparc/prom/printf.c
+++ b/arch/sparc/prom/printf.c
@@ -5,7 +5,7 @@
  * Copyright (c) 2002 Pete Zaitcev (zaitcev@yahoo.com)
  *
  * We used to warn all over the code: DO NOT USE prom_printf(),
- * and yet people do. Anton's banking code was outputing banks
+ * and yet people do. Anton's banking code was outputting banks
  * with prom_printf for most of the 2.4 lifetime. Since an effective
  * stick is not available, we deployed a carrot: an early printk
  * through PROM by means of -p boot option. This ought to fix it.
-- 
1.5.0.1

-- 
Simon Arlott
