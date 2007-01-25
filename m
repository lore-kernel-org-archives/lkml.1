Return-Path: <linux-kernel-owner+w=401wt.eu-S1030487AbXAYXan@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030487AbXAYXan (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 18:30:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030501AbXAYXan
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 18:30:43 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:27604 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030487AbXAYXal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 18:30:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PRZVps3MYnETOsPNrKELprGQ6R6cYLiKMjs/53wDLGwQPWn9w9V6X1XY7QS5OBG6QgqNuxvZy55nnMEcwjHBLdk3VkMc52BO6maHO8XQcCUQCpTui3g0Efb/1um+K0xnBlRLYSqe5SvJj0umT89/0Dh1kcNyKhjHwU82N+f9prc=
Message-ID: <195c7a900701251530m409878a8id301c7cada76f342@mail.gmail.com>
Date: Fri, 26 Jan 2007 00:30:39 +0100
From: "roucaries bastien" <roucaries.bastien@gmail.com>
To: "Larry Finger" <larry.finger@lwfinger.net>
Subject: Re: Bcm43xx oops after suspend to disk
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <45B92536.2080909@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <45B92488.6090908@lwfinger.net> <45B92536.2080909@lwfinger.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Do you have the log stuff that precedes this part? In particular, was there a assertion that failed?
>
It is oops on resume and no asseertion failled this boot. However I
have usually a lot of
bcm43xx: ASSERTION FAILED (radio_attenuation < 10) at:
drivers/net/wireless/bcm43xx/bcm43xx_phy.c:1496:bcm43xx_find_lopair()
Moreover after the first oops I have a second oops (Surelly a
consequence of the first).

-----------------------------------------------------
Jan 25 18:17:06 portablebastien kernel: bcm43xx: PHY connected
Jan 25 18:17:06 portablebastien kernel: bcm43xx: Microcode rev 0x118,
pl 0x17 (2004-05-06  21:34:00)
Jan 25 18:17:06 portablebastien kernel: bcm43xx: Radio turned on
Jan 25 18:17:06 portablebastien kernel: bcm43xx: Chip initialized
Jan 25 18:17:06 portablebastien kernel: bcm43xx: 32-bit DMA initialized
Jan 25 18:17:06 portablebastien kernel: bcm43xx: Keys cleared
Jan 25 18:17:06 portablebastien kernel: bcm43xx: Selected 802.11 core
(phytype 2)
Jan 25 18:17:06 portablebastien kernel: ADDRCONF(NETDEV_UP): eth2:
link is not ready
Jan 25 18:17:08 portablebastien dhcpd: Internet Systems Consortium
DHCP Server V3.0.4
Jan 25 18:17:08 portablebastien dhcpd: Copyright 2004-2006 Internet
Systems Consortium.
Jan 25 18:17:08 portablebastien dhcpd: All rights reserved.
Jan 25 18:17:08 portablebastien dhcpd: For info, please visit
http://www.isc.org/sw/dhcp/
Jan 25 18:17:08 portablebastien dhcpd: Internet Systems Consortium
DHCP Server V3.0.4
Jan 25 18:17:08 portablebastien dhcpd: Copyright 2004-2006 Internet
Systems Consortium.
Jan 25 18:17:08 portablebastien dhcpd: All rights reserved.
Jan 25 18:17:08 portablebastien dhcpd: For info, please visit
http://www.isc.org/sw/dhcp/
Jan 25 18:17:08 portablebastien dhcpd: Wrote 0 deleted host decls to
leases file.
Jan 25 18:17:08 portablebastien dhcpd: Wrote 0 new dynamic host decls
to leases file.
Jan 25 18:17:08 portablebastien dhcpd: Wrote 1 leases to leases file.
Jan 25 18:20:06 portablebastien kernel: NET: Registered protocol family 4
Jan 25 18:20:06 portablebastien kernel: NET: Registered protocol family 5
Jan 25 18:36:53 portablebastien -- MARK --
Jan 25 18:56:53 portablebastien -- MARK --
Jan 25 19:05:41 portablebastien kernel: Disabling non-boot CPUs ...
Jan 25 19:05:41 portablebastien kernel: Cannot set affinity for irq 0
Jan 25 19:05:41 portablebastien kernel: CPU 1 is now offline
Jan 25 19:05:41 portablebastien kernel: SMP alternatives: switching to UP code
Jan 25 19:46:45 portablebastien kernel: CPU1 is down
Jan 25 19:46:45 portablebastien kernel: Stopping tasks ... done.
Jan 25 19:46:45 portablebastien kernel: Shrinking memory...  ^H-^Hdone
(0 pages freed)
Jan 25 19:46:45 portablebastien kernel: Freed 0 kbytes in 0.02 seconds
(0.00 MB/s)
Jan 25 19:46:45 portablebastien kernel: Suspending console(s)
Jan 25 19:46:45 portablebastien kernel: bcm43xx: Suspending...
Jan 25 19:46:45 portablebastien kernel: bcm43xx: Radio turned off
Jan 25 19:46:45 portablebastien kernel: bcm43xx: DMA-32 0x0200 (RX)
max used slots: 1/64
Jan 25 19:46:45 portablebastien kernel: bcm43xx: DMA-32 0x02A0 (TX)
max used slots: 0/512
Jan 25 19:46:45 portablebastien kernel: bcm43xx: DMA-32 0x0280 (TX)
max used slots: 0/512
Jan 25 19:46:45 portablebastien kernel: bcm43xx: DMA-32 0x0260 (TX)
max used slots: 0/512
Jan 25 19:46:45 portablebastien kernel: bcm43xx: DMA-32 0x0240 (TX)
max used slots: 0/512
Jan 25 19:46:45 portablebastien kernel: bcm43xx: DMA-32 0x0220 (TX)
max used slots: 0/512
Jan 25 19:46:45 portablebastien kernel: bcm43xx: DMA-32 0x0200 (TX)
max used slots: 0/512
Jan 25 19:46:45 portablebastien kernel: ACPI: PCI interrupt for device
0000:03:03.0 disabled

Jan 25 19:46:45 portablebastien kernel: bcm43xx: Device suspended.
Jan 25 19:46:45 portablebastien kernel: ACPI: PCI interrupt for device
0000:03:01.2 disabled
Jan 25 19:46:45 portablebastien kernel: ohci1394 does not fully
support suspend and resume yet
Jan 25 19:46:45 portablebastien kernel: ACPI: PCI interrupt for device
0000:00:10.1 disabled
Jan 25 19:46:45 portablebastien kernel: ACPI: PCI interrupt for device
0000:00:0b.1 disabled
Jan 25 19:46:45 portablebastien kernel: ACPI: PCI interrupt for device
0000:00:0b.0 disabled
Jan 25 19:46:45 portablebastien kernel: swsusp: critical section:
Jan 25 19:46:45 portablebastien kernel: swsusp: Need to copy 114482 pages
Jan 25 19:46:45 portablebastien kernel: PCI: Enabling device
0000:00:0b.0 (0000 -> 0002)
Jan 25 19:46:45 portablebastien kernel: ACPI: PCI Interrupt
0000:00:0b.0[A] -> Link [LUB0] -> GSI 23 (level, low) -> IRQ 23
Jan 25 19:46:45 portablebastien kernel: ACPI: PCI Interrupt
0000:00:0b.1[B] -> Link [LUB2] -> GSI 22 (level, low) -> IRQ 22
Jan 25 19:46:45 portablebastien kernel: usb usb2: root hub lost power
or was reset
Jan 25 19:46:45 portablebastien kernel: ehci_hcd 0000:00:0b.1: debug port 1
Jan 25 19:46:45 portablebastien kernel: ACPI: PCI Interrupt
0000:00:10.1[B] -> Link [LAZA] -> GSI 21 (level, low) -> IRQ 21
Jan 25 19:46:45 portablebastien kernel: ohci1394: fw-host0: OHCI-1394
165.165 (PCI): IRQ=[17]  MMIO=[df7ff000-df7ff7ff]  Max Packet=[65536]
IR/IT contexts=[4/4]
Jan 25 19:46:45 portablebastien kernel: ACPI: PCI Interrupt
0000:03:01.2[C] -> Link [LNKD] -> GSI 16 (level, low) -> IRQ 16
Jan 25 19:46:45 portablebastien kernel: bcm43xx: Resuming...
Jan 25 19:46:45 portablebastien kernel: ACPI: PCI Interrupt
0000:03:03.0[A] -> Link [LNKB] -> GSI 19 (level, low) -> IRQ 19
Jan 25 19:46:45 portablebastien kernel: bcm43xx: PHY connected
Jan 25 19:46:45 portablebastien kernel: usb usb1: root hub lost power
or was reset
Jan 25 19:46:45 portablebastien kernel: ata1: EH complete
Jan 25 19:46:45 portablebastien kernel: ata2: EH complete
Jan 25 19:46:45 portablebastien kernel: Restarting tasks ... <6>usb
1-2: USB disconnect, address 4
Jan 25 19:46:45 portablebastien kernel: done.
Jan 25 19:46:45 portablebastien kernel: Enabling non-boot CPUs ...
Jan 25 19:46:46 portablebastien kernel: SMP alternatives: switching to SMP code
Jan 25 19:46:46 portablebastien kernel: Booting processor 1/2 APIC 0x1
Jan 25 19:46:46 portablebastien kernel: Initializing CPU#1
Jan 25 19:46:46 portablebastien kernel: Calibrating delay using timer
specific routine.. 3219.62 BogoMIPS (lpj=6439259)
Jan 25 19:46:46 portablebastien kernel: CPU: L1 I Cache: 64K (64
bytes/line), D cache 64K (64 bytes/line)
Jan 25 19:46:46 portablebastien kernel: CPU: L2 Cache: 512K (64 bytes/line)
Jan 25 19:46:46 portablebastien kernel: CPU 1/1 -> Node 0
Jan 25 19:46:46 portablebastien kernel: CPU: Physical Processor ID: 0
Jan 25 19:46:46 portablebastien kernel: CPU: Processor Core ID: 1
Jan 25 19:46:46 portablebastien kernel: AMD Turion(tm) 64 X2 Mobile
Technology TL-52 stepping 02
Jan 25 19:46:46 portablebastien kernel: CPU 1: Syncing TSC to CPU 0.
Jan 25 19:46:46 portablebastien kernel: CPU 1: synchronized TSC with
CPU 0 (last diff 0 cycles, maxerr 482 cycles)
Jan 25 19:46:46 portablebastien kernel: CPU1 is up
Jan 25 19:46:46 portablebastien kernel: usb 1-7: USB disconnect, address 5
Jan 25 19:46:46 portablebastien kernel: usb 2-4: USB disconnect, address 3
Jan 25 19:46:46 portablebastien kernel: usb 2-5: USB disconnect, address 4
Jan 25 19:46:47 portablebastien kernel: usb 2-5: new high speed USB
device using ehci_hcd and address 6
Jan 25 19:46:47 portablebastien kernel: usb 2-5: configuration #1
chosen from 1 choice
Jan 25 19:46:47 portablebastien kernel: usb 1-7: new full speed USB
device using ohci_hcd and address 6
Jan 25 19:46:48 portablebastien kernel: usb 1-7: configuration #1
chosen from 1 choice
Jan 25 19:47:39 portablebastien kernel: caller is oops_begin+0xb/0x80
----------------
THE PREVIOUS MAIL OOPS
----------------
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
Jan 25 19:47:39 portablebastien kernel: Pid: 4427, comm: rmmod Not
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

Thank you for your time


> Thanks,
>
> Larry
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
