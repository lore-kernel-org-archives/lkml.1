Return-Path: <linux-kernel-owner+w=401wt.eu-S1763034AbXKNTCj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763034AbXKNTCj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 14:02:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753243AbXKNTCc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 14:02:32 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:47247 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821AbXKNTCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 14:02:32 -0500
Date: Wed, 14 Nov 2007 10:54:44 -0800
From: Greg KH <greg@kroah.com>
To: Rob Landley <rob@landley.net>
Cc: linux-kernel@vger.kernel.org, Jeff Dike <jdike@addtoit.com>,
       akpm@linux-foundation.org, Chris Wright <chrisw@sous-sol.org>
Subject: Re: User Mode Linux still broken in 2.6.23.1
Message-ID: <20071114185444.GB14450@kroah.com>
References: <200711032351.52977.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711032351.52977.rob@landley.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 03, 2007 at 11:51:50PM -0500, Rob Landley wrote:
> Building with the attached .config on x86-64, it does this:
> 
>   CC      arch/um/kernel/smp.o
> In file included from include/asm/arch/tlb.h:11,
>                  from include/asm/tlb.h:4,
>                  from arch/um/kernel/smp.c:8:
> include/asm-generic/tlb.h: In function ???tlb_flush_mmu???:
> include/asm-generic/tlb.h:76: error: implicit declaration of function ???release_pages???
> include/asm-generic/tlb.h: In function ???tlb_remove_page???:
> include/asm-generic/tlb.h:105: error: implicit declaration of function ???page_cache_release???
> make[1]: *** [arch/um/kernel/smp.o] Error 1
> make: *** [arch/um/kernel] Error 2
> 
> I've been doing the following to fix it.  I know it's not the right fix,
> (see the earlier thread about it at http://lkml.org/lkml/2007/8/24/441 )
> but could the one line fix go into the -stable queue 2.6.23 while a proper
> fix goes into 2.6.24?

I think the patches that I have just added to the stable queue for
2.6.23.2 will fix this.  If not, please let me know after testing.

thanks,

greg k-h
