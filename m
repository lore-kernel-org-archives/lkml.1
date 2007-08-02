Return-Path: <linux-kernel-owner+w=401wt.eu-S1754697AbXHBHIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697AbXHBHIm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 03:08:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752163AbXHBHIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 03:08:34 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:65090 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107AbXHBHId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 03:08:33 -0400
Message-ID: <46B182AC.3080809@netcom.eu>
Date: Thu, 02 Aug 2007 09:07:24 +0200
From: David Engraf <david.engraf@netcom.eu>
User-Agent: Thunderbird 2.0.0.5 (X11/20070716)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: [linux-usb-devel] [PATCH] USB BIOS early handoff only when the
 we the driver is configured
References: <Pine.LNX.4.44L0.0707311058470.3520-100000@iolanthe.rowland.org> <46B03078.5040305@netcom.eu> <46B03468.3010307@netcom.eu> <20070801202347.GC11551@suse.de>
In-Reply-To: <20070801202347.GC11551@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Provags-ID: V01U2FsdGVkX19ovCIkqH3hcJK3BV4pNXL06F236wWVxyWguMZ
 bWc3fY/ljRN47dW+XLw8ev7llLvLHK6vHRozxzgANz3JcnnPTM
 paES3u09IM3IKD41DB2Sw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Greg KH schrieb:
> On Wed, Aug 01, 2007 at 09:21:12AM +0200, David Engraf wrote:
>   
>> At the moment I have a Jetway/VIA Mainboard which seems to have a
>> problem with the handoff.
>> Evenwhen I wait about 20 seconds the EHCI_USBLEGSUP_BIOS flag is not
>> cleared. I think this is a BIOS
>> bug and I will have to talk to Jetway/VIA.
>>     
>
> This sounds like a BIOS bug.
>   
I think so too and I have to talk to Jetway/VIA what there is going wrong.
>   
>> On the other hand, I don't need the EHCI controller in my kernel, so I
>> think the kernel shouldn't take the
>> handover for the EHCI controller like other OS which do not have an usb
>> driver and so don't know that
>> there is a EHCI_USBLEGSUP_BIOS flag which should be cleared.
>>     
>
> We need to do this early to handle a wide range of machines that do very
> nasty things if we do not grab the device as early as possible.  Even if
> we do not ever get around to loading that usb driver.
>
> Yeah, hardware sucks at times :(
>
>   
Ok, but when we don't habe the driver for the usb controller, I think
the BIOS should control it because
maybe the BIOS found for example a keyboard or mouse and emulates it as
an PS2 keayboard/mouse,
so we could use it without the usb driver. I think that's why they
developed the handoff feature.
Are there any known hardware which has problems when we disable the handoff?

> thanks,
>
> greg k-h
>   

Thanks

 
David Engraf

 

 
Netcom Sicherheitstechnik GmbH
Rheinallee 189
55120 Mainz
Tel: 	+49 6131 6305 0
Fax: 	+49 6131 6305 40
Email: 	david.engraf@netcom.eu

 
Sitz der Gesellschaft: Mainz
Registergericht: Amtsgericht Mainz, 14HRB3411
Geschäftsführer: Peter Otto

