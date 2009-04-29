Return-Path: <linux-kernel-owner+w=401wt.eu-S1757170AbZD2NEl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757170AbZD2NEl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 09:04:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756751AbZD2NE0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 09:04:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:44462 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756615AbZD2NEY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 09:04:24 -0400
Date: Wed, 29 Apr 2009 13:03:41 GMT
From: tip-bot for Robert Richter <robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, robert.richter@amd.com, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, robert.richter@amd.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1241002046-8832-3-git-send-email-robert.richter@amd.com>
References: <1241002046-8832-3-git-send-email-robert.richter@amd.com>
Subject: [tip:perfcounters/core] perf_counter, x86: declare perf_max_counters only for CONFIG_PERF_COUNTERS
Message-ID: <tip-829b42dd395c5801f6ae87da87ecbdcfd5ef1a6c@git.kernel.org>
Git-Commit-ID: 829b42dd395c5801f6ae87da87ecbdcfd5ef1a6c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 29 Apr 2009 13:03:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  829b42dd395c5801f6ae87da87ecbdcfd5ef1a6c
Gitweb:     http://git.kernel.org/tip/829b42dd395c5801f6ae87da87ecbdcfd5ef1a6c
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Wed, 29 Apr 2009 12:46:59 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 29 Apr 2009 14:51:01 +0200

perf_counter, x86: declare perf_max_counters only for CONFIG_PERF_COUNTERS

This is only needed for CONFIG_PERF_COUNTERS enabled.

[ Impact: cleanup ]

Signed-off-by: Robert Richter <robert.richter@amd.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <1241002046-8832-3-git-send-email-robert.richter@amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/perf_counter.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 9814328..be10b3f 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -512,12 +512,13 @@ struct perf_cpu_context {
 	int			recursion[4];
 };
 
+#ifdef CONFIG_PERF_COUNTERS
+
 /*
  * Set by architecture code:
  */
 extern int perf_max_counters;
 
-#ifdef CONFIG_PERF_COUNTERS
 extern const struct hw_perf_counter_ops *
 hw_perf_counter_init(struct perf_counter *counter);
 
