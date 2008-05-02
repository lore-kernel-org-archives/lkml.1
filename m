Return-Path: <linux-kernel-owner+w=401wt.eu-S934486AbYEBMvu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934486AbYEBMvu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 08:51:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758915AbYEBMvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 08:51:44 -0400
Received: from mercury.sdinet.de ([193.103.161.30]:47773 "EHLO
	mercury.sdinet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755476AbYEBMvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 08:51:43 -0400
X-Greylist: delayed 651 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 May 2008 08:51:43 EDT
Date: Fri, 2 May 2008 14:40:49 +0200 (CEST)
From: Sven-Haegar Koch <haegar@sdinet.de>
To: Alistair John Strachan <alistair@devzero.co.uk>
cc: Chris Knadle <Chris.Knadle@coredump.us>,
       Andrew Morton <akpm@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>, venkatesh.pallipadi@intel.com,
       davem@davemloft.net, trini@kernel.crashing.org, mingo@elte.hu,
       tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org,
       suresh.b.siddha@intel.com,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: huge gcc 4.1.{0,1} __weak problem
In-Reply-To: <200805021055.10602.alistair@devzero.co.uk>
Message-ID: <alpine.DEB.1.10.0805021439330.23679@mercury.sdinet.de>
References: <20080501235558.GA20637@orac.ofobscurity.com> <200805021055.10602.alistair@devzero.co.uk>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 May 2008, Alistair John Strachan wrote:
> On Friday 02 May 2008 00:55:58 Chris Knadle wrote:
> > On Thu, 1 May 2008, Linus Torvalds wrote:
> > > On Thu, 1 May 2008, Andrew Morton wrote:
> > > > > I see only the following choices:
> > > > > - remove __weak and replace all current usages
> > > > > - move all __weak functions into own files, and ensure that also
> > > > > happens for future usages
> > > > > - #error for gcc 4.1.{0,1}
> > > >
> > > > Can we detect the {0,1}?  __GNUC_EVEN_MORE_MINOR__?
> > >
> > > It's __GNUC_PATCHLEVEL__, I believe.
> > >
> > > So yes, we can distinguish 4.1.2 (good, and very common) from 4.1.{0,1}
> > > (bad, and rather uncommon).
> > > And yes, considering that 4.1.1 (and even more so 4.1.0) should be rare
> > > to begin with, I think it's better to just not support it.
> > >
> > >			Linus
> >
> >    Unfortunately Debian Stable (i.e. Etch), which is relatively popular for
> > server use, is still using 4.1.1  :-(  (The current gcc package is
> > gcc-4.1.1-21)
> >
> >    I have not looked to see if Debian Stable's gcc-4.1.1-21 has been
> > patched for the currently discussed __weak bug.
> 
> I checked and it has been patched in 4.1.1-21. This would make checking for 
> 4.1.1 via __GNUC_PATCHLEVEL__ potentially invalid, as patched distro 
> compilers may (and in this case do) have this fixed.

Not a problem for the Debian Stable Version, as someone already wrote, it 
calls itself 4.1.2, even if the package version number is 4.1.1-xx

> gcc --version
gcc (GCC) 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)
Copyright (C) 2006 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.


c'ya
sven

-- 

The Internet treats censorship as a routing problem, and routes around
it. (John Gilmore on http://www.cygnus.com/~gnu/)
