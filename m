Return-Path: <linux-kernel-owner+w=401wt.eu-S1761511AbXJQL6E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761511AbXJQL6E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 07:58:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761614AbXJQL5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 07:57:39 -0400
Received: from smtp4-g19.free.fr ([212.27.42.30]:45641 "EHLO smtp4-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761226AbXJQL5i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 07:57:38 -0400
Message-ID: <4715F8B0.6080107@free.fr>
Date: Wed, 17 Oct 2007 13:57:36 +0200
From: John Sigler <linux.kernel@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061108 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Martin Mares <mj@ucw.cz>
CC: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: Understanding lspci output
References: <4715D119.7000508@free.fr> <mj+md-20071017.110231.1634.nikam@ucw.cz>
In-Reply-To: <mj+md-20071017.110231.1634.nikam@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Martin,

Martin Mares wrote:

>> I ran lspci -vvv on a system:
>> http://linux.kernel.free.fr/halt/lspci.txt
>>
>> (I used lspci version 2.2.5 in case it matters.)
>>
>> But I'm having a hard time making sense of the output.
>>
>> 1. How many PCI buses are there in the system?
> 
> Two, just see the bus numbers of the devices. (However, there might be
> additional buses with no devices present and in case these are connected
> to a separate host bridge, they need not be visible.)
> 
>> 4. Does the system have a PCI-X bus?
> 
> Yes, the devices on bus 01 are PCI-X devices, so there is a PCI-X bus.

I thought PCI-X devices could operate on a PCI bus? If that is true, 
then the presence of a PCI-X device would not necessarily imply the 
presence of a PCI-X bus, right?

There are no external PCI-X slots in the system, only 2 PCI slots.
The 4 NICs are integrated to the motherboard.
http://advantech.com/products/1U-Rackmount-Intel-Pentium-4Processor-based-Platform-with-4PCI-LAN-Ports-2-PCI-Expansion-Slots/mod_1-23A2W4.aspx

>> 2. Do any of the PCI buses support 66 MHz operation?
> 
> Yes, PCI-X does.

So the 01:0f.0 device (Multimedia video controller) is on the same bus 
as the 4 PCI-X devices and will have to share the bus bandwidth?

Does 66MHz+ in the Status line means this device is running at 66 MHz?

>> 3. Do any of the PCI slots support 64-bit data path?
> 
> This cannot be inferred from the lspci output -- there is no way how to
> tell if a bus has physical slots or it exists only internally.

Can I use lspci to see whether a specific PCI device is using a 64-bit 
data path? (e.g. the 01:0f.0 device)

Regards.
