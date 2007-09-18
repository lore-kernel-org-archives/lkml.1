Return-Path: <linux-kernel-owner+w=401wt.eu-S1757926AbXIROaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757926AbXIROaa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 10:30:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755295AbXIROaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 10:30:22 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59109 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754735AbXIROaV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 10:30:21 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
Subject: Re: PCI Interrupt
Date: Tue, 18 Sep 2007 16:42:22 +0200
User-Agent: KMail/1.9.5
Cc: Duncan.Perrett@elekta.com, "Linux kernel" <linux-kernel@vger.kernel.org>
References: <OF031C3237.A0A88CB3-ON8025735A.0048E354-8025735A.00490635@elekta.com> <Pine.LNX.4.61.0709180955360.6632@chaos.analogic.com>
In-Reply-To: <Pine.LNX.4.61.0709180955360.6632@chaos.analogic.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709181642.23070.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 18 September 2007 15:57, linux-os (Dick Johnson) wrote:
> 
> On Tue, 18 Sep 2007 Duncan.Perrett@elekta.com wrote:
> 
> >
> > I have a CAN PCI card installed on my Ubuntu box.
> > I understand that PCI interrupts should be level rather than edge
> > triggered.
> >
> > The output of cat /proc/interrupts is :-
> >
> >           CPU0
> >  0:    1614601    IO-APIC-edge  timer
> >  1:        164    IO-APIC-edge  i8042
> >  8:          3    IO-APIC-edge  rtc
> >  9:          1   IO-APIC-level  acpi
> > 12:          0    IO-APIC-edge  CAN-ACx-PCI_01
> > 14:      65786    IO-APIC-edge  ide0
> > 169:       3220   IO-APIC-level  eth0, i915@pci:0000:00:02.0
> > 177:      46459   IO-APIC-level  eth1
> > 209:          0   IO-APIC-level  uhci_hcd:usb3, eth2
> > 217:          2   IO-APIC-level  uhci_hcd:usb1, ehci_hcd:usb4
> > 225:        697   IO-APIC-level  uhci_hcd:usb2
> > NMI:          0
> > LOC:    1614399
> > ERR:          0
> > MIS:          0
> >
> > You see that irq 12 CAN-ACx-PCI_01 is edge triggered.
> > Is there any way of forcing the BIOS to see the interrupt as a
> > level-triggered one?
> 
> It's done in the driver. IRQ12 can be shared, so the driver
> needs to request the IRQ as a shared interrupt.

Hm, edge-triggered interrupts cannot be shared, AFAIK.

Greetings,
Rafael
