Return-Path: <linux-kernel-owner+w=401wt.eu-S934082AbXF2R6s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934082AbXF2R6s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 13:58:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758964AbXF2R6l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 13:58:41 -0400
Received: from nz-out-0506.google.com ([64.233.162.229]:38991 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753416AbXF2R6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 13:58:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=a8P9zLBEHRWLiIOwbKM43s5yX96VY0By7+3f/R6Dwqv6HkeD9GJr5IXkFuO0pBT0Zz2znoabQC2z5ANHf3vLywNBT17WoanlqOxpjwKNjJMt5RqMuPqc0kkwFF65E8cVkn4U/RdZ059XnTPhmaSvbJ5qktxiOw7Co9f/QNtlIAM=
Message-ID: <8bf247760706291058p56b83177n3b3cb36049bb3802@mail.gmail.com>
Date: Fri, 29 Jun 2007 23:28:38 +0530
From: Ram <vshrirama@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: jffs2 problems
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
 I am using linux 2.6.19 and am seeing the following kernel crash.

 Im trying to test my jffs2 file system - The test creates 400 files
with a pattern and checks for data correctness.

  I dont know why jffs2_flush_wbuf() leads to a crash.

 Has anyone faced this problem before?.

 Can anyone help me on this.

Regards,
sriram

Kenel Dump:

jffs2_flush_wbuf(): Write failed with -5
Unable to handle kernel NULL pointer dereference at virtual address 00000000
pgd = c0dc8000
[00000000] *pgd=810eb031, *pte=00000000, *ppte=00000000
Internal error: Oops: 817 [#1]
Modules linked in: sensor_vs6524 vs6524lib video_buf
CPU: 0
PC is at __jffs2_flush_wbuf+0x7d8/0xc24
LR is at 0xc1a51000
pc : [<c012278c>]    lr : [<c1a51000>]    Tainted: P
sp : c15a9b60  ip : c15a9b10  fp : c15a9bc0
r10: c1fea9d8  r9 : 01840000  r8 : 00000000
r7 : c16cd728  r6 : c1ca6200  r5 : c16cd728  r4 : c0c27100
r3 : 00000000  r2 : 0000cf4b  r1 : c1a51000  r0 : 019c57f8
Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  Segment user
Control: C5387F
Table: 80DC8000  DAC: 00000015
Process cat (pid: 834, stack limit = 0xc15a8248)
Stack: (0xc15a9b60 to 0xc15aa000)
9b60: c15a9b88 c1a51000 c1bf981c 000000d0 019c57f8 c1a51000 c0c27100 c1fea768
9b80: fffffffb 00020000 00000008 00000000 00000010 c1ca6200 00000800 0000008b
9ba0: c1ca6200 019c5ff0 00000000 c1007788 c037a000 c15a9c10 c15a9bc4 c0123044
9bc0: c0121fc0 00000000 c028f248 c1ca631c 00000002 019c5ff0 00000044 00000002
9be0: c15a9c3c 00000010 019c5fac 00000000 019c5fac c1ca6200 c17054f8 c1007788
9c00: c1bf9964 c15a9c74 c15a9c18 c011ae7c c0122e30 019c5fac 00000000 c15a9c30
9c20: 000049fc 00000002 00000000 c0114508 c0123d4c 00000000 00000000 c17054f8
9c40: 00000044 c037a000 0000008b c15a9ca0 00000006 c17054f8 c1bf9964 c1ca6200
9c60: 00004000 00000000 c15a9ccc c15a9c78 c011b5e8 c011ad50 0000008b 00000003
9c80: 00000000 00000000 c0d8f000 0000008b 00001000 c037a000 0001a054 8bc2a978
9ca0: 8bc2a978 00000000 c17054f8 c1bf9990 c03191e0 00000000 00000000 00001000
9cc0: c15a9d18 c15a9cd0 c01166ec c011b3f0 00004000 00001000 c15a9ce4 c1ca6200
9ce0: c1bf9964 00000000 0000006e 0000006e 00001000 c02e93f8 00000000 00001000
9d00: c03191e0 00000000 00000000 c15a9db4 c15a9d1c c00631c4 c01165c8 00001000
9d20: becafca8 c1bf9990 c0231c68 c1bf9a34 c1c5dd40 00000001 c15a9eac 00000000
9d40: 00000000 c15a9ea4 485a9d54 00000001 00000000 c03191e0 00000000 c1c8e260
9d60: 0000006e 11e1a300 c15a9d98 c15a9d94 c15a9d7c c0044ecc c0044e30 c1bf9990
9d80: c15a9d98 00000000 c15a9db8 00004000 00000000 00006000 00000000 c15a9dfc
9da0: 00000000 c15a9e00 c15a9e58 c15a9dbc c0063bd0 c0062df0 00004000 00000000
9dc0: c15a9ef4 00002000 00000000 00006000 00000000 00004000 00000000 00000000
9de0: 00002000 c1bf9a34 c1c5dd40 c15a9ef4 c15a9ea4 c15a9eac 00000001 00002000
9e00: 00004000 00000000 c0057d60 22222222 22222222 22222222 22222222 22222222
9e20: c15a9eac c1bf9990 00004000 00000000 c15a9eac c1bf9990 00004000 00000000
9e40: c15a9ef4 c15a9ea4 c1bf99fc c15a9e98 c15a9e5c c0063c80 c0063658 c15a9ea4
9e60: 00002000 c1bf9a34 c1c5dd40 00000001 c15a9eac c15a9ef4 c15a9f78 c1c5dd40
9e80: c15a9ea4 c15a8000 0006cbc4 c15a9f50 c15a9ea0 c007f448 c0063c10 00004000
9ea0: 00000000 becafca8 00002000 c0068720 c15a9ebc 00000000 00000001 ffffffff
9ec0: c1c5dd40 00000000 00000000 00000000 00000000 c1c90580 00000000 00000000
9ee0: c15a9f44 c1c90580 c0053908 c15a9eec c15a9eec 00004000 00000000 c15a9f08
9f00: c00293f8 c002910c 00000000 00002000 c0dc8000 00000000 00000002 ffffffeb
9f20: 00000002 c1c90580 c15a9f44 c15a9f38 becafca8 c1c5dd40 c007f388 c15a8000
9f40: c15a9f78 c15a9f74 c15a9f54 c007f558 c007f394 c1c5dd60 c1c5dd40 c15a9f78
9f60: 00004000 00000000 c15a9fa4 c15a9f78 c007f684 c007f4a4 00004000 00000000
9f80: 00000000 00002000 00002000 becafca8 00000004 c0023ee4 00000000 c15a9fa8
9fa0: c0023d40 c007f644 00002000 00002000 00000001 becafca8 00002000 ffffc000
9fc0: 00002000 00002000 becafca8 00000001 00000003 00000000 0006cbc4 00000000
9fe0: 00000000 becafc7c 0000265c 401af510 60000010 00000001 616d6f00 78343270
Backtrace:
[<c0121fb4>] (__jffs2_flush_wbuf+0x0/0xc24) from [<c0123044>]
(jffs2_flash_writev+0x224/0x438)
[<c0122e24>] (jffs2_flash_writev+0x4/0x438) from [<c011ae7c>]
(jffs2_write_dnode+0x138/0x358)
[<c011ad44>] (jffs2_write_dnode+0x0/0x358) from [<c011b5e8>]
(jffs2_write_inode_range+0x204/0x37c)
[<c011b3e4>] (jffs2_write_inode_range+0x0/0x37c) from [<c01166ec>]
(jffs2_commit_write+0x130/0x254)
[<c01165bc>] (jffs2_commit_write+0x0/0x254) from [<c00631c4>]
(generic_file_buffered_write+0x3e4/0x5e4)
[<c0062de4>] (generic_file_buffered_write+0x4/0x5e4) from [<c0063bd0>]
(__generic_file_aio_write_nolock+0x584/0x5b4)
[<c006364c>] (__generic_file_aio_write_nolock+0x0/0x5b4) from
[<c0063c80>] (generic_file_aio_write+0x80/0xf4)
[<c0063c04>] (generic_file_aio_write+0x4/0xf4) from [<c007f448>]
(do_sync_write+0xc0/0x110)
[<c007f388>] (do_sync_write+0x0/0x110) from [<c007f558>] (vfs_write+0xc0/0x12c)
 r8 = C15A9F78  r7 = C15A8000  r6 = C007F388  r5 = C1C5DD40
 r4 = BECAFCA8
[<c007f498>] (vfs_write+0x0/0x12c) from [<c007f684>] (sys_write+0x4c/0x74)
 r8 = 00000000  r7 = 00004000  r6 = C15A9F78  r5 = C1C5DD40
 r4 = C1C5DD60
[<c007f638>] (sys_write+0x0/0x74) from [<c0023d40>] (ret_fast_syscall+0x0/0x2c)
 r8 = C0023EE4  r7 = 00000004  r6 = BECAFCA8  r5 = 00002000
 r4 = 00002000
Code: e59f3430 e1520003 13520000 13a03000 (15833000)
 Segmentation fault
cmp: EOF on /home/user/myfilename1813
