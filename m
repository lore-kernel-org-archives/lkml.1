Return-Path: <linux-kernel-owner+w=401wt.eu-S1752541AbYK2Tgj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541AbYK2Tgj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 14:36:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754327AbYK2Tg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 14:36:28 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46464 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754323AbYK2Tg1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 14:36:27 -0500
Date: Sat, 29 Nov 2008 20:36:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [git pull] core kernel fixes
Message-ID: <20081129193621.GA26248@elte.hu>
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

 Thanks,

	Ingo

------------------>
Li Zefan (1):
      lockdep: consistent alignement for lockdep info


 kernel/lockdep.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 06e1571..46a4041 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -3276,10 +3276,10 @@ void __init lockdep_info(void)
 {
 	printk("Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar\n");
 
-	printk("... MAX_LOCKDEP_SUBCLASSES:    %lu\n", MAX_LOCKDEP_SUBCLASSES);
+	printk("... MAX_LOCKDEP_SUBCLASSES:  %lu\n", MAX_LOCKDEP_SUBCLASSES);
 	printk("... MAX_LOCK_DEPTH:          %lu\n", MAX_LOCK_DEPTH);
 	printk("... MAX_LOCKDEP_KEYS:        %lu\n", MAX_LOCKDEP_KEYS);
-	printk("... CLASSHASH_SIZE:           %lu\n", CLASSHASH_SIZE);
+	printk("... CLASSHASH_SIZE:          %lu\n", CLASSHASH_SIZE);
 	printk("... MAX_LOCKDEP_ENTRIES:     %lu\n", MAX_LOCKDEP_ENTRIES);
 	printk("... MAX_LOCKDEP_CHAINS:      %lu\n", MAX_LOCKDEP_CHAINS);
 	printk("... CHAINHASH_SIZE:          %lu\n", CHAINHASH_SIZE);
