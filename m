Return-Path: <linux-kernel-owner+w=401wt.eu-S1753506AbYLPRR4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506AbYLPRR4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 12:17:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750998AbYLPRRs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 12:17:48 -0500
Received: from ns2.suse.de ([195.135.220.15]:37257 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750981AbYLPRRr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 12:17:47 -0500
Date: Tue, 16 Dec 2008 09:16:46 -0800
From: Greg KH <gregkh@suse.de>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: hjk@linutronix.de, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: adding of_platform_drivers (was: Re: [RESEND][PATCH] uio: Add
	of_platform_driver to uio_pdrv_genirq)
Message-ID: <20081216171646.GA12812@suse.de>
References: <1229007937-5501-1-git-send-email-w.sang@pengutronix.de> <20081211205033.GA7080@suse.de> <20081216122731.GC3275@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081216122731.GC3275@pengutronix.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2008 at 01:27:32PM +0100, Wolfram Sang wrote:
> > > +/* ---------------------------------------------------------------------
> > > + * OF bus binding
> > > + */
> > > +
> > > +#if defined(CONFIG_OF)
> > 
> > Same goes here, don't put #if in .c files please.
> 
> So, generally speaking, this means that I should not put a
> platform_driver and an of_platform_driver into one source file, but
> rather create an of_$DRIVER.c then?

Yes, this is the preferred way to do it.

thanks,

greg k-h
