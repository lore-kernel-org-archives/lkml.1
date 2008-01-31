Return-Path: <linux-kernel-owner+w=401wt.eu-S1764857AbYAaEJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764857AbYAaEJT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 23:09:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756211AbYAaEJD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 23:09:03 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:41783 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754756AbYAaEJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 23:09:00 -0500
Date: Wed, 30 Jan 2008 20:26:26 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: system without RAM on node0 boot fail
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Message-id: <200801302026.27130.yinghai.lu@sun.com>
Organization: SUN
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


one system not install RAM on node0 got

SRAT: PXM 0 -> APIC 0 -> Node 0
SRAT: PXM 0 -> APIC 1 -> Node 0
SRAT: PXM 1 -> APIC 2 -> Node 1
SRAT: PXM 1 -> APIC 3 -> Node 1
SRAT: Node 1 PXM 1 0-a0000
SRAT: Node 1 PXM 1 0-dd000000
SRAT: Node 1 PXM 1 0-123000000
Bootmem setup node 1 0000000000000000-0000000123000000
  NODE_DATA [000000000000e000 - 0000000000014fff]
  bootmap [0000000000015000 -  00000000000395ff] pages 25
early res: 0 [0-fff] BIOS data page
early res: 1 [6000-7fff] SMP_TRAMPOLINE
early res: 2 [200000-d9c273] TEXT DATA BSS
early res: 3 [7e700000-7ffffa25] RAMDISK
early res: 4 [9bc00-9dbff] EBDA
early res: 5 [8000-dfff] PGTABLE
Could not find start_pfn for node 0
Pid: 0, comm: swapper Not tainted 2.6.24-smp-04921-gbce08dc-dirty #42

Call Trace:
 [<ffffffff80c200d6>] free_area_init_node+0x22/0x381
 [<ffffffff804539e5>] generic_swap+0x0/0x17
 [<ffffffff80c06a1b>] find_zone_movable_pfns_for_nodes+0x54/0x271
 [<ffffffff80c06f4a>] free_area_init_nodes+0x239/0x287
 [<ffffffff80c0203a>] paging_init+0x46/0x4c
 [<ffffffff80bf9dba>] setup_arch+0x3c3/0x44e
 [<ffffffff80bf38d3>] start_kernel+0x6f/0x2c7
 [<ffffffff80bf31e1>] _sinittext+0x1e1/0x1e8

RIP 0x10
