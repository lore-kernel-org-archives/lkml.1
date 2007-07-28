Return-Path: <linux-kernel-owner+w=401wt.eu-S1758362AbXG1VKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758362AbXG1VKa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 17:10:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757160AbXG1VKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 17:10:11 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45605 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756901AbXG1VKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 17:10:08 -0400
Date: Sat, 28 Jul 2007 14:09:46 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Diego Calleja <diegocg@gmail.com>
cc: Jan Engelhardt <jengelh@computergmbh.de>,
       Jonathan Jessup <jonathanjessup@gmail.com>,
       Grzegorz Kulewski <kangur@polcom.net>, linux-kernel@vger.kernel.org,
       ck@vds.kolivas.org, lkml@metanurb.dk
Subject: Re: [ck] Re: Linus 2.6.23-rc1
In-Reply-To: <20070728225148.a0e58fdd.diegocg@gmail.com>
Message-ID: <alpine.LFD.0.999.0707281401280.3442@woody.linux-foundation.org>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org>
 <1185588279.1654.1.camel@localhost> <alpine.LFD.0.999.0707271922050.3442@woody.linux-foundation.org>
 <Pine.LNX.4.63.0707280817540.27758@alpha.polcom.net>
 <954c7c800707280045t4607cebfj532ef025a7a57c05@mail.gmail.com>
 <alpine.LFD.0.999.0707280956140.3442@woody.linux-foundation.org>
 <Pine.LNX.4.64.0707281927500.15125@fbirervta.pbzchgretzou.qr>
 <alpine.LFD.0.999.0707281050590.3442@woody.linux-foundation.org>
 <20070728225148.a0e58fdd.diegocg@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 28 Jul 2007, Diego Calleja wrote:

> El Sat, 28 Jul 2007 11:05:25 -0700 (PDT), Linus Torvalds <torvalds@linux-foundation.org> escribió:
> > 
> > So "modal" things are good for fixing behaviour in the short run. But they 
> > are a total disaster in the long run, and even in the short run they tend 
> > to have problems (simply because there will be cases that straddle the 
> > line, and show some of _both_ issues, and now *neither* mode is the right 
> > one)
> 
> I fully agree with this, but plugsched could have avoided this useless "division"
> on the topic of SD vs CFS. IMO that counts as an advantage, too ;)

Sure. I actually think it's a huge advantage (see the ManagementStyle file 
on pissing people off), but at the same time, I don't like playing 
politics with technology. The kernel is a technical project, and I make 
technical decisions.

So I absolutely detest adding code for "political" reasons.

I personally feel that modal behaviour is bad, so it would introduce what 
is in my opinion bad code, and likely result in problems not being found 
and fixed as well (because people would pick the thing that "works for 
them", and ignore the problems in the other module). So while I don't like 
making irreversible decisions (and the choice of CFS wasn't irreversible 
in itself, but if it pisses off Con, _that_ is generally not reversible), 
I dislike even more making a half-assed decision.

So rather than making a choice at all, my other choice would have been to 
not merge _either_ scheduler, and let people just continue to fight it 
out. Would that have made people happier? I seriously doubt it.

			Linus
