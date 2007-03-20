Return-Path: <linux-kernel-owner+w=401wt.eu-S1750894AbXCTDMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750894AbXCTDMb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 23:12:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932890AbXCTDMb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 23:12:31 -0400
Received: from smtp.osdl.org ([65.172.181.24]:43021 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750894AbXCTDMa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 23:12:30 -0400
Date: Mon, 19 Mar 2007 20:11:55 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Xavier Bestel <xavier.bestel@free.fr>
cc: Mark Lord <lkml@rtr.ca>, Al Boldi <a1426z@gawab.com>,
       Mike Galbraith <efault@gmx.de>, Con Kolivas <kernel@kolivas.org>,
       ck@vds.kolivas.org, Serge Belyshev <belyshev@depni.sinp.msu.ru>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Nicholas Miell <nmiell@comcast.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: RSDL v0.31
In-Reply-To: <1174322580.30876.72.camel@frg-rhel40-em64t-04>
Message-ID: <Pine.LNX.4.64.0703192006130.6730@woody.linux-foundation.org>
References: <200703042335.26785.a1426z@gawab.com>  <200703172048.46267.kernel@kolivas.org>
  <1174125534.7734.2.camel@Homer.simpson.net>  <200703172355.30989.a1426z@gawab.com>
  <45FEB54A.3040602@rtr.ca>  <1174321617.30876.69.camel@frg-rhel40-em64t-04>
  <45FEBBF5.9060002@rtr.ca> <1174322580.30876.72.camel@frg-rhel40-em64t-04>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 19 Mar 2007, Xavier Bestel wrote:
> > >> Stock scheduler wins easily, no contest.
> > > 
> > > What happens when you renice X ?
> > 
> > Dunno -- not necessary with the stock scheduler.
> 
> Could you try something like renice -10 $(pidof Xorg) ?

Could you try something as simple and accepting that maybe this is a 
problem?

Quite frankly, I was *planning* on merging RSDL very early after 2.6.21, 
but there is one thing that has turned me completely off the whole thing:

 - the people involved seem to be totally unwilling to even admit there 
   might be a problem.

This is like alcoholism. If you cannot admit that you might have a 
problem, you'll never get anywhere. And quite frankly, the RSDL proponents 
seem to be in denial ("we're always better", "it's your problem if the old 
scheduler works better", "just one report of old scheduler being better").

And the thing is, if people aren't even _willing_ to admit that there may 
be issues, there's *no*way*in*hell* I will merge it even for testing. 
Because the whole and only point of merging RSDL was to see if it could 
replace the old scheduler, and the most important feature in that case is 
not whether it is perfect, BUT WHETHER ANYBODY IS INTERESTED IN TRYING TO 
FIX THE INEVITABLE PROBLEMS!

See?

Can you people not see that the way you're doing that "RSDL is perfect" 
chorus in the face of people who report problems, you're just making it 
totally unrealistic that it will *ever* get merged.

So unless somebody steps up to the plate and actually *talks* about the 
problem reports, and admits that maybe RSDL will need some tweaking, I'm 
not going to merge it.

Because there is just _one_ thing that is more important than code - and 
that is the willingness to fix the code...

		Linus
