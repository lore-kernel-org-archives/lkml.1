Return-Path: <linux-kernel-owner+w=401wt.eu-S1756064AbZKGCOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064AbZKGCOb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 21:14:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755209AbZKGCOa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 21:14:30 -0500
Received: from mail.candelatech.com ([208.74.158.172]:42651 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754424AbZKGCO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 21:14:27 -0500
X-Greylist: delayed 3103 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Nov 2009 21:14:27 EST
Message-ID: <4AF4CBE9.5090707@candelatech.com>
Date: Fri, 06 Nov 2009 17:22:49 -0800
From: Hun-Kyi Wynn <hkwynn@candelatech.com>
Organization: Candela Technologies Inc.
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: please boot with early_ioremap_debug and report the dmesg
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Running Fedora 11:

Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Linux version 2.6.30.9-90.fc11.i686.PAE (mockbuild@x86-5.fedora.phx.redhat.com) 
(gcc version 4.4.1 20090725 (Red Hat 4.4.1-2) (GCC) ) #1 SMP Sat Oct 17 11:24:32 
EDT 2009
KERNEL supported cpus:
   Intel GenuineIntel
   AMD AuthenticAMD
   NSC Geode by NSC
   Cyrix CyrixInstead
   Centaur CentaurHauls
   Transmeta GenuineTMx86
   Transmeta TransmetaCPU
   UMC UMC UMC UMC
BIOS-provided physical RAM map:
  BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
  BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)
  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
  BIOS-e820: 0000000000100000 - 000000007f690000 (usable)
  BIOS-e820: 000000007f690000 - 000000007f6e0000 (reserved)
  BIOS-e820: 000000007f6e0000 - 000000007f6e3000 (ACPI NVS)
  BIOS-e820: 000000007f6e3000 - 000000007f6f0000 (ACPI data)
  BIOS-e820: 000000007f6f0000 - 000000007f700000 (reserved)
  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
console [earlyvga0] enabled
early_ioremap(000f0000, 00010000) [0] => Pid: 0, comm: swapper Not tainted 
2.6.30.9-90.fc11.i686.PAE #1
Call Trace:
  [<c0738645>] ? printk+0x14/0x17
  [<c0965e07>] __early_ioremap+0x60/0x19b
  [<c0956c2f>] ? e820_print_map+0x44/0x57
  [<c0965f68>] early_ioremap+0x12/0x14
  [<c097cad2>] dmi_scan_machine+0x66/0xc9
  [<c0955572>] setup_arch+0x3ee/0xa09
  [<c043607e>] ? vprintk+0x2da/0x2fc
  [<c0576467>] ? strncpy+0xb/0x23
  [<c0957abd>] ? __reserve_early+0xeb/0xff
  [<c0433376>] ? cpu_cgroup_create+0x8/0x49
  [<c09515df>] start_kernel+0x6d/0x2e6
  [<c0951081>] i386_start_kernel+0x70/0x77
00000000 + ffb00000
early_iounmap(ffb00000, 00010000) [0]
Pid: 0, comm: swapper Not tainted 2.6.30.9-90.fc11.i686.PAE #1
Call Trace:
  [<c0738645>] ? printk+0x14/0x17
  [<c0965feb>] early_iounmap+0x81/0x123
  [<c097cb18>] dmi_scan_machine+0xac/0xc9
  [<c0955572>] setup_arch+0x3ee/0xa09
  [<c043607e>] ? vprintk+0x2da/0x2fc
  [<c0576467>] ? strncpy+0xb/0x23
  [<c0957abd>] ? __reserve_early+0xeb/0xff
  [<c0433376>] ? cpu_cgroup_create+0x8/0x49
  [<c09515df>] start_kernel+0x6d/0x2e6
  [<c0951081>] i386_start_kernel+0x70/0x77
DMI not present or invalid.
last_pfn = 0x7f690 max_arch_pfn = 0x1000000
MTRR default type: uncachable
MTRR fixed ranges enabled:
   00000-9FFFF write-back
   A0000-EFFFF uncachable
   F0000-FFFFF write-through
MTRR variable ranges enabled:
   0 base 000000000 mask 080000000 write-back
   1 base 07F800000 mask 0FF800000 uncachable
   2 base 07F700000 mask 0FFF00000 uncachable
   3 disabled
   4 disabled
   5 disabled
   6 disabled
   7 disabled
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
original variable MTRRs
reg 0, base: 0GB, range: 2GB, type WB
reg 1, base: 2040MB, range: 8MB, type UC
reg 2, base: 2039MB, range: 1MB, type UC
total RAM coverred: 2039M
Found optimal setting for mtrr clean up
  gran_size: 64K         chunk_size: 16M         num_reg: 3      lose cover RAM: 0G
New variable MTRRs
reg 0, base: 0GB, range: 2GB, type WB
reg 1, base: 2039MB, range: 1MB, type UC
reg 2, base: 2040MB, range: 8MB, type UC
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
init_memory_mapping: 0000000000000000-00000000377fe000
NX (Execute Disable) protection: active
  0000000000 - 0000200000 page 4k
  0000200000 - 0037600000 page 2M
  0037600000 - 00377fe000 page 4k
kernel direct mapping tables up to 377fe000 @ 7000-e000
RAMDISK: 37cd6000 - 37feff13
Allocated new RAMDISK: 00a95000 - 00daef13
early_ioremap(37cd6000, 00040000) [0] => Pid: 0, comm: swapper Not tainted 
2.6.30.9-90.fc11.i686.PAE #1
Call Trace:
  [<c0738645>] ? printk+0x14/0x17
  [<c0965e07>] __early_ioremap+0x60/0x19b
  [<c0965f54>] early_memremap+0x12/0x14
  [<c09558a8>] setup_arch+0x724/0xa09
  [<c0433376>] ? cpu_cgroup_create+0x8/0x49
  [<c09515df>] start_kernel+0x6d/0x2e6
  [<c0951081>] i386_start_kernel+0x70/0x77
00000000 + ffb00000
early_iounmap(ffb00000, 00040000) [0]
Pid: 0, comm: swapper Not tainted 2.6.30.9-90.fc11.i686.PAE #1
Call Trace:
  [<c0738645>] ? printk+0x14/0x17
  [<c0965feb>] early_iounmap+0x81/0x123
  [<c09558c8>] setup_arch+0x744/0xa09
  [<c0433376>] ? cpu_cgroup_create+0x8/0x49
  [<c09515df>] start_kernel+0x6d/0x2e6
  [<c0951081>] i386_start_kernel+0x70/0x77
early_ioremap(37d16000, 00040000) [0] => Pid: 0, comm: swapper Not tainted 
2.6.30.9-90.fc11.i686.PAE #1
Call Trace:
  [<c0738645>] ? printk+0x14/0x17
  [<c0965e07>] __early_ioremap+0x60/0x19b
  [<c0965f54>] early_memremap+0x12/0x14
  [<c09558a8>] setup_arch+0x724/0xa09
  [<c0433376>] ? cpu_cgroup_create+0x8/0x49
  [<c09515df>] start_kernel+0x6d/0x2e6
  [<c0951081>] i386_start_kernel+0x70/0x77
00000000 + ffb00000
early_iounmap(ffb00000, 00040000) [0]
Pid: 0, comm: swapper Not tainted 2.6.30.9-90.fc11.i686.PAE #1
Call Trace:
  [<c0738645>] ? printk+0x14/0x17
  [<c0965feb>] early_iounmap+0x81/0x123
  [<c09558c8>] setup_arch+0x744/0xa09
  [<c0433376>] ? cpu_cgroup_create+0x8/0x49
  [<c09515df>] start_kernel+0x6d/0x2e6
  [<c0951081>] i386_start_kernel+0x70/0x77
early_ioremap(37d56000, 00040000) [0] => Pid: 0, comm: swapper Not tainted 
2.6.30.9-90.fc11.i686.PAE #1
Call Trace:
  [<c0738645>] ? printk+0x14/0x17
  [<c0965e07>] __early_ioremap+0x60/0x19b
  [<c0965f54>] early_memremap+0x12/0x14
  [<c09558a8>] setup_arch+0x724/0xa09
  [<c0433376>] ? cpu_cgroup_create+0x8/0x49
  [<c09515df>] start_kernel+0x6d/0x2e6
  [<c0951081>] i386_start_kernel+0x70/0x77
00000000 + ffb00000
early_iounmap(ffb00000, 00040000) [0]
Pid: 0, comm: swapper Not tainted 2.6.30.9-90.fc11.i686.PAE #1
Call Trace:
  [<c0738645>] ? printk+0x14/0x17
  [<c0965feb>] early_iounmap+0x81/0x123
  [<c09558c8>] setup_arch+0x744/0xa09
  [<c0433376>] ? cpu_cgroup_create+0x8/0x49
  [<c09515df>] start_kernel+0x6d/0x2e6
  [<c0951081>] i386_start_kernel+0x70/0x77
early_ioremap(37d96000, 00040000) [0] => Pid: 0, comm: swapper Not tainted 
2.6.30.9-90.fc11.i686.PAE #1
Call Trace:
  [<c0738645>] ? printk+0x14/0x17
  [<c0965e07>] __early_ioremap+0x60/0x19b
  [<c0965f54>] early_memremap+0x12/0x14
  [<c09558a8>] setup_arch+0x724/0xa09
  [<c0433376>] ? cpu_cgroup_create+0x8/0x49
  [<c09515df>] start_kernel+0x6d/0x2e6
  [<c0951081>] i386_start_kernel+0x70/0x77
00000000 + ffb00000
early_iounmap(ffb00000, 00040000) [0]
Pid: 0, comm: swapper Not tainted 2.6.30.9-90.fc11.i686.PAE #1
Call Trace:
  [<c0738645>] ? printk+0x14/0x17
  [<c0965feb>] early_iounmap+0x81/0x123
  [<c09558c8>] setup_arch+0x744/0xa09
  [<c0433376>] ? cpu_cgroup_create+0x8/0x49
  [<c09515df>] start_kernel+0x6d/0x2e6
  [<c0951081>] i386_start_kernel+0x70/0x77
early_ioremap(37dd6000, 00040000) [0] => Pid: 0, comm: swapper Not tainted 
2.6.30.9-90.fc11.i686.PAE #1
Call Trace:
  [<c0738645>] ? printk+0x14/0x17
  [<c0965e07>] __early_ioremap+0x60/0x19b
  [<c0965f54>] early_memremap+0x12/0x14
  [<c09558a8>] setup_arch+0x724/0xa09
  [<c0433376>] ? cpu_cgroup_create+0x8/0x49
  [<c09515df>] start_kernel+0x6d/0x2e6
  [<c0951081>] i386_start_kernel+0x70/0x77
00000000 + ffb00000
early_iounmap(ffb00000, 00040000) [0]
Pid: 0, comm: swapper Not tainted 2.6.30.9-90.fc11.i686.PAE #1
Call Trace:
  [<c0738645>] ? printk+0x14/0x17
  [<c0965feb>] early_iounmap+0x81/0x123
  [<c09558c8>] setup_arch+0x744/0xa09
  [<c0433376>] ? cpu_cgroup_create+0x8/0x49
  [<c09515df>] start_kernel+0x6d/0x2e6
  [<c0951081>] i386_start_kernel+0x70/0x77
early_ioremap(37e16000, 00040000) [0] => Pid: 0, comm: swapper Not tainted 
2.6.30.9-90.fc11.i686.PAE #1
Call Trace:
  [<c0738645>] ? printk+0x14/0x17
  [<c0965e07>] __early_ioremap+0x60/0x19b
  [<c0965f54>] early_memremap+0x12/0x14
  [<c09558a8>] setup_arch+0x724/0xa09
  [<c0433376>] ? cpu_cgroup_create+0x8/0x49
  [<c09515df>] start_kernel+0x6d/0x2e6
  [<c0951081>] i386_start_kernel+0x70/0x77
00000000 + ffb00000
early_iounmap(ffb00000, 00040000) [0]
Pid: 0, comm: swapper Not tainted 2.6.30.9-90.fc11.i686.PAE #1
Call Trace:
  [<c0738645>] ? printk+0x14/0x17
  [<c0965feb>] early_iounmap+0x81/0x123
  [<c09558c8>] setup_arch+0x744/0xa09
  [<c0433376>] ? cpu_cgroup_create+0x8/0x49
  [<c09515df>] start_kernel+0x6d/0x2e6
  [<c0951081>] i386_start_kernel+0x70/0x77
early_ioremap(37e56000, 00040000) [0] => Pid: 0, comm: swapper Not tainted 
2.6.30.9-90.fc11.i686.PAE #1
Call Trace:
  [<c0738645>] ? printk+0x14/0x17
  [<c0965e07>] __early_ioremap+0x60/0x19b
  [<c0965f54>] early_memremap+0x12/0x14
  [<c09558a8>] setup_arch+0x724/0xa09
  [<c0433376>] ? cpu_cgroup_create+0x8/0x49
  [<c09515df>] start_kernel+0x6d/0x2e6
  [<c0951081>] i386_start_kernel+0x70/0x77
00000000 + ffb00000
early_iounmap(ffb00000, 00040000) [0]
Pid: 0, comm: swapper Not tainted 2.6.30.9-90.fc11.i686.PAE #1
Call Trace:
  [<c0738645>] ? printk+0x14/0x17
  [<c0965feb>] early_iounmap+0x81/0x123
  [<c09558c8>] setup_arch+0x744/0xa09
  [<c0433376>] ? cpu_cgroup_create+0x8/0x49
  [<c09515df>] start_kernel+0x6d/0x2e6
  [<c0951081>] i386_start_kernel+0x70/0x77
early_ioremap(37e96000, 00040000) [0] => Pid: 0, comm: swapper Not tainted 
2.6.30.9-90.fc11.i686.PAE #1
Call Trace:
  [<c0738645>] ? printk+0x14/0x17
  [<c0965e07>] __early_ioremap+0x60/0x19b
  [<c0965f54>] early_memremap+0x12/0x14
  [<c09558a8>] setup_arch+0x724/0xa09
  [<c0433376>] ? cpu_cgroup_create+0x8/0x49
  [<c09515df>] start_kernel+0x6d/0x2e6
  [<c0951081>] i386_start_kernel+0x70/0x77
00000000 + ffb00000
early_iounmap(ffb00000, 00040000) [0]
Pid: 0, comm: swapper Not tainted 2.6.30.9-90.fc11.i686.PAE #1
Call Trace:
  [<c0738645>] ? printk+0x14/0x17
  [<c0965feb>] early_iounmap+0x81/0x123
  [<c09558c8>] setup_arch+0x744/0xa09
  [<c0433376>] ? cpu_cgroup_create+0x8/0x49
  [<c09515df>] start_kernel+0x6d/0x2e6
  [<c0951081>] i386_start_kernel+0x70/0x77
early_ioremap(37ed6000, 00040000) [0] => Pid: 0, comm: swapper Not tainted 
2.6.30.9-90.fc11.i686.PAE #1
Call Trace:
  [<c0738645>] ? printk+0x14/0x17
  [<c0965e07>] __early_ioremap+0x60/0x19b
  [<c0965f54>] early_memremap+0x12/0x14
  [<c09558a8>] setup_arch+0x724/0xa09
  [<c0433376>] ? cpu_cgroup_create+0x8/0x49
  [<c09515df>] start_kernel+0x6d/0x2e6
  [<c0951081>] i386_start_kernel+0x70/0x77
00000000 + ffb00000
early_iounmap(ffb00000, 00040000) [0]
Pid: 0, comm: swapper Not tainted 2.6.30.9-90.fc11.i686.PAE #1
Call Trace:
  [<c0738645>] ? printk+0x14/0x17
  [<c0965feb>] early_iounmap+0x81/0x123
  [<c09558c8>] setup_arch+0x744/0xa09
  [<c0433376>] ? cpu_cgroup_create+0x8/0x49
  [<c09515df>] start_kernel+0x6d/0x2e6
  [<c0951081>] i386_start_kernel+0x70/0x77
early_ioremap(37f16000, 00040000) [0] => Pid: 0, comm: swapper Not tainted 
2.6.30.9-90.fc11.i686.PAE #1
Call Trace:
  [<c0738645>] ? printk+0x14/0x17
  [<c0965e07>] __early_ioremap+0x60/0x19b
  [<c0965f54>] early_memremap+0x12/0x14
  [<c09558a8>] setup_arch+0x724/0xa09
  [<c0433376>] ? cpu_cgroup_create+0x8/0x49
  [<c09515df>] start_kernel+0x6d/0x2e6
  [<c0951081>] i386_start_kernel+0x70/0x77
00000000 + ffb00000
early_iounmap(ffb00000, 00040000) [0]
Pid: 0, comm: swapper Not tainted 2.6.30.9-90.fc11.i686.PAE #1
Call Trace:
  [<c0738645>] ? printk+0x14/0x17
  [<c0965feb>] early_iounmap+0x81/0x123
  [<c09558c8>] setup_arch+0x744/0xa09
  [<c0433376>] ? cpu_cgroup_create+0x8/0x49
  [<c09515df>] start_kernel+0x6d/0x2e6
  [<c0951081>] i386_start_kernel+0x70/0x77
early_ioremap(37f56000, 00040000) [0] => Pid: 0, comm: swapper Not tainted 
2.6.30.9-90.fc11.i686.PAE #1
Call Trace:
  [<c0738645>] ? printk+0x14/0x17
  [<c0965e07>] __early_ioremap+0x60/0x19b
  [<c0965f54>] early_memremap+0x12/0x14
  [<c09558a8>] setup_arch+0x724/0xa09
  [<c0433376>] ? cpu_cgroup_create+0x8/0x49
  [<c09515df>] start_kernel+0x6d/0x2e6
  [<c0951081>] i386_start_kernel+0x70/0x77
00000000 + ffb00000
early_iounmap(ffb00000, 00040000) [0]
Pid: 0, comm: swapper Not tainted 2.6.30.9-90.fc11.i686.PAE #1
Call Trace:
  [<c0738645>] ? printk+0x14/0x17
  [<c0965feb>] early_iounmap+0x81/0x123
  [<c09558c8>] setup_arch+0x744/0xa09
  [<c0433376>] ? cpu_cgroup_create+0x8/0x49
  [<c09515df>] start_kernel+0x6d/0x2e6
  [<c0951081>] i386_start_kernel+0x70/0x77
early_ioremap(37f96000, 00040000) [0] => Pid: 0, comm: swapper Not tainted 
2.6.30.9-90.fc11.i686.PAE #1
Call Trace:
  [<c0738645>] ? printk+0x14/0x17
  [<c0965e07>] __early_ioremap+0x60/0x19b
  [<c0965f54>] early_memremap+0x12/0x14
  [<c09558a8>] setup_arch+0x724/0xa09
  [<c0433376>] ? cpu_cgroup_create+0x8/0x49
  [<c09515df>] start_kernel+0x6d/0x2e6
  [<c0951081>] i386_start_kernel+0x70/0x77
00000000 + ffb00000
early_iounmap(ffb00000, 00040000) [0]
Pid: 0, comm: swapper Not tainted 2.6.30.9-90.fc11.i686.PAE #1
Call Trace:
  [<c0738645>] ? printk+0x14/0x17
  [<c0965feb>] early_iounmap+0x81/0x123
  [<c09558c8>] setup_arch+0x744/0xa09
  [<c0433376>] ? cpu_cgroup_create+0x8/0x49
  [<c09515df>] start_kernel+0x6d/0x2e6
  [<c0951081>] i386_start_kernel+0x70/0x77
early_ioremap(37fd6000, 00019f13) [0] => Pid: 0, comm: swapper Not tainted 
2.6.30.9-90.fc11.i686.PAE #1
Call Trace:
  [<c0738645>] ? printk+0x14/0x17
  [<c0965e07>] __early_ioremap+0x60/0x19b
  [<c0965f54>] early_memremap+0x12/0x14
  [<c09558a8>] setup_arch+0x724/0xa09
  [<c0433376>] ? cpu_cgroup_create+0x8/0x49
  [<c09515df>] start_kernel+0x6d/0x2e6
  [<c0951081>] i386_start_kernel+0x70/0x77
00000000 + ffb00000
early_iounmap(ffb00000, 00019f13) [0]
Pid: 0, comm: swapper Not tainted 2.6.30.9-90.fc11.i686.PAE #1
Call Trace:
  [<c0738645>] ? printk+0x14/0x17
  [<c0965feb>] early_iounmap+0x81/0x123
  [<c09558c8>] setup_arch+0x744/0xa09
  [<c0433376>] ? cpu_cgroup_create+0x8/0x49
  [<c09515df>] start_kernel+0x6d/0x2e6
  [<c0951081>] i386_start_kernel+0x70/0x77
Move RAMDISK from 0000000037cd6000 - 0000000037feff12 to 00a95000 - 00daef12
early_ioremap(0000040e, 00000002) [0] => Pid: 0, comm: swapper Not tainted 
2.6.30.9-90.fc11.i686.PAE #1
Call Trace:
  [<c0738645>] ? printk+0x14/0x17
  [<c0965e07>] __early_ioremap+0x60/0x19b
  [<c040ae84>] ? show_trace_log_lvl+0x39/0x43
  [<c0965f68>] early_ioremap+0x12/0x14
  [<c095c686>] __acpi_map_table+0x18/0x1a
  [<c072a2a6>] acpi_os_map_memory+0x21/0x23
  [<c05c877b>] acpi_find_root_pointer+0x20/0x12d
  [<c09756d6>] acpi_os_get_root_pointer+0x41/0x46
  [<c0976601>] acpi_initialize_tables+0x67/0x81
  [<c0974f94>] acpi_table_init+0x17/0x8b
  [<c095bf22>] acpi_boot_table_init+0x2e/0xc9
  [<c095593f>] setup_arch+0x7bb/0xa09
  [<c0433376>] ? cpu_cgroup_create+0x8/0x49
  [<c09515df>] start_kernel+0x6d/0x2e6
  [<c0951081>] i386_start_kernel+0x70/0x77
0000040e + ffb00000
early_iounmap(ffb0040e, 00000002) [0]
Pid: 0, comm: swapper Not tainted 2.6.30.9-90.fc11.i686.PAE #1
Call Trace:
  [<c0738645>] ? printk+0x14/0x17
  [<c0965feb>] early_iounmap+0x81/0x123
  [<c095c66c>] __acpi_unmap_table+0x10/0x12
  [<c072a283>] acpi_os_unmap_memory+0x1d/0x1f
  [<c05c879f>] acpi_find_root_pointer+0x44/0x12d
  [<c09756d6>] acpi_os_get_root_pointer+0x41/0x46
  [<c0976601>] acpi_initialize_tables+0x67/0x81
  [<c0974f94>] acpi_table_init+0x17/0x8b
  [<c095bf22>] acpi_boot_table_init+0x2e/0xc9
  [<c095593f>] setup_arch+0x7bb/0xa09
  [<c0433376>] ? cpu_cgroup_create+0x8/0x49
  [<c09515df>] start_kernel+0x6d/0x2e6
  [<c0951081>] i386_start_kernel+0x70/0x77
early_ioremap(0009f000, 00000400) [0] => Pid: 0, comm: swapper Not tainted 
2.6.30.9-90.fc11.i686.PAE #1
Call Trace:
  [<c0738645>] ? printk+0x14/0x17
  [<c0965e07>] __early_ioremap+0x60/0x19b
  [<c0965f68>] early_ioremap+0x12/0x14
  [<c095c686>] __acpi_map_table+0x18/0x1a
  [<c072a2a6>] acpi_os_map_memory+0x21/0x23
  [<c05c87b6>] acpi_find_root_pointer+0x5b/0x12d
  [<c09756d6>] acpi_os_get_root_pointer+0x41/0x46
  [<c0976601>] acpi_initialize_tables+0x67/0x81
  [<c0974f94>] acpi_table_init+0x17/0x8b
  [<c095bf22>] acpi_boot_table_init+0x2e/0xc9
  [<c095593f>] setup_arch+0x7bb/0xa09
  [<c0433376>] ? cpu_cgroup_create+0x8/0x49
  [<c09515df>] start_kernel+0x6d/0x2e6
  [<c0951081>] i386_start_kernel+0x70/0x77
00000000 + ffb00000
early_iounmap(ffb00000, 00000400) [0]
Pid: 0, comm: swapper Not tainted 2.6.30.9-90.fc11.i686.PAE #1
Call Trace:
  [<c0738645>] ? printk+0x14/0x17
  [<c0965feb>] early_iounmap+0x81/0x123
  [<c095c66c>] __acpi_unmap_table+0x10/0x12
  [<c072a283>] acpi_os_unmap_memory+0x1d/0x1f
  [<c05c87fb>] acpi_find_root_pointer+0xa0/0x12d
  [<c09756d6>] acpi_os_get_root_pointer+0x41/0x46
  [<c0976601>] acpi_initialize_tables+0x67/0x81
  [<c0974f94>] acpi_table_init+0x17/0x8b
  [<c095bf22>] acpi_boot_table_init+0x2e/0xc9
  [<c095593f>] setup_arch+0x7bb/0xa09
  [<c0433376>] ? cpu_cgroup_create+0x8/0x49
  [<c09515df>] start_kernel+0x6d/0x2e6
  [<c0951081>] i386_start_kernel+0x70/0x77
early_ioremap(000e0000, 00020000) [0] => Pid: 0, comm: swapper Not tainted 
2.6.30.9-90.fc11.i686.PAE #1
Call Trace:
  [<c0738645>] ? printk+0x14/0x17
  [<c0965e07>] __early_ioremap+0x60/0x19b
  [<c0965f68>] early_ioremap+0x12/0x14
  [<c095c686>] __acpi_map_table+0x18/0x1a
  [<c072a2a6>] acpi_os_map_memory+0x21/0x23
  [<c05c881a>] acpi_find_root_pointer+0xbf/0x12d
  [<c09756d6>] acpi_os_get_root_pointer+0x41/0x46
  [<c0976601>] acpi_initialize_tables+0x67/0x81
  [<c0974f94>] acpi_table_init+0x17/0x8b
  [<c095bf22>] acpi_boot_table_init+0x2e/0xc9
  [<c095593f>] setup_arch+0x7bb/0xa09
  [<c0433376>] ? cpu_cgroup_create+0x8/0x49
  [<c09515df>] start_kernel+0x6d/0x2e6
  [<c0951081>] i386_start_kernel+0x70/0x77
00000000 + ffb00000
early_iounmap(ffb00000, 00020000) [0]
Pid: 0, comm: swapper Not tainted 2.6.30.9-90.fc11.i686.PAE #1
Call Trace:
  [<c0738645>] ? printk+0x14/0x17
  [<c0965feb>] early_iounmap+0x81/0x123
  [<c095c66c>] __acpi_unmap_table+0x10/0x12
  [<c072a283>] acpi_os_unmap_memory+0x1d/0x1f
  [<c05c884e>] acpi_find_root_pointer+0xf3/0x12d
  [<c09756d6>] acpi_os_get_root_pointer+0x41/0x46
  [<c0976601>] acpi_initialize_tables+0x67/0x81
  [<c0974f94>] acpi_table_init+0x17/0x8b
  [<c095bf22>] acpi_boot_table_init+0x2e/0xc9
  [<c095593f>] setup_arch+0x7bb/0xa09
  [<c0433376>] ? cpu_cgroup_create+0x8/0x49
  [<c09515df>] start_kernel+0x6d/0x2e6
  [<c0951081>] i386_start_kernel+0x70/0x77
early_ioremap(000f7690, 00000024) [0] => Pid: 0, comm: swapper Not tainted 
2.6.30.9-90.fc11.i686.PAE #1
Call Trace:
  [<c0738645>] ? printk+0x14/0x17
  [<c0965e07>] __early_ioremap+0x60/0x19b
  [<c0965f68>] early_ioremap+0x12/0x14
  [<c095c686>] __acpi_map_table+0x18/0x1a
  [<c072a2a6>] acpi_os_map_memory+0x21/0x23
  [<c0976630>] acpi_tb_parse_root_table+0x15/0x2a6
  [<c072a283>] ? acpi_os_unmap_memory+0x1d/0x1f
  [<c05c884e>] ? acpi_find_root_pointer+0xf3/0x12d
  [<c0976613>] acpi_initialize_tables+0x79/0x81
  [<c0974f94>] acpi_table_init+0x17/0x8b
  [<c095bf22>] acpi_boot_table_init+0x2e/0xc9
  [<c095593f>] setup_arch+0x7bb/0xa09
  [<c0433376>] ? cpu_cgroup_create+0x8/0x49
  [<c09515df>] start_kernel+0x6d/0x2e6
  [<c0951081>] i386_start_kernel+0x70/0x77
00000690 + ffb00000
ACPI: RSDP 000f7690 00014 (v00 IntelR)
early_iounmap(ffb00690, 00000024) [0]
Pid: 0, comm: swapper Not tainted 2.6.30.9-90.fc11.i686.PAE #1
Call Trace:
  [<c0738645>] ? printk+0x14/0x17
  [<c0965feb>] early_iounmap+0x81/0x123
  [<c095c66c>] __acpi_unmap_table+0x10/0x12
  [<c072a283>] acpi_os_unmap_memory+0x1d/0x1f
  [<c0976681>] acpi_tb_parse_root_table+0x66/0x2a6
  [<c072a283>] ? acpi_os_unmap_memory+0x1d/0x1f
  [<c05c884e>] ? acpi_find_root_pointer+0xf3/0x12d
  [<c0976613>] acpi_initialize_tables+0x79/0x81
  [<c0974f94>] acpi_table_init+0x17/0x8b
  [<c095bf22>] acpi_boot_table_init+0x2e/0xc9
  [<c095593f>] setup_arch+0x7bb/0xa09
  [<c0433376>] ? cpu_cgroup_create+0x8/0x49
  [<c09515df>] start_kernel+0x6d/0x2e6
  [<c0951081>] i386_start_kernel+0x70/0x77
early_ioremap(7f6e3000, 00000024) [0] => Pid: 0, comm: swapper Not tainted 
2.6.30.9-90.fc11.i686.PAE #1
Call Trace:
  [<c0738645>] ? printk+0x14/0x17
  [<c0965e07>] __early_ioremap+0x60/0x19b
  [<c0965f68>] early_ioremap+0x12/0x14
  [<c095c686>] __acpi_map_table+0x18/0x1a
  [<c072a2a6>] acpi_os_map_memory+0x21/0x23
  [<c09766f3>] acpi_tb_parse_root_table+0xd8/0x2a6
  [<c072a283>] ? acpi_os_unmap_memory+0x1d/0x1f
  [<c05c884e>] ? acpi_find_root_pointer+0xf3/0x12d
  [<c0976613>] acpi_initialize_tables+0x79/0x81
  [<c0974f94>] acpi_table_init+0x17/0x8b
  [<c095bf22>] acpi_boot_table_init+0x2e/0xc9
  [<c095593f>] setup_arch+0x7bb/0xa09
  [<c0433376>] ? cpu_cgroup_create+0x8/0x49
  [<c09515df>] start_kernel+0x6d/0x2e6
  [<c0951081>] i386_start_kernel+0x70/0x77
00000000 + ffb00000
ACPI: RSDT 7f6e3000 00034 (v01 IntelR AWRDACPI 42302E31 AWRD 00000000)
early_iounmap(ffb00000, 00000024) [0]
Pid: 0, comm: swapper Not tainted 2.6.30.9-90.fc11.i686.PAE #1
Call Trace:
  [<c0738645>] ? printk+0x14/0x17
  [<c0965feb>] early_iounmap+0x81/0x123
  [<c095c66c>] __acpi_unmap_table+0x10/0x12
  [<c072a283>] acpi_os_unmap_memory+0x1d/0x1f
  [<c0976715>] acpi_tb_parse_root_table+0xfa/0x2a6
  [<c072a283>] ? acpi_os_unmap_memory+0x1d/0x1f
  [<c05c884e>] ? acpi_find_root_pointer+0xf3/0x12d
  [<c0976613>] acpi_initialize_tables+0x79/0x81
  [<c0974f94>] acpi_table_init+0x17/0x8b
  [<c095bf22>] acpi_boot_table_init+0x2e/0xc9
  [<c095593f>] setup_arch+0x7bb/0xa09
  [<c0433376>] ? cpu_cgroup_create+0x8/0x49
  [<c09515df>] start_kernel+0x6d/0x2e6
  [<c0951081>] i386_start_kernel+0x70/0x77
early_ioremap(7f6e3000, 00000034) [0] => Pid: 0, comm: swapper Not tainted 
2.6.30.9-90.fc11.i686.PAE #1
Call Trace:
  [<c0738645>] ? printk+0x14/0x17
  [<c0965e07>] __early_ioremap+0x60/0x19b
  [<c0965f68>] early_ioremap+0x12/0x14
  [<c095c686>] __acpi_map_table+0x18/0x1a
  [<c072a2a6>] acpi_os_map_memory+0x21/0x23
  [<c0976745>] acpi_tb_parse_root_table+0x12a/0x2a6
  [<c072a283>] ? acpi_os_unmap_memory+0x1d/0x1f
  [<c05c884e>] ? acpi_find_root_pointer+0xf3/0x12d
  [<c0976613>] acpi_initialize_tables+0x79/0x81
  [<c0974f94>] acpi_table_init+0x17/0x8b
  [<c095bf22>] acpi_boot_table_init+0x2e/0xc9
  [<c095593f>] setup_arch+0x7bb/0xa09
  [<c0433376>] ? cpu_cgroup_create+0x8/0x49
  [<c09515df>] start_kernel+0x6d/0x2e6
  [<c0951081>] i386_start_kernel+0x70/0x77
00000000 + ffb00000
early_iounmap(ffb00000, 00000034) [0]
Pid: 0, comm: swapper Not tainted 2.6.30.9-90.fc11.i686.PAE #1
Call Trace:
  [<c0738645>] ? printk+0x14/0x17
  [<c0965feb>] early_iounmap+0x81/0x123
  [<c095c66c>] __acpi_unmap_table+0x10/0x12
  [<c072a283>] acpi_os_unmap_memory+0x1d/0x1f
  [<c097684e>] acpi_tb_parse_root_table+0x233/0x2a6
  [<c072a283>] ? acpi_os_unmap_memory+0x1d/0x1f
  [<c0976613>] acpi_initialize_tables+0x79/0x81
  [<c0974f94>] acpi_table_init+0x17/0x8b
  [<c095bf22>] acpi_boot_table_init+0x2e/0xc9
  [<c095593f>] setup_arch+0x7bb/0xa09
  [<c0433376>] ? cpu_cgroup_create+0x8/0x49
  [<c09515df>] start_kernel+0x6d/0x2e6
  [<c0951081>] i386_start_kernel+0x70/0x77
early_ioremap(7f6e3080, 00000024) [0] => Pid: 0, comm: swapper Not tainted 
2.6.30.9-90.fc11.i686.PAE #1
Call Trace:
  [<c0738645>] ? printk+0x14/0x17
  [<c0965e07>] __early_ioremap+0x60/0x19b
  [<c04251f9>] ? set_pte_vaddr+0xc1/0xc9
  [<c0965f68>] early_ioremap+0x12/0x14
  [<c095c686>] __acpi_map_table+0x18/0x1a
  [<c072a2a6>] acpi_os_map_memory+0x21/0x23
  [<c05c804b>] acpi_tb_install_table+0x47/0x126
  [<c0976869>] acpi_tb_parse_root_table+0x24e/0x2a6
  [<c072a283>] ? acpi_os_unmap_memory+0x1d/0x1f
  [<c0976613>] acpi_initialize_tables+0x79/0x81
  [<c0974f94>] acpi_table_init+0x17/0x8b
  [<c095bf22>] acpi_boot_table_init+0x2e/0xc9
  [<c095593f>] setup_arch+0x7bb/0xa09
  [<c0433376>] ? cpu_cgroup_create+0x8/0x49
  [<c09515df>] start_kernel+0x6d/0x2e6
  [<c0951081>] i386_start_kernel+0x70/0x77
00000080 + ffb00000
ACPI: FACP 7f6e3080 00074 (v01 IntelR AWRDACPI 42302E31 AWRD 00000000)
early_iounmap(ffb00080, 00000024) [0]
Pid: 0, comm: swapper Not tainted 2.6.30.9-90.fc11.i686.PAE #1
Call Trace:
  [<c0738645>] ? printk+0x14/0x17
  [<c0965feb>] early_iounmap+0x81/0x123
  [<c095c66c>] __acpi_unmap_table+0x10/0x12
  [<c072a283>] acpi_os_unmap_memory+0x1d/0x1f
  [<c05c8122>] acpi_tb_install_table+0x11e/0x126
  [<c0976869>] acpi_tb_parse_root_table+0x24e/0x2a6
  [<c072a283>] ? acpi_os_unmap_memory+0x1d/0x1f
  [<c0976613>] acpi_initialize_tables+0x79/0x81
  [<c0974f94>] acpi_table_init+0x17/0x8b
  [<c095bf22>] acpi_boot_table_init+0x2e/0xc9
  [<c095593f>] setup_arch+0x7bb/0xa09
  [<c0433376>] ? cpu_cgroup_create+0x8/0x49
  [<c09515df>] start_kernel+0x6d/0x2e6
  [<c0951081>] i386_start_kernel+0x70/0x77
early_ioremap(7f6e3080, 00000074) [0] => Pid: 0, comm: swapper Not tainted 
2.6.30.9-90.fc11.i686.PAE #1
Call Trace:
  [<c0738645>] ? printk+0x14/0x17
  [<c0965e07>] __early_ioremap+0x60/0x19b
  [<c0965f68>] early_ioremap+0x12/0x14
  [<c095c686>] __acpi_map_table+0x18/0x1a
  [<c072a2a6>] acpi_os_map_memory+0x21/0x23
  [<c05c86b8>] acpi_tb_parse_fadt+0x1f/0x67
  [<c0976881>] acpi_tb_parse_root_table+0x266/0x2a6
  [<c072a283>] ? acpi_os_unmap_memory+0x1d/0x1f
  [<c0976613>] acpi_initialize_tables+0x79/0x81
  [<c0974f94>] acpi_table_init+0x17/0x8b
  [<c095bf22>] acpi_boot_table_init+0x2e/0xc9
  [<c095593f>] setup_arch+0x7bb/0xa09
  [<c0433376>] ? cpu_cgroup_create+0x8/0x49
  [<c09515df>] start_kernel+0x6d/0x2e6
  [<c0951081>] i386_start_kernel+0x70/0x77
00000080 + ffb00000
early_iounmap(ffb00080, 00000074) [0]
Pid: 0, comm: swapper Not tainted 2.6.30.9-90.fc11.i686.PAE #1
Call Trace:
  [<c0738645>] ? printk+0x14/0x17
  [<c0965feb>] early_iounmap+0x81/0x123
  [<c095c66c>] __acpi_unmap_table+0x10/0x12
  [<c072a283>] acpi_os_unmap_memory+0x1d/0x1f
  [<c05c86d7>] acpi_tb_parse_fadt+0x3e/0x67
  [<c0976881>] acpi_tb_parse_root_table+0x266/0x2a6
  [<c072a283>] ? acpi_os_unmap_memory+0x1d/0x1f
  [<c0976613>] acpi_initialize_tables+0x79/0x81
  [<c0974f94>] acpi_table_init+0x17/0x8b
  [<c095bf22>] acpi_boot_table_init+0x2e/0xc9
  [<c095593f>] setup_arch+0x7bb/0xa09
  [<c0433376>] ? cpu_cgroup_create+0x8/0x49
  [<c09515df>] start_kernel+0x6d/0x2e6
  [<c0951081>] i386_start_kernel+0x70/0x77
early_ioremap(7f6e3100, 00000024) [0] => Pid: 0, comm: swapper Not tainted 
2.6.30.9-90.fc11.i686.PAE #1
Call Trace:
  [<c0738645>] ? printk+0x14/0x17
  [<c0965e07>] __early_ioremap+0x60/0x19b
  [<c04251f9>] ? set_pte_vaddr+0xc1/0xc9
  [<c0965f68>] early_ioremap+0x12/0x14
  [<c095c686>] __acpi_map_table+0x18/0x1a
  [<c072a2a6>] acpi_os_map_memory+0x21/0x23
  [<c05c804b>] acpi_tb_install_table+0x47/0x126
  [<c05c86e8>] acpi_tb_parse_fadt+0x4f/0x67
  [<c0976881>] acpi_tb_parse_root_table+0x266/0x2a6
  [<c072a283>] ? acpi_os_unmap_memory+0x1d/0x1f
  [<c0976613>] acpi_initialize_tables+0x79/0x81
  [<c0974f94>] acpi_table_init+0x17/0x8b
  [<c095bf22>] acpi_boot_table_init+0x2e/0xc9
  [<c095593f>] setup_arch+0x7bb/0xa09
  [<c0433376>] ? cpu_cgroup_create+0x8/0x49
  [<c09515df>] start_kernel+0x6d/0x2e6
  [<c0951081>] i386_start_kernel+0x70/0x77
00000100 + ffb00000
ACPI: DSDT 7f6e3100 04D2A (v01 INTELR AWRDACPI 00001000 MSFT 03000000)
early_iounmap(ffb00100, 00000024) [0]
Pid: 0, comm: swapper Not tainted 2.6.30.9-90.fc11.i686.PAE #1
Call Trace:
  [<c0738645>] ? printk+0x14/0x17
  [<c0965feb>] early_iounmap+0x81/0x123
  [<c095c66c>] __acpi_unmap_table+0x10/0x12
  [<c072a283>] acpi_os_unmap_memory+0x1d/0x1f
  [<c05c8122>] acpi_tb_install_table+0x11e/0x126
  [<c05c86e8>] acpi_tb_parse_fadt+0x4f/0x67
  [<c0976881>] acpi_tb_parse_root_table+0x266/0x2a6
  [<c072a283>] ? acpi_os_unmap_memory+0x1d/0x1f
  [<c0976613>] acpi_initialize_tables+0x79/0x81
  [<c0974f94>] acpi_table_init+0x17/0x8b
  [<c095bf22>] acpi_boot_table_init+0x2e/0xc9
  [<c095593f>] setup_arch+0x7bb/0xa09
  [<c0433376>] ? cpu_cgroup_create+0x8/0x49
  [<c09515df>] start_kernel+0x6d/0x2e6
  [<c0951081>] i386_start_kernel+0x70/0x77
early_ioremap(7f6e0000, 00000024) [0] => Pid: 0, comm: swapper Not tainted 
2.6.30.9-90.fc11.i686.PAE #1
Call Trace:
  [<c0738645>] ? printk+0x14/0x17
  [<c0965e07>] __early_ioremap+0x60/0x19b
  [<c0965f68>] early_ioremap+0x12/0x14
  [<c095c686>] __acpi_map_table+0x18/0x1a
  [<c072a2a6>] acpi_os_map_memory+0x21/0x23
  [<c05c804b>] acpi_tb_install_table+0x47/0x126
  [<c05c86fc>] acpi_tb_parse_fadt+0x63/0x67
  [<c0976881>] acpi_tb_parse_root_table+0x266/0x2a6
  [<c072a283>] ? acpi_os_unmap_memory+0x1d/0x1f
  [<c0976613>] acpi_initialize_tables+0x79/0x81
  [<c0974f94>] acpi_table_init+0x17/0x8b
  [<c095bf22>] acpi_boot_table_init+0x2e/0xc9
  [<c095593f>] setup_arch+0x7bb/0xa09
  [<c0433376>] ? cpu_cgroup_create+0x8/0x49
  [<c09515df>] start_kernel+0x6d/0x2e6
  [<c0951081>] i386_start_kernel+0x70/0x77
00000000 + ffb00000
ACPI: FACS 7f6e0000 00040
early_iounmap(ffb00000, 00000024) [0]
Pid: 0, comm: swapper Not tainted 2.6.30.9-90.fc11.i686.PAE #1
Call Trace:
  [<c0738645>] ? printk+0x14/0x17
  [<c0965feb>] early_iounmap+0x81/0x123
  [<c095c66c>] __acpi_unmap_table+0x10/0x12
  [<c072a283>] acpi_os_unmap_memory+0x1d/0x1f
  [<c05c8122>] acpi_tb_install_table+0x11e/0x126
  [<c05c86fc>] acpi_tb_parse_fadt+0x63/0x67
  [<c0976881>] acpi_tb_parse_root_table+0x266/0x2a6
  [<c072a283>] ? acpi_os_unmap_memory+0x1d/0x1f
  [<c0976613>] acpi_initialize_tables+0x79/0x81
  [<c0974f94>] acpi_table_init+0x17/0x8b
  [<c095bf22>] acpi_boot_table_init+0x2e/0xc9
  [<c095593f>] setup_arch+0x7bb/0xa09
  [<c0433376>] ? cpu_cgroup_create+0x8/0x49
  [<c09515df>] start_kernel+0x6d/0x2e6
  [<c0951081>] i386_start_kernel+0x70/0x77
early_ioremap(7f6e7f00, 00000024) [0] => Pid: 0, comm: swapper Not tainted 
2.6.30.9-90.fc11.i686.PAE #1
Call Trace:
  [<c0738645>] ? printk+0x14/0x17
  [<c0965e07>] __early_ioremap+0x60/0x19b
  [<c0965f68>] early_ioremap+0x12/0x14
  [<c095c686>] __acpi_map_table+0x18/0x1a
  [<c072a2a6>] acpi_os_map_memory+0x21/0x23
  [<c05c804b>] acpi_tb_install_table+0x47/0x126
  [<c0976869>] acpi_tb_parse_root_table+0x24e/0x2a6
  [<c072a283>] ? acpi_os_unmap_memory+0x1d/0x1f
  [<c0976613>] acpi_initialize_tables+0x79/0x81
  [<c0974f94>] acpi_table_init+0x17/0x8b
  [<c095bf22>] acpi_boot_table_init+0x2e/0xc9
  [<c095593f>] setup_arch+0x7bb/0xa09
  [<c0433376>] ? cpu_cgroup_create+0x8/0x49
  [<c09515df>] start_kernel+0x6d/0x2e6
  [<c0951081>] i386_start_kernel+0x70/0x77
00000f00 + ffb00000
ACPI: MCFG 7f6e7f00 0003C (v01 IntelR AWRDACPI 42302E31 AWRD 00000000)
early_iounmap(ffb00f00, 00000024) [0]
Pid: 0, comm: swapper Not tainted 2.6.30.9-90.fc11.i686.PAE #1
Call Trace:
  [<c0738645>] ? printk+0x14/0x17
  [<c0965feb>] early_iounmap+0x81/0x123
  [<c095c66c>] __acpi_unmap_table+0x10/0x12
  [<c072a283>] acpi_os_unmap_memory+0x1d/0x1f
  [<c05c8122>] acpi_tb_install_table+0x11e/0x126
  [<c0976869>] acpi_tb_parse_root_table+0x24e/0x2a6
  [<c072a283>] ? acpi_os_unmap_memory+0x1d/0x1f
  [<c0976613>] acpi_initialize_tables+0x79/0x81
  [<c0974f94>] acpi_table_init+0x17/0x8b
  [<c095bf22>] acpi_boot_table_init+0x2e/0xc9
  [<c095593f>] setup_arch+0x7bb/0xa09
  [<c0433376>] ? cpu_cgroup_create+0x8/0x49
  [<c09515df>] start_kernel+0x6d/0x2e6
  [<c0951081>] i386_start_kernel+0x70/0x77
early_ioremap(7f6e7e40, 00000024) [0] => Pid: 0, comm: swapper Not tainted 
2.6.30.9-90.fc11.i686.PAE #1
Call Trace:
  [<c0738645>] ? printk+0x14/0x17
  [<c0965e07>] __early_ioremap+0x60/0x19b
  [<c0965f68>] early_ioremap+0x12/0x14
  [<c095c686>] __acpi_map_table+0x18/0x1a
  [<c072a2a6>] acpi_os_map_memory+0x21/0x23
  [<c05c804b>] acpi_tb_install_table+0x47/0x126
  [<c0976869>] acpi_tb_parse_root_table+0x24e/0x2a6
  [<c072a283>] ? acpi_os_unmap_memory+0x1d/0x1f
  [<c0976613>] acpi_initialize_tables+0x79/0x81
  [<c0974f94>] acpi_table_init+0x17/0x8b
  [<c095bf22>] acpi_boot_table_init+0x2e/0xc9
  [<c095593f>] setup_arch+0x7bb/0xa09
  [<c0433376>] ? cpu_cgroup_create+0x8/0x49
  [<c09515df>] start_kernel+0x6d/0x2e6
  [<c0951081>] i386_start_kernel+0x70/0x77
00000e40 + ffb00000
ACPI: APIC 7f6e7e40 00068 (v01 IntelR AWRDACPI 42302E31 AWRD 00000000)
early_iounmap(ffb00e40, 00000024) [0]
Pid: 0, comm: swapper Not tainted 2.6.30.9-90.fc11.i686.PAE #1
Call Trace:
  [<c0738645>] ? printk+0x14/0x17
  [<c0965feb>] early_iounmap+0x81/0x123
  [<c095c66c>] __acpi_unmap_table+0x10/0x12
  [<c072a283>] acpi_os_unmap_memory+0x1d/0x1f
  [<c05c8122>] acpi_tb_install_table+0x11e/0x126
  [<c0976869>] acpi_tb_parse_root_table+0x24e/0x2a6
  [<c072a283>] ? acpi_os_unmap_memory+0x1d/0x1f
  [<c0976613>] acpi_initialize_tables+0x79/0x81
  [<c0974f94>] acpi_table_init+0x17/0x8b
  [<c095bf22>] acpi_boot_table_init+0x2e/0xc9
  [<c095593f>] setup_arch+0x7bb/0xa09
  [<c0433376>] ? cpu_cgroup_create+0x8/0x49
  [<c09515df>] start_kernel+0x6d/0x2e6
  [<c0951081>] i386_start_kernel+0x70/0x77
early_ioremap(7f6e85a0, 00000024) [0] => Pid: 0, comm: swapper Not tainted 
2.6.30.9-90.fc11.i686.PAE #1
Call Trace:
  [<c0738645>] ? printk+0x14/0x17
  [<c0965e07>] __early_ioremap+0x60/0x19b
  [<c0965f68>] early_ioremap+0x12/0x14
  [<c095c686>] __acpi_map_table+0x18/0x1a
  [<c072a2a6>] acpi_os_map_memory+0x21/0x23
  [<c05c804b>] acpi_tb_install_table+0x47/0x126
  [<c0976869>] acpi_tb_parse_root_table+0x24e/0x2a6
  [<c072a283>] ? acpi_os_unmap_memory+0x1d/0x1f
  [<c0976613>] acpi_initialize_tables+0x79/0x81
  [<c0974f94>] acpi_table_init+0x17/0x8b
  [<c095bf22>] acpi_boot_table_init+0x2e/0xc9
  [<c095593f>] setup_arch+0x7bb/0xa09
  [<c0433376>] ? cpu_cgroup_create+0x8/0x49
  [<c09515df>] start_kernel+0x6d/0x2e6
  [<c0951081>] i386_start_kernel+0x70/0x77
000005a0 + ffb00000
ACPI: SSDT 7f6e85a0 00482 (v01  PmRef    CpuPm 00003000 INTL 20041203)
early_iounmap(ffb005a0, 00000024) [0]
Pid: 0, comm: swapper Not tainted 2.6.30.9-90.fc11.i686.PAE #1
Call Trace:
  [<c0738645>] ? printk+0x14/0x17
  [<c0965feb>] early_iounmap+0x81/0x123
  [<c095c66c>] __acpi_unmap_table+0x10/0x12
  [<c072a283>] acpi_os_unmap_memory+0x1d/0x1f
  [<c05c8122>] acpi_tb_install_table+0x11e/0x126
  [<c0976869>] acpi_tb_parse_root_table+0x24e/0x2a6
  [<c072a283>] ? acpi_os_unmap_memory+0x1d/0x1f
  [<c0976613>] acpi_initialize_tables+0x79/0x81
  [<c0974f94>] acpi_table_init+0x17/0x8b
  [<c095bf22>] acpi_boot_table_init+0x2e/0xc9
  [<c095593f>] setup_arch+0x7bb/0xa09
  [<c0433376>] ? cpu_cgroup_create+0x8/0x49
  [<c09515df>] start_kernel+0x6d/0x2e6
  [<c0951081>] i386_start_kernel+0x70/0x77
early_ioremap(7f6e3100, 00000024) [0] => Pid: 0, comm: swapper Not tainted 
2.6.30.9-90.fc11.i686.PAE #1
Call Trace:
  [<c0738645>] ? printk+0x14/0x17
  [<c0965e07>] __early_ioremap+0x60/0x19b
  [<c095c66c>] ? __acpi_unmap_table+0x10/0x12
  [<c0965f68>] early_ioremap+0x12/0x14
  [<c095c686>] __acpi_map_table+0x18/0x1a
  [<c072a2a6>] acpi_os_map_memory+0x21/0x23
  [<c05c7769>] acpi_get_table_header+0x61/0x9e
  [<c09751e4>] acpi_blacklisted+0x24/0x15a
  [<c05c74de>] ? acpi_get_table_with_size+0xe/0xa6
  [<c095ba0d>] ? acpi_parse_sbf+0x0/0x26
  [<c0975052>] ? acpi_table_parse+0x4a/0x6f
  [<c0974fb9>] ? acpi_table_init+0x3c/0x8b
  [<c095bf66>] acpi_boot_table_init+0x72/0xc9
  [<c095593f>] setup_arch+0x7bb/0xa09
  [<c0433376>] ? cpu_cgroup_create+0x8/0x49
  [<c09515df>] start_kernel+0x6d/0x2e6
  [<c0951081>] i386_start_kernel+0x70/0x77
00000100 + ffb00000
early_iounmap(ffb00100, 00000024) [0]
Pid: 0, comm: swapper Not tainted 2.6.30.9-90.fc11.i686.PAE #1
Call Trace:
  [<c0738645>] ? printk+0x14/0x17
  [<c0965feb>] early_iounmap+0x81/0x123
  [<c095c66c>] __acpi_unmap_table+0x10/0x12
  [<c072a283>] acpi_os_unmap_memory+0x1d/0x1f
  [<c05c7782>] acpi_get_table_header+0x7a/0x9e
  [<c09751e4>] acpi_blacklisted+0x24/0x15a
  [<c05c74de>] ? acpi_get_table_with_size+0xe/0xa6
  [<c095bf66>] acpi_boot_table_init+0x72/0xc9
  [<c095593f>] setup_arch+0x7bb/0xa09
  [<c0433376>] ? cpu_cgroup_create+0x8/0x49
  [<c09515df>] start_kernel+0x6d/0x2e6
  [<c0951081>] i386_start_kernel+0x70/0x77
early_ioremap(7f6e3100, 00000024) [0] => Pid: 0, comm: swapper Not tainted 
2.6.30.9-90.fc11.i686.PAE #1
Call Trace:
  [<c0738645>] ? printk+0x14/0x17
  [<c0965e07>] __early_ioremap+0x60/0x19b
  [<c0965f68>] early_ioremap+0x12/0x14
  [<c095c686>] __acpi_map_table+0x18/0x1a
  [<c072a2a6>] acpi_os_map_memory+0x21/0x23
  [<c05c7769>] acpi_get_table_header+0x61/0x9e
  [<c09751e4>] acpi_blacklisted+0x24/0x15a
  [<c05c74de>] ? acpi_get_table_with_size+0xe/0xa6
  [<c095bf66>] acpi_boot_table_init+0x72/0xc9
  [<c095593f>] setup_arch+0x7bb/0xa09
  [<c0433376>] ? cpu_cgroup_create+0x8/0x49
  [<c09515df>] start_kernel+0x6d/0x2e6
  [<c0951081>] i386_start_kernel+0x70/0x77
00000100 + ffb00000
early_iounmap(ffb00100, 00000024) [0]
Pid: 0, comm: swapper Not tainted 2.6.30.9-90.fc11.i686.PAE #1
Call Trace:
  [<c0738645>] ? printk+0x14/0x17
  [<c0965feb>] early_iounmap+0x81/0x123
  [<c095c66c>] __acpi_unmap_table+0x10/0x12
  [<c072a283>] acpi_os_unmap_memory+0x1d/0x1f
  [<c05c7782>] acpi_get_table_header+0x7a/0x9e
  [<c09751e4>] acpi_blacklisted+0x24/0x15a
  [<c05c74de>] ? acpi_get_table_with_size+0xe/0xa6
  [<c095bf66>] acpi_boot_table_init+0x72/0xc9
  [<c095593f>] setup_arch+0x7bb/0xa09
  [<c0433376>] ? cpu_cgroup_create+0x8/0x49
  [<c09515df>] start_kernel+0x6d/0x2e6
  [<c0951081>] i386_start_kernel+0x70/0x77
early_ioremap(7f6e3100, 00000024) [0] => Pid: 0, comm: swapper Not tainted 
2.6.30.9-90.fc11.i686.PAE #1
Call Trace:
  [<c0738645>] ? printk+0x14/0x17
  [<c0965e07>] __early_ioremap+0x60/0x19b
  [<c0965f68>] early_ioremap+0x12/0x14
  [<c095c686>] __acpi_map_table+0x18/0x1a
  [<c072a2a6>] acpi_os_map_memory+0x21/0x23
  [<c05c7769>] acpi_get_table_header+0x61/0x9e
  [<c09751e4>] acpi_blacklisted+0x24/0x15a
  [<c05c74de>] ? acpi_get_table_with_size+0xe/0xa6
  [<c095bf66>] acpi_boot_table_init+0x72/0xc9
  [<c095593f>] setup_arch+0x7bb/0xa09
  [<c0433376>] ? cpu_cgroup_create+0x8/0x49
  [<c09515df>] start_kernel+0x6d/0x2e6
  [<c0951081>] i386_start_kernel+0x70/0x77
00000100 + ffb00000
early_iounmap(ffb00100, 00000024) [0]
Pid: 0, comm: swapper Not tainted 2.6.30.9-90.fc11.i686.PAE #1
Call Trace:
  [<c0738645>] ? printk+0x14/0x17
  [<c0965feb>] early_iounmap+0x81/0x123
  [<c095c66c>] __acpi_unmap_table+0x10/0x12
  [<c072a283>] acpi_os_unmap_memory+0x1d/0x1f
  [<c05c7782>] acpi_get_table_header+0x7a/0x9e
  [<c09751e4>] acpi_blacklisted+0x24/0x15a
  [<c05c74de>] ? acpi_get_table_with_size+0xe/0xa6
  [<c095bf66>] acpi_boot_table_init+0x72/0xc9
  [<c095593f>] setup_arch+0x7bb/0xa09
  [<c0433376>] ? cpu_cgroup_create+0x8/0x49
  [<c09515df>] start_kernel+0x6d/0x2e6
  [<c0951081>] i386_start_kernel+0x70/0x77
early_ioremap(7f6e3100, 00000024) [0] => Pid: 0, comm: swapper Not tainted 
2.6.30.9-90.fc11.i686.PAE #1
Call Trace:
  [<c0738645>] ? printk+0x14/0x17
  [<c0965e07>] __early_ioremap+0x60/0x19b
  [<c0965f68>] early_ioremap+0x12/0x14
  [<c095c686>] __acpi_map_table+0x18/0x1a
  [<c072a2a6>] acpi_os_map_memory+0x21/0x23
  [<c05c7769>] acpi_get_table_header+0x61/0x9e
  [<c09751e4>] acpi_blacklisted+0x24/0x15a
  [<c05c74de>] ? acpi_get_table_with_size+0xe/0xa6
  [<c095bf66>] acpi_boot_table_init+0x72/0xc9
  [<c095593f>] setup_arch+0x7bb/0xa09
  [<c0433376>] ? cpu_cgroup_create+0x8/0x49
  [<c09515df>] start_kernel+0x6d/0x2e6
  [<c0951081>] i386_start_kernel+0x70/0x77
00000100 + ffb00000
early_iounmap(ffb00100, 00000024) [0]
Pid: 0, comm: swapper Not tainted 2.6.30.9-90.fc11.i686.PAE #1
Call Trace:
  [<c0738645>] ? printk+0x14/0x17
  [<c0965feb>] early_iounmap+0x81/0x123
  [<c095c66c>] __acpi_unmap_table+0x10/0x12
  [<c072a283>] acpi_os_unmap_memory+0x1d/0x1f
  [<c05c7782>] acpi_get_table_header+0x7a/0x9e
  [<c09751e4>] acpi_blacklisted+0x24/0x15a
  [<c05c74de>] ? acpi_get_table_with_size+0xe/0xa6
  [<c095bf66>] acpi_boot_table_init+0x72/0xc9
  [<c095593f>] setup_arch+0x7bb/0xa09
  [<c0433376>] ? cpu_cgroup_create+0x8/0x49
  [<c09515df>] start_kernel+0x6d/0x2e6
  [<c0951081>] i386_start_kernel+0x70/0x77
ACPI: no DMI BIOS year, acpi=force is required to enable ACPI
ACPI: Disabling ACPI support
1150MB HIGHMEM available.
887MB LOWMEM available.
   mapped low ram: 0 - 377fe000
   low ram: 0 - 377fe000
   node 0 low ram: 00000000 - 377fe000
   node 0 bootmap 0000a000 - 00010f00
(9 early reservations) ==> bootmem [0000000000 - 00377fe000]
   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
   #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
   #3 [0000400000 - 0000a8d58c]    TEXT DATA BSS ==> [0000400000 - 0000a8d58c]
   #4 [000009f000 - 0000100000]    BIOS reserved ==> [000009f000 - 0000100000]
   #5 [0000a8e000 - 0000a95000]              BRK ==> [0000a8e000 - 0000a95000]
   #6 [0000007000 - 000000a000]          PGTABLE ==> [0000007000 - 000000a000]
   #7 [0000a95000 - 0000daef13]      NEW RAMDISK ==> [0000a95000 - 0000daef13]
   #8 [000000a000 - 0000011000]          BOOTMAP ==> [000000a000 - 0000011000]
found SMP MP-table at [c00f3a40] f3a40
early_ioremap(000f2294, 00001000) [0] => Pid: 0, comm: swapper Not tainted 
2.6.30.9-90.fc11.i686.PAE #1
Call Trace:
  [<c0738645>] ? printk+0x14/0x17
  [<c0965e07>] __early_ioremap+0x60/0x19b
  [<c0965f68>] early_ioremap+0x12/0x14
  [<c095e5ae>] get_mpc_size+0x13/0x45
  [<c095e695>] smp_scan_config+0xb5/0xfb
  [<c095e72d>] __find_smp_config+0x52/0x71
  [<c095e759>] find_smp_config+0xd/0xf
  [<c095595b>] setup_arch+0x7d7/0xa09
  [<c0433376>] ? cpu_cgroup_create+0x8/0x49
  [<c09515df>] start_kernel+0x6d/0x2e6
  [<c0951081>] i386_start_kernel+0x70/0x77
00000294 + ffb00000
early_iounmap(ffb00294, 00001000) [0]
Pid: 0, comm: swapper Not tainted 2.6.30.9-90.fc11.i686.PAE #1
Call Trace:
  [<c0738645>] ? printk+0x14/0x17
  [<c0965feb>] early_iounmap+0x81/0x123
  [<c095e5bc>] get_mpc_size+0x21/0x45
  [<c095e695>] smp_scan_config+0xb5/0xfb
  [<c095e72d>] __find_smp_config+0x52/0x71
  [<c095e759>] find_smp_config+0xd/0xf
  [<c095595b>] setup_arch+0x7d7/0xa09
  [<c0433376>] ? cpu_cgroup_create+0x8/0x49
  [<c09515df>] start_kernel+0x6d/0x2e6
  [<c0951081>] i386_start_kernel+0x70/0x77
Zone PFN ranges:
   DMA      0x00000000 -> 0x00001000
   Normal   0x00001000 -> 0x000377fe
   HighMem  0x000377fe -> 0x0007f690
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
     0: 0x00000000 -> 0x0000009f
     0: 0x00000100 -> 0x0007f690
On node 0 totalpages: 521775
free_area_init_node: node 0, pgdat c09073a0, node_mem_map c1000000
   DMA zone: 32 pages used for memmap
   DMA zone: 0 pages reserved
   DMA zone: 3967 pages, LIFO batch:0
   Normal zone: 1744 pages used for memmap
   Normal zone: 221486 pages, LIFO batch:31
   HighMem zone: 2302 pages used for memmap
   HighMem zone: 292244 pages, LIFO batch:31
Using APIC driver default
Intel MultiProcessor Specification v1.4
     Virtual Wire compatibility mode.
early_ioremap(000f2294, 00001000) [0] => Pid: 0, comm: swapper Not tainted 
2.6.30.9-90.fc11.i686.PAE #1
Call Trace:
  [<c0738645>] ? printk+0x14/0x17
  [<c0965e07>] __early_ioremap+0x60/0x19b
  [<c0965f68>] early_ioremap+0x12/0x14
  [<c095e5ae>] get_mpc_size+0x13/0x45
  [<c095ed88>] __get_smp_config+0x26b/0x471
  [<c096b730>] ? free_area_init_nodes+0x2d1/0x2da
  [<c06a8974>] ? read_pci_config_16+0xe/0x7f
  [<c06a8974>] ? read_pci_config_16+0xe/0x7f
  [<c0697d7e>] ? dmi_matches+0xb/0x6b
  [<c0697e20>] ? dmi_check_system+0x17/0x3f
  [<c095ef98>] get_smp_config+0xa/0xc
  [<c0955b09>] setup_arch+0x985/0xa09
  [<c0433376>] ? cpu_cgroup_create+0x8/0x49
  [<c09515df>] start_kernel+0x6d/0x2e6
  [<c0951081>] i386_start_kernel+0x70/0x77
00000294 + ffb00000
early_iounmap(ffb00294, 00001000) [0]
Pid: 0, comm: swapper Not tainted 2.6.30.9-90.fc11.i686.PAE #1
Call Trace:
  [<c0738645>] ? printk+0x14/0x17
  [<c0965feb>] early_iounmap+0x81/0x123
  [<c095e5bc>] get_mpc_size+0x21/0x45
  [<c095ed88>] __get_smp_config+0x26b/0x471
  [<c096b730>] ? free_area_init_nodes+0x2d1/0x2da
  [<c06a8974>] ? read_pci_config_16+0xe/0x7f
  [<c06a8974>] ? read_pci_config_16+0xe/0x7f
  [<c0697d7e>] ? dmi_matches+0xb/0x6b
  [<c0697e20>] ? dmi_check_system+0x17/0x3f
  [<c095ef98>] get_smp_config+0xa/0xc
  [<c0955b09>] setup_arch+0x985/0xa09
  [<c0433376>] ? cpu_cgroup_create+0x8/0x49
  [<c09515df>] start_kernel+0x6d/0x2e6
  [<c0951081>] i386_start_kernel+0x70/0x77
early_ioremap(000f2294, 00000180) [0] => Pid: 0, comm: swapper Not tainted 
2.6.30.9-90.fc11.i686.PAE #1
Call Trace:
  [<c0738645>] ? printk+0x14/0x17
  [<c0965e07>] __early_ioremap+0x60/0x19b
  [<c0965f68>] early_ioremap+0x12/0x14
  [<c095ed9e>] __get_smp_config+0x281/0x471
  [<c096b730>] ? free_area_init_nodes+0x2d1/0x2da
  [<c06a8974>] ? read_pci_config_16+0xe/0x7f
  [<c06a8974>] ? read_pci_config_16+0xe/0x7f
  [<c0697d7e>] ? dmi_matches+0xb/0x6b
  [<c0697e20>] ? dmi_check_system+0x17/0x3f
  [<c095ef98>] get_smp_config+0xa/0xc
  [<c0955b09>] setup_arch+0x985/0xa09
  [<c0433376>] ? cpu_cgroup_create+0x8/0x49
  [<c09515df>] start_kernel+0x6d/0x2e6
  [<c0951081>] i386_start_kernel+0x70/0x77
00000294 + ffb00000
MPTABLE: OEM ID: OEM00000
MPTABLE: Product ID: PROD00000000
MPTABLE: APIC at: 0xFEE00000
Processor #0 (Bootup-CPU)
I/O APIC #2 Version 17 at 0xFEC00000.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
early_iounmap(ffb00294, 00000180) [0]
Pid: 0, comm: swapper Not tainted 2.6.30.9-90.fc11.i686.PAE #1
Call Trace:
  [<c0738645>] ? printk+0x14/0x17
  [<c0965feb>] early_iounmap+0x81/0x123
  [<c095ef21>] __get_smp_config+0x404/0x471
  [<c096b730>] ? free_area_init_nodes+0x2d1/0x2da
  [<c06a8974>] ? read_pci_config_16+0xe/0x7f
  [<c06a8974>] ? read_pci_config_16+0xe/0x7f
  [<c095ef98>] get_smp_config+0xa/0xc
  [<c0955b09>] setup_arch+0x985/0xa09
  [<c0433376>] ? cpu_cgroup_create+0x8/0x49
  [<c09515df>] start_kernel+0x6d/0x2e6
  [<c0951081>] i386_start_kernel+0x70/0x77
Processors: 1
SMP: Allowing 1 CPUs, 0 hotplug CPUs
nr_irqs_gsi: 24
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
Allocating PCI resources starting at 80000000 (gap: 7f700000:60900000)
NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:1 nr_node_ids:1
PERCPU: Embedded 12 pages at c1ffa000, static data 27932 bytes
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 517697
Kernel command line: ro root=/dev/vg_fwa61041/lv_root early_ioremap_debug 
earlyprintk=vga
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
NR_IRQS:1280
PID hash table entries: 4096 (order: 12, 16384 bytes)
Fast TSC calibration using PIT
Detected 1595.953 MHz processor.
Console: colour VGA+ 80x25
console handover: boot [earlyvga0] -> real [tty0]
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
allocated 10437440 bytes of page_cgroup
please try cgroup_disable=memory option if you don't want
Initializing HighMem for node 0 (000377fe:0007f690)
Memory: 2048820k/2087488k available (3320k kernel code, 37416k reserved, 2082k 
data, 412k init, 1178184k highmem)
virtual kernel memory layout:
     fixmap  : 0xffc55000 - 0xfffff000   (3752 kB)
     pkmap   : 0xff800000 - 0xffa00000   (2048 kB)
     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
       .init : 0xc0951000 - 0xc09b8000   ( 412 kB)
       .data : 0xc073e194 - 0xc0946bd8   (2082 kB)
       .text : 0xc0400000 - 0xc073e194   (3320 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
Calibrating delay loop (skipped), value calculated using timer frequency.. 
3191.90 BogoMIPS (lpj=1595953)
Security Framework initialized
SELinux:  Initializing.
SELinux:  Starting in permissive mode
Mount-cache hash table entries: 512
Initializing cgroup subsys ns
Initializing cgroup subsys cpuacct
Initializing cgroup subsys memory
Initializing cgroup subsys devices
Initializing cgroup subsys freezer
Initializing cgroup subsys net_cls
CPU: L1 I cache: 32K, L1 D cache: 24K
CPU: L2 cache: 512K
CPU: Unsupported number of siblings 2<6>Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
using mwait in idle threads.
Checking 'hlt' instruction... OK.
SMP alternatives: switching to UP code
Freeing SMP alternatives: 24k freed
ftrace: converting mcount calls to 0f 1f 44 00 00
ftrace: allocating 18958 entries in 38 pages
Failed to register trace ftrace module notifier
ExtINT not setup in hardware but reported by MP table
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=0 pin2=0
CPU0: Intel(R) Atom(TM) CPU N270   @ 1.60GHz stepping 02
Brought up 1 CPUs
Total of 1 processors activated (3191.90 BogoMIPS).
sizeof(vma)=88 bytes
sizeof(page)=32 bytes
sizeof(inode)=348 bytes
sizeof(dentry)=132 bytes
sizeof(ext3inode)=504 bytes
sizeof(buffer_head)=56 bytes
sizeof(skbuff)=180 bytes
sizeof(task_struct)=3220 bytes
CPU0 attaching NULL sched-domain.
net_namespace: 1096 bytes
Booting paravirtualized kernel on bare hardware
regulator: core version 0.5
Time:  0:38:51  Date: 11/07/09
NET: Registered protocol family 16
early_ioremap(7f6e7f00, 0000003c) [0] => Pid: 1, comm: swapper Not tainted 
2.6.30.9-90.fc11.i686.PAE #1
Call Trace:
  [<c0738645>] ? printk+0x14/0x17
  [<c0965e07>] __early_ioremap+0x60/0x19b
  [<c0570784>] ? idr_get_empty_slot+0x13c/0x1e7
  [<c0965f68>] early_ioremap+0x12/0x14
  [<c095c686>] __acpi_map_table+0x18/0x1a
  [<c072a2a6>] acpi_os_map_memory+0x21/0x23
  [<c05c7d69>] acpi_tb_verify_table+0x25/0x4e
  [<c05c7528>] acpi_get_table_with_size+0x58/0xa6
  [<c095c688>] ? acpi_parse_mcfg+0x0/0xfa
  [<c0975052>] acpi_table_parse+0x4a/0x6f
  [<c097e749>] __pci_mmcfg_init+0x157/0x2e3
  [<c097de7b>] ? pci_arch_init+0x0/0x5c
  [<c097e8ee>] pci_mmcfg_early_init+0xd/0xf
  [<c097de94>] pci_arch_init+0x19/0x5c
  [<c040305b>] do_one_initcall+0x51/0x13f
  [<c095135d>] kernel_init+0x176/0x1c7
  [<c09511e7>] ? kernel_init+0x0/0x1c7
  [<c0408f17>] kernel_thread_helper+0x7/0x10
00000f00 + ffb00000
early_iounmap(ffb00f00, 0000003c) [0]
Pid: 1, comm: swapper Not tainted 2.6.30.9-90.fc11.i686.PAE #1
Call Trace:
  [<c0738645>] ? printk+0x14/0x17
  [<c0965feb>] early_iounmap+0x81/0x123
  [<c095c688>] ? acpi_parse_mcfg+0x0/0xfa
  [<c095c66c>] __acpi_unmap_table+0x10/0x12
  [<c0975693>] early_acpi_os_unmap_memory+0x11/0x13
  [<c097506e>] acpi_table_parse+0x66/0x6f
  [<c097e749>] __pci_mmcfg_init+0x157/0x2e3
  [<c097de7b>] ? pci_arch_init+0x0/0x5c
  [<c097e8ee>] pci_mmcfg_early_init+0xd/0xf
  [<c097de94>] pci_arch_init+0x19/0x5c
  [<c040305b>] do_one_initcall+0x51/0x13f
  [<c095135d>] kernel_init+0x176/0x1c7
  [<c09511e7>] ? kernel_init+0x0/0x1c7
  [<c0408f17>] kernel_thread_helper+0x7/0x10
PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
PCI: MCFG area at e0000000 reserved in E820
PCI: Using MMCONFIG for extended config space
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: Interpreter disabled.
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Probing PCI hardware
PCI: Probing PCI hardware (bus 00)
pci 0000:00:02.0: reg 10 32bit mmio: [0xfdf00000-0xfdf7ffff]
pci 0000:00:02.0: reg 14 io port: [0xff00-0xff07]
pci 0000:00:02.0: reg 18 32bit mmio: [0xd0000000-0xdfffffff]
pci 0000:00:02.0: reg 1c 32bit mmio: [0xfdf80000-0xfdfbffff]
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.1: PME# disabled
pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.2: PME# disabled
pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.3: PME# disabled
pci 0000:00:1d.0: reg 20 io port: [0xfe00-0xfe1f]
pci 0000:00:1d.1: reg 20 io port: [0xfd00-0xfd1f]
pci 0000:00:1d.2: reg 20 io port: [0xfc00-0xfc1f]
pci 0000:00:1d.3: reg 20 io port: [0xfb00-0xfb1f]
pci 0000:00:1d.7: reg 10 32bit mmio: [0xfdfff000-0xfdfff3ff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
pci 0000:00:1f.0: Force enabled HPET at 0xfed00000
pci 0000:00:1f.0: quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: region 0480-04bf claimed by ICH6 GPIO
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0800 (mask 003f)
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 0280 (mask 003f)
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 4700 (mask 000b)
pci 0000:00:1f.2: reg 10 io port: [0x00-0x07]
pci 0000:00:1f.2: reg 14 io port: [0x00-0x03]
pci 0000:00:1f.2: reg 18 io port: [0x00-0x07]
pci 0000:00:1f.2: reg 1c io port: [0x00-0x03]
pci 0000:00:1f.2: reg 20 io port: [0xfa00-0xfa0f]
pci 0000:00:1f.2: reg 24 32bit mmio: [0xfdffe000-0xfdffe3ff]
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.2: PME# disabled
pci 0000:00:1f.3: reg 20 io port: [0x500-0x51f]
pci 0000:01:00.0: reg 10 io port: [0xbe00-0xbeff]
pci 0000:01:00.0: reg 18 64bit mmio: [0xfd8ff000-0xfd8fffff]
pci 0000:01:00.0: reg 20 64bit mmio: [0xfd5f0000-0xfd5fffff]
pci 0000:01:00.0: reg 30 32bit mmio: [0x000000-0x01ffff]
pci 0000:01:00.0: supports D1 D2
pci 0000:01:00.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:01:00.0: PME# disabled
pci 0000:00:1c.0: bridge io port: [0xb000-0xbfff]
pci 0000:00:1c.0: bridge 32bit mmio: [0xfd800000-0xfd8fffff]
pci 0000:00:1c.0: bridge 64bit mmio pref: [0xfd500000-0xfd5fffff]
pci 0000:02:00.0: reg 10 io port: [0xae00-0xaeff]
pci 0000:02:00.0: reg 18 64bit mmio: [0xfdeff000-0xfdefffff]
pci 0000:02:00.0: reg 20 64bit mmio: [0xfddf0000-0xfddfffff]
pci 0000:02:00.0: reg 30 32bit mmio: [0x000000-0x01ffff]
pci 0000:02:00.0: supports D1 D2
pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:02:00.0: PME# disabled
pci 0000:00:1c.1: bridge io port: [0xa000-0xafff]
pci 0000:00:1c.1: bridge 32bit mmio: [0xfde00000-0xfdefffff]
pci 0000:00:1c.1: bridge 64bit mmio pref: [0xfdd00000-0xfddfffff]
pci 0000:03:00.0: reg 10 io port: [0xee00-0xeeff]
pci 0000:03:00.0: reg 18 64bit mmio: [0xfdcff000-0xfdcfffff]
pci 0000:03:00.0: reg 20 64bit mmio: [0xfdbf0000-0xfdbfffff]
pci 0000:03:00.0: reg 30 32bit mmio: [0x000000-0x01ffff]
pci 0000:03:00.0: supports D1 D2
pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:03:00.0: PME# disabled
pci 0000:00:1c.2: bridge io port: [0xe000-0xefff]
pci 0000:00:1c.2: bridge 32bit mmio: [0xfdc00000-0xfdcfffff]
pci 0000:00:1c.2: bridge 64bit mmio pref: [0xfdb00000-0xfdbfffff]
pci 0000:04:00.0: reg 10 io port: [0xde00-0xdeff]
pci 0000:04:00.0: reg 18 64bit mmio: [0xfdaff000-0xfdafffff]
pci 0000:04:00.0: reg 20 64bit mmio: [0xfd9f0000-0xfd9fffff]
pci 0000:04:00.0: reg 30 32bit mmio: [0x000000-0x01ffff]
pci 0000:04:00.0: supports D1 D2
pci 0000:04:00.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:04:00.0: PME# disabled
pci 0000:00:1c.3: bridge io port: [0xd000-0xdfff]
pci 0000:00:1c.3: bridge 32bit mmio: [0xfda00000-0xfdafffff]
pci 0000:00:1c.3: bridge 64bit mmio pref: [0xfd900000-0xfd9fffff]
pci 0000:05:07.0: reg 10 32bit mmio: [0xfd7f0000-0xfd7fffff]
pci 0000:00:1e.0: transparent bridge
pci 0000:00:1e.0: bridge io port: [0xc000-0xcfff]
pci 0000:00:1e.0: bridge 32bit mmio: [0xfd700000-0xfd7fffff]
pci 0000:00:1e.0: bridge 64bit mmio pref: [0xfd600000-0xfd6fffff]
pci 0000:00:1f.0: PIIX/ICH IRQ router [8086:27b9]
pci 0000:00:02.0: PCI->APIC IRQ transform: INT A -> IRQ 16
pci 0000:00:1c.0: PCI->APIC IRQ transform: INT A -> IRQ 16
pci 0000:00:1c.1: PCI->APIC IRQ transform: INT B -> IRQ 17
pci 0000:00:1c.2: PCI->APIC IRQ transform: INT C -> IRQ 18
pci 0000:00:1c.3: PCI->APIC IRQ transform: INT D -> IRQ 19
pci 0000:00:1d.0: PCI->APIC IRQ transform: INT A -> IRQ 23
pci 0000:00:1d.1: PCI->APIC IRQ transform: INT B -> IRQ 19
pci 0000:00:1d.2: PCI->APIC IRQ transform: INT C -> IRQ 18
pci 0000:00:1d.3: PCI->APIC IRQ transform: INT D -> IRQ 16
pci 0000:00:1d.7: PCI->APIC IRQ transform: INT A -> IRQ 23
pci 0000:00:1f.2: PCI->APIC IRQ transform: INT B -> IRQ 19
pci 0000:00:1f.3: PCI->APIC IRQ transform: INT B -> IRQ 19
pci 0000:01:00.0: PCI->APIC IRQ transform: INT A -> IRQ 16
pci 0000:02:00.0: PCI->APIC IRQ transform: INT A -> IRQ 17
pci 0000:03:00.0: PCI->APIC IRQ transform: INT A -> IRQ 18
pci 0000:04:00.0: PCI->APIC IRQ transform: INT A -> IRQ 19
pci 0000:05:07.0: PCI->APIC IRQ transform: INT A -> IRQ 16
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
hpet clockevent registered
HPET: 3 timers in total, 0 timers will be used for per-cpu timer
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 comparators, 64-bit 14.318180 MHz counter
pnp: PnP ACPI: disabled
pci 0000:00:1c.0: PCI bridge, secondary bus 0000:01
pci 0000:00:1c.0:   IO window: 0xb000-0xbfff
pci 0000:00:1c.0:   MEM window: 0xfd800000-0xfd8fffff
pci 0000:00:1c.0:   PREFETCH window: 0x000000fd500000-0x000000fd5fffff
pci 0000:00:1c.1: PCI bridge, secondary bus 0000:02
pci 0000:00:1c.1:   IO window: 0xa000-0xafff
pci 0000:00:1c.1:   MEM window: 0xfde00000-0xfdefffff
pci 0000:00:1c.1:   PREFETCH window: 0x000000fdd00000-0x000000fddfffff
pci 0000:00:1c.2: PCI bridge, secondary bus 0000:03
pci 0000:00:1c.2:   IO window: 0xe000-0xefff
pci 0000:00:1c.2:   MEM window: 0xfdc00000-0xfdcfffff
pci 0000:00:1c.2:   PREFETCH window: 0x000000fdb00000-0x000000fdbfffff
pci 0000:00:1c.3: PCI bridge, secondary bus 0000:04
pci 0000:00:1c.3:   IO window: 0xd000-0xdfff
pci 0000:00:1c.3:   MEM window: 0xfda00000-0xfdafffff
pci 0000:00:1c.3:   PREFETCH window: 0x000000fd900000-0x000000fd9fffff
pci 0000:00:1e.0: PCI bridge, secondary bus 0000:05
pci 0000:00:1e.0:   IO window: 0xc000-0xcfff
pci 0000:00:1e.0:   MEM window: 0xfd700000-0xfd7fffff
pci 0000:00:1e.0:   PREFETCH window: 0x000000fd600000-0x000000fd6fffff
pci 0000:00:1c.0: setting latency timer to 64
pci 0000:00:1c.1: setting latency timer to 64
pci 0000:00:1c.2: setting latency timer to 64
pci 0000:00:1c.3: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
pci_bus 0000:01: resource 0 io:  [0xb000-0xbfff]
pci_bus 0000:01: resource 1 mem: [0xfd800000-0xfd8fffff]
pci_bus 0000:01: resource 2 pref mem [0xfd500000-0xfd5fffff]
pci_bus 0000:02: resource 0 io:  [0xa000-0xafff]
pci_bus 0000:02: resource 1 mem: [0xfde00000-0xfdefffff]
pci_bus 0000:02: resource 2 pref mem [0xfdd00000-0xfddfffff]
pci_bus 0000:03: resource 0 io:  [0xe000-0xefff]
pci_bus 0000:03: resource 1 mem: [0xfdc00000-0xfdcfffff]
pci_bus 0000:03: resource 2 pref mem [0xfdb00000-0xfdbfffff]
pci_bus 0000:04: resource 0 io:  [0xd000-0xdfff]
pci_bus 0000:04: resource 1 mem: [0xfda00000-0xfdafffff]
pci_bus 0000:04: resource 2 pref mem [0xfd900000-0xfd9fffff]
pci_bus 0000:05: resource 0 io:  [0xc000-0xcfff]
pci_bus 0000:05: resource 1 mem: [0xfd700000-0xfd7fffff]
pci_bus 0000:05: resource 2 pref mem [0xfd600000-0xfd6fffff]
pci_bus 0000:05: resource 3 io:  [0x00-0xffff]
pci_bus 0000:05: resource 4 mem: [0x000000-0xffffffffffffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
NET: Registered protocol family 1
Trying to unpack rootfs image as initramfs...
Freeing initrd memory: 3175k freed
platform rtc_cmos: registered platform RTC device (no PNP device found)
apm: BIOS version 1.2 Flags 0x07 (Driver version 1.16ac)
audit: initializing netlink socket (disabled)
type=2000 audit(1257554330.502:1): initialized
highmem bounce pool size: 64 pages
HugeTLB registered 2 MB page size, pre-allocated 0 pages
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
msgmni has been set to 1708
SELinux:  Registering netfilter hooks
alg: No test for stdrng (krng)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:00:02.0: Boot video device
pcieport-driver 0000:00:1c.0: irq 24 for MSI/MSI-X
pcieport-driver 0000:00:1c.0: setting latency timer to 64
pcieport-driver 0000:00:1c.1: irq 25 for MSI/MSI-X
pcieport-driver 0000:00:1c.1: setting latency timer to 64
pcieport-driver 0000:00:1c.2: irq 26 for MSI/MSI-X
pcieport-driver 0000:00:1c.2: setting latency timer to 64
pcieport-driver 0000:00:1c.3: irq 27 for MSI/MSI-X
pcieport-driver 0000:00:1c.3: setting latency timer to 64
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
pciehp: PCI Express Hot Plug Controller Driver version: 0.4
acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
early_ioremap(7f6e7e40, 00000068) [0] => Pid: 1, comm: swapper Not tainted 
2.6.30.9-90.fc11.i686.PAE #1
Call Trace:
  [<c0738645>] ? printk+0x14/0x17
  [<c0965e07>] __early_ioremap+0x60/0x19b
  [<c057097b>] ? ida_get_new_above+0x14c/0x166
  [<c0965f68>] early_ioremap+0x12/0x14
  [<c095c686>] __acpi_map_table+0x18/0x1a
  [<c072a2a6>] acpi_os_map_memory+0x21/0x23
  [<c05c7d69>] acpi_tb_verify_table+0x25/0x4e
  [<c05c7528>] acpi_get_table_with_size+0x58/0xa6
  [<c05c758b>] acpi_get_table+0x15/0x1a
  [<c0976a47>] acpi_processor_init+0x26/0xe3
  [<c0976a21>] ? acpi_processor_init+0x0/0xe3
  [<c040305b>] do_one_initcall+0x51/0x13f
  [<c095135d>] kernel_init+0x176/0x1c7
  [<c09511e7>] ? kernel_init+0x0/0x1c7
  [<c0408f17>] kernel_thread_helper+0x7/0x10
00000e40 + ffb00000
isapnp: Scanning for PnP cards...
Switched to high resolution mode on CPU 0
isapnp: No Plug & Play device found
Non-volatile memory driver v1.3
Linux agpgart interface v0.103
agpgart-intel 0000:00:00.0: Intel 945GME Chipset
agpgart-intel 0000:00:00.0: detected 7932K stolen memory
agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
brd: module loaded
loop: module loaded
input: Macintosh mouse button emulation as /devices/virtual/input/input0
Driver 'sd' needs updating - please use bus_type methods
Driver 'sr' needs updating - please use bus_type methods
ata_piix 0000:00:1f.2: version 2.13
ata_piix 0000:00:1f.2: MAP [ P0 P2 -- -- ]
ata_piix 0000:00:1f.2: setting latency timer to 64
scsi0 : ata_piix
scsi1 : ata_piix
ata1: SATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xfa00 irq 14
ata2: SATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xfa08 irq 15
Fixed MDIO Bus: probed
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfdfff000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.30.9-90.fc11.i686.PAE ehci_hcd
usb usb1: SerialNumber: 0000:00:1d.7
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000fe00
usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: UHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.30.9-90.fc11.i686.PAE uhci_hcd
usb usb2: SerialNumber: 0000:00:1d.0
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000fd00
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.30.9-90.fc11.i686.PAE uhci_hcd
usb usb3: SerialNumber: 0000:00:1d.1
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000fc00
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.30.9-90.fc11.i686.PAE uhci_hcd
usb usb4: SerialNumber: 0000:00:1d.2
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.3: setting latency timer to 64
uhci_hcd 0000:00:1d.3: UHCI Host Controller
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.3: irq 16, io base 0x0000fb00
usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: UHCI Host Controller
usb usb5: Manufacturer: Linux 2.6.30.9-90.fc11.i686.PAE uhci_hcd
usb usb5: SerialNumber: 0000:00:1d.3
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
PNP: No PS/2 controller found. Probing ports directly.
ata1.00: ATA-8: STT_FTM16GL25H, 080826, max UDMA/100
ata1.00: 31277056 sectors, multi 0: LBA
ata1.00: configured for UDMA/100
scsi 0:0:0:0: Direct-Access     ATA      STT_FTM16GL25H   0808 PQ: 0 ANSI: 5
sd 0:0:0:0: Attached scsi generic sg0 type 0
sd 0:0:0:0: [sda] 31277056 512-byte hardware sectors: (16.0 GB/14.9 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support 
DPO or FUA
  sda: sda1 sda2
sd 0:0:0:0: [sda] Attached SCSI disk
serio: i8042 KBD port at 0x60,0x64 irq 1
mice: PS/2 mouse device common for all mice
rtc_cmos rtc_cmos: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one day, 114 bytes nvram, hpet irqs
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
cpuidle: using governor ladder
cpuidle: using governor menu
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
nf_conntrack.acct=1 kernel paramater, acct=1 nf_conntrack module option or
sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
ip_tables: (C) 2000-2006 Netfilter Core Team
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 17
Using IPI No-Shortcut mode
------------[ cut here ]------------
WARNING: at arch/x86/mm/ioremap.c:604 check_early_ioremap_leak+0x48/0x5c() (Not 
tainted)
Debug warning: early ioremap leak of 1 areas detected.
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.30.9-90.fc11.i686.PAE #1
Call Trace:
  [<c043564e>] warn_slowpath_common+0x70/0x87
  [<c0965bcd>] ? check_early_ioremap_leak+0x48/0x5c
  [<c0965b85>] ? check_early_ioremap_leak+0x0/0x5c
  [<c04356a3>] warn_slowpath_fmt+0x29/0x38
  [<c0965bcd>] check_early_ioremap_leak+0x48/0x5c
  [<c040305b>] do_one_initcall+0x51/0x13f
  [<c095135d>] kernel_init+0x176/0x1c7
  [<c09511e7>] ? kernel_init+0x0/0x1c7
  [<c0408f17>] kernel_thread_helper+0x7/0x10
---[ end trace cd15a500b2962804 ]---
please boot with early_ioremap_debug and report the dmesg.
PM: Resume from disk failed.
registered taskstats version 1
   Magic number: 1:134:607
Initalizing network drop monitor service
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
Freeing unused kernel memory: 412k freed
Write protecting the kernel text: 3324k
Write protecting the kernel read-only data: 1612k
EXT4-fs: barriers enabled
kjournald2 starting: pid 54, dev dm-0:8, commit interval 5 seconds
EXT4-fs: delayed allocation enabled
EXT4-fs: file extents enabled
EXT4-fs: mballoc enabled
EXT4-fs: mounted filesystem dm-0 with ordered data mode
SELinux:  Disabled at runtime.
SELinux:  Unregistering netfilter hooks
type=1404 audit(1257554332.267:2): selinux=0 auid=4294967295 ses=4294967295
udev: starting version 141
r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
r8169 0000:01:00.0: setting latency timer to 64
r8169 0000:01:00.0: irq 28 for MSI/MSI-X
eth0: RTL8168c/8111c at 0xf8264000, 00:03:2d:12:16:0a, XID 3c4000c0 IRQ 28
r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
r8169 0000:02:00.0: setting latency timer to 64
r8169 0000:02:00.0: irq 29 for MSI/MSI-X
eth1: RTL8168c/8111c at 0xf827c000, 00:03:2d:12:16:0b, XID 3c4000c0 IRQ 29
r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
r8169 0000:03:00.0: setting latency timer to 64
r8169 0000:03:00.0: irq 30 for MSI/MSI-X
eth2: RTL8168c/8111c at 0xf8292000, 00:03:2d:12:16:0c, XID 3c4000c0 IRQ 30
r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
r8169 0000:04:00.0: setting latency timer to 64
r8169 0000:04:00.0: irq 31 for MSI/MSI-X
eth3: RTL8168c/8111c at 0xf8296000, 00:03:2d:12:16:0d, XID 3c4000c0 IRQ 31
intel_rng: FWH not detected
iTCO_vendor_support: vendor-support=0
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.05
iTCO_wdt: Found a ICH7-M or ICH7-U TCO device (Version=2, TCOBASE=0x0460)
iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
input: PC Speaker as /devices/platform/pcspkr/input/input2
cfg80211: Calling CRDA to update world regulatory domain
ath5k 0000:05:07.0: registered as 'phy0'
cfg80211: World regulatory domain updated:
         (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
         (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
         (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
         (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
         (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
         (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
phy0: Selected rate control algorithm 'minstrel'
ath5k phy0: Atheros AR5213A chip found (MAC: 0x59, PHY: 0x43)
ath5k phy0: RF5112B multiband radio found (0x36)
cfg80211: Calling CRDA for country: US
cfg80211: Regulatory domain changed to country: US
         (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
         (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
         (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
         (5250000 KHz - 5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
         (5490000 KHz - 5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
         (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
device-mapper: multipath: version 1.0.5 loaded
EXT4 FS on dm-0, internal journal on dm-0:8
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
r8169: eth3: link up
r8169: eth3: link up
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
w83627ehf: Found W83627EHG chip at 0x290
eth3: no IPv6 routers present
pktgen v2.70: Packet Generator for packet performance testing.
r8169: eth0: link down
ADDRCONF(NETDEV_UP): eth0: link is not ready
r8169: eth1: link down
ADDRCONF(NETDEV_UP): eth1: link is not ready
r8169: eth2: link down
ADDRCONF(NETDEV_UP): eth2: link is not ready
802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
All bugs added by David S. Miller <davem@redhat.com>
ADDRCONF(NETDEV_UP): wlan0: link is not ready
fuse init (API version 7.11)
r8169: eth2: link down
ADDRCONF(NETDEV_UP): eth2: link is not ready
device wmaster0 entered promiscuous mode
r8169: eth2: link down
ADDRCONF(NETDEV_UP): eth2: link is not ready

-- 
Hun-Kyi Wynn | hkwynn@candelatech.com
Candela Technologies Inc. | www.candelatech.com
Office: +1 360 380 1618
Mobile: +1 360 305 6822
Fax   : +1 360 380 1431
Timezone: PST, GMT -8
