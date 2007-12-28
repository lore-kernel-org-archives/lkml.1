Return-Path: <linux-kernel-owner+w=401wt.eu-S1754518AbXL1NDp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518AbXL1NDp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 08:03:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752170AbXL1NDh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 08:03:37 -0500
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:48887 "EHLO
	e28esmtp06.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752828AbXL1NDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 08:03:37 -0500
Date: Fri, 28 Dec 2007 18:33:07 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: Re: 2.6.24-rc6-mm1 Kernel panics at different functions ()
Message-ID: <20071228130307.GA20821@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20071222233056.d652743e.akpm@linux-foundation.org> <47736732.7040400@linux.vnet.ibm.com> <20071227015410.2c09db2f.akpm@linux-foundation.org> <4774BDBA.70904@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4774BDBA.70904@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> While doing the git bisect, following panic was seen
> 
> Unable to handle kernel paging request at 000000000000401e RIP: 
>  [<ffffffff80232ec8>] load_balance_monitor+0x15e/0x2a4
> PGD 0 
> Oops: 0000 [1] SMP 
> last sysfs file: /devices/pci0000:00/0000:00:0a.0/0000:02:04.0/host0/target0:0:6/0:0:6:0/type
> CPU 1 
> Modules linked in:
> Pid: 15, comm: load_balance_mo Not tainted 2.6.24-rc6-mm1-autokern1 #1
> RIP: 0010:[<ffffffff80232ec8>]  [<ffffffff80232ec8>] load_balance_monitor+0x15e/0x2a4
> RSP: 0000:ffff81007ffb7eb0  EFLAGS: 00010297
> RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000000
> RDX: 000000000000401e RSI: ffff81007ffb7ed8 RDI: 0000000000000000
> RBP: ffff81007ffb7f20 R08: ffff81007ffb6000 R09: ffff81007ffb6000
> R10: ffff81007ffb6000 R11: 0000000000000000 R12: 0000000000000000
> R13: 0000000000000003 R14: 0000000000000800 R15: ffff8101fe997f00
> FS:  0000000000000000(0000) GS:ffff8100e3b10000(0000) knlGS:00000000f73e1bb0
> CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> CR2: 000000000000401e CR3: 0000000000201000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process load_balance_mo (pid: 15, threadinfo ffff81007ffb6000, task ffff81007ff94790)
> Stack:  0000000000002000 0000000000000000 ffff810001009cc0 00000001e3b29d90
>  0000008000000000 000000000000000f ffff81007f0be780 000000000000000f
>  000000017ffb7f20 0000000000000000 00000000fffffffc ffffffffffffffff
> Call Trace:
>  [<ffffffff80232d6a>] load_balance_monitor+0x0/0x2a4
>  [<ffffffff80247830>] kthread+0x3d/0x63
>  [<ffffffff8020c2b8>] child_rip+0xa/0x12
>  [<ffffffff802477f3>] kthread+0x0/0x63
>  [<ffffffff8020c2ae>] child_rip+0x0/0x12
> 
> 
> Code: 48 8b 04 c2 48 8b 10 48 01 55 98 e8 ce 40 12 00 83 f8 07 41 
> RIP  [<ffffffff80232ec8>] load_balance_monitor+0x15e/0x2a4
>  RSP <ffff81007ffb7eb0>
> CR2: 000000000000401e
> 

Hmmm. Looking into it :-).

-- 
regards,
Dhaval
