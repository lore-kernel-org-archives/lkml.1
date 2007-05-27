Return-Path: <linux-kernel-owner+w=401wt.eu-S1760671AbXE0WSm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760671AbXE0WSm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 18:18:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758607AbXE0WSe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 18:18:34 -0400
Received: from smtp.cce.hp.com ([161.114.21.23]:48639 "EHLO
	ccerelrim02.cce.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758445AbXE0WSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 18:18:33 -0400
Message-ID: <465A03BD.1010802@gmail.com>
Date: Sun, 27 May 2007 18:18:37 -0400
From: Parag Warudkar <parag.warudkar@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Stefan Helbing <sth@wecltd.eu>
Cc: linux-kernel@vger.kernel.org, trond.myklebust@fys.uio.no
Subject: Re: Oops in kernel 2.6.21
References: <200705270855.l4R8t4rs020001@pop3mail.sitec.net>
In-Reply-To: <200705270855.l4R8t4rs020001@pop3mail.sitec.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-PMX-Version: 5.3.1.294258, Antispam-Engine: 2.5.1.298604, Antispam-Data: 2007.5.27.150241
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[ It's NFS - CCing Trond ]

Hi Stefan,

What was the last kernel that worked for you without giving this 
problem? Also is it possible for you to try the latest kernel 
(http://kernel.org/) to see if the problem is still reproducible?


Parag

Stefan Helbing wrote:
> Hello,
> 
> I'm really unsure if you can help me with this problem, so I choosed this address from oops-tracing.txt.
> I get an Oops in kernel 2.6.21 very often. One of the Oops logs is attached to this email.
> I believe (but I only believe - because until now the system is not doing more than this) that the Oops occurs during longer NFS transfers over a WAN connection.
> I took the source code from the current Debian unstable version.
> 
> Do you have a suggestion? More information necessary?
> Thank you very much!
> 
> Best regards
> Stefan Helbing
> 

> May 27 10:24:49 kassandra kernel: BUG: unable to handle kernel paging request at virtual address 00b00000
> May 27 10:24:49 kassandra kernel:  printing eip:
> May 27 10:24:49 kassandra kernel: c015d5ce
> May 27 10:24:49 kassandra kernel: *pde = 2aebf001
> May 27 10:24:49 kassandra kernel: *pte = 00000000
> May 27 10:24:49 kassandra kernel: Oops: 0000 [#1]
> May 27 10:24:49 kassandra kernel: SMP
> May 27 10:24:49 kassandra kernel: Modules linked in: ipt_REJECT ipt_LOG xt_limit xt_tcpudp iptable_filter ip_tables x_tables it87 hwmon_vid hwmon i2c_isa i2c_dev nfsd exportfs nfs lockd sunrpc i2c_i801 3c59x unix
> May 27 10:24:49 kassandra kernel: CPU:    0
> May 27 10:24:49 kassandra kernel: EIP:    0060:[__d_lookup+97/244]    Not tainted VLI
> May 27 10:24:49 kassandra kernel: EFLAGS: 00010206   (2.6.21-i386 #1)
> May 27 10:24:49 kassandra kernel: EIP is at __d_lookup+0x61/0xf4
> May 27 10:24:49 kassandra kernel: eax: 000126d5   ebx: 00003354   ecx: 00000011   edx: c36a6120
> May 27 10:24:49 kassandra kernel: esi: dde75d48   edi: cb71a194   ebp: 00b00000   esp: dde75cdc
> May 27 10:24:49 kassandra kernel: ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
> May 27 10:24:49 kassandra kernel: Process cp (pid: 5465, ti=dde74000 task=ec2a5070 task.ti=dde74000)
> May 27 10:24:49 kassandra kernel: Stack: 00000000 ffcaa7dc b93cff31 00000027 dde75d48 cb71a194 00003354 dde75d48
> May 27 10:24:49 kassandra kernel:        cb71a194 dde75f00 c015d54c ffcaa803 00000000 b93cff31 f8e5477a f8e60f35
> May 27 10:24:49 kassandra kernel:        00000000 00000001 cb71a194 0007b847 dde75f00 d8b52e9c dde75f30 00000000
> May 27 10:24:49 kassandra kernel: Call Trace:
> May 27 10:24:49 kassandra kernel:  [d_lookup+28/61] d_lookup+0x1c/0x3d
> May 27 10:24:49 kassandra kernel:  [pg0+950245242/1069429760] nfs_readdir_lookup+0xfc/0x2ca [nfs]
> May 27 10:24:49 kassandra kernel:  [pg0+950296373/1069429760] nfs3_decode_dirent+0xe0/0x190 [nfs]
> May 27 10:24:49 kassandra kernel:  [pg0+950241074/1069429760] nfs_do_filldir+0x70/0x187 [nfs]
> May 27 10:24:49 kassandra kernel:  [filldir64+0/234] filldir64+0x0/0xea
> May 27 10:24:49 kassandra kernel:  [pg0+950243017/1069429760] nfs_readdir+0x680/0x6d9 [nfs]
> May 27 10:24:49 kassandra kernel:  [do_lookup+69/157] do_lookup+0x45/0x9d
> May 27 10:24:49 kassandra kernel:  [filldir64+0/234] filldir64+0x0/0xea
> May 27 10:24:49 kassandra kernel:  [pg0+949935784/1069429760] rpcauth_lookup_credcache+0x85/0x1af [sunrpc]
> May 27 10:24:49 kassandra kernel:  [alloc_super+173/304] alloc_super+0xad/0x130
> May 27 10:24:49 kassandra kernel:  [pg0+950256250/1069429760] nfs_file_set_open_context+0x1f/0x3d [nfs]
> May 27 10:24:49 kassandra kernel:  [pg0+950256580/1069429760] nfs_open+0x5d/0x63 [nfs]
> May 27 10:24:49 kassandra kernel:  [copy_to_user+47/55] copy_to_user+0x2f/0x37
> May 27 10:24:49 kassandra kernel:  [cp_new_stat64+246/267] cp_new_stat64+0xf6/0x10b
> May 27 10:24:49 kassandra kernel:  [pg0+950296149/1069429760] nfs3_decode_dirent+0x0/0x190 [nfs]
> May 27 10:24:49 kassandra kernel:  [sys_fstat64+30/35] sys_fstat64+0x1e/0x23
> May 27 10:24:49 kassandra kernel:  [filldir64+0/234] filldir64+0x0/0xea
> May 27 10:24:49 kassandra kernel:  [vfs_readdir+71/106] vfs_readdir+0x47/0x6a
> May 27 10:24:49 kassandra kernel:  [sys_getdents64+103/174] sys_getdents64+0x67/0xae
> May 27 10:24:49 kassandra kernel:  [syscall_call+7/11] syscall_call+0x7/0xb
> May 27 10:24:49 kassandra kernel:  =======================
> May 27 10:24:49 kassandra kernel: Code: 01 c8 8b 0d 80 67 3b c0 89 c2 81 f2 01 00 37 9e d3 ea 31 d0 8b 15 84 67 3b c0 23 05 7c 67 3b c0 8b 2c 82 85 ed 0f 84 88 00 00 00 <8b> 45 00 0f 18 00 90 8b 4c 24 08 8d 5d f0 39 4b 1c 75 6a 8b 44
> May 27 10:24:49 kassandra kernel: EIP: [__d_lookup+97/244] __d_lookup+0x61/0xf4 SS:ESP 0068:dde75cdc

