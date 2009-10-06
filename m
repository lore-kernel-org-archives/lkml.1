Return-Path: <linux-kernel-owner+w=401wt.eu-S1756554AbZJFGBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756554AbZJFGBw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 02:01:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756537AbZJFGBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 02:01:51 -0400
Received: from mail-yw0-f176.google.com ([209.85.211.176]:57793 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756412AbZJFGBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 02:01:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=nzU/7ggtHSN8X4bZm2ZTKA68nunPyyiD+QwETeLpnFDMYoZWPPQ2MwVdooRsaJlKxz
         q1IHRJqVK+eNkKDiy6mj4ULaodsI4bb+nAnsoffXmmHq/jhxs2ZYjPt6HCa/7Byck+8Z
         qcloFxcbBhRdTu6FjS/9TGMQJEWn3UlR+6ezo=
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, fweisbec@gmail.com, rostedt@goodmis.org,
       lizf@cn.fujitsu.com
Subject: [PATCH 2/3] perf trace: Update eval_flag() flags array to match interrupt.h
Date: Tue,  6 Oct 2009 01:00:48 -0500
Message-Id: <1254808849-7829-3-git-send-email-tzanussi@gmail.com>
X-Mailer: git-send-email 1.6.4.GIT
In-Reply-To: <1254808849-7829-1-git-send-email-tzanussi@gmail.com>
References: <1254808849-7829-1-git-send-email-tzanussi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing BLOCK_IOPOLL_SOFTIRQ entry.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
---
 tools/perf/util/trace-event-parse.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index f6a8437..55b41b9 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -1968,10 +1968,11 @@ static const struct flag flags[] = {
 	{ "NET_TX_SOFTIRQ", 2 },
 	{ "NET_RX_SOFTIRQ", 3 },
 	{ "BLOCK_SOFTIRQ", 4 },
-	{ "TASKLET_SOFTIRQ", 5 },
-	{ "SCHED_SOFTIRQ", 6 },
-	{ "HRTIMER_SOFTIRQ", 7 },
-	{ "RCU_SOFTIRQ", 8 },
+	{ "BLOCK_IOPOLL_SOFTIRQ", 5 },
+	{ "TASKLET_SOFTIRQ", 6 },
+	{ "SCHED_SOFTIRQ", 7 },
+	{ "HRTIMER_SOFTIRQ", 8 },
+	{ "RCU_SOFTIRQ", 9 },
 
 	{ "HRTIMER_NORESTART", 0 },
 	{ "HRTIMER_RESTART", 1 },
-- 
1.6.4.GIT

