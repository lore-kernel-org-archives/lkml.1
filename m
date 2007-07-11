Return-Path: <linux-kernel-owner+w=401wt.eu-S1760945AbXGKHkQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760945AbXGKHkQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 03:40:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756018AbXGKHkG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 03:40:06 -0400
Received: from az33egw01.freescale.net ([192.88.158.102]:54345 "EHLO
	az33egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756007AbXGKHkE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 03:40:04 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Subject: RE: [PATCH 3/4] Extend the DMA-engine API.
Date: Wed, 11 Jul 2007 15:39:58 +0800
Message-ID: <46B96294322F7D458F9648B60E15112C6F3CED@zch01exm26.fsl.freescale.net>
In-Reply-To: <e9c3a7c20707101141m17e313e2k99be5b7197edc910@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 3/4] Extend the DMA-engine API.
Thread-Index: AcfDIfWZ4yUwLoGFS6a0HjJVMQKWtAAattdw
References: <11840607111926-git-send-email-wei.zhang@freescale.com> <e9c3a7c20707101141m17e313e2k99be5b7197edc910@mail.gmail.com>
From: "Zhang Wei-r63237" <Wei.Zhang@freescale.com>
To: "Dan Williams" <dan.j.williams@intel.com>
Cc: <akpm@linux-foundation.org>, <paulus@samba.org>,
       <galak@kernel.crashing.org>, <linuxppc-dev@ozlabs.org>,
       <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Dan, 

Do you mention here: http://marc.info/?l=linux-raid&m=118290909614463&w=2 ?
I see the async_tx is located at crypto/ of the above page, but my patch is for DMA engine in drivers/dma and for DMA engine driver.

Thanks!
Wei.
> -----Original Message-----
> Subject: Re: [PATCH 3/4] Extend the DMA-engine API.
> 
> On 7/10/07, Zhang Wei <wei.zhang@freescale.com> wrote:
> > Add channel wait queue and transfer callback dma_xfer_callback().
> > If the DMA controller and driver support interrupt, when the
> > transfer is finished, it will wakeup the wait queue
> > and call the callback function of the channel.
> >
> > Add dma_async_raw_xfer() to API and device_raw_xfer() to 
> struct dma_device
> > for RAW physical address DMA transfer, which will be used 
> at transfer
> > between I/O address and memory address.
> >
> 
> Please review the async_tx API patch series[1], it should meet your
> needs.  What you call "raw" mode support is now default for the
> dmaengine driver interface.  I plan to request that this series be
> merged for 2.6.23.
> 
> Regards,
> Dan
> 
> [1]http://marc.info/?l=linux-raid&w=2&r=1&s=md-accel&q=b
> 
