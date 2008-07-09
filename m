Return-Path: <linux-kernel-owner+w=401wt.eu-S1755642AbYGINDd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642AbYGINDd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 09:03:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751930AbYGINDY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 09:03:24 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37729 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751889AbYGINDY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 09:03:24 -0400
Date: Wed, 9 Jul 2008 15:03:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Vitaly Mayatskikh <v.mayatskih@gmail.com>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] Introduce copy_user_handle_tail routine
Message-ID: <20080709130305.GB20768@elte.hu>
References: <m37icazgt0.fsf@gravicappa.englab.brq.redhat.com> <alpine.LFD.1.10.0806281108240.4371@hp.linux-foundation.org> <m3lk0ngdo5.fsf@gravicappa.englab.brq.redhat.com> <alpine.LFD.1.10.0806300835220.28533@hp.linux-foundation.org> <m3fxqsjt22.fsf_-_@gravicappa.englab.brq.redhat.com> <486B8B6C.2050109@firstfloor.org> <m37ic4jr2w.fsf@gravicappa.englab.brq.redhat.com> <alpine.LFD.1.10.0807021930470.18105@woody.linux-foundation.org> <m34p71yjyx.fsf@gravicappa.englab.brq.redhat.com> <alpine.LFD.1.10.0807070901490.11076@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0807070901490.11076@woody.linux-foundation.org>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Mon, 7 Jul 2008, Vitaly Mayatskikh wrote:
> 
> > Linus Torvalds <torvalds@linux-foundation.org> writes:
> > 
> > > Now, the stuff that comes *before* that point is the "try to fix up one 
> > > byte at a time" thing, which I'd like to be simple and dumb. At least to 
> > > start with.
> > 
> > Just to be clear: do these patches are good enough now (to start 
> > with)? Or, may be, it needs to be further improved?
> 
> I think they are getting there. I'm obviously not merging them in 
> 2.6.26, but I'd be happy to do so for .27.
> 
> Obviously, I'd be even happier if it also went through the normal x86 
> review cycles (ie Ingo &co), but the current series is largely ack'ed 
> by me.

applied them to tip/x86/core, for v2.6.27 merging, thanks everyone.

I've added Linus's Acked-by. Vitaly, could you please send your 
Signed-off-by line, it was missing from the patches. You can check the 
current form of the commits via:

 git-pull git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86/core

(the patches changed slightly, there was some merge fallout due to other 
changes in this area.)

	Ingo
