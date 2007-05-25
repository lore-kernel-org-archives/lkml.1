Return-Path: <linux-kernel-owner+w=401wt.eu-S1765742AbXEYVqq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765742AbXEYVqq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 17:46:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759699AbXEYVqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 17:46:40 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:45310 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758951AbXEYVqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 17:46:39 -0400
Date: Fri, 25 May 2007 23:46:33 +0200
From: Adrian Bunk <bunk@stusta.de>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Satyam Sharma <satyam.sharma@gmail.com>, Krzysztof Halasa <khc@pm.waw.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: any value to "NORET_TYPE" macro?
Message-ID: <20070525214633.GJ3899@stusta.de>
References: <Pine.LNX.4.64.0705221616270.18792@localhost.localdomain> <m37ir0iodl.fsf@maximus.localdomain> <a781481a0705230137v4c8ba82fx263212a2958b55b9@mail.gmail.com> <Pine.LNX.4.64.0705230908180.4309@localhost.localdomain> <a781481a0705230646x9a0255ak4254d05ba5442cad@mail.gmail.com> <Pine.LNX.4.64.0705241239560.10926@localhost.localdomain> <a781481a0705241153m29781dd2u825c0e9bfdb6beb0@mail.gmail.com> <Pine.LNX.4.64.0705251335010.13229@localhost.localdomain> <a781481a0705251225g12d2cd8eya57df87fcbfd5eed@mail.gmail.com> <Pine.LNX.4.64.0705251539500.14140@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705251539500.14140@localhost.localdomain>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, 2007 at 03:40:18PM -0400, Robert P. J. Day wrote:
> On Sat, 26 May 2007, Satyam Sharma wrote:
> 
> > Hi Robert,
> >
> > On 5/25/07, Robert P. J. Day <rpjday@mindspring.com> wrote:
> > > On Fri, 25 May 2007, Satyam Sharma wrote:
> > > ...
> > > > 1. If this is a function _declaration_ (i.e. a prototype in some
> > > > header or some .c file), then remove the NORET_TYPE macro. Also,
> > > > if an ATTRIB_NORET or NORET_AND already exists then you're done.
> > > > Else, introduce an ATTRIB_NORET after the arglist but before ;
> > >
> > > actually, what i would be introducing in all cases is "__noreturn",
> > > the short form currently defined in compiler-gcc.h.  and i would be
> > > removing every instance of ATTRIB_NORET and its buddies.
> >
> > Ummm ... you mean we're replacing all occurrences of ATTRIB_NORET
> > as well? Note that NORET_TYPE and ATTRIB_NORET are both defined
> > in the generic include/linux/linkage.h whereas __noreturn is in
> > compiler-gcc.h which is included only for gcc builds -- hence, my
> > preference for ATTRIB_NORET. Also, there is not even a single user of
> > __noreturn anywhere in the kernel code whereas ATTRIB_NORET is used
> > in all these places, which means it looks like to be the standard thing ...
> > Anyway, I'm fine either way.
> 
> ah, i hadn't noticed that.  i must think on this more.  man, i thought
> this was going to be so simple.  argh.

It's only an optimization, so defining __noreturn to nothing for other 
compilers should work fine.

> rday

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

