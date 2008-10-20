Return-Path: <linux-kernel-owner+w=401wt.eu-S1752611AbYJTCCY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611AbYJTCCY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 22:02:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752005AbYJTCCQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 22:02:16 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:25415 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbYJTCCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 22:02:15 -0400
X-RZG-CLASS-ID: mo00
X-RZG-AUTH: :O2kGeEG7b/pS1E64W3aniLTNDUcEh+JwjGMyQkjVygg3aAH02IubSkmAm8qKOaN6beV63w==
Subject: 2.6.28-git catches low memory corruption
From: Martin Capitanio <c4p7n@capitanio.org>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 20 Oct 2008 04:02:06 +0200
Message-Id: <1224468126.6481.52.camel@marvin>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.0 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

and a mysterious cpu-fan/intel-xorg interaction disappears. Great.
        
Thanks,
Martin

[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007f4de000 (usable)
[    0.000000]  BIOS-e820: 000000007f4de000 - 000000007f4e9000 (reserved)
[    0.000000]  BIOS-e820: 000000007f4e9000 - 000000007f543000 (usable)
[    0.000000]  BIOS-e820: 000000007f543000 - 000000007f546000 (reserved)
[    0.000000]  BIOS-e820: 000000007f546000 - 000000007f5bb000 (usable)
[    0.000000]  BIOS-e820: 000000007f5bb000 - 000000007f5bf000 (reserved)
[    0.000000]  BIOS-e820: 000000007f5bf000 - 000000007f66b000 (usable)
[    0.000000]  BIOS-e820: 000000007f66b000 - 000000007f6bf000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007f6bf000 - 000000007f700000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007f700000 - 0000000080000000 (reserved)
[    0.000000]  BIOS-e820: 00000000f8000000 - 00000000fc000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
[    0.000000] DMI 2.4 present.
[    0.000000] last_pfn = 0x7f66b max_arch_pfn = 0x3ffffffff
[    0.000000] Scanning 2 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000001000 (usable)
[    0.000000]  modified: 0000000000001000 - 0000000000006000 (reserved)
[    0.000000]  modified: 0000000000006000 - 0000000000008000 (usable)
[    0.000000]  modified: 0000000000008000 - 0000000000010000 (reserved)
[    0.000000]  modified: 0000000000010000 - 0000000000092c00 (usable)
[    0.000000]  modified: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 000000007f4de000 (usable)
[    0.000000]  modified: 000000007f4de000 - 000000007f4e9000 (reserved)
[    0.000000]  modified: 000000007f4e9000 - 000000007f543000 (usable)
[    0.000000]  modified: 000000007f543000 - 000000007f546000 (reserved)
[    0.000000]  modified: 000000007f546000 - 000000007f5bb000 (usable)
[    0.000000]  modified: 000000007f5bb000 - 000000007f5bf000 (reserved)
[    0.000000]  modified: 000000007f5bf000 - 000000007f66b000 (usable)
[    0.000000]  modified: 000000007f66b000 - 000000007f6bf000 (ACPI NVS)
[    0.000000]  modified: 000000007f6bf000 - 000000007f700000 (ACPI data)
[    0.000000]  modified: 000000007f700000 - 0000000080000000 (reserved)
[    0.000000]  modified: 00000000f8000000 - 00000000fc000000 (reserved)
[    0.000000]  modified: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  modified: 00000000fed14000 - 00000000fed1a000 (reserved)
[    0.000000]  modified: 00000000fed1c000 - 00000000fed20000 (reserved)
[    0.000000]  modified: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  modified: 00000000fff00000 - 0000000100000000 (reserved)
[    0.000000] init_memory_mapping
[    0.000000]  0000000000 - 007f600000 page 2M
[    0.000000]  007f600000 - 007f66b000 page 4k
[    0.000000] kernel direct mapping tables up to 7f66b000 @ 10000-14000
[    0.000000] last_map_addr: 7f66b000 end: 7f66b000
[    0.000000] RAMDISK: 378e9000 - 37fefb9e
[    0.000000] ACPI: RSDP 000FE020, 0024 (r2 TOSINV)
[    0.000000] ACPI: XSDT 7F6FE120, 0064 (r1 TOSINV TOSINV00        1       1000013)
[    0.000000] ACPI: FACP 7F6FD000, 00F4 (r4 TOSINV TOSINV00        1 MSFT  1000013)
[    0.000000] ACPI: DSDT 7F6F5000, 7A3C (r1 TOSINV TOSINV00        1 MSFT  1000013)
[    0.000000] ACPI: FACS 7F675000, 0040
[    0.000000] ACPI: APIC 7F6F4000, 0068 (r2 TOSINV TOSINV00        1 MSFT  1000013)
[    0.000000] ACPI: HPET 7F6F3000, 0038 (r1 TOSINV TOSINV00        1 MSFT  1000013)
[    0.000000] ACPI: MCFG 7F6F2000, 003C (r1 TOSINV TOSINV00        1 MSFT  1000013)
[    0.000000] ACPI: ASF! 7F6F1000, 00A5 (r32 TOSINV TOSINV00        1 MSFT  1000013)
[    0.000000] ACPI: SLIC 7F6F0000, 0176 (r1 TOSINV TOSINV00        1 MSFT  1000013)
[    0.000000] ACPI: BOOT 7F6EF000, 0028 (r1 TOSINV TOSINV00        1 MSFT  1000013)
[    0.000000] ACPI: SSDT 7F6EE000, 04C4 (r1  PmRef    CpuPm     3000 INTL 20051117)
[    0.000000] ACPI: DMI detected: Toshiba
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] (6 early reservations) ==> bootmem [0000000000 - 007f66b000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
[    0.000000]   #2 [0000200000 - 00008e927c]    TEXT DATA BSS ==> [0000200000 - 00008e927c]
[    0.000000]   #3 [00378e9000 - 0037fefb9e]          RAMDISK ==> [00378e9000 - 0037fefb9e]
[    0.000000]   #4 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
[    0.000000]   #5 [0000010000 - 0000012000]          PGTABLE ==> [0000010000 - 0000012000]
[    0.000000] found SMP MP-table at [ffff8800000fe230] 000fe230
[    0.000000]  [ffffe20000000000-ffffe20001ffffff] PMD -> [ffff880001200000-ffff8800031fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00100000
 
reg00: base=0x0fffe0000 ( 4095MB), size=  128KB, count=1: write-protect
reg01: base=0x000000000 (    0MB), size= 1024MB, count=1: write-back
reg02: base=0x040000000 ( 1024MB), size= 1024MB, count=1: write-back
reg03: base=0x07f800000 ( 2040MB), size=    8MB, count=1: uncachable
reg04: base=0x07f700000 ( 2039MB), size=    1MB, count=1: uncachable
reg05: base=0x080000000 ( 2048MB), size=  256MB, count=1: write-combining

(II) intel: Driver for Intel Integrated Graphics Chipsets: i810,
        i810-dc100, i810e, i815, i830M, 845G, 852GM/855GM, 865G, 915G,
        E7221 (i915), 915GM, 945G, 945GM, 945GME, 965G, G35, 965Q, 946GZ,
        965GM, 965GME/GLE, G33, Q35, Q33,
        Mobile Intel® GM45 Express Chipset,
        Intel Integrated Graphics Device, G45/G43, Q45/Q43
(II) Primary Device is: PCI 00@00:02:0
(II) resource ranges after xf86ClaimFixedResources() call:
        [0] -1  0       0xffffffff - 0xffffffff (0x1) MX[B]
        [1] -1  0       0x000f0000 - 0x000fffff (0x10000) MX[B]
        [2] -1  0       0x000c0000 - 0x000effff (0x30000) MX[B]
        [3] -1  0       0x00000000 - 0x0009ffff (0xa0000) MX[B]
        [4] -1  0       0x0000ffff - 0x0000ffff (0x1) IX[B]
        [5] -1  0       0x00000000 - 0x00000000 (0x1) IX[B]
(II) resource ranges after probing:
        [0] -1  0       0xffffffff - 0xffffffff (0x1) MX[B]
        [1] -1  0       0x000f0000 - 0x000fffff (0x10000) MX[B]
        [2] -1  0       0x000c0000 - 0x000effff (0x30000) MX[B]
        [3] -1  0       0x00000000 - 0x0009ffff (0xa0000) MX[B]
        [4] 0   0       0x000a0000 - 0x000affff (0x10000) MS[B]
        [5] 0   0       0x000b0000 - 0x000b7fff (0x8000) MS[B]
        [6] 0   0       0x000b8000 - 0x000bffff (0x8000) MS[B]
        [7] -1  0       0x0000ffff - 0x0000ffff (0x1) IX[B]
        [8] -1  0       0x00000000 - 0x00000000 (0x1) IX[B]
        [9] 0   0       0x000003b0 - 0x000003bb (0xc) IS[B]
        [10] 0  0       0x000003c0 - 0x000003df (0x20) IS[B]


