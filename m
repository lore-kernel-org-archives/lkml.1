Return-Path: <linux-kernel-owner+w=401wt.eu-S1756252AbZIKTmN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756252AbZIKTmN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 15:42:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756207AbZIKTmM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 15:42:12 -0400
Received: from mx2.compro.net ([216.54.166.4]:14265 "EHLO mx2.compro.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756196AbZIKTmL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 15:42:11 -0400
X-IronPort-AV: E=Sophos;i="4.44,372,1249272000"; 
   d="scan'208";a="4354047"
Message-ID: <4AAAA814.3000706@compro.net>
Date: Fri, 11 Sep 2009 15:42:12 -0400
From: Mark Hounschell <markh@compro.net>
Reply-To: markh@compro.net
Organization: Compro Computer Svcs.
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: "Richard B. Johnson" <RJohnson@Route495Software.com>
CC: Mark Hounschell <dmarkh@cfl.rr.com>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: problems doing direct dma from a pci device to pci-e device
References: <4AAA5B1F.3020103@compro.net> <20090911154714.70a94454@lxorguk.ukuu.org.uk> <4AAA6BE7.8040306@compro.net> <48E3B73EAC22453CA65D2431F2F47B69@Route495PC>
In-Reply-To: <48E3B73EAC22453CA65D2431F2F47B69@Route495PC>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard B. Johnson wrote:
> ----- Original Message ----- From: "Mark Hounschell" <markh@compro.net>
> To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
> Cc: <linux-pci@vger.kernel.org>; "Mark Hounschell" <dmarkh@cfl.rr.com>;
> <linux-kernel@vger.kernel.org>
> Sent: Friday, September 11, 2009 11:25 AM
> Subject: Re: problems doing direct dma from a pci device to pci-e device
> 
> 
>> Alan Cox wrote:
>>>> I now have an AM3 based DFI DK 790FXB-M3H5 motherboard. This board
>>>> has 3 regular
>>>> PCI slots and 3 PCI-E (16x) slots. I also have a PCI-E (x4) version
>>>> of the VMIC-5565
>>>> reflective memory  card in one of the PCI-E slots and our gpiohsd
>>>> card in one of the regular
>>>> PCI slots. All on the motherboard. No expansion slots being used.
>>>> However I cannot get
>>>> data from our gpiohsd into the PCI-E VMIC-5565 cards memory. I can
>>>> certainly get the data there
>>>> from a userland buffer, no problem. Just not from one card to the
>>>> other directly. Oh and when
>>>> I put the regular PCI version of the VMIC into one of the regular
>>>> PCI slots everything works
>>>> as expected. They are then both on the same PCI bus and no bridges
>>>> are involved though.
> 
> The read I mentioned was a read immediately following the DMA operation.
> Some PCI (PCI-X using
> a HyperTransport serial bus) implimentations deliberately time-out to
> prevent a hung system. The result
> that I've seen was no data anywhere. It just vanished!
> 
> Reading the destination a few milliseconds (or seconds) later won't
> prevent this timeout!
> 
 
How about a couple hundred usecs? Along that line, I can make it do dma reads
from that VMIC card also. All I get is ones. It's strange that in this case, my gpiohsd
isn't reporting any kind of pci bus error in it's status register.

Thanks
Mark


