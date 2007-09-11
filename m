Return-Path: <linux-kernel-owner+w=401wt.eu-S1763275AbXIKKGY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763275AbXIKKGY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 06:06:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761548AbXIKKGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 06:06:17 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:40823 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761497AbXIKKGQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 06:06:16 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 5/5] Add DMA engine driver for Freescale MPC85xx processors.
Date: Tue, 11 Sep 2007 18:06:10 +0800
Message-ID: <46B96294322F7D458F9648B60E15112C85D61C@zch01exm26.fsl.freescale.net>
In-Reply-To: <20070907085845.54dc88f8.randy.dunlap@oracle.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 5/5] Add DMA engine driver for Freescale MPC85xx processors.
Thread-Index: AcfxaBAjIPEfNwO1SxKoveL8mqtGpQC8tOCA
References: <11891624582950-git-send-email-wei.zhang@freescale.com> <20070907085845.54dc88f8.randy.dunlap@oracle.com>
From: "Zhang Wei-r63237" <Wei.Zhang@freescale.com>
To: "Randy Dunlap" <randy.dunlap@oracle.com>
Cc: <paulus@samba.org>, <shannon.nelson@intel.com>,
       <linux-kernel@vger.kernel.org>, <linuxppc-dev@ozlabs.org>,
       <galak@kernel.crashing.org>,
       "Zhu Ebony-r57400" <ebony.zhu@freescale.com>,
       <dan.j.williams@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 
> --- /dev/null
> > +++ b/drivers/dma/fsldma.c
> > @@ -0,0 +1,995 @@
> 
> Thanks for using kernel-doc notation.  However, ...
> 
> > +/**
> > + * fsl_dma_alloc_descriptor - Allocate descriptor from 
> channel's DMA pool.
> 
> Function parameters need to be listed & described here.
> See Documentation/kernel-doc-nano-HOWTO.txt or other source files
> for examples.
> 
> (Applies to all documented function interfaces here.)

All right, I'll add full descriptions here. :P

> 
> > + *
> > + * Return - The descriptor allocated. NULL for failed.
> > + */
> > +static struct fsl_desc_sw *fsl_dma_alloc_descriptor(
> > +					struct fsl_dma_chan *fsl_chan,
> > +					gfp_t flags)
> > +{
> ...
> > +}
> 
> > +/**
> > + * fsl_chan_xfer_ld_queue -- Transfer the link descriptors 
> in channel
> > + *                           ld_queue.
> 
> The function's "short description" (unfortunately) must be on only one
> line.  E.g.:
> 
>  * fsl_chan_xfer_ld_queue - Transfer link descriptors in 
> channel ld_queue.
> 

How about it's length greater than 80?

> > + */
> > +static void fsl_chan_xfer_ld_queue(struct fsl_dma_chan *fsl_chan)
> > +{
> ...
> > +}
> 
> > diff --git a/drivers/dma/fsldma.h b/drivers/dma/fsldma.h
> > new file mode 100644
> > index 0000000..05be9ed
> > --- /dev/null
> > +++ b/drivers/dma/fsldma.h
> > @@ -0,0 +1,188 @@
> > +struct fsl_dma_chan_regs {
> > +	__mix32	mr;		/* 0x00 - Mode Register */
> > +	__mix32	sr;		/* 0x04 - Status Register */
> > +	__mix64	cdar;		/* 0x08 - Cureent descriptor 
> address register */
> 
>                                           Current
> 

I'll fix it.

Thanks!
- zw
