Return-Path: <linux-kernel-owner+w=401wt.eu-S1765320AbXGOQPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765320AbXGOQPu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 12:15:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760706AbXGOQFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 12:05:34 -0400
Received: from www.osadl.org ([213.239.205.134]:42620 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762282AbXGOQFT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 12:05:19 -0400
Message-Id: <20070715155541.973781894@inhelltoy.tec.linutronix.de>
References: <20070715155510.341941668@inhelltoy.tec.linutronix.de>
User-Agent: quilt/0.46-1
Date: Sun, 15 Jul 2007 16:11:11 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <ak@suse.de>, Chris Wright <chrisw@sous-sol.org>
Subject: [patch-mm 29/33] x86_64: cleanup apic.c after clock events switch
Content-Disposition: inline; filename=x86_64-cleanup-apic-c.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Make variables static.

Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>

---

 arch/x86_64/kernel/apic.c |    6 +++---
 include/asm-x86_64/apic.h |    1 -
 2 files changed, 3 insertions(+), 4 deletions(-)

Index: linux-2.6.22-rc6-mm/arch/x86_64/kernel/apic.c
===================================================================
--- linux-2.6.22-rc6-mm.orig/arch/x86_64/kernel/apic.c	2007-07-15 17:48:14.000000000 +0200
+++ linux-2.6.22-rc6-mm/arch/x86_64/kernel/apic.c	2007-07-15 17:48:22.000000000 +0200
@@ -40,10 +40,10 @@
 #include <asm/hpet.h>
 #include <asm/apic.h>
 
-int apic_mapped;
 int apic_verbosity;
-int apic_calibrate_pmtmr __initdata;
-int disable_apic_timer __initdata;
+static int apic_mapped;
+static int apic_calibrate_pmtmr __initdata;
+static int disable_apic_timer __initdata;
 
 /* Local APIC timer works in C2? */
 int local_apic_timer_c2_ok;
Index: linux-2.6.22-rc6-mm/include/asm-x86_64/apic.h
===================================================================
--- linux-2.6.22-rc6-mm.orig/include/asm-x86_64/apic.h	2007-07-15 17:48:14.000000000 +0200
+++ linux-2.6.22-rc6-mm/include/asm-x86_64/apic.h	2007-07-15 17:48:22.000000000 +0200
@@ -19,7 +19,6 @@
 extern int apic_verbosity;
 extern int apic_runs_main_timer;
 extern int ioapic_force;
-extern int apic_mapped;
 
 /*
  * Define the default level of output to be very little

-- 

