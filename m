Return-Path: <linux-kernel-owner+w=401wt.eu-S1754345AbZIKPZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754345AbZIKPZ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 11:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751733AbZIKPZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 11:25:25 -0400
Received: from mx2.compro.net ([216.54.166.4]:5220 "EHLO mx2.compro.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750966AbZIKPZY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 11:25:24 -0400
X-IronPort-AV: E=Sophos;i="4.44,370,1249272000"; 
   d="scan'208";a="4352811"
Message-ID: <4AAA6BE7.8040306@compro.net>
Date: Fri, 11 Sep 2009 11:25:27 -0400
From: Mark Hounschell <markh@compro.net>
Reply-To: markh@compro.net
Organization: Compro Computer Svcs.
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-pci@vger.kernel.org, Mark Hounschell <dmarkh@cfl.rr.com>,
       linux-kernel@vger.kernel.org
Subject: Re: problems doing direct dma from a pci device to pci-e device
References: <4AAA5B1F.3020103@compro.net> <20090911154714.70a94454@lxorguk.ukuu.org.uk>
In-Reply-To: <20090911154714.70a94454@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> I now have an AM3 based DFI DK 790FXB-M3H5 motherboard. This board has 3 regular
>> PCI slots and 3 PCI-E (16x) slots. I also have a PCI-E (x4) version of the VMIC-5565
>> reflective memory  card in one of the PCI-E slots and our gpiohsd card in one of the regular
>> PCI slots. All on the motherboard. No expansion slots being used. However I cannot get
>> data from our gpiohsd into the PCI-E VMIC-5565 cards memory. I can certainly get the data there
>> from a userland buffer, no problem. Just not from one card to the other directly. Oh and when
>> I put the regular PCI version of the VMIC into one of the regular PCI slots everything works
>> as expected. They are then both on the same PCI bus and no bridges are involved though.
> 
> Have you verified with the vendor that such DMA works properly ? There is
> a long history of there being boards where some device to device DMA
> exploded or vanished. The arrival of PCI capture cards doing direct to
> video DMA cleaned the world up (eg the BT848) but I wouldn't be suprised
> if this recurred somewhere since they were popular and nobody really
> noticed as they didn't run such an unusual config.
> 

I have not made an inquiry with the vendor yet. I'm pretty sure I have done 
this with this very card in another mother board. I guess I need to dig that one 
up and verify it before I go much further.  

But it's much like you describe above. The data seems to just vanish. I can't
see any way to use my v-metro to find out where it's going either.

> Also does the board have a true IOMMU in the PCI-E side of the system ?
> It's not a chipset I know.
> 

That I don't know for sure but I thought they all did??

I'll verify that the VMIC card is in fact capable in that other MB before
I do anything else.

Thanks
Mark

