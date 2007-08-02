Return-Path: <linux-kernel-owner+w=401wt.eu-S1760500AbXHBTvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760500AbXHBTvX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 15:51:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758667AbXHBTu4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 15:50:56 -0400
Received: from rsva.tech.tigrisnet.net ([69.20.9.156]:41996 "EHLO
	rsva.tech.tigrisnet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757671AbXHBTuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 15:50:54 -0400
X-Greylist: delayed 1941 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Aug 2007 15:50:54 EDT
Message-ID: <46B22E08.80102@mansey.com>
Date: Thu, 02 Aug 2007 12:18:32 -0700
From: Jon Mansey <jon@mansey.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: unionfs and snmpd kernle bug report
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

kernel BUG at
/home/user/linux-modules-extra-2.6-2.6.18/debian/build/build_i386_none_686-bigmem_unionfs/build/commonfops.c:189! 

invalid opcode: 0000 [#1]
SMP
Modules linked in: ipv6 reiserfs dm_snapshot dm_mirror dm_mod i2c_i801
psmouse shpchp i2c_core e7xxx_edac pci_hotplug intel_rng evdev serio_raw
edac_mc sg pcspkr rtc squashfs loop unionfs ext2 mbcache sd_mod
usb_storage piix aic7xxx scsi_transport_spi e1000 scsi_mod e100 mii
generic ide_core uhci_hcd usbcore thermal processor fan
CPU:    0
EIP:    0060:[<f89795fc>]    Not tainted VLI
EFLAGS: 00210202   ( 2.6.18-4-686-bigmem #1)
EIP is at unionfs_file_revalidate+0x88/0x892 [unionfs]
eax: ea9aeaa0   ebx: dfd849c0   ecx: 00000002   edx: 00000001
esi: 00000001   edi: ffffffff   ebp: f7db8000   esp: f7db9f48
ds: 007b   es: 007b   ss: 0068
Process snmpd (pid: 2470, ti=f7db8000 task=dfb32000 task.ti=f7db8000)
Stack: 00000001 dfd849c0 00000000 dfd6d800 f7e00198 00000002 c014ca8c
f7dda754
       dfbebc4c dff43ae0 00000002 dfbebb20 c0124d63 dfd849c0 dff89c80
ffffffff
       f7db8000 f897a1b9 dff89c80 bfc6df34 dfd849c0 dff89c80 ffffffff
f7db8000
Call Trace:
[<c014ca8c>] unmap_region+0xe4/0xf3
[<c0124d63>] do_gettimeofday+0x31/0xce
[<f897a1b9>] unionfs_flush+0x16/0xd7 [unionfs]
[<c0157be3>] filp_close+0x2f/0x54
[<c0102c77>] syscall_call+0x7/0xb
Code: 0f 84 7f 07 00 00 8b 5c 24 0c 8b 74 24 10 8b 83 60 01 00 00 8b 5c
24 04 8b 48 04 8b 46 54 8b 50 24 8b 43 78 39 d1 8b 70 08 7e 08 <0f> 0b
bd 00 3e c5 97 f8 8b 44 24 10 f6 40 04 10 0f 84 4f 07 00
EIP: [<f89795fc>] unionfs_file_revalidate+0x88/0x892 [unionfs] SS:ESP
0068:f7db9f48

