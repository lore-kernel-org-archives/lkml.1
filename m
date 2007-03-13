Return-Path: <linux-kernel-owner+w=401wt.eu-S1753120AbXCMFKv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120AbXCMFKv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 01:10:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753129AbXCMFKu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 01:10:50 -0400
Received: from mail.gmx.net ([213.165.64.20]:48647 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753120AbXCMFKt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 01:10:49 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18GPK9TF2AGgMuQ+SbNwH1xGlCBNKH1ol2v7cYQye
	M0eI7z3krSmfOZ
Subject: Re: [PATCH][RSDL-mm 0/7] RSDL cpu scheduler for 2.6.21-rc3-mm2
From: Mike Galbraith <efault@gmx.de>
To: Con Kolivas <kernel@kolivas.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <8cd998d50703121551u44ea3d85g2541503373f461f4@mail.gmail.com>
References: <200703111457.17624.kernel@kolivas.org>
	 <200703130549.47058.kernel@kolivas.org>
	 <1173730314.6431.30.camel@Homer.simpson.net>
	 <200703130738.19034.kernel@kolivas.org>
	 <1173732344.6431.54.camel@Homer.simpson.net>
	 <8cd998d50703121551u44ea3d85g2541503373f461f4@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 13 Mar 2007 06:10:39 +0100
Message-Id: <1173762639.7944.45.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-13 at 09:51 +1100, Con Kolivas wrote:
> On 13/03/07, Mike Galbraith <efault@gmx.de> wrote:

> > As soon as your cpu is fully utilized, fairness looses or interactivity
> > loses.  Pick one.
> 
> That's not true unless you refuse to prioritise your tasks
> accordingly. Let's take this discussion in a different direction. You
> already nice your lame processes. Why? You already have the concept
> that you are prioritising things to normal or background tasks. You
> say so yourself that lame is a background task. Stating the bleedingly
> obvious, the unix way of prioritising things is via nice. You already
> do that. So moving on from that...

Sure.  If a user wants to do anything interactive, they can indeed nice
19 the rest of their box before they start.

> Your test case you ask "how can I maximise cpu usage". Well you know
> the answer already. You run two threads. I won't dispute that.
> 
> The debate seems to be centered on whether two tasks that are niced +5
> or to a higher value is background. In my opinion, nice 5 is not
> background, but relatively less cpu. You already are savvy enough to
> be using two threads and nicing them. All I ask you to do when using
> RSDL is to change your expectations slightly and your settings from
> nice 5 to nice 10 or 15 or even 19. Why is that so offensive to you?

It's not "offensive" to me, it is a behavioral regression.  The
situation as we speak is that you can run cpu intensive tasks while
watching eye-candy.  With RSDL, you can't, you feel the non-interactive
load instantly.  Doesn't the fact that you're asking me to lower my
expectations tell you that I just might have a point?

> Please don't pick 5.none of the above. Please try to work with me on this.

I'm not trying to be pig-headed.  I'm of the opinion that fairness is
great... until you strictly enforce it wrt interactive tasks.  

	-Mike

