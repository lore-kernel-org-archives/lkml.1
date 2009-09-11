Return-Path: <linux-kernel-owner+w=401wt.eu-S1752620AbZIKOp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620AbZIKOp5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 10:45:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752021AbZIKOp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 10:45:56 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44189 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751883AbZIKOp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 10:45:56 -0400
Date: Fri, 11 Sep 2009 15:47:14 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: markh@compro.net
Cc: linux-pci@vger.kernel.org, Mark Hounschell <dmarkh@cfl.rr.com>,
       linux-kernel@vger.kernel.org
Subject: Re: problems doing direct dma from a pci device to pci-e device
Message-ID: <20090911154714.70a94454@lxorguk.ukuu.org.uk>
In-Reply-To: <4AAA5B1F.3020103@compro.net>
References: <4AAA5B1F.3020103@compro.net>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I now have an AM3 based DFI DK 790FXB-M3H5 motherboard. This board has 3 regular
> PCI slots and 3 PCI-E (16x) slots. I also have a PCI-E (x4) version of the VMIC-5565
> reflective memory  card in one of the PCI-E slots and our gpiohsd card in one of the regular
> PCI slots. All on the motherboard. No expansion slots being used. However I cannot get
> data from our gpiohsd into the PCI-E VMIC-5565 cards memory. I can certainly get the data there
> from a userland buffer, no problem. Just not from one card to the other directly. Oh and when
> I put the regular PCI version of the VMIC into one of the regular PCI slots everything works
> as expected. They are then both on the same PCI bus and no bridges are involved though.

Have you verified with the vendor that such DMA works properly ? There is
a long history of there being boards where some device to device DMA
exploded or vanished. The arrival of PCI capture cards doing direct to
video DMA cleaned the world up (eg the BT848) but I wouldn't be suprised
if this recurred somewhere since they were popular and nobody really
noticed as they didn't run such an unusual config.

Also does the board have a true IOMMU in the PCI-E side of the system ?
It's not a chipset I know.
