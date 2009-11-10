Return-Path: <linux-kernel-owner+w=401wt.eu-S1756700AbZKJPEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756700AbZKJPEU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 10:04:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756653AbZKJPEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 10:04:09 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:63592 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756630AbZKJPEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 10:04:06 -0500
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 3/3] perf bench: Fix sched-message.c for more confortable output
Date: Wed, 11 Nov 2009 00:04:02 +0900
Message-Id: <1257865442-20252-4-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1257865442-20252-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
References: <1257865442-20252-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes sched-message.c for more confortable output.
Change points are comment style description and
formatting numerical values and its units.

Example of use:
| % perf bench sched messaging
| # Running sched/messaging benchmark...
| # 20 sender and receiver processes per group
| # 10 groups == 400 processes run
|
|      Total time:1.490 [sec]

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
---
 tools/perf/bench/sched-messaging.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/bench/sched-messaging.c b/tools/perf/bench/sched-messaging.c
index 2cc5edc..0a86dea 100644
--- a/tools/perf/bench/sched-messaging.c
+++ b/tools/perf/bench/sched-messaging.c
@@ -314,12 +314,12 @@ int bench_sched_messaging(int argc, const char **argv,
 
 	switch (bench_format) {
 	case BENCH_FORMAT_DEFAULT:
-		printf("(%d sender and receiver %s per group)\n",
+		printf("# %d sender and receiver %s per group\n",
 		       num_fds, thread_mode ? "threads" : "processes");
-		printf("(%d groups == %d %s run)\n\n",
+		printf("# %d groups == %d %s run\n\n",
 		       num_groups, num_groups * 2 * num_fds,
 		       thread_mode ? "threads" : "processes");
-		printf("\tTotal time:%lu.%03lu sec\n",
+		printf(" %14s:%lu.%03lu [sec]\n", "Total time",
 		       diff.tv_sec, diff.tv_usec/1000);
 		break;
 	case BENCH_FORMAT_SIMPLE:
-- 
1.5.6.5

