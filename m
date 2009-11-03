Return-Path: <linux-kernel-owner+w=401wt.eu-S1753811AbZKCQoM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811AbZKCQoM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 11:44:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753208AbZKCQoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 11:44:12 -0500
Received: from senator.holtmann.net ([87.106.208.187]:52255 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377AbZKCQoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 11:44:11 -0500
Subject: Re: Please consider reverting
 7d930bc33653d5592dc386a76a38f39c2e962344
From: Marcel Holtmann <marcel@holtmann.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       David Miller <davem@davemloft.net>, johannes@sipsolutions.net,
       linville@tuxdriver.com, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org
In-Reply-To: <alpine.LFD.2.01.0911030815180.31845@localhost.localdomain>
References: <20091103053156.GA3212@core.coreip.homeip.net>
	 <20091102.224957.32364226.davem@davemloft.net>
	 <20091103065238.GE3212@core.coreip.homeip.net>
	 <1257232587.3420.55.camel@localhost.localdomain>
	 <alpine.LFD.2.01.0911030719430.31845@localhost.localdomain>
	 <1257262588.3420.79.camel@localhost.localdomain>
	 <alpine.LFD.2.01.0911030738260.31845@localhost.localdomain>
	 <1257264485.3420.87.camel@localhost.localdomain>
	 <alpine.LFD.2.01.0911030815180.31845@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 04 Nov 2009 01:44:07 +0900
Message-Id: <1257266647.3420.105.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

> > I do have a patch in my inbox from Johannes from 4 days ago that fixes
> > this issue.
> > 
> > 	http://marc.info/?l=linux-wireless&m=125697124819563&w=2
> > 
> > So what is the take away from this now? Do you wanna have Johannes step
> > over John and Dave and send such a patch directly to you?
> 
> Hell yes. If it causes lockups for people, and the original commit is 
> _known_ to be buggy, these kinds of things should be expedited.
> 
> How much users time and effort do we want to waste?
> 
> And there's a secondary issue too - how comfortable do we want people to 
> be to test late-in-the-game -git trees? I should hope that they should be 
> considered pretty stable. And ask yourself: would it have been better to 
> have had this bug in my -git tree for just one day, or for five days?
> 
> Of course, the optimal situation would have been that such a buggy commit 
> wouldn't have been ever merged in the first place - at least not after 
> -rc5. But notice how I'm not really complaining about that part: I'm a 
> firm believer in the "bugs happen" reality, and while we should try to be 
> careful, things like this _will_ slip through. 
> 
> So I'm not unhappy about the bug happening in the first place. It would 
> have been better had it not, but hey, mistakes happen. We should just 
> "Deal with it". 
> 
> And yes, "dealing with it" very much means by-passing maintainers if 
> necessary. It can mean sending patches directly to me, but it _also_ means 
> asking me to just revert a commit that turns out to be buggy and was 
> merged late.
> 
> And that's what I'm really arguing for here - I don't like how you and 
> Johannes were arguing against "dealing with it". As it was, we clearly had 
> users wasting their time on this.

that is a clear statement and I am perfectly fine with this.

However to be fair here, this one didn't hit everybody. I for myself
haven't seen it at all and actually I have been running this "faulty"
kernel for a while now and suspending happily multiple times a day. As
much as you hate that the patch for this bug took longer than needed to
find its way into your tree, the immediate need and the wide problem was
not clear. So there will be always cases where at the time of writing
the patch, the sensible thing to do is following the normal merge path
and the patch will end up in your tree multiple days later. It is not
optimal, but it happens.

And for the record, I think that a quick bug report to linux-wireless
would have been as effective and a request for a revert. But that is my
pure personal opinion here.

Regards

Marcel


