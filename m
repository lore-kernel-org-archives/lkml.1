Return-Path: <linux-kernel-owner+w=401wt.eu-S1756832AbXFBEvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756832AbXFBEvR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 00:51:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753376AbXFBEvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 00:51:09 -0400
Received: from an-out-0708.google.com ([209.85.132.241]:20160 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153AbXFBEvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 00:51:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=f1FyymOb5/EIqfkXSXhukxtr9iwc2RsnHXwPmP9sYjtqMhNYYXbCMez5rqhBejVmr1rOjGrtCfUdD4u+VHJ2ENS4kuEccy7RpeICyh5WtdbdmI72+g9b6I2I8Cnnuog7oScRZAp4aG2R/ryXHSMTLz9kgi7TzkRTvyyowK2yRN0=
Message-ID: <516d7fa80706012151m32facb87nafb68811c784fa54@mail.gmail.com>
Date: Sat, 2 Jun 2007 00:51:07 -0400
From: "Mike Richards" <mrmikerich@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Missing RAM on x86_64
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, I appear to be missing quite a bit of RAM on an x86_64 system. I
have 1GB installed, but 'free' only shows 878MB:

pokey$ free -m
             total       used       free     shared    buffers     cached
Mem:           878        571        306          0         52        332
-/+ buffers/cache:        186        691
Swap:         1023          0       1023

I'm used to seeing a little bit of RAM missing with 32bit systems, but
146MB seems a bit much. The part of dmesg that concerns the RAM is
shown below. Anyone know what's up here? Is this normal for an x86_64
system?

Linux version 2.6.20.11 (root@pokey) (gcc version 4.1.2) #1 SMP Thu
May 24 18:29:52 GMT 2007
Command line: auto BOOT_IMAGE=2.6.20.11 rw root=801
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 0000000037fd0000 (usable)
 BIOS-e820: 0000000037fd0000 - 0000000037fde000 (ACPI data)
 BIOS-e820: 0000000037fde000 - 0000000038000000 (ACPI NVS)
 BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fef00000 (reserved)
 BIOS-e820: 00000000ff780000 - 0000000100000000 (reserved)
Entering add_active_range(0, 0, 159) 0 entries of 256 used
Entering add_active_range(0, 256, 229328) 1 entries of 256 used
end_pfn_map = 1048576
DMI 2.3 present.
Entering add_active_range(0, 0, 159) 0 entries of 256 used
Entering add_active_range(0, 256, 229328) 1 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1048576
early_node_map[2] active PFN ranges
    0:        0 ->      159
    0:      256 ->   229328
On node 0 totalpages: 229231
  DMA zone: 56 pages used for memmap
  DMA zone: 890 pages reserved
  DMA zone: 3053 pages, LIFO batch:0
  DMA32 zone: 3079 pages used for memmap
  DMA32 zone: 222153 pages, LIFO batch:31
  Normal zone: 0 pages used for memmap
Intel MultiProcessor Specification v1.4
MPTABLE: OEM ID: nVidia   MPTABLE: Product ID: MCP51G/M     MPTABLE:
APIC at: 0xFEE00000
Processor #0 (Bootup-CPU)
I/O APIC #1 at 0xFEC00000.
Setting APIC routing to flat
Processors: 1
Nosave address range: 000000000009f000 - 00000000000a0000
Nosave address range: 00000000000a0000 - 00000000000e0000
Nosave address range: 00000000000e0000 - 0000000000100000
Allocating PCI resources starting at 40000000 (gap: 38000000:c6c00000)
PERCPU: Allocating 25088 bytes of per cpu data
Built 1 zonelists.  Total pages: 225206
Kernel command line: auto BOOT_IMAGE=2.6.20.11 rw root=801
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
Console: colour VGA+ 80x25
Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
Checking aperture...
CPU 0: aperture @ 61ba000000 size 32 MB
Aperture too small (32 MB)
No AGP bridge found
Memory: 898964k/917312k available (2235k kernel code, 17744k reserved,
750k data, 200k init)
