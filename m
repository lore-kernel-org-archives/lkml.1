Return-Path: <linux-kernel-owner+w=401wt.eu-S1757122AbZGEQcw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757122AbZGEQcw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 12:32:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756090AbZGEQcm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 12:32:42 -0400
Received: from fifo99.com ([67.223.236.141]:41184 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753018AbZGEQcm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 12:32:42 -0400
From: Daniel Walker <dwalker@fifo99.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: =?utf-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
       Brian Swetland <swetland@google.com>, linux-kernel@vger.kernel.org,
       Daniel Walker <dwalker@fifo99.com>
Subject: [PATCH 1/4] staging: android: binder: cleanup some long lines
Date: Sun,  5 Jul 2009 09:32:42 -0700
Message-Id: <1246811565-8548-1-git-send-email-dwalker@fifo99.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This file has a lot of long line problems due to the massive indent issues
that exist. This just cleans up some of the really really long ones.

Signed-off-by: Daniel Walker <dwalker@fifo99.com>
---
 drivers/staging/android/binder.c |   16 +++++++++++-----
 1 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
index bf2244e..7e15f6e 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -1308,7 +1308,8 @@ static void binder_transaction_buffer_release(struct binder_proc *proc,
 		    buffer->data_size < sizeof(*fp) ||
 		    !IS_ALIGNED(*offp, sizeof(void *))) {
 			printk(KERN_ERR "binder: transaction release %d bad"
-					"offset %zd, size %zd\n", debug_id, *offp, buffer->data_size);
+					"offset %zd, size %zd\n", debug_id,
+					*offp, buffer->data_size);
 			continue;
 		}
 		fp = (struct flat_binder_object *)(buffer->data + *offp);
@@ -1317,7 +1318,8 @@ static void binder_transaction_buffer_release(struct binder_proc *proc,
 		case BINDER_TYPE_WEAK_BINDER: {
 			struct binder_node *node = binder_get_node(proc, fp->binder);
 			if (node == NULL) {
-				printk(KERN_ERR "binder: transaction release %d bad node %p\n", debug_id, fp->binder);
+				printk(KERN_ERR "binder: transaction release %d"
+				       " bad node %p\n", debug_id, fp->binder);
 				break;
 			}
 			binder_debug(BINDER_DEBUG_TRANSACTION,
@@ -1329,7 +1331,9 @@ static void binder_transaction_buffer_release(struct binder_proc *proc,
 		case BINDER_TYPE_WEAK_HANDLE: {
 			struct binder_ref *ref = binder_get_ref(proc, fp->handle);
 			if (ref == NULL) {
-				printk(KERN_ERR "binder: transaction release %d bad handle %ld\n", debug_id, fp->handle);
+				printk(KERN_ERR "binder: transaction release %d"
+				       " bad handle %ld\n", debug_id,
+				       fp->handle);
 				break;
 			}
 			binder_debug(BINDER_DEBUG_TRANSACTION,
@@ -1346,7 +1350,8 @@ static void binder_transaction_buffer_release(struct binder_proc *proc,
 			break;
 
 		default:
-			printk(KERN_ERR "binder: transaction release %d bad object type %lx\n", debug_id, fp->type);
+			printk(KERN_ERR "binder: transaction release %d bad "
+			       "object type %lx\n", debug_id, fp->type);
 			break;
 		}
 	}
@@ -1599,7 +1604,8 @@ static void binder_transaction(struct binder_proc *proc,
 			else
 				fp->type = BINDER_TYPE_WEAK_HANDLE;
 			fp->handle = ref->desc;
-			binder_inc_ref(ref, fp->type == BINDER_TYPE_HANDLE, &thread->todo);
+			binder_inc_ref(ref, fp->type == BINDER_TYPE_HANDLE,
+				       &thread->todo);
 
 			binder_debug(BINDER_DEBUG_TRANSACTION,
 				     "        node %d u%p -> ref %d desc %d\n",
-- 
1.5.4.3

