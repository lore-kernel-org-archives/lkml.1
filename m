Return-Path: <linux-kernel-owner+w=401wt.eu-S1757738AbZA3XKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757738AbZA3XKs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 18:10:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755318AbZA3XKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 18:10:40 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:33550 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752213AbZA3XKj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 18:10:39 -0500
Date: Sat, 31 Jan 2009 00:10:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [git pull] irq fixes
Message-ID: <20090130231032.GA11025@elte.hu>
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

Please pull the latest irq-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git irq-fixes-for-linus

 Thanks,

	Ingo

------------------>
Ingo Molnar (1):
      irq: export __set_irq_handler() and handle_level_irq()


 kernel/irq/chip.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index f63c706..7de11bd 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -383,6 +383,7 @@ handle_level_irq(unsigned int irq, struct irq_desc *desc)
 out_unlock:
 	spin_unlock(&desc->lock);
 }
+EXPORT_SYMBOL_GPL(handle_level_irq);
 
 /**
  *	handle_fasteoi_irq - irq handler for transparent controllers
@@ -593,6 +594,7 @@ __set_irq_handler(unsigned int irq, irq_flow_handler_t handle, int is_chained,
 	}
 	spin_unlock_irqrestore(&desc->lock, flags);
 }
+EXPORT_SYMBOL_GPL(__set_irq_handler);
 
 void
 set_irq_chip_and_handler(unsigned int irq, struct irq_chip *chip,
