Return-Path: <linux-kernel-owner+w=401wt.eu-S1764639AbYD0UwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764639AbYD0UwS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 16:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751754AbYD0UwE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 16:52:04 -0400
Received: from mail.gmx.net ([213.165.64.20]:35583 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751118AbYD0UwB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 16:52:01 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX192DO1HpZB2+GvaQhWsCXtgksSqBtkPBS1lTxPUqi
	KckKHBSOMbe2TS
Subject: Re: [PATCH] prepare kconfig inline optimization for all
	architectures
From: Mike Galbraith <efault@gmx.de>
To: Adrian Bunk <bunk@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       linux arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>
In-Reply-To: <20080427174714.GB2252@cs181133002.pp.htv.fi>
References: <20080427105100.GA14795@uranus.ravnborg.org>
	 <20080427113158.GY2252@cs181133002.pp.htv.fi>
	 <alpine.LFD.1.10.0804271002360.2896@woody.linux-foundation.org>
	 <20080427172235.GA2252@cs181133002.pp.htv.fi>
	 <alpine.LFD.1.10.0804271029130.2896@woody.linux-foundation.org>
	 <20080427174714.GB2252@cs181133002.pp.htv.fi>
Content-Type: text/plain
Date: Sun, 27 Apr 2008 22:51:54 +0200
Message-Id: <1209329514.4868.57.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2008-04-27 at 20:47 +0300, Adrian Bunk wrote:
> On Sun, Apr 27, 2008 at 10:32:28AM -0700, Linus Torvalds wrote:
> > 
> > 
> > On Sun, 27 Apr 2008, Adrian Bunk wrote:
> > > 
> > > I'm looking at it from a different angle, all code in the kernel should 
> > > follow the following rules [1]:
> > > - no functions in .c files should be marked inline
> > > - all functions in headers should be static inline
> > > - all functions in headers should either be very small or collapse
> > >   to become very small after inlining
> > > 
> > > I can simply not see any usecase for a non-forced inline in the kernel,
> > > and fixing the kernel should give a superset of the space savings of 
> > > this "inline optimization".
> > 
> > Your whole argument is premised on the assumption that the compiler does 
> > the right thing.
> >...
> 
> No, you seem to be misunderstanding what I am saying.
> 
> Status Quo as of 2.6.25:
> - we force the compiler to always inline with "inline"

What is wrong with that?  I believe the term is 'directive'.

> - we have inline's in .c files and too big functions in headers, and
>   both of them are wrong

Yes, correct the source.

> "inline optimization":
> - we leave the compiler the choice whether or not to inline with "inline"

How did it come to pass that we invented such a thing as an optional
directive?

	-Mike

