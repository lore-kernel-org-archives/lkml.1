Return-Path: <linux-kernel-owner+w=401wt.eu-S1757488AbXE3Oda@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757488AbXE3Oda (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 10:33:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755869AbXE3ObZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 10:31:25 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:55596 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753385AbXE3ObV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 10:31:21 -0400
Message-Id: <20070530140228.008060643@polymtl.ca>
References: <20070530140025.917261793@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 30 May 2007 10:00:29 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Adrian Bunk <bunk@stusta.de>, Andi Kleen <andi@firstfloor.org>
Subject: [patch 4/9] Conditional Calls - Add kconfig menus
Content-Disposition: inline; filename=conditional-calls-kconfig-menus.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Wed, 30 May 2007 14:30:51 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Conditional calls provide a way to compile in kernels features that can be
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
 kernel/Kconfig.condcall  |   20 ++++++++++++++++++++
 26 files changed, 147 insertions(+)

Index: linux-2.6-lttng/arch/alpha/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/alpha/Kconfig	2007-05-30 08:42:52.000000000 -0400
+++ linux-2.6-lttng/arch/alpha/Kconfig	2007-05-30 08:43:43.000000000 -0400
@@ -653,6 +653,12 @@
 
 source "arch/alpha/oprofile/Kconfig"
 
+menu "Instrumentation Support"
+
+source "kernel/Kconfig.condcall"
+
+endmenu
+
 source "arch/alpha/Kconfig.debug"
 
 # DUMMY_CONSOLE may be defined in drivers/video/console/Kconfig
Index: linux-2.6-lttng/arch/arm/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/arm/Kconfig	2007-05-30 08:42:35.000000000 -0400
+++ linux-2.6-lttng/arch/arm/Kconfig	2007-05-30 08:43:43.000000000 -0400
@@ -1042,6 +1042,12 @@
 
 source "arch/arm/oprofile/Kconfig"
 
+menu "Instrumentation Support"
+
+source "kernel/Kconfig.condcall"
+
+endmenu
+
 source "arch/arm/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/arch/arm26/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/arm26/Kconfig	2007-05-30 08:42:35.000000000 -0400
+++ linux-2.6-lttng/arch/arm26/Kconfig	2007-05-30 08:43:43.000000000 -0400
@@ -241,6 +241,12 @@
 
 source "drivers/usb/Kconfig"
 
+menu "Instrumentation Support"
+
+source "kernel/Kconfig.condcall"
+
+endmenu
+
 source "arch/arm26/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/arch/cris/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/cris/Kconfig	2007-05-30 08:42:35.000000000 -0400
+++ linux-2.6-lttng/arch/cris/Kconfig	2007-05-30 08:43:43.000000000 -0400
@@ -198,6 +198,12 @@
 
 source "drivers/usb/Kconfig"
 
+menu "Instrumentation Support"
+
+source "kernel/Kconfig.condcall"
+
+endmenu
+
 source "arch/cris/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/arch/frv/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/frv/Kconfig	2007-05-30 08:42:35.000000000 -0400
+++ linux-2.6-lttng/arch/frv/Kconfig	2007-05-30 08:43:43.000000000 -0400
@@ -375,6 +375,12 @@
 
 source "fs/Kconfig"
 
+menu "Instrumentation Support"
+
+source "kernel/Kconfig.condcall"
+
+endmenu
+
 source "arch/frv/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/arch/h8300/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/h8300/Kconfig	2007-05-30 08:42:35.000000000 -0400
+++ linux-2.6-lttng/arch/h8300/Kconfig	2007-05-30 08:43:43.000000000 -0400
@@ -220,6 +220,12 @@
 
 source "fs/Kconfig"
 
+menu "Instrumentation Support"
+
+source "kernel/Kconfig.condcall"
+
+endmenu
+
 source "arch/h8300/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/arch/i386/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/i386/Kconfig	2007-05-30 08:42:53.000000000 -0400
+++ linux-2.6-lttng/arch/i386/Kconfig	2007-05-30 08:44:45.000000000 -0400
@@ -1233,6 +1233,8 @@
 	  for kernel debugging, non-intrusive instrumentation and testing.
 	  If in doubt, say "N".
 
+source "kernel/Kconfig.condcall"
+
 endif # INSTRUMENTATION
 
 source "arch/i386/Kconfig.debug"
Index: linux-2.6-lttng/arch/ia64/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/ia64/Kconfig	2007-05-30 08:42:35.000000000 -0400
+++ linux-2.6-lttng/arch/ia64/Kconfig	2007-05-30 08:43:43.000000000 -0400
@@ -590,6 +590,9 @@
 	  a probepoint and specifies the callback.  Kprobes is useful
 	  for kernel debugging, non-intrusive instrumentation and testing.
 	  If in doubt, say "N".
+
+source "kernel/Kconfig.condcall"
+
 endmenu
 
 source "arch/ia64/Kconfig.debug"
Index: linux-2.6-lttng/arch/m32r/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/m32r/Kconfig	2007-05-30 08:42:35.000000000 -0400
+++ linux-2.6-lttng/arch/m32r/Kconfig	2007-05-30 08:43:43.000000000 -0400
@@ -405,6 +405,12 @@
 
 source "arch/m32r/oprofile/Kconfig"
 
+menu "Instrumentation Support"
+
+source "kernel/Kconfig.condcall"
+
+endmenu
+
 source "arch/m32r/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/arch/m68k/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/m68k/Kconfig	2007-05-30 08:42:35.000000000 -0400
+++ linux-2.6-lttng/arch/m68k/Kconfig	2007-05-30 08:43:43.000000000 -0400
@@ -670,6 +670,12 @@
 
 source "fs/Kconfig"
 
+menu "Instrumentation Support"
+
+source "kernel/Kconfig.condcall"
+
+endmenu
+
 source "arch/m68k/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/arch/m68knommu/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/m68knommu/Kconfig	2007-05-30 08:42:35.000000000 -0400
+++ linux-2.6-lttng/arch/m68knommu/Kconfig	2007-05-30 08:43:43.000000000 -0400
@@ -668,6 +668,12 @@
 
 source "fs/Kconfig"
 
+menu "Instrumentation Support"
+
+source "kernel/Kconfig.condcall"
+
+endmenu
+
 source "arch/m68knommu/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/arch/mips/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/mips/Kconfig	2007-05-30 08:42:36.000000000 -0400
+++ linux-2.6-lttng/arch/mips/Kconfig	2007-05-30 08:43:43.000000000 -0400
@@ -1957,6 +1957,12 @@
 
 source "arch/mips/oprofile/Kconfig"
 
+menu "Instrumentation Support"
+
+source "kernel/Kconfig.condcall"
+
+endmenu
+
 source "arch/mips/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/arch/parisc/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/parisc/Kconfig	2007-05-30 08:42:35.000000000 -0400
+++ linux-2.6-lttng/arch/parisc/Kconfig	2007-05-30 08:43:43.000000000 -0400
@@ -269,6 +269,12 @@
 
 source "arch/parisc/oprofile/Kconfig"
 
+menu "Instrumentation Support"
+
+source "kernel/Kconfig.condcall"
+
+endmenu
+
 source "arch/parisc/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/arch/powerpc/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/powerpc/Kconfig	2007-05-30 08:42:35.000000000 -0400
+++ linux-2.6-lttng/arch/powerpc/Kconfig	2007-05-30 08:43:43.000000000 -0400
@@ -903,6 +903,9 @@
 	  a probepoint and specifies the callback.  Kprobes is useful
 	  for kernel debugging, non-intrusive instrumentation and testing.
 	  If in doubt, say "N".
+
+source "kernel/Kconfig.condcall"
+
 endmenu
 
 source "arch/powerpc/Kconfig.debug"
Index: linux-2.6-lttng/arch/ppc/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/ppc/Kconfig	2007-05-30 08:42:35.000000000 -0400
+++ linux-2.6-lttng/arch/ppc/Kconfig	2007-05-30 08:43:43.000000000 -0400
@@ -1451,8 +1451,14 @@
 
 source "lib/Kconfig"
 
+menu "Instrumentation Support"
+
 source "arch/powerpc/oprofile/Kconfig"
 
+source "kernel/Kconfig.condcall"
+
+endmenu
+
 source "arch/ppc/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/arch/s390/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/s390/Kconfig	2007-05-30 08:43:05.000000000 -0400
+++ linux-2.6-lttng/arch/s390/Kconfig	2007-05-30 08:43:43.000000000 -0400
@@ -549,6 +549,8 @@
 
 source "lib/Kconfig.statistic"
 
+source "kernel/Kconfig.condcall"
+
 endmenu
 
 source "arch/s390/Kconfig.debug"
Index: linux-2.6-lttng/arch/sh/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/sh/Kconfig	2007-05-30 08:42:35.000000000 -0400
+++ linux-2.6-lttng/arch/sh/Kconfig	2007-05-30 08:43:43.000000000 -0400
@@ -721,6 +721,12 @@
 
 source "arch/sh/oprofile/Kconfig"
 
+menu "Instrumentation Support"
+
+source "kernel/Kconfig.condcall"
+
+endmenu
+
 source "arch/sh/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/arch/sh64/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/sh64/Kconfig	2007-05-30 08:42:35.000000000 -0400
+++ linux-2.6-lttng/arch/sh64/Kconfig	2007-05-30 08:43:43.000000000 -0400
@@ -284,6 +284,12 @@
 
 source "arch/sh64/oprofile/Kconfig"
 
+menu "Instrumentation Support"
+
+source "kernel/Kconfig.condcall"
+
+endmenu
+
 source "arch/sh64/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/arch/sparc/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/sparc/Kconfig	2007-05-30 08:42:35.000000000 -0400
+++ linux-2.6-lttng/arch/sparc/Kconfig	2007-05-30 08:43:43.000000000 -0400
@@ -306,6 +306,8 @@
 
 source "arch/sparc/oprofile/Kconfig"
 
+source "kernel/Kconfig.condcall"
+
 endmenu
 
 source "arch/sparc/Kconfig.debug"
Index: linux-2.6-lttng/arch/sparc64/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/sparc64/Kconfig	2007-05-30 08:42:35.000000000 -0400
+++ linux-2.6-lttng/arch/sparc64/Kconfig	2007-05-30 08:43:43.000000000 -0400
@@ -438,6 +438,9 @@
 	  a probepoint and specifies the callback.  Kprobes is useful
 	  for kernel debugging, non-intrusive instrumentation and testing.
 	  If in doubt, say "N".
+
+source "kernel/Kconfig.condcall"
+
 endmenu
 
 source "arch/sparc64/Kconfig.debug"
Index: linux-2.6-lttng/arch/um/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/um/Kconfig	2007-05-30 08:42:35.000000000 -0400
+++ linux-2.6-lttng/arch/um/Kconfig	2007-05-30 08:43:43.000000000 -0400
@@ -336,4 +336,10 @@
 	bool
 	default n
 
+menu "Instrumentation Support"
+
+source "kernel/Kconfig.condcall"
+
+endmenu
+
 source "arch/um/Kconfig.debug"
Index: linux-2.6-lttng/arch/v850/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/v850/Kconfig	2007-05-30 08:42:35.000000000 -0400
+++ linux-2.6-lttng/arch/v850/Kconfig	2007-05-30 08:43:43.000000000 -0400
@@ -331,6 +331,12 @@
 
 source "drivers/usb/Kconfig"
 
+menu "Instrumentation Support"
+
+source "kernel/Kconfig.condcall"
+
+endmenu
+
 source "arch/v850/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/arch/x86_64/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/x86_64/Kconfig	2007-05-30 08:42:48.000000000 -0400
+++ linux-2.6-lttng/arch/x86_64/Kconfig	2007-05-30 08:43:43.000000000 -0400
@@ -794,6 +794,9 @@
 	  a probepoint and specifies the callback.  Kprobes is useful
 	  for kernel debugging, non-intrusive instrumentation and testing.
 	  If in doubt, say "N".
+
+source "kernel/Kconfig.condcall"
+
 endmenu
 
 source "arch/x86_64/Kconfig.debug"
Index: linux-2.6-lttng/arch/xtensa/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/xtensa/Kconfig	2007-05-30 08:42:35.000000000 -0400
+++ linux-2.6-lttng/arch/xtensa/Kconfig	2007-05-30 08:43:43.000000000 -0400
@@ -251,6 +251,12 @@
 	  provide one yourself.
 endmenu
 
+menu "Instrumentation Support"
+
+source "kernel/Kconfig.condcall"
+
+endmenu
+
 source "arch/xtensa/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/kernel/Kconfig.condcall
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/kernel/Kconfig.condcall	2007-05-30 08:43:43.000000000 -0400
@@ -0,0 +1,20 @@
+# Code markers configuration
+
+config COND_CALL
+	bool "Activate conditional calls"
+	depends on MODULES
+	help
+	  Provides a way to dynamically enable kernel features while having a
+	  very small footprint when disabled.
+
+config COND_CALL_DISABLE_OPTIMIZATION
+	bool "Disable conditional calls optimization"
+	depends on COND_CALL && EMBEDDED
+	default n
+	help
+	  Disable code replacement jump optimisations. Especially useful if your
+	  code is in a read-only rom/flash.
+
+config COND_CALL_ENABLE_OPTIMIZATION
+	def_bool y
+	depends on COND_CALL && !COND_CALL_DISABLE_OPTIMIZATION
Index: linux-2.6-lttng/arch/avr32/Kconfig.debug
===================================================================
--- linux-2.6-lttng.orig/arch/avr32/Kconfig.debug	2007-05-30 08:28:44.000000000 -0400
+++ linux-2.6-lttng/arch/avr32/Kconfig.debug	2007-05-30 08:43:43.000000000 -0400
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
 
+source "kernel/Kconfig.condcall"
+
+endmenu
+
 endmenu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
