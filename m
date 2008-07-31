Return-Path: <linux-kernel-owner+w=401wt.eu-S1758928AbYGaVpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758928AbYGaVpo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 17:45:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758501AbYGaVpS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 17:45:18 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45888 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757594AbYGaVpQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 17:45:16 -0400
Date: Thu, 31 Jul 2008 23:45:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [git pull] core fixlet
Message-ID: <20080731214505.GA22980@elte.hu>
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

Please pull the latest core-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-fixes-for-linus

(the drivers/base/class.c bit has an ack from Greg.)

Thanks,

	Ingo

------------------>
Randy Dunlap (1):
      locking: fix mutex @key parameter kernel-doc notation


 drivers/base/class.c |    1 +
 kernel/mutex.c       |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/base/class.c b/drivers/base/class.c
index 839d27c..5667c2f 100644
--- a/drivers/base/class.c
+++ b/drivers/base/class.c
@@ -198,6 +198,7 @@ static void class_create_release(struct class *cls)
  * class_create - create a struct class structure
  * @owner: pointer to the module that is to "own" this struct class
  * @name: pointer to a string for the name of this class.
+ * @key: the lock_class_key for this class; used by mutex lock debugging
  *
  * This is used to create a struct class pointer that can then be used
  * in calls to device_create().
diff --git a/kernel/mutex.c b/kernel/mutex.c
index bcdc9ac..12c779d 100644
--- a/kernel/mutex.c
+++ b/kernel/mutex.c
@@ -34,6 +34,7 @@
 /***
  * mutex_init - initialize the mutex
  * @lock: the mutex to be initialized
+ * @key: the lock_class_key for the class; used by mutex lock debugging
  *
  * Initialize the mutex to unlocked state.
  *
