Return-Path: <linux-kernel-owner+w=401wt.eu-S1753976AbXLGEYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976AbXLGEYU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 23:24:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752967AbXLGEYD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 23:24:03 -0500
Received: from ns.suse.de ([195.135.220.2]:51543 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752545AbXLGEYA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 23:24:00 -0500
Date: Fri, 7 Dec 2007 05:23:58 +0100
From: Nick Piggin <npiggin@suse.de>
To: Rob Landley <rob@landley.net>
Cc: Jared Hulbert <jaredeh@gmail.com>, carsteno@de.ibm.com,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [patch] ext2: xip check fix
Message-ID: <20071207042358.GC31674@wotan.suse.de>
References: <20071204042628.GA26636@wotan.suse.de> <200712061211.49443.rob@landley.net> <6934efce0712061922j682cee55pc1d5d079465f4849@mail.gmail.com> <200712062217.40355.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712062217.40355.rob@landley.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 06, 2007 at 10:17:39PM -0600, Rob Landley wrote:
> On Thursday 06 December 2007 21:22:25 Jared Hulbert wrote:
> > > > I have'nt looked at it yet. I do appreciate it, I think it might
> > > > broaden the user-base of this feature which is up to now s390 only due
> > > > to the fact that the flash memory extensions have not been implemented
> > > > (yet?). And it enables testing xip on other platforms. The patch is on
> > > > my must-read list.
> > >
> > > query: which feature is currently s390 only?  (Execute In Place?)
> >
> > I think so.  The filemap_xip.c functionality doesn't work for Flash
> > memory yet.  Flash memory doesn't have struct pages to back it up with
> > which this stuff depends on.
> 
> Um, trying to clarify:  S390.  Also known as zSeries, big iron machine, uses 
> its own weird processor design rather than x86, x86-64, arm, or mips 
> processors.
> 
> How does "struct page" enter into this?
> 
> What I want to know is, are you saying execute in place doesn't work on things 
> like arm and mips?  (I so, I was unaware of this.  I heard about somebody 
> getting it to work on a Nintendo DS: 
> http://forums.maxconsole.net/showthread.php?t=18668 )

It's just that the only device driver with XIP support for the moment is
s390 (and an obscure powerpc one).

Now with my ramdisk patch, anybody can use it. That's just using regular
RAM, but there is nothing preventing XIP backed by more exotic storage,
provided the CPU can natively address and execute from it.
 
