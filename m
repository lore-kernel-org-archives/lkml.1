Return-Path: <linux-kernel-owner+w=401wt.eu-S1757905AbYGPNJB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757905AbYGPNJB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 09:09:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755390AbYGPNIx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 09:08:53 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43873 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755185AbYGPNIw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 09:08:52 -0400
Date: Wed, 16 Jul 2008 15:08:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] x86: more header fixes
Message-ID: <20080716130839.GA1296@elte.hu>
References: <20080610214544.GA14824@damson.getinternet.no> <20080618103006.GF15255@elte.hu> <19f34abd0806180919v5a8c21e7ua7e1f928d8a53ab4@mail.gmail.com> <20080626120202.GH29619@elte.hu> <19f34abd0806260953h504ff85dmf11a59171df3442b@mail.gmail.com> <20080701092820.GA31309@elte.hu> <20080716115137.GA8075@elte.hu> <19f34abd0807160550v68aacb58nbdd46b0fe74c4704@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0807160550v68aacb58nbdd46b0fe74c4704@mail.gmail.com>
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


* Vegard Nossum <vegard.nossum@gmail.com> wrote:

> On Wed, Jul 16, 2008 at 1:51 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Ingo Molnar <mingo@elte.hu> wrote:
> >
> >> * Vegard Nossum <vegard.nossum@gmail.com> wrote:
> >>
> >> > > or perhaps we could include it in tip/master right now as well, if
> >> > > you did another branch that excluded the files below. That would
> >> > > make merging a lot easier - and we could do a second phase in
> >> > > v2.6.27-rc1. Hm?
> >> >
> >> > I don't think we really need to resolve conflicts at all. What we
> >> > can do is simply to re-run the scripts against tip/master whenever
> >> > you want the update.
> >>
> >> ok, lets do it that way.
> >
> > ... the right moment for this would be about now. Mind rerunning your
> > scripts and create a pullable linux-2.6-headers tree, based on latest
> > -git?
> 
> Aright! Here she is; you may pull the 'for-tip' branch of
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/vegard/linux-2.6-headers.git
> for-tip
> 
> To see the result. This was based on tip/master. Shortlog:
>
> Vegard Nossum (3):
>       x86: consolidate header guards
>       kvm: fix spurious '#' in header
>       kvm: consolidate header guard

thanks. I've picked up these changes and rebased them to -git. (that way 
they can be maintained as a topic easier) The few files that were left 
out due to conflicts we can do later on. I pushed the result out into 
the tip/x86/header-guards topic branch - please double-check that i 
merged it right.

	Ingo
