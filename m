Return-Path: <linux-kernel-owner+w=401wt.eu-S1756597AbZCXIOw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597AbZCXIOw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 04:14:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751919AbZCXIOf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 04:14:35 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:34335 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbZCXIOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 04:14:34 -0400
Subject: [PATCH 1/2] kmemtrace: fix tracepoint declarations
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: mingo@elte.hu
Cc: eduard.munteanu@linux360.ro, linux-kernel@vger.kernel.org
Date: Tue, 24 Mar 2009 10:14:30 +0200
Message-Id: <1237882470.25315.30.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

Impact: fix build

Use the new TP_PROTO and TP_ARGS to fix the build.

Cc: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 include/trace/kmemtrace.h |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/include/trace/kmemtrace.h b/include/trace/kmemtrace.h
index 9e28ae1..7514476 100644
--- a/include/trace/kmemtrace.h
+++ b/include/trace/kmemtrace.h
@@ -15,41 +15,41 @@
 extern void kmemtrace_init(void);
 
 DECLARE_TRACE(kmalloc,
-	      TPPROTO(unsigned long call_site,
+	      TP_PROTO(unsigned long call_site,
 		      const void *ptr,
 		      size_t bytes_req,
 		      size_t bytes_alloc,
 		      gfp_t gfp_flags),
-	      TPARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags));
+	      TP_ARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags));
 DECLARE_TRACE(kmem_cache_alloc,
-	      TPPROTO(unsigned long call_site,
+	      TP_PROTO(unsigned long call_site,
 		      const void *ptr,
 		      size_t bytes_req,
 		      size_t bytes_alloc,
 		      gfp_t gfp_flags),
-	      TPARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags));
+	      TP_ARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags));
 DECLARE_TRACE(kmalloc_node,
-	      TPPROTO(unsigned long call_site,
+	      TP_PROTO(unsigned long call_site,
 		      const void *ptr,
 		      size_t bytes_req,
 		      size_t bytes_alloc,
 		      gfp_t gfp_flags,
 		      int node),
-	      TPARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags, node));
+	      TP_ARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags, node));
 DECLARE_TRACE(kmem_cache_alloc_node,
-	      TPPROTO(unsigned long call_site,
+	      TP_PROTO(unsigned long call_site,
 		      const void *ptr,
 		      size_t bytes_req,
 		      size_t bytes_alloc,
 		      gfp_t gfp_flags,
 		      int node),
-	      TPARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags, node));
+	      TP_ARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags, node));
 DECLARE_TRACE(kfree,
-	      TPPROTO(unsigned long call_site, const void *ptr),
-	      TPARGS(call_site, ptr));
+	      TP_PROTO(unsigned long call_site, const void *ptr),
+	      TP_ARGS(call_site, ptr));
 DECLARE_TRACE(kmem_cache_free,
-	      TPPROTO(unsigned long call_site, const void *ptr),
-	      TPARGS(call_site, ptr));
+	      TP_PROTO(unsigned long call_site, const void *ptr),
+	      TP_ARGS(call_site, ptr));
 
 #endif /* __KERNEL__ */
 
-- 
1.5.4.3



