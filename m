Return-Path: <linux-kernel-owner+w=401wt.eu-S1764458AbZE0Orq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764458AbZE0Orq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 10:47:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764328AbZE0Or3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 10:47:29 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44193 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764249AbZE0Or3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 10:47:29 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/2] CacheFiles: Fixup renamed filenames in comments in
	internal.h
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: dhowells@redhat.com, linux-cachefs@redhat.com,
       linux-kernel@vger.kernel.org
Date: Wed, 27 May 2009 15:46:55 +0100
Message-ID: <20090527144655.31445.77160.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090527144649.31445.46764.stgit@warthog.procyon.org.uk>
References: <20090527144649.31445.46764.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix up renamed filenames in comments in fs/cachefiles/internal.h.  Originally,
the files were all called cf-xxx.c, but they got renamed to just xxx.c.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/cachefiles/internal.h |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)


diff --git a/fs/cachefiles/internal.h b/fs/cachefiles/internal.h
index 19218e1..f7c255f 100644
--- a/fs/cachefiles/internal.h
+++ b/fs/cachefiles/internal.h
@@ -122,13 +122,13 @@ static inline void cachefiles_state_changed(struct cachefiles_cache *cache)
 }
 
 /*
- * cf-bind.c
+ * bind.c
  */
 extern int cachefiles_daemon_bind(struct cachefiles_cache *cache, char *args);
 extern void cachefiles_daemon_unbind(struct cachefiles_cache *cache);
 
 /*
- * cf-daemon.c
+ * daemon.c
  */
 extern const struct file_operations cachefiles_daemon_fops;
 
@@ -136,17 +136,17 @@ extern int cachefiles_has_space(struct cachefiles_cache *cache,
 				unsigned fnr, unsigned bnr);
 
 /*
- * cf-interface.c
+ * interface.c
  */
 extern const struct fscache_cache_ops cachefiles_cache_ops;
 
 /*
- * cf-key.c
+ * key.c
  */
 extern char *cachefiles_cook_key(const u8 *raw, int keylen, uint8_t type);
 
 /*
- * cf-namei.c
+ * namei.c
  */
 extern int cachefiles_delete_object(struct cachefiles_cache *cache,
 				    struct cachefiles_object *object);
@@ -165,7 +165,7 @@ extern int cachefiles_check_in_use(struct cachefiles_cache *cache,
 				   struct dentry *dir, char *filename);
 
 /*
- * cf-proc.c
+ * proc.c
  */
 #ifdef CONFIG_CACHEFILES_HISTOGRAM
 extern atomic_t cachefiles_lookup_histogram[HZ];
@@ -190,7 +190,7 @@ void cachefiles_hist(atomic_t histogram[], unsigned long start_jif)
 #endif
 
 /*
- * cf-rdwr.c
+ * rdwr.c
  */
 extern int cachefiles_read_or_alloc_page(struct fscache_retrieval *,
 					 struct page *, gfp_t);
@@ -205,7 +205,7 @@ extern int cachefiles_write_page(struct fscache_storage *, struct page *);
 extern void cachefiles_uncache_page(struct fscache_object *, struct page *);
 
 /*
- * cf-security.c
+ * security.c
  */
 extern int cachefiles_get_security_ID(struct cachefiles_cache *cache);
 extern int cachefiles_determine_cache_security(struct cachefiles_cache *cache,
@@ -225,7 +225,7 @@ static inline void cachefiles_end_secure(struct cachefiles_cache *cache,
 }
 
 /*
- * cf-xattr.c
+ * xattr.c
  */
 extern int cachefiles_check_object_type(struct cachefiles_object *object);
 extern int cachefiles_set_object_xattr(struct cachefiles_object *object,

