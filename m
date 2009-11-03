Return-Path: <linux-kernel-owner+w=401wt.eu-S1753435AbZKCQYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435AbZKCQYu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 11:24:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751261AbZKCQYt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 11:24:49 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48151 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751336AbZKCQYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 11:24:49 -0500
Date: Tue, 3 Nov 2009 08:23:38 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Marcel Holtmann <marcel@holtmann.org>
cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       David Miller <davem@davemloft.net>, johannes@sipsolutions.net,
       linville@tuxdriver.com, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org
Subject: Re: Please consider reverting
 7d930bc33653d5592dc386a76a38f39c2e962344
In-Reply-To: <1257264485.3420.87.camel@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0911030815180.31845@localhost.localdomain>
References: <20091103053156.GA3212@core.coreip.homeip.net>  <20091102.224957.32364226.davem@davemloft.net>  <20091103065238.GE3212@core.coreip.homeip.net>  <1257232587.3420.55.camel@localhost.localdomain>  <alpine.LFD.2.01.0911030719430.31845@localhost.localdomain>
  <1257262588.3420.79.camel@localhost.localdomain>  <alpine.LFD.2.01.0911030738260.31845@localhost.localdomain> <1257264485.3420.87.camel@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 4 Nov 2009, Marcel Holtmann wrote:
>
> I do have a patch in my inbox from Johannes from 4 days ago that fixes
> this issue.
> 
> 	http://marc.info/?l=linux-wireless&m=125697124819563&w=2
> 
> So what is the take away from this now? Do you wanna have Johannes step
> over John and Dave and send such a patch directly to you?

Hell yes. If it causes lockups for people, and the original commit is 
_known_ to be buggy, these kinds of things should be expedited.

How much users time and effort do we want to waste?

And there's a secondary issue too - how comfortable do we want people to 
be to test late-in-the-game -git trees? I should hope that they should be 
considered pretty stable. And ask yourself: would it have been better to 
have had this bug in my -git tree for just one day, or for five days?

Of course, the optimal situation would have been that such a buggy commit 
wouldn't have been ever merged in the first place - at least not after 
-rc5. But notice how I'm not really complaining about that part: I'm a 
firm believer in the "bugs happen" reality, and while we should try to be 
careful, things like this _will_ slip through. 

So I'm not unhappy about the bug happening in the first place. It would 
have been better had it not, but hey, mistakes happen. We should just 
"Deal with it". 

And yes, "dealing with it" very much means by-passing maintainers if 
necessary. It can mean sending patches directly to me, but it _also_ means 
asking me to just revert a commit that turns out to be buggy and was 
merged late.

And that's what I'm really arguing for here - I don't like how you and 
Johannes were arguing against "dealing with it". As it was, we clearly had 
users wasting their time on this.

		Linus
