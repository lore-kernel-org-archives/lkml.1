Return-Path: <linux-kernel-owner+w=401wt.eu-S1751828AbZEZKfD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828AbZEZKfD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 06:35:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752075AbZEZKen
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 06:34:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:56438 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751519AbZEZKel (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 06:34:41 -0400
Date: Tue, 26 May 2009 10:34:02 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
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
Subject: [tip:perfcounters/core] perf stat: Remove unused variable
Message-ID: <tip-4e97ddf09ee3ce715fc334399bae4cc0c0a13057@git.kernel.org>
Git-Commit-ID: 4e97ddf09ee3ce715fc334399bae4cc0c0a13057
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 26 May 2009 10:34:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4e97ddf09ee3ce715fc334399bae4cc0c0a13057
Gitweb:     http://git.kernel.org/tip/4e97ddf09ee3ce715fc334399bae4cc0c0a13057
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Tue, 26 May 2009 10:07:44 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 26 May 2009 10:08:19 +0200

perf stat: Remove unused variable

[ Impact: cleanup ]

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Kacur <jkacur@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/builtin-stat.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/Documentation/perf_counter/builtin-stat.c b/Documentation/perf_counter/builtin-stat.c
index 88c70be..c1053d8 100644
--- a/Documentation/perf_counter/builtin-stat.c
+++ b/Documentation/perf_counter/builtin-stat.c
@@ -541,8 +541,6 @@ static void skip_signal(int signo)
 
 int cmd_stat(int argc, char **argv, const char *prefix)
 {
-	sigset_t blocked;
-
 	page_size = sysconf(_SC_PAGE_SIZE);
 
 	process_options(argc, argv);
