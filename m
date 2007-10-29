Return-Path: <linux-kernel-owner+w=401wt.eu-S1756650AbXJ2Tqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756650AbXJ2Tqj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 15:46:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754100AbXJ2Tmn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 15:42:43 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:59363 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755153AbXJ2Tmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 15:42:42 -0400
Date: Mon, 29 Oct 2007 15:42:41 -0400
To: Wijnand Rietman <wijnand.rietman@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: CONFIG_IDEDMA_AUTO & 2.4.32 & hdparm -d1
Message-ID: <20071029194241.GA27646@csclub.uwaterloo.ca>
References: <b3790d380710290605g5d1770fao675418f062f111b9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b3790d380710290605g5d1770fao675418f062f111b9@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2007 at 02:05:44PM +0100, Wijnand Rietman wrote:
> I am running Linux on a PC104 board from a compact flash card. Because
> the physical DMA lines are missing on some of the compact flash
> carrier cards, I would like to be able to boot with DMA disabled and
> to enable DMA in a later stage if desired (and supported by hardware).
> 
> The problem is that when I set CONFIG_IDEDMA_AUTO to FALSE, I cannot
> enable DMA anymore with hdparm, not even with hardware that supports
> DMA. If I set CONFIG_IDEDMA_AUTO to TRUE, I can use hdparm to disable
> and enable DMA (but of course I get long timeouts with the carrier
> cards that do not have the physical DMA lines).
> 
> Q1: Is this how the CONFIG_IDEDMA_AUTO setting is supposed to work in
> combination with hdparm?
> Q2: Is there a way to boot with DMA disabled and to enable it later on
> once the system is up and running?
> 
> Kernel: 2.4.32
> Chipset: CS5530
> 
> Any help is highly appreciated!

I had trouble with DMA and compact flash cards on our board (prior to
the new revision) since it did not have the DMA lines (they weren't part
of the CF spec when the board was designed).  The way I booted was to
pass 'ide=nodma' and that worked fine (at least on the sc1200).

I could enable dma with hdparm later if I wanted (which of course made
the ide driver rather upset when it tried to then use the non existant
dma lines).

--
Len Sorensen
