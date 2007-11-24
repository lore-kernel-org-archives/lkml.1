Return-Path: <linux-kernel-owner+w=401wt.eu-S1754801AbXKXNAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801AbXKXNAj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 08:00:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752893AbXKXNAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 08:00:32 -0500
Received: from [123.6.91.133] ([123.6.91.133]:59715 "EHLO
	wuhm-laptop.dev.hisome.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752662AbXKXNAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 08:00:31 -0500
X-Greylist: delayed 1542 seconds by postgrey-1.27 at vger.kernel.org; Sat, 24 Nov 2007 08:00:29 EST
Subject: HELP: Internal error: Oops: f5 [#1]
From: wuhm <wuhm@hisome.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Sat, 24 Nov 2007 20:41:43 +0800
Message-Id: <1195908103.857.1.camel@wuhm-laptop.dev.hisome.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-8) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Unable to handle kernel paging request at virtual address c3c00000
pgd = c3a5c000
[c3c00000] *pgd=00000000
Internal error: Oops: f5 [#1]
Modules linked in: dm642 mv_sata ixp400_eth ixp400
CPU: 0
PC is at .c2u_0cpynopld+0x8/0x24
LR is at mpeg_read+0x19c/0x35c [dm642]
pc : [<c0106934>]    lr : [<bf0c8a98>]    Tainted: P
sp : c331bed8  ip : 0000025c  fp : c331bf54
r10: 0000c000  r9 : bdff3d58  r8 : c31a89a0
r7 : c331bf78  r6 : e5931000  r5 : e1a00003  r4 : e59f30ec
r3 : e3a02004  r2 : 00003d58  r1 : c3bffffc  r0 : bdffbd54
Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  Segment user
Control: 39FF  Table: 03A5C000  DAC: 00000015
Process SOE (pid: 332, stack limit = 0xc331a194)
Stack: (0xc331bed8 to 0xc331c000)
bec0:                                                       0000c000
c3978000
bee0: c31a89a0 bdff3d58 c331bf78 bf0c8a98 d4f6f580 d4f6f580 c331bf40
c331bf08
bf00: c0218ca0 c003454c 00000000 00000225 d4f6f580 c3a56904 00039a79
c331bf44
bf20: c025d2f8 007fffff 94b00495 0000c000 c31a89a0 bdff3d58 c331bf78
fffffff7
bf40: c331a000 400220cc c331bf74 c331bf58 c00726c4 bf0c8908 c31a89c4
bdff3d58
bf60: 0000c000 c31a89a0 c331bfa4 c331bf78 c0072998 c0072608 00000000
00000000
bf80: 00000001 00000007 bdff3d58 0000c000 00000003 c0020de4 00000000
c331bfa8
bfa0: c0020c60 c007295c 00000007 ffffffff 00000007 bdff3d58 0000c000
00000000
bfc0: 00000007 bdff3d58 0000c000 0000c000 0001dbc0 00000000 400220cc
00000003
bfe0: 40022168 bdff3d2c 40019870 400781c4 60000010 00000007 00000000
00000000
Backtrace:
[<bf0c88fc>] (mpeg_read+0x0/0x35c [dm642]) from [<c00726c4>] (vfs_read
+0xc8/0x140)
[<c00725fc>] (vfs_read+0x0/0x140) from [<c0072998>] (sys_read+0x48/0x74)
 r7 = C31A89A0  r6 = 0000C000  r5 = BDFF3D58  r4 = C31A89C4
[<c0072950>] (sys_read+0x0/0x74) from [<c0020c60>] (ret_fast_syscall
+0x0/0x2c)
 r8 = C0020DE4  r7 = 00000003  r6 = 0000C000  r5 = BDFF3D58
 r4 = 00000007
Code: f5d1f05c f5d0f05c e8b10078 e8a00078 (e8b10078)

