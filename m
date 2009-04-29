Return-Path: <linux-kernel-owner+w=401wt.eu-S1757389AbZD2LMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757389AbZD2LMV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 07:12:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753197AbZD2LMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 07:12:10 -0400
Received: from sandesh.cdotd.ernet.in ([196.1.105.47]:57435 "EHLO
	sandesh.cdotd.ernet.in" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681AbZD2LMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 07:12:08 -0400
From: "Deepak Gaur" <dgaur@cdotd.ernet.in>
To: linux-kernel@vger.kernel.org
Subject: Powerpc Port linux-2.6.29 
Date: Wed, 29 Apr 2009 16:26:36 +0530
Message-Id: <20090429104826.M14209@cdotd.ernet.in>
X-Mailer: Open WebMail 2.51 20050228
X-OriginatingIP: 192.168.1.167 (dgaur)
MIME-Version: 1.0
Content-Type: text/plain;
	charset=iso-8859-1
X-imss-version: 2.054
X-imss-result: Passed
X-imss-scanInfo: M:B L:E SM:2
X-imss-tmaseResult: TT:1 TS:-15.3959 TC:1F TRN:48 TV:5.6.1016(16610.004)
X-imss-scores: Clean:100.00000 C:0 M:0 S:0 R:0
X-imss-settings: Baseline:5 C:4 M:4 S:4 R:1 (0.0000 0.0000)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all

I am trying to port linux-2.6.29 on an MPC8560ADS like Custom board. U-BOOT is properly
working on this board but when I boot Linux OS on this board I get some weired errors
as mentioned below

The uImage is kept in code flash at address 0xe0000000 . I have checked the register
settings for my Custom board and everything seems to be ok .. 
-------------------------------------------------------------------------------------
FLASH: 32.5 MB
L2:    256 KB enabled
In:    serial
Out:   serial
Err:   serial
Net:   TSEC1, TSEC2
Hit any key to stop autoboot:  0
WARNING: adjusting available memory to 30000000
## Booting kernel from Legacy Image at e0000000 ...
   Image Name:   Linux-2.6.29
   Image Type:   PowerPC Linux Kernel Image (gzip compressed)
   Data Size:    1451400 Bytes =  1.4 MB
   Load Address: 00400000
   Entry Point:  004005a8
   Verifying Checksum ... OK
   Uncompressing Kernel Image ... OK
Using MPC85xx ADS machine description
Memory CAM mapping: CAM0=256Mb, CAM1=256Mb, CAM2=256Mb residual: 256Mb
Linux version 2.6.29 (deepak@Localhost) (gcc version 3.4.3 (MontaVista
3.4.3-25.0.96.0600665 2006-05-179Found FSL PCI host bridge at 0x00000000a0008000.
Firmware bus number: 0->0
PCI host bridge /pci@a0008000 (primary) ranges:
 MEM 0x0000000080000000..0x000000009fffffff -> 0x0000000080000000
  IO 0x00000000a2000000..0x00000000a2ffffff -> 0x0000000000000000
Zone PFN ranges:
  DMA      0x00000000 -> 0x00030000
  Normal   0x00030000 -> 0x00030000
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0: 0x00000000 -> 0x00030000
MMU: Allocated 1088 bytes of context maps for 255 contexts
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 195072
Kernel command line: console=ttyCPM0,9600 root=/dev/nfs rw nfsroot=rootpath ip=dhcp
mpic: Setting up MPIC " OpenPIC  " version 1.2 at a0040000, max 1 CPUs
mpic: ISU size: 56, shift: 6, mask: 3f
mpic: Initializing for 56 sources
PID hash table entries: 4096 (order: 12, 16384 bytes)
clocksource: timebase mult[79364d9] shift[22] registered
console [ttyCPM0] enabled
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
BUG: Bad page state in process swapper  pfn:2fc69
page:c0d0ed20 flags:(null) count:0 mapcount:-524288 mapping:(null) index:0
Call Trace:
[c02dbef0] [c0007a84] show_stack+0x48/0x174 (unreliable)
[c02dbf20] [c006fa14] bad_page+0x9c/0x160
[c02dbf40] [c0071564] __free_pages_ok+0x2c8/0x3a8
[c02dbf70] [c02a9788] free_all_bootmem_core+0x1a4/0x240
[c02dbfa0] [c02a4544] mem_init+0x64/0x178
[c02dbfc0] [c029a67c] start_kernel+0x1d0/0x2a8
[c02dbff0] [c00003b4] skpinv+0x2dc/0x318
BUG: Bad page state in process swapper  pfn:2fc8f
page:c0d0f1e0 flags:(null) count:0 mapcount:7799008 mapping:(null) index:0
Call Trace:
[c02dbef0] [c0007a84] show_stack+0x48/0x174 (unreliable)
[c02dbf20] [c006fa14] bad_page+0x9c/0x160
[c02dbf40] [c0071564] __free_pages_ok+0x2c8/0x3a8
[c02dbf70] [c02a9788] free_all_bootmem_core+0x1a4/0x240
[c02dbfa0] [c02a4544] mem_init+0x64/0x178
[c02dbfc0] [c029a67c] start_kernel+0x1d0/0x2a8
[c02dbff0] [c00003b4] skpinv+0x2dc/0x318
BUG: Bad page state in process swapper  pfn:2fcc4
page:c0d0f880 flags:(null) count:0 mapcount:7799040 mapping:(null) index:0
Call Trace:
[c02dbef0] [c0007a84] show_stack+0x48/0x174 (unreliable)
[c02dbf20] [c006fa14] bad_page+0x9c/0x160
[c02dbf40] [c0071564] __free_pages_ok+0x2c8/0x3a8
[c02dbf70] [c02a9788] free_all_bootmem_core+0x1a4/0x240
[c02dbfa0] [c02a4544] mem_init+0x64/0x178
[c02dbfc0] [c029a67c] start_kernel+0x1d0/0x2a8
[c02dbff0] [c00003b4] skpinv+0x2dc/0x318
------------------------------------------------------------------------------------

I shall be grateful if anyone could help me in resolving this issue

with regards,

Deepak Gaur

