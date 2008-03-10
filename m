Return-Path: <linux-kernel-owner+w=401wt.eu-S1754350AbYCJNLs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754350AbYCJNLs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 09:11:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751665AbYCJNLi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 09:11:38 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55635 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751606AbYCJNLi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 09:11:38 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: Linux 2.6.25-rc4
Date: Mon, 10 Mar 2008 14:10:27 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Anders Eriksson <aeriksson@fastmail.fm>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.1.00.0803042044460.12253@woody.linux-foundation.org> <20080310085539.6815693C900@tippex.mynet.homeunix.org> <200803101336.56159.bzolnier@gmail.com>
In-Reply-To: <200803101336.56159.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803101410.27877.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 10 of March 2008, Bartlomiej Zolnierkiewicz wrote:
> On Monday 10 March 2008, Anders Eriksson wrote:
> > 
> > aeriksson@fastmail.fm said:
> > > torvalds@linux-foundation.org said:
> > >> I think we do want the bisect run here.
> > >> My worry is that this is likely very timing-sensitive, so when it starts
> > >> failing it might not be because of the commit that actually introduces the
> > >> bug, but because some other timing changed, but with some luck that won't  
> > >> be the case.
> > 
> > > I'm on it. Slow machine. Household's router, 4000 versions to go... 
> > 
> > The bisect came up with this:
> > 
> > 18a056feccabdfa9764016a615121b194828bc72 is first bad commit
> > commit 18a056feccabdfa9764016a615121b194828bc72
> 
> Hmm, this is the first commit _after_ the previous "guilty"
> commit 852738f39258deafb3d89c187cb1a4050820d555 so it just
> can't be the "real bad" one...

Well, would that be practical to prepare a patch reverting this commit
and whatever depends on it so that Anders can verify it?

Rafael
