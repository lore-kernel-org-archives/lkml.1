Return-Path: <linux-kernel-owner+w=401wt.eu-S1756773AbZCEXWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756773AbZCEXWX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 18:22:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755079AbZCEXWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 18:22:08 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:37429 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752872AbZCEXWG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 18:22:06 -0500
Message-Id: <20090305225514.355264287@polymtl.ca>
References: <20090305224728.947235917@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 05 Mar 2009 17:47:40 -0500
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
Subject: [RFC patch 12/41] x86 : export vmalloc_sync_all()
Content-Disposition: inline; filename=export-vmalloc-sync-all-symbol.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Thu,  5 Mar 2009 23:14:10 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Needed by the tracer module. Used to make sure the tracer will not trigger a
page faults. It would be useful in case of full page fault handler
instrumentation.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 arch/x86/mm/fault.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6-lttng/arch/x86/mm/fault.c
===================================================================
--- linux-2.6-lttng.orig/arch/x86/mm/fault.c	2009-03-04 13:24:31.000000000 -0500
+++ linux-2.6-lttng/arch/x86/mm/fault.c	2009-03-04 14:11:47.000000000 -0500
@@ -935,3 +935,4 @@ void vmalloc_sync_all(void)
 	}
 #endif
 }
+EXPORT_SYMBOL_GPL(vmalloc_sync_all);

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
