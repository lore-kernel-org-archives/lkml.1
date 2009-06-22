Return-Path: <linux-kernel-owner+w=401wt.eu-S1756979AbZFVONW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756979AbZFVONW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 10:13:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751994AbZFVONO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 10:13:14 -0400
Received: from mailout5.samsung.com ([203.254.224.35]:60955 "EHLO
	mailout5.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbZFVONN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 10:13:13 -0400
Date: Mon, 22 Jun 2009 16:12:29 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: PROBLEM: kernel oops with g_serial USB gadget on 2.6.30
In-reply-to: <Pine.LNX.4.44L0.0906221004590.2991-100000@iolanthe.rowland.org>
To: "'Alan Stern'" <stern@rowland.harvard.edu>
Cc: "'Peter Korsgaard'" <jacmet@sunsite.dk>,
       "'USB list'" <linux-usb@vger.kernel.org>,
       "'Kernel development list'" <linux-kernel@vger.kernel.org>,
       kyungmin.park@samsung.com,
       "'Marek Szyprowski'" <m.szyprowski@samsung.com>
Message-id: <001301c9f343$7e16ed80$7a44c880$%szyprowski@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
Thread-index: AcnzQsSvU4vMg0TRTOaK/GS+++YprQAADzxg
References: <001201c9f341$20b8b710$622a2530$%szyprowski@samsung.com>
 <Pine.LNX.4.44L0.0906221004590.2991-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Monday, June 22, 2009 4:07 PM, Alan Stern wrote:

> > >  Marek> I would like to ask if someone has successfully used
> g_serial
> > >  Marek> USB gadget driver with kernel 2.6.29 or 2.6.30? I'm
> developing
> > >  Marek> a low level hardware driver for USB gadgets on ARM S3C6410
> > >  Marek> platform. This driver is working quite fine (I've used it a
> > >  Marek> lot with g_ether CDC/RNDIS ethernet gadget driver). During
> my
> > >  Marek> development I've found the following bug in g_serial
> driver:
> > >
> > > You are aware that Ben Dooks has written an UDC driver for the OTG
> > > controller on the s3c6410 which is now in mainline, right?
> > >
> > > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-
> > > 2.6.git;a=commit;h=5b7d70c6dbf2db786395cbd21750a1a4ce222f84
> >
> > Yes, I am aware. That driver does not work well for me (but this is
> the
> > other case). However I did a test with his driver and the result was
> also
> > a kernel oops:
> >
> > [...]
> >
> > > I've used the g_serial driver on 2.6.29 without problems (not on
> > > s3c6410 though).
> >
> > On what hardware you use the g_serial driver? It is ARM-based? I
> > understand that this might be also related to the way that low level
> > hardware gadget driver is implemented, but I really have no idea how
> > to hunt for this bug.
> 
> This is just a guess...  But there's a good possibility that the oops
> was caused by recent changes to the serial layer which have not been
> propagated through to the g_serial driver.

How recent these changes are? I did a test on another ARM-based Linux 
platform with old 2.6.28 kernel and the result was exactly the same as 
above...

Best regards
--
Marek Szyprowski
Samsung Poland R&D Center


