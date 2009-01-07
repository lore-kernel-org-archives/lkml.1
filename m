Return-Path: <linux-kernel-owner+w=401wt.eu-S1757266AbZAGERz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757266AbZAGERz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 23:17:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754270AbZAGERE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 23:17:04 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:43005 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643AbZAGERB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 23:17:01 -0500
Message-Id: <20090107041659.845180453@goodmis.org>
References: <20090107041605.168020089@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 06 Jan 2009 23:16:09 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Roel Kluin <roel.kluin@gmail.com>, Pekka Paalanen <pq@iki.fi>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH v2 4/4] trace: clean up funny line breaks in stat_seq_show
Content-Disposition: inline; filename=0004-trace-clean-up-funny-line-breaks-in-stat_seq_show.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: clean up

Andrew Morton pointed out that the entry assignment in stat_seq_show
did not need to be done in the declaration, causing funny line breaks.

This patch makes it a bit more pleasing on the eyes.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace_stat.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_stat.c b/kernel/trace/trace_stat.c
index 4cb4ff2..f110ce9 100644
--- a/kernel/trace/trace_stat.c
+++ b/kernel/trace/trace_stat.c
@@ -178,8 +178,9 @@ static void stat_seq_stop(struct seq_file *m, void *p)
 
 static int stat_seq_show(struct seq_file *s, void *v)
 {
-	struct trace_stat_list *entry =
-		list_entry(v, struct trace_stat_list, list);
+	struct trace_stat_list *entry;
+
+	entry =	list_entry(v, struct trace_stat_list, list);
 
 	return current_tracer.stat_show(s, entry->stat);
 }
-- 
1.5.6.5

-- 
