Return-Path: <linux-kernel-owner+w=401wt.eu-S1756589AbZD2NKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756589AbZD2NKg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 09:10:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758814AbZD2NHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 09:07:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:44613 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758903AbZD2NHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 09:07:15 -0400
Date: Wed, 29 Apr 2009 13:06:32 GMT
From: tip-bot for Robert Richter <robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, robert.richter@amd.com, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, robert.richter@amd.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1241002046-8832-18-git-send-email-robert.richter@amd.com>
References: <1241002046-8832-18-git-send-email-robert.richter@amd.com>
Subject: [tip:perfcounters/core] perf_counter, x86: make x86_pmu_read() static inline
Message-ID: <tip-bb775fc2d1dcd1aa6eafde37a8289ba2d80783aa@git.kernel.org>
Git-Commit-ID: bb775fc2d1dcd1aa6eafde37a8289ba2d80783aa
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 29 Apr 2009 13:06:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bb775fc2d1dcd1aa6eafde37a8289ba2d80783aa
Gitweb:     http://git.kernel.org/tip/bb775fc2d1dcd1aa6eafde37a8289ba2d80783aa
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Wed, 29 Apr 2009 12:47:14 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 29 Apr 2009 14:51:09 +0200

perf_counter, x86: make x86_pmu_read() static inline

[ Impact: micro-optimization ]

Signed-off-by: Robert Richter <robert.richter@amd.com>
Cc: Paul Mackerras <paulus@samba.org>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1241002046-8832-18-git-send-email-robert.richter@amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/perf_counter.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index 15d2c03..3f3ae47 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -1002,7 +1002,7 @@ void __init init_hw_perf_counters(void)
 	register_die_notifier(&perf_counter_nmi_notifier);
 }
 
-static void x86_pmu_read(struct perf_counter *counter)
+static inline void x86_pmu_read(struct perf_counter *counter)
 {
 	x86_perf_counter_update(counter, &counter->hw, counter->hw.idx);
 }
