Return-Path: <linux-kernel-owner+w=401wt.eu-S1754426AbZGWTVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754426AbZGWTVT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 15:21:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754293AbZGWTVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 15:21:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:36976 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754093AbZGWTVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 15:21:12 -0400
Message-Id: <20090723191957.221506799@chello.nl>
References: <20090723191642.780643661@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 23 Jul 2009 21:16:49 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 07/13] lockdep: Style nits
Content-Disposition: inline; filename=lockdep-cleanup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixes a few comments and whitespaces that annoyed me

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/lockdep.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

Index: linux-2.6/kernel/lockdep.c
===================================================================
--- linux-2.6.orig/kernel/lockdep.c
+++ linux-2.6/kernel/lockdep.c
@@ -867,15 +867,18 @@ static int add_lock_to_list(struct lock_
 	return 1;
 }
 
-/*For good efficiency of modular, we use power of 2*/
+/*
+ * For good efficiency of modular, we use power of 2
+ */
 #define MAX_CIRCULAR_QUEUE_SIZE		4096UL
 #define CQ_MASK				(MAX_CIRCULAR_QUEUE_SIZE-1)
 
-/* The circular_queue and helpers is used to implement the
+/*
+ * The circular_queue and helpers is used to implement the
  * breadth-first search(BFS)algorithem, by which we can build
  * the shortest path from the next lock to be acquired to the
  * previous held lock if there is a circular between them.
- * */
+ */
 struct circular_queue {
 	unsigned long element[MAX_CIRCULAR_QUEUE_SIZE];
 	unsigned int  front, rear;
@@ -931,6 +934,7 @@ static inline void mark_lock_accessed(st
 					struct lock_list *parent)
 {
 	unsigned long nr;
+
 	nr = lock - list_entries;
 	WARN_ON(nr >= nr_list_entries);
 	lock->parent = parent;
@@ -940,6 +944,7 @@ static inline void mark_lock_accessed(st
 static inline unsigned long lock_accessed(struct lock_list *lock)
 {
 	unsigned long nr;
+
 	nr = lock - list_entries;
 	WARN_ON(nr >= nr_list_entries);
 	return test_bit(nr, bfs_accessed);

-- 

