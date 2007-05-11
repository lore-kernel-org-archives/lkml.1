Return-Path: <linux-kernel-owner+w=401wt.eu-S934445AbXEKVeB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934445AbXEKVeB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 17:34:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762115AbXEKVdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 17:33:49 -0400
Received: from waste.org ([66.93.16.53]:42376 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934321AbXEKVds (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 17:33:48 -0400
Date: Fri, 11 May 2007 16:33:36 -0500
From: Oliver Xymoron <oxymoron@waste.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: SLUB under lguest on i386
Message-ID: <20070511213336.GX11166@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tried to boot using SLUB under lguest with 2.6.21-mm2. Got the
following:

...
[    0.388000] NET: Registered protocol family 17
[    0.388000] Using IPI Shortcut mode
[    0.420000] EXT2-fs warning: mounting unchecked fs, running e2fsck
is recommended
[    0.420000] VFS: Mounted root (ext2 filesystem).
[    0.420000] Freeing unused kernel memory: 188k freed
[   17.536000] BUG: spinlock lockup on CPU#0, init/1, c17de0c0
[   17.536000]  [<c0104584>] show_trace_log_lvl+0x1a/0x30
[   17.536000]  [<c0105196>] show_trace+0x12/0x14
[   17.536000]  [<c0105222>] dump_stack+0x15/0x17
[   17.536000]  [<c021339f>] _raw_spin_lock+0xbf/0xd8
[   17.536000]  [<c03cd41a>] _spin_lock+0x3c/0x42
[   17.536000]  [<c0154f0c>] vma_adjust+0x1a9/0x35f
[   17.536000]  [<c01554c3>] vma_merge+0x158/0x168
[   17.536000]  [<c0155b3b>] mmap_region+0x13b/0x405
[   17.536000]  [<c01560ec>] do_mmap_pgoff+0x211/0x269
[   17.536000]  [<c0107594>] sys_mmap2+0x64/0xb4
[   17.536000]  [<c010763d>] old_mmap+0x59/0x5f
[   17.536000]  [<c0103ed0>] syscall_call+0x7/0xb
[   17.536000]  =======================

And no sign of further progress. SLAB worked fine.

-- 
 "Love the dolphins," she advised him. "Write by W.A.S.T.E.." 
