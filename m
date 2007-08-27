Return-Path: <linux-kernel-owner+w=401wt.eu-S1753924AbXH0IeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924AbXH0IeT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 04:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751379AbXH0IeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 04:34:12 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:41094 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751182AbXH0IeL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 04:34:11 -0400
Date: Mon, 27 Aug 2007 10:35:07 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Adrian Bunk <bunk@kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: binutils trouble was Re: [1/2] 2.6.23-rc3: known regressions with patches
Message-ID: <20070827083507.GA18594@uranus.ravnborg.org>
References: <46C09C1A.7050706@googlemail.com> <20070813184204.GA6071@one.firstfloor.org> <6bffcb0e0708131324x29211ef5sd5154d44f0c2e79f@mail.gmail.com> <20070813205653.GA7069@one.firstfloor.org> <20070813212947.GK18945@stusta.de> <20070813224205.GA8760@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070813224205.GA8760@one.firstfloor.org>
User-Agent: Mutt/1.4.2.1i
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
> 
> sles8 (2.12.90.0.15; it was really one of the first production
> binutils for x86-64) doesn't work out of the box (looks like as-instr doesn't 
> work anymore and it has another assembler issue I'll fix) 
> but with that workarounded it also builds a reasonble looking vdso
> 
> Sam, can you please take a look at the as-instr issue? It seems
> to succeed now when it should fail.
> 
> It would be useful if someone could find out which binutils versions
> really not work.

Hi Andi.
I never got around to do any exhaustive check on as-instr.
I assume it was the .cfi_rel_offset thing that caused you to
assume as-instr was failing?
If not let me know if your request is still valid.

And sorry for being late on this. Busy and had forgotten this mail.

	Sam
