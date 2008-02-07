Return-Path: <linux-kernel-owner+w=401wt.eu-S1762374AbYBGWUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762374AbYBGWUf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 17:20:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758609AbYBGWU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 17:20:26 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:35453 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754358AbYBGWUY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 17:20:24 -0500
Date: Thu, 7 Feb 2008 23:04:11 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Chatre, Reinette" <reinette.chatre@intel.com>
Cc: ipw3945-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org,
       "Zhu, Yi" <yi.zhu@intel.com>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: iwl3945: not only it periodically dies, it also BUG()s, and oopses
Message-ID: <20080207220411.GA11259@elf.ucw.cz>
References: <20080205214441.GA1518@elf.ucw.cz> <D936D925018D154694D8A362EEB0892003982BB1@orsmsx416.amr.corp.intel.com> <20080206143218.GA16188@elf.ucw.cz> <D936D925018D154694D8A362EEB0892003982E4C@orsmsx416.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D936D925018D154694D8A362EEB0892003982E4C@orsmsx416.amr.corp.intel.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Could you please create a new bug in our bug tracking system
> (www.bughost.org) to enable us to track this problem? Please include the
> relevant information from the thread as well as the information you
> doscovered recently.

I'm connected over that iwl, so filing web form is not exactly
easy. Another day, another problem, today it oopsed:

I guess I should not have tried to fix iwl3945 by rmmoding, oh
well. Kernel is reasonably recent 2.6.25-rc0.
								Pavel

iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for Linux, 1.2.23ks
iwl3945: Copyright(c) 2003-2007 Intel Corporation
PCI: Setting latency timer of device 0000:03:00.0 to 64
iwl3945: Detected Intel PRO/Wireless 3945ABG Network Connection
iwl3945: Tunable channels: 11 802.11bg, 13 802.11a channels
PM: Adding info for No Bus:phy0
PM: Adding info for No Bus:wmaster0
phy0: Selected rate control algorithm 'iwl-3945-rs'
PM: Adding info for No Bus:wlan0
ACPI: PCI interrupt for device 0000:03:00.0 disabled
PM: Writing back config space on device 0000:03:00.0 at offset 1 (was 100102, writing 100106)
PM: Adding info for No Bus:firmware-0000:03:00
PM: Removing info for No Bus:firmware-0000:03:00
wlan0: Initial auth_alg=0
wlan0: authenticate with AP 00:11:2f:0e:95:a0
wlan0: RX authentication from 00:11:2f:0e:95:a0 (alg=0 transaction=2 status=0)
wlan0: authenticated
wlan0: associate with AP 00:11:2f:0e:95:a0
wlan0: RX AssocResp from 00:11:2f:0e:95:a0 (capab=0x401 status=0 aid=1)
wlan0: associated
Clocksource tsc unstable (delta = -65126761 ns)
usb 4-1: new full speed USB device using uhci_hcd and address 2
PM: Adding info for usb:4-1
PM: Adding info for No Bus:usbdev4.2_ep00
usb 4-1: configuration #1 chosen from 2 choices
PM: Adding info for usb:4-1:1.0
PM: Adding info for No Bus:usb0
usb0: register 'cdc_ether' at usb-0000:00:1d.2-1, CDC Ethernet Device, 5a:fb:9e:20:17:56
PM: Adding info for No Bus:usbdev4.2_ep83
PM: Adding info for usb:4-1:1.1
PM: Adding info for No Bus:usbdev4.2_ep81
PM: Adding info for No Bus:usbdev4.2_ep02
PM: Adding info for No Bus:usbdev4.2
usb 4-1: New USB device found, idVendor=1457, idProduct=5122
usb 4-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 4-1: Product: RNDIS/Ethernet Gadget
usb 4-1: Manufacturer: Linux 2.6.22.5-moko11/s3c2410_udc
acpiphp_glue: cannot get bridge info
usb 4-1: USB disconnect, address 2
PM: Removing info for No Bus:usbdev4.2_ep83
PM: Removing info for usb:4-1:1.0
usb0: unregister 'cdc_ether' usb-0000:00:1d.2-1, CDC Ethernet Device
PM: Removing info for No Bus:usb0
PM: Removing info for No Bus:usbdev4.2_ep81
PM: Removing info for No Bus:usbdev4.2_ep02
PM: Removing info for usb:4-1:1.1
PM: Removing info for usb:4-1
PM: Removing info for No Bus:usbdev4.2
PM: Removing info for No Bus:usbdev4.2_ep00
acpiphp_glue: cannot get bridge info
iwl3945: Microcode SW error detected.  Restarting 0x82000008.
iwl3945: TODO:  Implement Tx ABORT REQUIRED!!!
iwl3945: Can't stop Rx DMA.
wlan0: RX deauthentication from 00:11:2f:0e:95:a0 (reason=4)
wlan0: deauthenticated
wlan0: authenticate with AP 00:11:2f:0e:95:a0
wlan0: RX authentication from 00:11:2f:0e:95:a0 (alg=0 transaction=2 status=0)
wlan0: authenticated
wlan0: associate with AP 00:11:2f:0e:95:a0
wlan0: RX ReassocResp from 00:11:2f:0e:95:a0 (capab=0x401 status=0 aid=1)
wlan0: associated
iwl3945: Microcode SW error detected.  Restarting 0x82000008.
iwl3945: Can't stop Rx DMA.
wlan0: RX deauthentication from 00:11:2f:0e:95:a0 (reason=4)
wlan0: deauthenticated
wlan0: authenticate with AP 00:11:2f:0e:95:a0
wlan0: RX authentication from 00:11:2f:0e:95:a0 (alg=0 transaction=2 status=0)
wlan0: authenticated
wlan0: associate with AP 00:11:2f:0e:95:a0
wlan0: RX ReassocResp from 00:11:2f:0e:95:a0 (capab=0x401 status=0 aid=1)
wlan0: associated
ACPI: PCI interrupt for device 0000:03:00.0 disabled
PM: Removing info for No Bus:wlan0
PM: Removing info for No Bus:wmaster0
PM: Removing info for No Bus:phy0
iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for Linux, 1.2.23ks
iwl3945: Copyright(c) 2003-2007 Intel Corporation
PCI: Setting latency timer of device 0000:03:00.0 to 64
iwl3945: Detected Intel PRO/Wireless 3945ABG Network Connection
BUG: unable to handle kernel NULL pointer dereference at 00000109
IP: [<c0208063>] dma_alloc_coherent+0x43/0x100
*pde = 00000000 
Oops: 0000 [#1] SMP 
Modules linked in: iwl3945(+) [last unloaded: iwl3945]

Pid: 11189, comm: insmod Not tainted (2.6.24 #109)
EIP: 0060:[<c0208063>] EFLAGS: 00010202 CPU: 0
EIP is at dma_alloc_coherent+0x43/0x100
EAX: 00000000 EBX: 00000000 ECX: f338c70c EDX: 0000002c
ESI: 0000002c EDI: f338c710 EBP: 00000101 ESP: d9debd64
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process insmod (pid: 11189, ti=d9dea000 task=d9d25980 task.ti=d9dea000)
Stack: 00000000 f338c70c f7d5fb24 f3388e60 f3388e60 f338c710 f7d5fad0 f8c4b71b 
       00000020 00000000 00000000 f8c482df f8c501f4 f8c4ee4e f78f9630 c02b13f4 
       c02b10e1 f3351a88 f7d45530 c02b1134 c02b11fd f3351a88 f3351b18 00000000 
Call Trace:
 [<f8c4b71b>] iwl3945_hw_set_hw_setting+0x3b/0xc0 [iwl3945]
 [<f8c482df>] iwl3945_pci_probe+0x24f/0xcb0 [iwl3945]
 [<c02b13f4>] sysfs_addrm_finish+0x34/0x1c0
 [<c02b10e1>] sysfs_find_dirent+0x21/0x30
 [<c02b1134>] sysfs_add_one+0x44/0xa0
 [<c02b11fd>] sysfs_addrm_start+0x6d/0xb0
 [<c02b1f4b>] sysfs_create_link+0x8b/0xf0
 [<c03856c0>] pci_match_device+0x10/0xa0
 [<c0385846>] pci_device_probe+0x56/0x80
 [<c042fa08>] driver_probe_device+0x88/0x170
 [<c0719033>] klist_next+0x53/0xa0
 [<c042fc3a>] __driver_attach+0x7a/0x80
 [<c042edba>] bus_for_each_dev+0x3a/0x60
 [<c03857f0>] pci_device_probe+0x0/0x80
 [<c042f886>] driver_attach+0x16/0x20
 [<c042fbc0>] __driver_attach+0x0/0x80
 [<c042f63d>] bus_add_driver+0xbd/0x220
 [<c0270cc1>] cache_free_debugcheck+0xd1/0x220
 [<c0385790>] pci_device_remove+0x0/0x40
 [<c03857f0>] pci_device_probe+0x0/0x80
 [<c042fdcb>] driver_register+0x3b/0xf0
 [<c0248f21>] sys_init_module+0x1521/0x1a60
 [<c0385a5d>] __pci_register_driver+0x3d/0x80
 [<f8b9e030>] iwl3945_init+0x30/0x49 [iwl3945]
 [<c0247b3e>] sys_init_module+0x13e/0x1a60
 [<c02750a5>] do_sync_read+0xd5/0x120
 [<c07042d0>] ieee80211_rx_irqsafe+0x0/0x80
 [<c0273607>] filp_close+0x47/0x80
 [<c0203e8e>] syscall_call+0x7/0xb
 =======================
Code: 14 89 44 24 08 89 4c 24 04 74 06 8b a8 00 01 00 00 8d 46 ff bb ff ff ff ff c1 e8 0b 89 04 24 83 c3 01 d1 2c 24 75 f8 85 ed 74 5d <8b> 55 08 89 d9 8b 45 10 e8 70 0c 17 00 85 c0 78 44 89 c2 8b 45 
EIP: [<c0208063>] dma_alloc_coherent+0x43/0x100 SS:ESP 0068:d9debd64
---[ end trace 96f01332a9244198 ]---


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
