Return-Path: <linux-kernel-owner+w=401wt.eu-S1762650AbXGFKga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762650AbXGFKga (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 06:36:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755300AbXGFKgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 06:36:18 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:49395 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762286AbXGFKgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 06:36:14 -0400
Subject: [PATCH] stacktrace: fix header file for !CONFIG_STACKTRACE
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain
Date: Thu, 05 Jul 2007 16:09:23 +0200
Message-Id: <1183644563.3818.56.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The print_stack_trace macro in stacktrace.h has a wrong number of
arguments, fix it.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 include/linux/stacktrace.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6-git.orig/include/linux/stacktrace.h	2007-07-05 16:03:41.313168396 +0200
+++ linux-2.6-git/include/linux/stacktrace.h	2007-07-05 16:04:01.588168396 +0200
@@ -13,7 +13,7 @@ extern void save_stack_trace(struct stac
 extern void print_stack_trace(struct stack_trace *trace, int spaces);
 #else
 # define save_stack_trace(trace)			do { } while (0)
-# define print_stack_trace(trace)			do { } while (0)
+# define print_stack_trace(trace, spaces)		do { } while (0)
 #endif
 
 #endif


