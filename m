Return-Path: <linux-kernel-owner+w=401wt.eu-S1756886AbYGDPN7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756886AbYGDPN7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 11:13:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754400AbYGDPNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 11:13:50 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:64477 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754262AbYGDPNs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 11:13:48 -0400
Date: Fri, 4 Jul 2008 17:13:23 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: "Dan Williams" <dan.j.williams@intel.com>
Cc: "Pierre Ossman" <drzeus-list@drzeus.cx>, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org, kernel@avr32linux.org,
       shannon.nelson@intel.com, "David Brownell" <david-b@pacbell.net>
Subject: Re: [PATCH v4 0/6] dmaengine/mmc: DMA slave interface and two new
 drivers
Message-ID: <20080704171323.14fe6daa@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <e9c3a7c20807031806u23304279p33ed3467ba0e5a7f@mail.gmail.com>
References: <1214486603-23655-1-git-send-email-haavard.skinnemoen@atmel.com>
	<e9c3a7c20807031806u23304279p33ed3467ba0e5a7f@mail.gmail.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Jul 2008 15:13:33.0271 (UTC) FILETIME=[8623E670:01C8DDE8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Dan Williams" <dan.j.williams@intel.com> wrote:
> On Thu, Jun 26, 2008 at 6:23 AM, Haavard Skinnemoen
> <haavard.skinnemoen@atmel.com> wrote:
> >      dmaengine: Add dma_client parameter to device_alloc_chan_resources
> 
> Applied.  I fixed it up for fsldma and mv_xor.

Thanks.

> >      dmaengine: Add dma_chan_is_in_use() function
> 
> I applied the chan->client_count patch that we talked about.

Ok, I've updated the dw_dmac driver.

> >      dmaengine: Add slave DMA interface
> 
> There were some comments to the change log and other fixes, so I'll
> wait for v5 of this patch.

Will post v5 right after I finish typing this.

> >      dmaengine: Make DMA Engine menu visible for AVR32 users
> 
> Applied the "remove arch dependency in drivers/dma/Kconfig" instead.

Ok.

> >      dmaengine: Driver for the Synopsys DesignWare DMA controller
> >      Atmel MCI: Driver for Atmel on-chip MMC controllers
> 
> I will wait for v5 on these as well for the chan->client_count fixups
> and a response to the dma_unmap situation.

I'll send you v5 of the dw_dmac driver. The MMC driver should go in via
Pierre.

Thanks,

Haavard
