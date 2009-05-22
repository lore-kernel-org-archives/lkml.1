Return-Path: <linux-kernel-owner+w=401wt.eu-S1756457AbZEVQWi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756457AbZEVQWi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 12:22:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751535AbZEVQWa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 12:22:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:50101 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751442AbZEVQW3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 12:22:29 -0400
Date: Fri, 22 May 2009 16:21:51 GMT
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
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter tools: increase limits
Message-ID: <tip-c6eb13847ba081552d2af644219bddeff7110caf@git.kernel.org>
Git-Commit-ID: c6eb13847ba081552d2af644219bddeff7110caf
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 22 May 2009 16:21:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c6eb13847ba081552d2af644219bddeff7110caf
Gitweb:     http://git.kernel.org/tip/c6eb13847ba081552d2af644219bddeff7110caf
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Fri, 22 May 2009 18:18:28 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 22 May 2009 18:18:28 +0200

perf_counter tools: increase limits

I tried to run with 300 active counters and the tools bailed out
because our limit was at 64. So increase the counter limit to 1024
and the CPU limit to 4096.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/perf.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/perf_counter/perf.h b/Documentation/perf_counter/perf.h
index 6fa3656..81a7374 100644
--- a/Documentation/perf_counter/perf.h
+++ b/Documentation/perf_counter/perf.h
@@ -54,8 +54,8 @@ sys_perf_counter_open(struct perf_counter_hw_event *hw_event_uptr,
 		       group_fd, flags);
 }
 
-#define MAX_COUNTERS			64
-#define MAX_NR_CPUS			256
+#define MAX_COUNTERS			1024
+#define MAX_NR_CPUS			4096
 
 #define EID(type, id) (((__u64)(type) << PERF_COUNTER_TYPE_SHIFT) | (id))
 
