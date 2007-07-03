Return-Path: <linux-kernel-owner+w=401wt.eu-S1760166AbXGCQ2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760166AbXGCQ2d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 12:28:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755802AbXGCQ20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 12:28:26 -0400
Received: from xenotime.net ([66.160.160.81]:45011 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755856AbXGCQ2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 12:28:25 -0400
Date: Tue, 3 Jul 2007 09:31:25 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Jeff Garzik <jeff@garzik.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, akpm@osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH]: Check the right register for the DMA enabled flags
Message-Id: <20070703093125.fc022a71.rdunlap@xenotime.net>
In-Reply-To: <468A58D1.4070802@garzik.org>
References: <20070703151130.513fe2df@the-village.bc.nu>
	<468A58D1.4070802@garzik.org>
Organization: YPO4
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 Jul 2007 10:10:25 -0400 Jeff Garzik wrote:

> Alan Cox wrote:
> > Mirrors change in IT821X
> > 
> > Signed-off-by: Alan Cox <alan@redhat.com>
> > 
> > diff -u --new-file --exclude-from /usr/src/exclude --recursive linux.vanilla-2.6.22-rc6-mm1/drivers/ata/ata_generic.c linux-2.6.22-rc6-mm1/drivers/ata/ata_generic.c
> > --- linux.vanilla-2.6.22-rc6-mm1/drivers/ata/ata_generic.c	2007-07-02 20:50:11.000000000 +0100
> > +++ linux-2.6.22-rc6-mm1/drivers/ata/ata_generic.c	2007-07-02 21:02:10.000000000 +0100
> > @@ -50,7 +50,7 @@
> >  
> >  	/* Bits 5 and 6 indicate if DMA is active on master/slave */
> >  	if (ap->ioaddr.bmdma_addr)
> > -		dma_enabled = ioread8(ap->ioaddr.bmdma_addr + ATA_DMA_CMD);
> > +		dma_enabled = ioread8(ap->ioaddr.bmdma_addr + ATA_DMA_STATUS);
> 
> applied
> 
> Please put driver or subsystem name in subject, to disambiguate.  Email 
> subject goes straight into kernel changelog verbatim, and is in essence 
> a global namespace.

and please use linux-ide.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
