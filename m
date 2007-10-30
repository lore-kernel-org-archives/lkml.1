Return-Path: <linux-kernel-owner+w=401wt.eu-S1756584AbXJ3Pkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756584AbXJ3Pkt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 11:40:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754561AbXJ3Pkl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 11:40:41 -0400
Received: from ns1.suse.de ([195.135.220.2]:43447 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754102AbXJ3Pkk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 11:40:40 -0400
Date: Tue, 30 Oct 2007 08:40:08 -0700
From: Greg KH <gregkh@suse.de>
To: Medve Emilian-EMMEDVE1 <Emilian.Medve@freescale.com>
Cc: mochel@osdl.org, linux-kernel@vger.kernel.org, hjlipp@web.de,
       tilman@imap.cc, gigaset307x-common@lists.sourceforge.net, kkeil@suse.de,
       isdn4linux@listserv.isdn4linux.de, mac@melware.de,
       linux-omap-open-source@linux.omap.com
Subject: Re: [PATCH resend] Make the dev_*() family of macros in
	device.hcomplete
Message-ID: <20071030154008.GA22809@suse.de>
References: <1193697795-7823-1-git-send-email-Emilian.Medve@Freescale.com> <20071030000054.GA19022@suse.de> <598D5675D34BE349929AF5EDE9B03E27016E5FCB@az33exm24.fsl.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <598D5675D34BE349929AF5EDE9B03E27016E5FCB@az33exm24.fsl.freescale.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2007 at 05:11:24AM -0700, Medve Emilian-EMMEDVE1 wrote:
> Hi Greg K-H,
> 
> 
> > > +#define dev_info(dev, format, arg...)		\
> > > +	dev_printk(KERN_INFO, dev, format, ## arg)
> > > +
> > >  #ifdef DEBUG
> > >  #define dev_dbg(dev, format, arg...)		\
> > > -	dev_printk(KERN_DEBUG , dev , format , ## arg)
> > > +	dev_printk(KERN_DEBUG, dev, format, ## arg)
> > 
> > Those extra spaces are there for a good reason, older versions of gcc
> > are broken without it.  So please, put them all back...
> 
> You mean I should add spaces before commas only where they were
> initially or to all new code and/or macros?

Put it back where it was, and do the same for all other macros.

> I've observed other kernel code and more often there are no spaces
> before commas. I'm asking because the CodingStyle document is not very
> explicit about this rule.

This is a gcc rule, for variable length macros, not a CodingStyle
guideline.  It just will not work without it :)

thanks,

greg k-h
