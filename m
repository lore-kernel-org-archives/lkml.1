Return-Path: <linux-kernel-owner+w=401wt.eu-S1754747AbZJETku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747AbZJETku (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 15:40:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754717AbZJETkt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 15:40:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:35437 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754716AbZJETks (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 15:40:48 -0400
Date: Mon, 5 Oct 2009 19:39:41 GMT
From: "tip-bot for Jayson R. King" <dev@jaysonking.com>
Cc: linux-kernel@vger.kernel.org, dev@jaysonking.com, hpa@zytor.com,
       mingo@redhat.com, trivial@kernel.org, peterz@infradead.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, dev@jaysonking.com,
       linux-kernel@vger.kernel.org, trivial@kernel.org, peterz@infradead.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4AC9C8A6.6010209@jaysonking.com>
References: <4AC9C8A6.6010209@jaysonking.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Remove obsolete comment in sched_init()
Message-ID: <tip-cf82ff7ea7695b0e82ba07bc5e9f1bd03a74e1aa@git.kernel.org>
Git-Commit-ID: cf82ff7ea7695b0e82ba07bc5e9f1bd03a74e1aa
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 05 Oct 2009 19:39:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cf82ff7ea7695b0e82ba07bc5e9f1bd03a74e1aa
Gitweb:     http://git.kernel.org/tip/cf82ff7ea7695b0e82ba07bc5e9f1bd03a74e1aa
Author:     Jayson R. King <dev@jaysonking.com>
AuthorDate: Mon, 5 Oct 2009 05:21:26 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 5 Oct 2009 21:37:22 +0200

sched: Remove obsolete comment in sched_init()

Remove the comment about calling alloc_bootmem() as it is not
called here since commit 36b7b6d465489c4754c4fd66fcec6086eba87896.

Signed-off-by: Jayson R. King <dev@jaysonking.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Kosina <trivial@kernel.org>
LKML-Reference: <4AC9C8A6.6010209@jaysonking.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 830967e..a56446d 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -9322,10 +9322,6 @@ void __init sched_init(void)
 #ifdef CONFIG_CPUMASK_OFFSTACK
 	alloc_size += num_possible_cpus() * cpumask_size();
 #endif
-	/*
-	 * As sched_init() is called before page_alloc is setup,
-	 * we use alloc_bootmem().
-	 */
 	if (alloc_size) {
 		ptr = (unsigned long)kzalloc(alloc_size, GFP_NOWAIT);
 
