Return-Path: <linux-kernel-owner+w=401wt.eu-S1755117AbYAZNPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755117AbYAZNPm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 08:15:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752904AbYAZNPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 08:15:34 -0500
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:47465 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752886AbYAZNPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 08:15:34 -0500
X-Greylist: delayed 303 seconds by postgrey-1.27 at vger.kernel.org; Sat, 26 Jan 2008 08:15:33 EST
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgAAAFK+mkd5LXfi/2dsb2JhbAAIkXObHQ
X-IronPort-AV: E=Sophos;i="4.25,254,1199626200"; 
   d="scan'208";a="29503631"
Message-ID: <479B313F.7050406@solinnov.com.au>
Date: Sat, 26 Jan 2008 23:40:23 +1030
From: Sanka Piyaratna <sanka@solinnov.com.au>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Custom PCIe Device Driver 
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Everyone,

I am currently developing a custom PCIe device and the Linux kernel 
driver for this. I am able to use the device as a character device with 
PIO and now I am working on getting the DMA to work. I have implemented 
2 BARs (BAR0 - mem and BAR5 - mem) in the PCIe device. I have 
implemented the DMA in my custom device firmware to transfer a block of 
memory via the PCIe bus and now trying to get this to work with the 
device driver.

As I understand it, I can get hold of the PCI bus to become the bus 
master and then initiate the DMA transfer from my device. However, I 
don't understand how I can specify within my kernel driver how to 
specify which BAR to use.

Does this mean when I initiate a transfer from the hardware, the memory 
get transferred into the location allocated by by  pci_map_single() 
function regardless of which BAR the memory comes from? or do I need to 
specify the BAR using a mask?

Would some one be able to point me to an example code please?

Thanks and Regards,

Sanka
