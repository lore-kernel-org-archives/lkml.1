Return-Path: <linux-kernel-owner+w=401wt.eu-S1161848AbXDYIL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161848AbXDYIL0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 04:11:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161864AbXDYILZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 04:11:25 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1817 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161844AbXDYILR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 04:11:17 -0400
Date: Wed, 25 Apr 2007 08:10:51 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Dumitru Ciobarcianu <Dumitru.Ciobarcianu@iNES.RO>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Christian Hesse <mail@earthworm.de>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>, suspend2-devel@lists.suspend2.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2: hang in atomic copy)
Message-ID: <20070425081051.GA7221@ucw.cz>
References: <20070418220228.GA14536@elte.hu> <1176947576.5906.21.camel@nigel.suspend2.net> <20070419070437.GA25211@elte.hu> <20070424202336.GC16503@elf.ucw.cz> <alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org> <20070424212408.GD16457@elf.ucw.cz> <alpine.LFD.0.98.0704241630170.9964@woody.linux-foundation.org> <20070425064137.GA25247@elte.hu> <20070425072904.GB6866@ucw.cz> <1177487338.17755.46.camel@DustPuppy.LNX.RO>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1177487338.17755.46.camel@DustPuppy.LNX.RO>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > userspace-driven-suspend is already in the kernel, today. So it's not 
> > > really "two versions side by side doing the same thing", but more of:
> > > 
> > >            A B C + D E F G H
> > > 
> > > where "ABC" is used by the uswsusp code today, and "ABCDEFGH" is used by 
> > > suspend2. So any "suspend2 merge" would largely be about adding "DEFGH". 
> > 
> > Actually, we have 'D H' in kernel, today. It is called swsusp...
> > (Encryption, swapFile support and Graphical progress are missing from
> > today's kernel.)
> 
> Please stop using FUD. 
> Graphical progress it's not in the kernel, even with suspend2.

It was ascii-art, but still 'graphical', last time I checked.

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
