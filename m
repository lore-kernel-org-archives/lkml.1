Return-Path: <linux-kernel-owner+w=401wt.eu-S1757816AbYGJOp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757816AbYGJOp6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 10:45:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755435AbYGJOpu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 10:45:50 -0400
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:52042 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755424AbYGJOpt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 10:45:49 -0400
Date: Thu, 10 Jul 2008 16:47:14 +0200
From: Samuel Ortiz <sameo@openedhand.com>
To: Dmitry <dbaryshkov@gmail.com>
Cc: Ben Dooks <ben-linux@fluff.org>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [patch 1/4] MFD: Use to_platform_device instead of
	container_of.
Message-ID: <20080710144713.GA2573@sortiz.org>
Reply-To: Samuel Ortiz <sameo@openedhand.com>
References: <20080709104916.200210922@fluff.org> <20080709104932.475821512@fluff.org> <bc64b4640807090410h5448dfc0y6661daade8935107@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bc64b4640807090410h5448dfc0y6661daade8935107@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2008 at 03:10:01PM +0400, Dmitry wrote:
> 2008/7/9 Ben Dooks <ben-linux@fluff.org>:
> > Convert mfd_remove_devices_fn() to use to_platform_device()
> > instead of doing container_of().
> >
> > Signed-off-by: Ben Dooks <ben-linux@fluff.org>
> 
> Acked-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
I'll apply this one after the merge window.

Cheers,
Samuel.


> >
> > Index: linux-2.6.26-rc9-next20080709/drivers/mfd/mfd-core.c
> > ===================================================================
> > --- linux-2.6.26-rc9-next20080709.orig/drivers/mfd/mfd-core.c   2008-07-09 10:13:53.000000000 +0100
> > +++ linux-2.6.26-rc9-next20080709/drivers/mfd/mfd-core.c        2008-07-09 10:14:26.000000000 +0100
> > @@ -99,8 +99,7 @@ EXPORT_SYMBOL(mfd_add_devices);
> >
> >  static int mfd_remove_devices_fn(struct device *dev, void *unused)
> >  {
> > -       platform_device_unregister(
> > -                       container_of(dev, struct platform_device, dev));
> > +       platform_device_unregister(to_platform_device(dev));
> >        return 0;
> >  }
> >
> >
> > --
> >
> 
> 
> 
> -- 
> With best wishes
> Dmitry
