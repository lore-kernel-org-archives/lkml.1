Return-Path: <linux-kernel-owner+w=401wt.eu-S1759255AbXELS24@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759255AbXELS24 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 14:28:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755800AbXELS2u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 14:28:50 -0400
Received: from brick.kernel.dk ([80.160.20.94]:20434 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755307AbXELS2t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 14:28:49 -0400
Date: Sat, 12 May 2007 20:27:57 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Oliver Xymoron <oxymoron@waste.org>
Cc: Christoph Lameter <clameter@sgi.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: SLUB under lguest on i386
Message-ID: <20070512182756.GP4629@kernel.dk>
References: <20070511213336.GX11166@waste.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070511213336.GX11166@waste.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11 2007, Oliver Xymoron wrote:
> Tried to boot using SLUB under lguest with 2.6.21-mm2. Got the
> following:
> 
> ...
> [    0.388000] NET: Registered protocol family 17
> [    0.388000] Using IPI Shortcut mode
> [    0.420000] EXT2-fs warning: mounting unchecked fs, running e2fsck
> is recommended
> [    0.420000] VFS: Mounted root (ext2 filesystem).
> [    0.420000] Freeing unused kernel memory: 188k freed
> [   17.536000] BUG: spinlock lockup on CPU#0, init/1, c17de0c0
> [   17.536000]  [<c0104584>] show_trace_log_lvl+0x1a/0x30
> [   17.536000]  [<c0105196>] show_trace+0x12/0x14
> [   17.536000]  [<c0105222>] dump_stack+0x15/0x17
> [   17.536000]  [<c021339f>] _raw_spin_lock+0xbf/0xd8
> [   17.536000]  [<c03cd41a>] _spin_lock+0x3c/0x42
> [   17.536000]  [<c0154f0c>] vma_adjust+0x1a9/0x35f
> [   17.536000]  [<c01554c3>] vma_merge+0x158/0x168
> [   17.536000]  [<c0155b3b>] mmap_region+0x13b/0x405
> [   17.536000]  [<c01560ec>] do_mmap_pgoff+0x211/0x269
> [   17.536000]  [<c0107594>] sys_mmap2+0x64/0xb4
> [   17.536000]  [<c010763d>] old_mmap+0x59/0x5f
> [   17.536000]  [<c0103ed0>] syscall_call+0x7/0xb
> [   17.536000]  =======================
> 
> And no sign of further progress. SLAB worked fine.

Exact same thing happens on real hardware here.

-- 
Jens Axboe

