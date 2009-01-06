Return-Path: <linux-kernel-owner+w=401wt.eu-S1754000AbZAFJGI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000AbZAFJGI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 04:06:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751189AbZAFJFu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 04:05:50 -0500
Received: from alpha.facton.com ([83.236.152.122]:42062 "EHLO alpha.facton.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750931AbZAFJFs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 04:05:48 -0500
X-Greylist: delayed 748 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Jan 2009 04:05:47 EST
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: hwinfo problem since 2.6.28
Date: Tue, 6 Jan 2009 09:53:14 +0100
Message-ID: <3C59DB883F7B0B4D8096010D45ACCD13C73EA2@exch.facton.local>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: hwinfo problem since 2.6.28
Thread-Index: Aclv3DYqPGwhSzk9Qg22IVoJDubF+w==
From: "Beschorner Daniel" <Daniel.Beschorner@facton.com>
To: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since 2.6.28 my hwinfo tool crashes badly on 2 years old OpenSuSE 10.2
x64/SMP.
Older kernels run fine, I did a "make oldconfig" and rather used
defaults (just skipping low-64k checks).
This seems to be the only affected binary as far I can see.
Did I miss a new legacy/compat option or is it a bug?

Thank you!
Daniel

hwinfo: Corrupted page table at address 7fd04de3ec00
PGD 7dc33067 PUD 3efe067 PMD 27b83067 PTE fffffffffffffbff
Bad pagetable: 000d [#9] SMP
last sysfs file: /sys/devices/pci0000:00/0000:00:1e.0/0000:06:05.0/class
CPU 0
Modules linked in:
Pid: 13700, comm: hwinfo Tainted: G      D    2.6.28 #7
RIP: 0033:[<00007fd04d66f7f2>]  [<00007fd04d66f7f2>] 0x7fd04d66f7f2
RSP: 002b:00007fff55ed2c68  EFLAGS: 00010202
RAX: 00000000015d1fb0 RBX: 0000000000001000 RCX: fefefefefefefeff
RDX: 0000000000000001 RSI: 00007fd04de3ec00 RDI: 00000000015d1fb0
RBP: 000000000009fc00 R08: ffffffffff000000 R09: 00007fd04d6fbd60
R10: ffffffffffffffff R11: 0000000000000000 R12: 00007fd04d9a72f6
R13: 000000000009f000 R14: 0000000000000003 R15: 00000000015b4010
FS:  00007fd04dec06f0(0000) GS:ffffffff80619540(0000)
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007fd04de3ec00 CR3: 000000007de55000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process hwinfo (pid: 13700, threadinfo ffff88007dff2000, task
ffff88007ed934a0)

RIP  [<00007fd04d66f7f2>] 0x7fd04d66f7f2
 RSP <00007fff55ed2c68>
---[ end trace 742092d3bead57cc ]---


open("/dev/mem", O_RDONLY)              = 3
fstat(3, {st_mode=S_IFCHR|0640, st_rdev=makedev(1, 1), ...}) = 0
mmap(NULL, 4096, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7faeac9ec000
munmap(0x7faeac9ec000, 4096)            = 0
close(3)                                = 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0x7faeac95d000
open("/dev/mem", O_RDONLY)              = 3
fstat(3, {st_mode=S_IFCHR|0640, st_rdev=makedev(1, 1), ...}) = 0
mmap(NULL, 262144, PROT_READ, MAP_PRIVATE, 3, 0xc0000) = 0x7faeac91d000
munmap(0x7faeac91d000, 262144)          = 0
close(3)                                = 0
open("/dev/mem", O_RDONLY)              = 3
fstat(3, {st_mode=S_IFCHR|0640, st_rdev=makedev(1, 1), ...}) = 0
mmap(NULL, 4096, PROT_READ, MAP_PRIVATE, 3, 0x9f000) = 0x7faeac95c000
+++ killed by SIGKILL +++
