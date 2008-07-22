Return-Path: <linux-kernel-owner+w=401wt.eu-S1755155AbYGVLiq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155AbYGVLiq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 07:38:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752051AbYGVLii
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 07:38:38 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45981 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751189AbYGVLii (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 07:38:38 -0400
Date: Tue, 22 Jul 2008 13:38:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] x86: more header fixes
Message-ID: <20080722113823.GA9351@elte.hu>
References: <20080716142225.GA19054@elte.hu> <20080722123231.GA13172@localhost.localdomain> <20080722103632.GA27029@elte.hu> <19f34abd0807220413sabb9f65h6ac20f98efb680bf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0807220413sabb9f65h6ac20f98efb680bf@mail.gmail.com>
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

> On Tue, Jul 22, 2008 at 12:36 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >> I've updated my script to also fix any rogue uses of header-guard
> >> names in auxiliary files. I'm attaching the resulting patch.
> >>
> >> It doesn't really _fix_ the hideous hack, it merely unbreaks it.
> >>
> >> Patch #2 also fixes some left-over headers. They both apply on top of
> >> tip/x86/header-guards.
> >
> > looks good - do you have a branch i could pull into
> > tip/x86/header-guards?
> 
> I've pushed it to the 'for-tip' branch of
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/vegard/linux-2.6-headers.git
> 
> (Note that since you rebased the same branch last time, I just applied 
> my patches on top of _your_ branch and pushed that to above location.)
> 
> Though I still believe it should be squashed for bisectability.

hm, i pulled it but 1ab9e368 cannot be squashed into aa27f9586 cleanly.

I'd suggest the following approach, which we used for the scripted 
unification of arch/x86. Do a couple of preparatory patches that just 
bring all the header guards into proper shape. _Then_ run the script 
against that "prepared" tree. The end result should be correct to the 
best of our current knowledge. (i'll figure out any remaining build 
breakages quickly - i can build 120+ random kernels per hour)

We can rebase x86/header-guards to such a bisectable approach no problem 
if you can do it like that, it's not yet merged anywhere. Just send me a 
pull URI that i'll pull into a x86/header-guards that is reset back to 
linus/master.

Can you see any complications with that approach?

	Ingo
