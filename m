Return-Path: <linux-kernel-owner+w=401wt.eu-S1754359AbZHFIZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754359AbZHFIZc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 04:25:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754093AbZHFIZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 04:25:31 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47293 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753687AbZHFIZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 04:25:29 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 6 Aug 2009 17:23:41 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Subject: Re: mmotm 2009-08-06-00-30 uploaded
Message-Id: <20090806172341.17a34d60.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <200908060733.n767X6mN023120@imap1.linux-foundation.org>
References: <200908060733.n767X6mN023120@imap1.linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 06 Aug 2009 00:33:06 -0700
akpm@linux-foundation.org wrote:

> The mm-of-the-moment snapshot 2009-08-06-00-30 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/
> 
> and will soon be available at
> 
>    git://git.zen-sources.org/zen/mmotm.git
> 
> It contains the following patches against 2.6.31-rc5:
> 

Known issue ?

[    1.227119] INFO: trying to register non-static key.
[    1.227300] the code is fine but needs lockdep annotation.
[    1.227569] turning off the locking correctness validator.
[    1.227590] Pid: 1, comm: swapper Not tainted 2.6.31-rc5-mm1 #1
[    1.227609] Call Trace:
[    1.228000]  [<ffffffff81062978>] __lock_acquire+0xf70/0x174d
[    1.228000]  [<ffffffff813b541f>] ? __hw_addr_add+0x7c/0x115
[    1.228000]  [<ffffffff81060b6d>] ? mark_held_locks+0x4d/0x6b
[    1.228000]  [<ffffffff810bbf1c>] ? kmem_cache_alloc+0xa9/0x10c
[    1.228000]  [<ffffffff81060de0>] ? trace_hardirqs_on_caller+0x10b/0x12f
[    1.228000]  [<ffffffff81063216>] lock_acquire+0xc1/0xe5
[    1.228000]  [<ffffffff813b9f0e>] ? alloc_netdev_mq+0x12a/0x214
[    1.228000]  [<ffffffff814dd0a9>] _spin_lock_bh+0x31/0x3d
[    1.228000]  [<ffffffff813b9f0e>] ? alloc_netdev_mq+0x12a/0x214
[    1.228000]  [<ffffffff813b9f0e>] alloc_netdev_mq+0x12a/0x214
[    1.228000]  [<ffffffff812eedeb>] ? loopback_setup+0x0/0x7b
[    1.228000]  [<ffffffff8184aa7c>] loopback_net_init+0x30/0x7d
[    1.228000]  [<ffffffff813b37be>] register_pernet_device+0x2d/0x5a
[    1.228000]  [<ffffffff81851c15>] net_dev_init+0x143/0x1a1
[    1.228000]  [<ffffffff81851ad2>] ? net_dev_init+0x0/0x1a1
[    1.228000]  [<ffffffff8100905c>] do_one_initcall+0x56/0x130
[    1.228000]  [<ffffffff81084c95>] ? register_irq_proc+0xb0/0xcc
[    1.228000]  [<ffffffff81110000>] ? proc_fill_cache+0x27/0x132
[    1.228000]  [<ffffffff81820678>] kernel_init+0x168/0x1be
[    1.228000]  [<ffffffff8100cb5a>] child_rip+0xa/0x20
[    1.228000]  [<ffffffff8100c53c>] ? restore_args+0x0/0x30
[    1.228000]  [<ffffffff810acb75>] ? __get_vm_area_node+0x198/0x1e3
[    1.228000]  [<ffffffff81055fc7>] ? up+0xf/0x39
[    1.228000]  [<ffffffff81820510>] ? kernel_init+0x0/0x1be
[    1.228000]  [<ffffffff8100cb50>] ? child_rip+0x0/0x20
[    1.241276] cfg80211: Calling CRDA to update world regulatory domain


Thanks,
-Kame

