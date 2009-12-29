Return-Path: <linux-kernel-owner+w=401wt.eu-S1752722AbZL2JFG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722AbZL2JFG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 04:05:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752670AbZL2JEt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 04:04:49 -0500
Received: from mail.windriver.com ([147.11.1.11]:57429 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455AbZL2JEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 04:04:49 -0500
From: Liming Wang <liming.wang@windriver.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Liming Wang <liming.wang@windriver.com>
Subject: [PATCH 2/3] perf tools: remove pid option from stat
Date: Tue, 29 Dec 2009 16:37:08 +0800
Message-Id: <1262075829-16257-2-git-send-email-liming.wang@windriver.com>
X-Mailer: git-send-email 1.6.0.3
In-Reply-To: <1262075829-16257-1-git-send-email-liming.wang@windriver.com>
References: <1262075829-16257-1-git-send-email-liming.wang@windriver.com>
X-OriginalArrivalTime: 29 Dec 2009 09:03:42.0527 (UTC) FILETIME=[D1BB54F0:01CA8865]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pid option is useless for stat, so remove it.

Signed-off-by: Liming Wang <liming.wang@windriver.com>
---
 tools/perf/builtin-stat.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index c70d720..e3b31a3 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -71,7 +71,6 @@ static int			run_idx				=  0;
 static int			run_count			=  1;
 static int			inherit				=  1;
 static int			scale				=  1;
-static pid_t			target_pid			= -1;
 static pid_t			child_pid			= -1;
 static int			null_run			=  0;
 
@@ -471,8 +470,6 @@ static const struct option options[] = {
 		     parse_events),
 	OPT_BOOLEAN('i', "inherit", &inherit,
 		    "child tasks inherit counters"),
-	OPT_INTEGER('p', "pid", &target_pid,
-		    "stat events on existing pid"),
 	OPT_BOOLEAN('a', "all-cpus", &system_wide,
 		    "system-wide collection from all CPUs"),
 	OPT_BOOLEAN('c', "scale", &scale,
-- 
1.6.0.3

