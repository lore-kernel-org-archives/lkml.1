Return-Path: <linux-kernel-owner+w=401wt.eu-S1754240AbYACN1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240AbYACN1X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 08:27:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754668AbYACNXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 08:23:53 -0500
Received: from mu-out-0910.google.com ([209.85.134.191]:31401 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754603AbYACNXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 08:23:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:x-enigmail-version:content-type:content-transfer-encoding;
        b=udldA7/yk0wZTYyaSYuCcs/1KlTHIR/HvcammgT1AL3k+hchATkuYBVTIzb/6jfQjojuTaxB10bxCZkCLFFa+ImtX7kH5DV4AXP8coaXjXh+6tLTCw83+hpdBxqNVAkvE5kFVqcewXTDJzBHjx8lhbIQWo2E3eQjf+vucvwRayk=
Message-ID: <477CE1E0.4010504@gmail.com>
Date: Thu, 03 Jan 2008 14:23:44 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Al Viro <viro@zeniv.linux.org.uk>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: isofs oops - d_splice_alias+0x1f (2.6.24-rc5-mm1)
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this happened, while playing with broken dvd.

ISO 9660 Extensions: Microsoft Joliet Level 3
ISO 9660 Extensions: RRIP_1991A
end_request: I/O error, dev sr0, sector 21760
Buffer I/O error on device sr0, logical block 5440
Buffer I/O error on device sr0, logical block 5441
Buffer I/O error on device sr0, logical block 5442
Buffer I/O error on device sr0, logical block 5443
Buffer I/O error on device sr0, logical block 5444
Buffer I/O error on device sr0, logical block 5445
Buffer I/O error on device sr0, logical block 5446
Buffer I/O error on device sr0, logical block 5447
Buffer I/O error on device sr0, logical block 5448
Buffer I/O error on device sr0, logical block 5449
end_request: I/O error, dev sr0, sector 1447344
end_request: I/O error, dev sr0, sector 1447344
end_request: I/O error, dev sr0, sector 21808
end_request: I/O error, dev sr0, sector 21812
end_request: I/O error, dev sr0, sector 21760
end_request: I/O error, dev sr0, sector 21760
end_request: I/O error, dev sr0, sector 21760
end_request: I/O error, dev sr0, sector 21764
end_request: I/O error, dev sr0, sector 21760
end_request: I/O error, dev sr0, sector 21764
end_request: I/O error, dev sr0, sector 21760
end_request: I/O error, dev sr0, sector 21764
end_request: I/O error, dev sr0, sector 21760
end_request: I/O error, dev sr0, sector 21764
end_request: I/O error, dev sr0, sector 21760
end_request: I/O error, dev sr0, sector 21764
end_request: I/O error, dev sr0, sector 21760
end_request: I/O error, dev sr0, sector 21764
end_request: I/O error, dev sr0, sector 21760
printk: 40 messages suppressed.
Buffer I/O error on device sr0, logical block 5440
Buffer I/O error on device sr0, logical block 5441
end_request: I/O error, dev sr0, sector 136
ISOFS: unable to read i-node block
Unable to handle kernel NULL pointer dereference at 00000000000000ad RIP:
 [<ffffffff802a679f>] d_splice_alias+0x1f/0x100
PGD 67f1a067 PUD 67e15067 PMD 0
Oops: 0000 [1] SMP
last sysfs file: /sys/devices/platform/coretemp.1/temp1_input
CPU 0
Modules linked in: isofs tun bitrev ipv6 arc4 ecb crypto_blkcipher cryptomgr cry
pto_algapi ath5k mac80211 cfg80211 rtc_cmos rtc_core rtc_lib crc32 floppy ehci_h
cd sr_mod cdrom
Pid: 3096, comm: nautilus Not tainted 2.6.24-rc5-mm1_64 #354
RIP: 0010:[<ffffffff802a679f>]  [<ffffffff802a679f>] d_splice_alias+0x1f/0x100
RSP: 0000:ffff810061543b08  EFLAGS: 00010282
RAX: 00000000ffffffff RBX: fffffffffffffffb RCX: ffffffff880d3454
RDX: ffff810048542750 RSI: ffff81005e114e10 RDI: fffffffffffffffb
RBP: ffff810061543b28 R08: 0000000000000049 R09: 8000000000000000
R10: 0000000000000000 R11: 0000000000000001 R12: ffff81005e114e10
R13: ffff81005e2b11c0 R14: 0000000000000003 R15: 000000000000013c
FS:  0000000042123950(0063) GS:ffffffff80650000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000000000ad CR3: 0000000067d2f000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process nautilus (pid: 3096, threadinfo ffff810061542000, task ffff810048542750)
Stack:  ffff81007c0799c0 fffffffffffffffb ffff81007c0799c0 ffff81005e2b11c0
 ffff810061543bd8 ffffffff880d2395 ffffffff802a565b ffff81005e114e10
 ffff81005e2ec030 ffff8100638a3000 ffffe200015c63a8 0000000000000022
Call Trace:
 [<ffffffff880d2395>] :isofs:isofs_lookup+0x395/0x4a0
 [<ffffffff802a565b>] d_alloc+0x2b/0x1d0
 [<ffffffff8029a97c>] do_lookup+0x1ac/0x200
 [<ffffffff8029c747>] __link_path_walk+0x827/0xd10
 [<ffffffff8029cc93>] link_path_walk+0x63/0xe0
 [<ffffffff8028469f>] free_pages_and_swap_cache+0x9f/0xd0
 [<ffffffff8027d7f5>] unmap_region+0x135/0x150
 [<ffffffff8028ea65>] kmem_cache_free+0x15/0xa0
 [<ffffffff8026f686>] __pagevec_free+0x26/0x30
 [<ffffffff8029cd2c>] path_walk+0x1c/0x20
 [<ffffffff8029cf53>] do_path_lookup+0x83/0x1b0
 [<ffffffff8029dc2c>] __user_walk_fd+0x4c/0x80
 [<ffffffff80295b5b>] vfs_lstat_fd+0x2b/0x70
 [<ffffffff8028469f>] free_pages_and_swap_cache+0x9f/0xd0
 [<ffffffff8027d7f5>] unmap_region+0x135/0x150
 [<ffffffff8028ea65>] kmem_cache_free+0x15/0xa0
 [<ffffffff80295df7>] sys_newlstat+0x27/0x50
 [<ffffffff802521f9>] up_write+0x9/0x10
 [<ffffffff8027e755>] sys_munmap+0x55/0x70
 [<ffffffff8020ba4e>] system_call+0x7e/0x83


Code: 0f b7 87 b2 00 00 00 25 00 f0 00 00 3d 00 40 00 00 74 27 48
RIP  [<ffffffff802a679f>] d_splice_alias+0x1f/0x100
 RSP <ffff810061543b08>
CR2: 00000000000000ad

regards,
-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
