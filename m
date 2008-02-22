Return-Path: <linux-kernel-owner+w=401wt.eu-S936539AbYBVWSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936539AbYBVWSj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 17:18:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758164AbYBVWLP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 17:11:15 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:12834 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935011AbYBVWLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 17:11:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=L+XN90Aitk0zC4z3dSygh2ARV3VFRwKwK+MR7DvBbFLjR4Dh+6TOq4E52k6RR5e9JVaPDyZ2Xwgq0imUe1cTP7dYmMpf7Yg5npYb4fJtayaLF1/Iy4zArEHxOdv4xql4unKvK5auZbm0y0UoHxGPVlkBEeR7JRvAmr6cGFp0H1c=
Date: Fri, 22 Feb 2008 23:11:07 +0100
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: hpa <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       tglx <tglx@linutronix.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 14/20] x86: Coding Style fixes to
 arch/x86/kernel/cpu/mcheck/mce_32.c
Message-ID: <20080222231107.4a291fd4@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

File is now error free.
Compile tested.


Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
---
 arch/x86/kernel/cpu/mcheck/mce_32.c |   50 +++++++++++++++++-----------------
 1 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce_32.c b/arch/x86/kernel/cpu/mcheck/mce_32.c
index a5182dc..774d87c 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_32.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_32.c
@@ -10,20 +10,20 @@
 #include <linux/smp.h>
 #include <linux/thread_info.h>
 
-#include <asm/processor.h> 
+#include <asm/processor.h>
 #include <asm/system.h>
 #include <asm/mce.h>
 
 #include "mce.h"
 
-int mce_disabled = 0;
+int mce_disabled;
 int nr_mce_banks;
 
 EXPORT_SYMBOL_GPL(nr_mce_banks);	/* non-fatal.o */
 
 /* Handle unconfigured int18 (should never happen) */
-static void unexpected_machine_check(struct pt_regs * regs, long error_code)
-{	
+static void unexpected_machine_check(struct pt_regs *regs, long error_code)
+{
 	printk(KERN_ERR "CPU#%d: Unexpected int18 (Machine Check).\n", smp_processor_id());
 }
 
@@ -33,30 +33,30 @@ void (*machine_check_vector)(struct pt_regs *, long error_code) = unexpected_mac
 /* This has to be run for each processor */
 void mcheck_init(struct cpuinfo_x86 *c)
 {
-	if (mce_disabled==1)
+	if (mce_disabled == 1)
 		return;
 
 	switch (c->x86_vendor) {
-		case X86_VENDOR_AMD:
-			amd_mcheck_init(c);
-			break;
-
-		case X86_VENDOR_INTEL:
-			if (c->x86==5)
-				intel_p5_mcheck_init(c);
-			if (c->x86==6)
-				intel_p6_mcheck_init(c);
-			if (c->x86==15)
-				intel_p4_mcheck_init(c);
-			break;
-
-		case X86_VENDOR_CENTAUR:
-			if (c->x86==5)
-				winchip_mcheck_init(c);
-			break;
-
-		default:
-			break;
+	case X86_VENDOR_AMD:
+		amd_mcheck_init(c);
+		break;
+
+	case X86_VENDOR_INTEL:
+		if (c->x86 == 5)
+			intel_p5_mcheck_init(c);
+		if (c->x86 == 6)
+			intel_p6_mcheck_init(c);
+		if (c->x86 == 15)
+			intel_p4_mcheck_init(c);
+		break;
+
+	case X86_VENDOR_CENTAUR:
+		if (c->x86 == 5)
+			winchip_mcheck_init(c);
+		break;
+
+	default:
+		break;
 	}
 }
 
-- 
1.5.4.GIT

