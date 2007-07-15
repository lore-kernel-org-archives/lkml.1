Return-Path: <linux-kernel-owner+w=401wt.eu-S1762710AbXGOXme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762710AbXGOXme (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 19:42:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755973AbXGOXm1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 19:42:27 -0400
Received: from tomts10.bellnexxia.net ([209.226.175.54]:64774 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755637AbXGOXm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 19:42:26 -0400
Date: Sun, 15 Jul 2007 19:42:25 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: hch@infradead.org
Subject: [PATCH] Immediate Values - PowerPC Optimization - kerneldoc for implementation
Message-ID: <20070715234225.GJ22428@Krystal>
References: <20070714012439.285079881@polymtl.ca> <20070714012624.842959793@polymtl.ca> <20070715013852.GH23209@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070715013852.GH23209@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 19:41:53 up 8 days, 13:47,  3 users,  load average: 0.23, 0.60, 0.51
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Immediate Values - PowerPC Optimization - kerneldoc for implementation

Add kerneldoc to Immediate Values (PowerPC Optimization) API.
It applies after
"Immediate Values - PowerPC Optimization - kerneldoc"

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: hch@infradead.org
---
 arch/powerpc/kernel/immediate.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

Index: linux-2.6-lttng/arch/powerpc/kernel/immediate.c
===================================================================
--- linux-2.6-lttng.orig/arch/powerpc/kernel/immediate.c	2007-07-15 19:10:32.000000000 -0400
+++ linux-2.6-lttng/arch/powerpc/kernel/immediate.c	2007-07-15 19:11:50.000000000 -0400
@@ -13,8 +13,11 @@
 
 #define LI_OPCODE_LEN	2
 
-/*
- * The immediate value are aligned.
+/**
+ * arch_immediate_update - update one immediate value
+ * @immediate: pointer of type const struct __immediate to update
+ *
+ * Update one immediate value. Must be called with immediate_mutex held.
  */
 int arch_immediate_update(const struct __immediate *immediate)
 {
@@ -68,8 +71,11 @@ int arch_immediate_update(const struct _
 	return 0;
 }
 
-/*
- * Very early initialization of the in-core immediate values.
+/**
+ * arch_immediate_update_early - update one immediate value at boot time
+ * @immediate: pointer of type const struct __immediate to update
+ *
+ * Update one immediate value at boot time.
  * We can use flush_icache_range, since the cpu identification has been done in
  * the early_init stage.
  */
@@ -95,4 +101,3 @@ void __init arch_immediate_update_early(
 	flush_icache_range((unsigned long)immediate->immediate,
 				immediate->size);
 }
-
-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
