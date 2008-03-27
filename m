Return-Path: <linux-kernel-owner+w=401wt.eu-S1761789AbYC0NWo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761789AbYC0NWo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 09:22:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755883AbYC0NWe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 09:22:34 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:60978 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756697AbYC0NWd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 09:22:33 -0400
Date: Thu, 27 Mar 2008 15:22:21 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Jan Dittmer <jdi@l4x.org>
Cc: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for March 27
Message-ID: <20080327132221.GA29701@cs181133002.pp.htv.fi>
References: <20080327183357.7c637aed.sfr@canb.auug.org.au> <20080327104224.2b98b561@hskinnemo-gx620.norway.atmel.com> <20080327104745.GA1686@cs181133002.pp.htv.fi> <20080327123226.452f0a3f@hskinnemo-gx620.norway.atmel.com> <20080327115459.GB1686@cs181133002.pp.htv.fi> <621d098f0803270554j287ce58eme4b0e52cb6470154@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <621d098f0803270554j287ce58eme4b0e52cb6470154@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27, 2008 at 01:54:23PM +0100, Jan Dittmer wrote:
> On Thu, Mar 27, 2008 at 12:54 PM, Adrian Bunk <bunk@kernel.org> wrote:
> > On Thu, Mar 27, 2008 at 12:32:26PM +0100, Haavard Skinnemoen wrote:
> >  > On Thu, 27 Mar 2008 12:47:45 +0200
> >  > Adrian Bunk <bunk@kernel.org> wrote:
> >  >
> >  > > According to Jan's page, there's still a build error with the defconfig:
> >  > >   http://l4x.org/k/?d=40450#err
> >  >
> >  > Hmm...that must be a pretty ancient toolchain.
> 
> That's the toolchain from back when avr32 was first integrated in the
> kernel. So it may be outdated, but I didn't read any statement on
> the contrary. I tend to keep the toolchains stable as long as
> possible.
> 
> >  > FWIW, a more recent toolchain is available here:
> >  >
> >  > http://avr32linux.org/twiki/bin/view/Main/BinutilsPatches
> >  > http://avr32linux.org/twiki/bin/view/Main/GccPatches
> 
> So how can I get notified if I need a more recent toolchain?
> IMHO every architecture should have a file somewhere (in
> the kernel tree) where the required toolchain versions are
> listed and required patches are linked. That would make it
> such discussions unnecessary.

Even more important, all architectures should get all their 
required patches into upstream binutils and gcc.

There might be some time at the beginning of a port until this state is 
reached, but for the majority of our architectures plain upstream
binutils 2.18.50.0.5 and gcc 4.3.0 already give a successful kernel 
build.

And I'm regularly poking arch maintainers to get their binutils and gcc 
patches upstream.

Regarding "required toolchain versions" - I'm not even sure anyone 
really knows what the minimum binutils version for x86 is...

> Jan

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

