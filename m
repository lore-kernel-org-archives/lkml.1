Return-Path: <linux-kernel-owner+w=401wt.eu-S1758294AbYGDOsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758294AbYGDOsU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 10:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754292AbYGDOsI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 10:48:08 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:64267 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754022AbYGDOsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 10:48:07 -0400
Date: Fri, 4 Jul 2008 16:47:34 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Pierre Ossman <drzeus-list@drzeus.cx>, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org, kernel@avr32linux.org,
       "Nelson, Shannon" <shannon.nelson@intel.com>,
       David Brownell <david-b@pacbell.net>
Subject: Re: dmaengine skip unmap (was: Re: [PATCH v4 5/6] dmaengine: Driver
 for the Synopsys DesignWare DMA controller)
Message-ID: <20080704164734.009ba54a@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <1215132023.23470.15.camel@dwillia2-linux.ch.intel.com>
References: <1214486603-23655-1-git-send-email-haavard.skinnemoen@atmel.com>
	<1214486603-23655-2-git-send-email-haavard.skinnemoen@atmel.com>
	<1214486603-23655-3-git-send-email-haavard.skinnemoen@atmel.com>
	<1214486603-23655-4-git-send-email-haavard.skinnemoen@atmel.com>
	<1214486603-23655-5-git-send-email-haavard.skinnemoen@atmel.com>
	<1214486603-23655-6-git-send-email-haavard.skinnemoen@atmel.com>
	<1215132023.23470.15.camel@dwillia2-linux.ch.intel.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Jul 2008 14:47:49.0984 (UTC) FILETIME=[EE44FE00:01C8DDE4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Williams <dan.j.williams@intel.com> wrote:
> The one thing that stands out is that this driver does not unmap the
> source or destination buffers (and I now notice that fsldma is not doing
> this either, hmm...).  Yes, it is a no-op on avr32, for now, but the
> dma-mapping-api assumes that dma_map is always paired with dma_unmap.  I
> remember we discussed this earlier and that discussion inspired the
> patch below.  The end result is that dw_dmac can try to automatically
> dma_unmap the buffers unless an intelligent client, like the mmc driver,
> has disabled unmap.
> 
> Thoughts?

Looks reasonable. I'll update the dw_dmac driver and post a new version
in a few moments.

Haavard
