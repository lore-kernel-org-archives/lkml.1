Return-Path: <linux-kernel-owner+w=401wt.eu-S1761384AbZE2RQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761384AbZE2RQr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 13:16:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756298AbZE2RQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 13:16:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:57516 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753629AbZE2RQg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 13:16:36 -0400
Date: Fri, 29 May 2009 17:15:57 GMT
From: tip-bot for GeunSik Lim <leemgs1@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, geunsik.lim@samsung.com, leemgs1@gmail.com,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, geunsik.lim@samsung.com, a.p.zijlstra@chello.nl,
       leemgs1@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:sched/core] sched: fix typo in sched-rt-group.txt file
Message-ID: <tip-f04d82b7e0c63d0251f9952a537a4bc4d73aa1a9@git.kernel.org>
Git-Commit-ID: f04d82b7e0c63d0251f9952a537a4bc4d73aa1a9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 29 May 2009 17:15:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f04d82b7e0c63d0251f9952a537a4bc4d73aa1a9
Gitweb:     http://git.kernel.org/tip/f04d82b7e0c63d0251f9952a537a4bc4d73aa1a9
Author:     GeunSik Lim <leemgs1@gmail.com>
AuthorDate: Thu, 28 May 2009 10:36:14 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 29 May 2009 16:21:09 +0200

sched: fix typo in sched-rt-group.txt file

Fix typo about static priority's range.

    Kernel Space                     User Space
    ===============================================================
      0(high) to  98(low)     user RT priority 99(high) to 1(low)
                              with SCHED_RR or SCHED_FIFO
    ---------------------------------------------------------------
     99                       sched_priority is not used in scheduling
                              decisions(it must be specified as 0)
    ---------------------------------------------------------------
    100(high) to 139(low)     user nice -20(high) to 19(low)
    ---------------------------------------------------------------
    140                       idle task priority
    ---------------------------------------------------------------
    * ref) http://www.kernel.org/doc/man-pages/online/pages/man2/sched_setscheduler.2.html

Signed-off-by: GeunSik Lim <geunsik.lim@samsung.com>
CC: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/scheduler/sched-rt-group.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/scheduler/sched-rt-group.txt b/Documentation/scheduler/sched-rt-group.txt
index eb74b01..1df7f9c 100644
--- a/Documentation/scheduler/sched-rt-group.txt
+++ b/Documentation/scheduler/sched-rt-group.txt
@@ -187,7 +187,7 @@ get their allocated time.
 
 Implementing SCHED_EDF might take a while to complete. Priority Inheritance is
 the biggest challenge as the current linux PI infrastructure is geared towards
-the limited static priority levels 0-139. With deadline scheduling you need to
+the limited static priority levels 0-99. With deadline scheduling you need to
 do deadline inheritance (since priority is inversely proportional to the
 deadline delta (deadline - now).
 
