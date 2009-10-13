Return-Path: <linux-kernel-owner+w=401wt.eu-S1759073AbZJMHj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759073AbZJMHj4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 03:39:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759025AbZJMHjr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 03:39:47 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:62155 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759024AbZJMHjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 03:39:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=wUGwITHfbXIjoW27NqdN6WX9rUZ95Tnb3k/6WmBSwS6pO+GDhGjRpPAisYzCTZIMVr
         DcEUlAoTbVfQyHwU9VWTKCm/39PZBRBqST2yJJHjLDKV/P9tc6gDmT7JpwebMMeJRuTY
         wN+QWHVvl/V2oAWGpW0E0WnpnRuB8E4T8Hjts=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 3/3] tracing: Remove unused ftrace_trace_addr helper
Date: Tue, 13 Oct 2009 09:39:00 +0200
Message-Id: <1255419540-5481-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1255419540-5481-1-git-send-email-fweisbec@gmail.com>
References: <1255419540-5481-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the ftrace_trace_addr() function as only its off-case is
implemented and there are no users of it currently.

But we keep ftrace_graph_addr() off-case, in case someone come to use
the function graph tracer to profit from top-level callers filtering.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/trace.h |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 365fb19..f22a7ac 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -483,10 +483,6 @@ static inline int ftrace_graph_addr(unsigned long addr)
 	return 0;
 }
 #else
-static inline int ftrace_trace_addr(unsigned long addr)
-{
-	return 1;
-}
 static inline int ftrace_graph_addr(unsigned long addr)
 {
 	return 1;
-- 
1.6.2.3

