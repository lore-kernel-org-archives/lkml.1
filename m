Return-Path: <linux-kernel-owner+w=401wt.eu-S1756084AbYEKQTY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084AbYEKQTY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 12:19:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754603AbYEKQTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 12:19:13 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:53614 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754598AbYEKQTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 12:19:11 -0400
Date: Sun, 11 May 2008 18:19:30 +0200
From: Pavel Machek <pavel@suse.cz>
To: kernel list <linux-kernel@vger.kernel.org>, gregkh@suse.de,
       marcel@holtmann.org, linux-bluetooth@vger.kernel.org
Subject: 2.6.26-rc1: warnings from sysfs, bluetooth related
Message-ID: <20080511161930.GA2179@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi!

I'm getting these from rfcomm...

								Pavel

 host4: resumed
scsi 4:0:0:0: Direct-Access     OLYMPUS  C765UZ           1.00 PQ: 0 ANSI: 2
sd 4:0:0:0: [sdb] 32000 512-byte hardware sectors (16 MB)
sd 4:0:0:0: [sdb] Write Protect is off
sd 4:0:0:0: [sdb] Mode Sense: 18 00 00 08
sd 4:0:0:0: [sdb] Assuming drive cache: write through
sd 4:0:0:0: [sdb] 32000 512-byte hardware sectors (16 MB)
sd 4:0:0:0: [sdb] Write Protect is off
sd 4:0:0:0: [sdb] Mode Sense: 18 00 00 08
sd 4:0:0:0: [sdb] Assuming drive cache: write through
 sdb: sdb1
sd 4:0:0:0: [sdb] Attached SCSI removable disk
sd 4:0:0:0: Attached scsi generic sg1 type 0
usb-storage: device scan complete
hci_cmd_task: hci0 command tx timeout
usb 5-1: USB disconnect, address 2
btusb_bulk_complete: hci0 urb f6191550 failed to resubmit (19)
btusb_bulk_complete: hci0 urb f6879090 failed to resubmit (19)
btusb_send_frame: hci0 urb f6879090 submission failed
hub 1-0:1.0: unable to enumerate USB device on port 7
usb 5-1: new full speed USB device using uhci_hcd and address 4
usb 5-1: configuration #1 chosen from 1 choice
usb 5-1: New USB device found, idVendor=0a5c, idProduct=2110
usb 5-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 5-1: Product: BCM2045B
usb 5-1: Manufacturer: Broadcom Corp
sysfs: duplicate filename 'rfcomm0' can not be created
------------[ cut here ]------------
WARNING: at /data/l/linux/fs/sysfs/dir.c:425 sysfs_add_one+0x85/0xa0()
Modules linked in:
Pid: 2011, comm: rfcomm Tainted: G        W 2.6.26-rc1 #289
 [<c022a2af>] warn_on_slowpath+0x5f/0x90
 [<c021c9e8>] __wake_up_common+0x48/0x70
 [<c02203e8>] __wake_up+0x38/0x50
 [<c022aa8b>] wake_up_klogd+0x3b/0x40
 [<c038510b>] ida_get_new_above+0x7b/0x180
 [<c02bd400>] sysfs_ilookup_test+0x0/0x10
 [<c0751214>] _spin_unlock+0x14/0x20
 [<c029037f>] ifind+0x8f/0xa0
 [<c022b23b>] printk+0x1b/0x20
 [<c02bd775>] sysfs_add_one+0x85/0xa0
 [<c02bdcc8>] create_dir+0x48/0x90
 [<c02bdd39>] sysfs_create_dir+0x29/0x50
 [<c0751214>] _spin_unlock+0x14/0x20
 [<c0385d66>] kobject_add_internal+0xb6/0x190
 [<c0385eb9>] kobject_set_name_vargs+0x29/0x50
 [<c0386201>] kobject_add+0x31/0x60
 [<c0385c2f>] kobject_get+0xf/0x20
 [<c04235ef>] device_add+0x9f/0x500
 [<c042326e>] device_initialize+0xce/0xf0
 [<c0423aeb>] device_create+0x8b/0xc0
 [<c03e6219>] tty_register_device+0x69/0xf0
 [<c038a2a4>] vsnprintf+0x544/0x600
 [<c038e982>] __spin_lock_init+0x32/0x60
 [<c07512d9>] _spin_lock+0x29/0x40
 [<c06e20ea>] rfcomm_dev_ioctl+0x53a/0x690
 [<c06e01be>] rfcomm_sock_ioctl+0x1e/0x50
 [<c06e01c9>] rfcomm_sock_ioctl+0x29/0x50
 [<c0625e16>] sock_ioctl+0xb6/0x1d0
 [<c0625d60>] sock_ioctl+0x0/0x1d0
 [<c0288e8b>] vfs_ioctl+0x2b/0x90
 [<c0288f4c>] do_vfs_ioctl+0x5c/0x2a0
 [<c02891cd>] sys_ioctl+0x3d/0x70
 [<c0203c2a>] syscall_call+0x7/0xb
 =======================
---[ end trace a0614c8bfea95988 ]---
kobject_add_internal failed for rfcomm0 with -EEXIST, don't try to register things with the same name in the same directory.
Pid: 2011, comm: rfcomm Tainted: G        W 2.6.26-rc1 #289
 [<c0385de7>] kobject_add_internal+0x137/0x190
 [<c0386201>] kobject_add+0x31/0x60
 [<c0385c2f>] kobject_get+0xf/0x20
 [<c04235ef>] device_add+0x9f/0x500
 [<c042326e>] device_initialize+0xce/0xf0
 [<c0423aeb>] device_create+0x8b/0xc0
 [<c03e6219>] tty_register_device+0x69/0xf0
 [<c038a2a4>] vsnprintf+0x544/0x600
 [<c038e982>] __spin_lock_init+0x32/0x60
 [<c07512d9>] _spin_lock+0x29/0x40
 [<c06e20ea>] rfcomm_dev_ioctl+0x53a/0x690
 [<c06e01be>] rfcomm_sock_ioctl+0x1e/0x50
 [<c06e01c9>] rfcomm_sock_ioctl+0x29/0x50
 [<c0625e16>] sock_ioctl+0xb6/0x1d0
 [<c0625d60>] sock_ioctl+0x0/0x1d0
 [<c0288e8b>] vfs_ioctl+0x2b/0x90
 [<c0288f4c>] do_vfs_ioctl+0x5c/0x2a0
 [<c02891cd>] sys_ioctl+0x3d/0x70
 [<c0203c2a>] syscall_call+0x7/0xb
 =======================
sysfs: duplicate filename 'rfcomm0' can not be created
------------[ cut here ]------------
WARNING: at /data/l/linux/fs/sysfs/dir.c:425 sysfs_add_one+0x85/0xa0()
Modules linked in:
Pid: 2104, comm: rfcomm Tainted: G        W 2.6.26-rc1 #289
 [<c022a2af>] warn_on_slowpath+0x5f/0x90
 [<c021c9e8>] __wake_up_common+0x48/0x70
 [<c02203e8>] __wake_up+0x38/0x50
 [<c022aa8b>] wake_up_klogd+0x3b/0x40
 [<c038510b>] ida_get_new_above+0x7b/0x180
 [<c02bd400>] sysfs_ilookup_test+0x0/0x10
 [<c0751214>] _spin_unlock+0x14/0x20
 [<c029037f>] ifind+0x8f/0xa0
 [<c022b23b>] printk+0x1b/0x20
 [<c02bd775>] sysfs_add_one+0x85/0xa0
 [<c02bdcc8>] create_dir+0x48/0x90
 [<c02bdd39>] sysfs_create_dir+0x29/0x50
 [<c0751214>] _spin_unlock+0x14/0x20
 [<c0385d66>] kobject_add_internal+0xb6/0x190
 [<c0385eb9>] kobject_set_name_vargs+0x29/0x50
 [<c0386201>] kobject_add+0x31/0x60
 [<c0385c2f>] kobject_get+0xf/0x20
 [<c04235ef>] device_add+0x9f/0x500
 [<c042326e>] device_initialize+0xce/0xf0
 [<c0423aeb>] device_create+0x8b/0xc0
 [<c03e6219>] tty_register_device+0x69/0xf0
 [<c038a2a4>] vsnprintf+0x544/0x600
 [<c038e982>] __spin_lock_init+0x32/0x60
 [<c07512d9>] _spin_lock+0x29/0x40
 [<c06e20ea>] rfcomm_dev_ioctl+0x53a/0x690
 [<c06e01be>] rfcomm_sock_ioctl+0x1e/0x50
 [<c06e01c9>] rfcomm_sock_ioctl+0x29/0x50
 [<c0625e16>] sock_ioctl+0xb6/0x1d0
 [<c0625d60>] sock_ioctl+0x0/0x1d0
 [<c0288e8b>] vfs_ioctl+0x2b/0x90
 [<c0288f4c>] do_vfs_ioctl+0x5c/0x2a0
 [<c02891cd>] sys_ioctl+0x3d/0x70
 [<c0203c2a>] syscall_call+0x7/0xb
 =======================
---[ end trace a0614c8bfea95988 ]---
kobject_add_internal failed for rfcomm0 with -EEXIST, don't try to register things with the same name in the same directory.
Pid: 2104, comm: rfcomm Tainted: G        W 2.6.26-rc1 #289
 [<c0385de7>] kobject_add_internal+0x137/0x190
 [<c0386201>] kobject_add+0x31/0x60
 [<c0385c2f>] kobject_get+0xf/0x20
 [<c04235ef>] device_add+0x9f/0x500
 [<c042326e>] device_initialize+0xce/0xf0
 [<c0423aeb>] device_create+0x8b/0xc0
 [<c03e6219>] tty_register_device+0x69/0xf0
 [<c038a2a4>] vsnprintf+0x544/0x600
 [<c038e982>] __spin_lock_init+0x32/0x60
 [<c07512d9>] _spin_lock+0x29/0x40
 [<c06e20ea>] rfcomm_dev_ioctl+0x53a/0x690
 [<c06e01be>] rfcomm_sock_ioctl+0x1e/0x50
 [<c06e01c9>] rfcomm_sock_ioctl+0x29/0x50
 [<c0625e16>] sock_ioctl+0xb6/0x1d0
 [<c0625d60>] sock_ioctl+0x0/0x1d0
 [<c0288e8b>] vfs_ioctl+0x2b/0x90
 [<c0288f4c>] do_vfs_ioctl+0x5c/0x2a0
 [<c02891cd>] sys_ioctl+0x3d/0x70
 [<c0203c2a>] syscall_call+0x7/0xb
 =======================

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
