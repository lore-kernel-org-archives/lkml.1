Return-Path: <linux-kernel-owner+w=401wt.eu-S1756240AbYFZQXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240AbYFZQXi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 12:23:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751985AbYFZQX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 12:23:29 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:37812 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942AbYFZQX2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 12:23:28 -0400
Date: Thu, 26 Jun 2008 19:21:18 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: monstr@seznam.cz, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com,
       john.williams@petalogix.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       grant.likely@secretlab.ca, linuxppc-dev@ozlabs.org,
       vapier.adi@gmail.com, alan@lxorguk.ukuu.org.uk, hpa@zytor.com,
       Michal Simek <monstr@monstr.eu>
Subject: Re: [PATCH 48/60] microblaze_v4: headers simple files - empty or
	redirect to asm-generic
Message-ID: <20080626162118.GG22025@cs181140183.pp.htv.fi>
References: <1214483429-32360-1-git-send-email-monstr@seznam.cz> <1214483429-32360-48-git-send-email-monstr@seznam.cz> <1214483429-32360-49-git-send-email-monstr@seznam.cz> <200806261735.12738.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200806261735.12738.arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 05:35:11PM +0200, Arnd Bergmann wrote:
> On Thursday 26 June 2008, monstr@seznam.cz wrote:
> > +
> > +#ifndef _ASM_MICROBLAZE_NAMEI_H
> > +#define _ASM_MICROBLAZE_NAMEI_H
> > +
> > +#ifdef __KERNEL__
> > +
> > +/* This dummy routine maybe changed to something useful
> > + * for /usr/gnemul/ emulation stuff.
> > + * Look at asm-sparc/namei.h for details.
> > + */
> > +#define __emul_prefix() NULL
> > +
> > +#endif /* __KERNEL__ */
> > +
> > +#endif /* _ASM_MICROBLAZE_NAMEI_H */
> 
> Could you move this to asm-generic? Note that the comment is wrong,
> asm-sparc doesn't actually implement it any more, only ia64, mips and
> arm have an implementation that actually does something interesting
> here.

The comment could be nuked (as well as the #ifdef __KERNEL__), but for 
the one #define an asm-generic header would IMHO be overkill.

> 	Arnd <><

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

