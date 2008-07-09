Return-Path: <linux-kernel-owner+w=401wt.eu-S1757486AbYGILM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757486AbYGILM3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 07:12:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753708AbYGILMV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 07:12:21 -0400
Received: from trinity.fluff.org ([89.145.97.151]:59769 "EHLO
	trinity.fluff.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753675AbYGILMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 07:12:20 -0400
Date: Wed, 9 Jul 2008 12:12:15 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: Dmitry <dbaryshkov@gmail.com>
Cc: Ben Dooks <ben-linux@fluff.org>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk, sameo@openedhand.com
Subject: Re: [patch 3/4] MFD: Remove unnecessary fields if mfd_cell structure.
Message-ID: <20080709111215.GL8489@trinity.fluff.org>
References: <20080709104916.200210922@fluff.org> <20080709104932.905074060@fluff.org> <bc64b4640807090409h2ebb8f4embae20b8511fbe459@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bc64b4640807090409h2ebb8f4embae20b8511fbe459@mail.gmail.com>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.9i
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2008 at 03:09:12PM +0400, Dmitry wrote:
> 2008/7/9 Ben Dooks <ben-linux@fluff.org>:
> > The enable,disable,suspend and resume entry in the struct mfd_cell
> > do not seem to be necessary as they should be handled by the
> > platform driver that the device created has bound to.
> 
> NAK. It's used e.g. by the tmio-nand driver. These fields provide easy
> way to support
> enhanced power management, etc.

What enhancements over the standard platform device model do you need?
 
> >
> > Signed-off-by: Ben Dooks <ben-linux@fluff.org>
> >
> > Index: linux-2.6.26-rc9-next20080709/include/linux/mfd/core.h
> > ===================================================================
> > --- linux-2.6.26-rc9-next20080709.orig/include/linux/mfd/core.h 2008-07-09 10:44:45.000000000 +0100
> > +++ linux-2.6.26-rc9-next20080709/include/linux/mfd/core.h      2008-07-09 10:45:06.000000000 +0100
> > @@ -23,12 +26,6 @@
> >  */
> >  struct mfd_cell {
> >        const char              *name;
> > -
> > -       int                     (*enable)(struct platform_device *dev);
> > -       int                     (*disable)(struct platform_device *dev);
> > -       int                     (*suspend)(struct platform_device *dev);
> > -       int                     (*resume)(struct platform_device *dev);
> > -
> >        void                    *driver_data; /* driver-specific data */
> >
> >        /*
> >
> > --
> >
> 
> 
> 
> -- 
> With best wishes
> Dmitry

-- 
-- 
Ben

Q:      What's a light-year?
A:      One-third less calories than a regular year.

