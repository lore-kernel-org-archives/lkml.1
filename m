Return-Path: <linux-kernel-owner+w=401wt.eu-S1760521AbYDZRYF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760521AbYDZRYF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 13:24:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758886AbYDZRXy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 13:23:54 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:36359 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758860AbYDZRXx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 13:23:53 -0400
Date: Sat, 26 Apr 2008 20:23:29 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kbuild@vger.kernel.org, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] headerdep: a tool for detecting inclusion cycles in
	header file
Message-ID: <20080426172329.GO2252@cs181133002.pp.htv.fi>
References: <20080426134554.GA20727@damson.getinternet.no> <20080426164450.GK2252@cs181133002.pp.htv.fi> <19f34abd0804260957i62db6929s2a4227a517f3c9a1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <19f34abd0804260957i62db6929s2a4227a517f3c9a1@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 26, 2008 at 06:57:09PM +0200, Vegard Nossum wrote:
> On 4/26/08, Adrian Bunk <bunk@kernel.org> wrote:
> > On Sat, Apr 26, 2008 at 03:45:54PM +0200, Vegard Nossum wrote:
> >
> > > Hi Sam,
> >  >
> >  > Maybe something like this could be useful for cleaning up headers (and
> >  > maintaining that cleanliness once it has been achieved). What do you think?
> >
> > >...
> >
> >  And another note (after looking at the Cc list):
> >
> >  Header cleanup is *not* something suitable as a first task for a janitor.
> 
> Hehe, yes, I could not agree more!
> 
> I have been trying to resolve some of these errors myself, but it's
> incredibly hard to get right.
> 
> The reason I CCed kernel-janitors is that this IS a janitorial
> project. But I am not implying that janitor means "newbie" or trivial.
> At least the way I see it, janitor work is cleaning up, but not
> necessarily easy work. But I agree, definitely not a first task job.

kernel-janitors is basically for "I'm new to kernel development and 
want an easy task".

> >  The interesting cases are non-trivial.
> >
> >  And you need cross compilers for all architectures since fiddling with
> >  #include's under include/ breaks code left and right that only compiled
> >  due to some implicit #include (and if it still works due to another
> >  implicit #include on x86 the latter might not be present on all
> >  architectures).
> 
> Yep. I have been compiling cross-compilers myself. As a btw, I had
> already started some project to distribute binary cross-compilers
> http://folk.uio.no/vegardno/crosstool/ for the purpose of making
> cross-compiling easier to get started with. (It would be cool to have
> a complete suite of working cross-compilers in a single download.)

"The source code for the binary files below can be downloaded from the 
 aforementioned project websites."

-> GPL violation

> Vegard

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

