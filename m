Return-Path: <linux-kernel-owner+w=401wt.eu-S1754668Ab0AIOXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668Ab0AIOXu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 09:23:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753160Ab0AIOXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 09:23:49 -0500
Received: from pindarots.xs4all.nl ([80.101.128.228]:54801 "EHLO
	pindarots.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab0AIOXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 09:23:48 -0500
X-Greylist: delayed 480 seconds by postgrey-1.27 at vger.kernel.org; Sat, 09 Jan 2010 09:23:47 EST
Message-ID: <4B488F90.2010101@xs4all.nl>
Date: Sat, 09 Jan 2010 15:15:44 +0100
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Lightning/1.0pre Thunderbird/3.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: WARNING: at net/sched/sch_generic.c:261 dev_watchdog+0x21a/0x230()
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello,

I just powered up my H2210 Ipaq PDA and the kernel on the workstation it
was attached to mentioned:

IPv6 addrconf: prefix with wrong length 48
IPv6 addrconf: prefix with wrong length 48
IPv6 addrconf: prefix with wrong length 48
IPv6 addrconf: prefix with wrong length 48
IPv6 addrconf: prefix with wrong length 48
usb 3-1: new full speed USB device using ohci_hcd and address 2
usb 3-1: New USB device found, idVendor=049f, idProduct=505a
usb 3-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 3-1: Product: Ethernet Gadget
usb 3-1: Manufacturer: Linux 2.6.15-hh1/pxa2xx_udc
usb 3-1: configuration #1 chosen from 1 choice
usb0: register 'cdc_subset' at usb-0000:00:12.1-1, Linux Device,
9e:b5:6f:2c:07:4c
usb 3-1: USB disconnect, address 2
usb0: unregister 'cdc_subset' usb-0000:00:12.1-1, Linux Device
usb 3-1: new full speed USB device using ohci_hcd and address 3
usb 3-1: New USB device found, idVendor=0525, idProduct=a4a2
usb 3-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 3-1: Product: RNDIS/Ethernet Gadget
usb 3-1: Manufacturer: Linux 2.6.21-hh20/pxa2xx_udc
usb 3-1: configuration #1 chosen from 2 choices
usb0: register 'cdc_subset' at usb-0000:00:12.1-1, Linux Device,
9e:b5:6f:2c:07:4c
usb0: no IPv6 routers present
ata7: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0xe frozen
ata7: irq_stat 0x00a00080, device exchanged
ata7: hard resetting link
usb 2-6: new high speed USB device using ehci_hcd and address 5
usb 2-6: New USB device found, idVendor=05e3, idProduct=0608
usb 2-6: New USB device strings: Mfr=0, Product=1, SerialNumber=0
usb 2-6: Product: USB2.0 Hub
usb 2-6: configuration #1 chosen from 1 choice
hub 2-6:1.0: USB hub found
hub 2-6:1.0: 4 ports detected
usb 2-6.4: new high speed USB device using ehci_hcd and address 6
usb 2-6.4: New USB device found, idVendor=05e3, idProduct=0723
usb 2-6.4: New USB device strings: Mfr=3, Product=4, SerialNumber=2
usb 2-6.4: Product: USB Storage
usb 2-6.4: Manufacturer: Generic
usb 2-6.4: SerialNumber: 000000009451
usb 2-6.4: configuration #1 chosen from 1 choice
Initializing USB Mass Storage driver...
scsi9 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 6
usb-storage: waiting for device to settle before scanning
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
------------[ cut here ]------------
WARNING: at net/sched/sch_generic.c:261 dev_watchdog+0x21a/0x230()
Hardware name:
NETDEV WATCHDOG: usb0 (cdc_subset): transmit queue 0 timed out
Modules linked in: usb_storage hid_sunplus usbhid radeon ttm
drm_kms_helper drm fb i2c_algo_bit cfbcopyarea cfbimgblt cfbfillrect
rfcomm sco bridge stp llc bnep l2cap nfsd nfs_acl auth_rpcgss exportfs
it87 hwmon_vid lockd sunrpc ipt_REJECT iptable_filter ipt_MASQUERADE
iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 ip_tables
nf_conntrack_netbios_ns ip6t_REJECT xt_tcpudp nf_conntrack_ipv6 xt_state
nf_conntrack ip6table_filter ip6_tables x_tables ipv6 powernow_k8
binfmt_misc pwc videodev v4l1_compat v4l2_compat_ioctl32 btusb bluetooth
usblp dm_mirror dm_region_hash dm_log snd_hda_codec_atihdmi
snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_seq snd_seq_device
snd_pcm snd_timer snd ohci1394 sr_mod ppdev ehci_hcd sg ieee1394
parport_pc snd_page_alloc parport ohci_hcd evdev cdrom i2c_piix4 k10temp
button pata_atiixp sata_sil24 floppy [last unloaded: scsi_wait_scan]
Pid: 0, comm: swapper Not tainted 2.6.32.2 #4
Call Trace:
 <IRQ>  [<ffffffff81042d43>] ? warn_slowpath_common+0x73/0xb0
 [<ffffffff8103c92e>] ? walk_tg_tree+0x8e/0xc0
 [<ffffffff81042de0>] ? warn_slowpath_fmt+0x40/0x50
 [<ffffffff811a9761>] ? strlcpy+0x41/0x50
 [<ffffffff812f25ca>] ? dev_watchdog+0x21a/0x230
 [<ffffffff810340ac>] ? __wake_up+0x3c/0x60
 [<ffffffff8135d912>] ? _spin_unlock_irqrestore+0x12/0x40
 [<ffffffff812f23b0>] ? dev_watchdog+0x0/0x230
 [<ffffffff8104d052>] ? run_timer_softirq+0x162/0x260
 [<ffffffff810615fb>] ? ktime_get+0x5b/0xe0
 [<ffffffff810487e4>] ? __do_softirq+0xb4/0x140
 [<ffffffff8100c3ec>] ? call_softirq+0x1c/0x30
 [<ffffffff8100e2ed>] ? do_softirq+0x4d/0x80
 [<ffffffff810484c5>] ? irq_exit+0x85/0x90
 [<ffffffff8101eccb>] ? smp_apic_timer_interrupt+0x6b/0xa0
 [<ffffffff8100bde3>] ? apic_timer_interrupt+0x13/0x20
 <EOI>  [<ffffffff81012e10>] ? default_idle+0x20/0x40
 [<ffffffff8101316b>] ? c1e_idle+0x7b/0x100
 [<ffffffff8100a516>] ? cpu_idle+0x56/0xc0
---[ end trace c9c0cf5c72497ec6 ]---


This is on Fedora 12 x86_64 with a kernel.org 2.6.32.2...

Udo
