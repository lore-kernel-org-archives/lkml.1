Return-Path: <linux-kernel-owner+w=401wt.eu-S1754110AbXDPO5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110AbXDPO5y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 10:57:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754117AbXDPO5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 10:57:54 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:52158 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030727AbXDPO5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 10:57:53 -0400
Date: Mon, 16 Apr 2007 16:58:01 +0200
From: Adrian Bunk <bunk@stusta.de>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Jesper Juhl <jesper.juhl@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: so what *is* obsolete and removable?
Message-ID: <20070416145801.GE10338@stusta.de>
References: <Pine.LNX.4.64.0704151647200.29357@localhost.localdomain> <9a8748490704151450i251b8b1av8439bc275e982866@mail.gmail.com> <Pine.LNX.4.64.0704161030040.6837@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704161030040.6837@localhost.localdomain>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2007 at 10:44:52AM -0400, Robert P. J. Day wrote:
> On Sun, 15 Apr 2007, Jesper Juhl wrote:
> 
> > On 15/04/07, Robert P. J. Day <rpjday@mindspring.com> wrote:
> > >
> > >   in a recent posting, ian anderson suggested that, before kernel
> > > features are removed, they should spend a reasonable amount of
> > > time in the feature removal file to give everyone fair warning.
> > > if that's the case, then there are a *bunch* of things that should
> > > perhaps be added to that file real soon now just to start the
> > > clock ticking.
> > >
> > [snip]
> > > ./sound/oss/Kconfig:    bool "Obsolete OSS drivers"
> > > ./sound/oss/Kconfig:      This option enables support for obsolete OSS
> > > drivers that
> > >
> > >   clearly, that was a fairly brainless search, but it still
> > > reveals a pile of stuff that's "obsolete" (whatever that means in
> > > the context in which it's used).  so what's really obsolete?
> > >
> > IIRC Adrian Bunk is handling the removal of obsolete OSS drivers and
> > doing a nice job at it. Dunno about the rest of the stuff.
> 
> oh, i realize that a number of those examples from my earlier post
> were already handled/being handled (i don't even look under OSS these
> days when doing any cleanup).
> 
> my point was that, if ian's position is valid and stuff shouldn't be
> removed without fair warning, then a lot of that stuff should get
> entered into the feature removal file real soon now.

If you remove false positives from your grep result, "a lot" turns into 
a relatively small number.

But generally, you should try to ask the maintainers of the subsystem 
first what they think.

Whether to remove something now, in 6 months, or not, can then be 
decided.

> rday
> 
> p.s.  again, if you run the simple grep i mentioned before:
> 
>   $ grep -iw obsolete $(find . -name Kconfig\*)
> 
> you find some odd combinations, such as this from net/ipv4/Kconfig:
> 
> config ARPD
>         bool "IP: ARP daemon support (EXPERIMENTAL)"
>         depends on EXPERIMENTAL
>         ---help---
>         ...
>         This code is experimental and also obsolete...
> 
> the thought of something being both experimental *and* obsolete is a
> bit weird, is it not?

It is not weird:
It was never more than experimental, and now it's obsolete.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

