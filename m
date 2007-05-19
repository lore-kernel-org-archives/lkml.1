Return-Path: <linux-kernel-owner+w=401wt.eu-S1762823AbXESPBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762823AbXESPBY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 11:01:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758643AbXESPBR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 11:01:17 -0400
Received: from netrider.rowland.org ([192.131.102.5]:4397 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758709AbXESPBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 11:01:17 -0400
Date: Sat, 19 May 2007 11:01:14 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Andrey Borzenkov <arvidjaar@mail.ru>
cc: linux-kernel@vger.kernel.org, <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] 2.6.22-rc2: regression: STD fails with
 pci_device_suspend(): usb_hcd_pci_suspend+0x0/0x160 [usbcore]() returns -16
In-Reply-To: <200705191543.15110.arvidjaar@mail.ru>
Message-ID: <Pine.LNX.4.44L0.0705191058570.8729-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 May 2007, Andrey Borzenkov wrote:

> This works just fine up to and including 2.6.21.

> unfortunatelt dmesg got truncated; if required I can rebuild with larger 
> buffer; the part around suspend is
> 
> swsusp: Marking nosave pages: 000000000009f000 - 0000000000100000
> swsusp: Basic memory bitmaps created
> Stopping tasks ... done.
> Shrinking memory... done (14553 pages freed)
> Freed 58212 kbytes in 0.30 seconds (194.04 MB/s)
> Suspending console(s)
> sd 0:0:0:0: [sda] Synchronizing SCSI cache
> pnp: Device 00:09 disabled.
> ACPI: PCI interrupt for device 0000:00:0a.0 disabled
> Trying to free already-free IRQ 11
> ACPI: PCI interrupt for device 0000:00:06.0 disabled
> ACPI: Unable to derive IRQ for device 0000:00:04.0
> pci_device_suspend(): usb_hcd_pci_suspend+0x0/0x160 [usbcore]() returns -16
> suspend_device(): pci_device_suspend+0x0/0x70() returns -16
> Could not suspend device 0000:00:02.0: error -16

Please turn on CONFIG_USB_DEBUG and post the resulting dmesg log.

Alan Stern

