Return-Path: <linux-kernel-owner+w=401wt.eu-S1757637AbYDSNsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757637AbYDSNsV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 09:48:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755266AbYDSNsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 09:48:11 -0400
Received: from hades.rz.tu-clausthal.de ([139.174.2.20]:58647 "EHLO
	hades.rz.tu-clausthal.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755125AbYDSNsI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 09:48:08 -0400
From: Volker Armin Hemmann <volker.armin.hemmann@tu-clausthal.de>
To: "Peer Chen" <pchen@nvidia.com>
Subject: Re: 2.6.24.X: SATA/AHCI related boot delay. - not with 2.6.24.3
Date: Sat, 19 Apr 2008 15:48:03 +0200
User-Agent: KMail/1.9.9
Cc: "Jeff Garzik" <jeff@garzik.org>, "Tejun Heo" <htejun@gmail.com>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       "Kuan Luo" <kluo@nvidia.com>
References: <200803091922.33083.volker.armin.hemmann@tu-clausthal.de> <200804151820.03530.volker.armin.hemmann@tu-clausthal.de> <15F501D1A78BD343BE8F4D8DB854566B271FF262@hkemmail01.nvidia.com>
In-Reply-To: <15F501D1A78BD343BE8F4D8DB854566B271FF262@hkemmail01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200804191548.04013.volker.armin.hemmann@tu-clausthal.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H,

with 2.6.25+reiser4:

[    0.367181] ------------[ cut here ]------------
[    0.367181] WARNING: at drivers/ata/ahci.c:645 ahci_init_one+0x190/0xa3a()
[    0.367181] Modules linked in:
[    0.367181] Pid: 1, comm: swapper Not tainted 2.6.25 #1
[    0.367181]
[    0.367181] Call Trace:
[    0.367181]  [<ffffffff8022c451>] warn_on_slowpath+0x51/0x63
[    0.367181]  [<ffffffff80220061>] __ioremap+0x148/0x197
[    0.367185]  [<ffffffff803cf680>] pci_conf1_read+0xb2/0xbd
[    0.367225]  [<ffffffff8032aa0e>] pcim_iomap_release+0x0/0x2c
[    0.367264]  [<ffffffff8032aa0e>] pcim_iomap_release+0x0/0x2c
[    0.367304]  [<ffffffff803845e9>] devres_find+0x4b/0x65
[    0.367343]  [<ffffffff803ab959>] ahci_init_one+0x190/0xa3a
[    0.367382]  [<ffffffff802af71f>] sysfs_addrm_finish+0x1d/0x209
[    0.367422]  [<ffffffff80283f34>] ifind+0x34/0x8d
[    0.367461]  [<ffffffff802af436>] sysfs_find_dirent+0x1b/0x2f
[    0.367501]  [<ffffffff80322e1d>] ida_get_new_above+0xf0/0x180
[    0.367540]  [<ffffffff802af71f>] sysfs_addrm_finish+0x1d/0x209
[    0.367580]  [<ffffffff802b0260>] sysfs_create_link+0xb6/0x102
[    0.367620]  [<ffffffff80335b44>] pci_device_probe+0x4c/0x72
[    0.367659]  [<ffffffff80382088>] driver_probe_device+0xb5/0x132
[    0.367698]  [<ffffffff8038221b>] __driver_attach+0x6f/0xaf
[    0.367737]  [<ffffffff803821ac>] __driver_attach+0x0/0xaf
[    0.367776]  [<ffffffff803821ac>] __driver_attach+0x0/0xaf
[    0.367816]  [<ffffffff8038144a>] bus_for_each_dev+0x44/0x6f
[    0.367856]  [<ffffffff802a9a3b>] proc_match+0x23/0x2d
[    0.367895]  [<ffffffff80381cb6>] bus_add_driver+0xae/0x1f4
[    0.367933]  [<ffffffff8038244a>] driver_register+0x59/0xce
[    0.367973]  [<ffffffff80335d85>] __pci_register_driver+0x4a/0x7d
[    0.368019]  [<ffffffff805346b8>] kernel_init+0x14f/0x2b9
[    0.368059]  [<ffffffff8020bd58>] child_rip+0xa/0x12
[    0.368097]  [<ffffffff80534569>] kernel_init+0x0/0x2b9
[    0.368136]  [<ffffffff8020bd4e>] child_rip+0x0/0x12
[    0.368173]
[    0.368210] ---[ end trace 9a12831ed6194f10 ]---
[    1.373847] ahci 0000:00:0a.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf 
imp
l SATA mode
[    1.373847] ahci 0000:00:0a.0: flags: 64bit sntf led clo pmp pio
[    1.373847] PCI: Setting latency timer of device 0000:00:0a.0 to 64
[    1.373849] scsi0 : ahci
[    1.373859] scsi1 : ahci
[    1.373868] scsi2 : ahci
[    1.373877] scsi3 : ahci
[    1.373884] ata1: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc100 
irq
 23
[    1.373884] ata2: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc180 
irq
 23
[    1.373884] ata3: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc200 
irq
 23
[    1.373884] ata4: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc280 
irq
 23
[    1.806725] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.807223] ata1.00: ATA-7: WDC WD1600JS-00MHB1, 10.02E01, max UDMA/133
[    1.807223] ata1.00: 312581808 sectors, multi 16: LBA48
[    1.807780] ata1.00: configured for UDMA/133
[    2.439665] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.460164] ata2.00: ATA-8: SAMSUNG HD501LJ, CR100-12, max UDMA7
[    2.460164] ata2.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    2.462073] ata2.00: configured for UDMA/133
[    2.779316] ata3: SATA link down (SStatus 0 SControl 300)
[    3.099182] ata4: SATA link down (SStatus 0 SControl 300)
[    3.300538] scsi 0:0:0:0: Direct-Access     ATA      WDC WD1600JS-00M 10.0 
PQ
: 0 ANSI: 5
[    3.300551] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 
MB)
[    3.300551] sd 0:0:0:0: [sda] Write Protect is off
[    3.300551] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.300551] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, 
does
n't support DPO or FUA
[    3.300551] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 
MB)
[    3.300551] sd 0:0:0:0: [sda] Write Protect is off
[    3.300551] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.300551] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, 
does
n't support DPO or FUA
[    3.300551]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
[    3.142035] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.142045] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    3.142050] scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG HD501LJ  CR10 
PQ
: 0 ANSI: 5
[    3.142057] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 
MB)
[    3.142057] sd 1:0:0:0: [sdb] Write Protect is off
[    3.142057] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    3.142057] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, 
does
n't support DPO or FUA
[    3.142057] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 
MB)
[    3.142057] sd 1:0:0:0: [sdb] Write Protect is off
[    3.142057] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    3.142057] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, 
does
n't support DPO or FUA
[    3.142057]  sdb: sdb1 sdb2
[    3.153169] sd 1:0:0:0: [sdb] Attached SCSI disk
[    3.153179] sd 1:0:0:0: Attached scsi generic sg1 type 0

and from mmapper:
0x2f00: 0xf9dfc004
0x2f01: 0x00f9dfc0
0x2f02: 0x0000f9df
0x2f03: 0x000000f9
0x2f04: 0x00000000
0x2f05: 0xfc000000
0x2f06: 0xfffc0000
0x2f07: 0xfffffc00
0x2f08: 0xfffffffc
0x2f09: 0xffffffff
0x2f0a: 0x00ffffff
0x2f0b: 0x0900ffff
0x2f0c: 0x000900ff
0x2f0d: 0x24000900
0x2f0e: 0x50240009
0x2f0f: 0x00502400
0x2f10: 0xfe005024
0x2f11: 0xfdfe0050
0x2f12: 0x00fdfe00
0x2f13: 0x0000fdfe
0x2f14: 0x000000fd
0x2f15: 0xfc000000
0x2f16: 0xfffc0000
0x2f17: 0xfffffc00
0x2f18: 0xfffffffc
0x2f19: 0xffffffff
0x2f1a: 0x00ffffff
0x2f1b: 0x0c00ffff
0x2f1c: 0x000c00ff
0x2f1d: 0x00000c00
0x2f1e: 0x0000000c
0x2f1f: 0x00000000
0x2f20: 0x00000000
0x2f21: 0x00000000
0x2f22: 0x00000000
0x2f23: 0x00000000
0x2f24: 0x00000000
0x2f25: 0x00000000
0x2f26: 0x00000000
0x2f27: 0x00000000
0x2f28: 0x00000000
0x2f29: 0x00000000
0x2f2a: 0x00000000
0x2f2b: 0x00000000
0x2f2c: 0x00000000
0x2f2d: 0x00000000
0x2f2e: 0x00000000
0x2f2f: 0x00000000
0x2f30: 0x00000000
0x2f31: 0x00000000
0x2f32: 0x00000000
0x2f33: 0x00000000
0x2f34: 0x00000000
0x2f35: 0x00000000
0x2f36: 0x00000000
0x2f37: 0x00000000
0x2f38: 0x00000000
0x2f39: 0x00000000
0x2f3a: 0x00000000
0x2f3b: 0x00000000
0x2f3c: 0x00000000
0x2f3d: 0x00000000
0x2f3e: 0x00000000
0x2f3f: 0x00000000
0x2f40: 0x00000000
0x2f41: 0x00000000
0x2f42: 0x00000000
0x2f43: 0x00000000
0x2f44: 0x00000000
0x2f45: 0x00000000
0x2f46: 0x00000000
0x2f47: 0x00000000
0x2f48: 0x00000000
0x2f49: 0x00000000
0x2f4a: 0x00000000
0x2f4b: 0x00000000
0x2f4c: 0x00000000
0x2f4d: 0x00000000
0x2f4e: 0x00000000
0x2f4f: 0x00000000
0x2f50: 0x00000000
0x2f51: 0x00000000
0x2f52: 0x00000000
0x2f53: 0x00000000
0x2f54: 0x00000000
0x2f55: 0x00000000
0x2f56: 0x00000000
0x2f57: 0x00000000
0x2f58: 0x00000000
0x2f59: 0x00000000
0x2f5a: 0x00000000
0x2f5b: 0x00000000
0x2f5c: 0x00000000
0x2f5d: 0x00000000
0x2f5e: 0x00000000
0x2f5f: 0x00000000
0x2f60: 0x00000000
0x2f61: 0x00000000
0x2f62: 0x00000000
0x2f63: 0x00000000
0x2f64: 0x00000000
0x2f65: 0x00000000
0x2f66: 0x00000000
0x2f67: 0x00000000
0x2f68: 0x00000000
0x2f69: 0x00000000
0x2f6a: 0x00000000
0x2f6b: 0x00000000
0x2f6c: 0x00000000
0x2f6d: 0x00000000
0x2f6e: 0x00000000
0x2f6f: 0x00000000
0x2f70: 0x00000000
0x2f71: 0x00000000
0x2f72: 0x00000000
0x2f73: 0x00000000
0x2f74: 0x00000000
0x2f75: 0x00000000
0x2f76: 0x00000000
0x2f77: 0x00000000
0x2f78: 0x00000000
0x2f79: 0x00000000
0x2f7a: 0x00000000
0x2f7b: 0x00000000
0x2f7c: 0x00000000
0x2f7d: 0x41000000
0x2f7e: 0x40410000
0x2f7f: 0x10404100
0x2f80: 0xc6104041
0x2f81: 0x02c61040
0x2f82: 0x0002c610
0x2f83: 0x000002c6
0x2f84: 0x80000002
0x2f85: 0x35800000
0x2f86: 0x48358000
0x2f87: 0xf6483580
0x2f88: 0x38f64835
0x2f89: 0x3138f648
0x2f8a: 0xd03138f6
0x2f8b: 0xf6d03138
0x2f8c: 0x88f6d031
0x2f8d: 0x0488f6d0
0x2f8e: 0xec0488f6
0x2f8f: 0xb6ec0488
0x2f90: 0x56b6ec04
0x2f91: 0x6b56b6ec
0x2f92: 0x736b56b6
0x2f93: 0xd6736b56
0x2f94: 0xc1d6736b
0x2f95: 0x87c1d673
0x2f96: 0xf187c1d6
0x2f97: 0x2bf187c1
0x2f98: 0xfc2bf187
0x2f99: 0xa7fc2bf1
0x2f9a: 0x67a7fc2b
0x2f9b: 0x6f67a7fc
0x2f9c: 0x5f6f67a7
0x2f9d: 0xd25f6f67
0x2f9e: 0xa8d25f6f
0x2f9f: 0x07a8d25f
0x2fa0: 0x8007a8d2
0x2fa1: 0xfc8007a8
0x2fa2: 0xf2fc8007
0x2fa3: 0x62f2fc80
0x2fa4: 0x1062f2fc
0x2fa5: 0xfe1062f2
0x2fa6: 0x7bfe1062
0x2fa7: 0x807bfe10
0x2fa8: 0xed807bfe
0x2fa9: 0xfded807b
0x2faa: 0x97fded80
0x2fab: 0x9697fded
0x2fac: 0x9e9697fd
0x2fad: 0x499e9697
0x2fae: 0xbd499e96
0x2faf: 0xa2bd499e
0x2fb0: 0x9aa2bd49
0x2fb1: 0x589aa2bd
0x2fb2: 0x20589aa2
0x2fb3: 0x3720589a
0x2fb4: 0x1b372058
0x2fb5: 0xa41b3720
0x2fb6: 0x08a41b37
0x2fb7: 0x7e08a41b
0x2fb8: 0x457e08a4
0x2fb9: 0x7e457e08
0x2fba: 0x2e7e457e
0x2fbb: 0x502e7e45
0x2fbc: 0x5e502e7e
0x2fbd: 0x855e502e
0x2fbe: 0x99855e50
0x2fbf: 0x1b99855e
0x2fc0: 0x921b9985
0x2fc1: 0x22921b99
0x2fc2: 0x5a22921b
0x2fc3: 0x005a2292
0x2fc4: 0x3e005a22
0x2fc5: 0x5b3e005a
0x2fc6: 0x045b3e00
0x2fc7: 0xe4045b3e
0x2fc8: 0xf2e4045b
0x2fc9: 0xe4f2e404
0x2fca: 0x3be4f2e4
0x2fcb: 0xb33be4f2
0x2fcc: 0xbbb33be4
0x2fcd: 0x97bbb33b
0x2fce: 0x4997bbb3
0x2fcf: 0x714997bb
0x2fd0: 0x8e714997
0x2fd1: 0x0e8e7149
0x2fd2: 0x3a0e8e71
0x2fd3: 0xcf3a0e8e
0x2fd4: 0x5fcf3a0e
0x2fd5: 0xb75fcf3a
0x2fd6: 0xdbb75fcf
0x2fd7: 0x5ddbb75f
0x2fd8: 0x205ddbb7
0x2fd9: 0x19205ddb
0x2fda: 0x0219205d
0x2fdb: 0x10021920
0x2fdc: 0x79100219
0x2fdd: 0x26791002
0x2fde: 0x00267910
0x2fdf: 0xfb002679
0x2fe0: 0x00fb0026
0x2fe1: 0xbb00fb00
0x2fe2: 0xf8bb00fb
0x2fe3: 0x7bf8bb00
0x2fe4: 0xb47bf8bb
0x2fe5: 0x0ab47bf8
0x2fe6: 0x7e0ab47b
0x2fe7: 0xff7e0ab4
0x2fe8: 0xf7ff7e0a
0x2fe9: 0x51f7ff7e
0x2fea: 0x4f51f7ff
0x2feb: 0x104f51f7
0x2fec: 0xe7104f51
0x2fed: 0xdae7104f
0x2fee: 0x3adae710
0x2fef: 0xbb3adae7
0x2ff0: 0xc7bb3ada
0x2ff1: 0xfdc7bb3a
0x2ff2: 0xfffdc7bb
0x2ff3: 0xd8fffdc7
0x2ff4: 0xc3d8fffd
0x2ff5: 0x90c3d8ff
0x2ff6: 0x0890c3d8
0x2ff7: 0x9f0890c3
0x2ff8: 0x7a9f0890
0x2ff9: 0x007a9f08
0x2ffa: 0xfd007a9f
0x2ffb: 0xaffd007a
0x2ffc: 0xb0affd00
0x2ffd: 0xffb0affd
0x2ffe: 0xffffb0af
0x2fff: 0xffffffb0

Glück Auf
Volker
