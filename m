Return-Path: <linux-kernel-owner+w=401wt.eu-S1756453AbZDNOL2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756453AbZDNOL2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 10:11:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756256AbZDNOLP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 10:11:15 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58836 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756369AbZDNOLO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 10:11:14 -0400
Date: Tue, 14 Apr 2009 16:11:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [GIT PULL] lockdep fix for sparc/s390 build breakage
Message-ID: <20090414141101.GA17768@elte.hu>
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

This fixes a Sparc and S390 build breakage i caused yesterday by 
pushing this commit too fast:

   9eeba61: lockdep: warn about lockdep disabling after kernel taint

Sorry about that.

 Thanks,

	Ingo

------------------>
Ingo Molnar (1):
      lockdep: warn about lockdep disabling after kernel taint, fix


 include/linux/debug_locks.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/debug_locks.h b/include/linux/debug_locks.h
index 493dedb..29b3ce3 100644
--- a/include/linux/debug_locks.h
+++ b/include/linux/debug_locks.h
@@ -3,6 +3,7 @@
 
 #include <linux/kernel.h>
 #include <asm/atomic.h>
+#include <asm/system.h>
 
 struct task_struct;
 
