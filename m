Return-Path: <linux-kernel-owner+w=401wt.eu-S1758241AbYBRCgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758241AbYBRCgW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 21:36:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757126AbYBRCgB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 21:36:01 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47144 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753533AbYBRCgA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 21:36:00 -0500
Date: Mon, 18 Feb 2008 03:35:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH x86] i8259A_32: Remove redundant irq_desc[NR_IRQ]
	initialization
Message-ID: <20080218023542.GA30201@elte.hu>
References: <20080217225954.GA3020@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080217225954.GA3020@ubuntu>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Ahmed S. Darwish <darwish.07@gmail.com> wrote:

> Remove redundant irq_desc[NR_IRQS] element initialization in 
> init_ISA_irqs(). irq_desc[NR_IRQS] is already statically initialized 
> with the same values in kernel/irq/handle.c .

nice catch - applied. This also saves a few bytes of image space:

   text    data     bss     dec     hex filename
   1389     356      14    1759     6df i8259_32.o.before
   1325     356      14    1695     69f i8259_32.o.after

	Ingo
