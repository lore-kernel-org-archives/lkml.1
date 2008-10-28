Return-Path: <linux-kernel-owner+w=401wt.eu-S1753434AbYJ1KwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753434AbYJ1KwV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 06:52:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752756AbYJ1KwN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 06:52:13 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43964 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752163AbYJ1KwN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 06:52:13 -0400
Date: Tue, 28 Oct 2008 11:51:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [git pull] irq updates
Message-ID: <20081028105154.GA26244@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0012]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest irq-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git irq-fixes-for-linus

 Thanks,

	Ingo

------------------>
roel kluin (1):
      irq: make variable static


 kernel/irq/proc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/irq/proc.c b/kernel/irq/proc.c
index fac014a..4d161c7 100644
--- a/kernel/irq/proc.c
+++ b/kernel/irq/proc.c
@@ -220,7 +220,7 @@ void unregister_handler_proc(unsigned int irq, struct irqaction *action)
 	}
 }
 
-void register_default_affinity_proc(void)
+static void register_default_affinity_proc(void)
 {
 #ifdef CONFIG_SMP
 	proc_create("irq/default_smp_affinity", 0600, NULL,
