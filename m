Return-Path: <linux-kernel-owner+w=401wt.eu-S1757851AbZBECdF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757851AbZBECdF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 21:33:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762352AbZBECco
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 21:32:44 -0500
Received: from mx2.redhat.com ([66.187.237.31]:36626 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762154AbZBECco (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 21:32:44 -0500
Date: Thu, 5 Feb 2009 00:32:31 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH tip 1/2] trace_branch: Remove unused function
Message-ID: <20090205023231.GA17653@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 kernel/trace/trace_branch.c |   17 -----------------
 1 files changed, 0 insertions(+), 17 deletions(-)

diff --git a/kernel/trace/trace_branch.c b/kernel/trace/trace_branch.c
index 297deb2..027e836 100644
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
1.6.0.6

