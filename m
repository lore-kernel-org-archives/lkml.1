Return-Path: <linux-kernel-owner+w=401wt.eu-S1758769AbYHVM0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758769AbYHVM0r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 08:26:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753930AbYHVM0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 08:26:38 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40511 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753780AbYHVM0h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 08:26:37 -0400
Date: Fri, 22 Aug 2008 14:26:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [git pull] core fixes
Message-ID: <20080822122620.GA4953@elte.hu>
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
Randy Dunlap (1):
      rcu: fix synchronize_rcu() so that kernel-doc works


 kernel/rcupdate.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index f14f372..467d594 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -77,6 +77,7 @@ void wakeme_after_rcu(struct rcu_head  *head)
  * sections are delimited by rcu_read_lock() and rcu_read_unlock(),
  * and may be nested.
  */
+void synchronize_rcu(void);	/* Makes kernel-doc tools happy */
 synchronize_rcu_xxx(synchronize_rcu, call_rcu)
 EXPORT_SYMBOL_GPL(synchronize_rcu);
 
