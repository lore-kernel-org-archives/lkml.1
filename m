Return-Path: <linux-kernel-owner+w=401wt.eu-S1755657AbXD0L4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755657AbXD0L4Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 07:56:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755664AbXD0L4Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 07:56:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59063 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755657AbXD0L4X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 07:56:23 -0400
Date: Fri, 27 Apr 2007 13:55:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Kasper Sandberg <lkml@metanurb.dk>
Cc: Gene Heskett <gene.heskett@gmail.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Mark Lord <lkml@rtr.ca>,
       Zach Carter <linux@zachcarter.com>, buddabrod <buddabrod@gmail.com>
Subject: Re: [patch] CFS scheduler, -v6
Message-ID: <20070427115526.GA7699@elte.hu>
References: <20070425214704.GA32572@elte.hu> <1177596399.14496.1.camel@localhost> <200704261041.04838.gene.heskett@gmail.com> <1177618164.14496.5.camel@localhost> <20070427115344.GA30706@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070427115344.GA30706@elte.hu>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> update for lkml readers: this is some really 'catastrophic' condition 
> triggering on your box. Here ogg123 just never skips on an older 750 
> MHz box, which is 4-5 times slower than your 2GHz box - while i have 
> _fourty nice-0 infinite loops_ running. I.e. at this clearly 
> ridiculous load, at just 2.5% of CPU time ogg123 is just chugging 
> along nicely and never leaves out a beat.

Kasper, just to exclude the possibility that this is somehow related to 
IO scheduling, could you copy the OGG file over to /dev/shm and play it 
from there? Do you still get the bad skips?

	Ingo
