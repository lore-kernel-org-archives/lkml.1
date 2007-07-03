Return-Path: <linux-kernel-owner+w=401wt.eu-S1761686AbXGCQt6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761686AbXGCQt6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 12:49:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755411AbXGCQr2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 12:47:28 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:46309 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760154AbXGCQr1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 12:47:27 -0400
Message-Id: <20070703164629.652643243@polymtl.ca>
References: <20070703164534.492133618@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Tue, 03 Jul 2007 12:45:37 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, chris@zankel.net
Subject: [patch 3/3] Use DATA_DATA in xtensa
Content-Disposition: inline; filename=use-data-data-in-xtensa.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Tue,  3 Jul 2007 16:46:29 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: chris@zankel.net
---
 arch/xtensa/kernel/vmlinux.lds.S |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6-lttng/arch/xtensa/kernel/vmlinux.lds.S
===================================================================
--- linux-2.6-lttng.orig/arch/xtensa/kernel/vmlinux.lds.S	2007-06-16 22:20:09.000000000 -0400
+++ linux-2.6-lttng/arch/xtensa/kernel/vmlinux.lds.S	2007-06-16 22:20:41.000000000 -0400
@@ -118,7 +118,8 @@
   _fdata = .;
   .data :
   {
-    *(.data) CONSTRUCTORS
+    DATA_DATA
+    CONSTRUCTORS
     . = ALIGN(XCHAL_ICACHE_LINESIZE);
     *(.data.cacheline_aligned)
   }

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
