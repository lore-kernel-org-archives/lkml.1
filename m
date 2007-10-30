Return-Path: <linux-kernel-owner+w=401wt.eu-S1756119AbXJ3PcE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119AbXJ3PcE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 11:32:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753513AbXJ3Pbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 11:31:52 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:61832 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753281AbXJ3Pbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 11:31:51 -0400
Date: Tue, 30 Oct 2007 08:29:31 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Medve Emilian-EMMEDVE1" <Emilian.Medve@freescale.com>
Cc: "Greg KH" <gregkh@suse.de>, <mochel@osdl.org>,
       <linux-kernel@vger.kernel.org>, <hjlipp@web.de>, <tilman@imap.cc>,
       <gigaset307x-common@lists.sourceforge.net>, <kkeil@suse.de>,
       <isdn4linux@listserv.isdn4linux.de>, <mac@melware.de>,
       <linux-omap-open-source@linux.omap.com>
Subject: Re: [PATCH resend] Make the dev_*() family of macros in
 device.hcomplete
Message-Id: <20071030082931.113274cc.randy.dunlap@oracle.com>
In-Reply-To: <598D5675D34BE349929AF5EDE9B03E27016E5FCB@az33exm24.fsl.freescale.net>
References: <1193697795-7823-1-git-send-email-Emilian.Medve@Freescale.com>
	<20071030000054.GA19022@suse.de>
	<598D5675D34BE349929AF5EDE9B03E27016E5FCB@az33exm24.fsl.freescale.net>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Oct 2007 05:11:24 -0700 Medve Emilian-EMMEDVE1 wrote:

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
> initially or to all new code and/or macros? I've observed other kernel
> code and more often there are no spaces before commas. I'm asking
> because the CodingStyle document is not very explicit about this rule.

My (hazy?) recollection of the gcc issue is that it is only the
comma before the ## that needs spaces around it.

I'm not even sure that we are still supporting that gcc version,
but you should just put the spaces back to be safe IMO.

---
~Randy
