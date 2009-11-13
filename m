Return-Path: <linux-kernel-owner+w=401wt.eu-S1755781AbZKMKCq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755781AbZKMKCq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 05:02:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755512AbZKMKCm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 05:02:42 -0500
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:43098 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755346AbZKMKCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 05:02:40 -0500
Message-ID: <4AFD2EC3.3040104@linux.vnet.ibm.com>
Date: Fri, 13 Nov 2009 15:32:43 +0530
From: Rishikesh <risrajak@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090825)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [2.6.32-rc6] : WARNING: at mm/page_alloc.c:1805 __alloc_pages_nodemask+0x1cb/0x67c()
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi All,

Getting this call trace on on 2.6.32-rc6 kernel. while running some 
memory testcases.


------------[ cut here ]------------
WARNING: at mm/page_alloc.c:1805 __alloc_pages_nodemask+0x1cb/0x67c()
Hardware name: IBM eServer BladeCenter HS21 -[8853L6A]-
Modules linked in: veth macvlan dummy ipt_MASQUERADE iptable_nat nf_nat 
bridge stp llc nfsd lockd nfs_acl auth_rpcgss exportfs sunrpc ipv6 
cpufreq_ondemand acpi_cpufreq freq_table dm_mirror dm_region_hash dm_log 
dm_multipath dm_mod ata_generic pata_acpi i5k_amb hwmon i5000_edac 
edac_core ioatdma dca bnx2 iTCO_wdt iTCO_vendor_support pcspkr ata_piix 
serio_raw shpchp mptsas mptscsih mptbase scsi_transport_sas [last 
unloaded: microcode]
Pid: 17590, comm: cat Not tainted 2.6.32-rc6-tip+ #1
Call Trace:
 [<ffffffff8104ecd6>] warn_slowpath_common+0x77/0x8f
 [<ffffffff8104ecfd>] warn_slowpath_null+0xf/0x11
 [<ffffffff810cb5eb>] __alloc_pages_nodemask+0x1cb/0x67c
 [<ffffffff81078ef9>] ? mark_held_locks+0x52/0x70
 [<ffffffff810c9fe0>] ? __free_pages_ok+0x16d/0x186
 [<ffffffff810f21a1>] alloc_pages_current+0x90/0x99
 [<ffffffff810ca380>] __get_free_pages+0x13/0x50
 [<ffffffff810fb62e>] __kmalloc+0x42/0x1a1
 [<ffffffff810fa5be>] ? kfree+0x6d/0x138
 [<ffffffff8111d639>] ? seq_read+0x1fd/0x36c
 [<ffffffff8111d639>] seq_read+0x1fd/0x36c
 [<ffffffff8111d43c>] ? seq_read+0x0/0x36c
 [<ffffffff8114d5bb>] proc_reg_read+0x8d/0xac
 [<ffffffff8110586f>] vfs_read+0xa6/0x103
 [<ffffffff81079185>] ? trace_hardirqs_on_caller+0x11d/0x141
 [<ffffffff81105982>] sys_read+0x45/0x69
 [<ffffffff81009bc2>] system_call_fastpath+0x16/0x1b
---[ end trace ec8ffea506351141 ]---


-Rishi
