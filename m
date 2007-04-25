Return-Path: <linux-kernel-owner+w=401wt.eu-S1161792AbXDYTzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161792AbXDYTzz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 15:55:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161803AbXDYTzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 15:55:54 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:33954 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161792AbXDYTzx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 15:55:53 -0400
Date: Wed, 25 Apr 2007 21:55:35 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Adrian Bunk <bunk@stusta.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Christian Hesse <mail@earthworm.de>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>, suspend2-devel@lists.suspend2.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2: hang in atomic copy)
Message-ID: <20070425195535.GA17387@elf.ucw.cz>
References: <20070424202336.GC16503@elf.ucw.cz> <alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org> <20070424212408.GD16457@elf.ucw.cz> <alpine.LFD.0.98.0704241630170.9964@woody.linux-foundation.org> <20070425072350.GA6866@ucw.cz> <20070425151825.GW3468@stusta.de> <20070425173405.GE17074@elf.ucw.cz> <20070425183934.GX3468@stusta.de> <alpine.LFD.0.98.0704251148110.9964@woody.linux-foundation.org> <20070425192512.GZ3468@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070425192512.GZ3468@stusta.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > 3W for the complete system? In CPU state S1? [1]
> > 
> > In STR, 3W is quite realistic. The CPU is off, all (or most - up to you) 
> > the devices are off, but the motherboard and memory is powered.
> 
> As far as I understand it, the CPU isn't off in S1.
> 
> > > And even 3W would still be a waste of energy.
> > 
> > .. but if the alternative is a feature that just isn't worth it, and 
> > likely to not only have its own bugs, but cause bugs elsewhere? (And yes, 
> > I believe STD is both of those. There's a reason it's called "STD". Go 
> > to google and type "STD" and press "I'm feeling lucky". Google is God).
> 
> Is there really no use case for STD?

Of course there are use cases for STD... lots of them... that's why
I'm maintaining it.

It has some "interesting" use cases, like suspend on one machine,
transfer image to identical one, resume there, dual-boot to windows;
there are "normal" use cases, like machines not capable of S3.

I hope we are not dropping STD just now...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
