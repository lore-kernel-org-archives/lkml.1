Return-Path: <linux-kernel-owner+w=401wt.eu-S1758319AbYDCNZq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758319AbYDCNZq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 09:25:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757496AbYDCNZc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 09:25:32 -0400
Received: from styx.suse.cz ([82.119.242.94]:38146 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759439AbYDCNZa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 09:25:30 -0400
Date: Thu, 3 Apr 2008 15:25:27 +0200
From: Jan Kara <jack@suse.cz>
To: linux-kernel@vger.kernel.org
Cc: Lubos Lunak <l.lunak@suse.cz>
Subject: Oops while reading /proc/ioports or /proc/iomem
Message-ID: <20080403132527.GB25980@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

  a friend of mine got the following oops during installation... Seems like
something tampered with resource lists while we were reading them.

									Honza

----- Forwarded message from Lubos Lunak <l.lunak@suse.cz> -----

From: Lubos Lunak <l.lunak@suse.cz>
To: jack@suse.cz
Subject: 11.0a3 crash

eth0: no IPv6 routers present
BUG: unable to handle kernel paging request at f938ddbc
IP: [<c01e0d58>] strnlen+0x9/0x19
*pde = 36b24067 *pte = 00000000 
Oops: 0000 [#1] SMP 
last sysfs file: /sys/devices/platform/pcspkr/modalias
Modules linked in: parport_pc parport squashfs ipv6 e1000e usb_storage uhci_hcd usbhid hid ff_memless ehci_hcd usbcore ata_piix pata_acpi libata arc4 ecb crypto_blkcipher loop nfs nfs_acl lockd sunrpc nls_iso8859_1 nls_cp437 af_packet nvram edd sg st sd_mod sr_mod scsi_mod ide_disk ide_cd_mod cdrom ide_core [last unloaded: parport]

Pid: 3350, comm: y2base Tainted: G        N (2.6.25-rc5-git3-6-default #1)
EIP: 0060:[<c01e0d58>] EFLAGS: 00010297 CPU: 0
EIP is at strnlen+0x9/0x19
EAX: f938ddbc EBX: f7d6c02e ECX: f938ddbc EDX: fffffffe
ESI: f7c15efc EDI: f938ddbc EBP: f7c15e84 ESP: f7c15e84
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process y2base (pid: 3350, ti=f7c14000 task=f7ccc020 task.ti=f7c14000)
Stack: f7c15eb8 c01e03e7 c0379605 00000fde f7d6c022 00000010 f7d6d000 00000000 
       ffffffff ffffffff f7d6c022 f7a94e00 f7a94e00 f7c15ecc c018dab5 f7c15edc 
       00000000 f7a4bde0 f7c15f0c c0129a49 f7a94e00 c03795f1 00000000 c037f049 
Call Trace:
 [<c01e03e7>] vsnprintf+0x286/0x41f
 [<c018dab5>] seq_printf+0x25/0x45
 [<c0129a49>] r_show+0x5d/0x67
 [<c018df1d>] seq_read+0x195/0x25f
 [<c01a666f>] proc_reg_read+0x5a/0x6e
 [<c0177d8f>] vfs_read+0x89/0x133
 [<c0177ed2>] sys_read+0x3b/0x60
 [<c0105b62>] syscall_call+0x7/0xb
 [<b7a8a771>] 0xb7a8a771
 =======================
Code: 05 bf 01 00 00 00 4f 89 f8 5f 5d c3 55 85 c9 89 e5 57 89 c7 89 d0 74 05 f2 ae 75 01 4f 89 f8 5f 5d c3 55 89 c1 89 e5 89 c8 eb 06 <80> 38 00 74 07 40 4a 83 fa ff 75 f4 29 c8 5d c3 55 89 e5 57 56 
EIP: [<c01e0d58>] strnlen+0x9/0x19 SS:ESP 0068:f7c15e84
---[ end trace ae86811bcda28245 ]---
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.


----- End forwarded message -----
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
