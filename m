Return-Path: <linux-kernel-owner+w=401wt.eu-S1759892AbXHODzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759892AbXHODzq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 23:55:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752973AbXHODzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 23:55:36 -0400
Received: from mtl.rackplans.net ([69.90.0.18]:55445 "EHLO mtl.rackplans.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751345AbXHODzf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 23:55:35 -0400
X-Greylist: delayed 1140 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Aug 2007 23:55:35 EDT
Date: Tue, 14 Aug 2007 23:36:32 -0400 (EDT)
From: Gerhard Mack <gmack@innerfire.net>
X-X-Sender: gmack@mtl.rackplans.net
To: linux-kernel@vger.kernel.org
Subject: 2.6.23-rc3: sysfs_remove_bin_file: bad dentry or inode or no such
 file: "descriptors"
Message-ID: <alpine.DEB.0.999.0708142335120.21213@mtl.rackplans.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

hello, 

Got this when I booted into 2.6.23-rc3:  Let me know if more info is 
needed.

	Gerhard


sysfs_remove_bin_file: bad dentry or inode or no such file: "descriptors"

Call Trace:
 [<ffffffff80480117>] usb_remove_sysfs_dev_files+0x89/0x9d
 [<ffffffff8047cf29>] usb_unbind_device+0x15/0x19
 [<ffffffff803f855e>] __device_release_driver+0x8e/0xb0
 [<ffffffff803f8953>] device_release_driver+0x2c/0x44
 [<ffffffff803f7e56>] bus_remove_device+0x6e/0x7d
 [<ffffffff803f6641>] device_del+0x1ec/0x268
 [<ffffffff80477af3>] usb_disconnect+0xbc/0x149
 [<ffffffff804782c2>] hub_thread+0x3f8/0xba5
 [<ffffffff805e3463>] thread_return+0x57/0xdf
 [<ffffffff80244f0b>] autoremove_wake_function+0x0/0x2e
 [<ffffffff80477eca>] hub_thread+0x0/0xba5
 [<ffffffff80244df3>] kthread+0x47/0x74
 [<ffffffff8020c588>] child_rip+0xa/0x12
 [<ffffffff8021b96a>] flat_send_IPI_mask+0x0/0x4c
 [<ffffffff80244dac>] kthread+0x0/0x74
 [<ffffffff8020c57e>] child_rip+0x0/0x12



--
Gerhard Mack

gmack@innerfire.net

<>< As a computer I find your faith in technology amusing.
