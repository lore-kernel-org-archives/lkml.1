Return-Path: <linux-kernel-owner+w=401wt.eu-S935288AbXGUHgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935288AbXGUHgS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 03:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758453AbXGUHgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 03:36:11 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:39976 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754171AbXGUHgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 03:36:10 -0400
Date: Sat, 21 Jul 2007 09:35:33 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andi Kleen <ak@suse.de>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [RFC, Announce] Unified x86 architecture, arch/x86
Message-ID: <20070721073533.GE3801@stusta.de>
References: <1184970779.4012.38.camel@chaos> <200707210740.19227.ak@suse.de> <Pine.LNX.4.58.0707210147340.29129@gandalf.stny.rr.com> <200707210806.12880.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200707210806.12880.ak@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 21, 2007 at 08:06:11AM +0200, Andi Kleen wrote:
> On Saturday 21 July 2007 07:50:46 Steven Rostedt wrote:
>  
> > This patch was the beginning of the merger, not the end result. It strived
> > for binary identical images. It was to put everything together as a
> > _starting_point_!   The next thing to do after this is to start the
> > merging.
> 
> Well we've been merging what makes sense since several years. So it's not 
> really starting anything that hasn't already occurred.

The problem with the current "merging" is that it's extremely hard to 
figure out whether some code in x86_64 might be using some code in i386 
since there are currently 5 (five) different mechanisms used for sharing 
code between the two architectures.

It happens so often that someone accidentally breaks one architecture 
because he didn't notice the code also gets used on the other 
architecture.

> -Andi

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

