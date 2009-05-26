Return-Path: <linux-kernel-owner+w=401wt.eu-S1754563AbZEZN2i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563AbZEZN2i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 09:28:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753204AbZEZN2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 09:28:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:57025 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751358AbZEZN23 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 09:28:29 -0400
Date: Tue, 26 May 2009 13:27:45 GMT
From: tip-bot for Mike Galbraith <efault@gmx.de>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, jkacur@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, mtosatti@redhat.com,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, a.p.zijlstra@chello.nl,
       efault@gmx.de, mtosatti@redhat.com, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf top: fix typo in -d option
Message-ID: <tip-db20c0031288ff524d82b1f240f35f85d4a052eb@git.kernel.org>
Git-Commit-ID: db20c0031288ff524d82b1f240f35f85d4a052eb
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 26 May 2009 13:27:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  db20c0031288ff524d82b1f240f35f85d4a052eb
Gitweb:     http://git.kernel.org/tip/db20c0031288ff524d82b1f240f35f85d4a052eb
Author:     Mike Galbraith <efault@gmx.de>
AuthorDate: Tue, 26 May 2009 15:25:34 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 26 May 2009 15:25:34 +0200

perf top: fix typo in -d option

Clean up copy/paste options parsing conversion error.

[ Impact: reactivate -d option ]

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: John Kacur <jkacur@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/builtin-top.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/perf_counter/builtin-top.c b/Documentation/perf_counter/builtin-top.c
index cacaa3c..6b1c66f 100644
--- a/Documentation/perf_counter/builtin-top.c
+++ b/Documentation/perf_counter/builtin-top.c
@@ -727,7 +727,7 @@ static const struct option options[] = {
 		    "number of mmap data pages"),
 	OPT_INTEGER('r', "realtime", &realtime_prio,
 		    "collect data with this RT SCHED_FIFO priority"),
-	OPT_INTEGER('d', "delay", &realtime_prio,
+	OPT_INTEGER('d', "delay", &delay_secs,
 		    "number of seconds to delay between refreshes"),
 	OPT_BOOLEAN('D', "dump-symtab", &dump_symtab,
 			    "dump the symbol table used for profiling"),
