Return-Path: <linux-kernel-owner+w=401wt.eu-S1754813AbZGNOYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813AbZGNOYe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 10:24:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754552AbZGNOYd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 10:24:33 -0400
Received: from frankvm.xs4all.nl ([80.126.170.174]:45195 "EHLO
	janus.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753986AbZGNOYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 10:24:32 -0400
X-Greylist: delayed 1502 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Jul 2009 10:24:32 EDT
Date: Tue, 14 Jul 2009 15:59:28 +0200
From: Frank van Maarseveen <frankvm@frankvm.com>
To: linux-kernel@vger.kernel.org
Subject: VFS/ext3: 2.6.29.4 nested mutex lockup
Message-ID: <20090714135928.GA3760@janus>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------------[ cut here ]------------ 
WARNING: at kernel/mutex.c:135 mutex_lock_nested+0x28a/0x2e0() 
Hardware name: Dell DXP051                   
Modules linked in:
 vmthrottle
 
Pid: 29131, comm: make Not tainted 2.6.29.4-x202 #1 
Call Trace: 
 [<c065bc3f>] ? printk+0x18/0x1a 
 [<c0149bd3>] warn_slowpath+0x73/0xd0 
 [<c020b703>] ? ext3_find_entry+0x5c3/0x6e0 
 [<c01adc9c>] ? slab_pad_check+0x3c/0x120 
 [<c065d7da>] mutex_lock_nested+0x28a/0x2e0 
 [<c01bbc4c>] ? do_lookup+0xdc/0x1e0 
 [<c01c51e9>] ? dput+0x89/0x140 
 [<c01bba60>] ? __follow_mount+0x20/0x80 
 [<c01bbc4c>] do_lookup+0xdc/0x1e0 
 [<c01bd290>] __link_path_walk+0x2f0/0xd50 
 [<c01afa1e>] ? __slab_alloc+0x13e/0x620 
 [<c01bdea4>] path_walk+0x54/0xb0 
 [<c01bdfec>] do_path_lookup+0x8c/0x170 
 [<c01bec3a>] user_path_at+0x4a/0x80 
 [<c01b7014>] ? cp_new_stat64+0xe4/0x100 
 [<c01b7361>] vfs_stat_fd+0x21/0x50 
 [<c01b7431>] vfs_stat+0x11/0x20 
 [<c01b7454>] sys_stat64+0x14/0x30 
 [<c0121276>] ? syscall_exit+0x8/0x1a 
 [<c012126a>] syscall_call+0x7/0xb 
---[ end trace 92b87b1c7643c599 ]--- 
BUG: NMI Watchdog detected LOCKUP

-- 
Frank
