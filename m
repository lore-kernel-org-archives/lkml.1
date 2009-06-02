Return-Path: <linux-kernel-owner+w=401wt.eu-S1753288AbZFBWc7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288AbZFBWc7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 18:32:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752533AbZFBWcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 18:32:51 -0400
Received: from hera.kernel.org ([140.211.167.34]:57032 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752074AbZFBWcu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 18:32:50 -0400
Date: Tue, 2 Jun 2009 22:32:15 GMT
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
Subject: [tip:perfcounters/core] perf record: Increase mmap buffering default
Message-ID: <tip-3cf165fc2e7f221a7a95098b47eb990779e29f5f@git.kernel.org>
Git-Commit-ID: 3cf165fc2e7f221a7a95098b47eb990779e29f5f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 02 Jun 2009 22:32:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3cf165fc2e7f221a7a95098b47eb990779e29f5f
Gitweb:     http://git.kernel.org/tip/3cf165fc2e7f221a7a95098b47eb990779e29f5f
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Tue, 2 Jun 2009 23:02:59 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 2 Jun 2009 23:04:24 +0200

perf record: Increase mmap buffering default

I've run into mmap overruns with the current 16 pages default,
increase it to 128 pages.

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
 Documentation/perf_counter/builtin-record.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/perf_counter/builtin-record.c b/Documentation/perf_counter/builtin-record.c
index 19cba6b..8feb119 100644
--- a/Documentation/perf_counter/builtin-record.c
+++ b/Documentation/perf_counter/builtin-record.c
@@ -19,9 +19,9 @@ static int			default_interval = 100000;
 static int			event_count[MAX_COUNTERS];
 
 static int			fd[MAX_NR_CPUS][MAX_COUNTERS];
-static int			nr_cpus				=  0;
+static int			nr_cpus				= 0;
 static unsigned int		page_size;
-static unsigned int		mmap_pages			= 16;
+static unsigned int		mmap_pages			= 128;
 static int			output;
 static const char		*output_name			= "perf.data";
 static int			group				= 0;
