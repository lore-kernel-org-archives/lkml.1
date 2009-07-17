Return-Path: <linux-kernel-owner+w=401wt.eu-S934407AbZGQKih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934407AbZGQKih (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 06:38:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934391AbZGQKih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 06:38:37 -0400
Received: from mail.atmel.fr ([81.80.104.162]:59427 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934390AbZGQKig (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 06:38:36 -0400
Message-ID: <4A605493.7090607@atmel.com>
Date: Fri, 17 Jul 2009 12:38:11 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: dan.j.williams@intel.com, maciej.sosnowski@intel.com
CC: Nicolas Ferre <nicolas.ferre@atmel.com>, avictor.za@gmail.com,
       linux-arm-kernel@lists.arm.linux.org.uk, patrice.vilchez@atmel.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2 v3] dmaengine: at_hdmac: new driver for the Atmel
 AHB DMA Controller
References: <1246012936-10812-1-git-send-email-nicolas.ferre@atmel.com> <1246641873-21686-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <1246641873-21686-1-git-send-email-nicolas.ferre@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolas Ferre :
> This AHB DMA Controller (aka HDMA or DMAC on AT91 systems) is availlable on
> at91sam9rl chip. It will be used on other products in the future.
> 
> This first release covers only the memory-to-memory tranfer type. This is the
> only tranfer type supported by this chip.  On other products, it will be used
> also for peripheral DMA transfer (slave API support to come).
> 
> I used dmatest client without problem in different configurations to test it.
> 
> Full documentation for this controller can be found in the SAM9RL datasheet:
> http://www.atmel.com/dyn/products/product_card.asp?part_id=4243
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---
> v2 is here:
> http://lkml.org/lkml/2009/6/26/104
> 
> v2 -> v3:
>  - initial number of descriptors to allocate for each channel raised to 64 and
>    is now a parameter
>  - ack-bit in descriptor flag comment synchronized with TXx9 dma driver
>  - atc_desc_get() when short on descriptors in pool: create one at a time
>  - allocation flag changed to GFP_ATOMIC in atc_desc_get()
>  - call to proper funtion while unmapping: use of new
>    DMA_COMPL_{SRC,DEST}_UNMAP_SINGLE flags
>  - call dma_run_dependencies() at the end of atc_chain_complete()

Dan, Maciej: Ping ?

I have a "slave" support on top of this patch and would like the initial
work to be accepted before going further...

Thanks, Bye,
-- 
Nicolas Ferre

