Return-Path: <linux-kernel-owner+w=401wt.eu-S1764508AbZE0Orf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764508AbZE0Orf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 10:47:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760454AbZE0Or1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 10:47:27 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44190 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760411AbZE0Or0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 10:47:26 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 1/2] FS-Cache: Fixup renamed filenames in comments in
	internal.h
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: dhowells@redhat.com, linux-cachefs@redhat.com,
       linux-kernel@vger.kernel.org
Date: Wed, 27 May 2009 15:46:50 +0100
Message-ID: <20090527144649.31445.46764.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix up renamed filenames in comments in fs/fscache/internal.h.  Originally, the
files were all called fsc-xxx.c, but they got renamed to just xxx.c.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/fscache/internal.h |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)


diff --git a/fs/fscache/internal.h b/fs/fscache/internal.h
index e0cbd16..1c34130 100644
--- a/fs/fscache/internal.h
+++ b/fs/fscache/internal.h
@@ -28,7 +28,7 @@
 #define FSCACHE_MAX_THREADS	32
 
 /*
- * fsc-cache.c
+ * cache.c
  */
 extern struct list_head fscache_cache_list;
 extern struct rw_semaphore fscache_addremove_sem;
@@ -37,7 +37,7 @@ extern struct fscache_cache *fscache_select_cache_for_object(
 	struct fscache_cookie *);
 
 /*
- * fsc-cookie.c
+ * cookie.c
  */
 extern struct kmem_cache *fscache_cookie_jar;
 
@@ -45,13 +45,13 @@ extern void fscache_cookie_init_once(void *);
 extern void __fscache_cookie_put(struct fscache_cookie *);
 
 /*
- * fsc-fsdef.c
+ * fsdef.c
  */
 extern struct fscache_cookie fscache_fsdef_index;
 extern struct fscache_cookie_def fscache_fsdef_netfs_def;
 
 /*
- * fsc-histogram.c
+ * histogram.c
  */
 #ifdef CONFIG_FSCACHE_HISTOGRAM
 extern atomic_t fscache_obj_instantiate_histogram[HZ];
@@ -75,7 +75,7 @@ extern const struct file_operations fscache_histogram_fops;
 #endif
 
 /*
- * fsc-main.c
+ * main.c
  */
 extern unsigned fscache_defer_lookup;
 extern unsigned fscache_defer_create;
@@ -86,14 +86,14 @@ extern int fscache_wait_bit(void *);
 extern int fscache_wait_bit_interruptible(void *);
 
 /*
- * fsc-object.c
+ * object.c
  */
 extern void fscache_withdrawing_object(struct fscache_cache *,
 				       struct fscache_object *);
 extern void fscache_enqueue_object(struct fscache_object *);
 
 /*
- * fsc-operation.c
+ * operation.c
  */
 extern int fscache_submit_exclusive_op(struct fscache_object *,
 				       struct fscache_operation *);
@@ -104,7 +104,7 @@ extern void fscache_start_operations(struct fscache_object *);
 extern void fscache_operation_gc(struct work_struct *);
 
 /*
- * fsc-proc.c
+ * proc.c
  */
 #ifdef CONFIG_PROC_FS
 extern int __init fscache_proc_init(void);
@@ -115,7 +115,7 @@ extern void fscache_proc_cleanup(void);
 #endif
 
 /*
- * fsc-stats.c
+ * stats.c
  */
 #ifdef CONFIG_FSCACHE_STATS
 extern atomic_t fscache_n_ops_processed[FSCACHE_MAX_THREADS];

