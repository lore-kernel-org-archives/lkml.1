Return-Path: <linux-kernel-owner+w=401wt.eu-S1753938AbYGWM7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938AbYGWM7g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 08:59:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751840AbYGWM72
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 08:59:28 -0400
Received: from [85.204.20.254] ([85.204.20.254]:34656 "EHLO megainternet.ro"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751223AbYGWM71 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 08:59:27 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Jul 2008 08:59:27 EDT
Subject: kernel oops
From: Andrei Popa <andrei.popa@i-neo.ro>
Reply-To: andrei.popa@i-neo.ro
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: INEOSOFT
Date: Wed, 23 Jul 2008 15:52:36 +0300
Message-Id: <1216817556.4415.29.camel@ierdnac>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello,

I installed gnokii-0.6.22-r2 and gave the command "gnokii --identify"
and the kernel oopsed:

BUG: unable to handle kernel NULL pointer dereference at 00000458
IP: [<c0444b52>] mutex_unlock+0x0/0xb
*pde = 00000000
Oops: 0002 [#1] PREEMPT SMP

Pid: 19043, comm: gnokii Not tainted (2.6.26-ineo7 #2)
EIP: 0060:[<c0444b52>] EFLAGS: 00010246 CPU: 0
EIP is at mutex_unlock+0x0/0xb
EAX: 00000458 EBX: 00000000 ECX: df90a000 EDX: dc722100
ESI: df90a000 EDI: 00000458 EBP: 00000100 ESP: dc736e54
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process gnokii (pid: 19043, ti=dc736000 task=dfb3c6c0 task.ti=dc736000)
Stack: c03830ae 00000000 dc736e84 00000000 ffffffea ffffffed c0383062
dc722100
       00000100 c023cbfd 0902e0ff 0a600000 df90a000 00000000 df857544
dc713240
       00000000 c023ca9e c016951c dc722100 00000000 dc722100 dc713240
00000000
Call Trace:
 [<c03830ae>] acm_tty_open+0x4c/0x214
 [<c0383062>] acm_tty_open+0x0/0x214
 [<c023cbfd>] tty_open+0x15f/0x2a6
 [<c023ca9e>] tty_open+0x0/0x2a6
 [<c016951c>] chrdev_open+0x98/0x149
 [<c0169484>] chrdev_open+0x0/0x149
 [<c0165dde>] __dentry_open+0xfd/0x222
 [<c0165f96>] nameidata_to_filp+0x2e/0x53
 [<c016f80b>] do_filp_open+0x1bb/0x64f
 [<c016610e>] get_unused_fd_flags+0xb3/0xe3
 [<c016d383>] do_getname+0x4b/0x82
 [<c0166239>] do_sys_open+0x50/0xdd
 [<c01662f2>] sys_open+0x2c/0x3c
 [<c0102eb1>] sysenter_past_esp+0x6a/0x91
 [<c0440000>] init_chipset_sis5513+0x1b2/0x1c5
 =======================
Code: 44 24 38 ec 2a 13 c0 e8 06 ff ff ff 8b 5c 24 48 8b 74 24 4c 8b 7c
24 50 8b 6c 24 54 83 c4 58 c3 f0 ff 08 79 05 e8 9e 00 00 00 c3 <f0> ff
00 7f 05 e8 01 00 00 00 c3 83 ec 08 89 74 24 04 8d 70 04
EIP: [<c0444b52>] mutex_unlock+0x0/0xb SS:ESP 0068:dc736e54
---[ end trace 2723488af998d371 ]---
Nms ~ #                                  


