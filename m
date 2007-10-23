Return-Path: <linux-kernel-owner+w=401wt.eu-S1752976AbXJWTEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976AbXJWTEq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 15:04:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752290AbXJWTEi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 15:04:38 -0400
Received: from orion2.pixelized.ch ([195.190.190.13]:38282 "EHLO
	mail.pixelized.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268AbXJWTEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 15:04:36 -0400
Message-ID: <471E45B4.9050504@debian.org>
Date: Tue, 23 Oct 2007 21:04:20 +0200
From: Giacomo Catenazzi <cate@debian.org>
User-Agent: Mozilla-Thunderbird 2.0.0.6 (X11/20071009)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: last git: BUG: unable to handle kernel paging request at virtual
 address 92184900
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello people,

I've still some kernel bug

ciao
	cate

Oct 23 20:20:05 catee kernel: BUG: unable to handle kernel paging request at virtual address 92184900
Oct 23 20:20:05 catee kernel: printing eip: c017b9c2 *pde = 00000000
Oct 23 20:20:05 catee kernel: Oops: 0002 [#1] SMP
Oct 23 20:20:05 catee kernel: Modules linked in: fuse tuner tea5767 tda8290 tuner_simple mt20xx floppy bttv ir_common videobuf_dma_sg btcx_risc tveeprom
Oct 23 20:20:05 catee kernel:
Oct 23 20:20:05 catee kernel: Pid: 2191, comm: dirmngr Not tainted (2.6.23-g0b776eb5 #16)
Oct 23 20:20:05 catee kernel: EIP: 0060:[<c017b9c2>] EFLAGS: 00010203 CPU: 2
Oct 23 20:20:05 catee kernel: EIP is at generic_drop_inode+0x5d/0x147
Oct 23 20:20:05 catee kernel: EAX: c478b238 EBX: c478b228 ECX: c2491600 EDX: c4d170b8
Oct 23 20:20:05 catee kernel: ESI: c2405f40 EDI: c478b228 EBP: c4933940 ESP: c3798e90
Oct 23 20:20:05 catee kernel: DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Oct 23 20:20:05 catee kernel: Process dirmngr (pid: 2191, ti=c3798000 task=c2c99ab0 task.ti=c3798000)
Oct 23 20:20:05 catee kernel: Stack: c478b228 c017b00d c5046314 c01791bf c5046314 c2405f40 c017a0d7 00000008
Oct 23 20:20:05 catee kernel: c016b622 00000010 00000000 c5046314 c478b228 c037f600 c478b200 c2832200
Oct 23 20:20:05 catee kernel: 00000000 c02f9a4d 00000000 c20107b4 c2469ae0 00000000 00000001 ffffffff
Oct 23 20:20:05 catee kernel: Call Trace:
Oct 23 20:20:05 catee kernel: [<c017b00d>] iput+0x5c/0x62
Oct 23 20:20:05 catee kernel: [<c01791bf>] d_kill+0x2b/0x44
Oct 23 20:20:05 catee kernel: [<c017a0d7>] dput+0x6d/0xf3
Oct 23 20:20:05 catee kernel: [<c016b622>] __fput+0x124/0x169
Oct 23 20:20:05 catee kernel: [<c02f9a4d>] sys_accept+0x17b/0x1d8
Oct 23 20:20:05 catee kernel: [<c013527f>] autoremove_wake_function+0x0/0x35
Oct 23 20:20:05 catee kernel: [<c013d617>] tick_program_event+0x38/0x58
Oct 23 20:20:05 catee kernel: [<c02f9cb2>] sys_socketcall+0x208/0x273
Oct 23 20:20:05 catee kernel: [<c0103fde>] sysenter_past_esp+0x5f/0x85
Oct 23 20:20:05 catee kernel: =======================
Oct 23 20:20:05 catee kernel: Code: 8b 43 14 89 42 04 89 10 8d 43 10 89 43 10 89 43 14 83 8b 44 01 00 00 20 83 2d 40 e8 49 c0 01 08 05 e4 27 41 c0 01 8b 83 e0 00 00 <00> 85 c0 0f 85 cd 00 00 00 89 d8 e8 e3 fd ff ff 89 d8 e8 b0 f5
Oct 23 20:20:05 catee kernel: EIP: [<c017b9c2>] generic_drop_inode+0x5d/0x147 SS:ESP 0068:c3798e90
Oct 23 20:20:05 catee kernel: BUG: unable to handle kernel paging request at virtual address bfa76fc3
Oct 23 20:20:05 catee kernel: printing eip: c015b9b6 *pde = 00000000
Oct 23 20:20:05 catee kernel: Oops: 0002 [#2] SMP
Oct 23 20:20:05 catee kernel: Modules linked in: fuse tuner tea5767 tda8290 tuner_simple mt20xx floppy bttv ir_common videobuf_dma_sg btcx_risc tveeprom
Oct 23 20:20:05 catee kernel:
Oct 23 20:20:05 catee kernel: Pid: 2191, comm: dirmngr Tainted: G      D (2.6.23-g0b776eb5 #16)
Oct 23 20:20:05 catee kernel: EIP: 0060:[<c015b9b6>] EFLAGS: 00010282 CPU: 2
Oct 23 20:20:05 catee kernel: EIP is at free_pgtables+0x8a/0xb4
Oct 23 20:20:05 catee kernel: EAX: bfa8c000 EBX: c3798d94 ECX: 00000000 EDX: 00000018
Oct 23 20:20:05 catee kernel: ESI: c3623d4c EDI: c25675c0 EBP: bfa77000 ESP: c3798d78
Oct 23 20:20:05 catee kernel: DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Oct 23 20:20:05 catee kernel: Process dirmngr (pid: 2191, ti=c3798000 task=c2c99ab0 task.ti=c3798000)
Oct 23 20:20:05 catee kernel: Stack: c2f12c80 00000000 c015ca2e 00000000 c3798d90 00000000 00000097 c201d180
Oct 23 20:20:05 catee kernel: c2f12c80 c2c99ab0 0000000b c0121f30 00000001 c0126cb6 c3798dbc c01050f0
Oct 23 20:20:05 catee kernel: c03e2f7c 000000f5 c2c99c5c c02077da c3798e58 00000246 c3798e90 c03b0068
Oct 23 20:20:05 catee kernel: Call Trace:
Oct 23 20:20:05 catee kernel: [<c015ca2e>] exit_mmap+0x91/0xeb
Oct 23 20:20:05 catee kernel: [<c0121f30>] mmput+0x23/0x7b
Oct 23 20:20:05 catee kernel: [<c0126cb6>] do_exit+0x12f/0x791
Oct 23 20:20:05 catee kernel: [<c01050f0>] show_registers+0x85/0x1c2
Oct 23 20:20:05 catee kernel: [<c02077da>] do_unblank_screen+0x54/0x12d
Oct 23 20:20:05 catee kernel: [<c0105421>] do_trap+0x0/0xbe
Oct 23 20:20:05 catee kernel: [<c011bdcb>] do_page_fault+0x2e4/0x5c9
Oct 23 20:20:05 catee kernel: [<c011bae7>] do_page_fault+0x0/0x5c9
Oct 23 20:20:05 catee kernel: [<c0353952>] error_code+0x72/0x78
Oct 23 20:20:05 catee kernel: [<c017b9c2>] generic_drop_inode+0x5d/0x147
Oct 23 20:20:05 catee kernel: [<c017b00d>] iput+0x5c/0x62
Oct 23 20:20:05 catee kernel: [<c01791bf>] d_kill+0x2b/0x44
Oct 23 20:20:05 catee kernel: [<c017a0d7>] dput+0x6d/0xf3
Oct 23 20:20:05 catee kernel: [<c016b622>] __fput+0x124/0x169
Oct 23 20:20:05 catee kernel: [<c02f9a4d>] sys_accept+0x17b/0x1d8
Oct 23 20:20:05 catee kernel: [<c013527f>] autoremove_wake_function+0x0/0x35
Oct 23 20:20:05 catee kernel: [<c013d617>] tick_program_event+0x38/0x58
Oct 23 20:20:05 catee kernel: [<c02f9cb2>] sys_socketcall+0x208/0x273
Oct 23 20:20:05 catee kernel: [<c0103fde>] sysenter_past_esp+0x5f/0x85
Oct 23 20:20:05 catee kernel: =======================
Oct 23 20:20:05 catee kernel: Code: 12 00 00 85 f6 75 da 89 df 8b 4f 08 8b 44 24 24 89 44 24 04 8b 44 24 08 89 04 24 89 ea 8b 44 24 0c e8 66 f1 ff ff 83 c4 10 5b 5e <c0> 5d c3 89 df 8b 4f 08 89 54 24 04 8b 44 24 08 89 04 24 89 ea
Oct 23 20:20:05 catee kernel: EIP: [<c015b9b6>] free_pgtables+0x8a/0xb4 SS:ESP 0068:c3798d78
Oct 23 20:20:05 catee kernel: Fixing recursive fault but reboot is needed!
Oct 23 20:20:05 catee kernel: BUG: unable to handle kernel paging request at virtual address 92184900
Oct 23 20:20:05 catee kernel: printing eip: c017b9c2 *pde = 00000000
Oct 23 20:20:05 catee kernel: Oops: 0002 [#3] SMP
Oct 23 20:20:05 catee kernel: Modules linked in: fuse tuner tea5767 tda8290 tuner_simple mt20xx floppy bttv ir_common videobuf_dma_sg btcx_risc tveeprom
Oct 23 20:20:05 catee kernel:
Oct 23 20:20:05 catee kernel: Pid: 2543, comm: hald-addon-acpi Tainted: G      D (2.6.23-g0b776eb5 #16)
Oct 23 20:20:05 catee kernel: EIP: 0060:[<c017b9c2>] EFLAGS: 00010203 CPU: 2
Oct 23 20:20:05 catee kernel: EIP is at generic_drop_inode+0x5d/0x147
Oct 23 20:20:05 catee kernel: EAX: c478be38 EBX: c478be28 ECX: c2491600 EDX: c4d170b8
Oct 23 20:20:05 catee kernel: ESI: c2405f40 EDI: c478be28 EBP: c4933940 ESP: c387ef4c
Oct 23 20:20:05 catee kernel: DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Oct 23 20:20:05 catee kernel: Process hald-addon-acpi (pid: 2543, ti=c387e000 task=c3460030 task.ti=c387e000)
Oct 23 20:20:05 catee kernel: Stack: c478be28 c017b00d c5046294 c01791bf c5046294 c2405f40 c017a0d7 00000008
Oct 23 20:20:05 catee kernel: c016b622 00000010 00000000 c5046294 c478be28 c4933940 c24b7080 00000000
Oct 23 20:20:05 catee kernel: c387e000 c0168f9a c0138257 c24b7080 00000004 c4933940 c016a0dc 00000004
Oct 23 20:20:05 catee kernel: Call Trace:
Oct 23 20:20:05 catee kernel: [<c017b00d>] iput+0x5c/0x62
Oct 23 20:20:05 catee kernel: [<c01791bf>] d_kill+0x2b/0x44
Oct 23 20:20:05 catee kernel: [<c017a0d7>] dput+0x6d/0xf3
Oct 23 20:20:05 catee kernel: [<c016b622>] __fput+0x124/0x169
Oct 23 20:20:05 catee kernel: [<c0168f9a>] filp_close+0x3e/0x62
Oct 23 20:20:05 catee kernel: [<c0138257>] sys_nanosleep+0x64/0x99
Oct 23 20:20:05 catee kernel: [<c016a0dc>] sys_close+0x5e/0x9a
Oct 23 20:20:05 catee kernel: [<c0103fde>] sysenter_past_esp+0x5f/0x85
Oct 23 20:20:05 catee kernel: [<c0350000>] packet_recvmsg+0x17b/0x1af
Oct 23 20:20:05 catee kernel: =======================
Oct 23 20:20:05 catee kernel: Code: 8b 43 14 89 42 04 89 10 8d 43 10 89 43 10 89 43 14 83 8b 44 01 00 00 20 83 2d 40 e8 49 c0 01 08 05 e4 27 41 c0 01 8b 83 e0 00 00 <00> 85 c0 0f 85 cd 00 00 00 89 d8 e8 e3 fd ff ff 89 d8 e8 b0 f5
Oct 23 20:20:05 catee kernel: EIP: [<c017b9c2>] generic_drop_inode+0x5d/0x147 SS:ESP 0068:c387ef4c
Oct 23 20:20:05 catee kernel: BUG: unable to handle kernel paging request at virtual address bfd6efc3
Oct 23 20:20:05 catee kernel: printing eip: c015b9b6 *pde = 00000000
Oct 23 20:20:05 catee kernel: Oops: 0002 [#4] SMP
Oct 23 20:20:05 catee kernel: Modules linked in: fuse tuner tea5767 tda8290 tuner_simple mt20xx floppy bttv ir_common videobuf_dma_sg btcx_risc tveeprom
Oct 23 20:20:05 catee kernel:
Oct 23 20:20:05 catee kernel: Pid: 2543, comm: hald-addon-acpi Tainted: G      D (2.6.23-g0b776eb5 #16)
Oct 23 20:20:05 catee kernel: EIP: 0060:[<c015b9b6>] EFLAGS: 00010282 CPU: 2
Oct 23 20:20:05 catee kernel: EIP is at free_pgtables+0x8a/0xb4
Oct 23 20:20:05 catee kernel: EAX: bfd84000 EBX: c387ee50 ECX: 00000000 EDX: 00000018
Oct 23 20:20:05 catee kernel: ESI: c345e17c EDI: c257bf98 EBP: bfd6f000 ESP: c387ee34
Oct 23 20:20:05 catee kernel: DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Oct 23 20:20:05 catee kernel: Process hald-addon-acpi (pid: 2543, ti=c387e000 task=c3460030 task.ti=c387e000)
Oct 23 20:20:05 catee kernel: Stack: c2ec9e40 00000000 c015ca2e 00000000 c387ee4c 00000000 0000004f c201d180
Oct 23 20:20:05 catee kernel: c2ec9e40 c3460030 0000000b c0121f30 00000001 c0126cb6 c387ee78 c01050f0
Oct 23 20:20:05 catee kernel: c03e2f7c 000000f5 c34601dc c02077da c387ef14 00000246 c387ef4c c03b0068
Oct 23 20:20:05 catee kernel: Call Trace:
Oct 23 20:20:05 catee kernel: [<c015ca2e>] exit_mmap+0x91/0xeb
Oct 23 20:20:05 catee kernel: [<c0121f30>] mmput+0x23/0x7b
Oct 23 20:20:05 catee kernel: [<c0126cb6>] do_exit+0x12f/0x791
Oct 23 20:20:05 catee kernel: [<c01050f0>] show_registers+0x85/0x1c2
Oct 23 20:20:05 catee kernel: [<c02077da>] do_unblank_screen+0x54/0x12d
Oct 23 20:20:05 catee kernel: [<c0105421>] do_trap+0x0/0xbe
Oct 23 20:20:05 catee kernel: [<c011bdcb>] do_page_fault+0x2e4/0x5c9
Oct 23 20:20:05 catee kernel: [<c02fd552>] skb_dequeue+0x45/0x4b
Oct 23 20:20:05 catee kernel: [<c011bae7>] do_page_fault+0x0/0x5c9
Oct 23 20:20:05 catee kernel: [<c0353952>] error_code+0x72/0x78
Oct 23 20:20:05 catee kernel: [<c017b9c2>] generic_drop_inode+0x5d/0x147
Oct 23 20:20:05 catee kernel: [<c017b00d>] iput+0x5c/0x62
Oct 23 20:20:05 catee kernel: [<c01791bf>] d_kill+0x2b/0x44
Oct 23 20:20:05 catee kernel: [<c017a0d7>] dput+0x6d/0xf3
Oct 23 20:20:05 catee kernel: [<c016b622>] __fput+0x124/0x169
Oct 23 20:20:05 catee kernel: [<c0168f9a>] filp_close+0x3e/0x62
Oct 23 20:20:05 catee kernel: [<c0138257>] sys_nanosleep+0x64/0x99
Oct 23 20:20:05 catee kernel: [<c016a0dc>] sys_close+0x5e/0x9a
Oct 23 20:20:05 catee kernel: [<c0103fde>] sysenter_past_esp+0x5f/0x85
Oct 23 20:20:05 catee kernel: [<c0350000>] packet_recvmsg+0x17b/0x1af
Oct 23 20:20:05 catee kernel: =======================
Oct 23 20:20:05 catee kernel: Code: 12 00 00 85 f6 75 da 89 df 8b 4f 08 8b 44 24 24 89 44 24 04 8b 44 24 08 89 04 24 89 ea 8b 44 24 0c e8 66 f1 ff ff 83 c4 10 5b 5e <c0> 5d c3 89 df 8b 4f 08 89 54 24 04 8b 44 24 08 89 04 24 89 ea
Oct 23 20:20:05 catee kernel: EIP: [<c015b9b6>] free_pgtables+0x8a/0xb4 SS:ESP 0068:c387ee34
Oct 23 20:20:05 catee kernel: Fixing recursive fault but reboot is needed!
Oct 23 20:20:05 catee kernel: invalid opcode: 0000 [#5] SMP
Oct 23 20:20:05 catee kernel: Modules linked in: fuse tuner tea5767 tda8290 tuner_simple mt20xx floppy bttv ir_common videobuf_dma_sg btcx_risc tveeprom
Oct 23 20:20:05 catee kernel:
Oct 23 20:20:05 catee kernel: Pid: 3433, comm: icedove-bin Tainted: G      D (2.6.23-g0b776eb5 #16)
Oct 23 20:20:05 catee kernel: EIP: 0060:[<c015b9ba>] EFLAGS: 00210286 CPU: 0
Oct 23 20:20:05 catee kernel: EIP is at free_pgtables+0x8e/0xb4
Oct 23 20:20:05 catee kernel: EAX: b279cfff EBX: c39fbf64 ECX: b2b9d000 EDX: b2b9c000
Oct 23 20:20:05 catee kernel: ESI: c3484740 EDI: c4a59aac EBP: b2b9c000 ESP: c39fbf44
Oct 23 20:20:05 catee kernel: DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Oct 23 20:20:05 catee kernel: Process icedove-bin (pid: 3433, ti=c39fb000 task=c4292030 task.ti=c39fb000)
Oct 23 20:20:05 catee kernel: Stack: c4ac941c c4957bfc c015c911 b2b9d000 c39fbf60 00000000 c4a59aac 00000001
Oct 23 20:20:05 catee kernel: c200d180 b2b9c000 c3484740 c4a59aac c4a59aac c015d350 b2b9c000 b2b9d000
Oct 23 20:20:05 catee kernel: c3484744 c4ac941c b2b9d000 c4ac9428 c4ac941c c3484740 c3484774 00000000
Oct 23 20:20:05 catee kernel: Call Trace:
Oct 23 20:20:05 catee kernel: [<c015c911>] unmap_region+0xc1/0x112
Oct 23 20:20:05 catee kernel: [<c015d350>] do_munmap+0x137/0x1c7
Oct 23 20:20:05 catee kernel: [<c015d407>] sys_munmap+0x27/0x35
Oct 23 20:20:05 catee kernel: [<c0103fde>] sysenter_past_esp+0x5f/0x85
Oct 23 20:20:05 catee kernel: =======================
Oct 23 20:20:05 catee kernel: Code: f6 75 da 89 df 8b 4f 08 8b 44 24 24 89 44 24 04 8b 44 24 08 89 04 24 89 ea 8b 44 24 0c e8 66 f1 ff ff 83 c4 10 5b 5e c0 5d c3 89 <df> 8b 4f 08 89 54 24 04 8b 44 24 08 89 04 24 89 ea 8b 44 24 0c
Oct 23 20:20:05 catee kernel: EIP: [<c015b9ba>] free_pgtables+0x8e/0xb4 SS:ESP 0068:c39fbf44
Oct 23 20:20:05 catee kernel: BUG: unable to handle kernel paging request at virtual address bfbc9fc3
Oct 23 20:20:05 catee kernel: printing eip: c015b9b6 *pde = 00000000
Oct 23 20:20:05 catee kernel: Oops: 0002 [#6] SMP
Oct 23 20:20:05 catee kernel: Modules linked in: fuse tuner tea5767 tda8290 tuner_simple mt20xx floppy bttv ir_common videobuf_dma_sg btcx_risc tveeprom
Oct 23 20:20:05 catee kernel:
Oct 23 20:20:05 catee kernel: Pid: 3944, comm: watchdog Tainted: G      D (2.6.23-g0b776eb5 #16)
Oct 23 20:20:05 catee kernel: EIP: 0060:[<c015b9b6>] EFLAGS: 00010282 CPU: 0
Oct 23 20:20:05 catee kernel: EIP is at free_pgtables+0x8a/0xb4
Oct 23 20:20:05 catee kernel: EAX: bfbdf000 EBX: c2cfcf50 ECX: 00000000 EDX: 00000018
Oct 23 20:20:05 catee kernel: ESI: c4a5917c EDI: c4995ba8 EBP: bfbca000 ESP: c2cfcf34
Oct 23 20:20:05 catee kernel: DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Oct 23 20:20:05 catee kernel: Process watchdog (pid: 3944, ti=c2cfc000 task=c27d9ab0 task.ti=c2cfc000)
Oct 23 20:20:05 catee kernel: Stack: c34c4ac0 00000000 c015ca2e 00000000 c2cfcf4c 00000000 00000043 c200d180
Oct 23 20:20:05 catee kernel: c34c4ac0 c27d9ab0 00000000 c0121f30 00000001 c0126cb6 c011bbb5 00000000
Oct 23 20:20:05 catee kernel: c2c64fc0 c2f44580 c27d9ab0 c24c7030 00000f68 c242007b c2cf007b 00000004
Oct 23 20:20:05 catee kernel: Call Trace:
Oct 23 20:20:05 catee kernel: [<c015ca2e>] exit_mmap+0x91/0xeb
Oct 23 20:20:05 catee kernel: [<c0121f30>] mmput+0x23/0x7b
Oct 23 20:20:05 catee kernel: [<c0126cb6>] do_exit+0x12f/0x791
Oct 23 20:20:05 catee kernel: [<c011bbb5>] do_page_fault+0xce/0x5c9
Oct 23 20:20:05 catee kernel: [<c012733e>] do_group_exit+0x26/0x6c
Oct 23 20:20:05 catee kernel: [<c0103fde>] sysenter_past_esp+0x5f/0x85
Oct 23 20:20:05 catee kernel: [<c0350000>] packet_recvmsg+0x17b/0x1af
Oct 23 20:20:05 catee kernel: =======================
Oct 23 20:20:05 catee kernel: Code: 12 00 00 85 f6 75 da 89 df 8b 4f 08 8b 44 24 24 89 44 24 04 8b 44 24 08 89 04 24 89 ea 8b 44 24 0c e8 66 f1 ff ff 83 c4 10 5b 5e <c0> 5d c3 89 df 8b 4f 08 89 54 24 04 8b 44 24 08 89 04 24 89 ea
Oct 23 20:20:05 catee kernel: EIP: [<c015b9b6>] free_pgtables+0x8a/0xb4 SS:ESP 0068:c2cfcf34
Oct 23 20:20:05 catee kernel: Fixing recursive fault but reboot is needed!
Oct 23 20:20:05 catee kernel: BUG: unable to handle kernel paging request at virtual address bfbc9fc3
Oct 23 20:20:05 catee kernel: printing eip: c015b9b6 *pde = 00000000
Oct 23 20:20:05 catee kernel: Oops: 0002 [#7] SMP
Oct 23 20:20:05 catee kernel: Modules linked in: fuse tuner tea5767 tda8290 tuner_simple mt20xx floppy bttv ir_common videobuf_dma_sg btcx_risc tveeprom
Oct 23 20:20:05 catee kernel:
Oct 23 20:20:05 catee kernel: Pid: 3945, comm: watchdog Tainted: G      D (2.6.23-g0b776eb5 #16)
Oct 23 20:20:05 catee kernel: EIP: 0060:[<c015b9b6>] EFLAGS: 00010282 CPU: 0
Oct 23 20:20:05 catee kernel: EIP is at free_pgtables+0x8a/0xb4
Oct 23 20:20:05 catee kernel: EAX: bfbdf000 EBX: c3a65f50 ECX: 00000000 EDX: 00000018
Oct 23 20:20:05 catee kernel: ESI: c4995ca4 EDI: c48f8ca4 EBP: bfbca000 ESP: c3a65f34
Oct 23 20:20:05 catee kernel: DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Oct 23 20:20:05 catee kernel: Process watchdog (pid: 3945, ti=c3a65000 task=c49e8030 task.ti=c3a65000)
Oct 23 20:20:05 catee kernel: Stack: c2f12200 00000000 c015ca2e 00000000 c3a65f4c 00000000 00000043 c200d180
Oct 23 20:20:05 catee kernel: c2f12200 c49e8030 00000000 c0121f30 00000001 c0126cb6 c011bbb5 00000000
Oct 23 20:20:05 catee kernel: c34341c0 c2f44580 c49e8030 c24c7030 00000f69 0000007b 0000007b 00000004
Oct 23 20:20:05 catee kernel: Call Trace:
Oct 23 20:20:05 catee kernel: [<c015ca2e>] exit_mmap+0x91/0xeb
Oct 23 20:20:05 catee kernel: [<c0121f30>] mmput+0x23/0x7b
Oct 23 20:20:05 catee kernel: [<c0126cb6>] do_exit+0x12f/0x791
Oct 23 20:20:05 catee kernel: [<c011bbb5>] do_page_fault+0xce/0x5c9
Oct 23 20:20:05 catee kernel: [<c012733e>] do_group_exit+0x26/0x6c
Oct 23 20:20:05 catee kernel: [<c0103fde>] sysenter_past_esp+0x5f/0x85
Oct 23 20:20:05 catee kernel: [<c0350000>] packet_recvmsg+0x17b/0x1af
Oct 23 20:20:05 catee kernel: =======================
Oct 23 20:20:05 catee kernel: Code: 12 00 00 85 f6 75 da 89 df 8b 4f 08 8b 44 24 24 89 44 24 04 8b 44 24 08 89 04 24 89 ea 8b 44 24 0c e8 66 f1 ff ff 83 c4 10 5b 5e <c0> 5d c3 89 df 8b 4f 08 89 54 24 04 8b 44 24 08 89 04 24 89 ea
Oct 23 20:20:05 catee kernel: EIP: [<c015b9b6>] free_pgtables+0x8a/0xb4 SS:ESP 0068:c3a65f34
Oct 23 20:20:05 catee kernel: Fixing recursive fault but reboot is needed!
Oct 23 20:20:05 catee kernel: BUG: unable to handle kernel paging request at virtual address bfbc9fc3
Oct 23 20:20:05 catee kernel: printing eip: c015b9b6 *pde = 00000000
Oct 23 20:20:05 catee kernel: Oops: 0002 [#8] SMP
Oct 23 20:20:05 catee kernel: Modules linked in: fuse tuner tea5767 tda8290 tuner_simple mt20xx floppy bttv ir_common videobuf_dma_sg btcx_risc tveeprom
Oct 23 20:20:05 catee kernel:
Oct 23 20:20:05 catee kernel: Pid: 3946, comm: watchdog Tainted: G      D (2.6.23-g0b776eb5 #16)
Oct 23 20:20:05 catee kernel: EIP: 0060:[<c015b9b6>] EFLAGS: 00010282 CPU: 1
Oct 23 20:20:05 catee kernel: EIP is at free_pgtables+0x8a/0xb4
Oct 23 20:20:05 catee kernel: EAX: bfbdf000 EBX: c2f60f50 ECX: 00000000 EDX: 00000018
Oct 23 20:20:05 catee kernel: ESI: c4333320 EDI: c43bab54 EBP: bfbca000 ESP: c2f60f34
Oct 23 20:20:05 catee kernel: DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Oct 23 20:20:05 catee kernel: Process watchdog (pid: 3946, ti=c2f60000 task=c2de2570 task.ti=c2f60000)
Oct 23 20:20:05 catee kernel: Stack: c2dd7900 00000000 c015ca2e 00000000 c2f60f4c 00000000 00000043 c2015180
Oct 23 20:20:05 catee kernel: c2dd7900 c2de2570 00000000 c0121f30 00000001 c0126cb6 c011bbb5 00000000
Oct 23 20:20:05 catee kernel: c24a61c0 c2f44580 c2de2570 c24c7030 00000f6a 0000007b 0000007b 00000004
Oct 23 20:20:05 catee kernel: Call Trace:
Oct 23 20:20:05 catee kernel: [<c015ca2e>] exit_mmap+0x91/0xeb
Oct 23 20:20:05 catee kernel: [<c0121f30>] mmput+0x23/0x7b
Oct 23 20:20:05 catee kernel: [<c0126cb6>] do_exit+0x12f/0x791
Oct 23 20:20:05 catee kernel: [<c011bbb5>] do_page_fault+0xce/0x5c9
Oct 23 20:20:05 catee kernel: [<c012733e>] do_group_exit+0x26/0x6c
Oct 23 20:20:05 catee kernel: [<c0103fde>] sysenter_past_esp+0x5f/0x85
Oct 23 20:20:05 catee kernel: [<c0350000>] packet_recvmsg+0x17b/0x1af
Oct 23 20:20:05 catee kernel: =======================
Oct 23 20:20:05 catee kernel: Code: 12 00 00 85 f6 75 da 89 df 8b 4f 08 8b 44 24 24 89 44 24 04 8b 44 24 08 89 04 24 89 ea 8b 44 24 0c e8 66 f1 ff ff 83 c4 10 5b 5e <c0> 5d c3 89 df 8b 4f 08 89 54 24 04 8b 44 24 08 89 04 24 89 ea
Oct 23 20:20:05 catee kernel: EIP: [<c015b9b6>] free_pgtables+0x8a/0xb4 SS:ESP 0068:c2f60f34
Oct 23 20:20:05 catee kernel: Fixing recursive fault but reboot is needed!
Oct 23 20:20:05 catee kernel: BUG: unable to handle kernel paging request at virtual address bfbc9fc3
Oct 23 20:20:05 catee kernel: printing eip: c015b9b6 *pde = 00000000
Oct 23 20:20:05 catee kernel: Oops: 0002 [#9] SMP
Oct 23 20:20:05 catee kernel: Modules linked in: fuse tuner tea5767 tda8290 tuner_simple mt20xx floppy bttv ir_common videobuf_dma_sg btcx_risc tveeprom
Oct 23 20:20:05 catee kernel:
Oct 23 20:20:05 catee kernel: Pid: 3947, comm: watchdog Tainted: G      D (2.6.23-g0b776eb5 #16)
Oct 23 20:20:05 catee kernel: EIP: 0060:[<c015b9b6>] EFLAGS: 00010282 CPU: 1
Oct 23 20:20:05 catee kernel: EIP is at free_pgtables+0x8a/0xb4
Oct 23 20:20:05 catee kernel: EAX: bfbdf000 EBX: c3672f50 ECX: 00000000 EDX: 00000018
Oct 23 20:20:05 catee kernel: ESI: c4968908 EDI: c4968f98 EBP: bfbca000 ESP: c3672f34
Oct 23 20:20:05 catee kernel: DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Oct 23 20:20:05 catee kernel: Process watchdog (pid: 3947, ti=c3672000 task=c3417ab0 task.ti=c3672000)
Oct 23 20:20:05 catee kernel: Stack: c3443580 00000000 c015ca2e 00000000 c3672f4c 00000000 00000043 c2015180
Oct 23 20:20:05 catee kernel: c3443580 c3417ab0 00000000 c0121f30 00000001 c0126cb6 c011bbb5 00000000
Oct 23 20:20:05 catee kernel: c2c64140 c2f44580 c3417ab0 c24c7030 00000f6b 0000007b 0000007b 00000004
Oct 23 20:20:05 catee kernel: Call Trace:
Oct 23 20:20:05 catee kernel: [<c015ca2e>] exit_mmap+0x91/0xeb
Oct 23 20:20:05 catee kernel: [<c0121f30>] mmput+0x23/0x7b
Oct 23 20:20:05 catee kernel: [<c0126cb6>] do_exit+0x12f/0x791
Oct 23 20:20:05 catee kernel: [<c011bbb5>] do_page_fault+0xce/0x5c9
Oct 23 20:20:05 catee kernel: [<c012733e>] do_group_exit+0x26/0x6c
Oct 23 20:20:05 catee kernel: [<c0103fde>] sysenter_past_esp+0x5f/0x85
Oct 23 20:20:05 catee kernel: [<c0350000>] packet_recvmsg+0x17b/0x1af
Oct 23 20:20:05 catee kernel: =======================
Oct 23 20:20:05 catee kernel: Code: 12 00 00 85 f6 75 da 89 df 8b 4f 08 8b 44 24 24 89 44 24 04 8b 44 24 08 89 04 24 89 ea 8b 44 24 0c e8 66 f1 ff ff 83 c4 10 5b 5e <c0> 5d c3 89 df 8b 4f 08 89 54 24 04 8b 44 24 08 89 04 24 89 ea
Oct 23 20:20:05 catee kernel: EIP: [<c015b9b6>] free_pgtables+0x8a/0xb4 SS:ESP 0068:c3672f34
Oct 23 20:20:05 catee kernel: Fixing recursive fault but reboot is needed!
Oct 23 20:20:05 catee kernel: invalid opcode: 0000 [#10] SMP
Oct 23 20:20:05 catee kernel: Modules linked in: fuse tuner tea5767 tda8290 tuner_simple mt20xx floppy bttv ir_common videobuf_dma_sg btcx_risc tveeprom
Oct 23 20:20:05 catee kernel:
Oct 23 20:20:05 catee kernel: Pid: 3317, comm: kopete Tainted: G      D (2.6.23-g0b776eb5 #16)
Oct 23 20:20:05 catee kernel: EIP: 0060:[<c015b9ba>] EFLAGS: 00210286 CPU: 0
Oct 23 20:20:05 catee kernel: EIP is at free_pgtables+0x8e/0xb4
Oct 23 20:20:05 catee kernel: EAX: b5afcfff EBX: c4a0ef64 ECX: b5efd000 EDX: b5efc000
Oct 23 20:20:05 catee kernel: ESI: c2cc2c80 EDI: c49a0bfc EBP: b5efc000 ESP: c4a0ef44
Oct 23 20:20:05 catee kernel: DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Oct 23 20:20:05 catee kernel: Process kopete (pid: 3317, ti=c4a0e000 task=c49e8ab0 task.ti=c4a0e000)
Oct 23 20:20:05 catee kernel: Stack: c48a5ef0 c49c8df4 c015c911 b5efd000 c4a0ef60 00000000 c49a0bfc 00000001
Oct 23 20:20:05 catee kernel: c200d180 b5efc000 c2cc2c80 c49a0bfc c49a0bfc c015d350 b5efc000 b5efd000
Oct 23 20:20:05 catee kernel: c2cc2c84 c48a5ef0 b5efd000 c48a5efc c48a5ef0 c2cc2c80 c2cc2cb4 00000000
Oct 23 20:20:05 catee kernel: Call Trace:
Oct 23 20:20:05 catee kernel: [<c015c911>] unmap_region+0xc1/0x112
Oct 23 20:20:05 catee kernel: [<c015d350>] do_munmap+0x137/0x1c7
Oct 23 20:20:05 catee kernel: [<c015d407>] sys_munmap+0x27/0x35
Oct 23 20:20:05 catee kernel: [<c0103fde>] sysenter_past_esp+0x5f/0x85
Oct 23 20:20:05 catee kernel: =======================
Oct 23 20:20:05 catee kernel: Code: f6 75 da 89 df 8b 4f 08 8b 44 24 24 89 44 24 04 8b 44 24 08 89 04 24 89 ea 8b 44 24 0c e8 66 f1 ff ff 83 c4 10 5b 5e c0 5d c3 89 <df> 8b 4f 08 89 54 24 04 8b 44 24 08 89 04 24 89 ea 8b 44 24 0c
Oct 23 20:20:05 catee kernel: EIP: [<c015b9ba>] free_pgtables+0x8e/0xb4 SS:ESP 0068:c4a0ef44
Oct 23 20:20:05 catee kernel: BUG: unable to handle kernel paging request at virtual address bfbc9fc3
Oct 23 20:20:05 catee kernel: printing eip: c015b9b6 *pde = 00000000
Oct 23 20:20:05 catee kernel: Oops: 0002 [#11] SMP
Oct 23 20:20:05 catee kernel: Modules linked in: fuse tuner tea5767 tda8290 tuner_simple mt20xx floppy bttv ir_common videobuf_dma_sg btcx_risc tveeprom
Oct 23 20:20:05 catee kernel:
Oct 23 20:20:05 catee kernel: Pid: 3948, comm: watchdog Tainted: G      D (2.6.23-g0b776eb5 #16)
Oct 23 20:20:05 catee kernel: EIP: 0060:[<c015b9b6>] EFLAGS: 00010282 CPU: 1
Oct 23 20:20:05 catee kernel: EIP is at free_pgtables+0x8a/0xb4
Oct 23 20:20:05 catee kernel: EAX: bfbdf000 EBX: c2f8af50 ECX: 00000000 EDX: 00000018
Oct 23 20:20:05 catee kernel: ESI: c48a9860 EDI: c48a9668 EBP: bfbca000 ESP: c2f8af34
Oct 23 20:20:05 catee kernel: DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Oct 23 20:20:05 catee kernel: Process watchdog (pid: 3948, ti=c2f8a000 task=c3637030 task.ti=c2f8a000)
Oct 23 20:20:05 catee kernel: Stack: c34033c0 00000000 c015ca2e 00000000 c2f8af4c 00000000 00000043 c2015180
Oct 23 20:20:05 catee kernel: c34033c0 c3637030 00000000 c0121f30 00000001 c0126cb6 c011bbb5 00000000
Oct 23 20:20:05 catee kernel: c253d500 c2f44580 c3637030 c24c7030 00000f6c c242007b c2f8007b 00000004
Oct 23 20:20:05 catee kernel: Call Trace:
Oct 23 20:20:05 catee kernel: [<c015ca2e>] exit_mmap+0x91/0xeb
Oct 23 20:20:05 catee kernel: [<c0121f30>] mmput+0x23/0x7b
Oct 23 20:20:05 catee kernel: [<c0126cb6>] do_exit+0x12f/0x791
Oct 23 20:20:05 catee kernel: [<c011bbb5>] do_page_fault+0xce/0x5c9
Oct 23 20:20:05 catee kernel: [<c012733e>] do_group_exit+0x26/0x6c
Oct 23 20:20:05 catee kernel: [<c0103fde>] sysenter_past_esp+0x5f/0x85
Oct 23 20:20:05 catee kernel: [<c0350000>] packet_recvmsg+0x17b/0x1af
Oct 23 20:20:05 catee kernel: =======================
Oct 23 20:20:05 catee kernel: Code: 12 00 00 85 f6 75 da 89 df 8b 4f 08 8b 44 24 24 89 44 24 04 8b 44 24 08 89 04 24 89 ea 8b 44 24 0c e8 66 f1 ff ff 83 c4 10 5b 5e <c0> 5d c3 89 df 8b 4f 08 89 54 24 04 8b 44 24 08 89 04 24 89 ea
Oct 23 20:20:05 catee kernel: EIP: [<c015b9b6>] free_pgtables+0x8a/0xb4 SS:ESP 0068:c2f8af34
Oct 23 20:20:05 catee kernel: Fixing recursive fault but reboot is needed!
Oct 23 20:20:05 catee kernel: BUG: unable to handle kernel paging request at virtual address bfbc9fc3
Oct 23 20:20:05 catee kernel: printing eip: c015b9b6 *pde = 00000000
Oct 23 20:20:05 catee kernel: Oops: 0002 [#12] SMP
Oct 23 20:20:05 catee kernel: Modules linked in: fuse tuner tea5767 tda8290 tuner_simple mt20xx floppy bttv ir_common videobuf_dma_sg btcx_risc tveeprom
Oct 23 20:20:05 catee kernel:
Oct 23 20:20:05 catee kernel: Pid: 3949, comm: watchdog Tainted: G      D (2.6.23-g0b776eb5 #16)
Oct 23 20:20:05 catee kernel: EIP: 0060:[<c015b9b6>] EFLAGS: 00010282 CPU: 1
Oct 23 20:20:05 catee kernel: EIP is at free_pgtables+0x8a/0xb4
Oct 23 20:20:05 catee kernel: EAX: bfbdf000 EBX: c4aaaf50 ECX: 00000000 EDX: 00000018
Oct 23 20:20:05 catee kernel: ESI: c48a256c EDI: c3a6abfc EBP: bfbca000 ESP: c4aaaf34
Oct 23 20:20:05 catee kernel: DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Oct 23 20:20:05 catee kernel: Process watchdog (pid: 3949, ti=c4aaa000 task=c4821ab0 task.ti=c4aaa000)
Oct 23 20:20:05 catee kernel: Stack: c2dc83c0 00000000 c015ca2e 00000000 c4aaaf4c 00000000 00000043 c2015180
Oct 23 20:20:05 catee kernel: c2dc83c0 c4821ab0 00000000 c0121f30 00000001 c0126cb6 c011bbb5 00000000
Oct 23 20:20:05 catee kernel: c3434780 c2f44580 c4821ab0 c24c7030 00000f6d 0000007b 0000007b 00000004
Oct 23 20:20:05 catee kernel: Call Trace:
Oct 23 20:20:05 catee kernel: [<c015ca2e>] exit_mmap+0x91/0xeb
Oct 23 20:20:05 catee kernel: [<c0121f30>] mmput+0x23/0x7b
Oct 23 20:20:05 catee kernel: [<c0126cb6>] do_exit+0x12f/0x791
Oct 23 20:20:05 catee kernel: [<c011bbb5>] do_page_fault+0xce/0x5c9
Oct 23 20:20:05 catee kernel: [<c012733e>] do_group_exit+0x26/0x6c
Oct 23 20:20:05 catee kernel: [<c0103fde>] sysenter_past_esp+0x5f/0x85
Oct 23 20:20:05 catee kernel: [<c0350000>] packet_recvmsg+0x17b/0x1af
Oct 23 20:20:05 catee kernel: =======================
Oct 23 20:20:05 catee kernel: Code: 12 00 00 85 f6 75 da 89 df 8b 4f 08 8b 44 24 24 89 44 24 04 8b 44 24 08 89 04 24 89 ea 8b 44 24 0c e8 66 f1 ff ff 83 c4 10 5b 5e <c0> 5d c3 89 df 8b 4f 08 89 54 24 04 8b 44 24 08 89 04 24 89 ea
Oct 23 20:20:05 catee kernel: EIP: [<c015b9b6>] free_pgtables+0x8a/0xb4 SS:ESP 0068:c4aaaf34
Oct 23 20:20:05 catee kernel: Fixing recursive fault but reboot is needed!
Oct 23 20:20:05 catee kernel: BUG: unable to handle kernel paging request at virtual address bfbc9fc3
Oct 23 20:20:05 catee kernel: printing eip: c015b9b6 *pde = 00000000
Oct 23 20:20:05 catee kernel: Oops: 0002 [#13] SMP
Oct 23 20:20:05 catee kernel: Modules linked in: fuse tuner tea5767 tda8290 tuner_simple mt20xx floppy bttv ir_common videobuf_dma_sg btcx_risc tveeprom
Oct 23 20:20:05 catee kernel:
Oct 23 20:20:05 catee kernel: Pid: 3950, comm: watchdog Tainted: G      D (2.6.23-g0b776eb5 #16)
Oct 23 20:20:05 catee kernel: EIP: 0060:[<c015b9b6>] EFLAGS: 00010282 CPU: 1
Oct 23 20:20:05 catee kernel: EIP is at free_pgtables+0x8a/0xb4
Oct 23 20:20:05 catee kernel: EAX: bfbdf000 EBX: c4a87f50 ECX: 00000000 EDX: 00000018
Oct 23 20:20:05 catee kernel: ESI: c48a28b4 EDI: c48a21d0 EBP: bfbca000 ESP: c4a87f34
Oct 23 20:20:05 catee kernel: DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Oct 23 20:20:05 catee kernel: Process watchdog (pid: 3950, ti=c4a87000 task=c2469030 task.ti=c4a87000)
Oct 23 20:20:05 catee kernel: Stack: c3484c80 00000000 c015ca2e 00000000 c4a87f4c 00000000 00000043 c2015180
Oct 23 20:20:05 catee kernel: c3484c80 c2469030 00000000 c0121f30 00000001 c0126cb6 c011bbb5 00000000
Oct 23 20:20:05 catee kernel: c24a6a40 c2f44580 c2469030 c24c7030 00000f6e 0000007b 0000007b 00000004
Oct 23 20:20:05 catee kernel: Call Trace:
Oct 23 20:20:05 catee kernel: [<c015ca2e>] exit_mmap+0x91/0xeb
Oct 23 20:20:05 catee kernel: [<c0121f30>] mmput+0x23/0x7b
Oct 23 20:20:05 catee kernel: [<c0126cb6>] do_exit+0x12f/0x791
Oct 23 20:20:05 catee kernel: [<c011bbb5>] do_page_fault+0xce/0x5c9
Oct 23 20:20:05 catee kernel: [<c012733e>] do_group_exit+0x26/0x6c
Oct 23 20:20:05 catee kernel: [<c0103fde>] sysenter_past_esp+0x5f/0x85
Oct 23 20:20:05 catee kernel: [<c0350000>] packet_recvmsg+0x17b/0x1af
Oct 23 20:20:05 catee kernel: =======================
Oct 23 20:20:05 catee kernel: Code: 12 00 00 85 f6 75 da 89 df 8b 4f 08 8b 44 24 24 89 44 24 04 8b 44 24 08 89 04 24 89 ea 8b 44 24 0c e8 66 f1 ff ff 83 c4 10 5b 5e <c0> 5d c3 89 df 8b 4f 08 89 54 24 04 8b 44 24 08 89 04 24 89 ea
Oct 23 20:20:05 catee kernel: EIP: [<c015b9b6>] free_pgtables+0x8a/0xb4 SS:ESP 0068:c4a87f34
Oct 23 20:20:05 catee kernel: Fixing recursive fault but reboot is needed!
Oct 23 20:20:05 catee kernel: BUG: unable to handle kernel paging request at virtual address bfbc9fc3
Oct 23 20:20:05 catee kernel: printing eip: c015b9b6 *pde = 00000000
Oct 23 20:20:05 catee kernel: Oops: 0002 [#14] SMP
Oct 23 20:20:05 catee kernel: Modules linked in: fuse tuner tea5767 tda8290 tuner_simple mt20xx floppy bttv ir_common videobuf_dma_sg btcx_risc tveeprom
Oct 23 20:20:05 catee kernel:
Oct 23 20:20:05 catee kernel: Pid: 3951, comm: watchdog Tainted: G      D (2.6.23-g0b776eb5 #16)
Oct 23 20:20:05 catee kernel: EIP: 0060:[<c015b9b6>] EFLAGS: 00010282 CPU: 1
Oct 23 20:20:05 catee kernel: EIP is at free_pgtables+0x8a/0xb4
Oct 23 20:20:05 catee kernel: EAX: bfbdf000 EBX: c3a6ef50 ECX: 00000000 EDX: 00000018
Oct 23 20:20:05 catee kernel: ESI: c4814764 EDI: c39b0e9c EBP: bfbca000 ESP: c3a6ef34
Oct 23 20:20:05 catee kernel: DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Oct 23 20:20:05 catee kernel: Process watchdog (pid: 3951, ti=c3a6e000 task=c24c3570 task.ti=c3a6e000)
Oct 23 20:20:05 catee kernel: Stack: c3443900 00000000 c015ca2e 00000000 c3a6ef4c 00000000 00000043 c2015180
Oct 23 20:20:05 catee kernel: c3443900 c24c3570 00000000 c0121f30 00000001 c0126cb6 c011bbb5 00000000
Oct 23 20:20:05 catee kernel: c2c64c80 c2f44580 c24c3570 c24c7030 00000f6f 0000007b 0000007b 00000004
Oct 23 20:20:05 catee kernel: Call Trace:
Oct 23 20:20:05 catee kernel: [<c015ca2e>] exit_mmap+0x91/0xeb
Oct 23 20:20:05 catee kernel: [<c0121f30>] mmput+0x23/0x7b
Oct 23 20:20:05 catee kernel: [<c0126cb6>] do_exit+0x12f/0x791
Oct 23 20:20:05 catee kernel: [<c011bbb5>] do_page_fault+0xce/0x5c9
Oct 23 20:20:05 catee kernel: [<c012733e>] do_group_exit+0x26/0x6c
Oct 23 20:20:05 catee kernel: [<c0103fde>] sysenter_past_esp+0x5f/0x85
Oct 23 20:20:05 catee kernel: [<c0350000>] packet_recvmsg+0x17b/0x1af
Oct 23 20:20:05 catee kernel: =======================
Oct 23 20:20:05 catee kernel: Code: 12 00 00 85 f6 75 da 89 df 8b 4f 08 8b 44 24 24 89 44 24 04 8b 44 24 08 89 04 24 89 ea 8b 44 24 0c e8 66 f1 ff ff 83 c4 10 5b 5e <c0> 5d c3 89 df 8b 4f 08 89 54 24 04 8b 44 24 08 89 04 24 89 ea
Oct 23 20:20:05 catee kernel: EIP: [<c015b9b6>] free_pgtables+0x8a/0xb4 SS:ESP 0068:c3a6ef34
Oct 23 20:20:05 catee kernel: Fixing recursive fault but reboot is needed!
Oct 23 20:20:05 catee kernel: BUG: unable to handle kernel paging request at virtual address bfbc9fc3
Oct 23 20:20:05 catee kernel: printing eip: c015b9b6 *pde = 00000000
Oct 23 20:20:05 catee kernel: Oops: 0002 [#15] SMP
Oct 23 20:20:05 catee kernel: Modules linked in: fuse tuner tea5767 tda8290 tuner_simple mt20xx floppy bttv ir_common videobuf_dma_sg btcx_risc tveeprom
Oct 23 20:20:05 catee kernel:
Oct 23 20:20:05 catee kernel: Pid: 3952, comm: watchdog Tainted: G      D (2.6.23-g0b776eb5 #16)
Oct 23 20:20:05 catee kernel: EIP: 0060:[<c015b9b6>] EFLAGS: 00010282 CPU: 1
Oct 23 20:20:05 catee kernel: EIP is at free_pgtables+0x8a/0xb4
Oct 23 20:20:05 catee kernel: EAX: bfbdf000 EBX: c432df50 ECX: 00000000 EDX: 00000018
Oct 23 20:20:05 catee kernel: ESI: c48143c8 EDI: c4814ca4 EBP: bfbca000 ESP: c432df34
Oct 23 20:20:05 catee kernel: DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Oct 23 20:20:05 catee kernel: Process watchdog (pid: 3952, ti=c432d000 task=c2c94030 task.ti=c432d000)
Oct 23 20:20:05 catee kernel: Stack: c2f443c0 00000000 c015ca2e 00000000 c432df4c 00000000 00000043 c2015180
Oct 23 20:20:05 catee kernel: c2f443c0 c2c94030 00000000 c0121f30 00000001 c0126cb6 c011bbb5 00000000
Oct 23 20:20:05 catee kernel: c253dac0 c2f44580 c2c94030 c24c7030 00000f70 0000007b 0000007b 00000004
Oct 23 20:20:05 catee kernel: Call Trace:
Oct 23 20:20:05 catee kernel: [<c015ca2e>] exit_mmap+0x91/0xeb
Oct 23 20:20:05 catee kernel: [<c0121f30>] mmput+0x23/0x7b
Oct 23 20:20:05 catee kernel: [<c0126cb6>] do_exit+0x12f/0x791
Oct 23 20:20:05 catee kernel: [<c011bbb5>] do_page_fault+0xce/0x5c9
Oct 23 20:20:05 catee kernel: [<c012733e>] do_group_exit+0x26/0x6c
Oct 23 20:20:05 catee kernel: [<c0103fde>] sysenter_past_esp+0x5f/0x85
Oct 23 20:20:05 catee kernel: [<c0350000>] packet_recvmsg+0x17b/0x1af
Oct 23 20:20:05 catee kernel: =======================
Oct 23 20:20:05 catee kernel: Code: 12 00 00 85 f6 75 da 89 df 8b 4f 08 8b 44 24 24 89 44 24 04 8b 44 24 08 89 04 24 89 ea 8b 44 24 0c e8 66 f1 ff ff 83 c4 10 5b 5e <c0> 5d c3 89 df 8b 4f 08 89 54 24 04 8b 44 24 08 89 04 24 89 ea
Oct 23 20:20:05 catee kernel: EIP: [<c015b9b6>] free_pgtables+0x8a/0xb4 SS:ESP 0068:c432df34
Oct 23 20:20:05 catee kernel: Fixing recursive fault but reboot is needed!
Oct 23 20:20:05 catee kernel: BUG: unable to handle kernel paging request at virtual address bfbc9fc3
Oct 23 20:20:05 catee kernel: printing eip: c015b9b6 *pde = 00000000
Oct 23 20:20:05 catee kernel: Oops: 0002 [#16] SMP
Oct 23 20:20:05 catee kernel: Modules linked in: fuse tuner tea5767 tda8290 tuner_simple mt20xx floppy bttv ir_common videobuf_dma_sg btcx_risc tveeprom
Oct 23 20:20:05 catee kernel:
Oct 23 20:20:05 catee kernel: Pid: 3953, comm: watchdog Tainted: G      D (2.6.23-g0b776eb5 #16)
Oct 23 20:20:05 catee kernel: EIP: 0060:[<c015b9b6>] EFLAGS: 00010282 CPU: 1
Oct 23 20:20:05 catee kernel: EIP is at free_pgtables+0x8a/0xb4
Oct 23 20:20:05 catee kernel: EAX: bfbdf000 EBX: c4983f50 ECX: 00000000 EDX: 00000018
Oct 23 20:20:05 catee kernel: ESI: c4a82320 EDI: c4a82c50 EBP: bfbca000 ESP: c4983f34
Oct 23 20:20:05 catee kernel: DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Oct 23 20:20:05 catee kernel: Process watchdog (pid: 3953, ti=c4983000 task=c3a64ab0 task.ti=c4983000)
Oct 23 20:20:05 catee kernel: Stack: c3968e40 00000000 c015ca2e 00000000 c4983f4c 00000000 00000043 c2015180
Oct 23 20:20:05 catee kernel: c3968e40 c3a64ab0 00000000 c0121f30 00000001 c0126cb6 c011bbb5 00000000
Oct 23 20:20:05 catee kernel: c3434800 c2f44580 c3a64ab0 c24c7030 00000f71 0000007b 0000007b 00000004
Oct 23 20:20:05 catee kernel: Call Trace:
Oct 23 20:20:05 catee kernel: [<c015ca2e>] exit_mmap+0x91/0xeb
Oct 23 20:20:05 catee kernel: [<c0121f30>] mmput+0x23/0x7b
Oct 23 20:20:05 catee kernel: [<c0126cb6>] do_exit+0x12f/0x791
Oct 23 20:20:05 catee kernel: [<c011bbb5>] do_page_fault+0xce/0x5c9
Oct 23 20:20:05 catee kernel: [<c012733e>] do_group_exit+0x26/0x6c
Oct 23 20:20:05 catee kernel: [<c0103fde>] sysenter_past_esp+0x5f/0x85
Oct 23 20:20:05 catee kernel: [<c0350000>] packet_recvmsg+0x17b/0x1af
Oct 23 20:20:05 catee kernel: =======================
Oct 23 20:20:05 catee kernel: Code: 12 00 00 85 f6 75 da 89 df 8b 4f 08 8b 44 24 24 89 44 24 04 8b 44 24 08 89 04 24 89 ea 8b 44 24 0c e8 66 f1 ff ff 83 c4 10 5b 5e <c0> 5d c3 89 df 8b 4f 08 89 54 24 04 8b 44 24 08 89 04 24 89 ea
Oct 23 20:20:05 catee kernel: EIP: [<c015b9b6>] free_pgtables+0x8a/0xb4 SS:ESP 0068:c4983f34
Oct 23 20:20:05 catee kernel: Fixing recursive fault but reboot is needed!
Oct 23 20:20:05 catee kernel: BUG: unable to handle kernel paging request at virtual address bfbc9fc3
Oct 23 20:20:05 catee kernel: printing eip: c015b9b6 *pde = 00000000
Oct 23 20:20:05 catee kernel: Oops: 0002 [#17] SMP
Oct 23 20:20:05 catee kernel: Modules linked in: fuse tuner tea5767 tda8290 tuner_simple mt20xx floppy bttv ir_common videobuf_dma_sg btcx_risc tveeprom
Oct 23 20:20:05 catee kernel:
Oct 23 20:20:05 catee kernel: Pid: 3954, comm: watchdog Tainted: G      D (2.6.23-g0b776eb5 #16)
Oct 23 20:20:05 catee kernel: EIP: 0060:[<c015b9b6>] EFLAGS: 00010282 CPU: 1
Oct 23 20:20:05 catee kernel: EIP is at free_pgtables+0x8a/0xb4
Oct 23 20:20:05 catee kernel: EAX: bfbdf000 EBX: c48e3f50 ECX: 00000000 EDX: 00000018
Oct 23 20:20:05 catee kernel: ESI: c42e44c4 EDI: c39564c4 EBP: bfbca000 ESP: c48e3f34
Oct 23 20:20:05 catee kernel: DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Oct 23 20:20:05 catee kernel: Process watchdog (pid: 3954, ti=c48e3000 task=c42dd030 task.ti=c48e3000)
Oct 23 20:20:05 catee kernel: Stack: c3484900 00000000 c015ca2e 00000000 c48e3f4c 00000000 00000043 c2015180
Oct 23 20:20:05 catee kernel: c3484900 c42dd030 00000000 c0121f30 00000001 c0126cb6 c011bbb5 00000000
Oct 23 20:20:05 catee kernel: c24a6fc0 c2f44580 c42dd030 c24c7030 00000f72 0000007b 0000007b 00000004
Oct 23 20:20:05 catee kernel: Call Trace:
Oct 23 20:20:05 catee kernel: [<c015ca2e>] exit_mmap+0x91/0xeb
Oct 23 20:20:05 catee kernel: [<c0121f30>] mmput+0x23/0x7b
Oct 23 20:20:05 catee kernel: [<c0126cb6>] do_exit+0x12f/0x791
Oct 23 20:20:05 catee kernel: [<c011bbb5>] do_page_fault+0xce/0x5c9
Oct 23 20:20:05 catee kernel: [<c012733e>] do_group_exit+0x26/0x6c
Oct 23 20:20:05 catee kernel: [<c0103fde>] sysenter_past_esp+0x5f/0x85
Oct 23 20:20:05 catee kernel: [<c0350000>] packet_recvmsg+0x17b/0x1af
Oct 23 20:20:05 catee kernel: =======================
Oct 23 20:20:05 catee kernel: Code: 12 00 00 85 f6 75 da 89 df 8b 4f 08 8b 44 24 24 89 44 24 04 8b 44 24 08 89 04 24 89 ea 8b 44 24 0c e8 66 f1 ff ff 83 c4 10 5b 5e <c0> 5d c3 89 df 8b 4f 08 89 54 24 04 8b 44 24 08 89 04 24 89 ea
Oct 23 20:20:05 catee kernel: EIP: [<c015b9b6>] free_pgtables+0x8a/0xb4 SS:ESP 0068:c48e3f34
Oct 23 20:20:05 catee kernel: Fixing recursive fault but reboot is needed!
Oct 23 20:20:05 catee kernel: BUG: unable to handle kernel paging request at virtual address bfbc9fc3
Oct 23 20:20:05 catee kernel: printing eip: c015b9b6 *pde = 00000000
Oct 23 20:20:05 catee kernel: Oops: 0002 [#18] SMP
Oct 23 20:20:05 catee kernel: Modules linked in: fuse tuner tea5767 tda8290 tuner_simple mt20xx floppy bttv ir_common videobuf_dma_sg btcx_risc tveeprom
Oct 23 20:20:05 catee kernel:
Oct 23 20:20:05 catee kernel: Pid: 3955, comm: watchdog Tainted: G      D (2.6.23-g0b776eb5 #16)
Oct 23 20:20:05 catee kernel: EIP: 0060:[<c015b9b6>] EFLAGS: 00010282 CPU: 1
Oct 23 20:20:05 catee kernel: EIP is at free_pgtables+0x8a/0xb4
Oct 23 20:20:05 catee kernel: EAX: bfbdf000 EBX: c4335f50 ECX: 00000000 EDX: 00000018
Oct 23 20:20:05 catee kernel: ESI: c42e4320 EDI: c42e4614 EBP: bfbca000 ESP: c4335f34
Oct 23 20:20:05 catee kernel: DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Oct 23 20:20:05 catee kernel: Process watchdog (pid: 3955, ti=c4335000 task=c4821030 task.ti=c4335000)
Oct 23 20:20:05 catee kernel: Stack: c257de40 00000000 c015ca2e 00000000 c4335f4c 00000000 00000043 c2015180
Oct 23 20:20:05 catee kernel: c257de40 c4821030 00000000 c0121f30 00000001 c0126cb6 c011bbb5 00000000
Oct 23 20:20:05 catee kernel: c2c64200 c2f44580 c4821030 c24c7030 00000f73 c242007b c433007b 00000004
Oct 23 20:20:05 catee kernel: Call Trace:
Oct 23 20:20:05 catee kernel: [<c015ca2e>] exit_mmap+0x91/0xeb
Oct 23 20:20:05 catee kernel: [<c0121f30>] mmput+0x23/0x7b
Oct 23 20:20:05 catee kernel: [<c0126cb6>] do_exit+0x12f/0x791
Oct 23 20:20:05 catee kernel: [<c011bbb5>] do_page_fault+0xce/0x5c9
Oct 23 20:20:05 catee kernel: [<c012733e>] do_group_exit+0x26/0x6c
Oct 23 20:20:05 catee kernel: [<c0103fde>] sysenter_past_esp+0x5f/0x85
Oct 23 20:20:05 catee kernel: [<c0350000>] packet_recvmsg+0x17b/0x1af
Oct 23 20:20:05 catee kernel: =======================
Oct 23 20:20:05 catee kernel: Code: 12 00 00 85 f6 75 da 89 df 8b 4f 08 8b 44 24 24 89 44 24 04 8b 44 24 08 89 04 24 89 ea 8b 44 24 0c e8 66 f1 ff ff 83 c4 10 5b 5e <c0> 5d c3 89 df 8b 4f 08 89 54 24 04 8b 44 24 08 89 04 24 89 ea
Oct 23 20:20:05 catee kernel: EIP: [<c015b9b6>] free_pgtables+0x8a/0xb4 SS:ESP 0068:c4335f34
Oct 23 20:20:05 catee kernel: Fixing recursive fault but reboot is needed!
Oct 23 20:20:05 catee kernel: BUG: unable to handle kernel paging request at virtual address b7f1dfc3
Oct 23 20:20:05 catee kernel: printing eip: c015b9b6 *pde = 0480b067 *pte = 00000000
Oct 23 20:20:05 catee kernel: Oops: 0002 [#19] SMP
Oct 23 20:20:05 catee kernel: Modules linked in: fuse tuner tea5767 tda8290 tuner_simple mt20xx floppy bttv ir_common videobuf_dma_sg btcx_risc tveeprom
Oct 23 20:20:05 catee kernel:
Oct 23 20:20:05 catee kernel: Pid: 3956, comm: cron Tainted: G      D (2.6.23-g0b776eb5 #16)
Oct 23 20:20:05 catee kernel: EIP: 0060:[<c015b9b6>] EFLAGS: 00010286 CPU: 2
Oct 23 20:20:05 catee kernel: EIP is at free_pgtables+0x8a/0xb4
Oct 23 20:20:05 catee kernel: EAX: b7b1efff EBX: c3a47f64 ECX: b7f1f000 EDX: b7f1e000
Oct 23 20:20:05 catee kernel: ESI: c2f44ac0 EDI: c49b0470 EBP: b7f1e000 ESP: c3a47f44
Oct 23 20:20:05 catee kernel: DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Oct 23 20:20:05 catee kernel: Process cron (pid: 3956, ti=c3a47000 task=c3409030 task.ti=c3a47000)
Oct 23 20:20:05 catee kernel: Stack: c43cf4c4 c49b05c0 c015c911 b7f1f000 c3a47f60 00000000 c49b0470 00000001
Oct 23 20:20:05 catee kernel: c201d180 b7f1e000 c2f44ac0 c49b0470 c49b0470 c015d350 b7f1e000 b7f1f000
Oct 23 20:20:05 catee kernel: c2f44ac4 c43cf4c4 b7f1f000 c43cf4d0 c43cf4c4 c2f44ac0 c2f44af4 00000000
Oct 23 20:20:05 catee kernel: Call Trace:
Oct 23 20:20:05 catee kernel: [<c015c911>] unmap_region+0xc1/0x112
Oct 23 20:20:05 catee kernel: [<c015d350>] do_munmap+0x137/0x1c7
Oct 23 20:20:05 catee kernel: [<c015d407>] sys_munmap+0x27/0x35
Oct 23 20:20:05 catee kernel: [<c0103fde>] sysenter_past_esp+0x5f/0x85
Oct 23 20:20:05 catee kernel: =======================
Oct 23 20:20:05 catee kernel: Code: 12 00 00 85 f6 75 da 89 df 8b 4f 08 8b 44 24 24 89 44 24 04 8b 44 24 08 89 04 24 89 ea 8b 44 24 0c e8 66 f1 ff ff 83 c4 10 5b 5e <c0> 5d c3 89 df 8b 4f 08 89 54 24 04 8b 44 24 08 89 04 24 89 ea
Oct 23 20:20:05 catee kernel: EIP: [<c015b9b6>] free_pgtables+0x8a/0xb4 SS:ESP 0068:c3a47f44
Oct 23 20:20:05 catee kernel: BUG: unable to handle kernel paging request at virtual address bfbc9fc3
Oct 23 20:20:05 catee kernel: printing eip: c015b9b6 *pde = 00000000
Oct 23 20:20:05 catee kernel: Oops: 0002 [#20] SMP
Oct 23 20:20:05 catee kernel: Modules linked in: fuse tuner tea5767 tda8290 tuner_simple mt20xx floppy bttv ir_common videobuf_dma_sg btcx_risc tveeprom
Oct 23 20:20:05 catee kernel:
Oct 23 20:20:05 catee kernel: Pid: 3957, comm: watchdog Tainted: G      D (2.6.23-g0b776eb5 #16)
Oct 23 20:20:05 catee kernel: EIP: 0060:[<c015b9b6>] EFLAGS: 00010282 CPU: 0
Oct 23 20:20:05 catee kernel: EIP is at free_pgtables+0x8a/0xb4
Oct 23 20:20:05 catee kernel: EAX: bfbdf000 EBX: c348cf50 ECX: 00000000 EDX: 00000018
Oct 23 20:20:05 catee kernel: ESI: c48235c0 EDI: c43cf17c EBP: bfbca000 ESP: c348cf34
Oct 23 20:20:05 catee kernel: DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Oct 23 20:20:05 catee kernel: Process watchdog (pid: 3957, ti=c348c000 task=c4292570 task.ti=c348c000)
Oct 23 20:20:05 catee kernel: Stack: c3968200 00000000 c015ca2e 00000000 c348cf4c 00000000 00000043 c200d180
Oct 23 20:20:05 catee kernel: c3968200 c4292570 00000000 c0121f30 00000001 c0126cb6 c011bbb5 00000000
Oct 23 20:20:05 catee kernel: c253d140 c2f44580 c4292570 c24c7030 00000f75 0000007b 0000007b 00000004
Oct 23 20:20:05 catee kernel: Call Trace:
Oct 23 20:20:05 catee kernel: [<c015ca2e>] exit_mmap+0x91/0xeb
Oct 23 20:20:05 catee kernel: [<c0121f30>] mmput+0x23/0x7b
Oct 23 20:20:05 catee kernel: [<c0126cb6>] do_exit+0x12f/0x791
Oct 23 20:20:05 catee kernel: [<c011bbb5>] do_page_fault+0xce/0x5c9
Oct 23 20:20:05 catee kernel: [<c012733e>] do_group_exit+0x26/0x6c
Oct 23 20:20:05 catee kernel: [<c0103fde>] sysenter_past_esp+0x5f/0x85
Oct 23 20:20:05 catee kernel: [<c0350000>] packet_recvmsg+0x17b/0x1af
Oct 23 20:20:05 catee kernel: =======================
Oct 23 20:20:05 catee kernel: Code: 12 00 00 85 f6 75 da 89 df 8b 4f 08 8b 44 24 24 89 44 24 04 8b 44 24 08 89 04 24 89 ea 8b 44 24 0c e8 66 f1 ff ff 83 c4 10 5b 5e <c0> 5d c3 89 df 8b 4f 08 89 54 24 04 8b 44 24 08 89 04 24 89 ea
Oct 23 20:20:05 catee kernel: EIP: [<c015b9b6>] free_pgtables+0x8a/0xb4 SS:ESP 0068:c348cf34
Oct 23 20:20:05 catee kernel: Fixing recursive fault but reboot is needed!
Oct 23 20:20:21 catee kernel: BUG: unable to handle kernel paging request at virtual address bfbc9fc3
Oct 23 20:20:21 catee kernel: printing eip: c015b9b6 *pde = 00000000
Oct 23 20:20:21 catee kernel: Oops: 0002 [#21] SMP
Oct 23 20:20:21 catee kernel: Modules linked in: fuse tuner tea5767 tda8290 tuner_simple mt20xx floppy bttv ir_common videobuf_dma_sg btcx_risc tveeprom
Oct 23 20:20:21 catee kernel:
Oct 23 20:20:21 catee kernel: Pid: 3958, comm: watchdog Tainted: G      D (2.6.23-g0b776eb5 #16)
Oct 23 20:20:21 catee kernel: EIP: 0060:[<c015b9b6>] EFLAGS: 00010282 CPU: 0
Oct 23 20:20:21 catee kernel: EIP is at free_pgtables+0x8a/0xb4
Oct 23 20:20:21 catee kernel: EAX: bfbdf000 EBX: c2568f50 ECX: 00000000 EDX: 00000018
Oct 23 20:20:21 catee kernel: ESI: c3a61ef0 EDI: c48bfbfc EBP: bfbca000 ESP: c2568f34
Oct 23 20:20:21 catee kernel: DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Oct 23 20:20:21 catee kernel: Process watchdog (pid: 3958, ti=c2568000 task=c24d0570 task.ti=c2568000)
Oct 23 20:20:21 catee kernel: Stack: c3635c80 00000000 c015ca2e 00000000 c2568f4c 00000000 00000043 c200d180
Oct 23 20:20:21 catee kernel: c3635c80 c24d0570 00000000 c0121f30 00000001 c0126cb6 c011bbb5 00000000
Oct 23 20:20:21 catee kernel: c3434480 c2f44580 c24d0570 c24c7030 00000f76 0000007b 0000007b 00000004
Oct 23 20:20:21 catee kernel: Call Trace:
Oct 23 20:20:21 catee kernel: [<c015ca2e>] exit_mmap+0x91/0xeb
Oct 23 20:20:21 catee kernel: [<c0121f30>] mmput+0x23/0x7b
Oct 23 20:20:21 catee kernel: [<c0126cb6>] do_exit+0x12f/0x791
Oct 23 20:20:21 catee kernel: [<c011bbb5>] do_page_fault+0xce/0x5c9
Oct 23 20:20:21 catee kernel: [<c012733e>] do_group_exit+0x26/0x6c
Oct 23 20:20:21 catee kernel: [<c0103fde>] sysenter_past_esp+0x5f/0x85
Oct 23 20:20:21 catee kernel: [<c0350000>] packet_recvmsg+0x17b/0x1af
Oct 23 20:20:21 catee kernel: =======================
Oct 23 20:20:21 catee kernel: Code: 12 00 00 85 f6 75 da 89 df 8b 4f 08 8b 44 24 24 89 44 24 04 8b 44 24 08 89 04 24 89 ea 8b 44 24 0c e8 66 f1 ff ff 83 c4 10 5b 5e <c0> 5d c3 89 df 8b 4f 08 89 54 24 04 8b 44 24 08 89 04 24 89 ea
Oct 23 20:20:21 catee kernel: EIP: [<c015b9b6>] free_pgtables+0x8a/0xb4 SS:ESP 0068:c2568f34
Oct 23 20:20:21 catee kernel: Fixing recursive fault but reboot is needed!
Oct 23 20:20:31 catee kernel: BUG: unable to handle kernel paging request at virtual address bfbc9fc3
Oct 23 20:20:31 catee kernel: printing eip: c015b9b6 *pde = 00000000
Oct 23 20:20:31 catee kernel: Oops: 0002 [#22] SMP
Oct 23 20:20:31 catee kernel: Modules linked in: fuse tuner tea5767 tda8290 tuner_simple mt20xx floppy bttv ir_common videobuf_dma_sg btcx_risc tveeprom
Oct 23 20:20:31 catee kernel:
Oct 23 20:20:31 catee kernel: Pid: 3959, comm: watchdog Tainted: G      D (2.6.23-g0b776eb5 #16)
Oct 23 20:20:31 catee kernel: EIP: 0060:[<c015b9b6>] EFLAGS: 00010282 CPU: 0
Oct 23 20:20:31 catee kernel: EIP is at free_pgtables+0x8a/0xb4
Oct 23 20:20:31 catee kernel: EAX: bfbdf000 EBX: c490af50 ECX: 00000000 EDX: 00000018
Oct 23 20:20:31 catee kernel: ESI: c42cfca4 EDI: c4328cf8 EBP: bfbca000 ESP: c490af34
Oct 23 20:20:31 catee kernel: DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Oct 23 20:20:31 catee kernel: Process watchdog (pid: 3959, ti=c490a000 task=c27d9570 task.ti=c490a000)
Oct 23 20:20:31 catee kernel: Stack: c2cc2ac0 00000000 c015ca2e 00000000 c490af4c 00000000 00000043 c200d180
Oct 23 20:20:31 catee kernel: c2cc2ac0 c27d9570 00000000 c0121f30 00000001 c0126cb6 c011bbb5 00000000
Oct 23 20:20:31 catee kernel: c24a6400 c2f44580 c27d9570 c24c7030 00000f77 c242007b c490007b 00000004
Oct 23 20:20:31 catee kernel: Call Trace:
Oct 23 20:20:31 catee kernel: [<c015ca2e>] exit_mmap+0x91/0xeb
Oct 23 20:20:31 catee kernel: [<c0121f30>] mmput+0x23/0x7b
Oct 23 20:20:31 catee kernel: [<c0126cb6>] do_exit+0x12f/0x791
Oct 23 20:20:31 catee kernel: [<c011bbb5>] do_page_fault+0xce/0x5c9
Oct 23 20:20:31 catee kernel: [<c012733e>] do_group_exit+0x26/0x6c
Oct 23 20:20:31 catee kernel: [<c0103fde>] sysenter_past_esp+0x5f/0x85
Oct 23 20:20:31 catee kernel: [<c0350000>] packet_recvmsg+0x17b/0x1af
Oct 23 20:20:31 catee kernel: =======================
Oct 23 20:20:31 catee kernel: Code: 12 00 00 85 f6 75 da 89 df 8b 4f 08 8b 44 24 24 89 44 24 04 8b 44 24 08 89 04 24 89 ea 8b 44 24 0c e8 66 f1 ff ff 83 c4 10 5b 5e <c0> 5d c3 89 df 8b 4f 08 89 54 24 04 8b 44 24 08 89 04 24 89 ea
Oct 23 20:20:31 catee kernel: EIP: [<c015b9b6>] free_pgtables+0x8a/0xb4 SS:ESP 0068:c490af34
Oct 23 20:20:31 catee kernel: Fixing recursive fault but reboot is needed!
Oct 23 20:20:41 catee kernel: BUG: unable to handle kernel paging request at virtual address bfbc9fc3
Oct 23 20:20:41 catee kernel: printing eip: c015b9b6 *pde = 00000000
Oct 23 20:20:41 catee kernel: Oops: 0002 [#23] SMP
Oct 23 20:20:41 catee kernel: Modules linked in: fuse tuner tea5767 tda8290 tuner_simple mt20xx floppy bttv ir_common videobuf_dma_sg btcx_risc tveeprom
Oct 23 20:20:41 catee kernel:
Oct 23 20:20:41 catee kernel: Pid: 3960, comm: watchdog Tainted: G      D (2.6.23-g0b776eb5 #16)
Oct 23 20:20:41 catee kernel: EIP: 0060:[<c015b9b6>] EFLAGS: 00010282 CPU: 0
Oct 23 20:20:41 catee kernel: EIP is at free_pgtables+0x8a/0xb4
Oct 23 20:20:41 catee kernel: EAX: bfbdf000 EBX: c4942f50 ECX: 00000000 EDX: 00000018
Oct 23 20:20:41 catee kernel: ESI: c48b3f44 EDI: c42cfba8 EBP: bfbca000 ESP: c4942f34
Oct 23 20:20:41 catee kernel: DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Oct 23 20:20:41 catee kernel: Process watchdog (pid: 3960, ti=c4942000 task=c2c94ab0 task.ti=c4942000)
Oct 23 20:20:41 catee kernel: Stack: c3403e40 00000000 c015ca2e 00000000 c4942f4c 00000000 00000043 c200d180
Oct 23 20:20:41 catee kernel: c3403e40 c2c94ab0 00000000 c0121f30 00000001 c0126cb6 c011bbb5 00000000
Oct 23 20:20:41 catee kernel: c2c64640 c2f44580 c2c94ab0 c24c7030 00000f78 0000007b 0000007b 00000004
Oct 23 20:20:41 catee kernel: Call Trace:
Oct 23 20:20:41 catee kernel: [<c015ca2e>] exit_mmap+0x91/0xeb
Oct 23 20:20:41 catee kernel: [<c0121f30>] mmput+0x23/0x7b
Oct 23 20:20:41 catee kernel: [<c0126cb6>] do_exit+0x12f/0x791
Oct 23 20:20:41 catee kernel: [<c011bbb5>] do_page_fault+0xce/0x5c9
Oct 23 20:20:41 catee kernel: [<c012733e>] do_group_exit+0x26/0x6c
Oct 23 20:20:41 catee kernel: [<c0103fde>] sysenter_past_esp+0x5f/0x85
Oct 23 20:20:41 catee kernel: [<c0350000>] packet_recvmsg+0x17b/0x1af
Oct 23 20:20:41 catee kernel: =======================
Oct 23 20:20:41 catee kernel: Code: 12 00 00 85 f6 75 da 89 df 8b 4f 08 8b 44 24 24 89 44 24 04 8b 44 24 08 89 04 24 89 ea 8b 44 24 0c e8 66 f1 ff ff 83 c4 10 5b 5e <c0> 5d c3 89 df 8b 4f 08 89 54 24 04 8b 44 24 08 89 04 24 89 ea
Oct 23 20:20:41 catee kernel: EIP: [<c015b9b6>] free_pgtables+0x8a/0xb4 SS:ESP 0068:c4942f34
Oct 23 20:20:41 catee kernel: Fixing recursive fault but reboot is needed!
Oct 23 20:20:51 catee kernel: BUG: unable to handle kernel paging request at virtual address bfbc9fc3
Oct 23 20:20:51 catee kernel: printing eip: c015b9b6 *pde = 00000000
Oct 23 20:20:51 catee kernel: Oops: 0002 [#24] SMP
Oct 23 20:20:51 catee kernel: Modules linked in: fuse tuner tea5767 tda8290 tuner_simple mt20xx floppy bttv ir_common videobuf_dma_sg btcx_risc tveeprom
Oct 23 20:20:51 catee kernel:
Oct 23 20:20:51 catee kernel: Pid: 3961, comm: watchdog Tainted: G      D (2.6.23-g0b776eb5 #16)
Oct 23 20:20:51 catee kernel: EIP: 0060:[<c015b9b6>] EFLAGS: 00010282 CPU: 0
Oct 23 20:20:51 catee kernel: EIP is at free_pgtables+0x8a/0xb4
Oct 23 20:20:51 catee kernel: EAX: bfbdf000 EBX: c2564f50 ECX: 00000000 EDX: 00000018
Oct 23 20:20:51 catee kernel: ESI: c4957e48 EDI: c48b3e48 EBP: bfbca000 ESP: c2564f34
Oct 23 20:20:51 catee kernel: DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Oct 23 20:20:51 catee kernel: Process watchdog (pid: 3961, ti=c2564000 task=c344a570 task.ti=c2564000)
Oct 23 20:20:51 catee kernel: Stack: c3968c80 00000000 c015ca2e 00000000 c2564f4c 00000000 00000043 c200d180
Oct 23 20:20:51 catee kernel: c3968c80 c344a570 00000000 c0121f30 00000001 c0126cb6 c011bbb5 00000000
Oct 23 20:20:51 catee kernel: c253d580 c2f44580 c344a570 c24c7030 00000f79 0000007b 0000007b 00000004
Oct 23 20:20:51 catee kernel: Call Trace:
Oct 23 20:20:51 catee kernel: [<c015ca2e>] exit_mmap+0x91/0xeb
Oct 23 20:20:51 catee kernel: [<c0121f30>] mmput+0x23/0x7b
Oct 23 20:20:51 catee kernel: [<c0126cb6>] do_exit+0x12f/0x791
Oct 23 20:20:51 catee kernel: [<c011bbb5>] do_page_fault+0xce/0x5c9
Oct 23 20:20:51 catee kernel: [<c012733e>] do_group_exit+0x26/0x6c
Oct 23 20:20:51 catee kernel: [<c0103fde>] sysenter_past_esp+0x5f/0x85
Oct 23 20:20:51 catee kernel: [<c0350000>] packet_recvmsg+0x17b/0x1af
Oct 23 20:20:51 catee kernel: =======================
Oct 23 20:20:51 catee kernel: Code: 12 00 00 85 f6 75 da 89 df 8b 4f 08 8b 44 24 24 89 44 24 04 8b 44 24 08 89 04 24 89 ea 8b 44 24 0c e8 66 f1 ff ff 83 c4 10 5b 5e <c0> 5d c3 89 df 8b 4f 08 89 54 24 04 8b 44 24 08 89 04 24 89 ea
Oct 23 20:20:51 catee kernel: EIP: [<c015b9b6>] free_pgtables+0x8a/0xb4 SS:ESP 0068:c2564f34
Oct 23 20:20:51 catee kernel: Fixing recursive fault but reboot is needed!
Oct 23 20:20:51 catee kernel: BUG: unable to handle kernel paging request at virtual address b6730fc3
Oct 23 20:20:51 catee kernel: printing eip: c015b9b6 *pde = 04346067 *pte = 00000000
Oct 23 20:20:51 catee kernel: Oops: 0002 [#25] SMP
Oct 23 20:20:51 catee kernel: Modules linked in: fuse tuner tea5767 tda8290 tuner_simple mt20xx floppy bttv ir_common videobuf_dma_sg btcx_risc tveeprom
Oct 23 20:20:51 catee kernel:
Oct 23 20:20:51 catee kernel: Pid: 3159, comm: kweatherservice Tainted: G      D (2.6.23-g0b776eb5 #16)
Oct 23 20:20:51 catee kernel: EIP: 0060:[<c015b9b6>] EFLAGS: 00010286 CPU: 0
Oct 23 20:20:51 catee kernel: EIP is at free_pgtables+0x8a/0xb4
Oct 23 20:20:51 catee kernel: EAX: b6331fff EBX: c2f37f64 ECX: b6732000 EDX: b6731000
Oct 23 20:20:51 catee kernel: ESI: c2f12040 EDI: c48b30d4 EBP: b6731000 ESP: c2f37f44
Oct 23 20:20:51 catee kernel: DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Oct 23 20:20:51 catee kernel: Process kweatherservice (pid: 3159, ti=c2f37000 task=c24b2570 task.ti=c2f37000)
Oct 23 20:20:51 catee kernel: Stack: c2e9dc50 c435e8b4 c015c911 b6732000 c2f37f60 00000000 c48b30d4 00000001
Oct 23 20:20:51 catee kernel: c200d180 b6731000 c2f12040 c48b30d4 c48b30d4 c015d350 b6731000 b6732000
Oct 23 20:20:51 catee kernel: c2f12044 c2e9dc50 b6732000 c2e9dc5c c2e9dc50 c2f12040 c2f12074 00000000
Oct 23 20:20:51 catee kernel: Call Trace:
Oct 23 20:20:51 catee kernel: [<c015c911>] unmap_region+0xc1/0x112
Oct 23 20:20:51 catee kernel: [<c015d350>] do_munmap+0x137/0x1c7
Oct 23 20:20:51 catee kernel: [<c015d407>] sys_munmap+0x27/0x35
Oct 23 20:20:51 catee kernel: [<c0103fde>] sysenter_past_esp+0x5f/0x85
Oct 23 20:20:51 catee kernel: [<c0350000>] packet_recvmsg+0x17b/0x1af
Oct 23 20:20:51 catee kernel: =======================
Oct 23 20:20:51 catee kernel: Code: 12 00 00 85 f6 75 da 89 df 8b 4f 08 8b 44 24 24 89 44 24 04 8b 44 24 08 89 04 24 89 ea 8b 44 24 0c e8 66 f1 ff ff 83 c4 10 5b 5e <c0> 5d c3 89 df 8b 4f 08 89 54 24 04 8b 44 24 08 89 04 24 89 ea
Oct 23 20:20:51 catee kernel: EIP: [<c015b9b6>] free_pgtables+0x8a/0xb4 SS:ESP 0068:c2f37f44
Oct 23 20:21:01 catee kernel: BUG: unable to handle kernel paging request at virtual address bfbc9fc3
Oct 23 20:21:01 catee kernel: printing eip: c015b9b6 *pde = 00000000
Oct 23 20:21:01 catee kernel: Oops: 0002 [#26] SMP
Oct 23 20:21:01 catee kernel: Modules linked in: fuse tuner tea5767 tda8290 tuner_simple mt20xx floppy bttv ir_common videobuf_dma_sg btcx_risc tveeprom
Oct 23 20:21:01 catee kernel:
Oct 23 20:21:01 catee kernel: Pid: 3962, comm: watchdog Tainted: G      D (2.6.23-g0b776eb5 #16)
Oct 23 20:21:01 catee kernel: EIP: 0060:[<c015b9b6>] EFLAGS: 00010282 CPU: 0
Oct 23 20:21:01 catee kernel: EIP is at free_pgtables+0x8a/0xb4
Oct 23 20:21:01 catee kernel: EAX: bfbdf000 EBX: c48d2f50 ECX: 00000000 EDX: 00000018
Oct 23 20:21:01 catee kernel: ESI: c4957da0 EDI: c495717c EBP: bfbca000 ESP: c48d2f34
Oct 23 20:21:01 catee kernel: DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Oct 23 20:21:01 catee kernel: Process watchdog (pid: 3962, ti=c48d2000 task=c490c030 task.ti=c48d2000)
Oct 23 20:21:01 catee kernel: Stack: c3635e40 00000000 c015ca2e 00000000 c48d2f4c 00000000 00000043 c200d180
Oct 23 20:21:01 catee kernel: c3635e40 c490c030 00000000 c0121f30 00000001 c0126cb6 c011bbb5 00000000
Oct 23 20:21:01 catee kernel: c3434840 c2f44580 c490c030 c24c7030 00000f7a 0000007b 0000007b 00000004
Oct 23 20:21:01 catee kernel: Call Trace:
Oct 23 20:21:01 catee kernel: [<c015ca2e>] exit_mmap+0x91/0xeb
Oct 23 20:21:01 catee kernel: [<c0121f30>] mmput+0x23/0x7b
Oct 23 20:21:01 catee kernel: [<c0126cb6>] do_exit+0x12f/0x791
Oct 23 20:21:01 catee kernel: [<c011bbb5>] do_page_fault+0xce/0x5c9
Oct 23 20:21:01 catee kernel: [<c012733e>] do_group_exit+0x26/0x6c
Oct 23 20:21:01 catee kernel: [<c0103fde>] sysenter_past_esp+0x5f/0x85
Oct 23 20:21:01 catee kernel: [<c0350000>] packet_recvmsg+0x17b/0x1af
Oct 23 20:21:01 catee kernel: =======================
Oct 23 20:21:01 catee kernel: Code: 12 00 00 85 f6 75 da 89 df 8b 4f 08 8b 44 24 24 89 44 24 04 8b 44 24 08 89 04 24 89 ea 8b 44 24 0c e8 66 f1 ff ff 83 c4 10 5b 5e <c0> 5d c3 89 df 8b 4f 08 89 54 24 04 8b 44 24 08 89 04 24 89 ea
Oct 23 20:21:01 catee kernel: EIP: [<c015b9b6>] free_pgtables+0x8a/0xb4 SS:ESP 0068:c48d2f34
Oct 23 20:21:01 catee kernel: Fixing recursive fault but reboot is needed!
Oct 23 20:21:01 catee kernel: BUG: unable to handle kernel paging request at virtual address b5c86fc3
Oct 23 20:21:01 catee kernel: printing eip: c015b9b6 *pde = 0487e067 *pte = 00000000
Oct 23 20:21:01 catee kernel: Oops: 0002 [#27] SMP
Oct 23 20:21:01 catee kernel: Modules linked in: fuse tuner tea5767 tda8290 tuner_simple mt20xx floppy bttv ir_common videobuf_dma_sg btcx_risc tveeprom
Oct 23 20:21:01 catee kernel:
Oct 23 20:21:01 catee kernel: Pid: 3182, comm: akregator Tainted: G      D (2.6.23-g0b776eb5 #16)
Oct 23 20:21:01 catee kernel: EIP: 0060:[<c015b9b6>] EFLAGS: 00010286 CPU: 1
Oct 23 20:21:01 catee kernel: EIP is at free_pgtables+0x8a/0xb4
Oct 23 20:21:01 catee kernel: EAX: b5887fff EBX: c4880f64 ECX: b5c88000 EDX: b5c87000
Oct 23 20:21:01 catee kernel: ESI: c2dd7040 EDI: c48e9e48 EBP: b5c87000 ESP: c4880f44
Oct 23 20:21:01 catee kernel: DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Oct 23 20:21:01 catee kernel: Process akregator (pid: 3182, ti=c4880000 task=c24d4570 task.ti=c4880000)
Oct 23 20:21:01 catee kernel: Stack: c48beaac c48a2764 c015c911 b5c88000 c4880f60 00000000 c48e9e48 00000001
Oct 23 20:21:01 catee kernel: c2015180 b5c87000 c2dd7040 c48e9e48 c48e9e48 c015d350 b5c87000 b5c88000
Oct 23 20:21:01 catee kernel: c2dd7044 c48beaac b5c88000 c48beab8 c48beaac c2dd7040 c2dd7074 00000000
Oct 23 20:21:01 catee kernel: Call Trace:
Oct 23 20:21:01 catee kernel: [<c015c911>] unmap_region+0xc1/0x112
Oct 23 20:21:01 catee kernel: [<c015d350>] do_munmap+0x137/0x1c7
Oct 23 20:21:01 catee kernel: [<c015d407>] sys_munmap+0x27/0x35
Oct 23 20:21:01 catee kernel: [<c0103fde>] sysenter_past_esp+0x5f/0x85
Oct 23 20:21:01 catee kernel: =======================
Oct 23 20:21:01 catee kernel: Code: 12 00 00 85 f6 75 da 89 df 8b 4f 08 8b 44 24 24 89 44 24 04 8b 44 24 08 89 04 24 89 ea 8b 44 24 0c e8 66 f1 ff ff 83 c4 10 5b 5e <c0> 5d c3 89 df 8b 4f 08 89 54 24 04 8b 44 24 08 89 04 24 89 ea
Oct 23 20:21:01 catee kernel: EIP: [<c015b9b6>] free_pgtables+0x8a/0xb4 SS:ESP 0068:c4880f44
Oct 23 20:21:11 catee kernel: BUG: unable to handle kernel paging request at virtual address bfbc9fc3
Oct 23 20:21:11 catee kernel: printing eip: c015b9b6 *pde = 00000000
Oct 23 20:21:11 catee kernel: Oops: 0002 [#28] SMP
Oct 23 20:21:11 catee kernel: Modules linked in: fuse tuner tea5767 tda8290 tuner_simple mt20xx floppy bttv ir_common videobuf_dma_sg btcx_risc tveeprom
Oct 23 20:21:11 catee kernel:
Oct 23 20:21:11 catee kernel: Pid: 3963, comm: watchdog Tainted: G      D (2.6.23-g0b776eb5 #16)
Oct 23 20:21:11 catee kernel: EIP: 0060:[<c015b9b6>] EFLAGS: 00010282 CPU: 0
Oct 23 20:21:11 catee kernel: EIP is at free_pgtables+0x8a/0xb4
Oct 23 20:21:11 catee kernel: EAX: bfbdf000 EBX: c483df50 ECX: 00000000 EDX: 00000018
Oct 23 20:21:11 catee kernel: ESI: c35b6518 EDI: c43ca860 EBP: bfbca000 ESP: c483df34
Oct 23 20:21:11 catee kernel: DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Oct 23 20:21:11 catee kernel: Process watchdog (pid: 3963, ti=c483d000 task=c4a9cab0 task.ti=c483d000)
Oct 23 20:21:11 catee kernel: Stack: c3443c80 00000000 c015ca2e 00000000 c483df4c 00000000 00000043 c200d180
Oct 23 20:21:11 catee kernel: c3443c80 c4a9cab0 00000000 c0121f30 00000001 c0126cb6 c011bbb5 00000000
Oct 23 20:21:11 catee kernel: c24a6b40 c2f44580 c4a9cab0 c24c7030 00000f7b 0000007b 0000007b 00000004
Oct 23 20:21:11 catee kernel: Call Trace:
Oct 23 20:21:11 catee kernel: [<c015ca2e>] exit_mmap+0x91/0xeb
Oct 23 20:21:11 catee kernel: [<c0121f30>] mmput+0x23/0x7b
Oct 23 20:21:11 catee kernel: [<c0126cb6>] do_exit+0x12f/0x791
Oct 23 20:21:11 catee kernel: [<c011bbb5>] do_page_fault+0xce/0x5c9
Oct 23 20:21:11 catee kernel: [<c012733e>] do_group_exit+0x26/0x6c
Oct 23 20:21:11 catee kernel: [<c0103fde>] sysenter_past_esp+0x5f/0x85
Oct 23 20:21:11 catee kernel: [<c0350000>] packet_recvmsg+0x17b/0x1af
Oct 23 20:21:11 catee kernel: =======================
Oct 23 20:21:11 catee kernel: Code: 12 00 00 85 f6 75 da 89 df 8b 4f 08 8b 44 24 24 89 44 24 04 8b 44 24 08 89 04 24 89 ea 8b 44 24 0c e8 66 f1 ff ff 83 c4 10 5b 5e <c0> 5d c3 89 df 8b 4f 08 89 54 24 04 8b 44 24 08 89 04 24 89 ea
Oct 23 20:21:11 catee kernel: EIP: [<c015b9b6>] free_pgtables+0x8a/0xb4 SS:ESP 0068:c483df34
Oct 23 20:21:11 catee kernel: Fixing recursive fault but reboot is needed!
Oct 23 20:21:21 catee kernel: BUG: unable to handle kernel paging request at virtual address bfbc9fc3
Oct 23 20:21:21 catee kernel: printing eip: c015b9b6 *pde = 00000000
Oct 23 20:21:21 catee kernel: Oops: 0002 [#29] SMP
Oct 23 20:21:21 catee kernel: Modules linked in: fuse tuner tea5767 tda8290 tuner_simple mt20xx floppy bttv ir_common videobuf_dma_sg btcx_risc tveeprom
Oct 23 20:21:21 catee kernel:
Oct 23 20:21:21 catee kernel: Pid: 3964, comm: watchdog Tainted: G      D (2.6.23-g0b776eb5 #16)
Oct 23 20:21:21 catee kernel: EIP: 0060:[<c015b9b6>] EFLAGS: 00010282 CPU: 0
Oct 23 20:21:21 catee kernel: EIP is at free_pgtables+0x8a/0xb4
Oct 23 20:21:21 catee kernel: EAX: bfbdf000 EBX: c3838f50 ECX: 00000000 EDX: 00000018
Oct 23 20:21:21 catee kernel: ESI: c35b6aac EDI: c35b6710 EBP: bfbca000 ESP: c3838f34
Oct 23 20:21:21 catee kernel: DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Oct 23 20:21:21 catee kernel: Process watchdog (pid: 3964, ti=c3838000 task=c49e8570 task.ti=c3838000)
Oct 23 20:21:21 catee kernel: Stack: c2f44c80 00000000 c015ca2e 00000000 c3838f4c 00000000 00000043 c200d180
Oct 23 20:21:21 catee kernel: c2f44c80 c49e8570 00000000 c0121f30 00000001 c0126cb6 c011bbb5 00000000
Oct 23 20:21:21 catee kernel: c2c64480 c2f44580 c49e8570 c24c7030 00000f7c 0000007b 0000007b 00000004
Oct 23 20:21:21 catee kernel: Call Trace:
Oct 23 20:21:21 catee kernel: [<c015ca2e>] exit_mmap+0x91/0xeb
Oct 23 20:21:21 catee kernel: [<c0121f30>] mmput+0x23/0x7b
Oct 23 20:21:21 catee kernel: [<c0126cb6>] do_exit+0x12f/0x791
Oct 23 20:21:21 catee kernel: [<c011bbb5>] do_page_fault+0xce/0x5c9
Oct 23 20:21:21 catee kernel: [<c012733e>] do_group_exit+0x26/0x6c
Oct 23 20:21:21 catee kernel: [<c0103fde>] sysenter_past_esp+0x5f/0x85
Oct 23 20:21:21 catee kernel: [<c0350000>] packet_recvmsg+0x17b/0x1af
Oct 23 20:21:21 catee kernel: =======================
Oct 23 20:21:21 catee kernel: Code: 12 00 00 85 f6 75 da 89 df 8b 4f 08 8b 44 24 24 89 44 24 04 8b 44 24 08 89 04 24 89 ea 8b 44 24 0c e8 66 f1 ff ff 83 c4 10 5b 5e <c0> 5d c3 89 df 8b 4f 08 89 54 24 04 8b 44 24 08 89 04 24 89 ea
Oct 23 20:21:21 catee kernel: EIP: [<c015b9b6>] free_pgtables+0x8a/0xb4 SS:ESP 0068:c3838f34
Oct 23 20:21:21 catee kernel: Fixing recursive fault but reboot is needed!
Oct 23 20:21:31 catee kernel: BUG: unable to handle kernel paging request at virtual address bfbc9fc3
Oct 23 20:21:31 catee kernel: printing eip: c015b9b6 *pde = 00000000
Oct 23 20:21:31 catee kernel: Oops: 0002 [#30] SMP
Oct 23 20:21:31 catee kernel: Modules linked in: fuse tuner tea5767 tda8290 tuner_simple mt20xx floppy bttv ir_common videobuf_dma_sg btcx_risc tveeprom
Oct 23 20:21:31 catee kernel:
Oct 23 20:21:31 catee kernel: Pid: 3965, comm: watchdog Tainted: G      D (2.6.23-g0b776eb5 #16)
Oct 23 20:21:31 catee kernel: EIP: 0060:[<c015b9b6>] EFLAGS: 00010282 CPU: 0
Oct 23 20:21:31 catee kernel: EIP is at free_pgtables+0x8a/0xb4
Oct 23 20:21:31 catee kernel: EAX: bfbdf000 EBX: c49dbf50 ECX: 00000000 EDX: 00000018
Oct 23 20:21:31 catee kernel: ESI: c491b668 EDI: c491bba8 EBP: bfbca000 ESP: c49dbf34
Oct 23 20:21:31 catee kernel: DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Oct 23 20:21:31 catee kernel: Process watchdog (pid: 3965, ti=c49db000 task=c344aab0 task.ti=c49db000)
Oct 23 20:21:31 catee kernel: Stack: c2dc8200 00000000 c015ca2e 00000000 c49dbf4c 00000000 00000043 c200d180
Oct 23 20:21:31 catee kernel: c2dc8200 c344aab0 00000000 c0121f30 00000001 c0126cb6 c011bbb5 00000000
Oct 23 20:21:31 catee kernel: c253d4c0 c2f44580 c344aab0 c24c7030 00000f7d 0000007b 0000007b 00000004
Oct 23 20:21:31 catee kernel: Call Trace:
Oct 23 20:21:31 catee kernel: [<c015ca2e>] exit_mmap+0x91/0xeb
Oct 23 20:21:31 catee kernel: [<c0121f30>] mmput+0x23/0x7b
Oct 23 20:21:31 catee kernel: [<c0126cb6>] do_exit+0x12f/0x791
Oct 23 20:21:31 catee kernel: [<c011bbb5>] do_page_fault+0xce/0x5c9
Oct 23 20:21:31 catee kernel: [<c012733e>] do_group_exit+0x26/0x6c
Oct 23 20:21:31 catee kernel: [<c0103fde>] sysenter_past_esp+0x5f/0x85
Oct 23 20:21:31 catee kernel: [<c0350000>] packet_recvmsg+0x17b/0x1af
Oct 23 20:21:31 catee kernel: =======================
Oct 23 20:21:31 catee kernel: Code: 12 00 00 85 f6 75 da 89 df 8b 4f 08 8b 44 24 24 89 44 24 04 8b 44 24 08 89 04 24 89 ea 8b 44 24 0c e8 66 f1 ff ff 83 c4 10 5b 5e <c0> 5d c3 89 df 8b 4f 08 89 54 24 04 8b 44 24 08 89 04 24 89 ea
Oct 23 20:21:31 catee kernel: EIP: [<c015b9b6>] free_pgtables+0x8a/0xb4 SS:ESP 0068:c49dbf34
Oct 23 20:21:31 catee kernel: Fixing recursive fault but reboot is needed!
Oct 23 20:21:41 catee kernel: BUG: unable to handle kernel paging request at virtual address bfbc9fc3
Oct 23 20:21:41 catee kernel: printing eip: c015b9b6 *pde = 00000000
Oct 23 20:21:41 catee kernel: Oops: 0002 [#31] SMP
Oct 23 20:21:41 catee kernel: Modules linked in: fuse tuner tea5767 tda8290 tuner_simple mt20xx floppy bttv ir_common videobuf_dma_sg btcx_risc tveeprom
Oct 23 20:21:41 catee kernel:
Oct 23 20:21:41 catee kernel: Pid: 3966, comm: watchdog Tainted: G      D (2.6.23-g0b776eb5 #16)
Oct 23 20:21:41 catee kernel: EIP: 0060:[<c015b9b6>] EFLAGS: 00010282 CPU: 0
Oct 23 20:21:41 catee kernel: EIP is at free_pgtables+0x8a/0xb4
Oct 23 20:21:41 catee kernel: EAX: bfbdf000 EBX: c2560f50 ECX: 00000000 EDX: 00000018
Oct 23 20:21:41 catee kernel: ESI: c49dec50 EDI: c3a3e5c0 EBP: bfbca000 ESP: c2560f34
Oct 23 20:21:41 catee kernel: DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Oct 23 20:21:41 catee kernel: Process watchdog (pid: 3966, ti=c2560000 task=c4313030 task.ti=c2560000)
Oct 23 20:21:41 catee kernel: Stack: c2dd7740 00000000 c015ca2e 00000000 c2560f4c 00000000 00000043 c200d180
Oct 23 20:21:41 catee kernel: c2dd7740 c4313030 00000000 c0121f30 00000001 c0126cb6 c011bbb5 00000000
Oct 23 20:21:41 catee kernel: c3434380 c2f44580 c4313030 c24c7030 00000f7e c242007b c256007b 00000004
Oct 23 20:21:41 catee kernel: Call Trace:
Oct 23 20:21:41 catee kernel: [<c015ca2e>] exit_mmap+0x91/0xeb
Oct 23 20:21:41 catee kernel: [<c0121f30>] mmput+0x23/0x7b
Oct 23 20:21:41 catee kernel: [<c0126cb6>] do_exit+0x12f/0x791
Oct 23 20:21:41 catee kernel: [<c011bbb5>] do_page_fault+0xce/0x5c9
Oct 23 20:21:41 catee kernel: [<c012733e>] do_group_exit+0x26/0x6c
Oct 23 20:21:41 catee kernel: [<c0103fde>] sysenter_past_esp+0x5f/0x85
Oct 23 20:21:41 catee kernel: [<c0350000>] packet_recvmsg+0x17b/0x1af
Oct 23 20:21:41 catee kernel: =======================
Oct 23 20:21:41 catee kernel: Code: 12 00 00 85 f6 75 da 89 df 8b 4f 08 8b 44 24 24 89 44 24 04 8b 44 24 08 89 04 24 89 ea 8b 44 24 0c e8 66 f1 ff ff 83 c4 10 5b 5e <c0> 5d c3 89 df 8b 4f 08 89 54 24 04 8b 44 24 08 89 04 24 89 ea
