Return-Path: <linux-kernel-owner+w=401wt.eu-S1754562AbZIKP7y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562AbZIKP7y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 11:59:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754551AbZIKP7x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 11:59:53 -0400
Received: from smtp56.dc2.safesecureweb.com ([65.36.215.98]:37024 "EHLO
	smtp56.dc2.safesecureweb.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753634AbZIKP7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 11:59:53 -0400
X-Greylist: delayed 756 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Sep 2009 11:59:53 EDT
Message-ID: <48E3B73EAC22453CA65D2431F2F47B69@Route495PC>
From: "Richard B. Johnson" <RJohnson@Route495Software.com>
To: "\"Mark Hounschell\"" <dmarkh@cfl.rr.com>
Cc: <linux-pci@vger.kernel.org>, "Mark Hounschell" <dmarkh@cfl.rr.com>,
       <linux-kernel@vger.kernel.org>
References: <4AAA5B1F.3020103@compro.net> <20090911154714.70a94454@lxorguk.ukuu.org.uk> <4AAA6BE7.8040306@compro.net>
In-Reply-To: <4AAA6BE7.8040306@compro.net>
Subject: Re: problems doing direct dma from a pci device to pci-e device
Date: Fri, 11 Sep 2009 11:46:09 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Windows Mail 6.0.6001.18000
X-MimeOLE: Produced By Microsoft MimeOLE V6.0.6001.18049
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message ----- 
From: "Mark Hounschell" <markh@compro.net>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Cc: <linux-pci@vger.kernel.org>; "Mark Hounschell" <dmarkh@cfl.rr.com>; 
<linux-kernel@vger.kernel.org>
Sent: Friday, September 11, 2009 11:25 AM
Subject: Re: problems doing direct dma from a pci device to pci-e device


> Alan Cox wrote:
>>> I now have an AM3 based DFI DK 790FXB-M3H5 motherboard. This board has 3 
>>> regular
>>> PCI slots and 3 PCI-E (16x) slots. I also have a PCI-E (x4) version of 
>>> the VMIC-5565
>>> reflective memory  card in one of the PCI-E slots and our gpiohsd card 
>>> in one of the regular
>>> PCI slots. All on the motherboard. No expansion slots being used. 
>>> However I cannot get
>>> data from our gpiohsd into the PCI-E VMIC-5565 cards memory. I can 
>>> certainly get the data there
>>> from a userland buffer, no problem. Just not from one card to the other 
>>> directly. Oh and when
>>> I put the regular PCI version of the VMIC into one of the regular PCI 
>>> slots everything works
>>> as expected. They are then both on the same PCI bus and no bridges are 
>>> involved though.

The read I mentioned was a read immediately following the DMA operation. 
Some PCI (PCI-X using
a HyperTransport serial bus) implimentations deliberately time-out to 
prevent a hung system. The result
that I've seen was no data anywhere. It just vanished!

Reading the destination a few milliseconds (or seconds) later won't prevent 
this timeout!

Cheers,
Richard B. Johnson
http://Route495Software.com/






