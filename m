Return-Path: <linux-kernel-owner+w=401wt.eu-S1755529AbYHOKTt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529AbYHOKTt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 06:19:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752749AbYHOKTm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 06:19:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57906 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752331AbYHOKTl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 06:19:41 -0400
Date: Fri, 15 Aug 2008 12:19:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/07] dyn_array/nr_irqs/sparse_irq support v10 - fix
Message-ID: <20080815101927.GA4770@elte.hu>
References: <1218766832-20476-1-git-send-email-yhlu.kernel@gmail.com> <20080815082735.GC4776@elte.hu> <86802c440808150134x5bf005fmdcb0f557422af365@mail.gmail.com> <20080815085120.GA18748@elte.hu> <20080815093546.GA9312@elte.hu> <1218794430.10800.237.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1218794430.10800.237.camel@twins>
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Fri, 2008-08-15 at 11:35 +0200, Ingo Molnar wrote:
> 
> > looks wrong - it should be unconditional (i've done that via the patch 
> > below). I dont remember why we made early_init_irq_lock_class() 
> > dependent on CONFIG_TRACE_IRQFLAGS before. Peter, do you have any 
> > memories?
> 
> Nope, git suggests I poke you about it.. :-)

muhaha - i dont even know that guy who did this sloppy commit 2 years 
ago - "Ingo Molnar", or however he is called.

I believe my (mistaken) thinking would have been that desc->irq lockdep 
class does not matter as long as we dont do irq-tracing. Which might 
have been borderline correct then but is wrong now, for things like 
lockstat?

	Ingo
