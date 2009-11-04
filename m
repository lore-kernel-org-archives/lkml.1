Return-Path: <linux-kernel-owner+w=401wt.eu-S1755483AbZKDLK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483AbZKDLK5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 06:10:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755430AbZKDLK4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 06:10:56 -0500
Received: from hera.kernel.org ([140.211.167.34]:39758 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755441AbZKDLKy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 06:10:54 -0500
Date: Wed, 4 Nov 2009 11:10:26 GMT
From: tip-bot for Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: linux-kernel@vger.kernel.org, h-shimamoto@ct.jp.nec.com, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, h-shimamoto@ct.jp.nec.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4AF12A3A.5050200@ct.jp.nec.com>
References: <4AF12A3A.5050200@ct.jp.nec.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Remove unused time_sync_thresh declaration
Message-ID: <tip-2a2bb3142d326bb28b03875cabfc49baaac9a14a@git.kernel.org>
Git-Commit-ID: 2a2bb3142d326bb28b03875cabfc49baaac9a14a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2a2bb3142d326bb28b03875cabfc49baaac9a14a
Gitweb:     http://git.kernel.org/tip/2a2bb3142d326bb28b03875cabfc49baaac9a14a
Author:     Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
AuthorDate: Wed, 4 Nov 2009 16:16:10 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 4 Nov 2009 11:43:42 +0100

sched: Remove unused time_sync_thresh declaration

time_sync_thresh had been removed.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <4AF12A3A.5050200@ct.jp.nec.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/sched.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index f18102c..754b3de 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -171,8 +171,6 @@ print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 }
 #endif
 
-extern unsigned long long time_sync_thresh;
-
 /*
  * Task state bitmask. NOTE! These bits are also
  * encoded in fs/proc/array.c: get_task_state().
