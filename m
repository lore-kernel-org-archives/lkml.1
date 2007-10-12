Return-Path: <linux-kernel-owner+w=401wt.eu-S1760058AbXJLHyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760058AbXJLHyn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 03:54:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754699AbXJLHye
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 03:54:34 -0400
Received: from loopy.telegraphics.com.au ([202.45.126.152]:51203 "EHLO
	loopy.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145AbXJLHyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 03:54:32 -0400
Date: Fri, 12 Oct 2007 17:54:30 +1000 (EST)
From: Finn Thain <fthain@telegraphics.com.au>
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: Rob Landley <rob@landley.net>, Sam Ravnborg <sam@ravnborg.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [PATCH] Make m68k cross compile like every other architecture.
In-Reply-To: <Pine.LNX.4.64.0710120849480.11634@anakin>
Message-ID: <Pine.LNX.4.64.0710121731110.17887@loopy.telegraphics.com.au>
References: <200710101722.21126.rob@landley.net> <Pine.LNX.4.64.0710111707270.3729@anakin>
 <Pine.LNX.4.64.0710120211130.4083@loopy.telegraphics.com.au>
 <200710111614.39879.rob@landley.net> <Pine.LNX.4.64.0710120849480.11634@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



> 
> If your cross-compiler is called differently than the default on in 
> arch/*/Makefile,

Part of the problem is that there is no compelling default. The name of 
the cross-compiler can vary depending on the chosen executable prefix or 
the chosen target tuple.

Let's say I create new cross toolchains for both m68k and powerpc. I use 
the "m68k-linux-gnu" to follow the m68k default, but let's assume powerpc 
users prefer their default "powerpc-linux" so I follow that too. The 
result is that I now have gcc's -B option working (or not working) in 
suprising ways too.

Uniformity is more helpful downstream than a different arbitrary default 
for each architecture. Debian should patch their default into their kernel 
source packages if they've standardised on cross compiler prefixes.

> what's the problem with calling?
> 
>     make ARCH=myarch CROSS_COMPILE=my-cross-compile-prefx-
> 
> This has been working for +10 years on all non-ia32 platforms I ever worked on.

But there is no problem with calling that (?). Rob's patch doesn't change 
this.

-f

> 
> Gr{oetje,eeting}s,
> 
> 						Geert
> 
