Return-Path: <linux-kernel-owner+w=401wt.eu-S2992944AbXDYTZI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992944AbXDYTZI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 15:25:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992984AbXDYTZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 15:25:07 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:34225 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S2992944AbXDYTZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 15:25:05 -0400
Date: Wed, 25 Apr 2007 21:25:12 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@elte.hu>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Christian Hesse <mail@earthworm.de>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>, suspend2-devel@lists.suspend2.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2:
	hang in atomic copy)
Message-ID: <20070425192512.GZ3468@stusta.de>
References: <20070419070437.GA25211@elte.hu> <20070424202336.GC16503@elf.ucw.cz> <alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org> <20070424212408.GD16457@elf.ucw.cz> <alpine.LFD.0.98.0704241630170.9964@woody.linux-foundation.org> <20070425072350.GA6866@ucw.cz> <20070425151825.GW3468@stusta.de> <20070425173405.GE17074@elf.ucw.cz> <20070425183934.GX3468@stusta.de> <alpine.LFD.0.98.0704251148110.9964@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0704251148110.9964@woody.linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2007 at 11:50:45AM -0700, Linus Torvalds wrote:
> 
> 
> On Wed, 25 Apr 2007, Adrian Bunk wrote:
> > 
> > 3W for the complete system? In CPU state S1? [1]
> 
> In STR, 3W is quite realistic. The CPU is off, all (or most - up to you) 
> the devices are off, but the motherboard and memory is powered.

As far as I understand it, the CPU isn't off in S1.

> > And even 3W would still be a waste of energy.
> 
> .. but if the alternative is a feature that just isn't worth it, and 
> likely to not only have its own bugs, but cause bugs elsewhere? (And yes, 
> I believe STD is both of those. There's a reason it's called "STD". Go 
> to google and type "STD" and press "I'm feeling lucky". Google is God).

Is there really no use case for STD?

No worries if power is completely lost.
Some people might boot Windows between suspending and resuming.
...

> 		Linus

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

