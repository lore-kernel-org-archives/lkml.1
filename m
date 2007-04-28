Return-Path: <linux-kernel-owner+w=401wt.eu-S1752875AbXD1X3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875AbXD1X3o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 19:29:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753201AbXD1X3n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 19:29:43 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:33641 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752875AbXD1X3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 19:29:42 -0400
Date: Sat, 28 Apr 2007 16:29:21 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Adrian Bunk <bunk@stusta.de>
cc: Diego Calleja <diegocg@gmail.com>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21
In-Reply-To: <20070428224904.GE3468@stusta.de>
Message-ID: <alpine.LFD.0.98.0704281601060.9964@woody.linux-foundation.org>
References: <20070426040806.GJ3468@stusta.de> <20070426125802.GL3468@stusta.de>
 <alpine.LFD.0.98.0704260828550.9964@woody.linux-foundation.org>
 <4630DB24.4030005@redhat.com> <20070426201325.8a1ebda3.diegocg@gmail.com>
 <alpine.LFD.0.98.0704261126010.9964@woody.linux-foundation.org>
 <20070426224148.69b91b2e.diegocg@gmail.com>
 <alpine.LFD.0.98.0704261354560.9964@woody.linux-foundation.org>
 <20070428195320.GZ3468@stusta.de> <20070428202701.GA30343@flint.arm.linux.org.uk>
 <20070428224904.GE3468@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 29 Apr 2007, Adrian Bunk wrote:
> 
> That's exactly where Linus' "drop any bug reports that are more than a 
> week old" suggestion is completely flawed - no matter what the submitter 
> does, how often he tests latest kernels, noone will help him.

You talk, but what do you actually *suggest*?

Talk is cheap. You use to do the walk too, but you've already said that 
you're not interested in that any more. So excuse me if I'm not impressed. 

The thing is, bugzilla is totally broken because it's designed to help 
track bugs, but it's *not* designed to actually handle the much harder 
problem, which is to actually get the *right* developers to be aware of 
the *right* bugs!

And both of those "right"s are important. Spamming everybody will just 
mean that everybody tunes them out. And spamming even the right developers 
with useless bugreports will also just cause them to tune out the good 
ones.

The thing is, the "tracking bugs" part that bugzilla _can_ do is also 
totally _useless_ without that much more important phase, namely the 
"connect the parties". That's what you really used to do. You made 
developers connect to the reports, because your reports were _useful_ and 
not overly noisy.

But go back and look - did you notice that once you connect the dots, it 
turns out that bugzilla itself isn't all that wonderful. Quite a lot of 
your regression reports had other ways of pointing to the problems, 
including very much mailing list archive pointers etc!

So bugzilla isn't actually all it's touted to be even _once_ the 
connection between reporter and developer has been established. I really 
don't see why you are so hung up about bugzilla, when your own regression 
reports didn't generally point to it all that often!

(I just went back and double-checked: you had more than twice as many 
pointers to kernel mailing list archives than you had pointers to bugzilla 
in the one series I looked at. And I'm _not_ saying that's wrong at all: I 
think the mailing list is actually likely to be at LEAST as useful as 
bugzilla is as a bug-tracker!)

And bugzilla actually falls down even more than the mailing list does for 
the whole (and MUCH MORE IMPORTANT!) phase of connecting developers to bug 
reports. And THAT is really the problem here.

And no, I don't actually think that automatically closing entries that 
haven't gotten any attention in the last two weeks would "fix" bugzilla. 
But I think that it might actually make people 
 (a) more likely to look into bugzilla (and thus maybe improve the 
     "connecting" developers/reporters thing)
 (b) act as a trivial noise-removal thing, because it would give 
     preferential treatment to people who are diligent about their 
     bug-reports and are willing to follow up on them and it would also 
     remove the noise that comes from obvious things that broke and got 
    fixed.

But I think the real fix is to have real humans that help de-noisify the 
bug reports. Let's call them the "bunk" group, just to pick a random 
four-letter combination. The kinds of people who help turn the mindless 
noise that is bugzilla (and the kernel mailing list) into directed 
_information_. 

No, nothing is ever going to be perfect. And "filtering" the noise will 
inevitably also end up dropping real information. But not filtering it 
will guarantee that even more is dropped.

		Linus
