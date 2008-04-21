Return-Path: <linux-kernel-owner+w=401wt.eu-S1754091AbYDUVDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091AbYDUVDR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 17:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751314AbYDUVDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 17:03:05 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:58901 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750905AbYDUVDE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 17:03:04 -0400
Date: Tue, 22 Apr 2008 00:02:32 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Alexey Starikovskiy <astarikovskiy@suse.de>, tglx@linutronix.de,
       hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: Voyager phys_cpu_present_map compile error
Message-ID: <20080421210232.GD2633@cs181133002.pp.htv.fi>
References: <20080421000238.GD26897@cs181133002.pp.htv.fi> <20080421085314.GI26897@cs181133002.pp.htv.fi> <20080421120054.GA6788@elte.hu> <1208793533.3640.24.camel@localhost.localdomain> <20080421195148.GG8770@elte.hu> <20080421200949.GB2633@cs181133002.pp.htv.fi> <20080421201352.GM8770@elte.hu> <20080421202605.GC2633@cs181133002.pp.htv.fi> <20080421202919.GA28069@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080421202919.GA28069@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2008 at 10:29:19PM +0200, Ingo Molnar wrote:
> 
> * Adrian Bunk <bunk@kernel.org> wrote:
> 
> > On Mon, Apr 21, 2008 at 10:13:52PM +0200, Ingo Molnar wrote:
> > > 
> > > * Adrian Bunk <bunk@kernel.org> wrote:
> > > 
> > > > > ok, that's good enough - that's why i excluded it from the auto-qa 
> > > > > test-space as well. Adrian, could you please remove it from your 
> > > > > config testset as well? If a user enables that config option it wont 
> > > > > boot anyway so it's not a problem in practice.
> > > > 
> > > > Who said that Voyager won't boot?
> > > 
> > > Adrian, you build Voyager kernels so just try to boot it once on 
> > > your PC and watch the show ...
> > 
> > Ingo, an ia64 kernel also won't boot on my computer, and I'll still 
> > compile test my patches for ia64 ...
> 
> dont be silly... the ia64 kernel is not under arch/x86, it's not even 
> the same instruction format. Voyager runs on x86 CPUs and is part of the 
> x86 architecture tree.

Your point is?

I'm compile testing 22 architectures (especially when sending my own 
patches), and whether a kernel would boot on my computer doesn't make 
any difference.

Why do you as an architecture maintainer want me to no longer spend my 
spare time on compile testing one of the subarchitectures of your 
architecture?

Other architecture maintainers tend to say "thanks for your bug report" 
and "thanks for your patch" when I'm sending bug reports and patches for 
platforms that have userbases comparable to Voyager...

> 	Ingo

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

