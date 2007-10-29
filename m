Return-Path: <linux-kernel-owner+w=401wt.eu-S1758797AbXJ2Ocl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758797AbXJ2Ocl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 10:32:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758366AbXJ2Oa6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 10:30:58 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:39950 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758166AbXJ2OaJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 10:30:09 -0400
Message-Id: <20071029142941.415411230@polymtl.ca>
References: <20071029142646.699058449@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Mon, 29 Oct 2007 10:26:54 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [patch 08/10] Move blktrace Kconfig entry to instrumentation menu
Content-Disposition: inline; filename=move-blktrace-to-instrumentation-menu.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Mon, 29 Oct 2007 14:29:41 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This block layer isntrumentation should appear in the instrumentation menu, not
in the block layer menu.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Jens Axboe <jens.axboe@oracle.com>
---
 block/Kconfig           |   13 -------------
 instrumentation/Kconfig |   13 +++++++++++++
 2 files changed, 13 insertions(+), 13 deletions(-)

Index: linux-2.6-lttng.stable/block/Kconfig
===================================================================
--- linux-2.6-lttng.stable.orig/block/Kconfig	2007-10-29 09:12:10.000000000 -0400
+++ linux-2.6-lttng.stable/block/Kconfig	2007-10-29 09:12:29.000000000 -0400
@@ -27,19 +27,6 @@ config LBD
 	  your machine, or if you want to have a raid or loopback device
 	  bigger than 2TB.  Otherwise say N.
 
-config BLK_DEV_IO_TRACE
-	bool "Support for tracing block io actions"
-	depends on SYSFS
-	select RELAY
-	select DEBUG_FS
-	help
-	  Say Y here, if you want to be able to trace the block layer actions
-	  on a given queue. Tracing allows you to see any traffic happening
-	  on a block device queue. For more information (and the user space
-	  support tools needed), fetch the blktrace app from:
-
-	  git://brick.kernel.dk/data/git/blktrace.git
-
 config LSF
 	bool "Support for Large Single Files"
 	depends on !64BIT
Index: linux-2.6-lttng.stable/instrumentation/Kconfig
===================================================================
--- linux-2.6-lttng.stable.orig/instrumentation/Kconfig	2007-10-29 09:13:07.000000000 -0400
+++ linux-2.6-lttng.stable/instrumentation/Kconfig	2007-10-29 09:13:14.000000000 -0400
@@ -46,4 +46,17 @@ config MARKERS
 	  Place an empty function call at each marker site. Can be
 	  dynamically changed for a probe function.
 
+config BLK_DEV_IO_TRACE
+	bool "Support for tracing block io actions"
+	depends on SYSFS
+	select RELAY
+	select DEBUG_FS
+	help
+	  Say Y here, if you want to be able to trace the block layer actions
+	  on a given queue. Tracing allows you to see any traffic happening
+	  on a block device queue. For more information (and the user space
+	  support tools needed), fetch the blktrace app from:
+
+	  git://brick.kernel.dk/data/git/blktrace.git
+
 endif # INSTRUMENTATION

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
