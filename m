Return-Path: <linux-kernel-owner+w=401wt.eu-S1756816AbXJKQy2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816AbXJKQy2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 12:54:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753948AbXJKQyV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 12:54:21 -0400
Received: from loopy.telegraphics.com.au ([202.45.126.152]:33417 "EHLO
	loopy.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857AbXJKQyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 12:54:20 -0400
X-Greylist: delayed 1691 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Oct 2007 12:54:20 EDT
Date: Fri, 12 Oct 2007 02:26:07 +1000 (EST)
From: Finn Thain <fthain@telegraphics.com.au>
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: Rob Landley <rob@landley.net>, Sam Ravnborg <sam@ravnborg.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [PATCH] Make m68k cross compile like every other architecture.
In-Reply-To: <Pine.LNX.4.64.0710111707270.3729@anakin>
Message-ID: <Pine.LNX.4.64.0710120211130.4083@loopy.telegraphics.com.au>
References: <200710101722.21126.rob@landley.net> <20071011113931.GB8393@uranus.ravnborg.org>
 <Pine.LNX.4.64.0710111443530.3729@anakin> <200710110827.12631.rob@landley.net>
 <Pine.LNX.4.64.0710111707270.3729@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 11 Oct 2007, Geert Uytterhoeven wrote:

> > Reading the patch in that link, recent cross compilers from _where_?  
> > Buildroot?  Cross-tools?  Gentoo embedded?  Cross Linux From Scratch?  
> > My Firmware Linux project?
> >
> > You assume they all use the same name, yet your patch changes them 
> > from one default name to another default name, presumably due to a gcc 
> > version change becoming increasingly political about the 
> > GNU/Linux/Dammit thing...
> 
> Compilers build from the only remaining distribution that supports (sort 
> of) m68k: Debian.

Maybe. I use an old Cross LFS build, as well as Debian (does Debian 
officially support m68k?), and there also exists an unofficial Gentoo 
port.

> If you cross compile for m68k and don't specify a toolchain, you get a 
> default one: the one the m68k developers use.
> 
> On some other architectures, you always have to specify the toolchain. 
> What's wrong with providing a default?

Nothing, except that uniformity across platforms follows the principal of 
least suprise. That generally makes life easier downstream.

I personally have created and used m68k cross toolchains as "m68k-linux", 
"m68k-linux-gnu" and "m68k-unknown-linux-gnu". AFAIK it's quite arbitrary.

This wasn't an issue before we came to depend on cross compilers. Since we 
tend to need them more as compilation becomes more expensive, IMHO we 
should follow the practice of the embedded architectures.

-f

> 
> Gr{oetje,eeting}s,
> 
> 						Geert
