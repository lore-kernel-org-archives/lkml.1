Return-Path: <linux-kernel-owner+w=401wt.eu-S1754793AbYHNN5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793AbYHNN5b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 09:57:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751152AbYHNN5Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 09:57:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36807 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751087AbYHNN5X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 09:57:23 -0400
Date: Thu, 14 Aug 2008 15:57:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] irq: sparse irqs, export nr_irqs
Message-ID: <20080814135700.GA19419@elte.hu>
References: <1218705441-21838-1-git-send-email-yhlu.kernel@gmail.com> <20080814132638.GA18743@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080814132638.GA18743@elte.hu>
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


>From c239ac14984518f2f3b7a920367c79bb6c3180e4 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Thu, 14 Aug 2008 15:58:26 +0200
Subject: [PATCH] irq: sparse irqs, export nr_irqs

fix:

  Building modules, stage 2.
  MODPOST 458 modules
  ERROR: "nr_irqs" [drivers/serial/8250.ko] undefined!

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/irq/handle.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index aa889c1..ce8774b 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -56,6 +56,7 @@ handle_bad_irq(unsigned int irq, struct irq_desc *desc)
  * Controller mappings for all interrupt sources:
  */
 int nr_irqs = NR_IRQS;
+EXPORT_SYMBOL_GPL(nr_irqs);
 
 #ifdef CONFIG_HAVE_DYN_ARRAY
 static struct irq_desc irq_desc_init = {
