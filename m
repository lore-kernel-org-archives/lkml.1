Return-Path: <linux-kernel-owner+w=401wt.eu-S1754051Ab0AaRhd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051Ab0AaRhd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 12:37:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753616Ab0AaRhc
	(ORCPT <rfc822;linux-kernel-outgoing-6734>);
	Sun, 31 Jan 2010 12:37:32 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58761 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753166Ab0AaRhc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 12:37:32 -0500
Date: Sun, 31 Jan 2010 18:37:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] lockdep fix
Message-ID: <20100131173721.GA7781@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-fixes-for-linus

 Thanks,

	Ingo

------------------>
Oleg Nesterov (1):
      lockdep: Fix check_usage_backwards() error message


 kernel/lockdep.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 5feaddc..c62ec14 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -2147,7 +2147,7 @@ check_usage_backwards(struct task_struct *curr, struct held_lock *this,
 		return ret;
 
 	return print_irq_inversion_bug(curr, &root, target_entry,
-					this, 1, irqclass);
+					this, 0, irqclass);
 }
 
 void print_irqtrace_events(struct task_struct *curr)
