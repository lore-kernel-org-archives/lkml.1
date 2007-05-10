Return-Path: <linux-kernel-owner+w=401wt.eu-S1757392AbXEJCJy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757392AbXEJCJy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 22:09:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754745AbXEJCJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 22:09:43 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:57173 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754072AbXEJCJm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 22:09:42 -0400
Message-Id: <20070510020916.836290342@polymtl.ca>
References: <20070510015555.973107048@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 09 May 2007 21:56:01 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, hch@infradead.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch 06/10] Linux Kernel Markers - Non optimized architectures
Content-Disposition: inline; filename=linux-kernel-markers-non-optimized-architectures.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Thu, 10 May 2007 02:09:17 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch also includes marker code for non optimized architectures.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-alpha/marker.h     |   13 +++++++++++++
 include/asm-arm/marker.h       |   13 +++++++++++++
 include/asm-arm26/marker.h     |   13 +++++++++++++
 include/asm-cris/marker.h      |   13 +++++++++++++
 include/asm-frv/marker.h       |   13 +++++++++++++
 include/asm-generic/marker.h   |   37 +++++++++++++++++++++++++++++++++++++
 include/asm-h8300/marker.h     |   13 +++++++++++++
 include/asm-ia64/marker.h      |   13 +++++++++++++
 include/asm-m32r/marker.h      |   13 +++++++++++++
 include/asm-m68k/marker.h      |   13 +++++++++++++
 include/asm-m68knommu/marker.h |   13 +++++++++++++
 include/asm-mips/marker.h      |   13 +++++++++++++
 include/asm-parisc/marker.h    |   13 +++++++++++++
 include/asm-ppc/marker.h       |   13 +++++++++++++
 include/asm-s390/marker.h      |   13 +++++++++++++
 include/asm-sh/marker.h        |   13 +++++++++++++
 include/asm-sh64/marker.h      |   13 +++++++++++++
 include/asm-sparc/marker.h     |   13 +++++++++++++
 include/asm-sparc64/marker.h   |   13 +++++++++++++
 include/asm-um/marker.h        |   13 +++++++++++++
 include/asm-v850/marker.h      |   13 +++++++++++++
 include/asm-x86_64/marker.h    |   13 +++++++++++++
 include/asm-xtensa/marker.h    |   13 +++++++++++++
 23 files changed, 323 insertions(+)

Index: linux-2.6-lttng/include/asm-arm/marker.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-arm/marker.h	2007-05-09 18:16:05.000000000 -0400
@@ -0,0 +1,13 @@
+/*
+ * marker.h
+ *
+ * Code markup for dynamic and static tracing. Architecture specific
+ * optimisations.
+ *
+ * No optimisation implemented.
+ *
+ * This file is released under the GPLv2.
+ * See the file COPYING for more details.
+ */
+
+#include <asm-generic/marker.h>
Index: linux-2.6-lttng/include/asm-cris/marker.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-cris/marker.h	2007-05-09 18:16:05.000000000 -0400
@@ -0,0 +1,13 @@
+/*
+ * marker.h
+ *
+ * Code markup for dynamic and static tracing. Architecture specific
+ * optimisations.
+ *
+ * No optimisation implemented.
+ *
+ * This file is released under the GPLv2.
+ * See the file COPYING for more details.
+ */
+
+#include <asm-generic/marker.h>
Index: linux-2.6-lttng/include/asm-frv/marker.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-frv/marker.h	2007-05-09 18:16:05.000000000 -0400
@@ -0,0 +1,13 @@
+/*
+ * marker.h
+ *
+ * Code markup for dynamic and static tracing. Architecture specific
+ * optimisations.
+ *
+ * No optimisation implemented.
+ *
+ * This file is released under the GPLv2.
+ * See the file COPYING for more details.
+ */
+
+#include <asm-generic/marker.h>
Index: linux-2.6-lttng/include/asm-generic/marker.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-generic/marker.h	2007-05-09 18:16:05.000000000 -0400
@@ -0,0 +1,37 @@
+#ifndef _ASM_GENERIC_MARKER_H
+#define _ASM_GENERIC_MARKER_H
+
+/*
+ * marker.h
+ *
+ * Code markup for dynamic and static tracing. Generic header.
+ *
+ * This file is released under the GPLv2.
+ * See the file COPYING for more details.
+ *
+ * Note : the empty asm volatile with read constraint is used here instead of a
+ * "used" attribute to fix a gcc 4.1.x bug.
+ */
+
+/* Default flags, used by MARK() */
+#define MF_DEFAULT			(MF_LOCKDEP | MF_PRINTK)
+
+/* Fallback on the generic markers, since no optimized version is available */
+#define trace_mark_optimized		trace_mark_generic
+#define _trace_mark			trace_mark_generic
+
+/* Marker with default behavior */
+#define trace_mark(format, args...)	_trace_mark(MF_DEFAULT, format, ## args)
+
+/* Architecture dependant marker information, used internally for marker
+ * activation. */
+
+#define MARK_OPTIMIZED_ENABLE_IMMEDIATE_OFFSET \
+		MARK_GENERIC_ENABLE_IMMEDIATE_OFFSET
+#define MARK_OPTIMIZED_ENABLE_TYPE	MARK_GENERIC_ENABLE_TYPE
+/* Dereference enable as lvalue from a pointer to its instruction */
+#define MARK_OPTIMIZED_ENABLE		MARK_GENERIC_ENABLE
+
+#define marker_optimized_set_enable marker_generic_set_enable
+
+#endif /* _ASM_GENERIC_MARKER_H */
Index: linux-2.6-lttng/include/asm-h8300/marker.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-h8300/marker.h	2007-05-09 18:16:05.000000000 -0400
@@ -0,0 +1,13 @@
+/*
+ * marker.h
+ *
+ * Code markup for dynamic and static tracing. Architecture specific
+ * optimisations.
+ *
+ * No optimisation implemented.
+ *
+ * This file is released under the GPLv2.
+ * See the file COPYING for more details.
+ */
+
+#include <asm-generic/marker.h>
Index: linux-2.6-lttng/include/asm-ia64/marker.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-ia64/marker.h	2007-05-09 18:16:05.000000000 -0400
@@ -0,0 +1,13 @@
+/*
+ * marker.h
+ *
+ * Code markup for dynamic and static tracing. Architecture specific
+ * optimisations.
+ *
+ * No optimisation implemented.
+ *
+ * This file is released under the GPLv2.
+ * See the file COPYING for more details.
+ */
+
+#include <asm-generic/marker.h>
Index: linux-2.6-lttng/include/asm-m32r/marker.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-m32r/marker.h	2007-05-09 18:16:05.000000000 -0400
@@ -0,0 +1,13 @@
+/*
+ * marker.h
+ *
+ * Code markup for dynamic and static tracing. Architecture specific
+ * optimisations.
+ *
+ * No optimisation implemented.
+ *
+ * This file is released under the GPLv2.
+ * See the file COPYING for more details.
+ */
+
+#include <asm-generic/marker.h>
Index: linux-2.6-lttng/include/asm-m68k/marker.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-m68k/marker.h	2007-05-09 18:16:05.000000000 -0400
@@ -0,0 +1,13 @@
+/*
+ * marker.h
+ *
+ * Code markup for dynamic and static tracing. Architecture specific
+ * optimisations.
+ *
+ * No optimisation implemented.
+ *
+ * This file is released under the GPLv2.
+ * See the file COPYING for more details.
+ */
+
+#include <asm-generic/marker.h>
Index: linux-2.6-lttng/include/asm-m68knommu/marker.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-m68knommu/marker.h	2007-05-09 18:16:05.000000000 -0400
@@ -0,0 +1,13 @@
+/*
+ * marker.h
+ *
+ * Code markup for dynamic and static tracing. Architecture specific
+ * optimisations.
+ *
+ * No optimisation implemented.
+ *
+ * This file is released under the GPLv2.
+ * See the file COPYING for more details.
+ */
+
+#include <asm-generic/marker.h>
Index: linux-2.6-lttng/include/asm-mips/marker.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-mips/marker.h	2007-05-09 18:16:05.000000000 -0400
@@ -0,0 +1,13 @@
+/*
+ * marker.h
+ *
+ * Code markup for dynamic and static tracing. Architecture specific
+ * optimisations.
+ *
+ * No optimisation implemented.
+ *
+ * This file is released under the GPLv2.
+ * See the file COPYING for more details.
+ */
+
+#include <asm-generic/marker.h>
Index: linux-2.6-lttng/include/asm-parisc/marker.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-parisc/marker.h	2007-05-09 18:16:05.000000000 -0400
@@ -0,0 +1,13 @@
+/*
+ * marker.h
+ *
+ * Code markup for dynamic and static tracing. Architecture specific
+ * optimisations.
+ *
+ * No optimisation implemented.
+ *
+ * This file is released under the GPLv2.
+ * See the file COPYING for more details.
+ */
+
+#include <asm-generic/marker.h>
Index: linux-2.6-lttng/include/asm-ppc/marker.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-ppc/marker.h	2007-05-09 18:16:05.000000000 -0400
@@ -0,0 +1,13 @@
+/*
+ * marker.h
+ *
+ * Code markup for dynamic and static tracing. Architecture specific
+ * optimisations.
+ *
+ * No optimisation implemented.
+ *
+ * This file is released under the GPLv2.
+ * See the file COPYING for more details.
+ */
+
+#include <asm-generic/marker.h>
Index: linux-2.6-lttng/include/asm-s390/marker.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-s390/marker.h	2007-05-09 18:16:05.000000000 -0400
@@ -0,0 +1,13 @@
+/*
+ * marker.h
+ *
+ * Code markup for dynamic and static tracing. Architecture specific
+ * optimisations.
+ *
+ * No optimisation implemented.
+ *
+ * This file is released under the GPLv2.
+ * See the file COPYING for more details.
+ */
+
+#include <asm-generic/marker.h>
Index: linux-2.6-lttng/include/asm-sh/marker.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-sh/marker.h	2007-05-09 18:16:05.000000000 -0400
@@ -0,0 +1,13 @@
+/*
+ * marker.h
+ *
+ * Code markup for dynamic and static tracing. Architecture specific
+ * optimisations.
+ *
+ * No optimisation implemented.
+ *
+ * This file is released under the GPLv2.
+ * See the file COPYING for more details.
+ */
+
+#include <asm-generic/marker.h>
Index: linux-2.6-lttng/include/asm-sh64/marker.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-sh64/marker.h	2007-05-09 18:16:05.000000000 -0400
@@ -0,0 +1,13 @@
+/*
+ * marker.h
+ *
+ * Code markup for dynamic and static tracing. Architecture specific
+ * optimisations.
+ *
+ * No optimisation implemented.
+ *
+ * This file is released under the GPLv2.
+ * See the file COPYING for more details.
+ */
+
+#include <asm-generic/marker.h>
Index: linux-2.6-lttng/include/asm-sparc/marker.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-sparc/marker.h	2007-05-09 18:16:05.000000000 -0400
@@ -0,0 +1,13 @@
+/*
+ * marker.h
+ *
+ * Code markup for dynamic and static tracing. Architecture specific
+ * optimisations.
+ *
+ * No optimisation implemented.
+ *
+ * This file is released under the GPLv2.
+ * See the file COPYING for more details.
+ */
+
+#include <asm-generic/marker.h>
Index: linux-2.6-lttng/include/asm-sparc64/marker.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-sparc64/marker.h	2007-05-09 18:16:05.000000000 -0400
@@ -0,0 +1,13 @@
+/*
+ * marker.h
+ *
+ * Code markup for dynamic and static tracing. Architecture specific
+ * optimisations.
+ *
+ * No optimisation implemented.
+ *
+ * This file is released under the GPLv2.
+ * See the file COPYING for more details.
+ */
+
+#include <asm-generic/marker.h>
Index: linux-2.6-lttng/include/asm-um/marker.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-um/marker.h	2007-05-09 18:16:05.000000000 -0400
@@ -0,0 +1,13 @@
+/*
+ * marker.h
+ *
+ * Code markup for dynamic and static tracing. Architecture specific
+ * optimisations.
+ *
+ * No optimisation implemented.
+ *
+ * This file is released under the GPLv2.
+ * See the file COPYING for more details.
+ */
+
+#include <asm-generic/marker.h>
Index: linux-2.6-lttng/include/asm-v850/marker.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-v850/marker.h	2007-05-09 18:16:05.000000000 -0400
@@ -0,0 +1,13 @@
+/*
+ * marker.h
+ *
+ * Code markup for dynamic and static tracing. Architecture specific
+ * optimisations.
+ *
+ * No optimisation implemented.
+ *
+ * This file is released under the GPLv2.
+ * See the file COPYING for more details.
+ */
+
+#include <asm-generic/marker.h>
Index: linux-2.6-lttng/include/asm-x86_64/marker.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-x86_64/marker.h	2007-05-09 18:16:05.000000000 -0400
@@ -0,0 +1,13 @@
+/*
+ * marker.h
+ *
+ * Code markup for dynamic and static tracing. Architecture specific
+ * optimisations.
+ *
+ * No optimisation implemented.
+ *
+ * This file is released under the GPLv2.
+ * See the file COPYING for more details.
+ */
+
+#include <asm-generic/marker.h>
Index: linux-2.6-lttng/include/asm-xtensa/marker.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-xtensa/marker.h	2007-05-09 18:16:05.000000000 -0400
@@ -0,0 +1,13 @@
+/*
+ * marker.h
+ *
+ * Code markup for dynamic and static tracing. Architecture specific
+ * optimisations.
+ *
+ * No optimisation implemented.
+ *
+ * This file is released under the GPLv2.
+ * See the file COPYING for more details.
+ */
+
+#include <asm-generic/marker.h>
Index: linux-2.6-lttng/include/asm-alpha/marker.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-alpha/marker.h	2007-05-09 18:16:05.000000000 -0400
@@ -0,0 +1,13 @@
+/*
+ * marker.h
+ *
+ * Code markup for dynamic and static tracing. Architecture specific
+ * optimisations.
+ *
+ * No optimisation implemented.
+ *
+ * This file is released under the GPLv2.
+ * See the file COPYING for more details.
+ */
+
+#include <asm-generic/marker.h>
Index: linux-2.6-lttng/include/asm-arm26/marker.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-arm26/marker.h	2007-05-09 18:16:05.000000000 -0400
@@ -0,0 +1,13 @@
+/*
+ * marker.h
+ *
+ * Code markup for dynamic and static tracing. Architecture specific
+ * optimisations.
+ *
+ * No optimisation implemented.
+ *
+ * This file is released under the GPLv2.
+ * See the file COPYING for more details.
+ */
+
+#include <asm-generic/marker.h>

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
