Return-Path: <linux-kernel-owner+w=401wt.eu-S1765794AbXHMWyj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765794AbXHMWyj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 18:54:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754719AbXHMWyW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 18:54:22 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:54176 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753492AbXHMWyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 18:54:21 -0400
Date: Tue, 14 Aug 2007 00:54:10 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, sam@ravnborg.org,
       Andre Noll <maan@systemlinux.org>
Subject: Re: binutils trouble was Re: [1/2] 2.6.23-rc3: known regressions
	with patches
Message-ID: <20070813225409.GN18945@stusta.de>
References: <46C09C1A.7050706@googlemail.com> <20070813184204.GA6071@one.firstfloor.org> <6bffcb0e0708131324x29211ef5sd5154d44f0c2e79f@mail.gmail.com> <20070813205653.GA7069@one.firstfloor.org> <20070813212947.GK18945@stusta.de> <20070813224205.GA8760@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070813224205.GA8760@one.firstfloor.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2007 at 12:42:05AM +0200, Andi Kleen wrote:
> On Mon, Aug 13, 2007 at 11:29:47PM +0200, Adrian Bunk wrote:
> > Debian 4.0 has older ones, and all distributions released more than a 
> > year ago for sure also have older ones (the required patch went into 
> > binutils CVS on 2006-05-30 and 2.17.50.0.3 was released on 2006-07-15).
> 
> I have no problem on SUSE 10.0 (2.16.91.0.2-8) or SLES9 (2.15.90.0.1.1-32.10) 
> which are both far older than a year.  Both produce good looking
> vdso.sos.

OK sorry, then I misunderstood it and missing -Wl,-z,max-page-size=4096 
-Wl,-z,common-page-size=4096 support is not the problem.

> sles8 (2.12.90.0.15; it was really one of the first production
> binutils for x86-64) doesn't work out of the box (looks like as-instr doesn't 
> work anymore and it has another assembler issue I'll fix) 
> but with that workarounded it also builds a reasonble looking vdso

We had several reports of 2.12* not working (AFAIR also on i386), so 
that's not a surprise.

> Sam, can you please take a look at the as-instr issue? It seems
> to succeed now when it should fail.
> 
> It would be useful if someone could find out which binutils versions
> really not work.

If Andre is working under Debian 3.1 (as his gcc version indicates) he's 
using 2.15, and together with your SLES9 test it seems the border is 
somewhere between 2.15 and 2.16.

> -Andi

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

