Return-Path: <linux-kernel-owner+w=401wt.eu-S1759112AbYA3MVP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759112AbYA3MVP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 07:21:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751452AbYA3MVB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 07:21:01 -0500
Received: from fk-out-0910.google.com ([209.85.128.188]:5470 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbYA3MU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 07:20:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:organization:x-mailer:mime-version:content-type:content-transfer-encoding:from;
        b=SNf3mMiahWNF4XXKtii1/hn5ojDbi/68hkYgeNHWODouVF1+7/GTycPRaX1cnPKnEzOCHnjCkmh6EkKtxa5Ed9/aPFgqsXhO5fghr2VTewuW+mQggiiU+Ni+UADZ/LDMfbtgSJ9j3FMq+AXIJeeWHI6mCvC6FiINDKOEb6Asb24=
Date: Wed, 30 Jan 2008 13:20:36 +0100
To: linux-pcmcia@lists.infradead.org
Cc: linux-sh <linux-sh@vger.kernel.org>,
       linux-main <linux-kernel@vger.kernel.org>
Subject: [HD64461_PCMCIA_driver] - Shared IRQ lines / Segfaults
Message-Id: <20080130132036.87299f09.Kristoffer.ericson@gmail.com>
Organization: JLime
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.5; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

Driver detects card insertion / ejection and sets power properly. The mapping looks resonable also compairing to a working 2.6.17 driver.
However when manually modprobing drivers I either get a segmentation fault or problems with IRQ shared lines.

Any suggestesions?

Best wishes
Kristoffer


Insert Card Log :
hd64461_interrupt: we are pushing changed events! events=64
hd64461_interrupt: Passing SS_DETECT to events
hd64461_interrupt: cscr changed due to [HD6446x_PCC0ISR] & HD6446x_PCCISR_MASK = true
hd64461_interrupt: we are pushing changed events! events=128
hd64461 : getting status from slot, b7
hd64461: will return status = 0
hd64461_interrupt: Passing SS_DETECT to events
hd64461_interrupt: cscr changed due to [HD6446x_PCC0ISR] & HD6446x_PCCISR_MASK = true
hd64461_interrupt: we are pushing changed events! events=128
hd64461 : getting status from slot, b3
hd64461: setting status to SS_DETECT
hd64461: IC_memory = 1
hd64461: setting status to SS_READY
hd64461: setting status to SS_3VCARD
hd64461: will return status = 10c0
hd64461 : getting status from slot, b3
hd64461: setting status to SS_DETECT
hd64461: IC_memory = 1
hd64461: setting status to SS_READY
hd64461: setting status to SS_3VCARD
hd64461: will return status = 10c0
hd64461 : getting status from slot, b3
hd64461: setting status to SS_DETECT
hd64461: IC_memory = 1
hd64461: setting status to SS_READY
hd64461: setting status to SS_3VCARD
hd64461: will return status = 10c0
flags = 0, csc_mask = 80, Vcc = 33 Vpp = 33 io_irq = 0
state->Vpp != sp->state.Vcc
hd64461_set_voltage: 33 Vcc, 33 Vpp
hd64461_set_socket: We've passed the routine successfully
hd64461 : getting status from slot, b3
hd64461: setting status to SS_DETECT
hd64461: IC_memory = 1
hd64461: setting status to SS_READY
hd64461: setting status to SS_3VCARD
hd64461: setting status to SS_POWERON
hd64461: will return status = 11c0
flags = 240, csc_mask = 80, Vcc = 33 Vpp = 33 io_irq = 0
hd64461_set_socket: SS_RESET and state changed
hd64461_set_socket: SS_OUTPUT_ENA and state changed
hd64461_set_socket: We've passed the routine successfully
flags = 200, csc_mask = 80, Vcc = 33 Vpp = 33 io_irq = 0
hd64461_set_socket: SS_RESET and state changed
hd64461_set_socket: We've passed the routine successfully
hd64461_interrupt: we are pushing changed events! events=64
hd64461 : getting status from slot, b3
hd64461: setting status to SS_DETECT
hd64461: IC_memory = 1
hd64461: setting status to SS_READY
hd64461: setting status to SS_3VCARD
hd64461: setting status to SS_POWERON
hd64461: will return status = 11c0
pccard: PCMCIA card inserted into slot 0
sock=0, map=0 flags=0x21 static_start=0x00000000, card_start=0x00000000
hd64461: settings pointers smem to 8d2ee4bc and saddr to b8000000
hd64461: mem->static_start = saddr (b8000000)
sock=0, map=0 flags=0x21 static_start=0xb8000000, card_start=0x00000000
hd64461: settings pointers smem to 8d2ee4bc and saddr to b8000000
hd64461: mem->static_start = saddr (b8000000)
sock=0, map=0 flags=0x21 static_start=0xb8000000, card_start=0x00000000
hd64461: settings pointers smem to 8d2ee4bc and saddr to b8000000
hd64461: mem->static_start = saddr (b8000000)
sock=0, map=0 flags=0x21 static_start=0xb8000000, card_start=0x00000000
hd64461: settings pointers smem to 8d2ee4bc and saddr to b8000000
hd64461: mem->static_start = saddr (b8000000)
sock=0, map=0 flags=0x21 static_start=0xb8000000, card_start=0x00000000
hd64461: settings pointers smem to 8d2ee4bc and saddr to b8000000
hd64461: mem->static_start = saddr (b8000000)
sock=0, map=0 flags=0x21 static_start=0xb8000000, card_start=0x00000000
hd64461: settings pointers smem to 8d2ee4bc and saddr to b8000000
hd64461: mem->static_start = saddr (b8000000)
sock=0, map=0 flags=0x21 static_start=0xb8000000, card_start=0x00000000
hd64461: settings pointers smem to 8d2ee4bc and saddr to b8000000
hd64461: mem->static_start = saddr (b8000000)
sock=0, map=0 flags=0x21 static_start=0xb8000000, card_start=0x00000000
hd64461: settings pointers smem to 8d2ee4bc and saddr to b8000000
hd64461: mem->static_start = saddr (b8000000)
sock=0, map=0 flags=0x21 static_start=0xb8000000, card_start=0x00000000
hd64461: settings pointers smem to 8d2ee4bc and saddr to b8000000
hd64461: mem->static_start = saddr (b8000000)
sock=0, map=0 flags=0x21 static_start=0xb8000000, card_start=0x00000000
hd64461: settings pointers smem to 8d2ee4bc and saddr to b8000000
hd64461: mem->static_start = saddr (b8000000)
sock=0, map=0 flags=0x21 static_start=0xb8000000, card_start=0x00000000
hd64461: settings pointers smem to 8d2ee4bc and saddr to b8000000
hd64461: mem->static_start = saddr (b8000000)
sock=0, map=0 flags=0x21 static_start=0xb8000000, card_start=0x00000000
hd64461: settings pointers smem to 8d2ee4bc and saddr to b8000000
hd64461: mem->static_start = saddr (b8000000)
sock=0, map=0 flags=0x21 static_start=0xb8000000, card_start=0x00000000
hd64461: settings pointers smem to 8d2ee4bc and saddr to b8000000
hd64461: mem->static_start = saddr (b8000000)
sock=0, map=0 flags=0x21 static_start=0xb8000000, card_start=0x00000000
hd64461: settings pointers smem to 8d2ee4bc and saddr to b8000000
hd64461: mem->static_start = saddr (b8000000)
sock=0, map=0 flags=0x21 static_start=0xb8000000, card_start=0x00000000
hd64461: settings pointers smem to 8d2ee4bc and saddr to b8000000
hd64461: mem->static_start = saddr (b8000000)
sock=0, map=0 flags=0x21 static_start=0xb8000000, card_start=0x00000000
hd64461: settings pointers smem to 8d2ee4bc and saddr to b8000000
hd64461: mem->static_start = saddr (b8000000)
sock=0, map=0 flags=0x21 static_start=0xb8000000, card_start=0x00000000
hd64461: settings pointers smem to 8d2ee4bc and saddr to b8000000
hd64461: mem->static_start = saddr (b8000000)
sock=0, map=0 flags=0x21 static_start=0xb8000000, card_start=0x00000000
hd64461: settings pointers smem to 8d2ee4bc and saddr to b8000000
hd64461: mem->static_start = saddr (b8000000)
sock=0, map=0 flags=0x1 static_start=0xb8000000, card_start=0x00000000
hd64461: settings pointers smem to 8d2ee4bc and saddr to b8000000
hd64461: !mem->flags & MAP_ATTRIB = true so saddr += HD6446x_PCC_WINDOW
hd64461: mem->static_start = saddr (b9000000)
sock=0, map=0 flags=0x1 static_start=0xb9000000, card_start=0x00000000
hd64461: settings pointers smem to 8d2ee4bc and saddr to b8000000
hd64461: !mem->flags & MAP_ATTRIB = true so saddr += HD6446x_PCC_WINDOW
hd64461: mem->static_start = saddr (b9000000)
pcmcia: registering new device pcmcia0.0
sock=0, map=0 flags=0x21 static_start=0xb9000000, card_start=0x00000000
hd64461: settings pointers smem to 8d2ee4bc and saddr to b8000000
hd64461: mem->static_start = saddr (b8000000)
sock=0, map=0 flags=0x21 static_start=0xb8000000, card_start=0x00000000
hd64461: settings pointers smem to 8d2ee4bc and saddr to b8000000
hd64461: mem->static_start = saddr (b8000000)

modprobe orinoco_cs : 
sock=0, map=0 flags=0x21 static_start=0xb8000000, card_start=0x00000000
hd64461: settings pointers smem to 8d2ee4bc and saddr to b8000000
hd64461: mem->static_start = saddr (b8000000)
sock=0, map=0 flags=0x21 static_start=0xb8000000, card_start=0x00000000
hd64461: settings pointers smem to 8d2ee4bc and saddr to b8000000
hd64461: mem->static_start = saddr (b8000000)
pcmcia: request for exclusive IRQ could not be fulfilled.
pcmcia: the driver needs updating to supported shared IRQ lines.
0.0: RequestIRQ: Operation succeeded

or : 
modprobe hostap_cs
hostap_cs: Registered netdevice wifi0
Unable to handle kernel NULL pointer dereference at virtual address 00000028
pc = 8d0031b8
*pde = 00000000
Oops: 0000 [#1]
Modules linked in: hostap_cs hostap orinoco_cs orinoco hermes atmel_cs atmel

Pid : 283, Comm:             modprobe
PC is at generic_inw+0x8/0x20
PC  : 8d0031b8 SP  : 8ecaba74 SR  : 400000f0 TEA : c0045040    Not tainted
R0  : 00000028 R1  : 8d2d9030 R2  : 8d2ac050 R3  : 00000007
R4  : 00000028 R5  : 00000002 R6  : 00000080 R7  : 8ecf06a0
R8  : 8ee62000 R9  : 00008a32 R10 : c002a1b0 R11 : 8ee62000
R12 : 00000080 R13 : 8ee62000 R14 : 8ecf06a0
MACH: 0000458f MACL: 00001110 GBR : 296ce450 PR  : 8d0031b8

Call trace: 
[<c002a1fa>] prism2_interrupt+0x4a/0xc50 [hostap_cs]
[<8d03ce74>] request_irq+0xc4/0x120
[<c002a1b0>] prism2_interrupt+0x0/0xc50 [hostap_cs]
[<8d17920c>] pcmcia_request_irq+0x19c/0x210
[<c002eb34>] hostap_cs_probe+0x9d4/0xe50 [hostap_cs]
[<8d042d50>] mempool_alloc+0x0/0x180
[<8d102a06>] generic_make_request+0x156/0x240
[<8d1618d0>] ata_qc_issue_prot+0x170/0x260
[<8d16ab9e>] ata_exec_command+0x1e/0x40
[<8d1618da>] ata_qc_issue_prot+0x17a/0x260
[<8d160772>] ata_qc_issue+0x272/0x530
[<8d025d1e>] rcu_process_callbacks+0xe/0x30
[<8d018a66>] tasklet_action+0x86/0xf0
[<8d0184e8>] __do_softirq+0x58/0xe0
[<8d0185d6>] do_softirq+0x66/0x80
[<8d018756>] irq_exit+0x36/0x60
[<8d173980>] pccard_get_next_tuple+0xc0/0x4a0
[<8d007024>] call_dpf+0x10/0x30
[<8d176408>] pcmcia_device_probe+0xb8/0x190
[<8d0136c0>] printk+0x0/0x20
[<8d145354>] driver_probe_device+0xd4/0x180
[<8d145606>] __driver_attach+0xf6/0x160
[<8d10bf60>] strlen+0x0/0x60
[<8d144168>] bus_for_each_dev+0x48/0x90
[<8d145510>] __driver_attach+0x0/0x160
[<8d1440f0>] next_device+0x0/0x30
[<8d144a6a>] bus_add_driver+0x5a/0x1e0
[<8d17613c>] pcmcia_register_driver+0xac/0x140
[<8d0136c0>] printk+0x0/0x20
[<8d115540>] crc32_le+0x0/0xb0
[<8d10bf60>] strlen+0x0/0x60
[<8d037474>] sys_init_module+0x154/0x1500
[<8d04da30>] kstrdup+0x0/0x50
[<8d22f590>] mutex_unlock+0x0/0x60
[<8d18beb0>] kfree_skb+0x0/0x60
[<8d007238>] syscall_call+0xc/0x10
[<8d037320>] sys_init_module+0x0/0x1500

Process: modprobe (pid: 283, stack limit = 8ecaa001)
Stack: (0x8ecaba74 to 0x8ecac000)
ba60:                                              c002a1fa 8ed79840 8ee62444 
ba80: 00000000 0000004e 00000080 8ee62000 8ecf06a0 8ecabab8 8d03ce74 8ecf06a0 
baa0: 8ee62000 00000080 0000004e c002a1b0 00000000 8ed79840 8d17920c 8ec912b0 
bac0: 8ece7200 00000000 8ece7234 8d2ee500 0000004e 00000040 8ee62000 00000080 
bae0: 8ece7344 c002eb34 8ee62444 0000017c 8ece7400 8ece7200 8ee62000 0000002e 
bb00: 00000000 00000000 8ecdbf1b 00000110 00000000 000000a6 40000e1b 8ecdaa0e 
bb20: 8ecabb24 761901c1 3619d535 ff460536 0000ffff 8ecdaaf0 8ecdbf38 8ecdbf38 
bb40: 00000000 8d042d50 8d102a06 0000014a 00000004 8ecabc4c fffffffb 00000014 
bb60: 8ec42150 8ecdab00 00000000 00000021 00000021 00000021 8d1618d0 8ecd6c00 
bb80: 8ecdd688 8ecdc000 8ecdc0f8 8d16ab9e 8d1618da 8ecdc08c 8d160772 8ecdc07c 
bba0: 8ecd9c10 8ecdc0f8 00000000 00016401 73756201 6d630076 2f616963 000493e0 
bbc0: 000802c8 74736f68 002dc6c0 002dc6c0 000186a0 64646100 56454400 48544150 
bbe0: 75622f3d 63702f73 6169636d 6972642f 73726576 736f6800 5f706174 53007363 
bc00: 59534255 4d455453 6972643d 73726576 51455300 00000000 00373532 00000000 
bc20: 00000000 00000000 00000000 00000146 00000000 00000040 8d3320c0 8d3320e0 
bc40: 8d332a00 8d332a20 8d332a40 8d332a60 8d332280 8d3322a0 8d3322c0 8d3322e0 
bc60: 8d334c80 8d334ca0 8d334cc0 8d334ce0 8d332300 8d332320 8d332340 8d332360 
bc80: 8d332380 8d3323a0 8d3323c0 8d3323e0 8d332100 8d332120 8d332140 8d332160 
bca0: 8d332180 8d3321a0 8d3321c0 8d3321e0 000000ff 0000ffff 8d330040 8d334d60 
bcc0: 8d334d80 8d334da0 8d334dc0 8d334de0 8d334e00 8d334e20 8d334e40 8d334e60 
bce0: 8d334e80 8d334ea0 8d334ec0 8d334ee0 8d334f00 8d334f20 00000000 00000000 
bd00: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 
bd20: 8d2df7a0 0000000a 8d2e0a04 00000001 8d025d1e ffffffff 8d018a66 ffffffff 
bd40: ffffff0f 00000000 8d0184e8 8d2df7a0 0000000a 8d2e0a04 00000001 8d2df7f4 
bd60: 00000000 8d0185d6 8d2c04f8 8d27bbb8 8ed2ba98 00000000 8d2e9428 000000f0 
bd80: 8d018756 8d173980 0000000e 8d2ee500 8ecabddc 00000001 8ed78c90 0000001a 
bda0: 8ecabda4 0000071a 8ed72c61 8ece9fc0 8d007024 8ece728c 8ee62000 8ee62580 
bdc0: 8ee6217c 8ee6217c 0000053c 00000000 8d3311c0 c0034e88 8ece728c 8ece7209 
bde0: 8ece7220 8ece7222 8ece722a 8ece7240 8ece7260 8d176408 8d0136c0 8d2c04f8 
be00: 8d2ee150 8ece7200 00000001 8ece728c c0034e88 00000001 000003e0 00000001 
be20: 00000000 00000000 00000000 00000000 8d145354 00000000 c0034ea0 8ece7308 
be40: 8ece728c 8d145606 8d10bf60 c0034ea0 c0034ea0 8ece72cc 8ece728c 8d144168 
be60: 8d145510 8d1440f0 00000000 8d2c0590 8d2c0590 8ece72d4 8d144a6a 000000bc 
be80: c0034ea8 c0034ea0 00000000 8d17613c 8d0136c0 8d115540 8d10bf60 c0034e88 
bea0: c0034d9c c0034ea0 c0034d78 8ecabed0 8d037474 00000027 8d04da30 00000000 
bec0: 8d22f590 c0034f90 c003504c 00000027 00000000 00000000 8ecf4bd0 8ecf6860 
bee0: c007e4b4 c007e357 8ed72ee0 c0098108 00000027 00000026 0000000b 00000000 
bf00: 00000000 00000011 00000000 0000000a 00000000 00000000 00000000 00000000 
bf20: 00000000 00000000 00000000 00000000 00000000 c0034f90 00000142 00000000 
bf40: 8d18beb0 00000001 8ecaa000 00000000 00000020 00000080 00000020 00000080 
bf60: 00000027 c0034f9c c0047030 c003508c 00000618 c0033292 c005345c 00000000 
bf80: 8d007238 7be7cb8c 7be7cb70 00000002 ffffff0f 00000001 8ecabff8 8d037320 
bfa0: 00000000 00400f84 00000000 00000080 296cf000 00052434 00416130 00416130 
bfc0: 00000000 00000000 7be7ce58 7be7cfbd 00000002 7be7cb70 7be7cb8c 7be7cb8c 
bfe0: 296580e6 0040320c 00000001 296ce450 90c30b48 00000000 00000054 00000160 
---[ end trace d3c1da1b63290843 ]---
Segmentation fault
