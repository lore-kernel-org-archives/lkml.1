Return-Path: <linux-kernel-owner+w=401wt.eu-S1761049AbYBLGOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761049AbYBLGOp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 01:14:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752979AbYBLGOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 01:14:38 -0500
Received: from rex.snapgear.com ([203.143.235.140]:52903 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752461AbYBLGOh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 01:14:37 -0500
Date: Tue, 12 Feb 2008 16:12:01 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200802120612.m1C6C1Jt009946@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU]: use asflags instead of EXTRA_AFLAGS
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modify the extra asm flags for debugger capabilities,
use asflags instead for EXTRA_AFLAGS. Suggestion from
Sam Ravnborg <sam@ravnborg.org>.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---

diff -Naurp linux-2.6.25-rc1/arch/m68knommu/platform/5206/Makefile linux-2.6.x/arch/m68knommu/platform/5206/Makefile
--- linux-2.6.25-rc1/arch/m68knommu/platform/5206/Makefile	2008-01-25 08:58:37.000000000 +1000
+++ linux-2.6.x/arch/m68knommu/platform/5206/Makefile	2008-02-12 14:05:13.000000000 +1000
@@ -12,9 +12,7 @@
 # EXTRA_AFLAGS += -DTRAP_DBG_INTERRUPT
 #
 
-ifdef CONFIG_FULLDEBUG
-EXTRA_AFLAGS += -DDEBUGGER_COMPATIBLE_CACHE=1
-endif
+asflags-$(CONFIG_FULLDEBUG) := -DDEBUGGER_COMPATIBLE_CACHE=1
 
 obj-y := config.o
 
diff -Naurp linux-2.6.25-rc1/arch/m68knommu/platform/5206e/Makefile linux-2.6.x/arch/m68knommu/platform/5206e/Makefile
--- linux-2.6.25-rc1/arch/m68knommu/platform/5206e/Makefile	2008-01-25 08:58:37.000000000 +1000
+++ linux-2.6.x/arch/m68knommu/platform/5206e/Makefile	2008-02-12 14:05:14.000000000 +1000
@@ -12,9 +12,7 @@
 # EXTRA_AFLAGS += -DTRAP_DBG_INTERRUPT
 #
 
-ifdef CONFIG_FULLDEBUG
-EXTRA_AFLAGS += -DDEBUGGER_COMPATIBLE_CACHE=1
-endif
+asflags-$(CONFIG_FULLDEBUG) := -DDEBUGGER_COMPATIBLE_CACHE=1
 
 obj-y := config.o
 
diff -Naurp linux-2.6.25-rc1/arch/m68knommu/platform/520x/Makefile linux-2.6.x/arch/m68knommu/platform/520x/Makefile
--- linux-2.6.25-rc1/arch/m68knommu/platform/520x/Makefile	2008-01-25 08:58:37.000000000 +1000
+++ linux-2.6.x/arch/m68knommu/platform/520x/Makefile	2008-02-12 14:05:14.000000000 +1000
@@ -12,8 +12,6 @@
 # EXTRA_AFLAGS += -DTRAP_DBG_INTERRUPT
 #
 
-ifdef CONFIG_FULLDEBUG
-EXTRA_AFLAGS += -DDEBUGGER_COMPATIBLE_CACHE=1
-endif
+asflags-$(CONFIG_FULLDEBUG) := -DDEBUGGER_COMPATIBLE_CACHE=1
 
 obj-y := config.o
diff -Naurp linux-2.6.25-rc1/arch/m68knommu/platform/523x/Makefile linux-2.6.x/arch/m68knommu/platform/523x/Makefile
--- linux-2.6.25-rc1/arch/m68knommu/platform/523x/Makefile	2008-01-25 08:58:37.000000000 +1000
+++ linux-2.6.x/arch/m68knommu/platform/523x/Makefile	2008-02-12 14:05:14.000000000 +1000
@@ -12,8 +12,6 @@
 # EXTRA_AFLAGS += -DTRAP_DBG_INTERRUPT
 #
 
-ifdef CONFIG_FULLDEBUG
-EXTRA_AFLAGS += -DDEBUGGER_COMPATIBLE_CACHE=1
-endif
+asflags-$(CONFIG_FULLDEBUG) := -DDEBUGGER_COMPATIBLE_CACHE=1
 
 obj-y := config.o
diff -Naurp linux-2.6.25-rc1/arch/m68knommu/platform/5249/Makefile linux-2.6.x/arch/m68knommu/platform/5249/Makefile
--- linux-2.6.25-rc1/arch/m68knommu/platform/5249/Makefile	2008-01-25 08:58:37.000000000 +1000
+++ linux-2.6.x/arch/m68knommu/platform/5249/Makefile	2008-02-12 14:05:14.000000000 +1000
@@ -12,9 +12,7 @@
 # EXTRA_AFLAGS += -DTRAP_DBG_INTERRUPT
 #
 
-ifdef CONFIG_FULLDEBUG
-EXTRA_AFLAGS += -DDEBUGGER_COMPATIBLE_CACHE=1
-endif
+asflags-$(CONFIG_FULLDEBUG) := -DDEBUGGER_COMPATIBLE_CACHE=1
 
 obj-y := config.o
 
diff -Naurp linux-2.6.25-rc1/arch/m68knommu/platform/5272/Makefile linux-2.6.x/arch/m68knommu/platform/5272/Makefile
--- linux-2.6.25-rc1/arch/m68knommu/platform/5272/Makefile	2008-01-25 08:58:37.000000000 +1000
+++ linux-2.6.x/arch/m68knommu/platform/5272/Makefile	2008-02-12 14:05:14.000000000 +1000
@@ -12,9 +12,7 @@
 # EXTRA_AFLAGS += -DTRAP_DBG_INTERRUPT
 #
 
-ifdef CONFIG_FULLDEBUG
-EXTRA_AFLAGS += -DDEBUGGER_COMPATIBLE_CACHE=1
-endif
+asflags-$(CONFIG_FULLDEBUG) := -DDEBUGGER_COMPATIBLE_CACHE=1
 
 obj-y := config.o
 
diff -Naurp linux-2.6.25-rc1/arch/m68knommu/platform/527x/Makefile linux-2.6.x/arch/m68knommu/platform/527x/Makefile
--- linux-2.6.25-rc1/arch/m68knommu/platform/527x/Makefile	2008-01-25 08:58:37.000000000 +1000
+++ linux-2.6.x/arch/m68knommu/platform/527x/Makefile	2008-02-12 14:05:14.000000000 +1000
@@ -12,9 +12,7 @@
 # EXTRA_AFLAGS += -DTRAP_DBG_INTERRUPT
 #
 
-ifdef CONFIG_FULLDEBUG
-EXTRA_AFLAGS += -DDEBUGGER_COMPATIBLE_CACHE=1
-endif
+asflags-$(CONFIG_FULLDEBUG) := -DDEBUGGER_COMPATIBLE_CACHE=1
 
 obj-y := config.o
 
diff -Naurp linux-2.6.25-rc1/arch/m68knommu/platform/528x/Makefile linux-2.6.x/arch/m68knommu/platform/528x/Makefile
--- linux-2.6.25-rc1/arch/m68knommu/platform/528x/Makefile	2008-01-25 08:58:37.000000000 +1000
+++ linux-2.6.x/arch/m68knommu/platform/528x/Makefile	2008-02-12 14:05:14.000000000 +1000
@@ -12,9 +12,7 @@
 # EXTRA_AFLAGS += -DTRAP_DBG_INTERRUPT
 #
 
-ifdef CONFIG_FULLDEBUG
-EXTRA_AFLAGS += -DDEBUGGER_COMPATIBLE_CACHE=1
-endif
+asflags-$(CONFIG_FULLDEBUG) := -DDEBUGGER_COMPATIBLE_CACHE=1
 
 obj-y := config.o
 
diff -Naurp linux-2.6.25-rc1/arch/m68knommu/platform/5307/Makefile linux-2.6.x/arch/m68knommu/platform/5307/Makefile
--- linux-2.6.25-rc1/arch/m68knommu/platform/5307/Makefile	2008-02-11 14:50:21.000000000 +1000
+++ linux-2.6.x/arch/m68knommu/platform/5307/Makefile	2008-02-12 14:05:14.000000000 +1000
@@ -12,9 +12,7 @@
 # EXTRA_AFLAGS += -DTRAP_DBG_INTERRUPT
 #
 
-ifdef CONFIG_FULLDEBUG
-EXTRA_AFLAGS += -DDEBUGGER_COMPATIBLE_CACHE=1
-endif
+asflags-$(CONFIG_FULLDEBUG) := -DDEBUGGER_COMPATIBLE_CACHE=1
 
 obj-y	+= config.o
 
diff -Naurp linux-2.6.25-rc1/arch/m68knommu/platform/532x/Makefile linux-2.6.x/arch/m68knommu/platform/532x/Makefile
--- linux-2.6.25-rc1/arch/m68knommu/platform/532x/Makefile	2008-01-25 08:58:37.000000000 +1000
+++ linux-2.6.x/arch/m68knommu/platform/532x/Makefile	2008-02-12 14:05:14.000000000 +1000
@@ -12,9 +12,7 @@
 # EXTRA_AFLAGS += -DTRAP_DBG_INTERRUPT
 #
 
-ifdef CONFIG_FULLDEBUG
-EXTRA_AFLAGS += -DDEBUGGER_COMPATIBLE_CACHE=1
-endif
+asflags-$(CONFIG_FULLDEBUG) := -DDEBUGGER_COMPATIBLE_CACHE=1
 
 #obj-y := config.o usb-mcf532x.o spi-mcf532x.o
 obj-y := config.o
diff -Naurp linux-2.6.25-rc1/arch/m68knommu/platform/5407/Makefile linux-2.6.x/arch/m68knommu/platform/5407/Makefile
--- linux-2.6.25-rc1/arch/m68knommu/platform/5407/Makefile	2008-01-25 08:58:37.000000000 +1000
+++ linux-2.6.x/arch/m68knommu/platform/5407/Makefile	2008-02-12 14:05:14.000000000 +1000
@@ -12,9 +12,7 @@
 # EXTRA_AFLAGS += -DTRAP_DBG_INTERRUPT
 #
 
-ifdef CONFIG_FULLDEBUG
-EXTRA_AFLAGS += -DDEBUGGER_COMPATIBLE_CACHE=1
-endif
+asflags-$(CONFIG_FULLDEBUG) := -DDEBUGGER_COMPATIBLE_CACHE=1
 
 obj-y := config.o
 
diff -Naurp linux-2.6.25-rc1/arch/m68knommu/platform/coldfire/Makefile linux-2.6.x/arch/m68knommu/platform/coldfire/Makefile
--- linux-2.6.25-rc1/arch/m68knommu/platform/coldfire/Makefile	2008-02-11 14:50:21.000000000 +1000
+++ linux-2.6.x/arch/m68knommu/platform/coldfire/Makefile	2008-02-12 14:05:13.000000000 +1000
@@ -12,9 +12,7 @@
 # EXTRA_AFLAGS += -DTRAP_DBG_INTERRUPT
 #
 
-ifdef CONFIG_FULLDEBUG
-AFLAGS += -DDEBUGGER_COMPATIBLE_CACHE=1
-endif
+asflags-$(CONFIG_FULLDEBUG) := -DDEBUGGER_COMPATIBLE_CACHE=1
 
 obj-$(CONFIG_COLDFIRE)	+= dma.o entry.o vectors.o
 obj-$(CONFIG_M5206)	+= timers.o
