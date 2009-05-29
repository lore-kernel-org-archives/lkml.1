Return-Path: <linux-kernel-owner+w=401wt.eu-S1755676AbZE2HHz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755676AbZE2HHz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 03:07:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755410AbZE2HHm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 03:07:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:39012 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755047AbZE2HHk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 03:07:40 -0400
Date: Fri, 29 May 2009 07:07:04 GMT
From: tip-bot for Mike Galbraith <efault@gmx.de>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter tools: Fix top symbol table max_ip typo
Message-ID: <tip-da417a7537cbf4beb28a08a49adf915f2358040c@git.kernel.org>
Git-Commit-ID: da417a7537cbf4beb28a08a49adf915f2358040c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 29 May 2009 07:07:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  da417a7537cbf4beb28a08a49adf915f2358040c
Gitweb:     http://git.kernel.org/tip/da417a7537cbf4beb28a08a49adf915f2358040c
Author:     Mike Galbraith <efault@gmx.de>
AuthorDate: Fri, 29 May 2009 08:23:16 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 29 May 2009 09:03:57 +0200

perf_counter tools: Fix top symbol table max_ip typo

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/builtin-top.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/perf_counter/builtin-top.c b/Documentation/perf_counter/builtin-top.c
index 0d100f5..ebe8bec 100644
--- a/Documentation/perf_counter/builtin-top.c
+++ b/Documentation/perf_counter/builtin-top.c
@@ -368,7 +368,7 @@ static int parse_symbols(void)
 
 	node = rb_last(&kernel_dso->syms);
 	sym = rb_entry(node, struct symbol, rb_node);
-	max_ip = sym->start;
+	max_ip = sym->end;
 
 	if (dump_symtab)
 		dso__fprintf(kernel_dso, stderr);
