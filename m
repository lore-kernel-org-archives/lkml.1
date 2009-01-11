Return-Path: <linux-kernel-owner+w=401wt.eu-S1755435AbZAKEFv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435AbZAKEFv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 23:05:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752295AbZAKEFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 23:05:43 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:57127 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751651AbZAKEFn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 23:05:43 -0500
Date: Sun, 11 Jan 2009 05:05:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Matt Mackall <mpm@selenic.com>, Yinghai Lu <yinghai@kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sparseirq: make some func to be used with genirq
Message-ID: <20090111040513.GF28520@elte.hu>
References: <496534B1.6080902@kernel.org> <20090108120619.GF1539@elte.hu> <1231435078.3178.278.camel@calx> <20090111034646.GA28520@elte.hu> <49696E92.6010804@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49696E92.6010804@sgi.com>
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


* Mike Travis <travis@sgi.com> wrote:

> Ingo Molnar wrote:
> > * Matt Mackall <mpm@selenic.com> wrote:
> > 
> >> On Thu, 2009-01-08 at 13:06 +0100, Ingo Molnar wrote:
> >>> (Matt Cc:-ed)
> >>>
> >>> Matt, does this look good to you? The point of this cleanup would be to 
> >>> make desc->timer_rand_state depend on hardirq (the presence of irq_desc[]) 
> >>> - not sparseirq (which does not make much sense).
> >> Seems fine.
> >>
> >> Signed-off-by: Matt Mackall <mpm@selenic.com>
> > 
> > applied it to tip/irq/urgent, thanks guys!
> > 
> > 	Ingo
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 
> This will conflict with the change of kstat_irqs from unsigned int to 
> unsigned long.
> 
> If you do your magic on tip/cpus4096, I will git-remote update my tree 
> and make the conflict go away...

you can defer the change to unsigned long to a later stage, when these 
have hit upstream. (in a few days)

	Ingo
