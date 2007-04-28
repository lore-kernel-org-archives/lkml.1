Return-Path: <linux-kernel-owner+w=401wt.eu-S1751076AbXD1Nz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751076AbXD1Nz0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 09:55:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751878AbXD1Nz0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 09:55:26 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59461 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751076AbXD1Nyo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 09:54:44 -0400
Date: Sat, 28 Apr 2007 15:53:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       Mark Lord <lkml@rtr.ca>, Zach Carter <linux@zachcarter.com>,
       buddabrod <buddabrod@gmail.com>
Subject: Re: [patch] CFS scheduler, -v6
Message-ID: <20070428135338.GA8207@elte.hu>
References: <20070425214704.GA32572@elte.hu> <20070428124516.GA27292@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070428124516.GA27292@in.ibm.com>
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


* Srivatsa Vaddagiri <vatsa@in.ibm.com> wrote:

> On Wed, Apr 25, 2007 at 11:47:04PM +0200, Ingo Molnar wrote:
> > The CFS patch against v2.6.21-rc7 or against v2.6.20.7 can be downloaded 
> > from the usual place:
> > 
> >     http://redhat.com/~mingo/cfs-scheduler/
> 
> +static inline struct rb_node * first_fair(struct rq *rq)
> +{
> +	if (rq->rb_leftmost)
> +		return rq->rb_leftmost;
> +	return rb_first(&rq->tasks_timeline);
> +}
> 
> Won't it help if you update rq->rb_leftmost above from the value 
> returned by rb_first(), so that subsequent calls to first_fair will be 
> sped up?

yeah, indeed. Would you like to do a patch for that?

	Ingo
