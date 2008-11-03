Return-Path: <linux-kernel-owner+w=401wt.eu-S1753552AbYKCSac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552AbYKCSac (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 13:30:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752137AbYKCSaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 13:30:23 -0500
Received: from filter2.host.bg ([87.120.40.156]:39511 "EHLO filter2.host.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752095AbYKCSaW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 13:30:22 -0500
Message-ID: <490F433A.8030408@saturnosoft.biz>
Date: Mon, 03 Nov 2008 20:30:18 +0200
From: Todor Gyumyushev <todor@saturnosoft.biz>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: bug report
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


trying to sleep the machine to ram

BUG: unable to handle kernel NULL pointer dereference at 0000000000000020
IP: [<ffffffff802db2ba>] journal_invalidatepage+0x5a/0x32b
PGD 587fe067 PUD 5875e067 PMD 0
Oops: 0000 [1] PREEMPT SMP
CPU 0
Modules linked in: hci_usb rfcomm l2cap bluetooth vboxdrv i915 drm fan 
ac batter
y loop arc4 ecb crypto_blkcipher cryptomgr snd_hda_intel sg snd_pcm 
ath5k snd_ti
mer mac80211 snd usblp sr_mod soundcore evdev ohci1394 thermal led_class 
intel_a
gp processor snd_page_alloc ieee1394 cdrom uhci_hcd ehci_hcd sky2 
thermal_sys cf
g80211 button
Pid: 983, comm: kio_trash Not tainted 2.6.27.4 #4
RIP: 0010:[<ffffffff802db2ba>]  [<ffffffff802db2ba>] 
journal_invalidatepage+0x5a
/0x32b
RSP: 0018:ffff88006eb89d28  EFLAGS: 00010213
RAX: 0000000000001000 RBX: 0000000000000000 RCX: ffff88000062b818
RDX: 0000000000000002 RSI: ffff88000062b268 RDI: ffff880001001150
RBP: 00000000000005ab R08: 0000000000000000 R09: 000000000000000e
R10: 00000000000005aa R11: ffffffff802ce2c6 R12: 0000000000000001
R13: 0000000000000009 R14: ffff88007cd94400 R15: ffff88007cd94554
FS:  00007fa9f5b3b6f0(0000) GS:ffffffff8056b5c0(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000020 CR3: 000000004374b000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process kio_trash (pid: 983, threadinfo ffff88006eb88000, task 
ffff88007da86660)
Stack:  0000000000000005 0000000000000000 ffffe200012361c0 0000000000000000
 0000100000000001 ffff88007cd94424 ffff88000062b268 ffffe200012361c0
 00000000000005ab 00000000000005ab 0000000000000009 ffff88006eb89e30
Call Trace:
 [<ffffffff8026ad66>] ? truncate_complete_page+0x1c/0x45
 [<ffffffff8026ae58>] ? truncate_inode_pages_range+0xc9/0x326
 [<ffffffff802cfe73>] ? ext3_delete_inode+0x17/0xd0
 [<ffffffff802cfe5c>] ? ext3_delete_inode+0x0/0xd0
 [<ffffffff80297642>] ? generic_delete_inode+0x82/0x108
 [<ffffffff8028e314>] ? do_unlinkat+0xdd/0x136
 [<ffffffff8020bfdb>] ? system_call_fastpath+0x16/0x1b


Code: 48 8b 44 24 10 48 8d 57 24 48 8b 40 10 4c 8d bf 54 01 00 00 48 89 
44 24 30                                            48 89 c3 48 89 54 24 
28 31 c0 c7 44 24 20 01 00 00 00 <8b> 53 20 01 c2 89 c0 
89                                            54 24 24 48 39 44 24 08 48 
8b 53 08 48
RIP  [<ffffffff802db2ba>] journal_invalidatepage+0x5a/0x32b
 RSP <ffff88006eb89d28>
CR2: 0000000000000020
---[ end trace 308462b93443026c ]---

Regards,
Todor

