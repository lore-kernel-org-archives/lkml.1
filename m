Return-Path: <linux-kernel-owner+w=401wt.eu-S1754610AbXKBMAF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610AbXKBMAF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 08:00:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753107AbXKBL7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 07:59:55 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:39187 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876AbXKBL7y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 07:59:54 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH resend] Make the dev_*() family of macros in device.hcomplete
Date: Fri, 2 Nov 2007 04:59:48 -0700
Message-ID: <598D5675D34BE349929AF5EDE9B03E270174CCE0@az33exm24.fsl.freescale.net>
In-Reply-To: <20071101165700.aa5167fb.akpm@linux-foundation.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH resend] Make the dev_*() family of macros in device.hcomplete
Thread-Index: Acgc4v50E5XAGJdPS7K6HIE5fvpxbgAZHwog
References: <1193697795-7823-1-git-send-email-Emilian.Medve@Freescale.com><20071030000054.GA19022@suse.de><598D5675D34BE349929AF5EDE9B03E27016E5FCB@az33exm24.fsl.freescale.net><20071030154008.GA22809@suse.de> <20071101165700.aa5167fb.akpm@linux-foundation.org>
From: "Medve Emilian-EMMEDVE1" <Emilian.Medve@freescale.com>
To: "Andrew Morton" <akpm@linux-foundation.org>, "Greg KH" <gregkh@suse.de>
Cc: <linux-kernel@vger.kernel.org>, <hjlipp@web.de>, <tilman@imap.cc>,
       <gigaset307x-common@lists.sourceforge.net>, <kkeil@suse.de>,
       <isdn4linux@listserv.isdn4linux.de>, <mac@melware.de>,
       <linux-omap-open-source@linux.omap.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Andrew,


Thanks for the detailed background.

By now I also submitted a patch with extra spaces. Which one would be a
better candidate for applying in a maintainer's tree (which tree?)?
Could you please pick up one of the versions? Should I resubmit the
first version without extra spaces?


Cheers,
Emil.


> -----Original Message-----
> From: Andrew Morton [mailto:akpm@linux-foundation.org] 
> Sent: Thursday, November 01, 2007 6:57 PM
> To: Greg KH
> Cc: Medve Emilian-EMMEDVE1; linux-kernel@vger.kernel.org; 
> hjlipp@web.de; tilman@imap.cc; 
> gigaset307x-common@lists.sourceforge.net; kkeil@suse.de; 
> isdn4linux@listserv.isdn4linux.de; mac@melware.de; 
> linux-omap-open-source@linux.omap.com
> Subject: Re: [PATCH resend] Make the dev_*() family of macros 
> in device.hcomplete
> 
> On Tue, 30 Oct 2007 08:40:08 -0700
> Greg KH <gregkh@suse.de> wrote:
> 
> > On Tue, Oct 30, 2007 at 05:11:24AM -0700, Medve 
> Emilian-EMMEDVE1 wrote:
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
> > > > Those extra spaces are there for a good reason, older 
> versions of gcc
> > > > are broken without it.  So please, put them all back...
> > > 
> > > You mean I should add spaces before commas only where they were
> > > initially or to all new code and/or macros?
> > 
> > Put it back where it was, and do the same for all other macros.
> > 
> > > I've observed other kernel code and more often there are no spaces
> > > before commas. I'm asking because the CodingStyle 
> document is not very
> > > explicit about this rule.
> > 
> > This is a gcc rule, for variable length macros, not a CodingStyle
> > guideline.  It just will not work without it :)
> > 
> 
> The space-before-a-comma requirement was for gcc-2.95, iirc.
> 
> It got to the stage where I was the only person testing with 
> gcc-2.95 so I
> spent inordinate amounts of time adding spaces before 
> people's newly-added
> commas.  Fortunately we abamdoned that gcc version so the 
> space-before-a-comma
> requirement no longer exists.
