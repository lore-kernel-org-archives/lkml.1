Return-Path: <linux-kernel-owner+w=401wt.eu-S935366AbXGRU4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935366AbXGRU4V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 16:56:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755016AbXGRU4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 16:56:13 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:60794 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754505AbXGRU4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 16:56:10 -0400
Message-ID: <469E7E54.4020200@cv-sv.de>
Date: Wed, 18 Jul 2007 22:55:48 +0200
From: Christian Volkmann <haveaniceday@cv-sv.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de-AT; rv:1.8.1.4) Gecko/20070529 SUSE/1.1.2-4.1 SeaMonkey/1.1.2
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: haveaniceday@cv-sv.de
Subject: OOps in CIFS during shutdown, kernel 2.6.22 tainted with vmware.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX18DhtW3ONwtIQneHHbPy/6YNuGPfgBWHRSYlF5
 P81L7SfKCYWfAiU3CZRvn/BbWxqPkGKDS91TZ1amt2ODEUfEE6
 lvgVeUsnKHbKqRZNOGUPg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I had several Oops in messages.
The kernel 2.6.22 is tainted with a vmware module.

Please ignore this mail if you expect vmware-modules had crashed the system.
The vmware had not been used during the uptime.

But may be somebody can find some errors also with a tainted kernel.

I will try to use the system without the tainting module.
May be this problem during the shutdown happens again.

Best regards,

Christian


Jul 18 17:20:01 ocv kernel: BUG: unable to handle kernel NULL pointer dereference at virtual address 000000c8
Jul 18 17:20:01 ocv kernel:  printing eip:
Jul 18 17:20:01 ocv kernel: f94d0a45
Jul 18 17:20:01 ocv kernel: *pde = 00000000
Jul 18 17:20:01 ocv kernel: Oops: 0000 [#1]
Jul 18 17:20:01 ocv kernel: SMP
Jul 18 17:20:01 ocv kernel: Modules linked in: i915 drm nfsd ipv6 vmnet(P) exportfs cifs lockd nfs_acl sunrpc vmmon(P) button battery ac cbc blkcipher twofish twofish_common cryptoloop usbhid ff_memless ohci_hcd sr_mod nls_utf8 ext2 loop dm_mod fuse
usb_storage tg3 intel_agp ac97_bus soundcore snd_page_alloc shpchp agpgart ehci_hcd ide_cd cdrom pci_hotplug uhci_hcd usbcore ext3 mbcache jbd edd fan sg ata_piix libata piix thermal processor sd_mod scsi_mod ide_disk ide_core
Jul 18 17:20:01 ocv kernel: CPU:    0
Jul 18 17:20:01 ocv kernel: EIP:    0060:[<f94d0a45>]    Tainted: P       VLI
Jul 18 17:20:01 ocv kernel: EFLAGS: 00010202   (2.6.22.1-cv #3)
Jul 18 17:20:01 ocv kernel: EIP is at smb_init+0x145/0x2a2 [cifs]
Jul 18 17:20:01 ocv kernel: eax: 00000034   ebx: f71134c0   ecx: dfed2e00   edx: 0000000f
Jul 18 17:20:02 ocv kernel: esi: dfed2e00   edi: f7015960   ebp: 00000032   esp: f6d5bd94
Jul 18 17:20:04 ocv kernel: ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Jul 18 17:20:05 ocv kernel: Process fuser (pid: 12000, ti=f6d5a000 task=dffd7570 task.ti=f6d5a000)
Jul 18 17:20:05 ocv kernel: Stack: 0000000e 0000000b 0000000f c5e14d40 c02b42b8 00000573 00008000 00000000
Jul 18 17:20:05 ocv kernel:        f71134c0 fffffff4 f7015960 f7ede4e0 f94d32be f6d5bde4 f6d5bde0 f7975140
Jul 18 17:20:06 ocv kernel:        dfed2e00 0000020a 51e38bf5 00000000 00000000 f71134c0 fffffff4 f7015960
Jul 18 17:20:06 ocv kernel: Call Trace:
Jul 18 17:20:07 ocv kernel:  [<c02b42b8>] do_page_fault+0x0/0x516
Jul 18 17:20:09 ocv kernel:  [<f94d32be>] CIFSSMBQPathInfo+0x43/0x259 [cifs]
Jul 18 17:20:09 ocv kernel:  [<f94e4560>] cifs_get_inode_info+0xcf/0x829 [cifs]
Jul 18 17:20:09 ocv kernel:  [<c017526a>] __link_path_walk+0xaf2/0xc1a
Jul 18 17:20:09 ocv kernel:  [<f94df1a4>] build_path_from_dentry+0x81/0x13e [cifs]
Jul 18 17:20:10 ocv kernel:  [<f94e4e9b>] cifs_revalidate+0x1e1/0x339 [cifs]
Jul 18 17:20:10 ocv kernel:  [<f94e5001>] cifs_getattr+0xe/0x2b [cifs]
Jul 18 17:20:11 ocv kernel:  [<f94e4ff3>] cifs_getattr+0x0/0x2b [cifs]
Jul 18 17:20:11 ocv kernel:  [<c016fb78>] vfs_getattr+0x40/0x53
Jul 18 17:20:11 ocv kernel:  [<c016fc4f>] vfs_stat_fd+0x2e/0x40
Jul 18 17:20:11 ocv kernel:  [<c016fcee>] sys_stat64+0xf/0x23
Jul 18 17:20:11 ocv kernel:  [<c0104cb2>] sysenter_past_esp+0x5f/0x85
Jul 18 17:20:11 ocv kernel:  [<c02b0000>] wireless_send_event+0x280/0x2f7
Jul 18 17:20:11 ocv kernel:  =======================
Jul 18 17:20:11 ocv kernel: Code: 75 23 bb 90 ff ff ff f6 05 00 44 50 f9 01 0f 84 6a 01 00 00 c7 04 24 e1 19 4f f9 e8 a0 35 c5 c6 e9 59 01 00 00 8b 46 24 8b 40 1c <83> b8 94 00 00 00 03 0f 84 28 ff ff ff e8 86 df cd c6 89 c7 8b
Jul 18 17:20:11 ocv kernel: EIP: [<f94d0a45>] smb_init+0x145/0x2a2 [cifs] SS:ESP 0068:f6d5bd94
Jul 18 17:20:11 ocv kernel: BUG: unable to handle kernel NULL pointer dereference at virtual address 000000c8
Jul 18 17:20:11 ocv kernel:  printing eip:
Jul 18 17:20:11 ocv kernel: f94d0a45
Jul 18 17:20:11 ocv kernel: *pde = 00000000
Jul 18 17:20:11 ocv kernel: Oops: 0000 [#2]
Jul 18 17:20:11 ocv kernel: SMP
Jul 18 17:20:11 ocv kernel: Modules linked in: i915 drm nfsd ipv6 vmnet(P) exportfs cifs lockd nfs_acl sunrpc vmmon(P) button battery ac cbc blkcipher twofish twofish_common cryptoloop usbhid ff_memless ohci_hcd sr_mod nls_utf8 ext2 loop dm_mod fuse
usb_storage tg3 intel_agp ac97_bus soundcore snd_page_alloc shpchp agpgart ehci_hcd ide_cd cdrom pci_hotplug uhci_hcd usbcore ext3 mbcache jbd edd fan sg ata_piix libata piix thermal processor sd_mod scsi_mod ide_disk ide_core
Jul 18 17:20:11 ocv kernel: CPU:    0
Jul 18 17:20:11 ocv kernel: EIP:    0060:[<f94d0a45>]    Tainted: P       VLI
Jul 18 17:20:11 ocv kernel: EFLAGS: 00010202   (2.6.22.1-cv #3)
Jul 18 17:20:11 ocv kernel: EIP is at smb_init+0x145/0x2a2 [cifs]
Jul 18 17:20:11 ocv kernel: eax: 00000034   ebx: f7b293c0   ecx: dfed2e00   edx: 0000000f
Jul 18 17:20:11 ocv kernel: esi: dfed2e00   edi: f7015960   ebp: 00000032   esp: eb517d94
Jul 18 17:20:11 ocv kernel: ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Jul 18 17:20:11 ocv kernel: Process fuser (pid: 12005, ti=eb516000 task=f6c58030 task.ti=eb516000)
Jul 18 17:20:11 ocv kernel: Stack: dfd28000 f8e0378a 0000000f 00000900 00000011 e193c360 00008000 00000000
Jul 18 17:20:11 ocv kernel:        f7b293c0 fffffff4 f7015960 f73e4d40 f94d32be eb517de4 eb517de0 f7975140
Jul 18 17:20:11 ocv kernel:        dfed2e00 0000020b 51e38bf5 00000000 00000000 f7b293c0 fffffff4 f7015960
Jul 18 17:20:11 ocv kernel: Call Trace:
Jul 18 17:20:11 ocv kernel:  [<f8e0378a>] journal_stop+0x270/0x27c [jbd]
Jul 18 17:20:11 ocv kernel:  [<f94d32be>] CIFSSMBQPathInfo+0x43/0x259 [cifs]
Jul 18 17:20:11 ocv kernel:  [<f94e4560>] cifs_get_inode_info+0xcf/0x829 [cifs]
Jul 18 17:20:11 ocv kernel:  [<c017526a>] __link_path_walk+0xaf2/0xc1a
Jul 18 17:20:11 ocv kernel:  [<f94df1a4>] build_path_from_dentry+0x81/0x13e [cifs]
Jul 18 17:20:11 ocv kernel:  [<f94e4e9b>] cifs_revalidate+0x1e1/0x339 [cifs]
Jul 18 17:20:11 ocv kernel:  [<f94e5001>] cifs_getattr+0xe/0x2b [cifs]
Jul 18 17:20:11 ocv kernel:  [<f94e4ff3>] cifs_getattr+0x0/0x2b [cifs]
Jul 18 17:20:11 ocv kernel:  [<c016fb78>] vfs_getattr+0x40/0x53
Jul 18 17:20:11 ocv kernel:  [<c016fc4f>] vfs_stat_fd+0x2e/0x40
Jul 18 17:20:11 ocv kernel:  [<c016fcee>] sys_stat64+0xf/0x23
Jul 18 17:20:11 ocv kernel:  [<c0104cb2>] sysenter_past_esp+0x5f/0x85
Jul 18 17:20:11 ocv kernel:  [<c02b0000>] wireless_send_event+0x280/0x2f7
Jul 18 17:20:11 ocv kernel:  =======================
Jul 18 17:20:11 ocv kernel: Code: 75 23 bb 90 ff ff ff f6 05 00 44 50 f9 01 0f 84 6a 01 00 00 c7 04 24 e1 19 4f f9 e8 a0 35 c5 c6 e9 59 01 00 00 8b 46 24 8b 40 1c <83> b8 94 00 00 00 03 0f 84 28 ff ff ff e8 86 df cd c6 89 c7 8b
Jul 18 17:20:11 ocv kernel: EIP: [<f94d0a45>] smb_init+0x145/0x2a2 [cifs] SS:ESP 0068:eb517d94
Jul 18 17:20:11 ocv kernel: BUG: unable to handle kernel NULL pointer dereference at virtual address 000000c8
Jul 18 17:20:11 ocv kernel:  printing eip:
Jul 18 17:20:11 ocv kernel: f94d0a45
Jul 18 17:20:11 ocv kernel: *pde = 00000000
Jul 18 17:20:11 ocv kernel: Oops: 0000 [#3]
Jul 18 17:20:11 ocv kernel: SMP
Jul 18 17:20:11 ocv kernel: Modules linked in: i915 drm nfsd ipv6 vmnet(P) exportfs cifs lockd nfs_acl sunrpc vmmon(P) button battery ac cbc blkcipher twofish twofish_common cryptoloop usbhid ff_memless ohci_hcd sr_mod nls_utf8 ext2 loop dm_mod fuse
usb_storage tg3 intel_agp ac97_bus soundcore snd_page_alloc shpchp agpgart ehci_hcd ide_cd cdrom pci_hotplug uhci_hcd usbcore ext3 mbcache jbd edd fan sg ata_piix libata piix thermal processor sd_mod scsi_mod ide_disk ide_core
Jul 18 17:20:11 ocv kernel: CPU:    0
Jul 18 17:20:11 ocv kernel: EIP:    0060:[<f94d0a45>]    Tainted: P       VLI
Jul 18 17:20:11 ocv kernel: EFLAGS: 00010202   (2.6.22.1-cv #3)
Jul 18 17:20:11 ocv kernel: EIP is at smb_init+0x145/0x2a2 [cifs]
Jul 18 17:20:11 ocv kernel: eax: 00000034   ebx: f7113940   ecx: dfed2e00   edx: 0000000f
Jul 18 17:20:11 ocv kernel: esi: dfed2e00   edi: f7015960   ebp: 00000032   esp: f6803d94
Jul 18 17:20:11 ocv kernel: ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Jul 18 17:20:11 ocv kernel: Process fuser (pid: 12008, ti=f6802000 task=df787ab0 task.ti=f6802000)
Jul 18 17:20:11 ocv kernel: Stack: 0000000e 0000000b 0000000f c5e14d40 c02b42b8 00000573 00008000 00000000
Jul 18 17:20:11 ocv kernel:        f7113940 fffffff4 f7015960 f7e9fca0 f94d32be f6803de4 f6803de0 f7975140
Jul 18 17:20:11 ocv kernel:        dfed2e00 0000020c 51e38bf5 00000000 00000000 f7113940 fffffff4 f7015960
Jul 18 17:20:11 ocv kernel: Call Trace:
Jul 18 17:20:11 ocv kernel:  [<c02b42b8>] do_page_fault+0x0/0x516
Jul 18 17:20:11 ocv kernel:  [<f94d32be>] CIFSSMBQPathInfo+0x43/0x259 [cifs]
Jul 18 17:20:11 ocv kernel:  [<f94e4560>] cifs_get_inode_info+0xcf/0x829 [cifs]
Jul 18 17:20:11 ocv kernel:  [<c017526a>] __link_path_walk+0xaf2/0xc1a
Jul 18 17:20:11 ocv kernel:  [<f94df1a4>] build_path_from_dentry+0x81/0x13e [cifs]
Jul 18 17:20:11 ocv kernel:  [<f94e4e9b>] cifs_revalidate+0x1e1/0x339 [cifs]
Jul 18 17:20:11 ocv kernel:  [<f94e5001>] cifs_getattr+0xe/0x2b [cifs]
Jul 18 17:20:11 ocv kernel:  [<f94e4ff3>] cifs_getattr+0x0/0x2b [cifs]
Jul 18 17:20:11 ocv kernel:  [<c016fb78>] vfs_getattr+0x40/0x53
Jul 18 17:20:11 ocv kernel:  [<c016fc4f>] vfs_stat_fd+0x2e/0x40
Jul 18 17:20:11 ocv kernel:  [<c016fcee>] sys_stat64+0xf/0x23
Jul 18 17:20:11 ocv kernel:  [<c0104cb2>] sysenter_past_esp+0x5f/0x85
Jul 18 17:20:11 ocv kernel:  [<c02b0000>] wireless_send_event+0x280/0x2f7
Jul 18 17:20:11 ocv kernel:  =======================
Jul 18 17:20:11 ocv kernel: Code: 75 23 bb 90 ff ff ff f6 05 00 44 50 f9 01 0f 84 6a 01 00 00 c7 04 24 e1 19 4f f9 e8 a0 35 c5 c6 e9 59 01 00 00 8b 46 24 8b 40 1c <83> b8 94 00 00 00 03 0f 84 28 ff ff ff e8 86 df cd c6 89 c7 8b
Jul 18 17:20:11 ocv kernel: EIP: [<f94d0a45>] smb_init+0x145/0x2a2 [cifs] SS:ESP 0068:f6803d94
Jul 18 17:20:11 ocv kernel: BUG: unable to handle kernel NULL pointer dereference at virtual address 000000c8
Jul 18 17:20:11 ocv kernel: /dev/vmmon[12015]: Module vmmon: unloaded
Jul 18 17:20:11 ocv kernel:  printing eip:
Jul 18 17:20:11 ocv kernel: BUG: unable to handle kernel NULL pointer dereference at virtual address 000000c8
Jul 18 17:20:11 ocv kernel:  printing eip:
Jul 18 17:20:11 ocv kernel: f94d0a45
Jul 18 17:20:11 ocv kernel: *pde = 00000000
Jul 18 17:20:11 ocv kernel: Oops: 0000 [#4]
Jul 18 17:20:11 ocv kernel: SMP
Jul 18 17:20:11 ocv kernel: Modules linked in: i915 drm nfsd ipv6 vmnet(P) exportfs cifs lockd nfs_acl sunrpc vmmon(P) button battery ac cbc blkcipher twofish twofish_common cryptoloop usbhid ff_memless ohci_hcd sr_mod nls_utf8 ext2 loop dm_mod fuse
usb_storage tg3 intel_agp ac97_bus soundcore snd_page_alloc shpchp agpgart ehci_hcd ide_cd cdrom pci_hotplug uhci_hcd usbcore ext3 mbcache jbd edd fan sg ata_piix libata piix thermal processor sd_mod scsi_mod ide_disk ide_core
Jul 18 17:20:11 ocv kernel: CPU:    0
Jul 18 17:20:11 ocv kernel: EIP:    0060:[<f94d0a45>]    Tainted: P       VLI
Jul 18 17:20:11 ocv kernel: EFLAGS: 00010202   (2.6.22.1-cv #3)
Jul 18 17:20:11 ocv kernel: EIP is at smb_init+0x145/0x2a2 [cifs]
Jul 18 17:20:11 ocv kernel: eax: 00000034   ebx: f780cb40   ecx: dfed2e00   edx: 0000000f
Jul 18 17:20:11 ocv kernel: esi: dfed2e00   edi: f7015960   ebp: 00000032   esp: f2991d94
Jul 18 17:20:11 ocv kernel: ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Jul 18 17:20:11 ocv kernel: Process fuser (pid: 12019, ti=f2990000 task=f2939ab0 task.ti=f2990000)
Jul 18 17:20:11 ocv kernel: Stack: 0000000e 0000000b 0000000f c5f5b900 c02b42b8 00000517 00008000 00000000
Jul 18 17:20:11 ocv kernel:        f780cb40 fffffff4 f7015960 f757c9e0 f94d32be f2991de4 f2991de0 f7975140
Jul 18 17:20:11 ocv kernel:        dfed2e00 0000020e 51e38bf5 00000000 00000000 f780cb40 fffffff4 f7015960
Jul 18 17:20:11 ocv kernel: Call Trace:
Jul 18 17:20:11 ocv kernel:  [<c02b42b8>] do_page_fault+0x0/0x516
Jul 18 17:20:11 ocv kernel:  [<f94d32be>] CIFSSMBQPathInfo+0x43/0x259 [cifs]
Jul 18 17:20:11 ocv kernel:  [<f94e4560>] cifs_get_inode_info+0xcf/0x829 [cifs]
Jul 18 17:20:11 ocv kernel:  [<c017526a>] __link_path_walk+0xaf2/0xc1a
Jul 18 17:20:11 ocv kernel:  [<f94df1a4>] build_path_from_dentry+0x81/0x13e [cifs]
Jul 18 17:20:12 ocv kernel:  [<f94e4e9b>] cifs_revalidate+0x1e1/0x339 [cifs]
Jul 18 17:20:12 ocv kernel:  [<f94e5001>] cifs_getattr+0xe/0x2b [cifs]
Jul 18 17:20:12 ocv kernel:  [<f94e4ff3>] cifs_getattr+0x0/0x2b [cifs]
Jul 18 17:20:12 ocv kernel:  [<c016fb78>] vfs_getattr+0x40/0x53
Jul 18 17:20:12 ocv kernel:  [<c016fc4f>] vfs_stat_fd+0x2e/0x40
Jul 18 17:20:12 ocv kernel:  [<c016fcee>] sys_stat64+0xf/0x23
Jul 18 17:20:12 ocv kernel:  [<c0104cb2>] sysenter_past_esp+0x5f/0x85
Jul 18 17:20:12 ocv kernel:  [<c02b0000>] wireless_send_event+0x280/0x2f7
Jul 18 17:20:12 ocv kernel:  =======================
Jul 18 17:20:12 ocv kernel: Code: 75 23 bb 90 ff ff ff f6 05 00 44 50 f9 01 0f 84 6a 01 00 00 c7 04 24 e1 19 4f f9 e8 a0 35 c5 c6 e9 59 01 00 00 8b 46 24 8b 40 1c <83> b8 94 00 00 00 03 0f 84 28 ff ff ff e8 86 df cd c6 89 c7 8b
Jul 18 17:20:12 ocv kernel: EIP: [<f94d0a45>] smb_init+0x145/0x2a2 [cifs] SS:ESP 0068:f2991d94
Jul 18 17:20:12 ocv kernel: f94d0a45
Jul 18 17:20:12 ocv kernel: *pde = 00000000
Jul 18 17:20:12 ocv kernel: Oops: 0000 [#5]
Jul 18 17:20:12 ocv kernel: SMP
Jul 18 17:20:12 ocv kernel: Modules linked in: i915 drm nfsd ipv6 vmnet(P) exportfs cifs lockd nfs_acl sunrpc vmmon(P) button battery ac cbc blkcipher twofish twofish_common cryptoloop usbhid ff_memless ohci_hcd sr_mod nls_utf8 ext2 loop dm_mod fuse
usb_storage tg3 intel_agp ac97_bus soundcore snd_page_alloc shpchp agpgart ehci_hcd ide_cd cdrom pci_hotplug uhci_hcd usbcore ext3 mbcache jbd edd fan sg ata_piix libata piix thermal processor sd_mod scsi_mod ide_disk ide_core
Jul 18 17:20:12 ocv kernel: CPU:    1
Jul 18 17:20:12 ocv kernel: EIP:    0060:[<f94d0a45>]    Tainted: P       VLI
Jul 18 17:20:12 ocv kernel: EFLAGS: 00010202   (2.6.22.1-cv #3)
Jul 18 17:20:12 ocv kernel: EIP is at smb_init+0x145/0x2a2 [cifs]
Jul 18 17:20:12 ocv kernel: eax: 00000034   ebx: f7c4ec00   ecx: dfed2e00   edx: 0000000f
Jul 18 17:20:12 ocv kernel: esi: dfed2e00   edi: f2eabe54   ebp: 00000032   esp: f2eabdfc
Jul 18 17:20:12 ocv kernel: ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Jul 18 17:20:12 ocv kernel: Process umount.cifs (pid: 12018, ti=f2eaa000 task=ecff0570 task.ti=f2eaa000)
Jul 18 17:20:12 ocv kernel: Stack: f70b4c08 dfcc3dc0 0000000f f70b4c08 f77a7e2c c017526a f141801b f7c6d54c
Jul 18 17:20:12 ocv kernel:        f7c4ec00 f2eabe58 f2eabe54 dfed2e00 f94d1258 f2eabe58 f2eabe54 00000000
Jul 18 17:20:12 ocv kernel:        00000202 51e38bf5 0000000b f2eabea4 0000020d 00000000 00000000 00000000
Jul 18 17:20:12 ocv kernel: Call Trace:
Jul 18 17:20:12 ocv kernel:  [<c017526a>] __link_path_walk+0xaf2/0xc1a
Jul 18 17:20:12 ocv kernel:  [<f94d1258>] SMBOldQFSInfo+0x5e/0x26c [cifs]
Jul 18 17:20:12 ocv kernel:  [<f94d0407>] cifs_statfs+0xc5/0xfd [cifs]
Jul 18 17:20:12 ocv kernel:  [<c02b452b>] do_page_fault+0x273/0x516
Jul 18 17:20:12 ocv kernel:  [<c016b75f>] vfs_statfs+0x47/0x5f
Jul 18 17:20:12 ocv kernel:  [<c016b851>] vfs_statfs64+0x10/0x21
Jul 18 17:20:12 ocv kernel:  [<c016c695>] sys_statfs64+0x49/0x80
Jul 18 17:20:12 ocv kernel:  [<c02b452b>] do_page_fault+0x273/0x516
Jul 18 17:20:12 ocv kernel:  [<c015f804>] do_munmap+0x193/0x1ac
Jul 18 17:20:12 ocv kernel:  [<c0104cb2>] sysenter_past_esp+0x5f/0x85
Jul 18 17:20:12 ocv kernel:  =======================
Jul 18 17:20:12 ocv kernel: Code: 75 23 bb 90 ff ff ff f6 05 00 44 50 f9 01 0f 84 6a 01 00 00 c7 04 24 e1 19 4f f9 e8 a0 35 c5 c6 e9 59 01 00 00 8b 46 24 8b 40 1c <83> b8 94 00 00 00 03 0f 84 28 ff ff ff e8 86 df cd c6 89 c7 8b
Jul 18 17:20:12 ocv kernel: EIP: [<f94d0a45>] smb_init+0x145/0x2a2 [cifs] SS:ESP 0068:f2eabdfc
Jul 18 17:20:12 ocv kernel: BUG: unable to handle kernel NULL pointer dereference at virtual address 000000c8
Jul 18 17:20:12 ocv kernel:  printing eip:
Jul 18 17:20:12 ocv kernel: f94d0a45
Jul 18 17:20:12 ocv kernel: *pde = 00000000
Jul 18 17:20:12 ocv kernel: Oops: 0000 [#6]
Jul 18 17:20:12 ocv kernel: SMP
Jul 18 17:20:12 ocv kernel: Modules linked in: i915 drm nfsd ipv6 vmnet(P) exportfs cifs lockd nfs_acl sunrpc button battery ac cbc blkcipher twofish twofish_common cryptoloop usbhid ff_memless ohci_hcd sr_mod nls_utf8 ext2 loop dm_mod fuse usb_storage
tg3 intel_agp ac97_bus soundcore snd_page_alloc shpchp agpgart ehci_hcd ide_cd cdrom pci_hotplug uhci_hcd usbcore ext3 mbcache jbd edd fan sg ata_piix libata piix thermal processor sd_mod scsi_mod ide_disk ide_core
Jul 18 17:20:12 ocv kernel: CPU:    0
Jul 18 17:20:12 ocv kernel: EIP:    0060:[<f94d0a45>]    Tainted: P       VLI
Jul 18 17:20:12 ocv kernel: EFLAGS: 00010202   (2.6.22.1-cv #3)
Jul 18 17:20:12 ocv kernel: EIP is at smb_init+0x145/0x2a2 [cifs]
Jul 18 17:20:12 ocv kernel: eax: 00000034   ebx: f7c4ec00   ecx: dfed2e00   edx: 0000000f
Jul 18 17:20:12 ocv kernel: esi: dfed2e00   edi: e2d8fe54   ebp: 00000032   esp: e2d8fdfc
Jul 18 17:20:12 ocv kernel: ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Jul 18 17:20:12 ocv kernel: Process umount.cifs (pid: 12030, ti=e2d8e000 task=dffe7ab0 task.ti=e2d8e000)
Jul 18 17:20:12 ocv kernel: Stack: f70b4c08 dfcc3dc0 0000000f f70b4c08 f77a7e2c c017526a e138b01b 0000000a
Jul 18 17:20:12 ocv kernel:        f7c4ec00 e2d8fe58 e2d8fe54 dfed2e00 f94d1258 e2d8fe58 e2d8fe54 00000000
Jul 18 17:20:12 ocv kernel:        00000246 51e38bf5 0000000b e2d8fea4 0000020f 00000000 00000000 00000000
Jul 18 17:20:12 ocv kernel: Call Trace:
Jul 18 17:20:12 ocv kernel:  [<c017526a>] __link_path_walk+0xaf2/0xc1a
Jul 18 17:20:12 ocv kernel:  [<f94d1258>] SMBOldQFSInfo+0x5e/0x26c [cifs]
Jul 18 17:20:12 ocv kernel:  [<f94d0407>] cifs_statfs+0xc5/0xfd [cifs]
Jul 18 17:20:12 ocv kernel:  [<c02b452b>] do_page_fault+0x273/0x516
Jul 18 17:20:12 ocv kernel:  [<c016b75f>] vfs_statfs+0x47/0x5f
Jul 18 17:20:12 ocv kernel:  [<c016b851>] vfs_statfs64+0x10/0x21
Jul 18 17:20:12 ocv kernel:  [<c016c695>] sys_statfs64+0x49/0x80
Jul 18 17:20:12 ocv kernel:  [<c02b452b>] do_page_fault+0x273/0x516
Jul 18 17:20:12 ocv kernel:  [<c015f804>] do_munmap+0x193/0x1ac
Jul 18 17:20:12 ocv kernel:  [<c0104cb2>] sysenter_past_esp+0x5f/0x85
Jul 18 17:20:12 ocv kernel:  =======================
Jul 18 17:20:12 ocv kernel: Code: 75 23 bb 90 ff ff ff f6 05 00 44 50 f9 01 0f 84 6a 01 00 00 c7 04 24 e1 19 4f f9 e8 a0 35 c5 c6 e9 59 01 00 00 8b 46 24 8b 40 1c <83> b8 94 00 00 00 03 0f 84 28 ff ff ff e8 86 df cd c6 89 c7 8b
Jul 18 17:20:12 ocv kernel: EIP: [<f94d0a45>] smb_init+0x145/0x2a2 [cifs] SS:ESP 0068:e2d8fdfc
Jul 18 17:20:12 ocv kernel: BUG: unable to handle kernel NULL pointer dereference at virtual address 000000c8
Jul 18 17:20:12 ocv kernel:  printing eip:
Jul 18 17:20:12 ocv kernel: f94d0a45
Jul 18 17:20:12 ocv kernel: *pde = 00000000
Jul 18 17:20:12 ocv kernel: Oops: 0000 [#7]
Jul 18 17:20:12 ocv kernel: SMP
Jul 18 17:20:12 ocv kernel: Modules linked in: i915 drm nfsd ipv6 vmnet(P) exportfs cifs lockd nfs_acl sunrpc button battery ac cbc blkcipher twofish twofish_common cryptoloop usbhid ff_memless ohci_hcd sr_mod nls_utf8 ext2 loop dm_mod fuse usb_storage
tg3 intel_agp ac97_bus soundcore snd_page_alloc shpchp agpgart ehci_hcd ide_cd cdrom pci_hotplug uhci_hcd usbcore ext3 mbcache jbd edd fan sg ata_piix libata piix thermal processor sd_mod scsi_mod ide_disk ide_core
Jul 18 17:20:12 ocv kernel: CPU:    1
Jul 18 17:20:12 ocv kernel: EIP:    0060:[<f94d0a45>]    Tainted: P       VLI
Jul 18 17:20:12 ocv kernel: EFLAGS: 00010202   (2.6.22.1-cv #3)
Jul 18 17:20:12 ocv kernel: EIP is at smb_init+0x145/0x2a2 [cifs]
Jul 18 17:20:12 ocv kernel: eax: 00000034   ebx: f7c477c0   ecx: dfed2e00   edx: 0000000f
Jul 18 17:20:12 ocv kernel: esi: dfed2e00   edi: f7015960   ebp: 00000032   esp: f29c3d94
Jul 18 17:20:12 ocv kernel: ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Jul 18 17:20:12 ocv kernel: Process fuser (pid: 12032, ti=f29c2000 task=de0b9570 task.ti=f29c2000)
Jul 18 17:20:12 ocv kernel: Stack: dfd28000 f8e0378a 0000000f 00000b80 00000011 e193c888 00008000 00000000
Jul 18 17:20:12 ocv kernel:        f7c477c0 fffffff4 f7015960 f7c73a80 f94d32be f29c3de4 f29c3de0 f7975140
Jul 18 17:20:12 ocv kernel:        dfed2e00 00000210 51e38bf5 00000000 00000000 f7c477c0 fffffff4 f7015960
Jul 18 17:20:12 ocv kernel: Call Trace:
Jul 18 17:20:12 ocv kernel:  [<f8e0378a>] journal_stop+0x270/0x27c [jbd]
Jul 18 17:20:12 ocv kernel:  [<f94d32be>] CIFSSMBQPathInfo+0x43/0x259 [cifs]
Jul 18 17:20:12 ocv kernel:  [<f94e4560>] cifs_get_inode_info+0xcf/0x829 [cifs]
Jul 18 17:20:12 ocv kernel:  [<c017526a>] __link_path_walk+0xaf2/0xc1a
Jul 18 17:20:12 ocv kernel:  [<f94df1a4>] build_path_from_dentry+0x81/0x13e [cifs]
Jul 18 17:20:12 ocv kernel:  [<f94e4e9b>] cifs_revalidate+0x1e1/0x339 [cifs]
Jul 18 17:20:12 ocv kernel:  [<f94e5001>] cifs_getattr+0xe/0x2b [cifs]
Jul 18 17:20:12 ocv kernel:  [<f94e4ff3>] cifs_getattr+0x0/0x2b [cifs]
Jul 18 17:20:12 ocv kernel:  [<c016fb78>] vfs_getattr+0x40/0x53
Jul 18 17:20:12 ocv kernel:  [<c016fc4f>] vfs_stat_fd+0x2e/0x40
Jul 18 17:20:12 ocv kernel:  [<c016fcee>] sys_stat64+0xf/0x23
Jul 18 17:20:12 ocv kernel:  [<c0104cb2>] sysenter_past_esp+0x5f/0x85
Jul 18 17:20:12 ocv kernel:  [<c02b0000>] wireless_send_event+0x280/0x2f7
Jul 18 17:20:12 ocv kernel:  =======================
Jul 18 17:20:12 ocv kernel: Code: 75 23 bb 90 ff ff ff f6 05 00 44 50 f9 01 0f 84 6a 01 00 00 c7 04 24 e1 19 4f f9 e8 a0 35 c5 c6 e9 59 01 00 00 8b 46 24 8b 40 1c <83> b8 94 00 00 00 03 0f 84 28 ff ff ff e8 86 df cd c6 89 c7 8b
Jul 18 17:20:12 ocv kernel: EIP: [<f94d0a45>] smb_init+0x145/0x2a2 [cifs] SS:ESP 0068:f29c3d94
Jul 18 17:20:12 ocv kernel: bridge-eth0: down
Jul 18 17:20:12 ocv kernel: bridge-eth0: detached
Jul 18 17:20:12 ocv kernel: BUG: unable to handle kernel NULL pointer dereference at virtual address 000000c8
Jul 18 17:20:12 ocv kernel:  printing eip:
Jul 18 17:20:12 ocv kernel: f94d0a45
Jul 18 17:20:12 ocv kernel: *pde = 00000000
Jul 18 17:20:12 ocv kernel: Oops: 0000 [#8]
Jul 18 17:20:12 ocv kernel: SMP
Jul 18 17:20:12 ocv kernel: Modules linked in: i915 drm nfsd ipv6 vmnet(P) exportfs cifs lockd nfs_acl sunrpc button battery ac cbc blkcipher twofish twofish_common cryptoloop usbhid ff_memless ohci_hcd sr_mod nls_utf8 ext2 loop dm_mod fuse usb_storage
tg3 intel_agp ac97_bus soundcore snd_page_alloc shpchp agpgart ehci_hcd ide_cd cdrom pci_hotplug uhci_hcd usbcore ext3 mbcache jbd edd fan sg ata_piix libata piix thermal processor sd_mod scsi_mod ide_disk ide_core
Jul 18 17:20:12 ocv kernel: CPU:    1
Jul 18 17:20:12 ocv kernel: EIP:    0060:[<f94d0a45>]    Tainted: P       VLI
Jul 18 17:20:12 ocv kernel: EFLAGS: 00010202   (2.6.22.1-cv #3)
Jul 18 17:20:12 ocv kernel: EIP is at smb_init+0x145/0x2a2 [cifs]
Jul 18 17:20:12 ocv kernel: eax: 00000034   ebx: e527a9c0   ecx: dfed2e00   edx: 0000000f
Jul 18 17:20:12 ocv kernel: esi: dfed2e00   edi: f7015960   ebp: 00000032   esp: f731fd94
Jul 18 17:20:12 ocv kernel: ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Jul 18 17:20:12 ocv kernel: Process fuser (pid: 12059, ti=f731e000 task=dffe7ab0 task.ti=f731e000)
Jul 18 17:20:12 ocv kernel: Stack: 0000000e 0000000b 0000000f c5f5b900 c02b42b8 00000517 00008000 00000000
Jul 18 17:20:12 ocv kernel:        e527a9c0 fffffff4 f7015960 f78846a0 f94d32be f731fde4 f731fde0 f7975140
Jul 18 17:20:12 ocv kernel:        dfed2e00 00000211 51e38bf5 00000000 00000000 e527a9c0 fffffff4 f7015960
Jul 18 17:20:12 ocv kernel: Call Trace:
Jul 18 17:20:12 ocv kernel:  [<c02b42b8>] do_page_fault+0x0/0x516
Jul 18 17:20:12 ocv kernel:  [<f94d32be>] CIFSSMBQPathInfo+0x43/0x259 [cifs]
Jul 18 17:20:12 ocv kernel:  [<f94e4560>] cifs_get_inode_info+0xcf/0x829 [cifs]
Jul 18 17:20:12 ocv kernel:  [<c017526a>] __link_path_walk+0xaf2/0xc1a
Jul 18 17:20:12 ocv kernel:  [<f94df1a4>] build_path_from_dentry+0x81/0x13e [cifs]
Jul 18 17:20:12 ocv kernel:  [<f94e4e9b>] cifs_revalidate+0x1e1/0x339 [cifs]
Jul 18 17:20:12 ocv kernel:  [<f94e5001>] cifs_getattr+0xe/0x2b [cifs]
Jul 18 17:20:12 ocv kernel:  [<f94e4ff3>] cifs_getattr+0x0/0x2b [cifs]
Jul 18 17:20:12 ocv kernel:  [<c016fb78>] vfs_getattr+0x40/0x53
Jul 18 17:20:12 ocv kernel:  [<c016fc4f>] vfs_stat_fd+0x2e/0x40
Jul 18 17:20:12 ocv kernel:  [<c016fcee>] sys_stat64+0xf/0x23
Jul 18 17:20:12 ocv kernel:  [<c0104cb2>] sysenter_past_esp+0x5f/0x85
Jul 18 17:20:12 ocv kernel:  [<c02b0000>] wireless_send_event+0x280/0x2f7
Jul 18 17:20:12 ocv kernel:  =======================
Jul 18 17:20:12 ocv kernel: Code: 75 23 bb 90 ff ff ff f6 05 00 44 50 f9 01 0f 84 6a 01 00 00 c7 04 24 e1 19 4f f9 e8 a0 35 c5 c6 e9 59 01 00 00 8b 46 24 8b 40 1c <83> b8 94 00 00 00 03 0f 84 28 ff ff ff e8 86 df cd c6 89 c7 8b
Jul 18 17:20:12 ocv kernel: EIP: [<f94d0a45>] smb_init+0x145/0x2a2 [cifs] SS:ESP 0068:f731fd94
Jul 18 17:20:12 ocv kernel: BUG: unable to handle kernel NULL pointer dereference at virtual address 000000c8
Jul 18 17:20:12 ocv kernel:  printing eip:
Jul 18 17:20:12 ocv kernel: f94d0a45
Jul 18 17:20:12 ocv kernel: *pde = 00000000
Jul 18 17:20:12 ocv kernel: Oops: 0000 [#9]
Jul 18 17:20:12 ocv kernel: SMP
Jul 18 17:20:12 ocv kernel: Modules linked in: i915 drm nfsd ipv6 vmnet(P) exportfs cifs lockd nfs_acl sunrpc button battery ac cbc blkcipher twofish twofish_common cryptoloop usbhid ff_memless ohci_hcd sr_mod nls_utf8 ext2 loop dm_mod fuse usb_storage
tg3 intel_agp ac97_bus soundcore snd_page_alloc shpchp agpgart ehci_hcd ide_cd cdrom pci_hotplug uhci_hcd usbcore ext3 mbcache jbd edd fan sg ata_piix libata piix thermal processor sd_mod scsi_mod ide_disk ide_core
Jul 18 17:20:12 ocv kernel: CPU:    1
Jul 18 17:20:12 ocv kernel: EIP:    0060:[<f94d0a45>]    Tainted: P       VLI
Jul 18 17:20:12 ocv kernel: EFLAGS: 00010202   (2.6.22.1-cv #3)
Jul 18 17:20:12 ocv kernel: EIP is at smb_init+0x145/0x2a2 [cifs]
Jul 18 17:20:12 ocv kernel: eax: 00000034   ebx: f3741340   ecx: dfed2e00   edx: 0000000f
Jul 18 17:20:12 ocv kernel: esi: dfed2e00   edi: f7015960   ebp: 00000032   esp: f28d5d94
Jul 18 17:20:12 ocv kernel: ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Jul 18 17:20:12 ocv kernel: Process fuser (pid: 12063, ti=f28d4000 task=dffe7ab0 task.ti=f28d4000)
Jul 18 17:20:12 ocv kernel: Stack: dfd28000 f8e0378a 0000000f 00000b80 00000011 e193c888 00008000 00000000
Jul 18 17:20:12 ocv kernel:        f3741340 fffffff4 f7015960 f757cfc0 f94d32be f28d5de4 f28d5de0 f7975140
Jul 18 17:20:12 ocv kernel:        dfed2e00 00000212 51e38bf5 00000000 00000000 f3741340 fffffff4 f7015960
Jul 18 17:20:12 ocv kernel: Call Trace:
Jul 18 17:20:12 ocv kernel:  [<f8e0378a>] journal_stop+0x270/0x27c [jbd]
Jul 18 17:20:12 ocv kernel:  [<f94d32be>] CIFSSMBQPathInfo+0x43/0x259 [cifs]
Jul 18 17:20:12 ocv kernel:  [<f94e4560>] cifs_get_inode_info+0xcf/0x829 [cifs]
Jul 18 17:20:12 ocv kernel:  [<c017526a>] __link_path_walk+0xaf2/0xc1a
Jul 18 17:20:12 ocv kernel:  [<f94df1a4>] build_path_from_dentry+0x81/0x13e [cifs]
Jul 18 17:20:12 ocv kernel:  [<f94e4e9b>] cifs_revalidate+0x1e1/0x339 [cifs]
Jul 18 17:20:12 ocv kernel:  [<f94e5001>] cifs_getattr+0xe/0x2b [cifs]
Jul 18 17:20:12 ocv kernel:  [<f94e4ff3>] cifs_getattr+0x0/0x2b [cifs]
Jul 18 17:20:12 ocv kernel:  [<c016fb78>] vfs_getattr+0x40/0x53
Jul 18 17:20:12 ocv kernel:  [<c016fc4f>] vfs_stat_fd+0x2e/0x40
Jul 18 17:20:12 ocv kernel:  [<c016fcee>] sys_stat64+0xf/0x23
Jul 18 17:20:12 ocv kernel:  [<c0104cb2>] sysenter_past_esp+0x5f/0x85
Jul 18 17:20:12 ocv kernel:  [<c02b0000>] wireless_send_event+0x280/0x2f7
Jul 18 17:20:12 ocv kernel:  =======================
Jul 18 17:20:12 ocv kernel: Code: 75 23 bb 90 ff ff ff f6 05 00 44 50 f9 01 0f 84 6a 01 00 00 c7 04 24 e1 19 4f f9 e8 a0 35 c5 c6 e9 59 01 00 00 8b 46 24 8b 40 1c <83> b8 94 00 00 00 03 0f 84 28 ff ff ff e8 86 df cd c6 89 c7 8b
Jul 18 17:20:12 ocv kernel: EIP: [<f94d0a45>] smb_init+0x145/0x2a2 [cifs] SS:ESP 0068:f28d5d94
Jul 18 17:20:12 ocv kernel: BUG: unable to handle kernel NULL pointer dereference at virtual address 000000c8
Jul 18 17:20:12 ocv kernel:  printing eip:
Jul 18 17:20:12 ocv kernel: f94d0a45
Jul 18 17:20:12 ocv kernel: *pde = 00000000
Jul 18 17:20:12 ocv kernel: Oops: 0000 [#10]
Jul 18 17:20:12 ocv kernel: SMP
Jul 18 17:20:12 ocv kernel: Modules linked in: i915 drm nfsd ipv6 vmnet(P) exportfs cifs lockd nfs_acl sunrpc button battery ac cbc blkcipher twofish twofish_common cryptoloop usbhid ff_memless ohci_hcd sr_mod nls_utf8 ext2 loop dm_mod fuse usb_storage
tg3 intel_agp ac97_bus soundcore snd_page_alloc shpchp agpgart ehci_hcd ide_cd cdrom pci_hotplug uhci_hcd usbcore ext3 mbcache jbd edd fan sg ata_piix libata piix thermal processor sd_mod scsi_mod ide_disk ide_core
Jul 18 17:20:12 ocv kernel: CPU:    0
Jul 18 17:20:12 ocv kernel: EIP:    0060:[<f94d0a45>]    Tainted: P       VLI
Jul 18 17:20:12 ocv kernel: EFLAGS: 00010202   (2.6.22.1-cv #3)
Jul 18 17:20:12 ocv kernel: EIP is at smb_init+0x145/0x2a2 [cifs]
Jul 18 17:20:12 ocv kernel: eax: 00000034   ebx: f7c478c0   ecx: dfed2e00   edx: 0000000f
Jul 18 17:20:12 ocv kernel: esi: dfed2e00   edi: f7015960   ebp: 00000032   esp: f6d5bd94
Jul 18 17:20:12 ocv kernel: ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Jul 18 17:20:12 ocv kernel: Process fuser (pid: 12071, ti=f6d5a000 task=f6c51570 task.ti=f6d5a000)
Jul 18 17:20:12 ocv kernel: Stack: dfd28000 f8e0378a 0000000f 00000b80 00000011 e193c3ec 00008000 00000000
Jul 18 17:20:12 ocv kernel:        f7c478c0 fffffff4 f7015960 f7e9f9c0 f94d32be f6d5bde4 f6d5bde0 f7975140
Jul 18 17:20:12 ocv kernel:        dfed2e00 00000213 51e38bf5 00000000 00000000 f7c478c0 fffffff4 f7015960
Jul 18 17:20:12 ocv kernel: Call Trace:
Jul 18 17:20:12 ocv kernel:  [<f8e0378a>] journal_stop+0x270/0x27c [jbd]
Jul 18 17:20:12 ocv kernel:  [<f94d32be>] CIFSSMBQPathInfo+0x43/0x259 [cifs]
Jul 18 17:20:12 ocv kernel:  [<f94e4560>] cifs_get_inode_info+0xcf/0x829 [cifs]
Jul 18 17:20:12 ocv kernel:  [<c017526a>] __link_path_walk+0xaf2/0xc1a
Jul 18 17:20:12 ocv kernel:  [<f94df1a4>] build_path_from_dentry+0x81/0x13e [cifs]
Jul 18 17:20:12 ocv kernel:  [<f94e4e9b>] cifs_revalidate+0x1e1/0x339 [cifs]
Jul 18 17:20:12 ocv kernel:  [<f94e5001>] cifs_getattr+0xe/0x2b [cifs]
Jul 18 17:20:12 ocv kernel:  [<f94e4ff3>] cifs_getattr+0x0/0x2b [cifs]
Jul 18 17:20:12 ocv kernel:  [<c016fb78>] vfs_getattr+0x40/0x53
Jul 18 17:20:12 ocv kernel:  [<c016fc4f>] vfs_stat_fd+0x2e/0x40
Jul 18 17:20:12 ocv kernel:  [<c016fcee>] sys_stat64+0xf/0x23
Jul 18 17:20:12 ocv kernel:  [<c0104cb2>] sysenter_past_esp+0x5f/0x85
Jul 18 17:20:12 ocv kernel:  [<c02b0000>] wireless_send_event+0x280/0x2f7
Jul 18 17:20:12 ocv kernel:  =======================
Jul 18 17:20:12 ocv kernel: Code: 75 23 bb 90 ff ff ff f6 05 00 44 50 f9 01 0f 84 6a 01 00 00 c7 04 24 e1 19 4f f9 e8 a0 35 c5 c6 e9 59 01 00 00 8b 46 24 8b 40 1c <83> b8 94 00 00 00 03 0f 84 28 ff ff ff e8 86 df cd c6 89 c7 8b
Jul 18 17:20:12 ocv kernel: EIP: [<f94d0a45>] smb_init+0x145/0x2a2 [cifs] SS:ESP 0068:f6d5bd94
Jul 18 17:20:12 ocv kernel: BUG: unable to handle kernel NULL pointer dereference at virtual address 000000c8
Jul 18 17:20:12 ocv kernel:  printing eip:
Jul 18 17:20:12 ocv kernel: f94d0a45
Jul 18 17:20:12 ocv kernel: *pde = 00000000
Jul 18 17:20:12 ocv kernel: Oops: 0000 [#11]
Jul 18 17:20:12 ocv kernel: SMP
Jul 18 17:20:12 ocv kernel: Modules linked in: i915 drm nfsd ipv6 vmnet(P) exportfs cifs lockd nfs_acl sunrpc button battery ac cbc blkcipher twofish twofish_common cryptoloop usbhid ff_memless ohci_hcd sr_mod nls_utf8 ext2 loop dm_mod fuse usb_storage
tg3 intel_agp ac97_bus soundcore snd_page_alloc shpchp agpgart ehci_hcd ide_cd cdrom pci_hotplug uhci_hcd usbcore ext3 mbcache jbd edd fan sg ata_piix libata piix thermal processor sd_mod scsi_mod ide_disk ide_core
Jul 18 17:20:12 ocv kernel: CPU:    1
Jul 18 17:20:12 ocv kernel: EIP:    0060:[<f94d0a45>]    Tainted: P       VLI
Jul 18 17:20:12 ocv kernel: EFLAGS: 00010202   (2.6.22.1-cv #3)
Jul 18 17:20:12 ocv kernel: EIP is at smb_init+0x145/0x2a2 [cifs]
Jul 18 17:20:12 ocv kernel: eax: 00000034   ebx: f1e0e840   ecx: dfed2e00   edx: 0000000f
Jul 18 17:20:12 ocv kernel: esi: dfed2e00   edi: f7015960   ebp: 00000032   esp: f25edd94
Jul 18 17:20:12 ocv kernel: ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Jul 18 17:20:12 ocv kernel: Process fuser (pid: 12074, ti=f25ec000 task=dfc9e030 task.ti=f25ec000)
Jul 18 17:20:12 ocv kernel: Stack: 0000000e 0000000b 0000000f c5f5b900 c02b42b8 00000517 00008000 00000000
Jul 18 17:20:12 ocv kernel:        f1e0e840 fffffff4 f7015960 f757ca00 f94d32be f25edde4 f25edde0 f7975140
Jul 18 17:20:12 ocv kernel:        dfed2e00 00000214 51e38bf5 00000000 00000000 f1e0e840 fffffff4 f7015960
Jul 18 17:20:12 ocv kernel: Call Trace:
Jul 18 17:20:12 ocv kernel:  [<c02b42b8>] do_page_fault+0x0/0x516
Jul 18 17:20:12 ocv kernel:  [<f94d32be>] CIFSSMBQPathInfo+0x43/0x259 [cifs]
Jul 18 17:20:12 ocv kernel:  [<f94e4560>] cifs_get_inode_info+0xcf/0x829 [cifs]
Jul 18 17:20:12 ocv kernel:  [<c017526a>] __link_path_walk+0xaf2/0xc1a
Jul 18 17:20:12 ocv kernel:  [<f94df1a4>] build_path_from_dentry+0x81/0x13e [cifs]
Jul 18 17:20:12 ocv kernel:  [<f94e4e9b>] cifs_revalidate+0x1e1/0x339 [cifs]
Jul 18 17:20:12 ocv kernel:  [<f94e5001>] cifs_getattr+0xe/0x2b [cifs]
Jul 18 17:20:12 ocv kernel:  [<f94e4ff3>] cifs_getattr+0x0/0x2b [cifs]
Jul 18 17:20:12 ocv kernel:  [<c016fb78>] vfs_getattr+0x40/0x53
Jul 18 17:20:12 ocv kernel:  [<c016fc4f>] vfs_stat_fd+0x2e/0x40
Jul 18 17:20:12 ocv kernel:  [<c016fcee>] sys_stat64+0xf/0x23
Jul 18 17:20:12 ocv kernel:  [<c0104cb2>] sysenter_past_esp+0x5f/0x85
Jul 18 17:20:12 ocv kernel:  [<c02b0000>] wireless_send_event+0x280/0x2f7
Jul 18 17:20:12 ocv kernel:  =======================
Jul 18 17:20:12 ocv kernel: Code: 75 23 bb 90 ff ff ff f6 05 00 44 50 f9 01 0f 84 6a 01 00 00 c7 04 24 e1 19 4f f9 e8 a0 35 c5 c6 e9 59 01 00 00 8b 46 24 8b 40 1c <83> b8 94 00 00 00 03 0f 84 28 ff ff ff e8 86 df cd c6 89 c7 8b
Jul 18 17:20:12 ocv kernel: EIP: [<f94d0a45>] smb_init+0x145/0x2a2 [cifs] SS:ESP 0068:f25edd94
Jul 18 17:20:12 ocv kernel: BUG: unable to handle kernel NULL pointer dereference at virtual address 000000c8
Jul 18 17:20:12 ocv kernel:  printing eip:
Jul 18 17:20:12 ocv kernel: f94d0a45
Jul 18 17:20:12 ocv kernel: *pde = 00000000
Jul 18 17:20:12 ocv kernel: Oops: 0000 [#12]
Jul 18 17:20:12 ocv kernel: SMP
Jul 18 17:20:12 ocv kernel: Modules linked in: i915 drm nfsd ipv6 vmnet(P) exportfs cifs lockd nfs_acl sunrpc button battery ac cbc blkcipher twofish twofish_common cryptoloop usbhid ff_memless ohci_hcd sr_mod nls_utf8 ext2 loop dm_mod fuse usb_storage
tg3 intel_agp ac97_bus soundcore snd_page_alloc shpchp agpgart ehci_hcd ide_cd cdrom pci_hotplug uhci_hcd usbcore ext3 mbcache jbd edd fan sg ata_piix libata piix thermal processor sd_mod scsi_mod ide_disk ide_core
Jul 18 17:20:12 ocv kernel: CPU:    1
Jul 18 17:20:12 ocv kernel: EIP:    0060:[<f94d0a45>]    Tainted: P       VLI
Jul 18 17:20:12 ocv kernel: EFLAGS: 00010202   (2.6.22.1-cv #3)
Jul 18 17:20:12 ocv kernel: EIP is at smb_init+0x145/0x2a2 [cifs]
Jul 18 17:20:12 ocv kernel: eax: 00000034   ebx: f7b29240   ecx: dfed2e00   edx: 0000000f
Jul 18 17:20:12 ocv kernel: esi: dfed2e00   edi: f7015960   ebp: 00000032   esp: f37abd94
Jul 18 17:20:12 ocv kernel: ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Jul 18 17:20:12 ocv kernel: Process fuser (pid: 12087, ti=f37aa000 task=f6ca3570 task.ti=f37aa000)
Jul 18 17:20:12 ocv kernel: Stack: dfd28000 f8e0378a 0000000f 00000b80 00000011 e193c888 00008000 00000000
Jul 18 17:20:12 ocv kernel:        f7b29240 fffffff4 f7015960 f714f720 f94d32be f37abde4 f37abde0 f7975140
Jul 18 17:20:12 ocv kernel:        dfed2e00 00000215 51e38bf5 00000000 00000000 f7b29240 fffffff4 f7015960
Jul 18 17:20:12 ocv kernel: Call Trace:
Jul 18 17:20:12 ocv kernel:  [<f8e0378a>] journal_stop+0x270/0x27c [jbd]
Jul 18 17:20:12 ocv kernel:  [<f94d32be>] CIFSSMBQPathInfo+0x43/0x259 [cifs]
Jul 18 17:20:12 ocv kernel:  [<f94e4560>] cifs_get_inode_info+0xcf/0x829 [cifs]
Jul 18 17:20:12 ocv kernel:  [<c017526a>] __link_path_walk+0xaf2/0xc1a
Jul 18 17:20:12 ocv kernel:  [<f94df1a4>] build_path_from_dentry+0x81/0x13e [cifs]
Jul 18 17:20:12 ocv kernel:  [<f94e4e9b>] cifs_revalidate+0x1e1/0x339 [cifs]
Jul 18 17:20:12 ocv kernel:  [<f94e5001>] cifs_getattr+0xe/0x2b [cifs]
Jul 18 17:20:12 ocv kernel:  [<f94e4ff3>] cifs_getattr+0x0/0x2b [cifs]
Jul 18 17:20:12 ocv kernel:  [<c016fb78>] vfs_getattr+0x40/0x53
Jul 18 17:20:12 ocv kernel:  [<c016fc4f>] vfs_stat_fd+0x2e/0x40
Jul 18 17:20:12 ocv kernel:  [<c016fcee>] sys_stat64+0xf/0x23
Jul 18 17:20:12 ocv kernel:  [<c0104cb2>] sysenter_past_esp+0x5f/0x85
Jul 18 17:20:12 ocv kernel:  [<c02b0000>] wireless_send_event+0x280/0x2f7
Jul 18 17:20:12 ocv kernel:  =======================
Jul 18 17:20:12 ocv kernel: Code: 75 23 bb 90 ff ff ff f6 05 00 44 50 f9 01 0f 84 6a 01 00 00 c7 04 24 e1 19 4f f9 e8 a0 35 c5 c6 e9 59 01 00 00 8b 46 24 8b 40 1c <83> b8 94 00 00 00 03 0f 84 28 ff ff ff e8 86 df cd c6 89 c7 8b
Jul 18 17:20:12 ocv kernel: EIP: [<f94d0a45>] smb_init+0x145/0x2a2 [cifs] SS:ESP 0068:f37abd94
Jul 18 17:20:12 ocv kernel: BUG: unable to handle kernel NULL pointer dereference at virtual address 000000c8
Jul 18 17:20:12 ocv kernel:  printing eip:
Jul 18 17:20:12 ocv kernel: f94d0a45
Jul 18 17:20:12 ocv kernel: *pde = 00000000
Jul 18 17:20:12 ocv kernel: Oops: 0000 [#13]
Jul 18 17:20:12 ocv kernel: SMP
Jul 18 17:20:12 ocv kernel: Modules linked in: i915 drm nfsd ipv6 vmnet(P) exportfs cifs lockd nfs_acl sunrpc button battery ac cbc blkcipher twofish twofish_common cryptoloop usbhid ff_memless ohci_hcd sr_mod nls_utf8 ext2 loop dm_mod fuse usb_storage
tg3 intel_agp ac97_bus soundcore snd_page_alloc shpchp agpgart ehci_hcd ide_cd cdrom pci_hotplug uhci_hcd usbcore ext3 mbcache jbd edd fan sg ata_piix libata piix thermal processor sd_mod scsi_mod ide_disk ide_core
Jul 18 17:20:12 ocv kernel: CPU:    1
Jul 18 17:20:12 ocv kernel: EIP:    0060:[<f94d0a45>]    Tainted: P       VLI
Jul 18 17:20:12 ocv kernel: EFLAGS: 00010202   (2.6.22.1-cv #3)
Jul 18 17:20:12 ocv kernel: EIP is at smb_init+0x145/0x2a2 [cifs]
Jul 18 17:20:12 ocv kernel: eax: 00000034   ebx: f7c470c0   ecx: dfed2e00   edx: 0000000f
Jul 18 17:20:12 ocv kernel: esi: dfed2e00   edi: f7015960   ebp: 00000032   esp: f6c6dd94
Jul 18 17:20:12 ocv kernel: ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Jul 18 17:20:12 ocv kernel: Process fuser (pid: 12102, ti=f6c6c000 task=f6c51ab0 task.ti=f6c6c000)
Jul 18 17:20:12 ocv kernel: Stack: dfd28000 f8e0378a 0000000f 00000b80 00000011 e193c84c 00008000 00000000
Jul 18 17:20:12 ocv kernel:        f7c470c0 fffffff4 f7015960 f7edeba0 f94d32be f6c6dde4 f6c6dde0 f7975140
Jul 18 17:20:12 ocv kernel:        dfed2e00 00000216 51e38bf5 00000000 00000000 f7c470c0 fffffff4 f7015960
Jul 18 17:20:12 ocv kernel: Call Trace:
Jul 18 17:20:12 ocv kernel:  [<f8e0378a>] journal_stop+0x270/0x27c [jbd]
Jul 18 17:20:12 ocv kernel:  [<f94d32be>] CIFSSMBQPathInfo+0x43/0x259 [cifs]
Jul 18 17:20:12 ocv kernel:  [<f94e4560>] cifs_get_inode_info+0xcf/0x829 [cifs]
Jul 18 17:20:12 ocv kernel:  [<c017526a>] __link_path_walk+0xaf2/0xc1a
Jul 18 17:20:12 ocv kernel:  [<f94df1a4>] build_path_from_dentry+0x81/0x13e [cifs]
Jul 18 17:20:12 ocv kernel:  [<f94e4e9b>] cifs_revalidate+0x1e1/0x339 [cifs]
Jul 18 17:20:12 ocv kernel:  [<f94e5001>] cifs_getattr+0xe/0x2b [cifs]
Jul 18 17:20:12 ocv kernel:  [<f94e4ff3>] cifs_getattr+0x0/0x2b [cifs]
Jul 18 17:20:12 ocv kernel:  [<c016fb78>] vfs_getattr+0x40/0x53
Jul 18 17:20:12 ocv kernel:  [<c016fc4f>] vfs_stat_fd+0x2e/0x40
Jul 18 17:20:12 ocv kernel:  [<c016fcee>] sys_stat64+0xf/0x23
Jul 18 17:20:12 ocv kernel:  [<c0104cb2>] sysenter_past_esp+0x5f/0x85
Jul 18 17:20:12 ocv kernel:  [<c02b0000>] wireless_send_event+0x280/0x2f7
Jul 18 17:20:12 ocv kernel:  =======================
Jul 18 17:20:12 ocv kernel: Code: 75 23 bb 90 ff ff ff f6 05 00 44 50 f9 01 0f 84 6a 01 00 00 c7 04 24 e1 19 4f f9 e8 a0 35 c5 c6 e9 59 01 00 00 8b 46 24 8b 40 1c <83> b8 94 00 00 00 03 0f 84 28 ff ff ff e8 86 df cd c6 89 c7 8b
Jul 18 17:20:12 ocv kernel: EIP: [<f94d0a45>] smb_init+0x145/0x2a2 [cifs] SS:ESP 0068:f6c6dd94
Jul 18 17:20:12 ocv kernel: BUG: unable to handle kernel NULL pointer dereference at virtual address 000000c8
Jul 18 17:20:12 ocv kernel:  printing eip:
Jul 18 17:20:12 ocv kernel: f94d0a45
Jul 18 17:20:12 ocv kernel: *pde = 00000000
Jul 18 17:20:12 ocv kernel: Oops: 0000 [#14]
Jul 18 17:20:12 ocv kernel: SMP
Jul 18 17:20:12 ocv kernel: Modules linked in: i915 drm nfsd ipv6 vmnet(P) exportfs cifs lockd nfs_acl sunrpc button battery ac cbc blkcipher twofish twofish_common cryptoloop usbhid ff_memless ohci_hcd sr_mod nls_utf8 ext2 loop dm_mod fuse usb_storage
tg3 intel_agp ac97_bus soundcore snd_page_alloc shpchp agpgart ehci_hcd ide_cd cdrom pci_hotplug uhci_hcd usbcore ext3 mbcache jbd edd fan sg ata_piix libata piix thermal processor sd_mod scsi_mod ide_disk ide_core
Jul 18 17:20:12 ocv kernel: CPU:    0
Jul 18 17:20:12 ocv kernel: EIP:    0060:[<f94d0a45>]    Tainted: P       VLI
Jul 18 17:20:12 ocv kernel: EFLAGS: 00010202   (2.6.22.1-cv #3)
Jul 18 17:20:12 ocv kernel: EIP is at smb_init+0x145/0x2a2 [cifs]
Jul 18 17:20:12 ocv kernel: eax: 00000034   ebx: f70b1140   ecx: dfed2e00   edx: 0000000f
Jul 18 17:20:12 ocv kernel: esi: dfed2e00   edi: f7015960   ebp: 00000032   esp: f7599d94
Jul 18 17:20:12 ocv kernel: ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Jul 18 17:20:12 ocv kernel: Process fuser (pid: 12112, ti=f7598000 task=dff98ab0 task.ti=f7598000)
Jul 18 17:20:12 ocv kernel: Stack: dfd28000 f8e0378a 0000000f 00000b80 00000011 e193c89c 00008000 00000000
Jul 18 17:20:12 ocv kernel:        f70b1140 fffffff4 f7015960 f7b784a0 f94d32be f7599de4 f7599de0 f7975140
Jul 18 17:20:12 ocv kernel:        dfed2e00 00000217 51e38bf5 00000000 00000000 f70b1140 fffffff4 f7015960
Jul 18 17:20:12 ocv kernel: Call Trace:
Jul 18 17:20:12 ocv kernel:  [<f8e0378a>] journal_stop+0x270/0x27c [jbd]
Jul 18 17:20:12 ocv kernel:  [<f94d32be>] CIFSSMBQPathInfo+0x43/0x259 [cifs]
Jul 18 17:20:12 ocv kernel:  [<f94e4560>] cifs_get_inode_info+0xcf/0x829 [cifs]
Jul 18 17:20:12 ocv kernel:  [<c017526a>] __link_path_walk+0xaf2/0xc1a
Jul 18 17:20:12 ocv kernel:  [<f94df1a4>] build_path_from_dentry+0x81/0x13e [cifs]
Jul 18 17:20:12 ocv kernel:  [<f94e4e9b>] cifs_revalidate+0x1e1/0x339 [cifs]
Jul 18 17:20:12 ocv kernel:  [<f94e5001>] cifs_getattr+0xe/0x2b [cifs]
Jul 18 17:20:12 ocv kernel:  [<f94e4ff3>] cifs_getattr+0x0/0x2b [cifs]
Jul 18 17:20:12 ocv kernel:  [<c016fb78>] vfs_getattr+0x40/0x53
Jul 18 17:20:12 ocv kernel:  [<c016fc4f>] vfs_stat_fd+0x2e/0x40
Jul 18 17:20:12 ocv kernel:  [<c016fcee>] sys_stat64+0xf/0x23
Jul 18 17:20:12 ocv kernel:  [<c0104cb2>] sysenter_past_esp+0x5f/0x85
Jul 18 17:20:12 ocv kernel:  [<c02b0000>] wireless_send_event+0x280/0x2f7
Jul 18 17:20:12 ocv kernel:  =======================
Jul 18 17:20:12 ocv kernel: Code: 75 23 bb 90 ff ff ff f6 05 00 44 50 f9 01 0f 84 6a 01 00 00 c7 04 24 e1 19 4f f9 e8 a0 35 c5 c6 e9 59 01 00 00 8b 46 24 8b 40 1c <83> b8 94 00 00 00 03 0f 84 28 ff ff ff e8 86 df cd c6 89 c7 8b
Jul 18 17:20:12 ocv kernel: EIP: [<f94d0a45>] smb_init+0x145/0x2a2 [cifs] SS:ESP 0068:f7599d94
Jul 18 17:20:12 ocv kernel: BUG: unable to handle kernel NULL pointer dereference at virtual address 000000c8
Jul 18 17:20:12 ocv kernel:  printing eip:
Jul 18 17:20:12 ocv kernel: f94d0a45
Jul 18 17:20:12 ocv kernel: *pde = 00000000
Jul 18 17:20:12 ocv kernel: Oops: 0000 [#15]
Jul 18 17:20:12 ocv kernel: SMP
Jul 18 17:20:12 ocv kernel: Modules linked in: i915 drm nfsd ipv6 vmnet(P) exportfs cifs lockd nfs_acl sunrpc button battery ac cbc blkcipher twofish twofish_common cryptoloop usbhid ff_memless ohci_hcd sr_mod nls_utf8 ext2 loop dm_mod fuse usb_storage
tg3 intel_agp ac97_bus soundcore snd_page_alloc shpchp agpgart ehci_hcd ide_cd cdrom pci_hotplug uhci_hcd usbcore ext3 mbcache jbd edd fan sg ata_piix libata piix thermal processor sd_mod scsi_mod ide_disk ide_core
Jul 18 17:20:12 ocv kernel: CPU:    1
Jul 18 17:20:12 ocv kernel: EIP:    0060:[<f94d0a45>]    Tainted: P       VLI
Jul 18 17:20:12 ocv kernel: EFLAGS: 00010202   (2.6.22.1-cv #3)
Jul 18 17:20:12 ocv kernel: EIP is at smb_init+0x145/0x2a2 [cifs]
Jul 18 17:20:12 ocv kernel: eax: 00000034   ebx: f7113640   ecx: dfed2e00   edx: 0000000f
Jul 18 17:20:12 ocv kernel: esi: dfed2e00   edi: f7015960   ebp: 00000032   esp: f7677d94
Jul 18 17:20:12 ocv kernel: ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Jul 18 17:20:12 ocv kernel: Process fuser (pid: 12118, ti=f7676000 task=f7af3ab0 task.ti=f7676000)
Jul 18 17:20:12 ocv kernel: Stack: dfd28000 f8e0378a 0000000f 00000b80 00000011 e193c84c 00008000 00000000
Jul 18 17:20:12 ocv kernel:        f7113640 fffffff4 f7015960 f76c1ac0 f94d32be f7677de4 f7677de0 f7975140
Jul 18 17:20:12 ocv kernel:        dfed2e00 00000218 51e38bf5 00000000 00000000 f7113640 fffffff4 f7015960
Jul 18 17:20:12 ocv kernel: Call Trace:
Jul 18 17:20:12 ocv kernel:  [<f8e0378a>] journal_stop+0x270/0x27c [jbd]
Jul 18 17:20:12 ocv kernel:  [<f94d32be>] CIFSSMBQPathInfo+0x43/0x259 [cifs]
Jul 18 17:20:12 ocv kernel:  [<f94e4560>] cifs_get_inode_info+0xcf/0x829 [cifs]
Jul 18 17:20:12 ocv kernel:  [<c017526a>] __link_path_walk+0xaf2/0xc1a
Jul 18 17:20:12 ocv kernel:  [<f94df1a4>] build_path_from_dentry+0x81/0x13e [cifs]
Jul 18 17:20:12 ocv kernel:  [<f94e4e9b>] cifs_revalidate+0x1e1/0x339 [cifs]
Jul 18 17:20:12 ocv kernel:  [<f94e5001>] cifs_getattr+0xe/0x2b [cifs]
Jul 18 17:20:12 ocv kernel:  [<f94e4ff3>] cifs_getattr+0x0/0x2b [cifs]
Jul 18 17:20:12 ocv kernel:  [<c016fb78>] vfs_getattr+0x40/0x53
Jul 18 17:20:12 ocv kernel:  [<c016fc4f>] vfs_stat_fd+0x2e/0x40
Jul 18 17:20:12 ocv kernel:  [<c016fcee>] sys_stat64+0xf/0x23
Jul 18 17:20:12 ocv kernel:  [<c0104cb2>] sysenter_past_esp+0x5f/0x85
Jul 18 17:20:12 ocv kernel:  [<c02b0000>] wireless_send_event+0x280/0x2f7
Jul 18 17:20:12 ocv kernel:  =======================
Jul 18 17:20:12 ocv kernel: Code: 75 23 bb 90 ff ff ff f6 05 00 44 50 f9 01 0f 84 6a 01 00 00 c7 04 24 e1 19 4f f9 e8 a0 35 c5 c6 e9 59 01 00 00 8b 46 24 8b 40 1c <83> b8 94 00 00 00 03 0f 84 28 ff ff ff e8 86 df cd c6 89 c7 8b
Jul 18 17:20:12 ocv kernel: EIP: [<f94d0a45>] smb_init+0x145/0x2a2 [cifs] SS:ESP 0068:f7677d94

