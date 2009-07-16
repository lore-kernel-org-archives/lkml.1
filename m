Return-Path: <linux-kernel-owner+w=401wt.eu-S933521AbZGPWyj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933521AbZGPWyj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 18:54:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933471AbZGPWyi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 18:54:38 -0400
Received: from mail-pz0-f197.google.com ([209.85.222.197]:39256 "EHLO
	mail-pz0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933096AbZGPWyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 18:54:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=el/ALcOdRc0QDNylX2009AmWMIilKOe2tFGTOInG4WV0CIHO5qNxP/k4zHCDQTXw3s
         9x7UuZhHczn4XCZUxZXSDXpMdZuucj+nxERESWtbS1OBqrmM2ntQl4gBtws252wC8/bX
         2zVBnu/NL6arMXc2qh16GOFlW8VwjmfdTsTjs=
Message-ID: <4A5FB00E.3000605@gmail.com>
Date: Thu, 16 Jul 2009 15:56:14 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Spicebird/0.7.1 (X11; 2009031304)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: BUG kmalloc-1024: Poison overwritten
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is another new one
except on my imac,
steps to reproduce(not sure) simple shutdown
the machine and started her up again spit out this:

[    5.847283] 
=============================================================================
[    5.848004] BUG kmalloc-1024: Poison overwritten
[    5.848004] 
-----------------------------------------------------------------------------
[    5.848004]
[    5.848004] INFO: 0xf48d6180-0xf48d61c3. First byte 0x24 instead of 0x6b
[    5.848004] INFO: Allocated in alloc_fdtable+0x9f/0x123 age=48 cpu=0 
pid=1092
[    5.848004] INFO: Freed in free_fdtable_rcu+0x37/0x7c age=44 cpu=0 
pid=1098
[    5.848004] INFO: Slab 0xc1c7ea80 objects=15 used=7 fp=0xf48d6180 
flags=0x400040c3
[    5.848004] INFO: Object 0xf48d6180 @offset=8576 fp=0xf48d54f0
[    5.848004]
[    5.848004] Bytes b4 0xf48d6170:  74 8c 05 00 80 1a 06 00 1c c8 06 00 
20 a1 07 00 t........È...¡..
[    5.848004]   Object 0xf48d6180:  24 b8 08 00 2b 2c 0a 00 00 35 0c 00 
40 42 0f 00 $¸..+,...5..@B..
[    5.848004]   Object 0xf48d6190:  55 58 14 00 80 84 1e 00 15 16 05 00 
74 8c 05 00 UX..........t...
[    5.848004]   Object 0xf48d61a0:  80 1a 06 00 1c c8 06 00 20 a1 07 00 
24 b8 08 00 .....È...¡..$¸..
[    5.848004]   Object 0xf48d61b0:  2b 2c 0a 00 00 35 0c 00 40 42 0f 00 
55 58 14 00 +,...5..@B..UX..
[    5.848004]   Object 0xf48d61c0:  80 84 1e 00 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b ....kkkkkkkkkkkk
[    5.848004]   Object 0xf48d61d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.848004]   Object 0xf48d61e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.848004]   Object 0xf48d61f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.848004]   Object 0xf48d6200:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.848004]   Object 0xf48d6210:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.848004]   Object 0xf48d6220:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.848004]   Object 0xf48d6230:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.848004]   Object 0xf48d6240:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.848004]   Object 0xf48d6250:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.848004]   Object 0xf48d6260:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.848004]   Object 0xf48d6270:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.848004]   Object 0xf48d6280:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.848004]   Object 0xf48d6290:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.848004]   Object 0xf48d62a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.848004]   Object 0xf48d62b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.848004]   Object 0xf48d62c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.848004]   Object 0xf48d62d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.848004]   Object 0xf48d62e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.848004]   Object 0xf48d62f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.848004]   Object 0xf48d6300:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.848004]   Object 0xf48d6310:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.848004]   Object 0xf48d6320:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.848004]   Object 0xf48d6330:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.848004]   Object 0xf48d6340:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.848004]   Object 0xf48d6350:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.848004]   Object 0xf48d6360:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.848004]   Object 0xf48d6370:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.848004]   Object 0xf48d6380:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.848004]   Object 0xf48d6390:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.848004]   Object 0xf48d63a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.848004]   Object 0xf48d63b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.848004]   Object 0xf48d63c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.848004]   Object 0xf48d63d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.848004]   Object 0xf48d63e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.848004]   Object 0xf48d63f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.848004]   Object 0xf48d6400:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.848004]   Object 0xf48d6410:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.848004]   Object 0xf48d6420:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.848004]   Object 0xf48d6430:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.848004]   Object 0xf48d6440:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.848004]   Object 0xf48d6450:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.848004]   Object 0xf48d6460:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.848004]   Object 0xf48d6470:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.848004]   Object 0xf48d6480:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.848004]   Object 0xf48d6490:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.848004]   Object 0xf48d64a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.848004]   Object 0xf48d64b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.848004]   Object 0xf48d64c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.848004]   Object 0xf48d64d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.848004]   Object 0xf48d64e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.848004]   Object 0xf48d64f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.848004]   Object 0xf48d6500:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.848004]   Object 0xf48d6510:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.848004]   Object 0xf48d6520:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.848004]   Object 0xf48d6530:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.848004]   Object 0xf48d6540:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.848004]   Object 0xf48d6550:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.848004]   Object 0xf48d6560:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.848004]   Object 0xf48d6570:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b a5 kkkkkkkkkkkkkkk¥
[    5.848004]  Redzone 0xf48d6580:  bb bb bb 
bb                                     »»»»
[    5.848004]  Padding 0xf48d65a8:  5a 5a 5a 5a 5a 5a 5a 
5a                         ZZZZZZZZ
[    5.848004] Pid: 1023, comm: udevd Not tainted 
2.6.31-rc3-00040-g78d802d #2
[    5.848004] Call Trace:
[    5.848004]  [<c10a43e6>] print_trailer+0xe2/0xea
[    5.848004]  [<c10a447a>] check_bytes_and_report+0x8c/0xaf
[    5.848004]  [<c10a4572>] check_object+0xa5/0x190
[    5.848004]  [<c10a5a8f>] __slab_alloc+0x381/0x497
[    5.848004]  [<c10a5b09>] ? __slab_alloc+0x3fb/0x497
[    5.848004]  [<c10a6277>] __kmalloc_track_caller+0xc4/0x141
[    5.848004]  [<c128a186>] ? netlink_sendmsg+0x178/0x260
[    5.848004]  [<c128a186>] ? netlink_sendmsg+0x178/0x260
[    5.848004]  [<c12757ff>] __alloc_skb+0x49/0x108
[    5.848004]  [<c128a186>] netlink_sendmsg+0x178/0x260
[    5.848004]  [<c126f632>] sock_sendmsg+0xde/0xf9
[    5.848004]  [<c112e636>] ? avc_has_perm+0x3c/0x46
[    5.848004]  [<c1050f65>] ? autoremove_wake_function+0x0/0x2f
[    5.848004]  [<c112e636>] ? avc_has_perm+0x3c/0x46
[    5.848004]  [<c126ff1e>] ? move_addr_to_kernel+0x3e/0x43
[    5.848004]  [<c127681f>] ? verify_iovec+0x3e/0x6b
[    5.848004]  [<c126f796>] sys_sendmsg+0x149/0x196
[    5.848004]  [<c103645d>] ? enqueue_entity+0x14/0x285
[    5.848004]  [<c108354e>] ? find_get_page+0x1d/0x7a
[    5.848004]  [<c1083c70>] ? filemap_fault+0x6f/0x319
[    5.848004]  [<c1093d42>] ? __do_fault+0x334/0x360
[    5.848004]  [<c1095668>] ? handle_mm_fault+0x315/0x69c
[    5.848004]  [<c1270785>] sys_socketcall+0x15a/0x185
[    5.848004]  [<c10180c4>] sysenter_do_call+0x12/0x22
[    5.848004] FIX kmalloc-1024: Restoring 0xf48d6180-0xf48d61c3=0x6b
[    5.848004]
[    5.848004] FIX kmalloc-1024: Marking all objects used

unfortunately the machine is tainted i.g. nvidia and wl.

As for patching the kernel I use the imac91.patch
(found on alsa list for sound) and my set of patches that I created for 
SELinux
mainly grammar fixes.(unless capitols and periods can cause this
in a comment, I'm not sure).

Justin P. Mattock
