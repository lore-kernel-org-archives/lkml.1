Return-Path: <linux-kernel-owner+w=401wt.eu-S937357AbXGRXjI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937357AbXGRXjI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 19:39:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936788AbXGRXbb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 19:31:31 -0400
Received: from rex.snapgear.com ([203.143.235.140]:35239 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S936853AbXGRXb2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 19:31:28 -0400
Date: Thu, 19 Jul 2007 09:30:14 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200707182330.l6INUERa014897@goober>
To: torvalds@linux-foundation.org
Subject: [PATCH] m68knommu: reformat show_cpuinfo()
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Reformat show_cpuinfo() to be consistent with normal coding style
(and rest of this file).

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---


diff -Naur linux-2.6.22/arch/m68knommu/kernel/setup.c linux-2.6.22-uc0/arch/m68knommu/kernel/setup.c
--- linux-2.6.22/arch/m68knommu/kernel/setup.c	2007-07-12 15:23:02.000000000 +1000
+++ linux-2.6.22-uc0/arch/m68knommu/kernel/setup.c	2007-07-12 15:27:00.000000000 +1000
@@ -268,32 +229,33 @@
 /*
  *	Get CPU information for use by the procfs.
  */
-
 static int show_cpuinfo(struct seq_file *m, void *v)
 {
-    char *cpu, *mmu, *fpu;
-    u_long clockfreq;
+	char *cpu, *mmu, *fpu;
+	u_long clockfreq;
 
-    cpu = CPU;
-    mmu = "none";
-    fpu = "none";
+	cpu = CPU;
+	mmu = "none";
+	fpu = "none";
 
 #ifdef CONFIG_COLDFIRE
-    clockfreq = (loops_per_jiffy*HZ)*3;
+	clockfreq = (loops_per_jiffy * HZ) * 3;
 #else
-    clockfreq = (loops_per_jiffy*HZ)*16;
+	clockfreq = (loops_per_jiffy * HZ) * 16;
 #endif
 
-    seq_printf(m, "CPU:\t\t%s\n"
-		   "MMU:\t\t%s\n"
-		   "FPU:\t\t%s\n"
-		   "Clocking:\t%lu.%1luMHz\n"
-		   "BogoMips:\t%lu.%02lu\n"
-		   "Calibration:\t%lu loops\n",
-		   cpu, mmu, fpu,
-		   clockfreq/1000000,(clockfreq/100000)%10,
-		   (loops_per_jiffy*HZ)/500000,((loops_per_jiffy*HZ)/5000)%100,
-		   (loops_per_jiffy*HZ));
+	seq_printf(m, "CPU:\t\t%s\n"
+		      "MMU:\t\t%s\n"
+		      "FPU:\t\t%s\n"
+		      "Clocking:\t%lu.%1luMHz\n"
+		      "BogoMips:\t%lu.%02lu\n"
+		      "Calibration:\t%lu loops\n",
+		      cpu, mmu, fpu,
+		      clockfreq / 1000000,
+		      (clockfreq / 100000) % 10,
+		      (loops_per_jiffy * HZ) / 500000,
+		      ((loops_per_jiffy * HZ) / 5000) % 100,
+		      (loops_per_jiffy * HZ));
 
 	return 0;
 }
