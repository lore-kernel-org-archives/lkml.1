Return-Path: <linux-kernel-owner+w=401wt.eu-S1031630AbXEAJl5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031630AbXEAJl5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 05:41:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031633AbXEAJl5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 05:41:57 -0400
Received: from 85-218-34-145.dclient.lsne.ch ([85.218.34.145]:36340 "EHLO vdr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1031630AbXEAJlz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 05:41:55 -0400
Date: Tue, 1 May 2007 11:41:53 +0200
From: Gregoire Favre <Gregoire.Favre@gmail.com>
To: Jon Burgess <jburgess777@googlemail.com>
Cc: linux-dvb@linuxtv.org, v4l-dvb-maintainer@linuxtv.org,
       Markus Rechberger <mrechberger@gmail.com>, linux-kernel@vger.kernel.org,
       Lee Revell <rlrevell@joe-job.com>
Subject: Re: [PATCH] Re: More than 2Gb problem (dvb related) ?
Message-ID: <20070501094153.GC6895@gmail.com>
References: <20070427111047.GB10284@gmail.com> <d9def9db0704271346i1556c59dgad222d5de7d919f6@mail.gmail.com> <1177711220.26292.20.camel@localhost.localdomain> <75b66ecd0704271506x595dfb6bqe0ef4fd153818501@mail.gmail.com> <1177780652.7152.14.camel@localhost.localdomain> <1177791277.5170.11.camel@localhost.localdomain> <20070430165232.GA6754@gmail.com> <1177956316.4752.13.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1177956316.4752.13.camel@localhost.localdomain>
X-Operating-System: Linux 2.6.21
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello again,

just forgot this :

ksymoops 2.4.11 on x86_64 2.6.21.  Options used
     -V (default)
     -k /proc/ksyms (default)
     -l /proc/modules (default)
     -o /lib/modules/2.6.21/ (default)
     -m /usr/src/linux/System.map (default)

Warning: You did not tell me where to find symbol information.  I will
assume that the log matches the kernel and modules that are running
right now and I'll use the default options above for symbol resolution.
If the current kernel and/or modules do not match the log, you can get
more accurate output by telling me the kernel version and where to find
map, modules, ksyms etc.  ksymoops -h explains the options.

Error (regular_file): read_ksyms stat /proc/ksyms failed
No modules in ksyms, skipping objects
No ksyms, skipping lsmod
SGI XFS with large block/inode numbers, no debug enabled
ehci_hcd 0000:00:1a.7: debug port 1
ehci_hcd 0000:00:1d.7: debug port 1
kernel BUG at mm/slab.c:2736!
CPU 1 
Pid: 9445, comm: cx88[0] dvb Tainted: P       2.6.21 #1
RIP: 0010:[<ffffffff8025e44e>]  [<ffffffff8025e44e>] cache_alloc_refill+0x1de/0x530
Using defaults from ksymoops -t elf64-x86-64 -a i386:x86-64
RSP: 0000:ffff81010ff31d30  EFLAGS: 00010002
RAX: 0000000000000000 RBX: 000000000000003c RCX: 0000000000000000
RDX: ffff81017fc6e400 RSI: 0000000000000004 RDI: ffff81017fc02180
RBP: ffff81017fc6e400 R08: 00000000ffffffff R09: 0000000000000004
R10: 0000000000000020 R11: 0000000000000001 R12: ffff81017fc02140
R13: ffff81017fc002c0 R14: 0000000000000000 R15: ffff81017fc13000
FS:  0000000000000000(0000) GS:ffff81017fc36540(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 00007fff05c58de8 CR3: 0000000129142000 CR4: 00000000000006e0
Stack:  0000000000000000 ffffffff805ea9b0 ffff81017fc02180 ffff810000000004
 ffffc2000067bfff 0000000000000286 0000000000000030 ffff81015fb4cf80
 0000000000006000 0000000000000004 ffff81017d4e90e0 ffffffff802bfaf3
Call Trace:
 [<ffffffff802bfaf3>] __kmalloc+0x63/0x70
 [<ffffffff802b80be>] __vmalloc_area_node+0x6e/0x160
 [<ffffffff887fc7c0>] :video_buf:videobuf_dma_init_kernel+0x50/0xd0
 [<ffffffff887fcc8e>] :video_buf:videobuf_iolock+0x7e/0x100
 [<ffffffff8883bfe4>] :cx8802:cx8802_buf_prepare+0xb4/0x120
 [<ffffffff887fc034>] :video_buf:videobuf_read_start+0xb4/0x150
 [<ffffffff888023e6>] :video_buf_dvb:videobuf_dvb_thread+0x46/0x170
 [<ffffffff8029d6d0>] keventd_create_kthread+0x0/0x90
 [<ffffffff888023a0>] :video_buf_dvb:videobuf_dvb_thread+0x0/0x170
 [<ffffffff8029d6d0>] keventd_create_kthread+0x0/0x90
 [<ffffffff802334f9>] kthread+0xd9/0x120
 [<ffffffff802283bf>] schedule_tail+0x3f/0xb0
 [<ffffffff802600e8>] child_rip+0xa/0x12
 [<ffffffff8029d6d0>] keventd_create_kthread+0x0/0x90
 [<ffffffff80233420>] kthread+0x0/0x120
 [<ffffffff802600de>] child_rip+0x0/0x12
Code: 0f 0b eb fe f7 44 24 18 00 20 00 00 0f 85 af 02 00 00 83 3c 


>>RIP; ffffffff8025e44e <cache_alloc_refill+1de/530>   <=====

>>RDX; ffff81017fc6e400 <phys_startup_64+ffff81017fa6e300/ffffffff7fffff00>
>>RDI; ffff81017fc02180 <phys_startup_64+ffff81017fa02080/ffffffff7fffff00>
>>RBP; ffff81017fc6e400 <phys_startup_64+ffff81017fa6e300/ffffffff7fffff00>
>>R08; 00000000ffffffff <phys_startup_64+ffdffeff/ffffffff7fffff00>
>>R12; ffff81017fc02140 <phys_startup_64+ffff81017fa02040/ffffffff7fffff00>
>>R13; ffff81017fc002c0 <phys_startup_64+ffff81017fa001c0/ffffffff7fffff00>
>>R15; ffff81017fc13000 <phys_startup_64+ffff81017fa12f00/ffffffff7fffff00>

Trace; ffffffff802bfaf3 <__kmalloc+63/70>
Trace; ffffffff802b80be <__vmalloc_area_node+6e/160>
Trace; ffffffff887fc7c0 <_end+81646fc/7ef67f3c>
Trace; ffffffff887fcc8e <_end+8164bca/7ef67f3c>
Trace; ffffffff8883bfe4 <_end+81a3f20/7ef67f3c>
Trace; ffffffff887fc034 <_end+8163f70/7ef67f3c>
Trace; ffffffff888023e6 <_end+816a322/7ef67f3c>
Trace; ffffffff8029d6d0 <keventd_create_kthread+0/90>
Trace; ffffffff888023a0 <_end+816a2dc/7ef67f3c>
Trace; ffffffff8029d6d0 <keventd_create_kthread+0/90>
Trace; ffffffff802334f9 <kthread+d9/120>
Trace; ffffffff802283bf <schedule_tail+3f/b0>
Trace; ffffffff802600e8 <child_rip+a/12>
Trace; ffffffff8029d6d0 <keventd_create_kthread+0/90>
Trace; ffffffff80233420 <kthread+0/120>
Trace; ffffffff802600de <child_rip+0/12>

Code;  ffffffff8025e44e <cache_alloc_refill+1de/530>
0000000000000000 <_RIP>:
Code;  ffffffff8025e44e <cache_alloc_refill+1de/530>   <=====
   0:   0f 0b                     ud2a      <=====
Code;  ffffffff8025e450 <cache_alloc_refill+1e0/530>
   2:   eb fe                     jmp    2 <_RIP+0x2>
Code;  ffffffff8025e452 <cache_alloc_refill+1e2/530>
   4:   f7 44 24 18 00 20 00      testl  $0x2000,0x18(%rsp)
Code;  ffffffff8025e459 <cache_alloc_refill+1e9/530>
   b:   00 
Code;  ffffffff8025e45a <cache_alloc_refill+1ea/530>
   c:   0f 85 af 02 00 00         jne    2c1 <_RIP+0x2c1>
Code;  ffffffff8025e460 <cache_alloc_refill+1f0/530>
  12:   83 3c 00 00               cmpl   $0x0,(%rax,%rax,1)


1 warning and 1 error issued.  Results may not be reliable.
-- 
Grégoire FAVRE  http://gregoire.favre.googlepages.com  http://www.gnupg.org
               http://picasaweb.google.com/Gregoire.Favre
