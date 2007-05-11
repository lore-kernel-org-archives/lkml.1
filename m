Return-Path: <linux-kernel-owner+w=401wt.eu-S966107AbXEKTpw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966107AbXEKTpw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 15:45:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763392AbXEKTmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 15:42:05 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:45946 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761368AbXEKTmC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 15:42:02 -0400
Message-ID: <4644C706.4050101@simon.arlott.org.uk>
Date: Fri, 11 May 2007 20:41:58 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       trivial@kernel.org
Subject: [PATCH] spelling fixes: arch/m32r/
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Spelling fixes in arch/m32r/.

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
---
 arch/m32r/kernel/irq.c      |    2 +-
 arch/m32r/kernel/signal.c   |    2 +-
 arch/m32r/kernel/smp.c      |   18 +++++++++---------
 arch/m32r/kernel/smpboot.c  |    6 +++---
 arch/m32r/kernel/sys_m32r.c |    2 +-
 5 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/arch/m32r/kernel/irq.c b/arch/m32r/kernel/irq.c
index f8d8650..d0c5b0b 100644
--- a/arch/m32r/kernel/irq.c
+++ b/arch/m32r/kernel/irq.c
@@ -71,7 +71,7 @@ skip:
 }
 
 /*
- * do_IRQ handles all normal device IRQ's (the special
+ * do_IRQ handles all normal device IRQs (the special
  * SMP cross-CPU interrupts have their own specific
  * handlers).
  */
diff --git a/arch/m32r/kernel/signal.c b/arch/m32r/kernel/signal.c
index 916faf6..a753d79 100644
--- a/arch/m32r/kernel/signal.c
+++ b/arch/m32r/kernel/signal.c
@@ -358,7 +358,7 @@ int do_signal(struct pt_regs *regs, sigset_t *oldset)
 
 	signr = get_signal_to_deliver(&info, &ka, regs, NULL);
 	if (signr > 0) {
-		/* Reenable any watchpoints before delivering the
+		/* Re-enable any watchpoints before delivering the
 		 * signal to user space. The processor register will
 		 * have been cleared if the watchpoint triggered
 		 * inside the kernel.
diff --git a/arch/m32r/kernel/smp.c b/arch/m32r/kernel/smp.c
index 3601291..c837bc1 100644
--- a/arch/m32r/kernel/smp.c
+++ b/arch/m32r/kernel/smp.c
@@ -202,7 +202,7 @@ void smp_flush_cache_all_interrupt(void)
 }
 
 /*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*/
-/* TLB flush request Routins                                                 */
+/* TLB flush request Routines                                                */
 /*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*/
 
 /*==========================================================================*
@@ -378,7 +378,7 @@ void smp_flush_tlb_page(struct vm_area_struct *vma, unsigned long va)
  * Name:         flush_tlb_others
  *
  * Description:  This routine requests other CPU to execute flush TLB.
- *               1.Setup parmeters.
+ *               1.Setup parameters.
  *               2.Send 'INVALIDATE_TLB_IPI' to other CPU.
  *                 Request other CPU to execute 'smp_invalidate_interrupt()'.
  *               3.Wait for other CPUs operation finished.
@@ -502,7 +502,7 @@ void smp_invalidate_interrupt(void)
 }
 
 /*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*/
-/* Stop CPU request Routins                                                 */
+/* Stop CPU request Routines                                                 */
 /*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*/
 
 /*==========================================================================*
@@ -566,7 +566,7 @@ static void stop_this_cpu(void *dummy)
 }
 
 /*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*/
-/* Call function Routins                                                     */
+/* Call function Routines                                                    */
 /*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*/
 
 /*==========================================================================*
@@ -690,7 +690,7 @@ void smp_call_function_interrupt(void)
 }
 
 /*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*/
-/* Timer Routins                                                             */
+/* Timer Routines                                                            */
 /*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*/
 
 /*==========================================================================*
@@ -802,7 +802,7 @@ void smp_local_timer_interrupt(void)
 }
 
 /*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*/
-/* Send IPI Routins                                                          */
+/* Send IPI Routines                                                         */
 /*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*/
 
 /*==========================================================================*
@@ -814,7 +814,7 @@ void smp_local_timer_interrupt(void)
  *
  * Arguments:    ipi_num - Number of IPI
  *               try -  0 : Send IPI certainly.
- *                     !0 : The following IPI is not sended when Target CPU
+ *                     !0 : The following IPI is not sent when Target CPU
  *                          has not received the before IPI.
  *
  * Returns:      void (cannot fail)
@@ -844,7 +844,7 @@ void send_IPI_allbutself(int ipi_num, int try)
  * Arguments:    cpu_mask - Bitmap of target CPUs logical ID
  *               ipi_num - Number of IPI
  *               try -  0 : Send IPI certainly.
- *                     !0 : The following IPI is not sended when Target CPU
+ *                     !0 : The following IPI is not sent when Target CPU
  *                          has not received the before IPI.
  *
  * Returns:      void (cannot fail)
@@ -885,7 +885,7 @@ static void send_IPI_mask(cpumask_t cpumask, int ipi_num, int try)
  * Arguments:    cpu_mask - Bitmap of target CPUs physical ID
  *               ipi_num - Number of IPI
  *               try -  0 : Send IPI certainly.
- *                     !0 : The following IPI is not sended when Target CPU
+ *                     !0 : The following IPI is not sent when Target CPU
  *                          has not received the before IPI.
  *
  * Returns:      IPICRi regster value.
diff --git a/arch/m32r/kernel/smpboot.c b/arch/m32r/kernel/smpboot.c
index 3eb3059..236eca3 100644
--- a/arch/m32r/kernel/smpboot.c
+++ b/arch/m32r/kernel/smpboot.c
@@ -132,7 +132,7 @@ static void map_cpu_to_physid(int, int);
 static void unmap_cpu_to_physid(int, int);
 
 /*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*/
-/* Boot up APs Routins : BSP                                                 */
+/* Boot up APs Routines : BSP                                                */
 /*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*/
 void __devinit smp_prepare_boot_cpu(void)
 {
@@ -403,7 +403,7 @@ void __init smp_cpus_done(unsigned int max_cpus)
 }
 
 /*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*/
-/* Activate a secondary processor Routins                                    */
+/* Activate a secondary processor Routines                                   */
 /*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*/
 
 /*==========================================================================*
@@ -508,7 +508,7 @@ static void __init smp_online(void)
 }
 
 /*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*/
-/* Boot up CPUs common Routins                                               */
+/* Boot up CPUs common Routines                                              */
 /*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*/
 static void __init show_mp_info(int nr_cpu)
 {
diff --git a/arch/m32r/kernel/sys_m32r.c b/arch/m32r/kernel/sys_m32r.c
index bda8554..b258004 100644
--- a/arch/m32r/kernel/sys_m32r.c
+++ b/arch/m32r/kernel/sys_m32r.c
@@ -213,7 +213,7 @@ asmlinkage int sys_uname(struct old_utsname __user * name)
 
 asmlinkage int sys_cacheflush(void *addr, int bytes, int cache)
 {
-	/* This should flush more selectivly ...  */
+	/* This should flush more selectively ...  */
 	_flush_cache_all();
 	return 0;
 }
-- 
1.5.0.1

-- 
Simon Arlott
