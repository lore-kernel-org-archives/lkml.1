Return-Path: <linux-kernel-owner+w=401wt.eu-S1757835AbZBEGOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757835AbZBEGOi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 01:14:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753928AbZBEGOM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 01:14:12 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:43783 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753762AbZBEGOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 01:14:11 -0500
Message-Id: <20090205061407.743306319@goodmis.org>
References: <20090205061335.917484162@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 05 Feb 2009 01:13:36 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 1/3] trace_branch: Remove unused function
Content-Disposition: inline; filename=0001-trace_branch-Remove-unused-function.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Impact: cleanup

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace_branch.c |   17 -----------------
 1 files changed, 0 insertions(+), 17 deletions(-)

diff --git a/kernel/trace/trace_branch.c b/kernel/trace/trace_branch.c
index 7ac72a4..f9b2f4d 100644
--- a/kernel/trace/trace_branch.c
+++ b/kernel/trace/trace_branch.c
@@ -143,23 +143,6 @@ static void branch_trace_reset(struct trace_array *tr)
 	stop_branch_trace(tr);
 }
 
-static int
-trace_print_print(struct trace_seq *s, struct trace_entry *entry, int flags)
-{
-	struct print_entry *field;
-
-	trace_assign_type(field, entry);
-
-	if (seq_print_ip_sym(s, field->ip, flags))
-		goto partial;
-
-	if (trace_seq_printf(s, ": %s", field->buf))
-		goto partial;
-
- partial:
-	return TRACE_TYPE_PARTIAL_LINE;
-}
-
 static enum print_line_t trace_branch_print(struct trace_iterator *iter,
 					    int flags)
 {
-- 
1.5.6.5

-- 
