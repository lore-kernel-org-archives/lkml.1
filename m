Return-Path: <linux-kernel-owner+w=401wt.eu-S1765788AbYBVWSC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765788AbYBVWSC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 17:18:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935543AbYBVWLE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 17:11:04 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:28753 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935521AbYBVWLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 17:11:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=t7dCu0mMKuHRTnXBPi6zgiSkwBDbHzWfBYVV1jKtH+tbibhC/wXZ9B/Biy/4p/DnPcxckbeNneUw88OpO5fj8mVj0nGukfk4C1369RVFjzLmwZB7iMwAkmtqcEvnoBaeh/2TWe+vhfplENQ3X3zegZM7fXYplB1sGw0VfqYiRc0=
Date: Fri, 22 Feb 2008 23:10:57 +0100
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: hpa <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       tglx <tglx@linutronix.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 13/20] x86: Coding Style fixes to
 arch/x86/kernel/cpu/mcheck/winchip.c
Message-ID: <20080222231057.21ee3e9c@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

File is now error and warning free.
Compile tested.


Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
---
 arch/x86/kernel/cpu/mcheck/winchip.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/winchip.c b/arch/x86/kernel/cpu/mcheck/winchip.c
index 3d428d5..f2be3e1 100644
--- a/arch/x86/kernel/cpu/mcheck/winchip.c
+++ b/arch/x86/kernel/cpu/mcheck/winchip.c
@@ -8,14 +8,14 @@
 #include <linux/kernel.h>
 #include <linux/interrupt.h>
 
-#include <asm/processor.h> 
+#include <asm/processor.h>
 #include <asm/system.h>
 #include <asm/msr.h>
 
 #include "mce.h"
 
 /* Machine check handler for WinChip C6 */
-static void winchip_machine_check(struct pt_regs * regs, long error_code)
+static void winchip_machine_check(struct pt_regs *regs, long error_code)
 {
 	printk(KERN_EMERG "CPU0: Machine Check Exception.\n");
 	add_taint(TAINT_MACHINE_CHECK);
@@ -28,8 +28,8 @@ void winchip_mcheck_init(struct cpuinfo_x86 *c)
 	machine_check_vector = winchip_machine_check;
 	wmb();
 	rdmsr(MSR_IDT_FCR1, lo, hi);
-	lo|= (1<<2);	/* Enable EIERRINT (int 18 MCE) */
-	lo&= ~(1<<4);	/* Enable MCE */
+	lo |= (1<<2);	/* Enable EIERRINT (int 18 MCE) */
+	lo &= ~(1<<4);	/* Enable MCE */
 	wrmsr(MSR_IDT_FCR1, lo, hi);
 	set_in_cr4(X86_CR4_MCE);
 	printk(KERN_INFO "Winchip machine check reporting enabled on CPU#0.\n");
-- 
1.5.4.GIT

