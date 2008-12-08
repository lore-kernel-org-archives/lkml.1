Return-Path: <linux-kernel-owner+w=401wt.eu-S1753488AbYLHVe1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488AbYLHVe1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 16:34:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752309AbYLHVeK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 16:34:10 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38158 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652AbYLHVeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 16:34:07 -0500
Date: Mon, 8 Dec 2008 22:35:43 +0100
From: Pavel Machek <pavel@suse.cz>
To: kernel list <linux-kernel@vger.kernel.org>, Paul.Clements@steeleye.com
Subject: warn-on from nbd in 2.6.28-rc7 from sysfs_add_one()
Message-ID: <20081208213542.GA10134@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


sysfs_add_one() complains about entry already existing.

								Pavel

usb 5-2: uevent
usb 5-2: usb_probe_device
usb 5-2: configuration #1 chosen from 1 choice
usb 5-2: adding 5-2:1.0 (config #1, interface 0)
usb 5-2:1.0: uevent
usbserial_generic 5-2:1.0: usb_probe_interface
usbserial_generic 5-2:1.0: usb_probe_interface - got id
/data/l/linux/drivers/usb/core/inode.c: creating file '003'
usb 5-2: New USB device found, idVendor=0483, idProduct=2016
usb 5-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 5-2: Product: Biometric Coprocessor
usb 5-2: Manufacturer: STMicroelectronics
Failed to execute /tmp/swsusp-init.  Attempting defaults...
hub 2-0:1.0: hub_suspend
usb usb2: bus auto-suspend
usb usb2: suspend_rh
hub 1-0:1.0: hub_suspend
usb usb1: bus auto-suspend
ehci_hcd 0000:00:1d.7: suspend root hub
hub 3-0:1.0: hub_suspend
usb usb3: bus auto-suspend
usb usb3: suspend_rh
hub 4-0:1.0: hub_suspend
usb usb4: bus auto-suspend
usb usb4: suspend_rh
EXT3 FS on sda4, internal journal
Adding 987988k swap on /dev/sda1.  Priority:-1 extents:1 across:987988k
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
pcmcia: Detected deprecated PCMCIA ioctl usage from process: hwclock.
pcmcia: This interface will soon be removed from the kernel; please expect breakage unless you upgrade to new tools.
pcmcia: see http://www.kernel.org/pub/linux/utils/kernel/pcmcia/pcmcia.html for details.
iwl3945 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
iwl3945 0000:03:00.0: restoring config space at offset 0x1 (was 0x100102, writing 0x100106)
iwl3945 0000:03:00.0: firmware: requesting iwlwifi-3945-1.ucode
Registered led device: iwl-phy0:radio
Registered led device: iwl-phy0:assoc
Registered led device: iwl-phy0:RX
Registered led device: iwl-phy0:TX
wlan0: direct probe to AP 00:11:2f:0e:95:a0 try 1
wlan0 direct probe responded
wlan0: authenticate with AP 00:11:2f:0e:95:a0
wlan0: authenticated
wlan0: associate with AP 00:11:2f:0e:95:a0
wlan0: RX AssocResp from 00:11:2f:0e:95:a0 (capab=0x401 status=0 aid=1)
wlan0: associated
coda_read_super: Bad mount data
coda_read_super: device index: 0
coda_read_super: rootfid is (01234567.ffffffff.08051a38.00000000)
coda: Unexpected interruption.
Failure of coda_cnode_make for root: error -4
wlan0: deauthenticated
wlan0: direct probe to AP 00:11:2f:0e:95:a0 try 1
wlan0 direct probe responded
wlan0: authenticate with AP 00:11:2f:0e:95:a0
wlan0: authenticated
wlan0: associate with AP 00:11:2f:0e:95:a0
wlan0: RX ReassocResp from 00:11:2f:0e:95:a0 (capab=0x401 status=0 aid=1)
wlan0: associated
wlan0: deauthenticated
wlan0: direct probe to AP 00:11:2f:0e:95:a0 try 1
wlan0 direct probe responded
wlan0: authenticate with AP 00:11:2f:0e:95:a0
wlan0: authenticated
wlan0: associate with AP 00:11:2f:0e:95:a0
wlan0: RX ReassocResp from 00:11:2f:0e:95:a0 (capab=0x401 status=0 aid=1)
wlan0: associated
wlan0: deauthenticated
wlan0: direct probe to AP 00:11:2f:0e:95:a0 try 1
wlan0 direct probe responded
wlan0: authenticate with AP 00:11:2f:0e:95:a0
wlan0: authenticated
wlan0: associate with AP 00:11:2f:0e:95:a0
wlan0: RX ReassocResp from 00:11:2f:0e:95:a0 (capab=0x401 status=0 aid=1)
wlan0: associated
wlan0: deauthenticated
wlan0: direct probe to AP 00:11:2f:0e:95:a0 try 1
wlan0 direct probe responded
wlan0: authenticate with AP 00:11:2f:0e:95:a0
wlan0: authenticated
wlan0: associate with AP 00:11:2f:0e:95:a0
wlan0: RX ReassocResp from 00:11:2f:0e:95:a0 (capab=0x401 status=0 aid=1)
wlan0: associated
CE: hpet increasing min_delta_ns to 15000 nsec
CE: hpet increasing min_delta_ns to 22500 nsec
Clocksource tsc unstable (delta = -63212306 ns)
wlan0: No ProbeResp from current AP 00:11:2f:0e:95:a0 - assume out of range
wlan0: direct probe to AP 00:11:2f:0e:95:a0 try 1
wlan0 direct probe responded
wlan0: authenticate with AP 00:11:2f:0e:95:a0
wlan0: authenticated
wlan0: associate with AP 00:11:2f:0e:95:a0
wlan0: RX ReassocResp from 00:11:2f:0e:95:a0 (capab=0x401 status=0 aid=1)
wlan0: associated
nbd: registered device at major 43
------------[ cut here ]------------
WARNING: at /data/l/linux/fs/sysfs/dir.c:462 sysfs_add_one+0x4a/0x50()
sysfs: duplicate filename 'pid' can not be created
Modules linked in: nbd
Pid: 8280, comm: nbd-client Not tainted 2.6.28-rc7 #422
Call Trace:
 [<c022e8d6>] warn_slowpath+0x76/0x90
 [<c024e3d1>] __lock_acquire+0x181/0x930
 [<c024e3d1>] __lock_acquire+0x181/0x930
 [<c0298b9f>] ifind+0x8f/0xa0
 [<c07bcff4>] _spin_unlock+0x14/0x20
 [<c02ca151>] sysfs_find_dirent+0x21/0x30
 [<c02ca17c>] __sysfs_add_one+0x1c/0x80
 [<c02ca22a>] sysfs_add_one+0x4a/0x50
 [<c02c9a50>] sysfs_add_file_mode+0x50/0x90
 [<c02c9aa0>] sysfs_add_file+0x10/0x20
 [<f8794e43>] nbd_ioctl+0x423/0x8e0 [nbd]
 [<f87947d0>] nbd_thread+0x0/0x250 [nbd]
 [<c021db8a>] __change_page_attr_set_clr+0xba/0x520
 [<c03c90ea>] delay_tsc+0x2a/0x50
 [<c03c9086>] __delay+0x6/0x10
 [<c03cd72a>] _raw_spin_lock+0xfa/0x190
 [<c021db8a>] __change_page_attr_set_clr+0xba/0x520
 [<c03ba15a>] __blkdev_driver_ioctl+0x7a/0x90
 [<c03ba229>] blkdev_ioctl+0x99/0x9e0
 [<c024e3d1>] __lock_acquire+0x181/0x930
 [<c0267dd6>] get_page_from_freelist+0x266/0x430
 [<c0262a71>] find_get_page+0x91/0xd0
 [<c024e3d1>] __lock_acquire+0x181/0x930
 [<c02629e0>] find_get_page+0x0/0xd0
 [<c0262cbb>] find_lock_page+0x1b/0x60
 [<c02713a0>] __do_fault+0x1a0/0x3c0
 [<c02713a9>] __do_fault+0x1a9/0x3c0
 [<c02ab6a7>] block_ioctl+0x37/0x50
 [<c02ab670>] block_ioctl+0x0/0x50
 [<c0293bbb>] vfs_ioctl+0x2b/0x90
 [<c0293c7c>] do_vfs_ioctl+0x5c/0x490
 [<c02457f6>] down_read_trylock+0x56/0x60
 [<c021cbd0>] do_page_fault+0x0/0x6a0
 [<c021ce4c>] do_page_fault+0x27c/0x6a0
 [<c02940ed>] sys_ioctl+0x3d/0x70
 [<c0203d52>] syscall_call+0x7/0xb
---[ end trace 0cbc102fb0629d93 ]---
nbd: sysfs_create_file failed!<6>nbd-server[8255]: segfault at 7 ip b7e61e97 sp bfc265d0 error 4 in libglib-2.0.so.0.1600.5[b7e37000+b4000]
nbd0: Receive control failed (result -32)
nbd0: queue cleared
nbd-server[8297]: segfault at 7 ip b7f18e97 sp bfbde2c0 error 4 in libglib-2.0.so.0.1600.5[b7eee000+b4000]
nbd0: Receive control failed (result -32)
nbd0: shutting down socket
nbd0: queue cleared
nbd-server[8338]: segfault at 7 ip b7f26e97 sp bfeebdd0 error 4 in libglib-2.0.so.0.1600.5[b7efc000+b4000]
nbd0: Receive control failed (result -32)
nbd0: shutting down socket
nbd0: queue cleared

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
