Return-Path: <linux-kernel-owner+w=401wt.eu-S1754005AbXJ3MLh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005AbXJ3MLh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 08:11:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752691AbXJ3MLa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 08:11:30 -0400
Received: from de01egw02.freescale.net ([192.88.165.103]:42142 "EHLO
	de01egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623AbXJ3MLa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 08:11:30 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH resend] Make the dev_*() family of macros in device.hcomplete
Date: Tue, 30 Oct 2007 05:11:24 -0700
Message-ID: <598D5675D34BE349929AF5EDE9B03E27016E5FCB@az33exm24.fsl.freescale.net>
In-Reply-To: <20071030000054.GA19022@suse.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH resend] Make the dev_*() family of macros in device.hcomplete
Thread-Index: AcgahzXXAQAhv/L3TdGe3jHEKteUyQAZK9VA
References: <1193697795-7823-1-git-send-email-Emilian.Medve@Freescale.com> <20071030000054.GA19022@suse.de>
From: "Medve Emilian-EMMEDVE1" <Emilian.Medve@freescale.com>
To: "Greg KH" <gregkh@suse.de>
Cc: <mochel@osdl.org>, <linux-kernel@vger.kernel.org>, <hjlipp@web.de>,
       <tilman@imap.cc>, <gigaset307x-common@lists.sourceforge.net>,
       <kkeil@suse.de>, <isdn4linux@listserv.isdn4linux.de>, <mac@melware.de>,
       <linux-omap-open-source@linux.omap.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg K-H,


> > +#define dev_info(dev, format, arg...)		\
> > +	dev_printk(KERN_INFO, dev, format, ## arg)
> > +
> >  #ifdef DEBUG
> >  #define dev_dbg(dev, format, arg...)		\
> > -	dev_printk(KERN_DEBUG , dev , format , ## arg)
> > +	dev_printk(KERN_DEBUG, dev, format, ## arg)
> 
> Those extra spaces are there for a good reason, older versions of gcc
> are broken without it.  So please, put them all back...

You mean I should add spaces before commas only where they were
initially or to all new code and/or macros? I've observed other kernel
code and more often there are no spaces before commas. I'm asking
because the CodingStyle document is not very explicit about this rule.


Thank you,
Emil.
