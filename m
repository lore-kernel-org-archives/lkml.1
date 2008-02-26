Return-Path: <linux-kernel-owner+w=401wt.eu-S1756767AbYBZNUU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756767AbYBZNUU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 08:20:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752381AbYBZNUG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 08:20:06 -0500
Received: from spiffy.freedom.ind.br ([201.35.65.91]:56480 "EHLO
	freedom.ind.br" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751708AbYBZNUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 08:20:04 -0500
To: linux-kernel@vger.kernel.org
Subject: oops when using git gc --auto
From: Otavio Salvador <otavio@debian.org>
Organization: O.S. Systems Ltda.
X-URL: http://www.debian.org/~otavio/
X-Attribution: O.S.
Date: Tue, 26 Feb 2008 10:22:24 -0300
Message-ID: <87tzjvhmy7.fsf@ossystems.com.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Today I got this oops, someone has an idea of what's going wrong?

Unable to handle kernel paging request at 0000020000000000 RIP: 
 [<ffffffff802735c3>] find_get_pages+0x3c/0x69
PGD 0 
Oops: 0000 [1] SMP 
CPU 3 
Modules linked in: sha256_generic aes_generic aes_x86_64 cbc blkcipher nvidia(P) rfcomm l2cap bluetooth ac battery ipv6 nfs lockd nfs_acl sunrpc bridge ext2 mbcache dm_crypt tun kvm_intel kvm loop snd_usb_audio snd_usb_lib snd_rawmidi snd_hda_intel e1000e i2c_i801 serio_raw snd_seq_device snd_pcm intel_agp button snd_timer pcspkr psmouse snd_hwdep snd snd_page_alloc soundcore evdev i2c_core xfs dm_mirror dm_snapshot dm_mod raid0 md_mod sg sr_mod cdrom sd_mod usbhid hid usb_storage pata_marvell floppy ahci ata_generic libata scsi_mod ehci_hcd uhci_hcd thermal processor fan
Pid: 15684, comm: git Tainted: P        2.6.24-1-amd64 #1
RIP: 0010:[<ffffffff802735c3>]  [<ffffffff802735c3>] find_get_pages+0x3c/0x69
RSP: 0018:ffff8100394dfd98  EFLAGS: 00010097
RAX: 0000000000000009 RBX: 000000000000000e RCX: 0000000000000009
RDX: 0000020000000000 RSI: 000000000000000a RDI: 0000000000000040
RBP: ffff810042964350 R08: 0000000000000040 R09: 000000000000000a
R10: ffff8100425a06c8 R11: 000000000000000a R12: 000000000000000e
R13: ffff8100394dfdf8 R14: ffff810042964350 R15: 0000000000000000
FS:  00002ae326df2190(0000) GS:ffff81007d7aeb40(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000020000000000 CR3: 00000000358f9000 CR4: 00000000000026e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process git (pid: 15684, threadinfo ffff8100394de000, task ffff8100359cd800)
Stack:  000000000000000d ffff8100394dfde8 000000000000000d 000000000000000e
 000000000000000e ffffffff802794d6 ffff8100014a7768 ffffffff80279b04
 0000000000000000 ffffffffffffffff 0000000000000000 0000000000000000
Call Trace:
 [<ffffffff802794d6>] pagevec_lookup+0x17/0x1e
 [<ffffffff80279b04>] truncate_inode_pages_range+0x108/0x2bd
 [<ffffffff802a9e3a>] generic_delete_inode+0xbf/0x127
 [<ffffffff802a1a4d>] do_unlinkat+0xd5/0x144
 [<ffffffff802989e2>] sys_write+0x45/0x6e
 [<ffffffff8020be2e>] system_call+0x7e/0x83


Code: 48 8b 02 25 00 40 02 00 48 3d 00 40 02 00 75 04 48 8b 52 10 
RIP  [<ffffffff802735c3>] find_get_pages+0x3c/0x69
 RSP <ffff8100394dfd98>
CR2: 0000020000000000
---[ end trace cb43a9f4488b815a ]---

-- 
        O T A V I O    S A L V A D O R
---------------------------------------------
 E-mail: otavio@debian.org      UIN: 5906116
 GNU/Linux User: 239058     GPG ID: 49A5F855
 Home Page: http://otavio.ossystems.com.br
---------------------------------------------
"Microsoft sells you Windows ... Linux gives
 you the whole house."
