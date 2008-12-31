Return-Path: <linux-kernel-owner+w=401wt.eu-S1756612AbYLaQKD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756612AbYLaQKD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 11:10:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755949AbYLaQJx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 11:09:53 -0500
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:58359 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755914AbYLaQJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 11:09:51 -0500
Date: Wed, 31 Dec 2008 21:33:29 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linux-s390@vger.kernel.org, heiko.carstens@de.ibm.com,
       schwidefsky@de.ibm.com
Subject: [BUG] next-20081231 - S390x kernel panics while bootup at
	init_sched_build_groups()
Message-ID: <20081231160329.GC4268@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
References: <20090101003258.eaa44700.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090101003258.eaa44700.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

	next-2001231 kernel panic's on S390x box, while boot up

Linux version 2.6.28-next-20081231-autotest (root@lnxabat1) (gcc version 4.1.0 (
SUSE Linux)) #1 SMP Wed Dec 31 08:43:37 CST 2008
setup: Linux is running as a z/VM guest operating system in 64-bit mode
Zone PFN ranges:
  DMA      0x00000000 -> 0x00080000
  Normal   0x00080000 -> 0x00080000
Movable zone start PFN for each node
early_node_mapÝ1¨ active PFN ranges
    0: 0x00000000 -> 0x00040000
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 258560
Kernel command line: root=/dev/dasdc1 selinux=0 IDENT=1230735656 BOOT_IMAGE=0
PID hash table entries: 4096 (order: 12, 32768 bytes)
console ÝttyS0¨ enabled
Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
Memory: 1015808k/1048576k available (2483k kernel code, 0k reserved, 1372k data,
 196k init)
Write protected kernel read-only data: 0x12000 - 0x382fff
SLUB: Genslabs=12, HWalign=256, Order=0-3, MinObjects=0, CPUs=64, Nodes=1
Security Framework initialized
SELinux:  Disabled at boot.
Mount-cache hash table entries: 256
cpu: 4 configured CPUs, 0 standby CPUs
cpu: Processor 0 started, address 2, identification 20AB8A
cpu: Processor 1 started, address 0, identification 00AB8A
cpu: Processor 2 started, address 1, identification 10AB8A
cpu: Processor 3 started, address 3, identification 30AB8A
Brought up 4 CPUs
Unable to handle kernel pointer dereference at virtual kernel address 0000000100
3fa000
Oops: 003b Ý#1¨ SMP
Modules linked in:
CPU: 0 Not tainted 2.6.28-next-20081231-autotest #1
Process swapper (pid: 1, task: 000000003fe80000, ksp: 000000003fe8ba78)
Krnl PSW : 0704000180000000 0000000000035632 (init_sched_build_groups+0xae/0x4a4
)
           R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:0 CC:0 PM:0 EA:3
Krnl GPRS: 00000000003c27b0 00000001003fa278 0000000000000000 00000000003c2508
           0000000000000000 000000000026f818 0000000000000000 0000000000000000
           0000000000000000 000000003fe8be50 00000000ffffffff 000000003fe8bcf0
Krnl Code: 0000000000035626: a7290000           lghi    00: HCPGSP2629I The virt
ual machine is placed in CP mode due to a SIGP stop from
 CPU 02.
01: HCPGSP2629I The virtual machine is placed in CP mode due to a SIGP stop from
 CPU 02.
03: HCPGSP2629I The virtual machine is placed in CP mode due to a SIGP stop from
 CPU 02.
02: HCPGIR450W CP entered; disabled wait PSW 00020001 80000000 00000000 00021416-- 0:conmux-control -- time-stamp -- Dec/31/08  7:04:54 --
-- 0:conmux-control -- time-stamp -- Dec/31/08  7:22:18 --
(bot:conmon-payload) disconnected
-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
