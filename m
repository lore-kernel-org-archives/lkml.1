Return-Path: <linux-kernel-owner+w=401wt.eu-S1758808AbZIPKZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758808AbZIPKZs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 06:25:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758802AbZIPKZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 06:25:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:58471 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758674AbZIPKZl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 06:25:41 -0400
Date: Wed, 16 Sep 2009 10:25:21 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: x86: Name old_perf in a unique way
Message-ID: <tip-7c423e98856df9b941223a7e7845b2502ad84b00@git.kernel.org>
Git-Commit-ID: 7c423e98856df9b941223a7e7845b2502ad84b00
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 16 Sep 2009 10:25:21 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7c423e98856df9b941223a7e7845b2502ad84b00
Gitweb:     http://git.kernel.org/tip/7c423e98856df9b941223a7e7845b2502ad84b00
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 16 Sep 2009 09:38:24 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 16 Sep 2009 11:21:07 +0200

sched: x86: Name old_perf in a unique way

Silly percpu bits don't respect static..

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>


---
 arch/x86/kernel/cpu/sched.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/sched.c b/arch/x86/kernel/cpu/sched.c
index 6c00a8f..a640ae5 100644
--- a/arch/x86/kernel/cpu/sched.c
+++ b/arch/x86/kernel/cpu/sched.c
@@ -8,11 +8,11 @@
 
 #ifdef CONFIG_SMP
 
-static DEFINE_PER_CPU(struct aperfmperf, old_perf);
+static DEFINE_PER_CPU(struct aperfmperf, old_perf_sched);
 
 static unsigned long scale_aperfmperf(void)
 {
-	struct aperfmperf val, *old = &__get_cpu_var(old_perf);
+	struct aperfmperf val, *old = &__get_cpu_var(old_perf_sched);
 	unsigned long ratio, flags;
 
 	local_irq_save(flags);
