Return-Path: <linux-kernel-owner+w=401wt.eu-S1760866AbZC1XqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760866AbZC1XqQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 19:46:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751286AbZC1Xp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 19:45:59 -0400
Received: from www.tglx.de ([62.245.132.106]:34598 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750719AbZC1Xp6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 19:45:58 -0400
Date: Sun, 29 Mar 2009 00:39:09 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@elte.hu>
cc: "H. Peter Anvin" <hpa@kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git-pull -tip] x86: include inverse Xmas tree patches
In-Reply-To: <20090328233438.GA4957@elte.hu>
Message-ID: <alpine.LFD.2.00.0903290035390.3397@localhost.localdomain>
References: <1238251730.2526.2.camel@ht.satnam> <20090328150746.GA3268@x200.localdomain> <20090328190350.GA30214@uranus.ravnborg.org> <49CEA3CD.105@kernel.org> <alpine.LFD.2.00.0903290025280.3397@localhost.localdomain> <20090328233438.GA4957@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Mar 2009, Ingo Molnar wrote:
> * Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > > Personally I'd prefer alphabetic order, sorting based on length 
> > > isn't a complete ordering.  Nearly all editors can sort 
> > > alphabetically at the push of a key.
> > 
> > I'd prefer if somebody would sit down and write a tool to analyse 
> > the include hell instead of manually shuffling crap around to 
> > avoid trivial merge conflicts. I have cleaned up enough stuff in 
> > the x86 merger myself where I was able to cut the number of 
> > includes at least in half just by staring at the gcc intermediate 
> > files. We could do better and automate the analysis so we get down 
> > to a handful of includes instead of including the world and more.
> 
> I do not disagree with include file cleanups (we've done many of 
> them in this cycle and in previous cycles), but note that the 
> reduction in include files at the top of .c files actually increases 
> the chance of patch conflicts: when a new include file is added by 
> two patches to the same .c file.

Those conflicts are trivial and if we have a mechanism to anlyse
include dependencies then we can avoid such conflicts often at all. 

Go through some of the include madness and watch the compiler reading
the same header file ten times for a single source file compile.

Thanks,

	tglx
