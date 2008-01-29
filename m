Return-Path: <linux-kernel-owner+w=401wt.eu-S1765483AbYA2AfU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765483AbYA2AfU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 19:35:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765195AbYA2Ae5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 19:34:57 -0500
Received: from iabervon.org ([66.92.72.58]:43724 "EHLO iabervon.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765512AbYA2Aey (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 19:34:54 -0500
Date: Mon, 28 Jan 2008 19:34:52 -0500 (EST)
From: Daniel Barkalow <barkalow@iabervon.org>
To: Gene Heskett <gene.heskett@gmail.com>
cc: Richard Heck <rgheck@bobjweil.com>, Zan Lynx <zlynx@acm.org>,
       Calvin Walton <calvin.walton@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux ide Mailing list <linux-ide@vger.kernel.org>
Subject: Re: Problem with ata layer in 2.6.24
In-Reply-To: <200801281905.35278.gene.heskett@gmail.com>
Message-ID: <alpine.LNX.1.00.0801281909170.13593@iabervon.org>
References: <200801272122.21823.gene.heskett@gmail.com> <479E1D9E.3000900@bobjweil.com> <alpine.LNX.1.00.0801281445200.13593@iabervon.org> <200801281905.35278.gene.heskett@gmail.com>
User-Agent: Alpine 1.00 (LNX 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jan 2008, Gene Heskett wrote:

> On Monday 28 January 2008, Daniel Barkalow wrote:
> >Building this and installing it along with the appropriate initrd (which
> >might be handled by Fedora's install scripts)
> 
> Or mine, which I've been using for years.

You're ahead of a surprising number of people, including me, if you 
understand making initrds.

> >will either get you back to 
> >old IDE or will make your kernel panic on boot, depending on whether you
> >got it right (so make sure you can still boot the kernel you're sure of or
> >something from a boot disk). This will also cause your hard drives to show
> >up as different device nodes, so if your boot process doesn't mount by
> >disk uuid but by some other feature (and I don't know what Fedora does),
> >you'll also need to change it to something either stable across access
> >methods or which works for the one you're now using.
> 
> It mounts by LABEL=.  All of it.

That'll save a huge amount of hassle. So long as you manage to get the 
right drivers included and the wrong drivers not included, you should be 
pretty much set.

> Fedora is not the only people having trouble,  name a distro, its probably 
> someplace in that 14,800 hit google returns.

Yeah, but they each may need different instructions, particularly if 
they're not mounting by label in general, or not mounting the root 
partition by label. That was the big hassle going the opposite direction. 
And the procedure is 4 lines to describe to somebody who knows how to 
build and install a new kernel for the distro, which is much shorter than 
the explanation of how you generally build and install a kernel. A real 
howto would have to explain where to get the distro's kernel sources and 
default configuration, for example.

	-Daniel
*This .sig left intentionally blank*
