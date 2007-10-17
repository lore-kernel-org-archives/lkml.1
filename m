Return-Path: <linux-kernel-owner+w=401wt.eu-S1762386AbXJQXjA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762386AbXJQXjA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 19:39:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757004AbXJQXid
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 19:38:33 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:52727 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757735AbXJQXic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 19:38:32 -0400
Date: Wed, 17 Oct 2007 17:37:03 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Understanding lspci output
In-reply-to: <fa.FcCntqDHRe76qrRi4OjUjOq2ak4@ifi.uio.no>
To: John Sigler <linux.kernel@free.fr>
Cc: Martin Mares <mj@ucw.cz>, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz
Message-id: <47169C9F.9040809@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.l0Y1Suv/oOMZej6qugSY8HCfo78@ifi.uio.no>
 <fa.5QGRWM6v1/dwLaQe8D1zMU1KZeM@ifi.uio.no>
 <fa.FcCntqDHRe76qrRi4OjUjOq2ak4@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

John Sigler wrote:
>>> 4. Does the system have a PCI-X bus?
>>
>> Yes, the devices on bus 01 are PCI-X devices, so there is a PCI-X bus.
> 
> I thought PCI-X devices could operate on a PCI bus? If that is true, 
> then the presence of a PCI-X device would not necessarily imply the 
> presence of a PCI-X bus, right?
> 
> There are no external PCI-X slots in the system, only 2 PCI slots.
> The 4 NICs are integrated to the motherboard.
> http://advantech.com/products/1U-Rackmount-Intel-Pentium-4Processor-based-Platform-with-4PCI-LAN-Ports-2-PCI-Expansion-Slots/mod_1-23A2W4.aspx 

The NICs are all PCI-X devices and they report "64bit+" so they will be 
running on a PCI-X bus internally.

> 
> 
>>> 2. Do any of the PCI buses support 66 MHz operation?
>>
>> Yes, PCI-X does.
> 
> So the 01:0f.0 device (Multimedia video controller) is on the same bus 
> as the 4 PCI-X devices and will have to share the bus bandwidth?
> 
> Does 66MHz+ in the Status line means this device is running at 66 MHz?

I believe so.

> 
>>> 3. Do any of the PCI slots support 64-bit data path?
>>
>> This cannot be inferred from the lspci output -- there is no way how to
>> tell if a bus has physical slots or it exists only internally.
> 
> Can I use lspci to see whether a specific PCI device is using a 64-bit 
> data path? (e.g. the 01:0f.0 device)

The "Multimedia video controller: DekTec Digital Video B.V. DTA-105" 
doesn't report PCI-X capabilities. And looking at the card on their web 
site, it does not have a 64-bit extension, so it doesn't support 64-bit.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

