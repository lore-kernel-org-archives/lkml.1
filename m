Return-Path: <linux-kernel-owner+w=401wt.eu-S1755840AbZIKSfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755840AbZIKSfu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 14:35:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755766AbZIKSft
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 14:35:49 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57785 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754380AbZIKSfs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 14:35:48 -0400
Date: Fri, 11 Sep 2009 20:35:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] core/cleanups for v2.6.32
Message-ID: <20090911183547.GA28152@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the core-cleanups-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-cleanups-for-linus

 Thanks,

	Ingo

------------------>
Bart Van Assche (1):
      workqueues: Improve schedule_work() documentation


 kernel/workqueue.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 0668795..3c44b56 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -600,7 +600,12 @@ static struct workqueue_struct *keventd_wq __read_mostly;
  * schedule_work - put work task in global workqueue
  * @work: job to be done
  *
- * This puts a job in the kernel-global workqueue.
+ * Returns zero if @work was already on the kernel-global workqueue and
+ * non-zero otherwise.
+ *
+ * This puts a job in the kernel-global workqueue if it was not already
+ * queued and leaves it in the same position on the kernel-global
+ * workqueue otherwise.
  */
 int schedule_work(struct work_struct *work)
 {
