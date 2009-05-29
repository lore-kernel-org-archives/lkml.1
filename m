Return-Path: <linux-kernel-owner+w=401wt.eu-S1755890AbZE2HHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890AbZE2HHn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 03:07:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752660AbZE2HHf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 03:07:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:39009 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751866AbZE2HHe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 03:07:34 -0400
Date: Fri, 29 May 2009 07:06:52 GMT
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
Subject: [tip:perfcounters/core] perf_counter tools: Fix top symbol table dump typo
Message-ID: <tip-a3ec8d70f1a55acccc4874fe9b4dadbbb9454a0f@git.kernel.org>
Git-Commit-ID: a3ec8d70f1a55acccc4874fe9b4dadbbb9454a0f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 29 May 2009 07:06:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a3ec8d70f1a55acccc4874fe9b4dadbbb9454a0f
Gitweb:     http://git.kernel.org/tip/a3ec8d70f1a55acccc4874fe9b4dadbbb9454a0f
Author:     Mike Galbraith <efault@gmx.de>
AuthorDate: Fri, 29 May 2009 06:46:46 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 29 May 2009 09:03:56 +0200

perf_counter tools: Fix top symbol table dump typo

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/builtin-top.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/perf_counter/builtin-top.c b/Documentation/perf_counter/builtin-top.c
index 52ba9f4..0d100f5 100644
--- a/Documentation/perf_counter/builtin-top.c
+++ b/Documentation/perf_counter/builtin-top.c
@@ -371,7 +371,7 @@ static int parse_symbols(void)
 	max_ip = sym->start;
 
 	if (dump_symtab)
-		dso__fprintf(kernel_dso, stdout);
+		dso__fprintf(kernel_dso, stderr);
 
 	return 0;
 
