Return-Path: <linux-kernel-owner+w=401wt.eu-S1755138AbYEDAuw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755138AbYEDAuw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 20:50:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750885AbYEDAun
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 20:50:43 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:58572 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750698AbYEDAum (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 20:50:42 -0400
Date: Sun, 4 May 2008 03:49:43 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Ingo Molnar <mingo@elte.hu>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Ingo, no more kconfig patches
Message-ID: <20080504004943.GC5838@cs181133002.pp.htv.fi>
References: <20080430230100.GK29330@cs181133002.pp.htv.fi> <20080501025234.GE27574@elte.hu> <20080501115923.GX29330@cs181133002.pp.htv.fi> <20080503191445.GF5292@elte.hu> <20080503202416.GR5838@cs181133002.pp.htv.fi> <m37ieb84ve.fsf@maximus.localdomain> <20080503214750.GU5838@cs181133002.pp.htv.fi> <m3wsmb6np2.fsf@maximus.localdomain> <20080503222943.GX5838@cs181133002.pp.htv.fi> <m3r6cj5584.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <m3r6cj5584.fsf@maximus.localdomain>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 04, 2008 at 01:37:47AM +0200, Krzysztof Halasa wrote:
> Adrian Bunk <bunk@kernel.org> writes:
> 
> > FB_SGIVW requires X86_VISWS and it's selected automatically.
> >
> > (which is not good if you want a kernel that runs on a PC)
> 
> Not sure what do you mean, it currently seem to "depend" on X86_VISWS:
> 
> config FB_SGIVW
>         tristate "SGI Visual Workstation framebuffer support"
>         depends on FB && X86_VISWS
>         select FB_CFB_FILLRECT
>         select FB_CFB_COPYAREA
>         select FB_CFB_IMAGEBLIT

Unless I misunderstand your proposal you want to resolve dependencies 
reversely.

And if you want to only do this for select's: FB_SGIVW could also be 
select'ed.

> > Why do we have to bother users with the MII option at all?
> >
> > "E1000E=m and TULIP=m but MII=y" works, but it doesn't really make 
> > sense.
> 
> (Obviously it assumes both TULIP and E1000E required MII which is not
> exactly the case)
> 
> But it makes a perfect sense, I can have modular drivers for (few)
> hardware devices (just in case I want to rmmod etc) but most of the
> kernel may be not modular. It would be nice if the Kconfig ask me if
> I want to "select" the dependency Y or M, even if there is only one
> way to make "select" dependencies happy (not counting "Y vs "M").

Getting the cases that really matter working would already be hard 
enough...

> Krzysztof Halasa

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

