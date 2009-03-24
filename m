Return-Path: <linux-kernel-owner+w=401wt.eu-S1756958AbZCXIXP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756958AbZCXIXP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 04:23:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754899AbZCXIW3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 04:22:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:48879 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754441AbZCXIWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 04:22:25 -0400
Date: Tue, 24 Mar 2009 08:21:28 GMT
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       penberg@cs.helsinki.fi, eduard.munteanu@linux360.ro, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       penberg@cs.helsinki.fi, eduard.munteanu@linux360.ro, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1237882470.25315.30.camel@penberg-laptop>
References: <1237882470.25315.30.camel@penberg-laptop>
Subject: [tip:tracing/kmemtrace] kmemtrace: fix tracepoint declarations
Message-ID: <tip-9d47aa18654e4344b1d20b14463addee676e9ea4@git.kernel.org>
Git-Commit-ID: 9d47aa18654e4344b1d20b14463addee676e9ea4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 24 Mar 2009 08:21:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9d47aa18654e4344b1d20b14463addee676e9ea4
Gitweb:     http://git.kernel.org/tip/9d47aa18654e4344b1d20b14463addee676e9ea4
Author:     Pekka Enberg <penberg@cs.helsinki.fi>
AuthorDate: Tue, 24 Mar 2009 10:14:30 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 24 Mar 2009 09:19:52 +0100

kmemtrace: fix tracepoint declarations

Impact: build fix

Use the new TP_PROTO and TP_ARGS to fix the build.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
LKML-Reference: <1237882470.25315.30.camel@penberg-laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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
 
