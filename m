Return-Path: <linux-kernel-owner+w=401wt.eu-S1756435AbXD2MSG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756435AbXD2MSG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 08:18:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756443AbXD2MSG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 08:18:06 -0400
Received: from mail.suse.de ([195.135.220.2]:58847 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756439AbXD2MSD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 08:18:03 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Adrian Bunk <bunk@stusta.de>, Diego Calleja <diegocg@gmail.com>,
       Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21
References: <20070426040806.GJ3468@stusta.de>
	<20070426125802.GL3468@stusta.de>
	<alpine.LFD.0.98.0704260828550.9964@woody.linux-foundation.org>
	<4630DB24.4030005@redhat.com>
	<20070426201325.8a1ebda3.diegocg@gmail.com>
	<alpine.LFD.0.98.0704261126010.9964@woody.linux-foundation.org>
	<20070426224148.69b91b2e.diegocg@gmail.com>
	<alpine.LFD.0.98.0704261354560.9964@woody.linux-foundation.org>
	<20070428195320.GZ3468@stusta.de>
	<20070428202701.GA30343@flint.arm.linux.org.uk>
	<20070428224904.GE3468@stusta.de>
	<alpine.LFD.0.98.0704281601060.9964@woody.linux-foundation.org>
From: Andi Kleen <andi@firstfloor.org>
Date: 29 Apr 2007 15:15:42 +0200
In-Reply-To: <alpine.LFD.0.98.0704281601060.9964@woody.linux-foundation.org>
Message-ID: <p73d51n1fup.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Sun, 29 Apr 2007, Adrian Bunk wrote:
> > 
> > That's exactly where Linus' "drop any bug reports that are more than a 
> > week old" suggestion is completely flawed - no matter what the submitter 
> > does, how often he tests latest kernels, noone will help him.
> 
> You talk, but what do you actually *suggest*?
> 
> Talk is cheap. You use to do the walk too, but you've already said that 
> you're not interested in that any more. So excuse me if I'm not impressed. 
> 
> The thing is, bugzilla is totally broken because it's designed to help 
> track bugs, but it's *not* designed to actually handle the much harder 
> problem, which is to actually get the *right* developers to be aware of 
> the *right* bugs!

This means we need people who figure out who to assign bugs too.
Aka bugmasters.

In theory it could be nearly automated. Figure out what files related
to the bug and assign to the last 5 people who submitted patches
for them and/or signed off. 

Ok I suppose it's not that easy -- you would need some human judgement.

BTW one big problem in our current bugzilla is that a lot of people
cannot reassign bugs they don't own. I sometimes see bugs that I don't
own bug I know who is responsible, but bugzilla doesn't allow me to do it.

So I think what would help:

- Ask more people to just categorize and reassign bugs (anybody interested?)
- Give more people in bugzilla the power to reassign arbitary bugs
(bugzilla maintainers would need to do that)

-Andi

