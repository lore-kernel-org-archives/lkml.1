Return-Path: <linux-kernel-owner+w=401wt.eu-S932345AbZJFMSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932345AbZJFMSR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 08:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932328AbZJFMSQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 08:18:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:34774 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932327AbZJFMSO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 08:18:14 -0400
Date: Tue, 6 Oct 2009 12:16:58 GMT
From: tip-bot for Tom Zanussi <tzanussi@gmail.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, fweisbec@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, tzanussi@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, fweisbec@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1254808849-7829-3-git-send-email-tzanussi@gmail.com>
References: <1254808849-7829-3-git-send-email-tzanussi@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf trace: Update eval_flag() flags array to match interrupt.h
Message-ID: <tip-b934cdd55f2ac38c825f3d46cfa87a1654f1c849@git.kernel.org>
Git-Commit-ID: b934cdd55f2ac38c825f3d46cfa87a1654f1c849
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 06 Oct 2009 12:16:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b934cdd55f2ac38c825f3d46cfa87a1654f1c849
Gitweb:     http://git.kernel.org/tip/b934cdd55f2ac38c825f3d46cfa87a1654f1c849
Author:     Tom Zanussi <tzanussi@gmail.com>
AuthorDate: Tue, 6 Oct 2009 01:00:48 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 6 Oct 2009 12:02:34 +0200

perf trace: Update eval_flag() flags array to match interrupt.h

Add missing BLOCK_IOPOLL_SOFTIRQ entry.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: rostedt@goodmis.org
Cc: lizf@cn.fujitsu.com
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <1254808849-7829-3-git-send-email-tzanussi@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
