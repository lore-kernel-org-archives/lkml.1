Return-Path: <linux-kernel-owner+w=401wt.eu-S1755044AbXHUWK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755044AbXHUWK4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 18:10:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751678AbXHUWKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 18:10:47 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:55538 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751348AbXHUWKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 18:10:46 -0400
Date: Wed, 22 Aug 2007 00:09:52 +0200
From: Adrian Bunk <bunk@kernel.org>
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Segher Boessenkool <segher@kernel.crashing.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jarek Poplawski <jarkao2@o2.pl>, Andi Kleen <ak@suse.de>,
       linux-arch@vger.kernel.org, Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: RFC: drop support for gcc < 4.0
Message-ID: <20070821220952.GH30705@stusta.de>
References: <20070821132038.GA22254@ff.dom.local> <20070821093103.3c097d4a.randy.dunlap@oracle.com> <20070821173550.GC30705@stusta.de> <20070821191959.GC2642@bingen.suse.de> <20070821195433.GE30705@stusta.de> <alpine.LFD.0.999.0708211306560.30176@woody.linux-foundation.org> <20070821202113.GF30705@stusta.de> <27c412eea99f1f80a3002e9668bd31f8@kernel.crashing.org> <20070821212129.GG30705@stusta.de> <1187732978.18410.51.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1187732978.18410.51.camel@localhost.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2007 at 04:49:38PM -0500, James Bottomley wrote:
> On Tue, 2007-08-21 at 23:21 +0200, Adrian Bunk wrote:
> > On Tue, Aug 21, 2007 at 10:49:49PM +0200, Segher Boessenkool wrote:
> > >> How many people e.g. test -rc kernels compiled with gcc 3.2?
> > >
> > > Why would that matter?  It either works or not.  If it doesn't
> > > work, it can either be fixed, or support for that old compiler
> > > version can be removed.
> > 
> > One bug report "kernel doesn't work / crash / ... when compiled with
> > gcc 3.2, but works when compiled with gcc 4.2" will most likely be lost 
> > in the big pile of unhandled bugs, not cause the removal of gcc 3.2 
> > support...
> 
> What's the bugzilla or pointer to this report please?  Those of us who
> use gcc-3 as the default kernel compiler will take it seriously (if it
> looks to have an impact to our kernel builds) otherwise we can tell you
> it's unreproducible/not a problem etc.

This was an example in response to Segher's point we would remove 
support for a gcc version in such a case.

I remember we had such issues, but I don't find any pointer to a 
specific one at the moment.

I'll keep you informed when bug reports come in that only occur with 
older gcc versions and that aren't easily fixable.

> James

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

