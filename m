Return-Path: <linux-kernel-owner+w=401wt.eu-S1756659AbXEOVKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756659AbXEOVKe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 17:10:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754046AbXEOVK2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 17:10:28 -0400
Received: from www17.your-server.de ([213.133.104.17]:2703 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318AbXEOVK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 17:10:28 -0400
Message-ID: <464A215D.3010701@web.de>
Date: Tue, 15 May 2007 23:08:45 +0200
From: Thomas Meyer <thomas.mey@web.de>
User-Agent: Thunderbird 2.0.0.0 (X11/20070421)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: BUG: at include/linux/slub_def.h:89 kmalloc_index()
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

head: f653c34dd3d8bde2c918316fd5ba2e2c4f95afcf

May 15 23:02:07 [kernel] BUG: at include/linux/slub_def.h:89 kmalloc_index()
May 15 23:02:07 [kernel]  [<c015fc10>] get_slab+0x43/0x1cc
May 15 23:02:07 [kernel]  [<f934b101>] usb_get_configuration+0x93f/0xd06
[usbcore]
May 15 23:02:07 [kernel]  [<c0160d82>] __kmalloc_track_caller+0x10/0x62
May 15 23:02:07 [kernel]  [<c014ea37>] __kzalloc+0x11/0x3a
May 15 23:02:07 [kernel]  [<f934b101>] usb_get_configuration+0x93f/0xd06
[usbcore]
May 15 23:02:07 [kernel]  [<f934854f>] usb_control_msg+0xcf/0xd9 [usbcore]
May 15 23:02:07 [kernel]  [<f9348dff>] usb_get_descriptor+0x85/0xaf
[usbcore]
May 15 23:02:07 [kernel]  [<f93495ca>]
usb_get_device_descriptor+0x72/0x7c [usbcore]
May 15 23:02:07 [kernel]  [<f9344375>] hub_port_init+0x542/0x54c [usbcore]
May 15 23:02:07 [kernel]  [<f9344c44>] usb_new_device+0x17/0xed [usbcore]
May 15 23:02:07 [kernel]  [<f934581a>] hub_thread+0x6fb/0xa67 [usbcore]
May 15 23:02:07 [kernel]  [<c02c783c>] __sched_text_start+0x6cc/0x782
May 15 23:02:07 [kernel]  [<c012f7b5>] autoremove_wake_function+0x0/0x35
May 15 23:02:07 [kernel]  [<f934511f>] hub_thread+0x0/0xa67 [usbcore]
May 15 23:02:07 [kernel]  [<c012f6ea>] kthread+0x3b/0x61
May 15 23:02:07 [kernel]  [<c012f6af>] kthread+0x0/0x61
May 15 23:02:07 [kernel]  [<c0104917>] kernel_thread_helper+0x7/0x10
May 15 23:02:07 [kernel]  =======================


