Return-Path: <linux-kernel-owner+w=401wt.eu-S1761159AbXEJNLp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761159AbXEJNLp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 09:11:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755981AbXEJNLj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 09:11:39 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:45666 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757282AbXEJNLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 09:11:38 -0400
Date: Thu, 10 May 2007 09:11:37 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Christoph Hellwig <hch@infradead.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 06/10] Linux Kernel Markers - Non optimized architectures
Message-ID: <20070510131137.GC22424@Krystal>
References: <20070510015555.973107048@polymtl.ca> <20070510020916.836290342@polymtl.ca> <20070510065636.GB8019@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070510065636.GB8019@infradead.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.34-grsec (i686)
X-Uptime: 09:08:49 up 97 days,  3:15,  5 users,  load average: 2.30, 2.75, 2.67
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linux Kernel Markers - Non Optimized Architectures fix 2

Fix comments in headers
- Remove Copyright notice in one-liner header
- Transfer generic header note "using asm to fix a gcc bug" to where it belongs
  now : in linux/marker.h.
- Fix optimisation -> optimization typo in powerpc and i386 headers.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 include/asm-arm/marker.h       |   12 ------------
 include/asm-cris/marker.h      |   12 ------------
 include/asm-frv/marker.h       |   12 ------------
 include/asm-generic/marker.h   |   12 ------------
 include/asm-h8300/marker.h     |   12 ------------
 include/asm-i386/marker.h      |    2 +-
 include/asm-ia64/marker.h      |   12 ------------
 include/asm-m32r/marker.h      |   12 ------------
 include/asm-m68k/marker.h      |   12 ------------
 include/asm-m68knommu/marker.h |   12 ------------
 include/asm-mips/marker.h      |   12 ------------
 include/asm-parisc/marker.h    |   12 ------------
 include/asm-powerpc/marker.h   |    2 +-
 include/asm-ppc/marker.h       |   12 ------------
 include/asm-s390/marker.h      |   12 ------------
 include/asm-sh/marker.h        |   12 ------------
 include/asm-sh64/marker.h      |   12 ------------
 include/asm-sparc/marker.h     |   12 ------------
 include/asm-sparc64/marker.h   |   12 ------------
 include/asm-um/marker.h        |   12 ------------
 include/asm-v850/marker.h      |   12 ------------
 include/asm-x86_64/marker.h    |   12 ------------
 include/asm-xtensa/marker.h    |   12 ------------
 include/linux/marker.h         |    4 +++-
 24 files changed, 5 insertions(+), 255 deletions(-)

Index: linux-2.6-lttng/include/asm-arm/marker.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-arm/marker.h	2007-05-10 09:02:16.000000000 -0400
+++ linux-2.6-lttng/include/asm-arm/marker.h	2007-05-10 09:02:31.000000000 -0400
@@ -1,13 +1 @@
-/*
- * marker.h
- *
- * Code markup for dynamic and static tracing. Architecture specific
- * optimisations.
- *
- * No optimisation implemented.
- *
- * This file is released under the GPLv2.
- * See the file COPYING for more details.
- */
-
 #include <asm-generic/marker.h>
Index: linux-2.6-lttng/include/asm-cris/marker.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-cris/marker.h	2007-05-10 09:02:16.000000000 -0400
+++ linux-2.6-lttng/include/asm-cris/marker.h	2007-05-10 09:02:35.000000000 -0400
@@ -1,13 +1 @@
-/*
- * marker.h
- *
- * Code markup for dynamic and static tracing. Architecture specific
- * optimisations.
- *
- * No optimisation implemented.
- *
- * This file is released under the GPLv2.
- * See the file COPYING for more details.
- */
-
 #include <asm-generic/marker.h>
Index: linux-2.6-lttng/include/asm-frv/marker.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-frv/marker.h	2007-05-10 09:02:16.000000000 -0400
+++ linux-2.6-lttng/include/asm-frv/marker.h	2007-05-10 09:02:38.000000000 -0400
@@ -1,13 +1 @@
-/*
- * marker.h
- *
- * Code markup for dynamic and static tracing. Architecture specific
- * optimisations.
- *
- * No optimisation implemented.
- *
- * This file is released under the GPLv2.
- * See the file COPYING for more details.
- */
-
 #include <asm-generic/marker.h>
Index: linux-2.6-lttng/include/asm-generic/marker.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-generic/marker.h	2007-05-10 09:02:17.000000000 -0400
+++ linux-2.6-lttng/include/asm-generic/marker.h	2007-05-10 09:04:14.000000000 -0400
@@ -1,18 +1,6 @@
 #ifndef _ASM_GENERIC_MARKER_H
 #define _ASM_GENERIC_MARKER_H
 
-/*
- * marker.h
- *
- * Code markup for dynamic and static tracing. Generic header.
- *
- * This file is released under the GPLv2.
- * See the file COPYING for more details.
- *
- * Note : the empty asm volatile with read constraint is used here instead of a
- * "used" attribute to fix a gcc 4.1.x bug.
- */
-
 #define _MF_DEFAULT			(_MF_LOCKDEP | _MF_PRINTK)
 
 #define MARK_OPTIMIZED			MARK_GENERIC
Index: linux-2.6-lttng/include/asm-h8300/marker.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-h8300/marker.h	2007-05-10 09:02:17.000000000 -0400
+++ linux-2.6-lttng/include/asm-h8300/marker.h	2007-05-10 09:04:23.000000000 -0400
@@ -1,13 +1 @@
-/*
- * marker.h
- *
- * Code markup for dynamic and static tracing. Architecture specific
- * optimisations.
- *
- * No optimisation implemented.
- *
- * This file is released under the GPLv2.
- * See the file COPYING for more details.
- */
-
 #include <asm-generic/marker.h>
Index: linux-2.6-lttng/include/asm-i386/marker.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-i386/marker.h	2007-05-10 09:02:17.000000000 -0400
+++ linux-2.6-lttng/include/asm-i386/marker.h	2007-05-10 09:05:06.000000000 -0400
@@ -4,7 +4,7 @@
 /*
  * marker.h
  *
- * Code markup for dynamic and static tracing. i386 architecture optimisations.
+ * Code markup for dynamic and static tracing. i386 architecture optimizations.
  *
  * (C) Copyright 2006 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
  *
Index: linux-2.6-lttng/include/asm-ia64/marker.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-ia64/marker.h	2007-05-10 09:02:17.000000000 -0400
+++ linux-2.6-lttng/include/asm-ia64/marker.h	2007-05-10 09:05:09.000000000 -0400
@@ -1,13 +1 @@
-/*
- * marker.h
- *
- * Code markup for dynamic and static tracing. Architecture specific
- * optimisations.
- *
- * No optimisation implemented.
- *
- * This file is released under the GPLv2.
- * See the file COPYING for more details.
- */
-
 #include <asm-generic/marker.h>
Index: linux-2.6-lttng/include/asm-m32r/marker.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-m32r/marker.h	2007-05-10 09:02:17.000000000 -0400
+++ linux-2.6-lttng/include/asm-m32r/marker.h	2007-05-10 09:05:12.000000000 -0400
@@ -1,13 +1 @@
-/*
- * marker.h
- *
- * Code markup for dynamic and static tracing. Architecture specific
- * optimisations.
- *
- * No optimisation implemented.
- *
- * This file is released under the GPLv2.
- * See the file COPYING for more details.
- */
-
 #include <asm-generic/marker.h>
Index: linux-2.6-lttng/include/asm-m68k/marker.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-m68k/marker.h	2007-05-10 09:02:17.000000000 -0400
+++ linux-2.6-lttng/include/asm-m68k/marker.h	2007-05-10 09:05:15.000000000 -0400
@@ -1,13 +1 @@
-/*
- * marker.h
- *
- * Code markup for dynamic and static tracing. Architecture specific
- * optimisations.
- *
- * No optimisation implemented.
- *
- * This file is released under the GPLv2.
- * See the file COPYING for more details.
- */
-
 #include <asm-generic/marker.h>
Index: linux-2.6-lttng/include/asm-m68knommu/marker.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-m68knommu/marker.h	2007-05-10 09:02:17.000000000 -0400
+++ linux-2.6-lttng/include/asm-m68knommu/marker.h	2007-05-10 09:05:19.000000000 -0400
@@ -1,13 +1 @@
-/*
- * marker.h
- *
- * Code markup for dynamic and static tracing. Architecture specific
- * optimisations.
- *
- * No optimisation implemented.
- *
- * This file is released under the GPLv2.
- * See the file COPYING for more details.
- */
-
 #include <asm-generic/marker.h>
Index: linux-2.6-lttng/include/asm-mips/marker.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-mips/marker.h	2007-05-10 09:02:17.000000000 -0400
+++ linux-2.6-lttng/include/asm-mips/marker.h	2007-05-10 09:05:21.000000000 -0400
@@ -1,13 +1 @@
-/*
- * marker.h
- *
- * Code markup for dynamic and static tracing. Architecture specific
- * optimisations.
- *
- * No optimisation implemented.
- *
- * This file is released under the GPLv2.
- * See the file COPYING for more details.
- */
-
 #include <asm-generic/marker.h>
Index: linux-2.6-lttng/include/asm-parisc/marker.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-parisc/marker.h	2007-05-10 09:02:17.000000000 -0400
+++ linux-2.6-lttng/include/asm-parisc/marker.h	2007-05-10 09:05:24.000000000 -0400
@@ -1,13 +1 @@
-/*
- * marker.h
- *
- * Code markup for dynamic and static tracing. Architecture specific
- * optimisations.
- *
- * No optimisation implemented.
- *
- * This file is released under the GPLv2.
- * See the file COPYING for more details.
- */
-
 #include <asm-generic/marker.h>
Index: linux-2.6-lttng/include/asm-powerpc/marker.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-powerpc/marker.h	2007-05-10 09:02:17.000000000 -0400
+++ linux-2.6-lttng/include/asm-powerpc/marker.h	2007-05-10 09:05:34.000000000 -0400
@@ -5,7 +5,7 @@
  * marker.h
  *
  * Code markup for dynamic and static tracing. PowerPC architecture
- * optimisations.
+ * optimizations.
  *
  * (C) Copyright 2006 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
  *
Index: linux-2.6-lttng/include/asm-ppc/marker.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-ppc/marker.h	2007-05-10 09:02:17.000000000 -0400
+++ linux-2.6-lttng/include/asm-ppc/marker.h	2007-05-10 09:05:38.000000000 -0400
@@ -1,13 +1 @@
-/*
- * marker.h
- *
- * Code markup for dynamic and static tracing. Architecture specific
- * optimisations.
- *
- * No optimisation implemented.
- *
- * This file is released under the GPLv2.
- * See the file COPYING for more details.
- */
-
 #include <asm-generic/marker.h>
Index: linux-2.6-lttng/include/asm-s390/marker.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-s390/marker.h	2007-05-10 09:02:17.000000000 -0400
+++ linux-2.6-lttng/include/asm-s390/marker.h	2007-05-10 09:05:40.000000000 -0400
@@ -1,13 +1 @@
-/*
- * marker.h
- *
- * Code markup for dynamic and static tracing. Architecture specific
- * optimisations.
- *
- * No optimisation implemented.
- *
- * This file is released under the GPLv2.
- * See the file COPYING for more details.
- */
-
 #include <asm-generic/marker.h>
Index: linux-2.6-lttng/include/asm-sh/marker.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-sh/marker.h	2007-05-10 09:02:17.000000000 -0400
+++ linux-2.6-lttng/include/asm-sh/marker.h	2007-05-10 09:05:47.000000000 -0400
@@ -1,13 +1 @@
-/*
- * marker.h
- *
- * Code markup for dynamic and static tracing. Architecture specific
- * optimisations.
- *
- * No optimisation implemented.
- *
- * This file is released under the GPLv2.
- * See the file COPYING for more details.
- */
-
 #include <asm-generic/marker.h>
Index: linux-2.6-lttng/include/asm-sh64/marker.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-sh64/marker.h	2007-05-10 09:02:17.000000000 -0400
+++ linux-2.6-lttng/include/asm-sh64/marker.h	2007-05-10 09:05:43.000000000 -0400
@@ -1,13 +1 @@
-/*
- * marker.h
- *
- * Code markup for dynamic and static tracing. Architecture specific
- * optimisations.
- *
- * No optimisation implemented.
- *
- * This file is released under the GPLv2.
- * See the file COPYING for more details.
- */
-
 #include <asm-generic/marker.h>
Index: linux-2.6-lttng/include/asm-sparc/marker.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-sparc/marker.h	2007-05-10 09:02:17.000000000 -0400
+++ linux-2.6-lttng/include/asm-sparc/marker.h	2007-05-10 09:05:52.000000000 -0400
@@ -1,13 +1 @@
-/*
- * marker.h
- *
- * Code markup for dynamic and static tracing. Architecture specific
- * optimisations.
- *
- * No optimisation implemented.
- *
- * This file is released under the GPLv2.
- * See the file COPYING for more details.
- */
-
 #include <asm-generic/marker.h>
Index: linux-2.6-lttng/include/asm-sparc64/marker.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-sparc64/marker.h	2007-05-10 09:02:17.000000000 -0400
+++ linux-2.6-lttng/include/asm-sparc64/marker.h	2007-05-10 09:05:50.000000000 -0400
@@ -1,13 +1 @@
-/*
- * marker.h
- *
- * Code markup for dynamic and static tracing. Architecture specific
- * optimisations.
- *
- * No optimisation implemented.
- *
- * This file is released under the GPLv2.
- * See the file COPYING for more details.
- */
-
 #include <asm-generic/marker.h>
Index: linux-2.6-lttng/include/asm-um/marker.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-um/marker.h	2007-05-10 09:02:17.000000000 -0400
+++ linux-2.6-lttng/include/asm-um/marker.h	2007-05-10 09:05:56.000000000 -0400
@@ -1,13 +1 @@
-/*
- * marker.h
- *
- * Code markup for dynamic and static tracing. Architecture specific
- * optimisations.
- *
- * No optimisation implemented.
- *
- * This file is released under the GPLv2.
- * See the file COPYING for more details.
- */
-
 #include <asm-generic/marker.h>
Index: linux-2.6-lttng/include/asm-v850/marker.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-v850/marker.h	2007-05-10 09:02:17.000000000 -0400
+++ linux-2.6-lttng/include/asm-v850/marker.h	2007-05-10 09:05:59.000000000 -0400
@@ -1,13 +1 @@
-/*
- * marker.h
- *
- * Code markup for dynamic and static tracing. Architecture specific
- * optimisations.
- *
- * No optimisation implemented.
- *
- * This file is released under the GPLv2.
- * See the file COPYING for more details.
- */
-
 #include <asm-generic/marker.h>
Index: linux-2.6-lttng/include/asm-x86_64/marker.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-x86_64/marker.h	2007-05-10 09:02:17.000000000 -0400
+++ linux-2.6-lttng/include/asm-x86_64/marker.h	2007-05-10 09:06:02.000000000 -0400
@@ -1,13 +1 @@
-/*
- * marker.h
- *
- * Code markup for dynamic and static tracing. Architecture specific
- * optimisations.
- *
- * No optimisation implemented.
- *
- * This file is released under the GPLv2.
- * See the file COPYING for more details.
- */
-
 #include <asm-generic/marker.h>
Index: linux-2.6-lttng/include/asm-xtensa/marker.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-xtensa/marker.h	2007-05-10 09:02:17.000000000 -0400
+++ linux-2.6-lttng/include/asm-xtensa/marker.h	2007-05-10 09:06:07.000000000 -0400
@@ -1,13 +1 @@
-/*
- * marker.h
- *
- * Code markup for dynamic and static tracing. Architecture specific
- * optimisations.
- *
- * No optimisation implemented.
- *
- * This file is released under the GPLv2.
- * See the file COPYING for more details.
- */
-
 #include <asm-generic/marker.h>
Index: linux-2.6-lttng/include/linux/marker.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/marker.h	2007-05-10 09:03:25.000000000 -0400
+++ linux-2.6-lttng/include/linux/marker.h	2007-05-10 09:03:51.000000000 -0400
@@ -45,7 +45,9 @@
 #define MF_PRINTK	(1 << 2)	/* vprintk can be called in the probe */
 #define _MF_NR		3		/* Number of marker flags */
 
-/* Generic marker flavor always available */
+/* Generic marker flavor always available.
+ * Note : the empty asm volatile with read constraint is used here instead of a
+ * "used" attribute to fix a gcc 4.1.x bug. */
 #define trace_mark_generic(flags, name, format, args...) \
 	do { \
 		static const char __mstrtab_name_##name[] \
-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
