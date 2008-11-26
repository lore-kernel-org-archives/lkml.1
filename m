Return-Path: <linux-kernel-owner+w=401wt.eu-S1753934AbYKZQbH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934AbYKZQbH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 11:31:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752603AbYKZQay
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 11:30:54 -0500
Received: from yx-out-2324.google.com ([74.125.44.29]:32082 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489AbYKZQax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 11:30:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=TiEdnu16/msLrKqKMIK2y2n4RFzyV6WqaXB07qxMv32bMbL/mINIT2wbZUjgXP13uk
         ml9ke8BrRAM6llmp4yzh8rl2Qcr0EP623yy6Mcvy6sKh+KneRjR2rNSAeQpO355+snuy
         arNa0BNRm9N3owqtc4j8ubSmp8AS6CU9cc8IQ=
Message-ID: <a4423d670811260830w19a67faak38b09f6153579af3@mail.gmail.com>
Date: Wed, 26 Nov 2008 19:30:51 +0300
From: "Alexander Beregalov" <a.beregalov@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       "Ingo Molnar" <mingo@elte.hu>
Subject: next-20081126: x86_64: kernel BUG at kernel/params.c:637
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi


Brought up 4 CPUs
Total of 4 processors activated (23949.39 BogoMIPS).
khelper used greatest stack depth: 5712 bytes left
net_namespace: 752 bytes
NET: Registered protocol family 16
ACPI FADT declares the system doesn't support PCIe ASPM, so disab

ACPI: bus type pci registered
PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
PCI: MCFG area at e0000000 reserved in E820
PCI: Using MMCONFIG at e0000000 - efffffff
PCI: Using configuration type 1 for base access
PCI: Dell PowerEdge 1950 detected, enabling pci=bfsort.
------------[ cut here ]------------
kernel BUG at kernel/params.c:637!
invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
last sysfs file:
CPU 0
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.28-rc6-next-20081126 #24
RIP: 0010:[<ffffffff806d7b25>]  [<ffffffff806d7b25>] param_sysfs_init+0x86/0xf3
RSP: 0018:ffff88007f46be40  EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000005 RCX: ffff88007f46bdf0
RDX: 0000000000000000 RSI: 000000000000002e RDI: 0000000000000000
RBP: ffff88007f46bea0 R08: ffffe200033b3040 R09: 000000000000005a
R10: ffff88007f46bab0 R11: ffffffff80376a0e R12: ffffffff8051ed40
R13: ffffffff8063a2d8 R14: ffff88007f46be40 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffffffff806ba800(0000) knlGS:00000

CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000000201000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 1, threadinfo ffff88007f46a000, task ffff8)
Stack:
 6400610069636861 ffffffff804e4a00 0000000000000003 fffffffffffff
 ffffffff806cbabd 0000000000000001 ffff88007f46be80 ffffffff8037d
 ffffffff80706470 ffffffffffffffff ffffffff806d7a9f 0000000000001
Call Trace:
 [<ffffffff804e4a00>] ? register_cpu+0x3a/0x77
 [<ffffffff806cbabd>] ? topology_init+0x0/0x30
 [<ffffffff8037499d>] ? __next_cpu+0x19/0x26
 [<ffffffff806d7a9f>] ? param_sysfs_init+0x0/0xf3
 [<ffffffff80209056>] _stext+0x56/0x130
 [<ffffffff80268358>] ? register_irq_proc+0xb0/0xcc
 [<ffffffff802d0000>] ? w_long+0x49/0x75
 [<ffffffff806c8655>] kernel_init+0x125/0x179
 [<ffffffff804e71a4>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff8020c979>] child_rip+0xa/0x21
 [<ffffffff802311b0>] ? finish_task_switch+0x0/0xb8
 [<ffffffff8020c340>] ? restore_args+0x0/0x30
 [<ffffffff806c8530>] ? kernel_init+0x0/0x179
 [<ffffffff8020c96f>] ? child_rip+0x0/0x21
Code: 00 49 c7 c5 10 98 63 80 4c 8d 75 a0 eb 45 41 83 7d 08 00 7
RIP  [<ffffffff806d7b25>] param_sysfs_init+0x86/0xf3
 RSP <ffff88007f46be40>
---[ end trace a22d306b065d4a66 ]---
swapper used greatest stack depth: 4912 bytes left
Kernel panic - not syncing: Attempted to kill init!
Pid: 1, comm: swapper Tainted: G      D    2.6.28-rc6-next-200814
Call Trace:
 [<ffffffff804e4c43>] panic+0xaa/0x15f
 [<ffffffff802399bd>] ? do_exit+0x347/0x89b
 [<ffffffff802399bd>] ? do_exit+0x347/0x89b
 [<ffffffff8025704a>] ? trace_hardirqs_on_caller+0x1f/0x153
 [<ffffffff804e73d7>] ? _write_unlock_irq+0x50/0x5d
 [<ffffffff802396e6>] do_exit+0x70/0x89b
 [<ffffffff8020f4c8>] oops_end+0x89/0x8e
 [<ffffffff8020f694>] die+0x55/0x5e
 [<ffffffff8020d2a7>] do_trap+0x110/0x11f
 [<ffffffff8020d5d9>] do_invalid_op+0x8f/0x98
 [<ffffffff806d7b25>] ? param_sysfs_init+0x86/0xf3
 [<ffffffff804e71e3>] ? trace_hardirqs_off_thunk+0x3a/0x3c
 [<ffffffff80376a0e>] ? kobject_uevent_env+0x365/0x390
 [<ffffffff8020c715>] invalid_op+0x15/0x20
 [<ffffffff80376a0e>] ? kobject_uevent_env+0x365/0x390
 [<ffffffff806d7b25>] ? param_sysfs_init+0x86/0xf3
 [<ffffffff804e4a00>] ? register_cpu+0x3a/0x77
 [<ffffffff806cbabd>] ? topology_init+0x0/0x30
 [<ffffffff8037499d>] ? __next_cpu+0x19/0x26
 [<ffffffff806d7a9f>] ? param_sysfs_init+0x0/0xf3
 [<ffffffff80209056>] _stext+0x56/0x130
 [<ffffffff80268358>] ? register_irq_proc+0xb0/0xcc
 [<ffffffff802d0000>] ? w_long+0x49/0x75
 [<ffffffff806c8655>] kernel_init+0x125/0x179
 [<ffffffff804e71a4>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff8020c979>] child_rip+0xa/0x21
 [<ffffffff802311b0>] ? finish_task_switch+0x0/0xb8
 [<ffffffff8020c340>] ? restore_args+0x0/0x30
 [<ffffffff806c8530>] ? kernel_init+0x0/0x179
 [<ffffffff8020c96f>] ? child_rip+0x0/0x21
