Return-Path: <linux-kernel-owner+w=401wt.eu-S1759329AbYAJOCg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759329AbYAJOCg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 09:02:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754504AbYAJOC0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 09:02:26 -0500
Received: from odyssey.analogic.com ([204.178.40.5]:2273 "EHLO
	odyssey.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757823AbYAJOCY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 09:02:24 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 10 Jan 2008 14:01:58.0064 (UTC) FILETIME=[5D4B5300:01C85391]
Content-class: urn:content-classes:message
Subject: Re: Is it possible to change IRQ for certain device?
Date: Thu, 10 Jan 2008 09:01:37 -0500
Message-ID: <Pine.LNX.4.61.0801100855300.32310@chaos.analogic.com>
in-reply-to: <20080110110535.GA25706@hazard.jcu.cz>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Is it possible to change IRQ for certain device?
thread-index: AchTkV1Ua16ie5m9T6+A0FNiCCDgkg==
References: <20080110110535.GA25706@hazard.jcu.cz>
From: "linux-os (Dick Johnson)" <linux-os@analogic.com>
To: "Jan Marek" <linux@hazard.jcu.cz>
Cc: "lkml" <linux-kernel@vger.kernel.org>
Reply-To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 10 Jan 2008, Jan Marek wrote:

> Hello lkml,
>
> I have problem with my computer: I have motherboard with AMD690G chipset
> and nVidia VGA card. But I cannot set BIOS, to assign for VGA unique
> IRQ. VGA card is sharing IRQ with two ohci_hcd (USB 1.1 controllers).
> But when I want use for X proprietary nvidia driver, X didn't work with
> this errors:
>
> In dmesg:
>
> NVRM: RmInitAdapter failed! (0x23:0xffffffff:678)
> NVRM: rm_init_adapter(0) failed
>
> and in /var/log/Xorg.0.log:
>
> (II) Setting vga for screen 0.
> (**) NVIDIA(0): Depth 24, (--) framebuffer bpp 32
> (==) NVIDIA(0): RGB weight 888
> (==) NVIDIA(0): Default visual is TrueColor
> (==) NVIDIA(0): Using gamma correction (1.0, 1.0, 1.0)
> (**) NVIDIA(0): Enabling RENDER acceleration
> (II) NVIDIA(0): Support for GLX with the Damage and Composite X
> extensions is
> (II) NVIDIA(0):     enabled.
> (EE) NVIDIA(0): Failed to initialize the NVIDIA graphics device
> PCI:1:0:0.
> (EE) NVIDIA(0):     Please see the COMMON PROBLEMS section in the
> README for
> (EE) NVIDIA(0):     additional information.
> (EE) NVIDIA(0): Failed to initialize the NVIDIA graphics device!
> (EE) NVIDIA(0):  *** Aborting ***
> (II) UnloadModule: "nvidia"
> (II) UnloadModule: "fb"
> (EE) Screen(s) found, but none have a usable configuration.
>
> Fatal server error:
> no screens found
>
> I've found in README for NVIDIA, that VGA has to have unique IRQ. I've
> tried to set INTERRUPT_LINE and INTERRUPT_PIN with setpci tool, set
> pci=routeirq, pci=noacpi as the kernel boot parameters, but IRQ
> is still the same.
>
> Is there a way to change IRQ for VGA (or for ohci_hcd instead of VGA)
> directly in Linux?
>
> Thanks a lot.
>
> Sincerely
> Jan Marek

The interrupt lines are set by the traces on the PC board and
the contents of various "glue" chips and FPGAs. Many lap-tops,
for instance, only have one IRQ serving any PCI devices. If
your screen card can't share the only IRQ you have, it is
broken. Contact the vendor of both your motherboard (they
may have a BIOS upgrade) and the screen card (they may
have a fix).


Cheers,
Dick Johnson
Penguin : Linux version 2.6.22.1 on an i686 machine (5588.29 BogoMips).
My book : http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
