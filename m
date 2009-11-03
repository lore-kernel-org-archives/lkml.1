Return-Path: <linux-kernel-owner+w=401wt.eu-S1753989AbZKCQtt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989AbZKCQtt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 11:49:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752898AbZKCQtt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 11:49:49 -0500
Received: from senator.holtmann.net ([87.106.208.187]:47713 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841AbZKCQts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 11:49:48 -0500
Subject: Re: Please consider reverting
 7d930bc33653d5592dc386a76a38f39c2e962344
From: Marcel Holtmann <marcel@holtmann.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       David Miller <davem@davemloft.net>, johannes@sipsolutions.net,
       linville@tuxdriver.com, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org
In-Reply-To: <20091103162955.GA4836@elte.hu>
References: <20091103053156.GA3212@core.coreip.homeip.net>
	 <20091102.224957.32364226.davem@davemloft.net>
	 <20091103065238.GE3212@core.coreip.homeip.net>
	 <1257232587.3420.55.camel@localhost.localdomain>
	 <alpine.LFD.2.01.0911030719430.31845@localhost.localdomain>
	 <1257262588.3420.79.camel@localhost.localdomain>
	 <alpine.LFD.2.01.0911030738260.31845@localhost.localdomain>
	 <1257264485.3420.87.camel@localhost.localdomain>
	 <20091103162955.GA4836@elte.hu>
Content-Type: text/plain
Date: Wed, 04 Nov 2009 01:49:44 +0900
Message-Id: <1257266984.3420.111.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

> > > > no questions that it needs fixed, I agree with you. However just blindly
> > > > reverting something, because it fixes it for one or two people, might
> > > > have side effects that causes more problems than the revert would
> > > > actually fix.
> > > 
> > > Stop whining. Really.
> > > 
> > > Everybody understands that it should be fixed.  That's not the question.
> > > 
> > > But it should be fixed _quickly_. In this case, I have a bisection report 
> > > FROM TWO DAYS AGO. And I'm still kicking myself for not just reverting 
> > > that piece-of-shit commit then, because I spent the time to look at the 
> > > oops and the commit, and could tell that it was crap.
> > > 
> > > Instead, I _did_ wait for the subsystem maintainer to get around to it. As 
> > > a result of waiting, I've now wasted time for a lot of other people.
> > 
> > I do have a patch in my inbox from Johannes from 4 days ago that fixes 
> > this issue.
> > 
> > 	http://marc.info/?l=linux-wireless&m=125697124819563&w=2
> > 
> > So what is the take away from this now? Do you wanna have Johannes 
> > step over John and Dave and send such a patch directly to you?
> 
> The problem as i see it is the kind of answer Johannes gave when the bug 
> was bisected to by Jeff Chua two days ago:
> 
>   Subject: wpa2 hangs v2.6.32-rc5-402-gb6727b1. Revert
>            7d930bc33653d5592dc386a76a38f39c2e962344 fixed it.
> 
>  [ <1257151742.3555.165.camel@johannes.local> ]
>  ...
>  |
>  | On Sun, 2009-11-01 at 23:18 +0800, Jeff Chua wrote:
>  | > wpa2 (wpa_supplicant) hangs v2.6.32-rc5-402-gb6727b1.
>  |
>  | Explain?
>  |
>  | > Reverting 7d930bc33653d5592dc386a76a38f39c2e962344 fixes it.
>  |
>  | Certainly not a good idea, will break when your AP denies association.
>  |
>  | johannes
> 
> Unhelpful, defensive, in denial.
> 
> Plus that you tried to berate Dmitry in this particular thread about the 
> revert was pretty bad form too IMO.
> 
> _Anyone_ who went through the unnecessary, avoidable cost of having to 
> do a bisection of a 3 days old commit merged at around -rc5 time is in 
> his full rights to ask for a revert, straight from Linus if he thinks 
> so. No ifs and when about it.
> 
> So IMO you are showing the wrong kind of attitude for a post-rc5 
> regression, by a _wide_ margin. The right kind of attitude would be:
> 
>   "Oops, my bad - thanks. I've queued up a revert."
> 
> or:
> 
>   "Oops, my bad - thanks. Does the attached patch fix it?
>    If not we'll revert it."
> 
> Furthermore, your 'hey, nothing happened, we fixed it after all' 
> argument is just a forewarning that you learned nothing and such 
> avoidable incidents could repeat in the future.

who said 'hey, nothing happened, we fixed it after all'. The fix for
this issue is 4 days old and was already on the way to Linus. And I
remember the first response was that this got fixed already and that the
patch is going to Linus.

Regards

Marcel


