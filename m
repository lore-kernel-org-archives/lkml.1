Return-Path: <linux-kernel-owner+w=401wt.eu-S1757352AbXF3AGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757352AbXF3AGe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 20:06:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753905AbXF3AG0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 20:06:26 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:44724 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753040AbXF3AGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 20:06:25 -0400
Date: Sat, 30 Jun 2007 02:06:48 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: Johannes Berg <johannes@sipsolutions.net>, Andrew Morton <akpm@osdl.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Con Kolivas <kernel@kolivas.org>, suspend2-devel@lists.suspend2.net,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] move suspend includes into right place (was Re:
	suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2: hang
	in atomic copy))
Message-ID: <20070630000648.GH6087@stusta.de>
References: <1176947576.5906.21.camel@nigel.suspend2.net> <20070419070437.GA25211@elte.hu> <20070424202336.GC16503@elf.ucw.cz> <alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org> <20070424212408.GD16457@elf.ucw.cz> <1177582633.6814.29.camel@johannes.berg> <20070426103051.GP17387@elf.ucw.cz> <20070426104052.GA19072@elf.ucw.cz> <1177595124.6814.77.camel@johannes.berg> <20070629224422.GE6732@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070629224422.GE6732@elf.ucw.cz>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 30, 2007 at 12:44:22AM +0200, Pavel Machek wrote:
> Hi!
> 
> > By the way.
> > 
> > > diff --git a/kernel/power/power.h b/kernel/power/power.h
> > > index eb461b8..dc13af5 100644
> > > --- a/kernel/power/power.h
> > > +++ b/kernel/power/power.h
> >         ^^^^^^^^^^^^^^^^^^^^
> > 
> > Don't these definitions need to be exported to userspace? That
> > definitely is not a header file for userspace.
> 
> Yes, they do. Does this look like a fix?
> 									Pavel
> 
> --- 
> 
> Split userinterface part of power.h into separate file.
>...

You should also add it to include/linux/Kbuild.
 
cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

