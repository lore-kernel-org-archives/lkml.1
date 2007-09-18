Return-Path: <linux-kernel-owner+w=401wt.eu-S1755973AbXIRN6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973AbXIRN6p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 09:58:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754316AbXIRN6i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 09:58:38 -0400
Received: from odyssey.analogic.com ([204.178.40.5]:4547 "EHLO
	odyssey.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754735AbXIRN6h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 09:58:37 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 18 Sep 2007 13:57:11.0497 (UTC) FILETIME=[CF652B90:01C7F9FB]
Content-class: urn:content-classes:message
Subject: Re: PCI Interrupt
Date: Tue, 18 Sep 2007 09:57:57 -0400
Message-ID: <Pine.LNX.4.61.0709180955360.6632@chaos.analogic.com>
In-Reply-To: <OF031C3237.A0A88CB3-ON8025735A.0048E354-8025735A.00490635@elekta.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: PCI Interrupt
Thread-Index: Acf5+8+L7MBbnZSATmK5vRAggBSwrA==
References: <OF031C3237.A0A88CB3-ON8025735A.0048E354-8025735A.00490635@elekta.com>
From: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
To: <Duncan.Perrett@elekta.com>
Cc: "Linux kernel" <linux-kernel@vger.kernel.org>
Reply-To: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 18 Sep 2007 Duncan.Perrett@elekta.com wrote:

>
> I have a CAN PCI card installed on my Ubuntu box.
> I understand that PCI interrupts should be level rather than edge
> triggered.
>
> The output of cat /proc/interrupts is :-
>
>           CPU0
>  0:    1614601    IO-APIC-edge  timer
>  1:        164    IO-APIC-edge  i8042
>  8:          3    IO-APIC-edge  rtc
>  9:          1   IO-APIC-level  acpi
> 12:          0    IO-APIC-edge  CAN-ACx-PCI_01
> 14:      65786    IO-APIC-edge  ide0
> 169:       3220   IO-APIC-level  eth0, i915@pci:0000:00:02.0
> 177:      46459   IO-APIC-level  eth1
> 209:          0   IO-APIC-level  uhci_hcd:usb3, eth2
> 217:          2   IO-APIC-level  uhci_hcd:usb1, ehci_hcd:usb4
> 225:        697   IO-APIC-level  uhci_hcd:usb2
> NMI:          0
> LOC:    1614399
> ERR:          0
> MIS:          0
>
> You see that irq 12 CAN-ACx-PCI_01 is edge triggered.
> Is there any way of forcing the BIOS to see the interrupt as a
> level-triggered one?

It's done in the driver. IRQ12 can be shared, so the driver
needs to request the IRQ as a shared interrupt.


Cheers,
Dick Johnson
Penguin : Linux version 2.6.22.1 on an i686 machine (5588.30 BogoMips).
My book : http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
