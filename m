Return-Path: <linux-kernel-owner+w=401wt.eu-S1752355AbYKLIAR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752355AbYKLIAR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 03:00:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751214AbYKLIAB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 03:00:01 -0500
Received: from monty.telenet-ops.be ([195.130.132.56]:42353 "EHLO
	monty.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbYKLIAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 03:00:00 -0500
Date: Wed, 12 Nov 2008 08:59:55 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: Christoph Lameter <cl@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: Re: next-20081106: undefined reference to `__per_cpu_start'
In-Reply-To: <20081107162114.2a41c623.sfr@canb.auug.org.au>
Message-ID: <Pine.LNX.4.64.0811120859160.13217@anakin>
References: <20081106173645.e7e79071.sfr@canb.auug.org.au>
 <20081106183939.GA26925@x200.localdomain> <Pine.LNX.4.64.0811061310350.6009@quilx.com>
 <20081107162114.2a41c623.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Nov 2008, Stephen Rothwell wrote:
> On Thu, 6 Nov 2008 13:15:07 -0600 (CST) Christoph Lameter <cl@linux-foundation.org> wrote:
> >
> > On Thu, 6 Nov 2008, Alexey Dobriyan wrote:
> > 
> > > On blackfin-BF526-EZBRD and other blackfins:
> > >
> > >   LD      .tmp_vmlinux1
> > > mm/built-in.o: In function `cpu_alloc_init':
> > > (.init.text+0x1486): undefined reference to `__per_cpu_start'
> > > mm/built-in.o: In function `cpu_alloc_init':
> > > (.init.text+0x148c): undefined reference to `__per_cpu_start'
> > > mm/built-in.o: In function `cpu_alloc_init':
> > > (.init.text+0x1492): undefined reference to `__per_cpu_end'
> > > mm/built-in.o: In function `cpu_alloc_init':
> > > (.init.text+0x1496): undefined reference to `__per_cpu_end'
> > 
> > Any contigencies for __per_cpu_start/end in your blackfin vmlinux.lds.h?
> > That is where these symbols are defined
> > 
> > Or did you use generic percpu support and set
> > CONFIG_HAVE_ZERO_BASED_PER_CPU?
> 
> Also a avr32 allnoconfig
> (http://kisskb.ellerman.id.au/kisskb/buildresult/53233/) gets:
> 
> backing-dev.c:(.init.text+0xc4c): undefined reference to `__per_cpu_start'
> backing-dev.c:(.init.text+0xc50): undefined reference to `__per_cpu_end'
> 
> and avr32 defconfig
> (http://kisskb.ellerman.id.au/kisskb/buildresult/53225/) gets:
> 
> vmstat.c:(.init.text+0xff0): undefined reference to `__per_cpu_start'
> vmstat.c:(.init.text+0xff4): undefined reference to `__per_cpu_end'

And m68k defconfig (http://kisskb.ellerman.id.au/kisskb/buildresult/54216/):

| : undefined reference to `__per_cpu_start'
| : undefined reference to `__per_cpu_end'

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
