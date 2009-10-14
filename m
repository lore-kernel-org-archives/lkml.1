Return-Path: <linux-kernel-owner+w=401wt.eu-S1759700AbZJNTq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759700AbZJNTq5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 15:46:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932099AbZJNTq4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 15:46:56 -0400
Received: from [71.74.56.125] ([71.74.56.125]:54421 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1759482AbZJNTqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 15:46:55 -0400
Message-Id: <20091014194357.807434040@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 14 Oct 2009 15:43:34 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 03/13] [PATCH 03/13] perf tools: handle trace parsing of < and >
References: <20091014194330.980165492@goodmis.org>
Content-Disposition: inline; filename=0003-perf-tools-handle-trace-parsing-of-and.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The code to handle the '<' and '>' ops was all in place, but
they were not in the switch statement to consider them as valid ops.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 tools/perf/util/trace-event-parse.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index cae88de..8388238 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -1170,6 +1170,8 @@ process_op(struct event *event, struct print_arg *arg, char **tok)
 		   strcmp(token, "*") == 0 ||
 		   strcmp(token, "^") == 0 ||
 		   strcmp(token, "/") == 0 ||
+		   strcmp(token, "<") == 0 ||
+		   strcmp(token, ">") == 0 ||
 		   strcmp(token, "==") == 0 ||
 		   strcmp(token, "!=") == 0) {
 
-- 
1.6.3.3


