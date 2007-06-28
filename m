Return-Path: <linux-kernel-owner+w=401wt.eu-S1756542AbXFUPdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756542AbXFUPdl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 11:33:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753654AbXFUPde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 11:33:34 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:52145 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753550AbXFUPdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 11:33:33 -0400
Message-ID: <4683D4A0.3000100@anagramm.de>
Date: Thu, 28 Jun 2007 17:32:48 +0200
From: Clemens Koller <clemens.koller@anagramm.de>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: pharon@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: Dual slot PCI riser messes up ivtv
References: <fa.ELPuDi4dcntxF8hk4oCNldcvgoc@ifi.uio.no> <467A89D4.6080607@shaw.ca>
In-Reply-To: <467A89D4.6080607@shaw.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Provags-ID: V01U2FsdGVkX19yVPm8P9NTLQsgKySOE64luE4WsNbLH3dLPdR
 W5fdc51Frqo9IGa5XmmuDAa5hEigzArjsacCiPcsDu/atR5PN1
 O/gzi33uOm4wh/SoUwfdw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Robert!

Robert Hancock schrieb:
> Islam Amer wrote:
 >> I am trying to build a settop box with two cards, a PVR-150 and a DVB
 >> card. The mini-ITX motherboard has only one PCI slot, so I bought an
 >> active PCI riser.

Please define "active". Is there a PCI bridge chip on the riser card?
Or better: Tell us manufacturer and type of this PCI riser card and the
mini-ITX board.

I am using a 1 to 3 PCI Bus riser card (passive, noname, bought it on ebay
some years ago).
The important thing is that in that case the IRQn lines as well as
the REQ#n and GNT#n lines are routed and coupled to the right IDSEL's of
the slots. It might be possible that the mini-ITX motherboard's PCI
configuration (BIOS) is limited there.
(This could propably be fixed in the kernel. At least in embedded
environments, it's common to have all PCI ID/IRQ routing
information in the kernel (or in the DeviceTree or OpenFirmware nowadays))

>> First I tried with two cheap lifeview cards on the riser and they
>> worked.

Propably they didn't need an interrupt?
$ cat /proc/interrupts ?

>> The PVR-150 is working fine alone, and so does the DVB card. But when I
>> use them with the riser nothing works.
> 
> Please post the output of lspci -vvv with the cards installed in the riser.

IRQ/IDSEL misconfiguration doesn't necessarily show up there.
Drivers might end up doing strange things if the IRQ never comes thru.
(experienced with Promise PDC20775 and PDC20269 HDD Controllers
on embedded PowerPC)

Just my $.05

Regards,
-- 
Clemens Koller
__________________________________
R&D Imaging Devices
Anagramm GmbH
Rupert-Mayer-Straße 45/1
Linhof Werksgelände
D-81379 München
Tel.089-741518-50
Fax 089-741518-19
http://www.anagramm-technology.com
