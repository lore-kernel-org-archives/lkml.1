Return-Path: <linux-kernel-owner+w=401wt.eu-S1764220AbXLUCR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764220AbXLUCR1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 21:17:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753733AbXLUCRR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 21:17:17 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:32556 "EHLO
	pd2mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551AbXLUCRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 21:17:16 -0500
Date: Thu, 20 Dec 2007 20:15:52 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [Fwd: Re: [PATCH 0/5]PCI: x86 MMCONFIG]
In-reply-to: <476B185D.3000409@redhat.com>
To: tcamuso@redhat.com
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz,
       "Chumbalkar, Nagananda" <Nagananda.Chumbalkar@hp.com>,
       Prarit Bhargava <prarit@redhat.com>, bnagendr@redhat.com
Message-id: <476B21D8.2030602@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 8BIT
References: <fa.HvUNJ45qy60H427u0v9fNt3Gc7E@ifi.uio.no>
 <fa.uuzqvr64HFsgxfiWwhEmE16Di6c@ifi.uio.no>
 <fa.zhxdNN/1rfQhfJLVmdGBjvKYrCM@ifi.uio.no>
 <fa.z1qlON6DA9ubBPFdrEcaFTMgYOY@ifi.uio.no>
 <fa.U/SCC1Gvd3nSOpkMu5vcsSPYyPE@ifi.uio.no>
 <fa.d8kGTkzOZH22bXRIRiakqgOPBM4@ifi.uio.no> <476B0C58.4030703@shaw.ca>
 <476B185D.3000409@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tony Camuso wrote:
> Robert Hancock wrote:
> 
>> First off, I would like to see confirmation from the horses's mouths 
>> here (namely AMD, ServerWorks/Broadcom, and whoever else) that there 
>> is no other way to get around this problem than disabling MMCONFIG for 
>> accesses behind those chips.
>>
> 
> I happen to have this one stored in my desktop.
> 
>  From AMD-8132TM HyperTransportTM
>      PCI-X®2.0 Tunnel
>       Revision Guide
> 
> http://www.amd.com/us-en/assets/content_type/white_papers_and_tech_docs/30801.pdf 
> 
> 
> 79 AMD-8132TM Tunnel Lacks Extended Configuration
>         Space Memory-Mapped I/O Base Address Register
> 
> Description
> 
> Current AMD processors do not natively support PCI-defined extended 
> configuration space. A memory
> mapped I/O base address register (MMIO BAR) is required in chipset 
> devices to support extended
> configuration space. The AMD-8132 does not have this MMIO BAR.
> Potential Effect On System
> 
> The AMD-8132 is a PCI-X® Mode 2 capable device and requires the MMIO BAR 
> to support extended
> configuration space. Using a device which does have this MMIO BAR and an 
> AMD-8132 on the same
> HyperTransportTM link of the processor may cause firmware/software 
> problems.
> 
> The base configuration space of the AMD-8132 and PCI(-X) devices 
> attached to it are accessible using only
> the mechanism defined in PCI 2.3. Registers of PCI-X Mode 2 devices 
> attached to the AMD-8132 in the
> extended configuration space are not accessible. The AMD-8132 has no 
> registers in the extended
> configuration space.
> 
> Suggested Workaround
> 
> It is strongly recommended that system designers do not connect the 
> AMD-8132 and devices that use extended
> configuration space MMIO BARs (ex: HyperTransport-to-PCI Express® 
> bridges) to the same processor
> HyperTransport link.
> 
> Fix Planned
> No

That does sound fairly definitive. I have to wonder why certain system 
designers then didn't follow their strong recommendation..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

