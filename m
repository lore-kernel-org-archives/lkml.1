Return-Path: <linux-kernel-owner+w=401wt.eu-S933261AbYAaQXy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933261AbYAaQXy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 11:23:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757802AbYAaQXq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 11:23:46 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:35258 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757599AbYAaQXq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 11:23:46 -0500
Date: Thu, 31 Jan 2008 18:24:23 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [git pull] x86 arch updates for v2.6.25
Message-ID: <20080131162423.GD19700@cs181133002.pp.htv.fi>
References: <20080130011550.GA31853@elte.hu> <20080131155739.GA19700@cs181133002.pp.htv.fi> <20080131160033.GA11501@elte.hu> <20080131161235.GB19700@cs181133002.pp.htv.fi> <20080131161523.GA12347@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080131161523.GA12347@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2008 at 05:15:23PM +0100, Ingo Molnar wrote:
> 
> * Adrian Bunk <bunk@kernel.org> wrote:
> 
> > On Thu, Jan 31, 2008 at 05:00:33PM +0100, Ingo Molnar wrote:
> > > 
> > > * Adrian Bunk <bunk@kernel.org> wrote:
> > > 
> > > > You tested x86 but broke more than half a dozen other archtectures, 
> > > > with at least 3 different commits breaking other architectures.
> > > 
> > > Note that all known breakages are fixed in current -git, except for the 
> > > s390 problem that Martin/Nick posted the fix.
> > 
> > What about the breakages caused by commit 
> > a5a19c63f4e55e32dc0bc3d936d7f94793d8b380 (this commit broke the 
> > defconfig compilation on at least avr32, blackfin, sh, sparc and uml)?
> 
> the patch below fixes that.

Is it safe, or why did Jeremy state in the commit
"I removed this include to avoid an include cycle"?

> 	Ingo
> 
> ---
>  include/asm-generic/tlb.h |    1 +
>  1 file changed, 1 insertion(+)
> 
> Index: linux/include/asm-generic/tlb.h
> ===================================================================
> --- linux.orig/include/asm-generic/tlb.h
> +++ linux/include/asm-generic/tlb.h
> @@ -15,6 +15,7 @@
>  
>  #include <linux/swap.h>
>  #include <linux/quicklist.h>
> +#include <asm/pgalloc.h>
>  #include <asm/tlbflush.h>
>  
>  /*

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

