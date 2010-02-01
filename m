Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264Ab0BAQvJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 11:51:09 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:57455 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753758Ab0BAQvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 11:51:06 -0500
From: Darren Hart <dvhltc@us.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: rostedt@goodmis.org, Darren Hart <dvhltc@us.ibm.com>
Subject: [PATCH 1/3] trace-graph: fix printf compile warnings
Date: Mon,  1 Feb 2010 08:50:24 -0800
Message-Id: <1265043026-24987-2-git-send-email-dvhltc@us.ibm.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1265043026-24987-1-git-send-email-dvhltc@us.ibm.com>
References: <1265043026-24987-1-git-send-email-dvhltc@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
---
 trace-graph.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/trace-graph.c b/trace-graph.c
index 135e516..1759163 100644
--- a/trace-graph.c
+++ b/trace-graph.c
@@ -886,13 +886,13 @@ static void draw_cpu_info(struct graph_info *ginfo, gint cpu, gint x, gint y)
 
 	trace_seq_init(&s);
 
-	dprintf(3, "start=%zu end=%zu time=%lu\n", ginfo->start_time, ginfo->end_time, time);
+	dprintf(3, "start=%llu end=%llu time=%llu\n", ginfo->start_time, ginfo->end_time, time);
 
 	record = find_record_on_cpu(ginfo, cpu, time);
 
 	if (record) {
 
-		dprintf(3, "record->ts=%llu time=%zu-%zu\n",
+		dprintf(3, "record->ts=%llu time=%llu-%llu\n",
 			record->ts, time, time-(gint)(1/ginfo->resolution));
 		print_rec_info(record, pevent, cpu);
 
-- 
1.6.3.3

