Return-Path: <linux-kernel-owner+w=401wt.eu-S1753189AbXDQJxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189AbXDQJxa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 05:53:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753199AbXDQJxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 05:53:30 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39800 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753189AbXDQJx3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 05:53:29 -0400
Date: Tue, 17 Apr 2007 11:53:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Williams <pwil3058@bigpond.net.au>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: [patch] CFS (Completely Fair Scheduler), v2
Message-ID: <20070417095303.GA25553@elte.hu>
References: <20070416220715.GA4071@elte.hu> <46246D61.8010300@bigpond.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46246D61.8010300@bigpond.net.au>
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


* Peter Williams <pwil3058@bigpond.net.au> wrote:

> Have you considered using rq->raw_weighted_load instead of 
> rq->nr_running in calculating fair_clock?  This would take the nice 
> value (or RT priority) of the other tasks into account when 
> determining what's fair.
> 
> Peter

> PS You'd have to change the migration thread's load_weight from 0 to 1 
> in order to prevent divide by zero without having to explicitly check 
> for it every time.

yeah - nice idea, i'll try this.

	Ingo
