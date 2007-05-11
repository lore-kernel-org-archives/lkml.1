Return-Path: <linux-kernel-owner+w=401wt.eu-S1762959AbXEKTtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762959AbXEKTtU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 15:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933287AbXEKTn0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 15:43:26 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:45979 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763043AbXEKTnY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 15:43:24 -0400
Message-ID: <4644C757.2050702@simon.arlott.org.uk>
Date: Fri, 11 May 2007 20:43:19 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       trivial@kernel.org
Subject: [PATCH] spelling fixes: arch/sh64/
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Spelling fixes in arch/sh64/.

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
---
 arch/sh64/kernel/pci_sh5.h    |    2 +-
 arch/sh64/kernel/process.c    |    2 +-
 arch/sh64/kernel/time.c       |    2 +-
 arch/sh64/mach-cayman/setup.c |    2 +-
 arch/sh64/mm/fault.c          |    2 +-
 arch/sh64/mm/tlbmiss.c        |    4 ++--
 6 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/sh64/kernel/pci_sh5.h b/arch/sh64/kernel/pci_sh5.h
index 8f21f5d..c71159d 100644
--- a/arch/sh64/kernel/pci_sh5.h
+++ b/arch/sh64/kernel/pci_sh5.h
@@ -4,7 +4,7 @@
  * May be copied or modified under the terms of the GNU General Public
  * License.  See linux/COPYING for more information.
  *
- * Defintions for the SH5 PCI hardware.
+ * Definitions for the SH5 PCI hardware.
  */
 
 /* Product ID */
diff --git a/arch/sh64/kernel/process.c b/arch/sh64/kernel/process.c
index 525d0ec..1b89c9d 100644
--- a/arch/sh64/kernel/process.c
+++ b/arch/sh64/kernel/process.c
@@ -387,7 +387,7 @@ ATTRIB_NORET void kernel_thread_helper(void *arg, int (*fn)(void *))
  * NOTE! Only a kernel-only process(ie the swapper or direct descendants
  * who haven't done an "execve()") should use this: it will work within
  * a system call from a "real" process, but the process memory space will
- * not be free'd until both the parent and the child have exited.
+ * not be freed until both the parent and the child have exited.
  */
 int kernel_thread(int (*fn)(void *), void * arg, unsigned long flags)
 {
diff --git a/arch/sh64/kernel/time.c b/arch/sh64/kernel/time.c
index 390b40d..bad0f05 100644
--- a/arch/sh64/kernel/time.c
+++ b/arch/sh64/kernel/time.c
@@ -123,7 +123,7 @@ static unsigned long long usecs_per_jiffy = 1000000/HZ; /* Approximation */
 static unsigned long long scaled_recip_ctc_ticks_per_jiffy;
 
 /* Estimate number of microseconds that have elapsed since the last timer tick,
-   by scaling the delta that has occured in the CTC register.
+   by scaling the delta that has occurred in the CTC register.
 
    WARNING WARNING WARNING : This algorithm relies on the CTC decrementing at
    the CPU clock rate.  If the CPU sleeps, the CTC stops counting.  Bear this
diff --git a/arch/sh64/mach-cayman/setup.c b/arch/sh64/mach-cayman/setup.c
index 3ed87cd..c3611cc 100644
--- a/arch/sh64/mach-cayman/setup.c
+++ b/arch/sh64/mach-cayman/setup.c
@@ -213,7 +213,7 @@ static int __init smsc_superio_setup(void)
 	SMSC_SUPERIO_WRITE_INDEXED(0x00, 0xc7); /* GP47 = nIOWOP */
 #endif
 
-	/* Exit the configuraton state */
+	/* Exit the configuration state */
 	outb(SMSC_EXIT_CONFIG_KEY, SMSC_CONFIG_PORT_ADDR);
 
 	return 0;
diff --git a/arch/sh64/mm/fault.c b/arch/sh64/mm/fault.c
index 4dd8ee8..3cd93ba 100644
--- a/arch/sh64/mm/fault.c
+++ b/arch/sh64/mm/fault.c
@@ -135,7 +135,7 @@ asmlinkage void do_page_fault(struct pt_regs *regs, unsigned long writeaccess,
 	/* SIM
 	 * Note this is now called with interrupts still disabled
 	 * This is to cope with being called for a missing IO port
-	 * address with interupts disabled. This should be fixed as
+	 * address with interrupts disabled. This should be fixed as
 	 * soon as we have a better 'fast path' miss handler.
 	 *
 	 * Plus take care how you try and debug this stuff.
diff --git a/arch/sh64/mm/tlbmiss.c b/arch/sh64/mm/tlbmiss.c
index d4c5334..b767d6c 100644
--- a/arch/sh64/mm/tlbmiss.c
+++ b/arch/sh64/mm/tlbmiss.c
@@ -14,7 +14,7 @@
  * IMPORTANT NOTES :
  * The do_fast_page_fault function is called from a context in entry.S where very few registers
  * have been saved.  In particular, the code in this file must be compiled not to use ANY
- * caller-save regiseters that are not part of the restricted save set.  Also, it means that
+ * caller-save registers that are not part of the restricted save set.  Also, it means that
  * code in this file must not make calls to functions elsewhere in the kernel, or else the
  * excepting context will see corruption in its caller-save registers.  Plus, the entry.S save
  * area is non-reentrant, so this code has to run with SR.BL==1, i.e. no interrupts taken inside
@@ -249,7 +249,7 @@ asmlinkage int do_fast_page_fault(unsigned long long ssr_md, unsigned long long
 	/* SIM
 	 * Note this is now called with interrupts still disabled
 	 * This is to cope with being called for a missing IO port
-	 * address with interupts disabled. This should be fixed as
+	 * address with interrupts disabled. This should be fixed as
 	 * soon as we have a better 'fast path' miss handler.
 	 *
 	 * Plus take care how you try and debug this stuff.
-- 
1.5.0.1

-- 
Simon Arlott
