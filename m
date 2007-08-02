Return-Path: <linux-kernel-owner+w=401wt.eu-S1755431AbXHBHQD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431AbXHBHQD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 03:16:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752677AbXHBHPy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 03:15:54 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:54511 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286AbXHBHPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 03:15:53 -0400
Message-ID: <46B1844B.8090007@netcom.eu>
Date: Thu, 02 Aug 2007 09:14:19 +0200
From: David Engraf <david.engraf@netcom.eu>
User-Agent: Thunderbird 2.0.0.5 (X11/20070716)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       gregkh@suse.de, linux-usb-devel@lists.sourceforge.net
Subject: Re: [linux-usb-devel] [PATCH] USB BIOS early handoff only when the
 we the driver is configured
References: <Pine.LNX.4.44L0.0708011038130.3764-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0708011038130.3764-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Provags-ID: V01U2FsdGVkX1/ZEwhwSAvw9gGoLYe0DCsv01M6GKHaQxLfImD
 nVHE3I49ZYoeLhj0hd+scy+uehPeVCQTJznimCQOjOqM73QTKU
 FLCFbP+dzPHW9bq/3lcMA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Alan Stern schrieb:
> On Wed, 1 Aug 2007, David Engraf wrote:
>
>   
>> At the moment I have a Jetway/VIA Mainboard which seems to have a problem
>> with the handoff. Even
>> when I wait about 20 seconds the EHCI_USBLEGSUP_BIOS flag is not cleared.
>> I think this is a BIOS
>> bug and I will have to talk to Jetway/VIA.
>>     
>
> I have the same problem on my Intel motherboard.  Which is surprising, 
> considering that Intel invented the BIOS-handoff technique.
>
>   
Ok, so even Intel has problems with the handoff.
>> On the other hand, I don't need the EHCI controller in my kernel, so I
>> think the kernel shouldn't take the
>> handover for the EHCI controller like other OS which do not have an usb
>> driver and so don't know that
>> there is a EHCI_USBLEGSUP_BIOS flag which should be cleared.
>>     
>
> There ought to be a solution to satisfy everybody.  For instance, you 
> could add a Kconfig flag for enabling USB handoff, and make it be 
> selected automatically if any of the PCI USB drivers are configured.
>
> Alan Stern
>
>   
This would be solution too, but what if someone uses the uhci controller
and don't want the
ehci. So a single Kconfig flag wouldn't be enough, we have to add 3
flags for uchi, ohci and
ehci. I think this maybe a little bit difficult when configuring the kernel.
The best solution would be when we could use the CONFIG_USB_xxxx_HCD
flag, but it
seems that some hardware has problems when we disable the handoff and
let the BIOS
control the usb controller. Do you know any of this hardware?

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

