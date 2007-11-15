Return-Path: <linux-kernel-owner+w=401wt.eu-S1757148AbXKOGDW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757148AbXKOGDW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 01:03:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751174AbXKOGDO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 01:03:14 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:34803 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbXKOGDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 01:03:13 -0500
Date: Wed, 14 Nov 2007 22:02:55 -0800
From: Greg KH <greg@kroah.com>
To: Rob Landley <rob@landley.net>
Cc: linux-kernel@vger.kernel.org, Jeff Dike <jdike@addtoit.com>,
       akpm@linux-foundation.org, Chris Wright <chrisw@sous-sol.org>
Subject: Re: User Mode Linux still broken in 2.6.23.1
Message-ID: <20071115060255.GA4837@kroah.com>
References: <200711032351.52977.rob@landley.net> <20071114185444.GB14450@kroah.com> <200711142358.16072.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711142358.16072.rob@landley.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2007 at 11:58:15PM -0600, Rob Landley wrote:
> On Wednesday 14 November 2007 12:54:44 Greg KH wrote:
> > On Sat, Nov 03, 2007 at 11:51:50PM -0500, Rob Landley wrote:
> > > Building with the attached .config on x86-64, it does this:
> > >
> > >   CC      arch/um/kernel/smp.o
> > > In file included from include/asm/arch/tlb.h:11,
> > >                  from include/asm/tlb.h:4,
> > >                  from arch/um/kernel/smp.c:8:
> > > include/asm-generic/tlb.h: In function ???tlb_flush_mmu???:
> > > include/asm-generic/tlb.h:76: error: implicit declaration of function
> > > ???release_pages??? include/asm-generic/tlb.h: In function
> > > ???tlb_remove_page???:
> > > include/asm-generic/tlb.h:105: error: implicit declaration of function
> > > ???page_cache_release??? make[1]: *** [arch/um/kernel/smp.o] Error 1
> > > make: *** [arch/um/kernel] Error 2
> > >
> > > I've been doing the following to fix it.  I know it's not the right fix,
> > > (see the earlier thread about it at http://lkml.org/lkml/2007/8/24/441 )
> > > but could the one line fix go into the -stable queue 2.6.23 while a
> > > proper fix goes into 2.6.24?
> >
> > I think the patches that I have just added to the stable queue for
> > 2.6.23.2 will fix this.  If not, please let me know after testing.
> 
> Where do I find these patches to test?  I know where to find the stable 
> releases, but not the "stable queue".
> 
> Documentation/stable_kernel_rules.txt just says there _is_ a stable queue, not 
> where to access it.  Google's first hit for "linux stable queue" was
> http://git.kernel.org/?p=linux/kernel/git/chrisw/stable-queue.git;a=shortlog 
> which apparently stopped updating in march...
> 
> Happy to test the patch you mentioned, if I can figure out where to find it...

It's at:
	http://git.kernel.org/?p=linux/kernel/git/stable/stable-queue.git;a=summary

Chris and I used to have separate queues, but that got messy, I suppose
we should just delete those old copies...

thanks,

greg k-h
