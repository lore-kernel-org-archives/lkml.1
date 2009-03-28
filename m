Return-Path: <linux-kernel-owner+w=401wt.eu-S1761011AbZC1Xhv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761011AbZC1Xhv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 19:37:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751785AbZC1Xhm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 19:37:42 -0400
Received: from www.tglx.de ([62.245.132.106]:51014 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119AbZC1Xhl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 19:37:41 -0400
Date: Sun, 29 Mar 2009 00:31:02 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "H. Peter Anvin" <hpa@kernel.org>
cc: Sam Ravnborg <sam@ravnborg.org>, Alexey Dobriyan <adobriyan@gmail.com>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git-pull -tip] x86: include inverse Xmas tree patches
In-Reply-To: <49CEA3CD.105@kernel.org>
Message-ID: <alpine.LFD.2.00.0903290025280.3397@localhost.localdomain>
References: <1238251730.2526.2.camel@ht.satnam> <20090328150746.GA3268@x200.localdomain> <20090328190350.GA30214@uranus.ravnborg.org> <49CEA3CD.105@kernel.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Mar 2009, H. Peter Anvin wrote:
> Sam Ravnborg wrote:
> > 
> > Ordering include based on length of line minimize the
> > risk of merge conflicts.
> > If people just add new includes in the bottom of the list you
> > are certain that a merge conflit happens.
> > 
> > This scheme is starting to be used in several places with the
> > primary advocates being David Miller and Ingo.
> > 
> > It is getting used both for includes _and_ for local variables.
> > 
> 
> Personally I'd prefer alphabetic order, sorting based on length isn't a
> complete ordering.  Nearly all editors can sort alphabetically at the
> push of a key.

I'd prefer if somebody would sit down and write a tool to analyse the
include hell instead of manually shuffling crap around to avoid
trivial merge conflicts. I have cleaned up enough stuff in the x86
merger myself where I was able to cut the number of includes at least
in half just by staring at the gcc intermediate files. We could do
better and automate the analysis so we get down to a handful of
includes instead of including the world and more.

Also there are lots of occasions where includes in header files can be
avoided completely by a single line forward declaration of struct foo
instead of adding the include, which drags in another five.

Thanks,

	tglx
