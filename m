Return-Path: <linux-kernel-owner+w=401wt.eu-S1756227AbXKUWXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227AbXKUWXR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 17:23:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755818AbXKUWXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 17:23:05 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47018 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753415AbXKUWXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 17:23:02 -0500
Date: Wed, 21 Nov 2007 14:22:39 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Kirill A. Shutemov" <k.shutemov@velesys.com>
Cc: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
Subject: Re: 2.6.24-rc3-mm1: usb mouse doesn't work
Message-Id: <20071121142239.bff7206b.akpm@linux-foundation.org>
In-Reply-To: <20071121182346.GA4280@localhost.localdomain>
References: <20071120204525.ff27ac98.akpm@linux-foundation.org>
	<20071121182346.GA4280@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Nov 2007 20:23:46 +0200
"Kirill A. Shutemov" <k.shutemov@velesys.com> wrote:

> USB mouse(Logitech M-BT58) doesn't work. TouchPad works.
> dmesg after rmmod usbcore && modprobe uhci_hcd:
> 
> usbcore: registered new interface driver usbfs
> usbcore: registered new interface driver hub
> usbcore: registered new device driver usb
> USB Universal Host Controller Interface driver v3.0
> ACPI: PCI Interrupt 0000:00:1d.0[A] -> Link [LNKE] -> GSI 10 (level, low)
> -> IRQ 10
> PCI: Setting latency timer of device 0000:00:1d.0 to 64
> uhci_hcd 0000:00:1d.0: UHCI Host Controller
> uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
> uhci_hcd 0000:00:1d.0: irq 10, io base 0x0000bf80
> usb usb1: configuration #1 chosen from 1 choice
> hub 1-0:1.0: USB hub found
> hub 1-0:1.0: 2 ports detected
> usb usb1: new device found, idVendor=0000, idProduct=0000
> usb usb1: new device strings: Mfr=3, Product=2, SerialNumber=1
> usb usb1: Product: UHCI Host Controller
> usb usb1: Manufacturer: Linux 2.6.24-kas-alt1 uhci_hcd
> usb usb1: SerialNumber: 0000:00:1d.0
> ACPI: PCI Interrupt 0000:00:1d.1[B] -> Link [LNKF] -> GSI 11 (level, low)
> -> IRQ 11
> PCI: Setting latency timer of device 0000:00:1d.1 to 64
> uhci_hcd 0000:00:1d.1: UHCI Host Controller
> uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
> uhci_hcd 0000:00:1d.1: irq 11, io base 0x0000bf60
> usb usb2: configuration #1 chosen from 1 choice
> hub 2-0:1.0: USB hub found
> hub 2-0:1.0: 2 ports detected
> usb usb2: new device found, idVendor=0000, idProduct=0000
> usb usb2: new device strings: Mfr=3, Product=2, SerialNumber=1
> usb usb2: Product: UHCI Host Controller
> usb usb2: Manufacturer: Linux 2.6.24-kas-alt1 uhci_hcd
> usb usb2: SerialNumber: 0000:00:1d.1
> ACPI: PCI Interrupt 0000:00:1d.2[C] -> Link [LNKG] -> GSI 9 (level, low)
> -> IRQ 9
> PCI: Setting latency timer of device 0000:00:1d.2 to 64
> uhci_hcd 0000:00:1d.2: UHCI Host Controller
> uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 3
> uhci_hcd 0000:00:1d.2: irq 9, io base 0x0000bf40
> usb usb3: configuration #1 chosen from 1 choice
> hub 3-0:1.0: USB hub found
> hub 3-0:1.0: 2 ports detected
> usb usb3: new device found, idVendor=0000, idProduct=0000
> usb usb3: new device strings: Mfr=3, Product=2, SerialNumber=1
> usb usb3: Product: UHCI Host Controller
> usb usb3: Manufacturer: Linux 2.6.24-kas-alt1 uhci_hcd
> usb usb3: SerialNumber: 0000:00:1d.2
> ACPI: PCI Interrupt 0000:00:1d.3[D] -> Link [LNKH] -> GSI 7 (level, low)
> -> IRQ 7
> PCI: Setting latency timer of device 0000:00:1d.3 to 64
> uhci_hcd 0000:00:1d.3: UHCI Host Controller
> uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 4
> uhci_hcd 0000:00:1d.3: irq 7, io base 0x0000bf20
> usb usb4: configuration #1 chosen from 1 choice
> hub 4-0:1.0: USB hub found
> hub 4-0:1.0: 2 ports detected
> usb usb4: new device found, idVendor=0000, idProduct=0000
> usb usb4: new device strings: Mfr=3, Product=2, SerialNumber=1
> usb usb4: Product: UHCI Host Controller
> usb usb4: Manufacturer: Linux 2.6.24-kas-alt1 uhci_hcd
> usb usb4: SerialNumber: 0000:00:1d.3
> uhci_hcd 0000:00:1d.3: FGR not stopped yet!
> 

I've had some strangenesses with USB lately.  Sometimes running `lsusb'
makes the USB system notice a newly attached device.

Is that "FGR not stopped yet!" messgae new behaviour?
