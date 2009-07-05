Return-Path: <linux-kernel-owner+w=401wt.eu-S1757448AbZGEQdg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757448AbZGEQdg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 12:33:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753018AbZGEQco
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 12:32:44 -0400
Received: from fifo99.com ([67.223.236.141]:41198 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756793AbZGEQcn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 12:32:43 -0400
From: Daniel Walker <dwalker@fifo99.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: =?utf-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
       Brian Swetland <swetland@google.com>, linux-kernel@vger.kernel.org,
       Daniel Walker <dwalker@fifo99.com>
Subject: [PATCH 4/4] staging: android: binder: partial checkpatch cleanup
Date: Sun,  5 Jul 2009 09:32:45 -0700
Message-Id: <1246811565-8548-4-git-send-email-dwalker@fifo99.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1246811565-8548-3-git-send-email-dwalker@fifo99.com>
References: <>
 <1246811565-8548-1-git-send-email-dwalker@fifo99.com>
 <1246811565-8548-2-git-send-email-dwalker@fifo99.com>
 <1246811565-8548-3-git-send-email-dwalker@fifo99.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clean up 3 or so checkpatch errors from one of my prior patches.

Signed-off-by: Daniel Walker <dwalker@fifo99.com>
---
 drivers/staging/android/binder.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
index 7e15f6e..c6dc58e 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -785,8 +785,8 @@ static struct binder_buffer *binder_alloc_buf(struct binder_proc *proc,
 	if (is_async) {
 		proc->free_async_space -= size + sizeof(struct binder_buffer);
 		binder_debug(BINDER_DEBUG_BUFFER_ALLOC_ASYNC,
-		             "binder: %d: binder_alloc_buf size %zd "
-		             "async free %zd\n", proc->pid, size,
+			     "binder: %d: binder_alloc_buf size %zd "
+			     "async free %zd\n", proc->pid, size,
 			     proc->free_async_space);
 	}
 
@@ -1146,7 +1146,7 @@ static void binder_delete_ref(struct binder_ref *ref)
 		binder_debug(BINDER_DEBUG_DEAD_BINDER,
 			     "binder: %d delete ref %d desc %d "
 			     "has death notification\n", ref->proc->pid,
-		             ref->debug_id, ref->desc);
+			     ref->debug_id, ref->desc);
 		list_del(&ref->death->work.entry);
 		kfree(ref->death);
 		binder_stats_deleted(BINDER_STAT_DEATH);
@@ -2331,7 +2331,7 @@ retry:
 				if (!weak && !strong) {
 					binder_debug(BINDER_DEBUG_INTERNAL_REFS,
 						     "binder: %d:%d node %d u%p c%p deleted\n",
-					    	     proc->pid, thread->pid, node->debug_id,
+						     proc->pid, thread->pid, node->debug_id,
 						     node->ptr, node->cookie);
 					rb_erase(&node->rb_node, &proc->nodes);
 					kfree(node);
-- 
1.5.4.3

