Return-Path: <linux-kernel-owner+w=401wt.eu-S1759612AbYDDRxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759612AbYDDRxv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 13:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758412AbYDDRxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 13:53:39 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:49418 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756586AbYDDRxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 13:53:38 -0400
Subject: 2.6.25-rc8-mm1 panic in rpaphp_register_slot()
From: Badari Pulavarty <pbadari@us.ibm.com>
To: achiang@hp.com, Andrew Morton <akpm@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 04 Apr 2008 10:53:36 -0700
Message-Id: <1207331616.5916.15.camel@badari-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew & Alex,

I get following panic in rpaphp_register_slot() on
2.6.25-rc8-mm1. Known issue ?


Thanks,
Badari

pci_hotplug: PCI Hot Plug PCI Core version: 0.5
rpaphp: RPA HOT Plug PCI Controller Driver version: 0.1
Unable to handle kernel paging request for data at address 0x00000070
Faulting instruction address: 0xc00000000031e4b8 
Oops: Kernel access of bad area, sig: 11 [#1]
SMP NR_CPUS=32 NUMA pSeries
Modules linked in:
NIP: c00000000031e4b8 LR: c00000000031dd60 CTR: 0000000000000000
REGS: c0000000700dba30 TRAP: 0300   Not tainted  (2.6.25-rc8-mm1)
MSR: 8000000000009032 <EE,ME,IR,DR>  CR: 42002022  XER: 20000009
DAR: 0000000000000070, DSISR: 0000000040000000
TASK = c0000000700d7990[1] 'swapper' THREAD: c0000000700d8000 CPU: 0
GPR00: c0000000006c6e90 c0000000700dbcb0 c000000000769140 c0000000703c1440
GPR04: c000000070226400 0000000000000000 0000000020000009 d000080080000004
GPR08: 0000000000000001 0000000000000000 c000000071fff1b8 0000000000000000
GPR12: 0000000000004000 c000000000690380 0000000000000000 0000000000000000
GPR16: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
GPR20: 4000000001c00000 0000000000000000 0000000002247c38 0000000000000000
GPR24: 0000000002247ea8 c000000071fff1b8 0000000000000000 c0000000023e8f48
GPR28: c0000000703c1440 c000000070ff7780 c0000000006f7778 c0000000006c6e90
NIP [c00000000031e4b8] .rpaphp_register_slot+0xd8/0x164
LR [c00000000031dd60] .rpaphp_add_slot+0x1a4/0x260
Call Trace:
[c0000000700dbcb0] [c0000000700dbd70] 0xc0000000700dbd70 (unreliable)
[c0000000700dbd40] [c00000000031dd60] .rpaphp_add_slot+0x1a4/0x260
[c0000000700dbe20] [c000000000636864] .rpaphp_init+0x34/0x68
[c0000000700dbea0] [c0000000006103ec] .kernel_init+0x1f8/0x38c
[c0000000700dbf90] [c000000000023f80] .kernel_thread+0x4c/0x68
Instruction dump:
48000020 e8bd0020 e89e8010 e87e8048 4bd38c09 60000000 3860fff5 48000080
e93d0028 e89d0030 7f83e378 e9290038 <e9290070> 80a90004 78a5eee2 4bffee7d
---[ end trace 561bb236c800851f ]---
Kernel panic - not syncing: Attempted to kill init!


