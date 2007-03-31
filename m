Return-Path: <linux-kernel-owner+w=401wt.eu-S1753284AbXCaQJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284AbXCaQJp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 12:09:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753277AbXCaQJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 12:09:45 -0400
Received: from build.arklinux.osuosl.org ([140.211.166.26]:53611 "EHLO
	mail.arklinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265AbXCaQJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 12:09:44 -0400
X-Greylist: delayed 2009 seconds by postgrey-1.27 at vger.kernel.org; Sat, 31 Mar 2007 12:09:44 EDT
From: Bernhard Rosenkraenzer <bero@arklinux.org>
To: linux-kernel@vger.kernel.org
Subject: 2.6.21-rc5-mm[12]: Oops on bootup in xor_see_2
Date: Sat, 31 Mar 2007 17:36:47 +0000
User-Agent: KMail/1.9.6
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703311736.47751.bero@arklinux.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm getting this Oops when booting an 2.6.21-rc5-mm1 or 2.6.21-rc5-mm2 on an 
Acer Aspire 1501 LMi in 32 bit mode (2.6.21-rc4-mm1 + hotfixes works 
perfectly):

xor: automatically using best checksumming function: pIII_sse

BUG: unable to handle kernel NULL pointer dereference at virtual address 
00000010
printing eip:
c02cb724
*pde=00000000
Oops: 0002 [#1]
last sysfs file:
Modules linked in:
CPU: 0
EIP: 0060:[<c02cb724>] Not tainted VLI
EFLAGS: 00010212 (2.6.12-rc5-mm2)
EIP is at xor_sse_2+0x34/0x200
eax: 00000010 ebx: fffea4df ecx: df8c3000 edx: df8c0000
esi: 8005003b edi: c03ebce0 ebp: df8c3000 esp: dfd01ef8
ds: 007b es: 007b fs: 00d8 gs: 0000 ss: 0068
Process swapper (pid: 1, ti=dfd000000 task=c146aa10 task:ti=dfd00000
Stack: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
       00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
       c13f1800 fffea4df 00000000 c02caa83 c03ebce0 df8c0000 00000000 c011bd7b
Call Trace:
  [<c02caa83>] do_xor_speed+0x53/0xf0
  [<c011bd7b>] printk+0x1b/0x20
  [<c02cac02>] calibrate_xor_block+0x2e/0x1b0
  [<c03fe7a2>] kernel_init+0x92/0x1c0
  [<c0103dee>] ret_from_fork+0x6/0x1c
  [<c03fe710>] kernel_init+0x0/0x1c0
  [<c03fe710>] kernel_init+0x0/0x1c0
  [<c0104937>] kernel_thread_helper+0x7/0x10
=======================
Code: 44 89 74 24 48 0f 20 c6 0f 06 0f 11 04 24 0f 11 4c 24 10 0f 11 54 24 20 
0f
      11 5c 24 30 0f 18 82 00 01 00 00 0f 18 82 20 01 00 00 <00> 00 00 00 00 
00
      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
