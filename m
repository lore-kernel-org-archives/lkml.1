Return-Path: <linux-kernel-owner+w=401wt.eu-S1752311AbZL0N4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752311AbZL0N4g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 08:56:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752144AbZL0N4f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 08:56:35 -0500
Received: from queue01.mail.zen.net.uk ([212.23.3.234]:60904 "EHLO
	fizeau.zen.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970AbZL0N4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 08:56:35 -0500
X-Greylist: delayed 1238 seconds by postgrey-1.27 at vger.kernel.org; Sun, 27 Dec 2009 08:56:34 EST
Date: Sun, 27 Dec 2009 13:35:52 +0000
From: Grant Wilson <grant.wilson@zen.co.uk>
To: lkml <linux-kernel@vger.kernel.org>
Subject: 2.6.33-rc2: WARNING: at kernel/lockdep.c:2830
Message-ID: <20091227133552.23ec12ef@worthy.swandive.local>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Originating-Smarthost03-IP: [82.71.45.175]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hit the following running 2.6.33-rc2.  Config available at http://swandive.no-ip.com/linux/config

[ 9675.476027] WARNING: at kernel/lockdep.c:2830 __lock_acquire+0x598/0xb30()
[ 9675.476030] Hardware name: System Product Name
[ 9675.476032] Modules linked in:
[ 9675.476036] Pid: 2733, comm: X Tainted: G        W  2.6.33-rc2 #2
[ 9675.476039] Call Trace:
[ 9675.476045]  [<ffffffff8106b0c8>] warn_slowpath_common+0x78/0xb0
[ 9675.476048]  [<ffffffff8106b10f>] warn_slowpath_null+0xf/0x20
[ 9675.476051]  [<ffffffff81098ab8>] __lock_acquire+0x598/0xb30
[ 9675.476056]  [<ffffffff81030e92>] ? native_sched_clock+0x22/0x70
[ 9675.476060]  [<ffffffff81030d09>] ? sched_clock+0x9/0x10
[ 9675.476064]  [<ffffffff8108a41d>] ? sched_clock_cpu+0xcd/0x110
[ 9675.476067]  [<ffffffff810990b5>] lock_acquire+0x65/0x90
[ 9675.476073]  [<ffffffff8135e670>] ? radeon_fence_signaled+0x30/0xc0
[ 9675.476077]  [<ffffffff815fea0a>] _raw_write_lock_irqsave+0x5a/0xa0
[ 9675.476080]  [<ffffffff8135e670>] ? radeon_fence_signaled+0x30/0xc0
[ 9675.476083]  [<ffffffff815feff5>] ? _raw_spin_unlock_irqrestore+0x45/0x80
[ 9675.476087]  [<ffffffff8135e670>] radeon_fence_signaled+0x30/0xc0
[ 9675.476090]  [<ffffffff8135e900>] radeon_fence_wait+0x200/0x3c0
[ 9675.476094]  [<ffffffff81083e80>] ? autoremove_wake_function+0x0/0x40
[ 9675.476099]  [<ffffffff8136f5cf>] radeon_ib_get+0xaf/0x210
[ 9675.476102]  [<ffffffff8137046f>] radeon_cs_ioctl+0x8f/0x1c0
[ 9675.476107]  [<ffffffff8131b893>] drm_ioctl+0x1c3/0x490
[ 9675.476110]  [<ffffffff81098a17>] ? __lock_acquire+0x4f7/0xb30
[ 9675.476113]  [<ffffffff813703e0>] ? radeon_cs_ioctl+0x0/0x1c0
[ 9675.476117]  [<ffffffff8108a41d>] ? sched_clock_cpu+0xcd/0x110
[ 9675.476120]  [<ffffffff810946ea>] ? get_lock_stats+0x2a/0x60
[ 9675.476123]  [<ffffffff8109472e>] ? put_lock_stats+0xe/0x30
[ 9675.476126]  [<ffffffff81094803>] ? lock_release_holdtime+0xb3/0x160
[ 9675.476130]  [<ffffffff81106318>] vfs_ioctl+0x38/0xd0
[ 9675.476133]  [<ffffffff811064ea>] do_vfs_ioctl+0x8a/0x5b0
[ 9675.476137]  [<ffffffff8127a7f9>] ? __up_read+0x99/0xc0
[ 9675.476140]  [<ffffffff81088ac6>] ? up_read+0x26/0x30
[ 9675.476144]  [<ffffffff81028bba>] ? sysret_check+0x2e/0x69
[ 9675.476148]  [<ffffffff81106a5a>] sys_ioctl+0x4a/0x80
[ 9675.476151]  [<ffffffff81028b82>] system_call_fastpath+0x16/0x1b

Cheers,
Grant
-- 
Running Linux 2.6.33-rc2 on x86_64
