Return-Path: <linux-kernel-owner+w=401wt.eu-S1755575AbZEVKh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575AbZEVKh1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 06:37:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751643AbZEVKhP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 06:37:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:47976 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751324AbZEVKhO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 06:37:14 -0400
Date: Fri, 22 May 2009 10:36:33 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
       mtosatti@redhat.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       mtosatti@redhat.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
In-Reply-To: <18966.10666.517218.332164@cargo.ozlabs.ibm.com>
References: <18966.10666.517218.332164@cargo.ozlabs.ibm.com>
Subject: [tip:perfcounters/core] perf_counter: fix !PERF_COUNTERS build failure
Message-ID: <tip-910431c7f2e963017d767b29c80ae706421e569f@git.kernel.org>
Git-Commit-ID: 910431c7f2e963017d767b29c80ae706421e569f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 22 May 2009 10:36:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  910431c7f2e963017d767b29c80ae706421e569f
Gitweb:     http://git.kernel.org/tip/910431c7f2e963017d767b29c80ae706421e569f
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Fri, 22 May 2009 12:32:15 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 22 May 2009 12:33:14 +0200

perf_counter: fix !PERF_COUNTERS build failure

Update the !CONFIG_PERF_COUNTERS prototype too, for
perf_counter_task_sched_out().

[ Impact: build fix ]

Signed-off-by: Paul Mackerras <paulus@samba.org>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <18966.10666.517218.332164@cargo.ozlabs.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/perf_counter.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 4cae01a..2eedae8 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -625,7 +625,8 @@ extern void perf_counter_init(void);
 static inline void
 perf_counter_task_sched_in(struct task_struct *task, int cpu)		{ }
 static inline void
-perf_counter_task_sched_out(struct task_struct *task, int cpu)		{ }
+perf_counter_task_sched_out(struct task_struct *task,
+			    struct task_struct *next, int cpu)		{ }
 static inline void
 perf_counter_task_tick(struct task_struct *task, int cpu)		{ }
 static inline void perf_counter_init_task(struct task_struct *child)	{ }
