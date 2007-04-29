Return-Path: <linux-kernel-owner+w=401wt.eu-S1754449AbXD2ASO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754449AbXD2ASO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 20:18:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754463AbXD2ASO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 20:18:14 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:60644 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754449AbXD2ASM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 20:18:12 -0400
Date: Sat, 28 Apr 2007 17:17:52 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Neil Brown <neilb@suse.de>
cc: "Martin J. Bligh" <mbligh@mbligh.org>, Diego Calleja <diegocg@gmail.com>,
       Chuck Ebbert <cebbert@redhat.com>, Adrian Bunk <bunk@stusta.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Linux 2.6.21
In-Reply-To: <17971.50834.907414.761549@notabene.brown>
Message-ID: <alpine.LFD.0.98.0704281711080.9964@woody.linux-foundation.org>
References: <alpine.LFD.0.98.0704252014050.9964@woody.linux-foundation.org>
 <20070426040806.GJ3468@stusta.de> <20070426125802.GL3468@stusta.de>
 <alpine.LFD.0.98.0704260828550.9964@woody.linux-foundation.org>
 <4630DB24.4030005@redhat.com> <20070426201325.8a1ebda3.diegocg@gmail.com>
 <alpine.LFD.0.98.0704261126010.9964@woody.linux-foundation.org>
 <20070426224148.69b91b2e.diegocg@gmail.com>
 <alpine.LFD.0.98.0704261354560.9964@woody.linux-foundation.org>
 <46339BC7.6050802@mbligh.org> <17971.50834.907414.761549@notabene.brown>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 29 Apr 2007, Neil Brown wrote:
> 
> I think more than half a brain is needed to do this well.  You need a
> reasonable understanding of how all the bits of the kernel work
> together so that you have a good chance of sending the bug in the right
> direction.

Yes. However, even if you just end up summarizing the current outstanding 
issues (and are not able to necessarily point to the right person), I 
suspect that all the top-level maintainers would be interested in it. As 
long as it's a "summary report twice a week" kind of thing.

In fact, I suspect a lot of non-maintainers would be interested too!

And if you then have some way for people to add commentary (and directing) 
to entries, you might start out not knowing where some bugreport should 
go, but you'll have people able to forward them.

I end up doing that fairly regularly - adding people to the Cc when I'm 
involved in a bug, and we suddenly notice that "hey, it looks like it's a 
timer" issue or something, and we end up adding Ingo and Thomas Gleixner 
to the cc.

This, btw, is why email is *so* much nicer than a web interface. A web 
interface is always "a single person looking at it". An email, on the 
other hand, is always "you can bounce it to make _another_ person look at 
it".

But I agree that the more involved in the kernel the initiating person has 
been (at least to *some* degree), the better. No question. I just don't 
think it necessarily needs to be a hugely core person. Anybody who has 
been reading lkml for the last few months will already know a lot of the 
people involved in different subsystems!

			Linus
