Return-Path: <linux-kernel-owner+w=401wt.eu-S1754781AbZHNKaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781AbZHNKaY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 06:30:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754231AbZHNKaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 06:30:23 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47587 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753818AbZHNKaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 06:30:23 -0400
Date: Fri, 14 Aug 2009 12:30:13 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Trilok Soni <soni.trilok@gmail.com>,
       Brian Swetland <swetland@google.com>,
       Joonyoung Shim <jy0922.shim@samsung.com>, m.szyprowski@samsung.com,
       t.fujak@samsung.com, kyungmin.park@samsung.com,
       David Brownell <david-b@pacbell.net>, Daniel Ribeiro <drwyrm@gmail.com>,
       arve@android.com, Barry Song <21cnbao@gmail.com>
Subject: Re: [RFC patch 2/3] genirq: Add buslock support for irq chips on
	slow busses
Message-ID: <20090814103013.GC32418@elf.ucw.cz>
References: <20090813191535.945521006@linutronix.de> <20090813193116.509070851@linutronix.de> <20090814101739.GA32418@elf.ucw.cz> <alpine.LFD.2.00.0908141220190.1283@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0908141220190.1283@localhost.localdomain>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2009-08-14 12:20:49, Thomas Gleixner wrote:
> On Fri, 14 Aug 2009, Pavel Machek wrote:
> > > +extern void disable_slowbus_irq(unsigned int irq);
> > > +extern void enable_slowbus_irq(unsigned int irq);
> > > +
> > 
> > AFAICT this means that driver would need to know what kind of IRQ it
> > is hooked to, right? That will lead to some ugly code in drivers that
> > can handle both normal and slowbus irqs, right?
> 
> Are there such drivers in reality ?

I think so. Between Spitz and Akita, some gpios were moved to slow i2c
extender. For stuff like buttons...

Now... it is probably already fixed somehow for Spitz/Akita, but I
believe more hardware designers do such things....
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
