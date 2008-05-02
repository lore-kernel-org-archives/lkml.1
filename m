Return-Path: <linux-kernel-owner+w=401wt.eu-S1761155AbYEBIMF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761155AbYEBIMF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 04:12:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752592AbYEBILs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 04:11:48 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:53524 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752460AbYEBILr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 04:11:47 -0400
Date: Fri, 2 May 2008 11:10:56 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tom Rini <trini@kernel.crashing.org>, torvalds@linux-foundation.org,
       venkatesh.pallipadi@intel.com, davem@davemloft.net, mingo@elte.hu,
       tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org,
       suresh.b.siddha@intel.com, vegard.nossum@gmail.com
Subject: Re: huge gcc 4.1.{0,1} __weak problem
Message-ID: <20080502081056.GA2003@cs181133002.pp.htv.fi>
References: <20080430013108.GA18207@linux-os.sc.intel.com> <20080429.212833.192304794.davem@davemloft.net> <924EFEDD5F540B4284297C4DC59F3DEEF7D18E@orsmsx423.amr.corp.intel.com> <20080501215633.GU29330@cs181133002.pp.htv.fi> <20080501152051.4eb4bad3.akpm@linux-foundation.org> <alpine.LFD.1.10.0805011525460.5994@woody.linux-foundation.org> <20080501153349.f4537ec7.akpm@linux-foundation.org> <20080501232447.GF4354@smtp.west.cox.net> <20080501165945.077d34f9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080501165945.077d34f9.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2008 at 04:59:45PM -0700, Andrew Morton wrote:
> On Thu, 1 May 2008 16:24:47 -0700
> Tom Rini <trini@kernel.crashing.org> wrote:
> > On Thu, May 01, 2008 at 03:33:49PM -0700, Andrew Morton wrote:
> > > 
> > > Drat.  There go my alpha, i386, m68k, s390, sparc and powerpc
> > > cross-compilers.  Vagard, save me!
> > > 
> > > Meanwhile I guess I can locally unpatch that patch.
> > 
> > I know I'll come off as an ass, but you can't make new ones with 4.1.2?
> > It's not like we're talking about gcc 2.95/96 fun here :)
> 
> Honestly, I nearly died when I built all those cross-compilers.  Sooooooo
> many combinations of gcc/binutils/glibc refused to work for obscure
> reasons.  Compilation on x86_64 just didn't work at all and I ended up
> having to build everything on a slow i386 box, etc, etc.  The stream of
> email to Dan got increasingly strident ;)
>...

I have my binutils 2.18.50.0.6 / gcc 4.3 based cross toolchains for an 
i386 host here (no glibc included since I'm using them only for kernel 
testcompiles).

If you are using an x86 machine I can rebuild them without -march=k8 
and give you a copy.

cu
Adrian


-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

