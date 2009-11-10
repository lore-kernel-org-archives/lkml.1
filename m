Return-Path: <linux-kernel-owner+w=401wt.eu-S1757831AbZKJTCF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757831AbZKJTCF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 14:02:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757803AbZKJTCE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 14:02:04 -0500
Received: from hera.kernel.org ([140.211.167.34]:37415 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757819AbZKJTCC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 14:02:02 -0500
Date: Tue, 10 Nov 2009 19:01:29 GMT
From: tip-bot for Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, mitake@dcl.info.waseda.ac.jp,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       mitake@dcl.info.waseda.ac.jp, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1257865442-20252-4-git-send-email-mitake@dcl.info.waseda.ac.jp>
References: <1257865442-20252-4-git-send-email-mitake@dcl.info.waseda.ac.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/bench] perf bench: Improve sched-message.c with more comfortable output
Message-ID: <tip-c5659b74f052150791750234f92dcfb29d27efa5@git.kernel.org>
Git-Commit-ID: c5659b74f052150791750234f92dcfb29d27efa5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c5659b74f052150791750234f92dcfb29d27efa5
Gitweb:     http://git.kernel.org/tip/c5659b74f052150791750234f92dcfb29d27efa5
Author:     Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
AuthorDate: Wed, 11 Nov 2009 00:04:02 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 10 Nov 2009 19:56:46 +0100

perf bench: Improve sched-message.c with more comfortable output

This patch improves sched-message.c with more comfortable output.

Change points are comment style description and
formatting numerical values and its units.

Example:

 | % perf bench sched messaging
 | # Running sched/messaging benchmark...
 | # 20 sender and receiver processes per group
 | # 10 groups == 400 processes run
 |
 |      Total time: 1.490 [sec]

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <1257865442-20252-4-git-send-email-mitake@dcl.info.waseda.ac.jp>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
---
 tools/perf/bench/sched-messaging.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/bench/sched-messaging.c b/tools/perf/bench/sched-messaging.c
index 2cc5edc..605a2a9 100644
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
+		printf(" %14s: %lu.%03lu [sec]\n", "Total time",
 		       diff.tv_sec, diff.tv_usec/1000);
 		break;
 	case BENCH_FORMAT_SIMPLE:
