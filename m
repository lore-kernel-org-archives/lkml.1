Return-Path: <linux-kernel-owner+w=401wt.eu-S932317AbZJFMSA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932317AbZJFMSA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 08:18:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932265AbZJFMR7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 08:17:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:34763 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932258AbZJFMR6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 08:17:58 -0400
Date: Tue, 6 Oct 2009 12:16:42 GMT
From: tip-bot for Tom Zanussi <tzanussi@gmail.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, fweisbec@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, tzanussi@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, fweisbec@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1254808849-7829-2-git-send-email-tzanussi@gmail.com>
References: <1254808849-7829-2-git-send-email-tzanussi@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf trace: Remove unused code in builtin-trace.c
Message-ID: <tip-d4c3768faaae70cdcffc3a5e296bd99edfa7ddb2@git.kernel.org>
Git-Commit-ID: d4c3768faaae70cdcffc3a5e296bd99edfa7ddb2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 06 Oct 2009 12:16:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d4c3768faaae70cdcffc3a5e296bd99edfa7ddb2
Gitweb:     http://git.kernel.org/tip/d4c3768faaae70cdcffc3a5e296bd99edfa7ddb2
Author:     Tom Zanussi <tzanussi@gmail.com>
AuthorDate: Tue, 6 Oct 2009 01:00:47 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 6 Oct 2009 12:02:33 +0200

perf trace: Remove unused code in builtin-trace.c

And some minor whitespace cleanup.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: rostedt@goodmis.org
Cc: lizf@cn.fujitsu.com
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <1254808849-7829-2-git-send-email-tzanussi@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-trace.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index e9d256e..0c5e4f7 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -219,10 +219,6 @@ remap:
 more:
 	event = (event_t *)(buf + head);
 
-	size = event->header.size;
-	if (!size)
-		size = 8;
-
 	if (head + event->header.size >= page_size * mmap_window) {
 		unsigned long shift = page_size * (head / page_size);
 		int res;
@@ -237,7 +233,6 @@ more:
 
 	size = event->header.size;
 
-
 	if (!size || process_event(event, offset, head) < 0) {
 
 		/*
@@ -290,7 +285,6 @@ int cmd_trace(int argc, const char **argv, const char *prefix __used)
 			usage_with_options(annotate_usage, options);
 	}
 
-
 	setup_pager();
 
 	return __cmd_trace();
