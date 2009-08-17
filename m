Return-Path: <linux-kernel-owner+w=401wt.eu-S1758204AbZHQWG5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758204AbZHQWG5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 18:06:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753469AbZHQWG4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 18:06:56 -0400
Received: from hera.kernel.org ([140.211.167.34]:50645 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752630AbZHQWGz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 18:06:55 -0400
Date: Mon, 17 Aug 2009 22:06:11 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, efault@gmx.de, peterz@infradead.org,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, rostedt@goodmis.org,
       peterz@infradead.org, efault@gmx.de, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1250543271-8383-1-git-send-email-fweisbec@gmail.com>
References: <1250543271-8383-1-git-send-email-fweisbec@gmail.com>
Subject: [tip:perfcounters/tracing] perf tools: Fix spelling mistake in callchain error
Message-ID: <tip-6ede59c412579303a25c11f93d4d262e100fc7e6@git.kernel.org>
Git-Commit-ID: 6ede59c412579303a25c11f93d4d262e100fc7e6
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 17 Aug 2009 22:06:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6ede59c412579303a25c11f93d4d262e100fc7e6
Gitweb:     http://git.kernel.org/tip/6ede59c412579303a25c11f93d4d262e100fc7e6
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Mon, 17 Aug 2009 23:07:48 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 18 Aug 2009 00:00:18 +0200

perf tools: Fix spelling mistake in callchain error

While running perf report -g in a perf.data file that hasn't
been recorded in callchain mode, the error reported has a
spelling issue:

	./perf report -g
	selected -c but no callchain data. Did you call perf record without -g?

Fix it.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <1250543271-8383-1-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-report.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 1e3ad22..ed1fdab 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -1401,7 +1401,7 @@ static int __cmd_report(void)
 			exit(-1);
 		}
 		if (callchain) {
-			fprintf(stderr, "selected -c but no callchain data."
+			fprintf(stderr, "selected -g but no callchain data."
 					" Did you call perf record without"
 					" -g?\n");
 			exit(-1);
