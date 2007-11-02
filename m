Return-Path: <linux-kernel-owner+w=401wt.eu-S1758033AbXKBPgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758033AbXKBPgf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 11:36:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753771AbXKBPgY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 11:36:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52337 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757500AbXKBPgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 11:36:23 -0400
Date: Fri, 2 Nov 2007 08:35:33 -0700
From: Greg KH <gregkh@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Emilian.Medve@freescale.com, linux-kernel@vger.kernel.org, hjlipp@web.de,
       tilman@imap.cc, gigaset307x-common@lists.sourceforge.net, kkeil@suse.de,
       isdn4linux@listserv.isdn4linux.de, mac@melware.de,
       linux-omap-open-source@linux.omap.com
Subject: Re: [PATCH resend] Make the dev_*() family of macros in
	device.hcomplete
Message-ID: <20071102153533.GB7485@suse.de>
References: <1193697795-7823-1-git-send-email-Emilian.Medve@Freescale.com> <20071030000054.GA19022@suse.de> <598D5675D34BE349929AF5EDE9B03E27016E5FCB@az33exm24.fsl.freescale.net> <20071030154008.GA22809@suse.de> <20071101165700.aa5167fb.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071101165700.aa5167fb.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 01, 2007 at 04:57:00PM -0700, Andrew Morton wrote:
> On Tue, 30 Oct 2007 08:40:08 -0700
> Greg KH <gregkh@suse.de> wrote:
> 
> > On Tue, Oct 30, 2007 at 05:11:24AM -0700, Medve Emilian-EMMEDVE1 wrote:
> > > Hi Greg K-H,
> > > 
> > > 
> > > > > +#define dev_info(dev, format, arg...)		\
> > > > > +	dev_printk(KERN_INFO, dev, format, ## arg)
> > > > > +
> > > > >  #ifdef DEBUG
> > > > >  #define dev_dbg(dev, format, arg...)		\
> > > > > -	dev_printk(KERN_DEBUG , dev , format , ## arg)
> > > > > +	dev_printk(KERN_DEBUG, dev, format, ## arg)
> > > > 
> > > > Those extra spaces are there for a good reason, older versions of gcc
> > > > are broken without it.  So please, put them all back...
> > > 
> > > You mean I should add spaces before commas only where they were
> > > initially or to all new code and/or macros?
> > 
> > Put it back where it was, and do the same for all other macros.
> > 
> > > I've observed other kernel code and more often there are no spaces
> > > before commas. I'm asking because the CodingStyle document is not very
> > > explicit about this rule.
> > 
> > This is a gcc rule, for variable length macros, not a CodingStyle
> > guideline.  It just will not work without it :)
> > 
> 
> The space-before-a-comma requirement was for gcc-2.95, iirc.
> 
> It got to the stage where I was the only person testing with gcc-2.95 so I
> spent inordinate amounts of time adding spaces before people's newly-added
> commas.  Fortunately we abamdoned that gcc version so the space-before-a-comma
> requirement no longer exists.

Ah, ok, that's good to remember in the future, thanks.

greg k-h
