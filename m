Return-Path: <linux-kernel-owner+w=401wt.eu-S1759248AbYGAOrf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759248AbYGAOrf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 10:47:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754260AbYGAOr1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 10:47:27 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38717 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753749AbYGAOr0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 10:47:26 -0400
Date: Tue, 1 Jul 2008 16:46:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Greg KH <greg@kroah.com>
Cc: Roland McGrath <roland@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       TAKADA Yoshihito <takada@mbf.nifty.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [stable] [PATCH] x86 ptrace: fix PTRACE_GETFPXREGS error
Message-ID: <20080701144658.GA18522@elte.hu>
References: <20080630.134445.193700135.takada@mbf.nifty.com> <20080630210241.93738154077@magilla.localdomain> <20080701090204.GA1729@elte.hu> <20080701093212.6D9DA15420E@magilla.localdomain> <20080701101104.GF31309@elte.hu> <20080701143418.GA30693@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080701143418.GA30693@kroah.com>
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


* Greg KH <greg@kroah.com> wrote:

> On Tue, Jul 01, 2008 at 12:11:04PM +0200, Ingo Molnar wrote:
> > 
> > * Roland McGrath <roland@redhat.com> wrote:
> > 
> > > > since the original fix is already upstream, i've applied the delta 
> > > > patch below. Should we still do this for v2.6.26 or can we defer it 
> > > > to v2.6.27? As ptrace is the only user of this facility for now this 
> > > > would be an identity transformation AFAICS and the v2.6.26 release 
> > > > is very close.
> > > 
> > > I don't think there's a problem with 2.6.26 either way.  I agree that 
> > > the user_regset internal API does not matter much before 2.6.27.
> > 
> > okay - i've queued it up in tip/x86/ptrace for now.
> > 
> > > My patch alone applies to 2.6.25, which is why I CC'd it to stable. I 
> > > think applying that (and not takada's patch) to stable-2.6.25 would be 
> > > best.
> > 
> > i think Greg already queued the original fix up for v2.6.25, as per the 
> > commit notifier below.
> 
> Yes I did queue that one up, but it looks different from Roland's 
> original patch in this thread.

yes, but as discussed in this thread, both patches are fine in principle 
as far as the regression goes.

	Ingo
