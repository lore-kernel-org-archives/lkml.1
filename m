Return-Path: <linux-kernel-owner+w=401wt.eu-S1756654AbYLKNsk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654AbYLKNsk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 08:48:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755455AbYLKNsc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 08:48:32 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42104 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755438AbYLKNsb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 08:48:31 -0500
Date: Thu, 11 Dec 2008 14:48:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.28-rc8
Message-ID: <20081211134825.GA26448@elte.hu>
References: <alpine.LFD.2.00.0812101651130.3340@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0812101651130.3340@localhost.localdomain>
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

> Nothing overly exciting here. Lots of small things, mostly in drivers 
> (with some defconfig updates for m68k and mips making the diffs 
> bigger).
> 
> There's some uncomfortably big changes to the intel DRI code, but most 
> of that is all about fixes to the new i916 "GEM" code that is only used 
> by development X servers, and is a new feature, so it shouldn't be able 
> to cause regressions.
> 
> Perhaps more interesting is simply the release scheduling issue. I'm 
> getting slowly ready to do a real 2.6.28, but I don't think anybody 
> really wants the merge window to be around the holidays. So the 
> question is really whether to
> 
>  (a) just make the -rc's go on a few more weeks, and do 2.6.28 after xmas
> 
>      I like this, because alledgely people are debugging things, and we'd 
>      get a more stable 2.6.28.

i'd really vote for a) because there's nothing worse to overlap xmas with 
than with merge window stress. A couple of key developers wont be around 
either in that timeframe (whose stuff is pending) - making early reaction 
to breakage in the merge window rather laggy and awkward.

A Dec 31 release would be perfect [ 84 days will have passed by then 
since v2.6.27 which was released on Oct 9 ] and we would start 2009 
exactly on point on the planned 3-months / 90 days schedule.

Here's our release cycle track record, and how much it deviates from the 
max-90-days target:

   2.6.28:  64 days [today]
  on 31th:  84 days         -6 days

   2.6.27:  88              -2 days
   2.6.26:  87              -3 days
   2.6.25:  83              -7 days
   2.6.24:  107            +17 days
   2.6.23:  92              +2 days
   2.6.22:  73             -17 days
   2.6.21:  80             -10 days
   2.6.20:  66             -26 days
   2.6.19:  70             -20 days
   2.6.18:  94              +4 days
   2.6.17:  89              -1 day
   2.6.16:  76             -14 days
   2.6.15:  67             -23 days
   2.6.14:  60             -30 days
   2.6.13:  72             -18 days

We lost two and a half weeks with 2.6.24 that was released belatedly on 
Jan 24 - we've made up all the ground for that already.

And the killer argument: there's nothing better to mask a nasty Jan 1 
hangover with than with some merge window stress ;-)

	Ingo
