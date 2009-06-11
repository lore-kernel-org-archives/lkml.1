Return-Path: <linux-kernel-owner+w=401wt.eu-S1762931AbZFKNWF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762931AbZFKNWF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 09:22:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754532AbZFKNVy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 09:21:54 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:55087 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367AbZFKNVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 09:21:53 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/9GW/WuOnl7uWhJ9qXWGrP
Date: Thu, 11 Jun 2009 06:21:35 -0700
From: Tony Lindgren <tony@atomide.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       David Miller <davem@davemloft.net>, swetland@google.com, pavel@ucw.cz,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       san@android.com, rlove@google.com
Subject: Re: HTC Dream aka. t-mobile g1 support
Message-ID: <20090611132134.GA11199@atomide.com>
References: <20090611111821.GK795@n2100.arm.linux.org.uk> <20090611.042226.28424489.davem@davemloft.net> <20090611114911.GL795@n2100.arm.linux.org.uk> <20090611.050030.169859977.davem@davemloft.net> <20090611123852.GM795@n2100.arm.linux.org.uk> <20090611135442.6b9ab315@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090611135442.6b9ab315@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Alan Cox <alan@lxorguk.ukuu.org.uk> [090611 05:54]:
> > For the most part, the answer is no.  People concentrate on their own
> > areas, and won't look at someone with a new class of platforms (eg,
> > the STMP or W90x900 stuff).
> 
> That would appear to be rational behaviour on their part.
> 
> > As I've already said, akpm tried to setup a mutual review between
> > several ARM folk, but as far as I'm aware, it has so far been 
> > unsuccessful (exactly why I don't know.)
> 
> Because its not rational economic behaviour on their part ?
> 
> > If patchwork just gathers up every patch which has ever been seen on
> > a mailing list, then stuff will get lost at a higher rate than today
> > and it will have a negative impact.

Just to comment on the patchwork, we've been using p.k.o for the omap
stuff for few months. It helps for sure as I can now nuke my omap inbox
on regular basis without losing patches :)

But even just for the omap code, we need several people dealing with them,
otherwise there's just too many patches floating around.

So in order to use patchwork for arm patches, it would have to be
distributed to many people to make any use of it like Alan is suggesting.
Otherwise it just fills up with tons of patches.
 
> Stop trying to stand in the middle of the motorway and directing traffic.
> You will get run over if you do that even if you are the best person on
> the planet at that job.
> 
> The problem is perfectly sortable with a bit of experimenting. This is a
> first suggestion - it might not work but it can't make things much worse
> and if the current system doesn't work the first process to fix it is to
> change things.
> 
> Make your tree the core ARM code only, any other patches you don't
> accept. Aggressively push stuff out to platform code, and if people want
> to change core code "because our platform is different" make them extract
> it into the platform layer not carry it in the core bits.
> 
> Nominate a bunch of people for the main ARM platforms. What they put into
> their platform specific trees goes direct from them to -next and if they
> trash their own platform thats their problem (and they can come to you
> for advice ;))

We've done this for two merge windows now for omap patches where the
patches have been posted to linux-arm-kernel, then they go into the
for-next tree, and then Russell merges them in.

It has worked OK, although Russell had some comments about having hard
time keeping track on what he had reviewed already.
 
> Leave it to the platform people to push their driver code through the
> right channels.
> 
> You may be ten times better than them at the job, but there are a hundred
> of them.

Some code Russell of course wants to review more carefully, like the omap
clock code that Russell has contributed heavily on.

But in general, I believe Alan's approach would help to distribute the
merging, and scale it up.
 
> Each of the teams now has an economic focus that is in accord with what
> they need to do "Get our platform working well", and as a secondary
> effect if one of the teams accidentally messes up another they've both
> got economic incentives to fix their shared problem. For core code
> issues you can just follow Linus usual approach of "I'll merge this when
> you've all stopped fighting and agreed a solution" (again you'll note
> this creates the correct incentives).
> 
> Which all in all might give you a bit more time to go gliding rather than
> running around like a lunatic trying to herd cats.

Of course we'd still like to get Russell's comments too on the code where
possible :)

Tony
