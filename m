Return-Path: <linux-kernel-owner+w=401wt.eu-S1754748AbYA0BpG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748AbYA0BpG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 20:45:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752487AbYA0Boz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 20:44:55 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:42925 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211AbYA0Boy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 20:44:54 -0500
Date: Sat, 26 Jan 2008 19:46:02 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Custom PCIe Device Driver
In-reply-to: <fa.lEecbnbm5VCSz+Y6rXCe4LJLkqw@ifi.uio.no>
To: Sanka Piyaratna <sanka@solinnov.com.au>
Cc: linux-kernel@vger.kernel.org
Message-id: <479BE25A.3060206@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.lEecbnbm5VCSz+Y6rXCe4LJLkqw@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sanka Piyaratna wrote:
> Hi Everyone,
> 
> I am currently developing a custom PCIe device and the Linux kernel 
> driver for this. I am able to use the device as a character device with 
> PIO and now I am working on getting the DMA to work. I have implemented 
> 2 BARs (BAR0 - mem and BAR5 - mem) in the PCIe device. I have 
> implemented the DMA in my custom device firmware to transfer a block of 
> memory via the PCIe bus and now trying to get this to work with the 
> device driver.
> 
> As I understand it, I can get hold of the PCI bus to become the bus 
> master and then initiate the DMA transfer from my device. However, I 
> don't understand how I can specify within my kernel driver how to 
> specify which BAR to use.
> 
> Does this mean when I initiate a transfer from the hardware, the memory 
> get transferred into the location allocated by by  pci_map_single() 
> function regardless of which BAR the memory comes from? or do I need to 
> specify the BAR using a mask?
> 
> Would some one be able to point me to an example code please?
> 
> Thanks and Regards,
> 
> Sanka

Your question doesn't seem to make much sense. DMA transfers have 
nothing to do with BARs at all, they don't come "from" or "to" one.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

