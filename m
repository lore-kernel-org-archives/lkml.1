Return-Path: <linux-kernel-owner+w=401wt.eu-S1758599AbXHJAoK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758599AbXHJAoK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 20:44:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755845AbXHJAnz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 20:43:55 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:59277 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755867AbXHJAny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 20:43:54 -0400
Date: Fri, 10 Aug 2007 02:43:40 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Shannon Nelson <shannon.nelson@intel.com>, linux-kernel@vger.kernel.org,
       Wolfgang Denk <wd@denx.de>
Subject: Re: [-mm patch] DMA engine kconfig improvements
Message-ID: <20070810004340.GC18938@stusta.de>
References: <20070725040304.111550f4.akpm@linux-foundation.org> <20070726052628.GL3572@stusta.de> <e9c3a7c20708031915y1fee8c62i9da0f42cddbb44dd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <e9c3a7c20708031915y1fee8c62i9da0f42cddbb44dd@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 03, 2007 at 07:15:31PM -0700, Dan Williams wrote:
> On 7/25/07, Adrian Bunk <bunk@stusta.de> wrote:
> > On Wed, Jul 25, 2007 at 04:03:04AM -0700, Andrew Morton wrote:
> > >...
> > > Changes since 2.6.22-rc6-mm1:
> > >...
> > > +dma-arch-fix.patch
> > >
> > >  Fix git-dma.patch
> > >...
> >
> > This results in an ARM-only driver in an X86-only menu...
> >
> > What about the patch below instead that also improves a few other things?
> I like it, just a few nits:
> 
> > -menu "DMA Engine support"
> > -       depends on HAS_DMA
> > +menuconfig DMADEVICES
> > +       bool "DMA Engine support"
> > +       depends on (PCI && X86) || ARCH_IOP32X || ARCH_IOP33X || ARCH_IOP13XX
> > +       help
> > +         Intel(R) DMA engines
> > +
> Perhaps we should go ahead and define ARCH_HAS_DMA_OFFLOAD and have
> DMADEVICES depend on that option.  A ppc32 driver is in the works:
> http://marc.info/?l=linux-raid&m=117400143317440&w=2
>...

That would be overkill - what my patch does here is just a minor 
cosmetical thing that could be dropped if it would become a problem.

> Regards,
> Dan (for Shannon while he is on vacation)

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

