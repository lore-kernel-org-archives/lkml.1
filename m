Return-Path: <linux-kernel-owner+w=401wt.eu-S1756411AbXHUVtz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756411AbXHUVtz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 17:49:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752286AbXHUVtm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 17:49:42 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:56217 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751673AbXHUVtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 17:49:41 -0400
Subject: Re: RFC: drop support for gcc < 4.0
From: James Bottomley <James.Bottomley@SteelEye.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Segher Boessenkool <segher@kernel.crashing.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jarek Poplawski <jarkao2@o2.pl>, Andi Kleen <ak@suse.de>,
       linux-arch@vger.kernel.org, Randy Dunlap <randy.dunlap@oracle.com>
In-Reply-To: <20070821212129.GG30705@stusta.de>
References: <20070821132038.GA22254@ff.dom.local>
	 <20070821093103.3c097d4a.randy.dunlap@oracle.com>
	 <20070821173550.GC30705@stusta.de> <20070821191959.GC2642@bingen.suse.de>
	 <20070821195433.GE30705@stusta.de>
	 <alpine.LFD.0.999.0708211306560.30176@woody.linux-foundation.org>
	 <20070821202113.GF30705@stusta.de>
	 <27c412eea99f1f80a3002e9668bd31f8@kernel.crashing.org>
	 <20070821212129.GG30705@stusta.de>
Content-Type: text/plain
Date: Tue, 21 Aug 2007 16:49:38 -0500
Message-Id: <1187732978.18410.51.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-08-21 at 23:21 +0200, Adrian Bunk wrote:
> On Tue, Aug 21, 2007 at 10:49:49PM +0200, Segher Boessenkool wrote:
> >> How many people e.g. test -rc kernels compiled with gcc 3.2?
> >
> > Why would that matter?  It either works or not.  If it doesn't
> > work, it can either be fixed, or support for that old compiler
> > version can be removed.
> 
> One bug report "kernel doesn't work / crash / ... when compiled with
> gcc 3.2, but works when compiled with gcc 4.2" will most likely be lost 
> in the big pile of unhandled bugs, not cause the removal of gcc 3.2 
> support...

What's the bugzilla or pointer to this report please?  Those of us who
use gcc-3 as the default kernel compiler will take it seriously (if it
looks to have an impact to our kernel builds) otherwise we can tell you
it's unreproducible/not a problem etc.

James


> > The only other policy than "only remove support if things are
> > badly broken" would be "only support what the GCC team supports",
> > which would be >= 4.1 now; and there are very good arguments for
> > supporting more than that with the Linux kernel.
> 
> No, it's not about bugs in gcc, it's about kernel+gcc combinations that 
> are mostly untested but officially supported.
> 
> E.g. how many kernel developers use kernels compiled without 
> unit-at-a-time? And unit-at-a-time does paper over some bugs,
> e.g. at about half a dozen section mismatch bugs I've fixed
> recently are not present with it.
> 
> But as the discussions have shown gcc 4.0 is currently too high for 
> making a cut, and it is not yet the right time for raising the minimum 
> required gcc version.
> 
> > Segher
> 
> cu
> Adrian
> 

