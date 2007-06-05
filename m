Return-Path: <linux-kernel-owner+w=401wt.eu-S1762846AbXFECTi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762846AbXFECTi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 22:19:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756748AbXFECTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 22:19:31 -0400
Received: from wr-out-0506.google.com ([64.233.184.226]:11134 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755867AbXFECTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 22:19:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:content-type:content-transfer-encoding;
        b=GD9wdyoXm7WK3TolPQ4IV6UI1k8uQoMr1DAObFrAWmiDwVogeg8nI4W8CDnZVUhfEBrntloTcLpejszNE1Iq6VH/HduhT4afEQngJ9gIUSJDyHCZoYsBIm3+P+OQEnTBjmPCHT+NIuGfoWBxFStFIxv/Ffc5tNhJhRWLJSIr2KI=
Message-ID: <4664C85D.5080409@gmail.com>
Date: Mon, 04 Jun 2007 23:20:13 -0300
From: Reinaldo de Carvalho <reinaldow@gmail.com>
User-Agent: IceDove 1.5.0.10 (X11/20070328)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Another missing RAM on x86_64
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

1024MB dont detected on Notebook HP 2125 with kernel 2.6.21.3

-- 
Reinaldo de Carvalho




:~# uname -a
Linux devil 2.6.21-amd64 #5 SMP Tue May 22 21:29:48 BRT 2007 x86_64 
GNU/Linux
:~# free -m
              total       used       free     shared    buffers     cached
Mem:           939        642        297          0         66        210
-/+ buffers/cache:        365        574
Swap:          956          0        956


Linux version 2.6.21-amd64 (root@devil) (gcc version 4.1.2 20061115 
(prerelease) (Debian 4.1.1-21)) #5 SMP Tue May 22 21:29:
48 BRT 2007
Command line: root=/dev/sda2 ro vga=0x317
BIOS-provided physical RAM map:
  BIOS-e820: 0000000000000000 - 000000000009dc00 (usable)
  BIOS-e820: 000000000009dc00 - 00000000000a0000 (reserved)
  BIOS-e820: 00000000000d2000 - 0000000000100000 (reserved)
  BIOS-e820: 0000000000100000 - 000000003bf10000 (usable)
  BIOS-e820: 000000003bf10000 - 000000003bf19000 (ACPI data)
  BIOS-e820: 000000003bf19000 - 000000003bf80000 (ACPI NVS)
  BIOS-e820: 000000003bf80000 - 0000000040000000 (reserved)
  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
  BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
Entering add_active_range(0, 0, 157) 0 entries of 256 used
Entering add_active_range(0, 256, 245520) 1 entries of 256 used
end_pfn_map = 1048576
DMI present.ACPI: RSDP 000F87C0, 0014 (r0 HP    )
ACPI: RSDT 3BF131F4, 0038 (r1 HP     30B5      6040000  LTP        0)
ACPI: FACP 3BF18D52, 0074 (r1 HP     30B5      6040000 PTL_    F4240)
ACPI: DSDT 3BF1322C, 5B26 (r1 HP       30B5    6040000 MSFT  100000E)
ACPI: FACS 3BF19FC0, 0040
ACPI: MCFG 3BF18DC6, 003C (r1 HP     30B5      6040000  LTP        0)
ACPI: APIC 3BF18E02, 0054 (r1 HP     30B5      6040000  LTP        0)
ACPI: BOOT 3BF18E56, 0028 (r1 HP     30B5      6040000  LTP        1)
ACPI: SSDT 3BF18E7E, 0182 (r1 HP     30B5      6040000  LTP        1)
Entering add_active_range(0, 0, 157) 0 entries of 256 used
Entering add_active_range(0, 256, 245520) 1 entries of 256 used
Zone PFN ranges:
   DMA             0 ->     4096
   DMA32        4096 ->  1048576
   Normal    1048576 ->  1048576
early_node_map[2] active PFN ranges
     0:        0 ->      157
     0:      256 ->   245520
On node 0 totalpages: 245421
   DMA zone: 56 pages used for memmap
   DMA zone: 1098 pages reserved
   DMA zone: 2843 pages, LIFO batch:0
   DMA32 zone: 3300 pages used for memmap
   DMA32 zone: 238124 pages, LIFO batch:31
   Normal zone: 0 pages used for memmap

processor       : 1
vendor_id       : AuthenticAMD
cpu family      : 15
model           : 72
model name      : AMD Turion(tm) 64 X2

