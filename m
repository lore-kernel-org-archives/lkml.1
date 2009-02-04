Return-Path: <linux-kernel-owner+w=401wt.eu-S1759400AbZBDTTX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759400AbZBDTTX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 14:19:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751761AbZBDTTH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 14:19:07 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41717 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751721AbZBDTTG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 14:19:06 -0500
Date: Wed, 4 Feb 2009 20:18:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [git pull] scheduler fix
Message-ID: <20090204191855.GA15973@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-fixes-for-linus

 Thanks,

	Ingo

------------------>
Randy Dunlap (1):
      sched: add missing kernel-doc in sched.h


 include/linux/sched.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 5a7c763..2127e95 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -443,6 +443,7 @@ struct pacct_struct {
  * @utime:		time spent in user mode, in &cputime_t units
  * @stime:		time spent in kernel mode, in &cputime_t units
  * @sum_exec_runtime:	total time spent on the CPU, in nanoseconds
+ * @lock:		lock for fields in this struct
  *
  * This structure groups together three kinds of CPU time that are
  * tracked for threads and thread groups.  Most things considering
