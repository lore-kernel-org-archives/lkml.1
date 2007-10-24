Return-Path: <linux-kernel-owner+w=401wt.eu-S1757927AbXJXMTg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757927AbXJXMTg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 08:19:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753254AbXJXMT3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 08:19:29 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:46172 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624AbXJXMT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 08:19:28 -0400
Date: Wed, 24 Oct 2007 08:15:43 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Sam Ravnborg <sam@ravnborg.org>
cc: Jens Axboe <jens.axboe@oracle.com>,
       Haavard Skinnemoen <hskinnemoen@atmel.no>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PATCH] Fix asm-avr32/dma-mapping.h breakage
In-Reply-To: <20071024112938.GA1770@uranus.ravnborg.org>
Message-ID: <Pine.LNX.4.64.0710240814570.31881@localhost.localdomain>
References: <20071024132220.14070582@dhcp-255-175.norway.atmel.com>
 <20071024112453.GP14671@kernel.dk> <20071024112938.GA1770@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Oct 2007, Sam Ravnborg wrote:

> On Wed, Oct 24, 2007 at 01:24:53PM +0200, Jens Axboe wrote:
> > On Wed, Oct 24 2007, Haavard Skinnemoen wrote:
> > > Hi Linus,
> > >
> > > Sorry about sending you pull requests so rapidly, but Jens broke my
> > > dma-mapping.h yesterday. Or you may say the bug was there to begin with
> > > and Jens merely exposed it, but that makes it sound like my fault ;-)
> > >
> > > Anyway, please pull from
> > >
> > >   ssh://master.kernel.org/pub/scm/linux/kernel/git/hskinnemoen/avr32-2.6.git for-linus
> > >
> > > to receive the following update.
> >
> > You should not take the blame :-)
> >
> > I'm collecting these patches, so I'll pull your fix and make sure it
> > gets to Linus today along with the other fixes.
>
> How about doing a "git grep asm/scatterlist"
> and fix all victims to use linux/scatterlist?
> Or you maybe did this already.

i was just about to ask -- is this one of those cases where the asm
versions of scatterlist.h should have a warning/error that they should
not be included directly, and to include linux/scatterlist.h instead?

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
