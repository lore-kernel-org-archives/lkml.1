Return-Path: <linux-kernel-owner+w=401wt.eu-S1759452AbXGJPng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759452AbXGJPng (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 11:43:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754411AbXGJPn3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 11:43:29 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:30858 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454AbXGJPn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 11:43:28 -0400
Date: Tue, 10 Jul 2007 08:46:03 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Zhang Wei <wei.zhang@freescale.com>
Cc: akpm@linux-foundation.org, paulus@samba.org, galak@kernel.crashing.org,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] Extend the DMA-engine API.
Message-Id: <20070710084603.286d7bb8.randy.dunlap@oracle.com>
In-Reply-To: <11840607111926-git-send-email-wei.zhang@freescale.com>
References: <11840607111926-git-send-email-wei.zhang@freescale.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jul 2007 17:45:11 +0800 Zhang Wei wrote:

> Add channel wait queue and transfer callback dma_xfer_callback().
> If the DMA controller and driver support interrupt, when the
> transfer is finished, it will wakeup the wait queue
> and call the callback function of the channel.
> 
> Add dma_async_raw_xfer() to API and device_raw_xfer() to struct dma_device
> for RAW physical address DMA transfer, which will be used at transfer
> between I/O address and memory address.
> 
> Signed-off-by: Zhang Wei <wei.zhang@freescale.com>
> ---
>  include/linux/dmaengine.h |   35 +++++++++++++++++++++++++++++++++++
>  1 files changed, 35 insertions(+), 0 deletions(-)

>  /**
> + * dma_async_raw_xfer - transfor data between physical addresses with callback

                           transfer

> + * @chan: DMA channel to be used
> + * @dest: destination address (physical)
> + * @src: source address (physical)
> + * @len: length
> + */
> +static inline dma_cookie_t dma_async_raw_xfer(struct dma_chan *chan,
> +				dma_addr_t dest, dma_addr_t src, size_t len,
> +				dma_xfer_callback cb, void *data)
> +{


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
