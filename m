Return-Path: <linux-kernel-owner+w=401wt.eu-S934350AbXC2WJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934350AbXC2WJ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 18:09:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934358AbXC2WJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 18:09:26 -0400
Received: from pool-72-92-185-191.albyny.east.verizon.net ([72.92.185.191]:50753
	"EHLO posidon.tmr.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934350AbXC2WJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 18:09:26 -0400
X-Greylist: delayed 463 seconds by postgrey-1.27 at vger.kernel.org; Thu, 29 Mar 2007 18:09:25 EDT
Date: Thu, 29 Mar 2007 18:01:41 -0400
From: Bill Davidsen <davidsen@posidon.tmr.com>
Message-Id: <200703292201.l2TM1fO4005275@posidon.tmr.com>
To: linux-kernel@vger.kernel.org
Subject: [2.6.21-rc5-git1][KVM] exception on start VM
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Starting a VM for Win98SE:

posidon:root> /usr/local/kvm-15/bin/qemu -m 128 -hda Win98SE-2.kvm 
exception 13 (0)
rax 00000000f000ff53 rbx 0000000000000000 rcx 000000000000005a rdx 000000000000000e
rsi 00000000001100c4 rdi 000000000002a002 rsp 0000000000086650 rbp 000000000000667a
r8  0000000000000000 r9  0000000000000000 r10 0000000000000000 r11 0000000000000000
r12 0000000000000000 r13 0000000000000000 r14 0000000000000000 r15 0000000000000000
rip 000000000000d350 rflags 00237206
cs fff8 (000fff80/0000ffff p 1 dpl 3 db 0 s 1 type 3 l 0 g 0 avl 0)
ds 0000 (00000000/0000ffff p 1 dpl 3 db 0 s 1 type 3 l 0 g 0 avl 0)
es 0000 (00000000/0000ffff p 1 dpl 3 db 0 s 1 type 3 l 0 g 0 avl 0)
ss 103f (000103f0/0000ffff p 1 dpl 3 db 0 s 1 type 3 l 0 g 0 avl 0)
fs 0000 (00000000/0000ffff p 1 dpl 3 db 0 s 1 type 3 l 0 g 0 avl 0)
gs 0000 (00000000/0000ffff p 1 dpl 3 db 0 s 1 type 3 l 0 g 0 avl 0)
tr 0000 (08850000/00002088 p 1 dpl 0 db 0 s 0 type b l 0 g 0 avl 0)
ldt 0000 (00000000/0000ffff p 1 dpl 0 db 0 s 0 type 2 l 0 g 0 avl 0)
gdt 87244/2f
idt 0/3ff
cr0 60000010 cr2 0 cr3 0 cr4 0 cr8 0 efer 0
Aborted
posidon:root>


Hope that's useful, I was looking at nbd issues and just tried for 
curiosity.

-- 
<davidsen@tmr.com>
