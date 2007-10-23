Return-Path: <linux-kernel-owner+w=401wt.eu-S1752747AbXJWPrH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747AbXJWPrH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 11:47:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752218AbXJWPq4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 11:46:56 -0400
Received: from www17.your-server.de ([213.133.104.17]:39449 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848AbXJWPq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 11:46:56 -0400
Message-ID: <471E1764.5040000@m3y3r.de>
Date: Tue, 23 Oct 2007 17:46:44 +0200
From: Thomas Meyer <thomas@m3y3r.de>
User-Agent: Thunderbird 2.0.0.6 (X11/20070803)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: WARNING: at fs/sysfs/dir.c:424 sysfs_add_one() with 4fa435018d740cb83d74c92306aa1f796da91ddd
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oct 23 17:13:55 [kernel] usb 1-1: new high speed USB device using
ehci_hcd and address 7
Oct 23 17:13:55 [kernel] usb 1-1: configuration #1 chosen from 1 choice
Oct 23 17:13:55 [kernel] hub 1-1:1.0: USB hub found
Oct 23 17:13:55 [kernel] hub 1-1:1.0: 4 ports detected
Oct 23 17:13:55 [kernel] sysfs: duplicate filename 'bInterfaceNumber'
can not be created
Oct 23 17:13:55 [kernel] WARNING: at fs/sysfs/dir.c:424 sysfs_add_one()
Oct 23 17:13:55 [kernel]  [<c01a37f0>] sysfs_add_one+0x54/0xb8
Oct 23 17:13:55 [kernel]  [<c01a332a>] sysfs_add_file+0x42/0x6a
Oct 23 17:13:55 [kernel]  [<c01a4a01>] sysfs_create_group+0x84/0xe7
Oct 23 17:13:55 [kernel]  [<c023e5ec>] device_add+0x44a/0x454
Oct 23 17:13:55 [kernel]  [<f88e774c>]
usb_create_sysfs_intf_files+0x24/0x98 [usbcore]
Oct 23 17:13:55 [kernel]  [<f88e4181>] usb_set_configuration+0x48f/0x4a9
[usbcore]
Oct 23 17:13:55 [kernel]  [<f88eabf3>] generic_probe+0x50/0x91 [usbcore]
Oct 23 17:13:55 [kernel]  [<f88e5817>] usb_probe_device+0x32/0x37 [usbcore]
Oct 23 17:13:55 [kernel]  [<c023fc11>] driver_probe_device+0xc5/0x148
Oct 23 17:13:55 [kernel]  [<c02d94bd>] klist_next+0x4b/0x6b
Oct 23 17:13:55 [kernel]  [<c023f14a>] bus_for_each_drv+0x35/0x5c
Oct 23 17:13:55 [kernel]  [<c023fd17>] device_attach+0x63/0x77
Oct 23 17:13:55 [kernel]  [<c023fc94>] __device_attach+0x0/0x5
Oct 23 17:13:55 [kernel]  [<c023f0c6>] bus_attach_device+0x26/0x75
Oct 23 17:13:55 [kernel]  [<c023e43d>] device_add+0x29b/0x454
Oct 23 17:13:55 [kernel]  [<f88dfc2e>] usb_new_device+0x4d/0x8a [usbcore]
Oct 23 17:13:55 [kernel]  [<f88e1149>] hub_thread+0x6f5/0xae2 [usbcore]
Oct 23 17:13:55 [kernel]  [<c02d9e72>] schedule+0x4b4/0x519
Oct 23 17:13:55 [kernel]  [<c013a1e1>] autoremove_wake_function+0x0/0x33
Oct 23 17:13:55 [kernel]  [<f88e0a54>] hub_thread+0x0/0xae2 [usbcore]
Oct 23 17:13:55 [kernel]  [<c013a119>] kthread+0x38/0x5f
Oct 23 17:13:55 [kernel]  [<c013a0e1>] kthread+0x0/0x5f
Oct 23 17:13:55 [kernel]  [<c0107bb7>] kernel_thread_helper+0x7/0x10
Oct 23 17:13:55 [kernel]  =======================


