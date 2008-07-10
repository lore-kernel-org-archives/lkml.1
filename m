Return-Path: <linux-kernel-owner+w=401wt.eu-S1758018AbYGJOqu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758018AbYGJOqu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 10:46:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755080AbYGJOqm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 10:46:42 -0400
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:52050 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754455AbYGJOql (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 10:46:41 -0400
Date: Thu, 10 Jul 2008 16:48:11 +0200
From: Samuel Ortiz <sameo@openedhand.com>
To: Ben Dooks <ben-linux@fluff.org>
Cc: Dmitry <dbaryshkov@gmail.com>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [patch 2/4] MFD: Coding style fixes
Message-ID: <20080710144810.GB2573@sortiz.org>
Reply-To: Samuel Ortiz <sameo@openedhand.com>
References: <20080709104916.200210922@fluff.org> <20080709104932.706237040@fluff.org> <bc64b4640807090411y774949f4q3c0881e93afa50bf@mail.gmail.com> <20080709111256.GM8489@trinity.fluff.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080709111256.GM8489@trinity.fluff.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2008 at 12:12:56PM +0100, Ben Dooks wrote:
> On Wed, Jul 09, 2008 at 03:11:21PM +0400, Dmitry wrote:
> > 2008/7/9 Ben Dooks <ben-linux@fluff.org>:
> > > Fix some coding style fixes in the mfd core driver.
> > >
> > > Signed-off-by: Ben Dooks <ben-linux@fluff.org>
> > 
> > I don't have a strong feeling about this. As it's pretty much only
> > whitespace changes,
> > my feelings are closer to NAK.  Leaving decision to Samuel or Ian.
> 
> The coding style is all over the place, this makes it far more readable.
I agree.
I'll apply it after the merge window as well.

Cheers,
Samuel.


> > >
> > > Index: linux-2.6.26-rc9-next20080709/drivers/mfd/mfd-core.c
> > > ===================================================================
> > > --- linux-2.6.26-rc9-next20080709.orig/drivers/mfd/mfd-core.c   2008-07-09 10:43:54.000000000 +0100
> > > +++ linux-2.6.26-rc9-next20080709/drivers/mfd/mfd-core.c        2008-07-09 10:44:45.000000000 +0100
> > > @@ -16,9 +16,9 @@
> > >  #include <linux/mfd/core.h>
> > >
> > >  static int mfd_add_device(struct platform_device *parent,
> > > -               const struct mfd_cell *cell,
> > > -               struct resource *mem_base,
> > > -               int irq_base)
> > > +                         const struct mfd_cell *cell,
> > > +                         struct resource *mem_base,
> > > +                         int irq_base)
> > >  {
> > >        struct resource res[cell->num_resources];
> > >        struct platform_device *pdev;
> > > @@ -75,11 +75,10 @@ fail_alloc:
> > >        return ret;
> > >  }
> > >
> > > -int mfd_add_devices(
> > > -               struct platform_device *parent,
> > > -               const struct mfd_cell *cells, int n_devs,
> > > -               struct resource *mem_base,
> > > -               int irq_base)
> > > +int mfd_add_devices(struct platform_device *parent,
> > > +                   const struct mfd_cell *cells, int n_devs,
> > > +                   struct resource *mem_base,
> > > +                   int irq_base)
> > >  {
> > >        int i;
> > >        int ret = 0;
> > > Index: linux-2.6.26-rc9-next20080709/include/linux/mfd/core.h
> > > ===================================================================
> > > --- linux-2.6.26-rc9-next20080709.orig/include/linux/mfd/core.h 2008-07-09 10:43:54.000000000 +0100
> > > +++ linux-2.6.26-rc9-next20080709/include/linux/mfd/core.h      2008-07-09 10:44:45.000000000 +0100
> > > @@ -1,5 +1,3 @@
> > > -#ifndef MFD_CORE_H
> > > -#define MFD_CORE_H
> > >  /*
> > >  * drivers/mfd/mfd-core.h
> > >  *
> > > @@ -13,6 +11,9 @@
> > >  *
> > >  */
> > >
> > > +#ifndef MFD_CORE_H
> > > +#define MFD_CORE_H
> > > +
> > >  #include <linux/platform_device.h>
> > >
> > >  /*
> > > @@ -38,17 +39,15 @@ struct mfd_cell {
> > >        const struct resource   *resources;
> > >  };
> > >
> > > -static inline struct mfd_cell *
> > > -mfd_get_cell(struct platform_device *pdev)
> > > +static inline struct mfd_cell *mfd_get_cell(struct platform_device *pdev)
> > >  {
> > >        return (struct mfd_cell *)pdev->dev.platform_data;
> > >  }
> > >
> > > -extern int mfd_add_devices(
> > > -               struct platform_device *parent,
> > > -               const struct mfd_cell *cells, int n_devs,
> > > -               struct resource *mem_base,
> > > -               int irq_base);
> > > +extern int mfd_add_devices(struct platform_device *parent,
> > > +                          const struct mfd_cell *cells, int n_devs,
> > > +                          struct resource *mem_base,
> > > +                          int irq_base);
> > >
> > >  extern void mfd_remove_devices(struct platform_device *parent);
> > >
> > >
> > > --
> > >
> > 
> > 
> > 
> > -- 
> > With best wishes
> > Dmitry
> 
> -- 
> -- 
> Ben
> 
> Q:      What's a light-year?
> A:      One-third less calories than a regular year.
> 
