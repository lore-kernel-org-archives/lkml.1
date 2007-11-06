Return-Path: <linux-kernel-owner+w=401wt.eu-S1756461AbXKFRRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756461AbXKFRRR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 12:17:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754041AbXKFRRE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 12:17:04 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:56805 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754195AbXKFRRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 12:17:03 -0500
Message-ID: <4730A17B.7010508@linux.vnet.ibm.com>
Date: Tue, 06 Nov 2007 22:46:43 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
CC: akpm@linux-foundation.org, mm-commits@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andy Whitcroft <apw@shadowen.org>
Subject: Re: [BUG] mm snapshot broken-out-2007-11-06-02-32.tar.gz - soft lockup
References: <200711061033.lA6AXrhT018804@imap1.linux-foundation.org> <47309BA4.2010803@linux.vnet.ibm.com>
In-Reply-To: <47309BA4.2010803@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kamalesh Babulal wrote:
> Hi Andrew,
> 
> The kernel is stuck at soft lockup while booting, with following
> call trace
> 
> BUG: soft lockup - CPU#1 stuck for 11s! [mount:959]
> 
> Pid: 959, comm: mount Not tainted (2.6.24-rc1-mm1-autokern1 #1)
> EIP: 0060:[<c1067b81>] EFLAGS: 00000206 CPU: 1
> EIP is at shrink_dcache_sb+0x4c/0xd1
> EAX: c132fe80 EBX: c1c21248 ECX: c1985000 EDX: fffffff3
> ESI: c1c21248 EDI: c1985000 EBP: c181a000 ESP: c2695e94
>  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> CR0: 8005003b CR2: 09dc8000 CR3: 02675000 CR4: 000002f0
> DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> DR6: ffff0ff0 DR7: 00000400
>  [<c105b871>] do_remount_sb+0x2c/0xa4
>  [<c108f0c0>] sysfs_fill_super+0x0/0x85
>  [<c105bc7d>] get_sb_single+0x71/0x88
>  [<c108f157>] sysfs_get_sb+0x12/0x17
>  [<c108f0c0>] sysfs_fill_super+0x0/0x85
>  [<c105bccb>] vfs_kern_mount+0x37/0x6e
>  [<c106c7ec>] do_new_mount+0x86/0x109
>  [<c106ce4b>] do_mount+0x18b/0x1a5
>  [<c1002c84>] apic_timer_interrupt+0x28/0x30
>  [<c106cc1e>] exact_copy_from_user+0x44/0x4f
>  [<c106d0b7>] sys_mount+0x6f/0xad
>  [<c100221e>] syscall_call+0x7/0xb
>  [<c1200000>] svcauth_unix_set_client+0xc/0x14d
>  =======================
> 

Kamalesh,

sysrq output would be really nice. sysrq-t, sysrq-d, sysrq-m.
Please see Documentation/sysrq.txt for details on how to use
sysrq.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
