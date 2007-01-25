Return-Path: <linux-kernel-owner+w=401wt.eu-S1030485AbXAYTSZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030485AbXAYTSZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 14:18:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030508AbXAYTSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 14:18:24 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:60571 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030485AbXAYTSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 14:18:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=MEQqDpjJ+d7bdRBYl6Hid4EIKtN75JsjigNlz1tvhnfnEMnPIyJydpw7GPaOcMkcXIHfXDGCAvbyD/WsdSFMNrEmULdP75sYWoa/SO6r3CebFWPQMUKCyJFtOV5RVvDvk2vN0Qz/bXfsgW195zw8FSlWt115qY4lBbu72EGT23E=
Message-ID: <195c7a900701251118n7bdfe7bevc9663e055348495@mail.gmail.com>
Date: Thu, 25 Jan 2007 20:18:21 +0100
From: "roucaries bastien" <roucaries.bastien@gmail.com>
To: bcm43xx-dev@lists.berlios.de
Subject: Bcm43xx oops after suspend to disk
Cc: pavel@suze.cz, linux-kernel@vger.kernel.org, rjw@sisk.pl
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

My bcm43xx oops after suspend to disk on a 2.6.20rc5 kernel (preempt+smp).

---------------
Jan 25 19:47:39 portablebastien kernel: caller is oops_begin+0xb/0x80
Jan 25 19:47:39 portablebastien kernel:
Jan 25 19:47:39 portablebastien kernel: Call Trace:
Jan 25 19:47:39 portablebastien kernel:  [<ffffffff8033f1eb>]
debug_smp_processor_id+0xab/0xc0
Jan 25 19:47:39 portablebastien kernel:  [<ffffffff8026d52b>]
oops_begin+0xb/0x80
Jan 25 19:47:39 portablebastien kernel:  [<ffffffff8020aee4>]
do_page_fault+0x6e4/0x890
Jan 25 19:47:39 portablebastien kernel:  [<ffffffff8022f383>]
__wake_up+0x43/0x70
Jan 25 19:47:39 portablebastien kernel:  [<ffffffff80269416>]
_spin_unlock_irqrestore+0x16/0x40
Jan 25 19:47:39 portablebastien kernel:  [<ffffffff80290f76>]
vprintk+0x2f6/0x360
Jan 25 19:47:39 portablebastien kernel:  [<ffffffff8026974d>]
error_exit+0x0/0x84
Jan 25 19:47:39 portablebastien kernel:  [<ffffffff8027ce30>]
physflat_send_IPI_mask+0x0/0x80
Jan 25 19:47:39 portablebastien kernel:  [<ffffffff803adb1c>]
hwrng_unregister+0x1c/0xf0
Jan 25 19:47:39 portablebastien kernel:  [<ffffffff803adb10>]
hwrng_unregister+0x10/0xf0
Jan 25 19:47:39 portablebastien kernel:  [<ffffffff8824f991>]
:bcm43xx:bcm43xx_free_board+0x21/0x70
Jan 25 19:47:39 portablebastien kernel:  [<ffffffff88252739>]
:bcm43xx:bcm43xx_net_stop+0x49/0x60
Jan 25 19:47:39 portablebastien kernel:  [<ffffffff803ef268>]
dev_close+0x58/0x80
Jan 25 19:47:39 portablebastien kernel:  [<ffffffff803ef319>]
unregister_netdevice+0x89/0x250
Jan 25 19:47:39 portablebastien kernel:  [<ffffffff803ef4f1>]
unregister_netdev+0x11/0x20
Jan 25 19:47:39 portablebastien kernel:  [<ffffffff882529dc>]
:bcm43xx:bcm43xx_remove_one+0x2c/0x50
Jan 25 19:47:39 portablebastien kernel:  [<ffffffff80348b0c>]
pci_device_remove+0x2c/0x60
Jan 25 19:47:39 portablebastien kernel:  [<ffffffff803bb4b1>]
__device_release_driver+0x91/0xc0
Jan 25 19:47:39 portablebastien kernel:  [<ffffffff803bbaa8>]
driver_detach+0xa8/0xf0
Jan 25 19:47:39 portablebastien kernel:  [<ffffffff803baf91>]
bus_remove_driver+0x81/0xb0
Jan 25 19:47:39 portablebastien kernel:  [<ffffffff803bbb2d>]
driver_unregister+0xd/0x20
Jan 25 19:47:39 portablebastien kernel:  [<ffffffff80348dfe>]
pci_unregister_driver+0x1e/0x90
Jan 25 19:47:39 portablebastien kernel:  [<ffffffff88269540>]
:bcm43xx:bcm43xx_exit+0x10/0x19
Jan 25 19:47:39 portablebastien kernel:  [<ffffffff802aabda>]
sys_delete_module+0x1da/0x230
Jan 25 19:47:39 portablebastien kernel:  [<ffffffff8026211e>]
system_call+0x7e/0x83
Jan 25 19:47:39 portablebastien kernel:
Jan 25 19:47:39 portablebastien kernel: PGD 67306067 PUD 67309067 PMD 0
Jan 25 19:47:39 portablebastien kernel: CPU 0
Jan 25 19:47:39 portablebastien kernel: Modules linked in: appletalk
ipx p8023 ppdev parport_pc lp parport button ac battery ipv6 tun ext3
jbd mbcache dm_snapshot dm
_mirror dm_mod eeprom lm90 kvm_amd kvm fuse sbp2 loop joydev pcmcia
snd_hda_intel snd_hda_codec snd_pcm_oss snd_mixer_oss snd_pcm
snd_timer snd yenta_socket bcm43xx
rsrc_nonstatic sdhci hci_usb pcmcia_core k8temp pcspkr soundcore
i2c_nforce2 firmware_class mmc_core bluetooth psmouse serio_raw
snd_page_alloc ieee80211softmac ieee
80211 ieee80211_crypt sg i2c_core sr_mod cdrom tsdev eth1394 evdev
reiserfs sd_mod generic amd74xx ide_core ata_generic usbhid pata_amd
ehci_hcd ohci1394 ieee1394 sa
ta_nv libata scsi_mod r8169 ohci_hcd thermal processor fan
an 25 19:47:39 portablebastien kernel: Pid: 4427, comm: rmmod Not
tainted 2.6.20-rc5toto #4
Jan 25 19:47:39 portablebastien kernel: RIP: 0010:[<ffffffff803adb1c>]
 [<ffffffff803adb1c>] hwrng_unregister+0x1c/0xf0
Jan 25 19:47:39 portablebastien kernel: RSP: 0018:ffff810067399d88
EFLAGS: 00010246
Jan 25 19:47:39 portablebastien kernel: RAX: 0000000000200200 RBX:
ffff81007d985898 RCX: ffff81007d9858c8
Jan 25 19:47:39 portablebastien kernel: RDX: 0000000000100100 RSI:
0000000000000013 RDI: ffffffff8052f2c0
Jan 25 19:47:39 portablebastien kernel: RBP: 0000000000000000 R08:
ffffffff805c9800 R09: 0000000000000080
Jan 25 19:47:39 portablebastien kernel: R10: 0000000000000001 R11:
ffffffff8027ce30 R12: ffff81007d985218
Jan 25 19:47:39 portablebastien kernel: R13: ffffffff88277ba0 R14:
ffffffff88277ba8 R15: 0000000000000880
Jan 25 19:47:39 portablebastien kernel: FS:  00002b34bf0eb6d0(0000)
GS:ffffffff8054b000(0000) knlGS:0000000000000000
Jan 25 19:47:39 portablebastien kernel: CS:  0010 DS: 0000 ES: 0000
CR0: 000000008005003b
Jan 25 19:47:39 portablebastien kernel: CR2: 0000000000100108 CR3:
000000006df78000 CR4: 00000000000006e0
Jan 25 19:47:39 portablebastien kernel: Process rmmod (pid: 4427,
threadinfo ffff810067398000, task ffff8100672570c0)
Jan 25 19:47:39 portablebastien kernel: Stack:  ffff81007d9851e0
ffffffff8824f991 ffff81007d9851e0 ffff81007d9851e0
Jan 25 19:47:39 portablebastien kernel:  ffff81007d9851e0
ffffffff88252739 ffff81007d984000 ffffffff803ef268
Jan 25 19:47:39 portablebastien kernel:  ffff81007d984000
ffffffff803ef319 ffff81007d984000 ffff81007d984000
Jan 25 19:47:39 portablebastien kernel: Call Trace:
Jan 25 19:47:39 portablebastien kernel:  [<ffffffff8824f991>]
:bcm43xx:bcm43xx_free_board+0x21/0x70
Jan 25 19:47:39 portablebastien kernel:  [<ffffffff88252739>]
:bcm43xx:bcm43xx_net_stop+0x49/0x60
Jan 25 19:47:39 portablebastien kernel:  [<ffffffff803ef268>]
dev_close+0x58/0x80
Jan 25 19:47:39 portablebastien kernel:  [<ffffffff803ef319>]
unregister_netdevice+0x89/0x250
Jan 25 19:47:39 portablebastien kernel:  [<ffffffff803ef4f1>]
unregister_netdev+0x11/0x20
Jan 25 19:47:39 portablebastien kernel:  [<ffffffff882529dc>]
:bcm43xx:bcm43xx_remove_one+0x2c/0x50
Jan 25 19:47:39 portablebastien kernel:  [<ffffffff80348b0c>]
pci_device_remove+0x2c/0x60
Jan 25 19:47:39 portablebastien kernel:  [<ffffffff803bb4b1>]
__device_release_driver+0x91/0xc0
Jan 25 19:47:39 portablebastien kernel:  [<ffffffff803bbaa8>]
driver_detach+0xa8/0xf0
Jan 25 19:47:39 portablebastien kernel:  [<ffffffff803baf91>]
bus_remove_driver+0x81/0xb0
Jan 25 19:47:39 portablebastien kernel:  [<ffffffff803bbb2d>]
driver_unregister+0xd/0x20
Jan 25 19:47:39 portablebastien kernel:  [<ffffffff80348dfe>]
pci_unregister_driver+0x1e/0x90
Jan 25 19:47:39 portablebastien kernel:  [<ffffffff88269540>]
:bcm43xx:bcm43xx_exit+0x10/0x19
Jan 25 19:47:39 portablebastien kernel:  [<ffffffff802aabda>]
sys_delete_module+0x1da/0x230
Jan 25 19:47:39 portablebastien kernel:  [<ffffffff8026211e>]
system_call+0x7e/0x83
Jan 25 19:47:39 portablebastien kernel:
Jan 25 19:47:39 portablebastien kernel:
Jan 25 19:47:39 portablebastien kernel: Code: 48 89 42 08 48 89 10 48
c7 41 08 00 02 20 00 48 c7 43 30 00
Jan 25 19:47:39 portablebastien kernel:  RSP <ffff810067399d88>
----------------------------------

Thank you very much.

Regards bastien

PS:
Btw it seems this bug was signaled on november 11
(https://lists.berlios.de/pipermail/bcm43xx-dev/2006-November/003074.html)
but not answered.
