Return-Path: <linux-kernel-owner+w=401wt.eu-S965259AbXB0AMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965259AbXB0AMd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 19:12:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965277AbXB0AL7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 19:11:59 -0500
Received: from mga07.intel.com ([143.182.124.22]:27949 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965267AbXB0ALz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 19:11:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,221,1170662400"; 
   d="scan'208"; a="187440851:sNHT22389003"
Message-Id: <20070227001605.729627007@sodium.jf.intel.com>
References: <20070227001338.344233745@sodium.jf.intel.com>
User-Agent: quilt/0.45-1
Date: Mon, 26 Feb 2007 16:13:40 -0800
From: inaky@linux.intel.com
To: Arjan van de Ven <arjan@infradead.org>, mingo@redhat.com, akpm@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 2/2] semaphores: all arches use include/asm-generic/semaphore.h
Content-Disposition: inline; filename=semaphores-all-arches-use-include-asm-generic-semaphore-h.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

As suggested by Arjan van de Ven, introduced a generic semaphore.h for
all that arches (previous patch in series). Make all arches include
that generic file.

Warning: not compile tested in all arches

Signed-off-by: Inaky Perez-Gonzalez <inaky@linux.intel.com>

---
 include/asm-alpha/semaphore.h     |    1 +
 include/asm-arm/semaphore.h       |    1 +
 include/asm-arm26/semaphore.h     |    1 +
 include/asm-avr32/semaphore.h     |    1 +
 include/asm-cris/semaphore.h      |    1 +
 include/asm-frv/semaphore.h       |    1 +
 include/asm-h8300/semaphore.h     |    1 +
 include/asm-i386/semaphore.h      |    1 +
 include/asm-ia64/semaphore.h      |    1 +
 include/asm-m32r/semaphore.h      |    1 +
 include/asm-m68k/semaphore.h      |    1 +
 include/asm-m68knommu/semaphore.h |    1 +
 include/asm-mips/semaphore.h      |    1 +
 include/asm-parisc/semaphore.h    |    1 +
 include/asm-powerpc/semaphore.h   |    1 +
 include/asm-s390/semaphore.h      |    1 +
 include/asm-sh/semaphore.h        |    1 +
 include/asm-sh64/semaphore.h      |    1 +
 include/asm-sparc/semaphore.h     |    1 +
 include/asm-sparc64/semaphore.h   |    1 +
 include/asm-v850/semaphore.h      |    1 +
 include/asm-x86_64/semaphore.h    |    1 +
 include/asm-xtensa/semaphore.h    |    1 +
 23 files changed, 23 insertions(+)

Index: linux.hg/include/asm-alpha/semaphore.h
===================================================================
--- linux.hg.orig/include/asm-alpha/semaphore.h	2007-02-26 15:51:27.000000000 -0800
+++ linux.hg/include/asm-alpha/semaphore.h	2007-02-26 15:53:11.000000000 -0800
@@ -11,6 +11,7 @@
 #include <asm/current.h>
 #include <asm/system.h>
 #include <asm/atomic.h>
+#include <asm-generic/semaphore.h>
 #include <linux/compiler.h>
 #include <linux/wait.h>
 #include <linux/rwsem.h>
Index: linux.hg/include/asm-arm/semaphore.h
===================================================================
--- linux.hg.orig/include/asm-arm/semaphore.h	2007-02-26 15:51:27.000000000 -0800
+++ linux.hg/include/asm-arm/semaphore.h	2007-02-26 15:53:11.000000000 -0800
@@ -11,6 +11,7 @@
 
 #include <asm/atomic.h>
 #include <asm/locks.h>
+#include <asm-generic/semaphore.h>
 
 struct semaphore {
 	atomic_t count;
Index: linux.hg/include/asm-arm26/semaphore.h
===================================================================
--- linux.hg.orig/include/asm-arm26/semaphore.h	2007-02-26 15:51:26.000000000 -0800
+++ linux.hg/include/asm-arm26/semaphore.h	2007-02-26 15:53:11.000000000 -0800
@@ -11,6 +11,7 @@
 
 #include <asm/atomic.h>
 #include <asm/locks.h>
+#include <asm-generic/semaphore.h>
 
 struct semaphore {
 	atomic_t count;
Index: linux.hg/include/asm-avr32/semaphore.h
===================================================================
--- linux.hg.orig/include/asm-avr32/semaphore.h	2007-02-26 15:51:26.000000000 -0800
+++ linux.hg/include/asm-avr32/semaphore.h	2007-02-26 15:53:11.000000000 -0800
@@ -17,6 +17,7 @@
 
 #include <asm/system.h>
 #include <asm/atomic.h>
+#include <asm-generic/semaphore.h>
 #include <linux/wait.h>
 #include <linux/rwsem.h>
 
Index: linux.hg/include/asm-cris/semaphore.h
===================================================================
--- linux.hg.orig/include/asm-cris/semaphore.h	2007-02-26 15:51:26.000000000 -0800
+++ linux.hg/include/asm-cris/semaphore.h	2007-02-26 15:53:11.000000000 -0800
@@ -13,6 +13,7 @@
 
 #include <asm/system.h>
 #include <asm/atomic.h>
+#include <asm-generic/semaphore.h>
 
 /*
  * CRIS semaphores, implemented in C-only so far. 
Index: linux.hg/include/asm-frv/semaphore.h
===================================================================
--- linux.hg.orig/include/asm-frv/semaphore.h	2007-02-26 15:51:27.000000000 -0800
+++ linux.hg/include/asm-frv/semaphore.h	2007-02-26 15:53:11.000000000 -0800
@@ -19,6 +19,7 @@
 #include <linux/wait.h>
 #include <linux/spinlock.h>
 #include <linux/rwsem.h>
+#include <asm-generic/semaphore.h>
 
 #define SEMAPHORE_DEBUG		0
 
Index: linux.hg/include/asm-h8300/semaphore.h
===================================================================
--- linux.hg.orig/include/asm-h8300/semaphore.h	2007-02-26 15:51:26.000000000 -0800
+++ linux.hg/include/asm-h8300/semaphore.h	2007-02-26 15:53:11.000000000 -0800
@@ -12,6 +12,7 @@
 
 #include <asm/system.h>
 #include <asm/atomic.h>
+#include <asm-generic/semaphore.h>
 
 /*
  * Interrupt-safe semaphores..
Index: linux.hg/include/asm-i386/semaphore.h
===================================================================
--- linux.hg.orig/include/asm-i386/semaphore.h	2007-02-26 15:51:27.000000000 -0800
+++ linux.hg/include/asm-i386/semaphore.h	2007-02-26 15:53:11.000000000 -0800
@@ -38,6 +38,7 @@
 
 #include <asm/system.h>
 #include <asm/atomic.h>
+#include <asm-generic/semaphore.h>
 #include <linux/wait.h>
 #include <linux/rwsem.h>
 
Index: linux.hg/include/asm-ia64/semaphore.h
===================================================================
--- linux.hg.orig/include/asm-ia64/semaphore.h	2007-02-26 15:51:27.000000000 -0800
+++ linux.hg/include/asm-ia64/semaphore.h	2007-02-26 15:53:11.000000000 -0800
@@ -10,6 +10,7 @@
 #include <linux/rwsem.h>
 
 #include <asm/atomic.h>
+#include <asm-generic/semaphore.h>
 
 struct semaphore {
 	atomic_t count;
Index: linux.hg/include/asm-m32r/semaphore.h
===================================================================
--- linux.hg.orig/include/asm-m32r/semaphore.h	2007-02-26 15:51:27.000000000 -0800
+++ linux.hg/include/asm-m32r/semaphore.h	2007-02-26 15:53:11.000000000 -0800
@@ -17,6 +17,7 @@
 #include <asm/assembler.h>
 #include <asm/system.h>
 #include <asm/atomic.h>
+#include <asm-generic/semaphore.h>
 
 struct semaphore {
 	atomic_t count;
Index: linux.hg/include/asm-m68k/semaphore.h
===================================================================
--- linux.hg.orig/include/asm-m68k/semaphore.h	2007-02-26 15:51:26.000000000 -0800
+++ linux.hg/include/asm-m68k/semaphore.h	2007-02-26 15:53:11.000000000 -0800
@@ -13,6 +13,7 @@
 
 #include <asm/system.h>
 #include <asm/atomic.h>
+#include <asm-generic/semaphore.h>
 
 /*
  * Interrupt-safe semaphores..
Index: linux.hg/include/asm-m68knommu/semaphore.h
===================================================================
--- linux.hg.orig/include/asm-m68knommu/semaphore.h	2007-02-26 15:51:27.000000000 -0800
+++ linux.hg/include/asm-m68knommu/semaphore.h	2007-02-26 15:53:11.000000000 -0800
@@ -12,6 +12,7 @@
 
 #include <asm/system.h>
 #include <asm/atomic.h>
+#include <asm-generic/semaphore.h>
 
 /*
  * Interrupt-safe semaphores..
Index: linux.hg/include/asm-mips/semaphore.h
===================================================================
--- linux.hg.orig/include/asm-mips/semaphore.h	2007-02-26 15:51:27.000000000 -0800
+++ linux.hg/include/asm-mips/semaphore.h	2007-02-26 15:53:11.000000000 -0800
@@ -26,6 +26,7 @@
 
 #include <asm/atomic.h>
 #include <asm/system.h>
+#include <asm-generic/semaphore.h>
 #include <linux/wait.h>
 #include <linux/rwsem.h>
 
Index: linux.hg/include/asm-parisc/semaphore.h
===================================================================
--- linux.hg.orig/include/asm-parisc/semaphore.h	2007-02-26 15:51:26.000000000 -0800
+++ linux.hg/include/asm-parisc/semaphore.h	2007-02-26 15:53:11.000000000 -0800
@@ -29,6 +29,7 @@
 #include <linux/rwsem.h>
 
 #include <asm/system.h>
+#include <asm-generic/semaphore.h>
 
 /*
  * The `count' is initialised to the number of people who are allowed to
Index: linux.hg/include/asm-powerpc/semaphore.h
===================================================================
--- linux.hg.orig/include/asm-powerpc/semaphore.h	2007-02-26 15:51:27.000000000 -0800
+++ linux.hg/include/asm-powerpc/semaphore.h	2007-02-26 15:53:11.000000000 -0800
@@ -12,6 +12,7 @@
 
 #include <asm/atomic.h>
 #include <asm/system.h>
+#include <asm-generic/semaphore.h>
 #include <linux/wait.h>
 #include <linux/rwsem.h>
 
Index: linux.hg/include/asm-s390/semaphore.h
===================================================================
--- linux.hg.orig/include/asm-s390/semaphore.h	2007-02-26 15:51:27.000000000 -0800
+++ linux.hg/include/asm-s390/semaphore.h	2007-02-26 15:53:11.000000000 -0800
@@ -13,6 +13,7 @@
 
 #include <asm/system.h>
 #include <asm/atomic.h>
+#include <asm-generic/semaphore.h>
 #include <linux/wait.h>
 #include <linux/rwsem.h>
 
Index: linux.hg/include/asm-sh/semaphore.h
===================================================================
--- linux.hg.orig/include/asm-sh/semaphore.h	2007-02-26 15:51:27.000000000 -0800
+++ linux.hg/include/asm-sh/semaphore.h	2007-02-26 15:53:11.000000000 -0800
@@ -19,6 +19,7 @@
 
 #include <asm/system.h>
 #include <asm/atomic.h>
+#include <asm-generic/semaphore.h>
 
 struct semaphore {
 	atomic_t count;
Index: linux.hg/include/asm-sh64/semaphore.h
===================================================================
--- linux.hg.orig/include/asm-sh64/semaphore.h	2007-02-26 15:51:26.000000000 -0800
+++ linux.hg/include/asm-sh64/semaphore.h	2007-02-26 15:53:11.000000000 -0800
@@ -26,6 +26,7 @@
 
 #include <asm/system.h>
 #include <asm/atomic.h>
+#include <asm-generic/semaphore.h>
 
 struct semaphore {
 	atomic_t count;
Index: linux.hg/include/asm-sparc/semaphore.h
===================================================================
--- linux.hg.orig/include/asm-sparc/semaphore.h	2007-02-26 15:51:26.000000000 -0800
+++ linux.hg/include/asm-sparc/semaphore.h	2007-02-26 15:53:11.000000000 -0800
@@ -6,6 +6,7 @@
 #ifdef __KERNEL__
 
 #include <asm/atomic.h>
+#include <asm-generic/semaphore.h>
 #include <linux/wait.h>
 #include <linux/rwsem.h>
 
Index: linux.hg/include/asm-sparc64/semaphore.h
===================================================================
--- linux.hg.orig/include/asm-sparc64/semaphore.h	2007-02-26 15:51:27.000000000 -0800
+++ linux.hg/include/asm-sparc64/semaphore.h	2007-02-26 15:53:11.000000000 -0800
@@ -10,6 +10,7 @@
 
 #include <asm/atomic.h>
 #include <asm/system.h>
+#include <asm-generic/semaphore.h>
 #include <linux/wait.h>
 #include <linux/rwsem.h>
 
Index: linux.hg/include/asm-v850/semaphore.h
===================================================================
--- linux.hg.orig/include/asm-v850/semaphore.h	2007-02-26 15:51:27.000000000 -0800
+++ linux.hg/include/asm-v850/semaphore.h	2007-02-26 15:53:11.000000000 -0800
@@ -7,6 +7,7 @@
 #include <linux/rwsem.h>
 
 #include <asm/atomic.h>
+#include <asm-generic/semaphore.h>
 
 struct semaphore {
 	atomic_t count;
Index: linux.hg/include/asm-x86_64/semaphore.h
===================================================================
--- linux.hg.orig/include/asm-x86_64/semaphore.h	2007-02-26 15:51:26.000000000 -0800
+++ linux.hg/include/asm-x86_64/semaphore.h	2007-02-26 15:53:11.000000000 -0800
@@ -39,6 +39,7 @@
 #include <asm/system.h>
 #include <asm/atomic.h>
 #include <asm/rwlock.h>
+#include <asm-generic/semaphore.h>
 #include <linux/wait.h>
 #include <linux/rwsem.h>
 #include <linux/stringify.h>
Index: linux.hg/include/asm-xtensa/semaphore.h
===================================================================
--- linux.hg.orig/include/asm-xtensa/semaphore.h	2007-02-26 15:51:26.000000000 -0800
+++ linux.hg/include/asm-xtensa/semaphore.h	2007-02-26 15:53:11.000000000 -0800
@@ -13,6 +13,7 @@
 
 #include <asm/atomic.h>
 #include <asm/system.h>
+#include <asm-generic/semaphore.h>
 #include <linux/wait.h>
 #include <linux/rwsem.h>
 

--

Inaky
