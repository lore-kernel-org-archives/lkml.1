Return-Path: <linux-kernel-owner+w=401wt.eu-S934905AbXGMSff@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934905AbXGMSff (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 14:35:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760194AbXGMSf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 14:35:28 -0400
Received: from waste.org ([66.93.16.53]:48588 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756939AbXGMSf1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 14:35:27 -0400
Date: Fri, 13 Jul 2007 13:35:06 -0500
From: Matt Mackall <mpm@selenic.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [rfc][patch] slob: improvements
Message-ID: <20070713183506.GN11115@waste.org>
References: <20070515084305.GA28631@wotan.suse.de> <20070515151731.GO11115@waste.org> <20070515233347.GA20468@wotan.suse.de> <20070713112725.d75acf1d.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070713112725.d75acf1d.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2007 at 11:27:25AM -0700, Randy Dunlap wrote:
> > Index: linux-2.6/init/Kconfig
> > ===================================================================
> > --- linux-2.6.orig/init/Kconfig
> > +++ linux-2.6/init/Kconfig
> > @@ -529,7 +529,7 @@ config SLUB
> >  	   way and has enhanced diagnostics.
> >  
> >  config SLOB
> > -	depends on EMBEDDED && !SPARSEMEM
> > +	depends on EMBEDDED && !SPARSEMEM && !ARCH_USES_SLAB_PAGE_STRUCT
> >  	bool "SLOB (Simple Allocator)"
> >  	help
> >  	   SLOB replaces the SLAB allocator with a drastically simpler
> 
> Is this patch going in?  I have a randconfig (2.6.22) with
> CONFIG_SLOB=y
> CONFIG_NUMA=y
> CONFIG_SMP=y
> The kernel build fails with these config symbols set like that.
> It looks like SLOB needs that additional
> 	&& !ARCH_USES_SLAB_PAGE_STRUCT
> (or 	&& !SMP)

I think Andrew intends to push it to 2.6.23, yes.

-- 
Mathematics is the supreme nostalgia of our time.
