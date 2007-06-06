Return-Path: <linux-kernel-owner+w=401wt.eu-S1755970AbXFFOAP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970AbXFFOAP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 10:00:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751124AbXFFOAE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 10:00:04 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:3017 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbXFFOAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 10:00:01 -0400
Message-ID: <4666BDF1.6080801@shadowen.org>
Date: Wed, 06 Jun 2007 15:00:17 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc4-mm1 -- x86_64 ACPI panic
References: <20070606020737.4663d686.akpm@linux-foundation.org>
In-Reply-To: <20070606020737.4663d686.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.2.0
OpenPGP: url=http://www.shadowen.org/~apw/public-key
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Getting this on a bigger x86_64 (bl6-13):

Unable to handle kernel NULL pointer dereference at 0000000000000000 RIP:
 [<ffffffff8037898b>] acpi_processor_throttling_seq_show+0xa7/0xd6
PGD 2d77067 PUD 34c3067 PMD 0
Oops: 0000 [1] SMP
CPU 3
Modules linked in: video output button battery asus_acpi ac lp
parport_pc parport floppy nvram amd_rng rng_core i2c_amd756 i2c_core
Pid: 1634, comm: head Not tainted 2.6.22-rc4-mm1-autokern1 #1
RIP: 0010:[<ffffffff8037898b>]  [<ffffffff8037898b>]
acpi_processor_throttling_seq_show+0xa7/0xd6
RSP: 0018:ffff810003c9de48  EFLAGS: 00010246
RAX: 0000000000000020 RBX: ffff8100029e7800 RCX: 0000000000000000
RDX: 000000000000002a RSI: ffffffff805993e4 RDI: ffff810002d714c0
RBP: ffff810002d714c0 R08: ffff810003f82051 R09: ffff810002d714c0
R10: ffffffffffffffff R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 00007fff64fd2b90
FS:  00002b3545aec6f0(0000) GS:ffff810001683a40(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000003966000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process head (pid: 1634, threadinfo ffff810003c9c000, task ffff810001c8c810)
Stack:  00000000000000d0 ffff810002d714c0 0000000000000001 0000000000000001
 0000000000002000 ffffffff802ab6eb ffff810003c9df50 ffff810002915d00
 ffff810002d714f0 ffff810002fa2000 0000000000000000 fffffffffffffffb
Call Trace:
 [<ffffffff802ab6eb>] seq_read+0x105/0x28e
 [<ffffffff802ab5e6>] seq_read+0x0/0x28e
 [<ffffffff802cd085>] proc_reg_read+0x80/0x9a
 [<ffffffff802925a7>] vfs_read+0xcb/0x153
 [<ffffffff80292943>] sys_read+0x45/0x6e
 [<ffffffff8020bc5e>] system_call+0x7e/0x83


Code: 45 8b 44 0d 00 44 89 e1 0f 45 d0 31 c0 49 ff c4 49 83 c5 28
RIP  [<ffffffff8037898b>] acpi_processor_throttling_seq_show+0xa7/0xd6
 RSP <ffff810003c9de48>
CR2: 0000000000000000
FATAL: Error inserting acpi_cpufreq
(/lib/modules/2.6.22-rc4-mm1-autokern1/kernel/arch/x86_64/kernel/cpufreq/acpi-cpufreq.ko):
No such device
