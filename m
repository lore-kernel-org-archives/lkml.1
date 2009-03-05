Return-Path: <linux-kernel-owner+w=401wt.eu-S1756947AbZCEXXB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756947AbZCEXXB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 18:23:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756756AbZCEXWr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 18:22:47 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:32987 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755869AbZCEXWq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 18:22:46 -0500
Message-Id: <20090305225520.443427388@polymtl.ca>
References: <20090305224728.947235917@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 05 Mar 2009 17:48:07 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>, ltt-dev@lists.casi.polymtl.ca,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>, Pekka Paalanen <pq@iki.fi>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Martin Bligh <mbligh@google.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       Jiaying Zhang <jiayingz@google.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       mrubin@google.com, md@google.com
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [RFC patch 39/41] SPUFS markers API update
Content-Disposition: inline; filename=spufs-markers-api-update.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Thu,  5 Mar 2009 23:14:16 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 arch/powerpc/platforms/cell/spufs/spufs.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6-lttng/arch/powerpc/platforms/cell/spufs/spufs.h
===================================================================
--- linux-2.6-lttng.orig/arch/powerpc/platforms/cell/spufs/spufs.h	2009-02-06 14:45:12.000000000 -0500
+++ linux-2.6-lttng/arch/powerpc/platforms/cell/spufs/spufs.h	2009-02-06 15:40:25.000000000 -0500
@@ -373,9 +373,9 @@ extern void spu_free_lscsa(struct spu_st
 extern void spuctx_switch_state(struct spu_context *ctx,
 		enum spu_utilization_state new_state);
 
-#define spu_context_trace(name, ctx, spu) \
-	trace_mark(name, "ctx %p spu %p", ctx, spu);
+#define spu_context_trace(name, ctx, _spu) \
+	trace_mark(spu, name, "ctx %p spu %p", ctx, _spu);
 #define spu_context_nospu_trace(name, ctx) \
-	trace_mark(name, "ctx %p", ctx);
+	trace_mark(spu, name, "ctx %p", ctx);
 
 #endif

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
