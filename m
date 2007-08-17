Return-Path: <linux-kernel-owner+w=401wt.eu-S1759067AbXHQQMD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759067AbXHQQMD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 12:12:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755095AbXHQQLx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 12:11:53 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:11078 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174AbXHQQLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 12:11:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=j+Jsn9KnahiVfz45ki2PRkwMerkihgWOeaCrUMIXWts6uKm+gv4hTy6UG0pNwuDuim6tNn9J3BZBMVyEztq9JyuUNgIfI/Y9apb+aaufrvlThn+Jh/gO2IkUPIELKuD3cTmOToZwEUhMXZwGorY1gIoKNJs5YJu+gMg+Iy5pS3k=
Message-ID: <ab40e9c0708170911r539f4f63t3659084d52567522@mail.gmail.com>
Date: Fri, 17 Aug 2007 18:11:45 +0200
From: "Xu Yang" <risingsunxy@googlemail.com>
To: linux-kernel@vger.kernel.org
Subject: bug information
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

finally I can send email to our list.......; )

When I was porting kernel 2.6.19 to my realview_eb_mpcore system, I
got the following information.
(actually my system is a software virtual prototype, which is built up
by myself)
I am pretty new in linux, so I am not sure what does these information
mean for me.

does anyone know what does these information tell ? and where might be
the problem?

thanks.

information:
Uncompressing Linux.................................................
done, booting the kernel.
<5>Linux version 2.6.19-arm2 (risingsunxy@localhost.localdomain) (gcc
version 4.2.0 20070413 (prerelease) (CodeSourcery Sourcery G++ Lite
2007q1-21)) #13 SMP Wed Aug 15 19:10:52 CEST 2007
CPU: ARMv6-compatible processor [410fb022] revision 2 (ARMv6TEJ), cr=00c5387f
Machine: ARM-RealView EB
<4>Warning: bad configuration page, trying to continue
Memory policy: ECC disabled, Data cache writealloc
<7>On node 0 totalpages: 32768
<7>  DMA zone: 320 pages used for memmap
<7>  DMA zone: 0 pages reserved
<7>  DMA zone: 32448 pages, LIFO batch:7
<7>  Normal zone: 0 pages used for memmap
CPU0: D VIPT write-back cache
CPU0: I cache: 512 bytes, associativity 1, 8 byte lines, 64 sets
CPU0: D cache: 32768 bytes, associativity 4, 32 byte lines, 256 sets
Built 1 zonelists.  Total pages: 32448
<5>Kernel command line: root=/dev/nfs nfsroot=10.1.69.3:/work/nfsroot
ip=dhcp console=ttyAMA0 mem=128M
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 00000080
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ128
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 00000081
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ129
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 00000082
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ130
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 00000083
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ131
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 00000084
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ132
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 00000085
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ133
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 00000086
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ134
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 00000087
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ135
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 00000088
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ136
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 00000089
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ137
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 0000008A
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ138
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 0000008B
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ139
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 0000008C
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ140
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 0000008D
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ141
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 0000008E
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ142
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 0000008F
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ143
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 00000090
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ144
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 00000091
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ145
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 00000092
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ146
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 00000093
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ147
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 00000094
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ148
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 00000095
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ149
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 00000096
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ150
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 00000097
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ151
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 00000098
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ152
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 00000099
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ153
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 0000009A
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ154
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 0000009B
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ155
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 0000009C
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ156
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 0000009D
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ157
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 0000009E
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ158
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 0000009F
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ159
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000A0
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ160
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000A1
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ161
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000A2
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ162
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000A3
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ163
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000A4
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ164
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000A5
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ165
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000A6
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ166
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000A7
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ167
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000A8
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ168
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000A9
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ169
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000AA
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ170
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000AB
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ171
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000AC
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ172
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000AD
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ173
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000AE
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ174
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000AF
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ175
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000B0
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ176
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000B1
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ177
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000B2
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ178
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000B3
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ179
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000B4
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ180
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000B5
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ181
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000B6
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ182
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000B7
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ183
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000B8
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ184
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000B9
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ185
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000BA
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ186
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000BB
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ187
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000BC
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ188
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000BD
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ189
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000BE
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ190
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000BF
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ191
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000C0
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ192
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000C1
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ193
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000C2
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ194
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000C3
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ195
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000C4
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ196
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000C5
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ197
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000C6
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ198
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000C7
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ199
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000C8
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ200
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000C9
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ201
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000CA
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ202
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000CB
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ203
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000CC
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ204
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000CD
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ205
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000CE
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ206
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000CF
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ207
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000D0
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ208
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000D1
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ209
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000D2
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ210
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000D3
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ211
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000D4
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ212
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000D5
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ213
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000D6
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ214
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000D7
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ215
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000D8
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ216
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000D9
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ217
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000DA
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ218
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000DB
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ219
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000DC
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ220
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000DD
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ221
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000DE
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ222
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000DF
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ223
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000E0
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ224
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000E1
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ225
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000E2
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ226
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000E3
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ227
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000E4
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ228
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000E5
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ229
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000E6
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ230
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000E7
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ231
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000E8
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ232
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000E9
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ233
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000EA
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ234
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000EB
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ235
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000EC
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ236
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000ED
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ237
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000EE
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ238
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000EF
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ239
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000F0
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ240
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000F1
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ241
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000F2
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ242
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000F3
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ243
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000F4
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ244
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000F5
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ245
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000F6
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ246
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000F7
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ247
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000F8
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ248
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000F9
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ249
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000FA
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ250
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000FB
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ251
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000FC
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ252
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000FD
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ253
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000FE
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ254
BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
[<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
[<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
(gic_dist_init+0x144/0x1a8)
 r7 = C0174834  r6 = 00000100  r5 = FF001000  r4 = 000000FF
[<c000dd44>] (gic_dist_init+0x0/0x1a8) from [<c000e0b0>]
(gic_init_irq+0x3c/0x88)
[<c000e074>] (gic_init_irq+0x0/0x88) from [<c000bb58>] (init_IRQ+0x58/0x68)
 r4 = C0173940
[<c000bb00>] (init_IRQ+0x0/0x68) from [<c00089e8>] (start_kernel+0x160/0x2b0)
[<c0008888>] (start_kernel+0x0/0x2b0) from [<00008078>] (0x8078)
<3>Trying to set irq flags for IRQ255
PID hash table entries: 512 (order: 9, 2048 bytes)
Console: colour dummy device 80x30
Dentry cache hash table entries: 16384 (order: 4, 65536 bytes)
Inode-cache hash table entries: 8192 (order: 3, 32768 bytes)
<6>Memory: 128MB = 128MB total
<5>Memory: 128000KB available (1160K code, 311K data, 64K init)
<7>Calibrating delay loop...
