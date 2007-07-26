Return-Path: <linux-kernel-owner+w=401wt.eu-S933187AbXGZPLs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933187AbXGZPLs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 11:11:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760977AbXGZPKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 11:10:23 -0400
Received: from rex.snapgear.com ([203.143.235.140]:47910 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758446AbXGZPKP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 11:10:15 -0400
Date: Fri, 27 Jul 2007 01:09:00 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200707261509.l6QF90HE004057@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU]: remove use of colfire_trap_init
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The switch to using the generic irq framework removed the 
coldfire_trap_init() code, so remove all references to it.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---

 5206/config.c  |    2 --
 5206e/config.c |    2 --
 520x/config.c  |    2 --
 523x/config.c  |    2 --
 5249/config.c  |    2 --
 5272/config.c  |    2 --
 527x/config.c  |    2 --
 528x/config.c  |    2 --
 5307/config.c  |    2 --
 532x/config.c  |    2 --
 5407/config.c  |    2 --
 11 files changed, 22 deletions(-)


diff -Naur linux-2.6.23-rc1-git2/arch/m68knommu/platform/5206/config.c linux/arch/m68knommu/platform/5206/config.c
--- linux-2.6.23-rc1-git2/arch/m68knommu/platform/5206/config.c	2007-07-26 11:03:08.000000000 +1000
+++ linux/arch/m68knommu/platform/5206/config.c	2007-07-26 22:40:20.000000000 +1000
@@ -28,7 +28,6 @@
 void coldfire_tick(void);
 void coldfire_timer_init(irq_handler_t handler);
 unsigned long coldfire_timer_offset(void);
-void coldfire_trap_init(void);
 void coldfire_reset(void);
 
 /***************************************************************************/
@@ -101,7 +100,6 @@
 	mach_sched_init = coldfire_timer_init;
 	mach_tick = coldfire_tick;
 	mach_gettimeoffset = coldfire_timer_offset;
-	mach_trap_init = coldfire_trap_init;
 	mach_reset = coldfire_reset;
 }
 
diff -Naur linux-2.6.23-rc1-git2/arch/m68knommu/platform/5206e/config.c linux/arch/m68knommu/platform/5206e/config.c
--- linux-2.6.23-rc1-git2/arch/m68knommu/platform/5206e/config.c	2007-07-26 11:03:08.000000000 +1000
+++ linux/arch/m68knommu/platform/5206e/config.c	2007-07-26 22:40:20.000000000 +1000
@@ -27,7 +27,6 @@
 void coldfire_tick(void);
 void coldfire_timer_init(irq_handler_t handler);
 unsigned long coldfire_timer_offset(void);
-void coldfire_trap_init(void);
 void coldfire_reset(void);
 
 /***************************************************************************/
@@ -107,7 +106,6 @@
 	mach_sched_init = coldfire_timer_init;
 	mach_tick = coldfire_tick;
 	mach_gettimeoffset = coldfire_timer_offset;
-	mach_trap_init = coldfire_trap_init;
 	mach_reset = coldfire_reset;
 }
 
diff -Naur linux-2.6.23-rc1-git2/arch/m68knommu/platform/520x/config.c linux/arch/m68knommu/platform/520x/config.c
--- linux-2.6.23-rc1-git2/arch/m68knommu/platform/520x/config.c	2007-07-26 11:03:08.000000000 +1000
+++ linux/arch/m68knommu/platform/520x/config.c	2007-07-26 22:40:20.000000000 +1000
@@ -30,7 +30,6 @@
 void coldfire_pit_tick(void);
 void coldfire_pit_init(irq_handler_t handler);
 unsigned long coldfire_pit_offset(void);
-void coldfire_trap_init(void);
 void coldfire_reset(void);
 
 /***************************************************************************/
@@ -51,7 +50,6 @@
     mach_sched_init = coldfire_pit_init;
     mach_tick = coldfire_pit_tick;
     mach_gettimeoffset = coldfire_pit_offset;
-    mach_trap_init = coldfire_trap_init;
     mach_reset = coldfire_reset;
 }
 
diff -Naur linux-2.6.23-rc1-git2/arch/m68knommu/platform/523x/config.c linux/arch/m68knommu/platform/523x/config.c
--- linux-2.6.23-rc1-git2/arch/m68knommu/platform/523x/config.c	2007-07-26 11:03:08.000000000 +1000
+++ linux/arch/m68knommu/platform/523x/config.c	2007-07-26 22:40:20.000000000 +1000
@@ -29,7 +29,6 @@
 void coldfire_pit_tick(void);
 void coldfire_pit_init(irq_handler_t handler);
 unsigned long coldfire_pit_offset(void);
-void coldfire_trap_init(void);
 void coldfire_reset(void);
 
 /***************************************************************************/
@@ -66,7 +65,6 @@
 	mach_sched_init = coldfire_pit_init;
 	mach_tick = coldfire_pit_tick;
 	mach_gettimeoffset = coldfire_pit_offset;
-	mach_trap_init = coldfire_trap_init;
 	mach_reset = coldfire_reset;
 }
 
diff -Naur linux-2.6.23-rc1-git2/arch/m68knommu/platform/5249/config.c linux/arch/m68knommu/platform/5249/config.c
--- linux-2.6.23-rc1-git2/arch/m68knommu/platform/5249/config.c	2007-07-26 11:03:08.000000000 +1000
+++ linux/arch/m68knommu/platform/5249/config.c	2007-07-26 22:40:20.000000000 +1000
@@ -27,7 +27,6 @@
 void coldfire_tick(void);
 void coldfire_timer_init(irq_handler_t handler);
 unsigned long coldfire_timer_offset(void);
-void coldfire_trap_init(void);
 void coldfire_reset(void);
 
 /***************************************************************************/
@@ -99,7 +98,6 @@
 	mach_sched_init = coldfire_timer_init;
 	mach_tick = coldfire_tick;
 	mach_gettimeoffset = coldfire_timer_offset;
-	mach_trap_init = coldfire_trap_init;
 	mach_reset = coldfire_reset;
 }
 
diff -Naur linux-2.6.23-rc1-git2/arch/m68knommu/platform/5272/config.c linux/arch/m68knommu/platform/5272/config.c
--- linux-2.6.23-rc1-git2/arch/m68knommu/platform/5272/config.c	2007-07-26 11:03:08.000000000 +1000
+++ linux/arch/m68knommu/platform/5272/config.c	2007-07-26 22:40:20.000000000 +1000
@@ -28,7 +28,6 @@
 void coldfire_tick(void);
 void coldfire_timer_init(irq_handler_t handler);
 unsigned long coldfire_timer_offset(void);
-void coldfire_trap_init(void);
 void coldfire_reset(void);
 
 extern unsigned int mcf_timervector;
@@ -132,7 +131,6 @@
 	mach_sched_init = coldfire_timer_init;
 	mach_tick = coldfire_tick;
 	mach_gettimeoffset = coldfire_timer_offset;
-	mach_trap_init = coldfire_trap_init;
 	mach_reset = coldfire_reset;
 }
 
diff -Naur linux-2.6.23-rc1-git2/arch/m68knommu/platform/527x/config.c linux/arch/m68knommu/platform/527x/config.c
--- linux-2.6.23-rc1-git2/arch/m68knommu/platform/527x/config.c	2007-07-26 11:03:08.000000000 +1000
+++ linux/arch/m68knommu/platform/527x/config.c	2007-07-26 22:40:20.000000000 +1000
@@ -29,7 +29,6 @@
 void coldfire_pit_tick(void);
 void coldfire_pit_init(irq_handler_t handler);
 unsigned long coldfire_pit_offset(void);
-void coldfire_trap_init(void);
 void coldfire_reset(void);
 
 /***************************************************************************/
@@ -66,7 +65,6 @@
 	mach_sched_init = coldfire_pit_init;
 	mach_tick = coldfire_pit_tick;
 	mach_gettimeoffset = coldfire_pit_offset;
-	mach_trap_init = coldfire_trap_init;
 	mach_reset = coldfire_reset;
 }
 
diff -Naur linux-2.6.23-rc1-git2/arch/m68knommu/platform/528x/config.c linux/arch/m68knommu/platform/528x/config.c
--- linux-2.6.23-rc1-git2/arch/m68knommu/platform/528x/config.c	2007-07-26 11:03:08.000000000 +1000
+++ linux/arch/m68knommu/platform/528x/config.c	2007-07-26 22:40:20.000000000 +1000
@@ -29,7 +29,6 @@
 void coldfire_pit_tick(void);
 void coldfire_pit_init(irq_handler_t handler);
 unsigned long coldfire_pit_offset(void);
-void coldfire_trap_init(void);
 void coldfire_reset(void);
 
 /***************************************************************************/
@@ -66,7 +65,6 @@
 	mach_sched_init = coldfire_pit_init;
 	mach_tick = coldfire_pit_tick;
 	mach_gettimeoffset = coldfire_pit_offset;
-	mach_trap_init = coldfire_trap_init;
 	mach_reset = coldfire_reset;
 }
 
diff -Naur linux-2.6.23-rc1-git2/arch/m68knommu/platform/5307/config.c linux/arch/m68knommu/platform/5307/config.c
--- linux-2.6.23-rc1-git2/arch/m68knommu/platform/5307/config.c	2007-07-26 11:03:08.000000000 +1000
+++ linux/arch/m68knommu/platform/5307/config.c	2007-07-26 22:40:20.000000000 +1000
@@ -29,7 +29,6 @@
 void coldfire_tick(void);
 void coldfire_timer_init(irq_handler_t handler);
 unsigned long coldfire_timer_offset(void);
-void coldfire_trap_init(void);
 void coldfire_reset(void);
 
 extern unsigned int mcf_timervector;
@@ -126,7 +125,6 @@
 	mach_sched_init = coldfire_timer_init;
 	mach_tick = coldfire_tick;
 	mach_gettimeoffset = coldfire_timer_offset;
-	mach_trap_init = coldfire_trap_init;
 	mach_reset = coldfire_reset;
 
 #ifdef MCF_BDM_DISABLE
diff -Naur linux-2.6.23-rc1-git2/arch/m68knommu/platform/532x/config.c linux/arch/m68knommu/platform/532x/config.c
--- linux-2.6.23-rc1-git2/arch/m68knommu/platform/532x/config.c	2007-07-26 11:03:08.000000000 +1000
+++ linux/arch/m68knommu/platform/532x/config.c	2007-07-26 22:40:20.000000000 +1000
@@ -37,7 +37,6 @@
 void coldfire_tick(void);
 void coldfire_timer_init(irq_handler_t handler);
 unsigned long coldfire_timer_offset(void);
-void coldfire_trap_init(void);
 void coldfire_reset(void);
 
 extern unsigned int mcf_timervector;
@@ -108,7 +107,6 @@
 	mach_sched_init = coldfire_timer_init;
 	mach_tick = coldfire_tick;
 	mach_gettimeoffset = coldfire_timer_offset;
-	mach_trap_init = coldfire_trap_init;
 	mach_reset = coldfire_reset;
 
 #ifdef MCF_BDM_DISABLE
diff -Naur linux-2.6.23-rc1-git2/arch/m68knommu/platform/5407/config.c linux/arch/m68knommu/platform/5407/config.c
--- linux-2.6.23-rc1-git2/arch/m68knommu/platform/5407/config.c	2007-07-26 11:03:08.000000000 +1000
+++ linux/arch/m68knommu/platform/5407/config.c	2007-07-26 22:40:20.000000000 +1000
@@ -28,7 +28,6 @@
 void coldfire_tick(void);
 void coldfire_timer_init(irq_handler_t handler);
 unsigned long coldfire_timer_offset(void);
-void coldfire_trap_init(void);
 void coldfire_reset(void);
 
 extern unsigned int mcf_timervector;
@@ -112,7 +111,6 @@
 	mach_sched_init = coldfire_timer_init;
 	mach_tick = coldfire_tick;
 	mach_gettimeoffset = coldfire_timer_offset;
-	mach_trap_init = coldfire_trap_init;
 	mach_reset = coldfire_reset;
 }
 
