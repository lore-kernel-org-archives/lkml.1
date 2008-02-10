Return-Path: <linux-kernel-owner+w=401wt.eu-S1757556AbYBJHzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757556AbYBJHzy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 02:55:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754594AbYBJHzp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 02:55:45 -0500
Received: from rv-out-0910.google.com ([209.85.198.184]:23128 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360AbYBJHzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 02:55:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=mDuUjFNYFPxZDOOOSCn9OblN9RAFZL2cPUY8WPWdN50JnGAwzlRgeUvxM12tZOw62ykO78BKj2VR49HJAjmkbPw40hqgYGbBWR3X5N+IyJ56RBpDRUC9GFzakpPpQr1EpG2uGLiuLUWt4wU4oZj4xR1Rv5Zv16E6VOs7+j0I9ZI=
Message-ID: <86802c440802092355l7393fe07gfbd021e9cef66181@mail.gmail.com>
Date: Sat, 9 Feb 2008 23:55:43 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Greg KH" <greg@kroah.com>
Subject: panic about sysfs with adm1026
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Calling initcall 0xffffffff80c4b575: sm_adm1026_init+0x0/0xe()
i2c-adapter i2c-1: : Unrecognized stepping 0x45. Defaulting to ADM1026.
general protection fault: 0000 [1] SMP
CPU 0
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.24-smp-09379-g0cf975e-dirty #34
RIP: 0010:[<ffffffff802d79ad>]  [<ffffffff802d79ad>] sysfs_add_file+0x16/0x81
RSP: 0000:ffff81040503dd50  EFLAGS: 00010286
RAX: 0000000000000000 RBX: fffe002e002d002c RCX: 00000000000048d9
RDX: 0000000000000002 RSI: fffe002e002d002c RDI: ffff810202c4fb90
RBP: 0000000000000000 R08: ffff810202c4fb90 R09: 0000000000000000
R10: 0000000000000002 R11: 0000000000000002 R12: 00000000fffffff4
R13: ffff810202c4fb90 R14: 000000000000000c R15: ffff810202c4fb90
FS:  0000000000000000(0000) GS:ffffffff80bde000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 00007fff94de3470 CR3: 0000000000201000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 1, threadinfo ffff81040503c000, task ffff810205040000)
Stack:  ffff810202c4fb90 0000000000000000 0000000000000000 0000000000000001
 ffff810202c4e000 ffffffff80b87850 0000000000000000 ffff810202c4e118
 ffffffff808e0cc0 ffffffff802d933c ffff81040503dd55 ffff810202c17878
Call Trace:
 [<ffffffff802d933c>] sysfs_create_group+0xa2/0x106
 [<ffffffff8069fbc2>] adm1026_detect+0x4b3/0x522
 [<ffffffff8069f70f>] adm1026_detect+0x0/0x522
 [<ffffffff80698bff>] i2c_probe_address+0xb9/0xfc
 [<ffffffff806997db>] i2c_probe+0x162/0x175
 [<ffffffff8069f70f>] adm1026_detect+0x0/0x522
 [<ffffffff8069910f>] i2c_register_driver+0x9a/0xea
 [<ffffffff80c276d2>] kernel_init+0x15d/0x2c9
 [<ffffffff8021fc68>] child_rip+0xa/0x12
 [<ffffffff80c27575>] kernel_init+0x0/0x2c9
 [<ffffffff8021fc5e>] child_rip+0x0/0x12


Code: c0 84 c0 74 0c 41 58 48 89 df 5b 5d e9 2a 07 00 00 5e 5b 5d c3
41 55 49 89 fd 41 54 41 bc f4 ff ff ff 55 53 48 89 f3 48 83 ec 28 <8b>
76 10 48 8b 3b 66 81 e6 ff 0f 66 81 ce 00 80 0f b7 f6 e8 fd
RIP  [<ffffffff802d79ad>] sysfs_add_file+0x16/0x81
 RSP <ffff81040503dd50>
---[ end trace b23a825db37d3043 ]---
