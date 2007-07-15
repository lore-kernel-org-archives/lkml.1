Return-Path: <linux-kernel-owner+w=401wt.eu-S1762568AbXGOXlf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762568AbXGOXlf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 19:41:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755637AbXGOXl2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 19:41:28 -0400
Received: from tomts10-srv.bellnexxia.net ([209.226.175.54]:64681 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755103AbXGOXl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 19:41:27 -0400
Date: Sun, 15 Jul 2007 19:41:25 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: hch@infradead.org
Subject: [PATCH] Immediate Values - i386 Optimization - kerneldoc for implementation
Message-ID: <20070715234125.GI22428@Krystal>
References: <20070714012439.285079881@polymtl.ca> <20070714012624.507095382@polymtl.ca> <20070715013756.GG23209@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070715013756.GG23209@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 19:40:48 up 8 days, 13:46,  3 users,  load average: 0.34, 0.71, 0.54
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Immediate Values - i386 Optimization - kerneldoc for implementation

Add kerneldoc to Immediate Values (i386 Optimization) API.
It applies after
"Immediate Values - i386 Optimization - kerneldoc"

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: hch@infradead.org
---
 arch/i386/kernel/immediate.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

Index: linux-2.6-lttng/arch/i386/kernel/immediate.c
===================================================================
--- linux-2.6-lttng.orig/arch/i386/kernel/immediate.c	2007-07-15 19:08:03.000000000 -0400
+++ linux-2.6-lttng/arch/i386/kernel/immediate.c	2007-07-15 19:09:56.000000000 -0400
@@ -170,8 +170,12 @@ static struct notifier_block immediate_n
 	.priority = 0x7fffffff,	/* we need to be notified first */
 };
 
-/*
- * Must be called with immediate_mutex held.
+
+/**
+ * arch_immediate_update - update one immediate value
+ * @immediate: pointer of type const struct __immediate to update
+ *
+ * Update one immediate value. Must be called with immediate_mutex held.
  */
 __kprobes int arch_immediate_update(const struct __immediate *immediate)
 {
@@ -266,8 +270,11 @@ __kprobes int arch_immediate_update(cons
 	return 0;
 }
 
-/*
- * Very early initialization of the in-core immediate values.
+/**
+ * arch_immediate_update_early - update one immediate value at boot time
+ * @immediate: pointer of type const struct __immediate to update
+ *
+ * Update one immediate value at boot time.
  */
 void __init arch_immediate_update_early(const struct __immediate *immediate)
 {
-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
