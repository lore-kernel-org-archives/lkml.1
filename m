Return-Path: <linux-kernel-owner+w=401wt.eu-S1766011AbXJORhv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766011AbXJORhv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 13:37:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765896AbXJORhL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 13:37:11 -0400
Received: from wr-out-0506.google.com ([64.233.184.232]:65161 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765837AbXJORhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 13:37:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=lstNbwwzbKshnY8U+3+9AnYLmK7ZA0k+r3SrvnJJFEtN7re14jqn5IDvuwspxlLc0dHmTDx8SOvLIPxmNZft3WbqJapuq2ClrL0l3xGFUrlmiOa9uBzg0apBkmOL9Wec9Nua8xBcc0V6NMdmgOAqKgwoNitWDpq95AgcO1oGnLc=
Message-ID: <86802c440710151037y75e6e8eex3e17da8763d68643@mail.gmail.com>
Date: Mon, 15 Oct 2007 10:37:04 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Greg KH" <gregkh@suse.de>, "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: usb
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

from linus's git this morning..

ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [LUB2] -> GSI 21 (level,
low) -> IRQ 21
ehci_hcd 0000:00:02.1: EHCI Host Controller
ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:02.1: debug port 1
ehci_hcd 0000:00:02.1: irq 21, io mem 0xdefbec00
ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 10 ports detected
ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [LUB0] -> GSI 22 (level,
low) -> IRQ 22
ohci_hcd 0000:00:02.0: OHCI Host Controller
ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:02.0: irq 22, io mem 0xdefbf000
usb 1-1: new high speed USB device using ehci_hcd and address 2
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 10 ports detected
USB Universal Host Controller Interface driver v3.0
Initializing USB Mass Storage driver...
usb 1-1: configuration #1 chosen from 1 choice
usb 1-6: new high speed USB device using ehci_hcd and address 5
usb 1-6: configuration #1 chosen from 1 choice
hub 1-6:1.0: USB hub found
hub 1-6:1.0: 4 ports detected
sysfs: duplicate filename 'bInterfaceNumber' can not be created
WARNING: at fs/sysfs/dir.c:425 sysfs_add_one()

Call Trace:
 [<ffffffff802bf326>] sysfs_add_one+0x54/0xbd
 [<ffffffff802bee22>] sysfs_add_file+0x50/0x81
 [<ffffffff802c07ec>] sysfs_create_group+0x9a/0xf2
 [<ffffffff80616cb6>] usb_create_sysfs_intf_files+0x32/0xc7
 [<ffffffff80613762>] usb_set_configuration+0x49d/0x4c0
 [<ffffffff8061a672>] generic_probe+0x53/0x95
 [<ffffffff804a57d3>] driver_probe_device+0xd3/0x150
 [<ffffffff804a5850>] __device_attach+0x0/0x5
 [<ffffffff804a4aec>] bus_for_each_drv+0x40/0x71
 [<ffffffff804a58db>] device_attach+0x63/0x7a
 [<ffffffff804a4a5e>] bus_attach_device+0x2a/0x78
 [<ffffffff804a3a20>] device_add+0x308/0x51e
 [<ffffffff8060ef04>] usb_new_device+0x47/0x80
 [<ffffffff8060facd>] hub_thread+0x75a/0xb4a
 [<ffffffff80245787>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8060f373>] hub_thread+0x0/0xb4a
 [<ffffffff8024565d>] kthread+0x47/0x76
 [<ffffffff8020ca58>] child_rip+0xa/0x12
 [<ffffffff80245616>] kthread+0x0/0x76
 [<ffffffff8020ca4e>] child_rip+0x0/0x12

usb 2-3: new full speed USB device using ohci_hcd and address 2
usb 2-3: configuration #1 chosen from 1 choice
hub 2-3:1.0: USB hub found
hub 2-3:1.0: 4 ports detected
usb 2-5: new low speed USB device using ohci_hcd and address 3
usb 2-5: configuration #1 chosen from 1 choice
scsi15 : SCSI emulation for USB Mass Storage devices
usb 2-3.1: new low speed USB device using ohci_hcd and address 4
usb 2-3.1: configuration #1 chosen from 1 choice
usb 2-3.4: new low speed USB device using ohci_hcd and address 5
usb 2-3.4: configuration #1 chosen from 1 choice

YH
