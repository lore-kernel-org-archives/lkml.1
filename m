Return-Path: <linux-kernel-owner+w=401wt.eu-S1760037AbXGCRJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760037AbXGCRJV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 13:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758746AbXGCRI5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 13:08:57 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:52084 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758476AbXGCRIz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 13:08:55 -0400
Message-Id: <20070703164514.368411508@polymtl.ca>
References: <20070703164046.645090494@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Tue, 03 Jul 2007 12:40:50 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Adrian Bunk <bunk@stusta.de>, Andi Kleen <andi@firstfloor.org>
Subject: [patch 04/10] Immediate Value - Add kconfig menus
Content-Disposition: inline; filename=immediate-values-kconfig-menus.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Tue,  3 Jul 2007 17:08:33 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Immediate values provide a way to compile in kernels features that can be
enabled dynamically, with a very small footprint when disabled.

This patch:

Add Kconfig menus for the marker code.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Adrian Bunk <bunk@stusta.de>
CC: Andi Kleen <andi@firstfloor.org>
---

 arch/alpha/Kconfig       |    6 ++++++
 arch/arm/Kconfig         |    6 ++++++
 arch/arm26/Kconfig       |    6 ++++++
 arch/avr32/Kconfig.debug |    7 +++++++
 arch/cris/Kconfig        |    6 ++++++
 arch/frv/Kconfig         |    6 ++++++
 arch/h8300/Kconfig       |    6 ++++++
 arch/i386/Kconfig        |    2 ++
 arch/ia64/Kconfig        |    3 +++
 arch/m32r/Kconfig        |    6 ++++++
 arch/m68k/Kconfig        |    6 ++++++
 arch/m68knommu/Kconfig   |    6 ++++++
 arch/mips/Kconfig        |    6 ++++++
 arch/parisc/Kconfig      |    6 ++++++
 arch/powerpc/Kconfig     |    3 +++
 arch/ppc/Kconfig         |    6 ++++++
 arch/s390/Kconfig        |    2 ++
 arch/sh/Kconfig          |    6 ++++++
 arch/sh64/Kconfig        |    6 ++++++
 arch/sparc/Kconfig       |    2 ++
 arch/sparc64/Kconfig     |    3 +++
 arch/um/Kconfig          |    6 ++++++
 arch/v850/Kconfig        |    6 ++++++
 arch/x86_64/Kconfig      |    3 +++
 arch/xtensa/Kconfig      |    6 ++++++
 kernel/Kconfig.immediate |    9 +++++++++
 26 files changed, 136 insertions(+)

Index: linux-2.6-lttng/arch/alpha/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/alpha/Kconfig	2007-06-17 13:21:09.000000000 -0400
+++ linux-2.6-lttng/arch/alpha/Kconfig	2007-06-17 13:25:17.000000000 -0400
@@ -653,6 +653,12 @@
 
 source "arch/alpha/oprofile/Kconfig"
 
+menu "Instrumentation Support"
+
+source "kernel/Kconfig.immediate"
+
+endmenu
+
 source "arch/alpha/Kconfig.debug"
 
 # DUMMY_CONSOLE may be defined in drivers/video/console/Kconfig
Index: linux-2.6-lttng/arch/arm/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/arm/Kconfig	2007-06-17 13:21:09.000000000 -0400
+++ linux-2.6-lttng/arch/arm/Kconfig	2007-06-17 13:25:17.000000000 -0400
@@ -1046,6 +1046,12 @@
 
 source "arch/arm/oprofile/Kconfig"
 
+menu "Instrumentation Support"
+
+source "kernel/Kconfig.immediate"
+
+endmenu
+
 source "arch/arm/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/arch/arm26/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/arm26/Kconfig	2007-06-17 13:21:09.000000000 -0400
+++ linux-2.6-lttng/arch/arm26/Kconfig	2007-06-17 13:25:17.000000000 -0400
@@ -244,6 +244,12 @@
 
 source "drivers/usb/Kconfig"
 
+menu "Instrumentation Support"
+
+source "kernel/Kconfig.immediate"
+
+endmenu
+
 source "arch/arm26/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/arch/cris/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/cris/Kconfig	2007-06-17 13:21:09.000000000 -0400
+++ linux-2.6-lttng/arch/cris/Kconfig	2007-06-17 13:25:17.000000000 -0400
@@ -198,6 +198,12 @@
 
 source "drivers/usb/Kconfig"
 
+menu "Instrumentation Support"
+
+source "kernel/Kconfig.immediate"
+
+endmenu
+
 source "arch/cris/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/arch/frv/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/frv/Kconfig	2007-06-17 13:21:09.000000000 -0400
+++ linux-2.6-lttng/arch/frv/Kconfig	2007-06-17 13:25:17.000000000 -0400
@@ -375,6 +375,12 @@
 
 source "fs/Kconfig"
 
+menu "Instrumentation Support"
+
+source "kernel/Kconfig.immediate"
+
+endmenu
+
 source "arch/frv/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/arch/h8300/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/h8300/Kconfig	2007-06-17 13:21:09.000000000 -0400
+++ linux-2.6-lttng/arch/h8300/Kconfig	2007-06-17 13:25:17.000000000 -0400
@@ -223,6 +223,12 @@
 
 source "fs/Kconfig"
 
+menu "Instrumentation Support"
+
+source "kernel/Kconfig.immediate"
+
+endmenu
+
 source "arch/h8300/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/arch/i386/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/i386/Kconfig	2007-06-17 13:21:09.000000000 -0400
+++ linux-2.6-lttng/arch/i386/Kconfig	2007-06-17 13:25:17.000000000 -0400
@@ -1235,6 +1235,8 @@
 	  for kernel debugging, non-intrusive instrumentation and testing.
 	  If in doubt, say "N".
 
+source "kernel/Kconfig.immediate"
+
 endif # INSTRUMENTATION
 
 source "arch/i386/Kconfig.debug"
Index: linux-2.6-lttng/arch/ia64/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/ia64/Kconfig	2007-06-17 13:21:09.000000000 -0400
+++ linux-2.6-lttng/arch/ia64/Kconfig	2007-06-17 13:25:17.000000000 -0400
@@ -593,6 +593,9 @@
 	  a probepoint and specifies the callback.  Kprobes is useful
 	  for kernel debugging, non-intrusive instrumentation and testing.
 	  If in doubt, say "N".
+
+source "kernel/Kconfig.immediate"
+
 endmenu
 
 source "arch/ia64/Kconfig.debug"
Index: linux-2.6-lttng/arch/m32r/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/m32r/Kconfig	2007-06-17 13:21:09.000000000 -0400
+++ linux-2.6-lttng/arch/m32r/Kconfig	2007-06-17 13:25:17.000000000 -0400
@@ -408,6 +408,12 @@
 
 source "arch/m32r/oprofile/Kconfig"
 
+menu "Instrumentation Support"
+
+source "kernel/Kconfig.immediate"
+
+endmenu
+
 source "arch/m32r/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/arch/m68k/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/m68k/Kconfig	2007-06-17 13:21:09.000000000 -0400
+++ linux-2.6-lttng/arch/m68k/Kconfig	2007-06-17 13:25:17.000000000 -0400
@@ -679,6 +679,12 @@
 
 source "fs/Kconfig"
 
+menu "Instrumentation Support"
+
+source "kernel/Kconfig.immediate"
+
+endmenu
+
 source "arch/m68k/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/arch/m68knommu/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/m68knommu/Kconfig	2007-06-17 13:21:09.000000000 -0400
+++ linux-2.6-lttng/arch/m68knommu/Kconfig	2007-06-17 13:25:17.000000000 -0400
@@ -668,6 +668,12 @@
 
 source "fs/Kconfig"
 
+menu "Instrumentation Support"
+
+source "kernel/Kconfig.immediate"
+
+endmenu
+
 source "arch/m68knommu/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/arch/mips/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/mips/Kconfig	2007-06-17 13:21:09.000000000 -0400
+++ linux-2.6-lttng/arch/mips/Kconfig	2007-06-17 13:25:17.000000000 -0400
@@ -1957,6 +1957,12 @@
 
 source "arch/mips/oprofile/Kconfig"
 
+menu "Instrumentation Support"
+
+source "kernel/Kconfig.immediate"
+
+endmenu
+
 source "arch/mips/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/arch/parisc/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/parisc/Kconfig	2007-06-17 13:21:09.000000000 -0400
+++ linux-2.6-lttng/arch/parisc/Kconfig	2007-06-17 13:25:17.000000000 -0400
@@ -269,6 +269,12 @@
 
 source "arch/parisc/oprofile/Kconfig"
 
+menu "Instrumentation Support"
+
+source "kernel/Kconfig.immediate"
+
+endmenu
+
 source "arch/parisc/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/arch/powerpc/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/powerpc/Kconfig	2007-06-17 13:21:09.000000000 -0400
+++ linux-2.6-lttng/arch/powerpc/Kconfig	2007-06-17 13:25:17.000000000 -0400
@@ -905,6 +905,9 @@
 	  a probepoint and specifies the callback.  Kprobes is useful
 	  for kernel debugging, non-intrusive instrumentation and testing.
 	  If in doubt, say "N".
+
+source "kernel/Kconfig.immediate"
+
 endmenu
 
 source "arch/powerpc/Kconfig.debug"
Index: linux-2.6-lttng/arch/ppc/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/ppc/Kconfig	2007-06-17 13:21:09.000000000 -0400
+++ linux-2.6-lttng/arch/ppc/Kconfig	2007-06-17 13:25:17.000000000 -0400
@@ -1451,8 +1451,14 @@
 
 source "lib/Kconfig"
 
+menu "Instrumentation Support"
+
 source "arch/powerpc/oprofile/Kconfig"
 
+source "kernel/Kconfig.immediate"
+
+endmenu
+
 source "arch/ppc/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/arch/s390/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/s390/Kconfig	2007-06-17 13:21:09.000000000 -0400
+++ linux-2.6-lttng/arch/s390/Kconfig	2007-06-17 13:25:17.000000000 -0400
@@ -547,6 +547,8 @@
 	  for kernel debugging, non-intrusive instrumentation and testing.
 	  If in doubt, say "N".
 
+source "kernel/Kconfig.immediate"
+
 endmenu
 
 source "arch/s390/Kconfig.debug"
Index: linux-2.6-lttng/arch/sh/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/sh/Kconfig	2007-06-17 13:21:09.000000000 -0400
+++ linux-2.6-lttng/arch/sh/Kconfig	2007-06-17 13:25:17.000000000 -0400
@@ -721,6 +721,12 @@
 
 source "arch/sh/oprofile/Kconfig"
 
+menu "Instrumentation Support"
+
+source "kernel/Kconfig.immediate"
+
+endmenu
+
 source "arch/sh/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/arch/sh64/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/sh64/Kconfig	2007-06-17 13:21:09.000000000 -0400
+++ linux-2.6-lttng/arch/sh64/Kconfig	2007-06-17 13:25:17.000000000 -0400
@@ -284,6 +284,12 @@
 
 source "arch/sh64/oprofile/Kconfig"
 
+menu "Instrumentation Support"
+
+source "kernel/Kconfig.immediate"
+
+endmenu
+
 source "arch/sh64/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/arch/sparc/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/sparc/Kconfig	2007-06-17 13:21:09.000000000 -0400
+++ linux-2.6-lttng/arch/sparc/Kconfig	2007-06-17 13:25:17.000000000 -0400
@@ -313,6 +313,8 @@
 
 source "arch/sparc/oprofile/Kconfig"
 
+source "kernel/Kconfig.immediate"
+
 endmenu
 
 source "arch/sparc/Kconfig.debug"
Index: linux-2.6-lttng/arch/sparc64/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/sparc64/Kconfig	2007-06-17 13:21:09.000000000 -0400
+++ linux-2.6-lttng/arch/sparc64/Kconfig	2007-06-17 13:25:17.000000000 -0400
@@ -438,6 +438,9 @@
 	  a probepoint and specifies the callback.  Kprobes is useful
 	  for kernel debugging, non-intrusive instrumentation and testing.
 	  If in doubt, say "N".
+
+source "kernel/Kconfig.immediate"
+
 endmenu
 
 source "arch/sparc64/Kconfig.debug"
Index: linux-2.6-lttng/arch/um/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/um/Kconfig	2007-06-17 13:21:09.000000000 -0400
+++ linux-2.6-lttng/arch/um/Kconfig	2007-06-17 13:25:17.000000000 -0400
@@ -335,4 +335,10 @@
 	bool
 	default n
 
+menu "Instrumentation Support"
+
+source "kernel/Kconfig.immediate"
+
+endmenu
+
 source "arch/um/Kconfig.debug"
Index: linux-2.6-lttng/arch/v850/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/v850/Kconfig	2007-06-17 13:21:09.000000000 -0400
+++ linux-2.6-lttng/arch/v850/Kconfig	2007-06-17 13:25:17.000000000 -0400
@@ -331,6 +331,12 @@
 
 source "drivers/usb/Kconfig"
 
+menu "Instrumentation Support"
+
+source "kernel/Kconfig.immediate"
+
+endmenu
+
 source "arch/v850/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/arch/x86_64/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/x86_64/Kconfig	2007-06-17 13:21:09.000000000 -0400
+++ linux-2.6-lttng/arch/x86_64/Kconfig	2007-06-17 13:25:17.000000000 -0400
@@ -792,6 +792,9 @@
 	  a probepoint and specifies the callback.  Kprobes is useful
 	  for kernel debugging, non-intrusive instrumentation and testing.
 	  If in doubt, say "N".
+
+source "kernel/Kconfig.immediate"
+
 endmenu
 
 source "arch/x86_64/Kconfig.debug"
Index: linux-2.6-lttng/arch/xtensa/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/xtensa/Kconfig	2007-06-17 13:21:09.000000000 -0400
+++ linux-2.6-lttng/arch/xtensa/Kconfig	2007-06-17 13:25:17.000000000 -0400
@@ -251,6 +251,12 @@
 	  provide one yourself.
 endmenu
 
+menu "Instrumentation Support"
+
+source "kernel/Kconfig.immediate"
+
+endmenu
+
 source "arch/xtensa/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/kernel/Kconfig.immediate
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/kernel/Kconfig.immediate	2007-06-17 13:25:27.000000000 -0400
@@ -0,0 +1,9 @@
+# Immediate values configuration
+
+config IMMEDIATE
+	bool "Use self-modifying code to provide fast immediate values"
+	help
+	  Provides a way to use immediate values acting as global values to
+	  dynamically enable kernel features while having a very small
+	  footprint when disabled. You may want to disable this feature if you
+	  run your kernel code on a read-only rom/flash.
Index: linux-2.6-lttng/arch/avr32/Kconfig.debug
===================================================================
--- linux-2.6-lttng.orig/arch/avr32/Kconfig.debug	2007-06-17 13:21:09.000000000 -0400
+++ linux-2.6-lttng/arch/avr32/Kconfig.debug	2007-06-17 13:25:17.000000000 -0400
@@ -6,6 +6,9 @@
 
 source "lib/Kconfig.debug"
 
+menu "Instrumentation Support"
+	depends on EXPERIMENTAL
+
 config KPROBES
 	bool "Kprobes"
 	depends on DEBUG_KERNEL
@@ -16,4 +19,8 @@
           for kernel debugging, non-intrusive instrumentation and testing.
           If in doubt, say "N".
 
+source "kernel/Kconfig.immediate"
+
+endmenu
+
 endmenu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
