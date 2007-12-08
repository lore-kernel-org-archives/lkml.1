Return-Path: <linux-kernel-owner+w=401wt.eu-S1754025AbXLHV6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025AbXLHV6X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 16:58:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752347AbXLHV6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 16:58:14 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:33295 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752203AbXLHV6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 16:58:13 -0500
Date: Sat, 8 Dec 2007 22:58:11 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       Pierre Ossman <drzeus@drzeus.cx>, Al Viro <viro@ftp.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, Marcel Holtmann <marcel@holtmann.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org, Jon Masters <jonathan@jonmasters.org>
Subject: Re: Correct types for mod_devicetable.h (was: Re: m68k build
	failure)
Message-ID: <20071208215811.GD20441@stusta.de>
References: <20071127220723.e2e3d0b4.akpm@linux-foundation.org> <20071201215602.7a4710d9@poseidon.drzeus.cx> <Pine.LNX.4.64.0712021219430.29349@anakin> <200712032102.20353.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200712032102.20353.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 03, 2007 at 09:02:19PM +1100, Rusty Russell wrote:
> On Sunday 02 December 2007 22:22:31 Geert Uytterhoeven wrote:
> > On Sat, 1 Dec 2007, Pierre Ossman wrote:
> > > Yeah, that could work. Have a header with stuff like this:
> > >
> > > typedef u16 __attribute__((aligned(2))) aligned_u16;
> > > typedef u32 __attribute__((aligned(4))) aligned_u32;
> >
> > I gave it a try:
> 
> This seems to turn a molehill into a mountain.
> 
> We can change that mod_devicetable.h at any time; it's not supposed to be a 
> userspace API (the kernel build system doesn't count).

module-init-tools is userspace and not shipped as part of the kernel 
build system...

> So, just insert two bits of padding in sdio_device_id and insert a comment 
> saying "/* Explicit padding: works even if we're cross-compiling */".

We had one such problem in 2.6.23 and now we had a similar one in 2.6.24.

Getting the alignment issues automatically right would really be an 
improvement...

> Thanks,
> Rusty.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

