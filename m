Return-Path: <linux-kernel-owner+w=401wt.eu-S1754361AbYIWSDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754361AbYIWSDY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 14:03:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751205AbYIWSDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 14:03:15 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:56797 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750955AbYIWSDP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 14:03:15 -0400
Date: Tue, 23 Sep 2008 20:02:25 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: kernel@avr32linux.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] atmel-mci: Platform code for supporting multiple
 mmc slots
Message-ID: <20080923200225.71a42c95@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <20080923194012.3907c677@mjolnir.drzeus.cx>
References: <1222101497-21183-1-git-send-email-haavard.skinnemoen@atmel.com>
	<1222101497-21183-2-git-send-email-haavard.skinnemoen@atmel.com>
	<1222101497-21183-3-git-send-email-haavard.skinnemoen@atmel.com>
	<20080923194012.3907c677@mjolnir.drzeus.cx>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 23 Sep 2008 18:02:16.0089 (UTC) FILETIME=[83451890:01C91DA6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman <drzeus-list@drzeus.cx> wrote:
> On Mon, 22 Sep 2008 18:38:15 +0200
> Haavard Skinnemoen <haavard.skinnemoen@atmel.com> wrote:
> 
> > +/**
> > + * struct mci_platform_data - board-specific MMC/SDcard configuration
> > + * @dma_slave: DMA slave interface to use in data transfers, or NULL.
> > + * @slot: Per-slot configuration data.
> > + */
> > +struct mci_platform_data {
> > +	struct mci_slot_pdata	slot[2];
> > +};  
> 
> Comment doesn't match code.

You're right -- I switched the order of the DMA and multi-slot patches
and forgot to update the comments. It will match when all four patches
are applied, but I'll fix it in the next round.

Haavard
