Return-Path: <linux-kernel-owner+w=401wt.eu-S1761164AbXJRFiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761164AbXJRFiR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 01:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760701AbXJRFh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 01:37:58 -0400
Received: from rtr.ca ([76.10.145.34]:4732 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760633AbXJRFh5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 01:37:57 -0400
Message-ID: <4716F134.2060002@rtr.ca>
Date: Thu, 18 Oct 2007 01:37:56 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>, Linus Torvalds <torvalds@osdl.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: 2.6.23-git12: WARNING: at fs/sysfs/dir.c:424 sysfs_add_one()
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


usb 5-1: new high speed USB device using ehci_hcd and address 2
usb 5-1: configuration #1 chosen from 1 choice
hub 5-1:1.0: USB hub found
hub 5-1:1.0: 4 ports detected
sysfs: duplicate filename 'bInterfaceNumber' can not be created
WARNING: at fs/sysfs/dir.c:424 sysfs_add_one()
 [sysfs_add_one+159/224] sysfs_add_one+0x9f/0xe0
hda_intel: azx_get_response timeout, switching to polling mode: last cmd=0x010f000c
 [sysfs_add_file+79/144] sysfs_add_file+0x4f/0x90
b44: eth0: Link is up at 100 Mbps, full duplex.
b44: eth0: Flow control is off for TX and off for RX.
 [sysfs_create_group+103/256] sysfs_create_group+0x67/0x100
 [klist_add_tail+30/80] klist_add_tail+0x1e/0x50
 [device_add+61/1472] device_add+0x3d/0x5c0
 [<f88a3adc>] usb_create_sysfs_intf_files+0x2c/0xb0 [usbcore]
 [<f889f701>] usb_set_configuration+0x391/0x5d0 [usbcore]
 [<f88a7c16>] generic_probe+0x76/0xb0 [usbcore]
 [<f88a1343>] usb_probe_device+0x33/0x40 [usbcore]
 [driver_probe_device+142/400] driver_probe_device+0x8e/0x190
 [klist_next+93/160] klist_next+0x5d/0xa0
 [bus_for_each_drv+68/112] bus_for_each_drv+0x44/0x70
 [device_attach+125/144] device_attach+0x7d/0x90
 [__device_attach+0/16] __device_attach+0x0/0x10
 [bus_attach_device+77/160] bus_attach_device+0x4d/0xa0
 [bus_add_device+300/352] bus_add_device+0x12c/0x160
 [device_add+1155/1472] device_add+0x483/0x5c0
 [<f889a274>] usb_new_device+0x54/0xa0 [usbcore]
 [<f889ab9a>] hub_thread+0x45a/0xca0 [usbcore]
 [schedule+460/1680] schedule+0x1cc/0x690
 [autoremove_wake_function+0/80] autoremove_wake_function+0x0/0x50
 [<f889a740>] hub_thread+0x0/0xca0 [usbcore]
 [kthread+66/112] kthread+0x42/0x70
 [kthread+0/112] kthread+0x0/0x70
 [kernel_thread_helper+7/24] kernel_thread_helper+0x7/0x18
 =======================
NET: Registered protocol family 17
