Return-Path: <linux-kernel-owner+w=401wt.eu-S2993084AbXDYUXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993084AbXDYUXb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 16:23:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993088AbXDYUXb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 16:23:31 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:34290 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S2993084AbXDYUXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 16:23:30 -0400
Date: Wed, 25 Apr 2007 22:23:36 +0200
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
Message-ID: <20070425202336.GC3468@stusta.de>
References: <alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org> <20070424212408.GD16457@elf.ucw.cz> <alpine.LFD.0.98.0704241630170.9964@woody.linux-foundation.org> <20070425072350.GA6866@ucw.cz> <20070425151825.GW3468@stusta.de> <20070425173405.GE17074@elf.ucw.cz> <20070425183934.GX3468@stusta.de> <alpine.LFD.0.98.0704251148110.9964@woody.linux-foundation.org> <20070425192512.GZ3468@stusta.de> <alpine.LFD.0.98.0704251231111.9964@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0704251231111.9964@woody.linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2007 at 12:38:47PM -0700, Linus Torvalds wrote:
> 
> 
> On Wed, 25 Apr 2007, Adrian Bunk wrote:
> > > 
> > > .. but if the alternative is a feature that just isn't worth it, and 
> > > likely to not only have its own bugs, but cause bugs elsewhere? (And yes, 
> > > I believe STD is both of those. There's a reason it's called "STD". Go 
> > > to google and type "STD" and press "I'm feeling lucky". Google is God).
> > 
> > Is there really no use case for STD?
>...
> I'd actually be happier *removing* STD support in the sense it is now: 
> it's way too closely integrated with STR, even though it has absolutely 
> nothing in common with it. When you STD, you'e actually much closer to a 
> *shutdown* than to STR, yet the STD code continually seems to want to be 
> in the "suspend" path, as shown even by its name.
> 
> So my objections to STD have nothing to do with saving state and shutting 
> down. They have everything to do with the fact that it is not - and will 
> never be - a "suspend", and it shouldn't affect suspend.
>...

There are two completely different points:
- I say that the feature STD has use cases where STR is not a replacement
- you say you dislike the current implementation of STD

For me it was a serious regression if STD was removed without any 
replacement.

If someone would replace the STD implementation with what you want it to 
be I wouldn't care and you were happy.

> 		Linus

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

