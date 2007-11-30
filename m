Return-Path: <linux-kernel-owner+w=401wt.eu-S1755700AbXK3UAU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755700AbXK3UAU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 15:00:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752638AbXK3UAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 15:00:05 -0500
Received: from relay1.sgi.com ([192.48.171.29]:46795 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751864AbXK3UAD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 15:00:03 -0500
Date: Fri, 30 Nov 2007 11:59:59 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Ingo Molnar <mingo@elte.hu>
cc: Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 0/3] Per cpu relocation to ZERO and x86_32 percpu ops on
 x86_64
In-Reply-To: <20071130194517.GD9928@elte.hu>
Message-ID: <Pine.LNX.4.64.0711301147100.2242@schroedinger.engr.sgi.com>
References: <20071130064305.459255715@sgi.com> <20071130112429.GA3605@elte.hu>
 <20071130112645.GA7565@elte.hu> <Pine.LNX.4.64.0711300918250.32294@schroedinger.engr.sgi.com>
 <20071130180002.GB19571@elte.hu> <Pine.LNX.4.64.0711301019590.1743@schroedinger.engr.sgi.com>
 <20071130183512.GA8985@elte.hu> <Pine.LNX.4.64.0711301043380.1919@schroedinger.engr.sgi.com>
 <20071130194517.GD9928@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Nov 2007, Ingo Molnar wrote:

> This was not any "formal" x86 maintainance activity - your patches are 
> still cooking. But i was thinking about maybe putting these patches into 
> the x86 test grind to get them shaken out some more the random 1000 
> bootup tests a day that it does. When integrating your patches I found a 
> bug and tentatively reported it to you, pointing out that it could 
> easily be my merge fault. Basically i was offering you to let your 
> patches cook in another kitchen as well. I never before had a negative 
> response to that :-/

You could have asked me for a patch against the x86 tree instead of 
forcing these into your tree. Then I could have made sure that everything 
is okay for your tests, I would have put the stuff into a git tree for you 
to pull etc. I'd be glad if you would test this but if at least if you get 
these kinds of rejects then its probably wise to stop and reconsider your 
approach.

> > I am a bit surprised since Andi and I never had this issue.
> 
> huh??? I am really wondering where this hostile attitude of yours comes 
> from. Getting patches build and boot is something architecture 
> maintainers do on a regular basis, it's a minimum requirement before 
> getting something merged into an architecture.

Hostile? AFAICT this is not the usual way how things are handled with mm 
patches. Preparing a patch against mainline would take some doing.
 
> And btw., -rc3-mm2 seems to have grown a spontaneous reboot problem, 
> that looks quite similar to what i saw:
> 
>   http://kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc3/2.6.24-rc3-mm2/announce.txt

Side swipe against mm? ;-) mm2 works fine here. What is so bad about mm?

> so from now on i guess i'll have to tag you as "does not want any 
> advance testing and review help with his patches" person and will leave 
> you alone.

I have tried to help you as best as I could in a endeavor that I 
expected to be fruitless while warning you not to go down that route.

I am in the same situation supposed to go on vacation from today till the 
12th. I took some hours to test your config and figure out how to clean up 
the mess.

