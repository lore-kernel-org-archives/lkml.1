Return-Path: <linux-kernel-owner+w=401wt.eu-S1754645AbZAaKsg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645AbZAaKsg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 05:48:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751991AbZAaKs2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 05:48:28 -0500
Received: from gw.goop.org ([64.81.55.164]:50196 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751979AbZAaKs0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 05:48:26 -0500
Message-ID: <49842C78.8090709@goop.org>
Date: Sat, 31 Jan 2009 02:48:24 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: zbigniew brzezinskix <zbigniewbrzezinskix@gmail.com>
CC: linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>
Subject: Re: 2.6.28 boot fails on Cyrix 6x86
References: <70438690901132000r4fabc40di959fea6f22ed3a69@mail.gmail.com>
In-Reply-To: <70438690901132000r4fabc40di959fea6f22ed3a69@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

zbigniew brzezinskix wrote:
> Vanilla 2.6.28 boot fails on Cyrix 6x86 ... seems ok on 6x86MX.
>
> tried:
>      (X) 386
>      (X) 486
>      (X) 586/K5/5x86/6x86/6x86MX
>
> cat /proc/cpuinfo
> processor       : 0
> vendor_id       : CyrixInstead
> cpu family      : 5
> model           : 2
> model name      : 6x86 2x Core/Bus Clock
> stepping        : 5
> fdiv_bug        : no
> hlt_bug         : no
> f00f_bug        : no
> coma_bug        : yes
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 1
> wp              : yes
> flags           : fpu cyrix_arr ds_cpl est cid
> bogomips        : 120.01
>
> BIOS EBDA/lowmem at: 00000000/000a0000
> Linux version 2.6.28 (root@box48) (gcc version 4.3.2 (Debian
> 4.3.2-1.1) ) #1 Tue Jan 13 11:59:16 EST 2009
> KERNEL supported cpus:
>   Intel GenuineIntel
>   AMD AuthenticAMD
>   NSC Geode by NSC
>   Cyrix CyrixInstead
>   Centaur CentaurHauls
>   Transmeta GenuineTMx86
>   Transmeta TransmetaCPU
>   UMC UMC UMC UMC
> Enabling CPUID on Cyrix processor.
> BIOS-provided physical RAM map:
>  BIOS-e820: 0000000000000000 - 00000000000a0000 (usable)
>  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
>  BIOS-e820: 0000000000100000 - 0000000003000000 (usable)
>  BIOS-e820: 00000000ffff0000 - 0000000100000000 (reserved)
> DMI not present or invalid.
> last_pfn = 0x3000 max_arch_pfn = 0x100000
> 48MB LOWMEM available.
>   mapped low ram: 0 - 03000000
>   low ram: 00000000 - 03000000
>   bootmap 00001000 - 00001600
> (6 early reservations) ==> bootmem [0000000000 - 0003000000]
>   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
>   #1 [0000100000 - 000036697c]    TEXT DATA BSS ==> [0000100000 - 000036697c]
>   #2 [0000367000 - 0000369000]    INIT_PG_TABLE ==> [0000367000 - 0000369000]
>   #3 [000009f000 - 0000100000]    BIOS reserved ==> [000009f000 - 0000100000]
>   #4 [0000007000 - 0000012000]          PGTABLE ==> [0000007000 - 0000012000]
>   #5 [0000001000 - 0000002000]          BOOTMAP ==> [0000001000 - 0000002000]
> Zone PFN ranges:
>   DMA      0x00000000 -> 0x00001000
>   Normal   0x00001000 -> 0x00003000
> Movable zone start PFN for each node
> early_node_map[2] active PFN ranges
>     0: 0x00000000 -> 0x000000a0
>     0: 0x00000100 -> 0x00003000
> Allocating PCI resources starting at 10000000 (gap: 3000000:fcff0000)
> Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 12096
> Kernel command line: root=/dev/hda1 ro console=tty0 console=ttyS0,115200
> Initializing CPU#0
> PID hash table entries: 256 (order: 8, 1024 bytes)
> Console: colour VGA+ 80x25
> console [tty0] enabled
> console [ttyS0] enabled
> Dentry cache hash table entries: 8192 (order: 3, 32768 bytes)
> Inode-cache hash table entries: 4096 (order: 2, 16384 bytes)
> Memory: 45680k/49152k available (1557k kernel code, 3084k reserved,
> 602k data, 184k init, 0k highmem)
> virtual kernel memory layout:
>     fixmap  : 0xfffed000 - 0xfffff000   (  72 kB)
>     vmalloc : 0xc3800000 - 0xfffeb000   ( 967 MB)
>     lowmem  : 0xc0000000 - 0xc3000000   (  48 MB)
>       .init : 0xc031e000 - 0xc034c000   ( 184 kB)
>       .data : 0xc0285437 - 0xc031be58   ( 602 kB)
>       .text : 0xc0100000 - 0xc0285437   (1557 kB)
> Checking if this processor honours the WP bit even in supervisor mode...Ok.
> Calibrating delay loop... 119.55 BogoMIPS (lpj=239104)
> Mount-cache hash table entries: 512
> Enabling CPUID on Cyrix processor.
> Enabling CPUID on Cyrix processor.
> CPU: Cyrix 6x86 2x Core/Bus Clock stepping 05
> Checking 'hlt' instruction... OK.
> invalid opcode: 0000 [#1]
> last sysfs file:
>
> Pid: 0, comm: swapper Not tainted (2.6.28 #1)
> EIP: 0060:[<c03220c6>] EFLAGS: 00010203 CPU: 0
> EIP is at stop_mce+0x0/0x19
> EAX: 00000004 EBX: c03378c8 ECX: c031dfec EDX: 00000034
> ESI: 00099800 EDI: c0316000 EBP: 0078d003 ESP: c031dfe4
>  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
> Process swapper (pid: 0, ti=c031c000 task=c02f7300 task.ti=c031c000)
> Stack:
>  c0321865 c03220c4 00000000 c031e829 c03378c8 00000000 00000000
> Call Trace:
>  [<c0321865>] alternative_instructions+0xa/0x37
>  [<c03220c4>] check_bugs+0xcd/0xcf
>  [<c031e829>] start_kernel+0x1da/0x1e2
> Code: 09 f4 f4 f4 f4 68 6c 97 2c c0 e8 32 10 f6 ff a0 40 8a 31 c0 5a
> 3c 06 b2 36 77 03 8d 50 30 88 15 b1 a0 2f c0 e8 97 f7 ff ff 58 c3 <0f>
> 20 e0 83 25 f0 00 35 c0 bf a3 f8 ba 33 c0 0f 20 e0 83 e0 bf
> EIP: [<c03220c6>] stop_mce+0x0/0x19 SS:ESP 0068:c031dfe4
>   

Looks like the quick fix is to turn off CONFIG_X86_MCE, but I guess the 
right fix is to make sure that stop_mce does nothing on chips which 
don't support it, or even have a CR4.

    J
