Return-Path: <linux-kernel-owner+w=401wt.eu-S1753567AbXCPQnQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567AbXCPQnQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 12:43:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965585AbXCPQnQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 12:43:16 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3729 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753574AbXCPQnP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 12:43:15 -0400
Date: Fri, 16 Mar 2007 16:42:45 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Con Kolivas <kernel@kolivas.org>
Cc: Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH][RSDL-mm 0/7] RSDL cpu scheduler for 2.6.21-rc3-mm2
Message-ID: <20070316164245.GC3951@ucw.cz>
References: <200703111457.17624.kernel@kolivas.org> <200703130549.47058.kernel@kolivas.org> <1173730314.6431.30.camel@Homer.simpson.net> <200703130738.19034.kernel@kolivas.org> <1173732344.6431.54.camel@Homer.simpson.net> <8cd998d50703121551u44ea3d85g2541503373f461f4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8cd998d50703121551u44ea3d85g2541503373f461f4@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >> > Killing the known corner case starvation scenarios 
> >is wonderful, but
> >> > let's not just pretend that interactive tasks don't 
> >have any special
> >> > requirements.
> >>
> >> Now you're really making a stretch of things. Where 
> >on earth did I say that
> >> interactive tasks don't have special requirements? 
> >It's a fundamental feature
> >> of this scheduler that I go to great pains to get 
> >them as low latency as
> >> possible and their fair share of cpu despite having a 
> >completely fair cpu
> >> distribution.
> >
> >As soon as your cpu is fully utilized, fairness looses 
> >or interactivity
> >loses.  Pick one.
> 
> That's not true unless you refuse to prioritise your 
> tasks
> accordingly. Let's take this discussion in a different 
> direction. You
> already nice your lame processes. Why? You already have 
> the concept
> that you are prioritising things to normal or background 
> tasks. You
> say so yourself that lame is a background task. Stating 
> the bleedingly
> obvious, the unix way of prioritising things is via 
> nice. You already
> do that. So moving on from that...
> 
> Your test case you ask "how can I maximise cpu usage". 
> Well you know
> the answer already. You run two threads. I won't dispute 
> that.
> 
> The debate seems to be centered on whether two tasks 
> that are niced +5
> or to a higher value is background. In my opinion, nice 
> 5 is not
> background, but relatively less cpu. You already are 
> savvy enough to
> be using two threads and nicing them. All I ask you to 
> do when using
> RSDL is to change your expectations slightly and your 
> settings from
> nice 5 to nice 10 or 15 or even 19. Why is that so 
> offensive to you?
> nice 5 is 75% the cpu of nice 0. nice 10 is 50%, nice 15 
> is 25%, nice

Hmm, I'd certainly expect nice to be stronger. nice 5 should be 50% or
less of nice 0... You'll not even notice nice 2 if that is 90%...

And I guess it nicely solves problem in this thread, too...
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
