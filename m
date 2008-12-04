Return-Path: <linux-kernel-owner+w=401wt.eu-S1754619AbYLDIbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619AbYLDIbj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 03:31:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750852AbYLDIb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 03:31:29 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55168 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750755AbYLDIb2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 03:31:28 -0500
Date: Thu, 4 Dec 2008 09:30:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>, containers@lists.osdl.org,
       Eric Biederman <ebiederm@xmission.com>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>
Subject: [PATCH] tracing: fix typo
Message-ID: <20081204083059.GA8131@elte.hu>
References: <20081204052638.425740534@goodmis.org> <20081204081008.GC32594@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081204081008.GC32594@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


small fixlet below.

	Ingo

-------------->
>From a3c1b9d13bfb96036face4ed424c604c432db393 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Thu, 4 Dec 2008 09:18:28 +0100
Subject: [PATCH] tracing: fix typo

Impact: fix build bug

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/trace/trace.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 8b81b4d..96202b3 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -529,7 +529,7 @@ static inline int ftrace_graph_addr(unsigned long addr)
 #else
 static inline int ftrace_trace_addr(unsigned long addr)
 {
-	return 1
+	return 1;
 }
 #endif /* CONFIG_DYNAMIC_FTRACE */
 
