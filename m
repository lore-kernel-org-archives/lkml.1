Return-Path: <linux-kernel-owner+w=401wt.eu-S1764336AbYFZNcg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764336AbYFZNcg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 09:32:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752748AbYFZNcY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 09:32:24 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:59341 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752285AbYFZNcW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 09:32:22 -0400
Date: Thu, 26 Jun 2008 15:32:12 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Dan Williams <dan.j.williams@intel.com>,
       Pierre Ossman <drzeus-list@drzeus.cx>
Cc: linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       kernel@avr32linux.org, shannon.nelson@intel.com,
       David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH v4 3/6] dmaengine: Add slave DMA interface
Message-ID: <20080626153212.543be415@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <1214486603-23655-4-git-send-email-haavard.skinnemoen@atmel.com>
References: <1214486603-23655-1-git-send-email-haavard.skinnemoen@atmel.com>
	<1214486603-23655-2-git-send-email-haavard.skinnemoen@atmel.com>
	<1214486603-23655-3-git-send-email-haavard.skinnemoen@atmel.com>
	<1214486603-23655-4-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Jun 2008 13:31:56.0393 (UTC) FILETIME=[00D02590:01C8D791]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, I guess I didn't update all the patch descriptions properly...

Haavard Skinnemoen <haavard.skinnemoen@atmel.com> wrote:
> A new struct dma_slave_descriptor is added. This extends the standard
> dma_async_tx_descriptor with a few members that are needed for doing
> slave DMA from/to peripherals.

This isn't correct anymore, as the dma_slave_descriptor struct turned
out not to be needed after all.

> A new operation for creating such descriptors is added to struct
> dma_device.

This isn't entirely correct either -- regular dma_async_tx_descriptors
are created, but one such descriptor can represent a whole scatterlist.

I'll update the changelog for the next round...

Haavard
