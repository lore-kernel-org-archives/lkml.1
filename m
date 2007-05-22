Return-Path: <linux-kernel-owner+w=401wt.eu-S1762475AbXEVHKT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762475AbXEVHKT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 03:10:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754985AbXEVHKH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 03:10:07 -0400
Received: from brick.kernel.dk ([80.160.20.94]:10230 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754953AbXEVHKG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 03:10:06 -0400
Date: Tue, 22 May 2007 09:07:39 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>, Hugh Dickins <hugh@veritas.com>,
       Srihari Vijayaraghavan <sriharivijayaraghavan@yahoo.com.au>,
       Oliver Xymoron <oxymoron@waste.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PROBLEM] 2.6.22-rc2 panics on x86-64 with slub
Message-ID: <20070522070738.GI4705@kernel.dk>
References: <20070520133505.46147.qmail@web52609.mail.re2.yahoo.com> <Pine.LNX.4.64.0705210917280.25871@schroedinger.engr.sgi.com> <Pine.LNX.4.64.0705211835140.26666@blonde.wat.veritas.com> <Pine.LNX.4.64.0705211121570.26794@schroedinger.engr.sgi.com> <Pine.LNX.4.64.0705211930370.31659@blonde.wat.veritas.com> <Pine.LNX.4.64.0705211147100.26970@schroedinger.engr.sgi.com> <20070521190043.GA4705@kernel.dk> <Pine.LNX.4.64.0705211208270.27129@schroedinger.engr.sgi.com> <Pine.LNX.4.64.0705212026080.5442@blonde.wat.veritas.com> <Pine.LNX.4.64.0705211524060.29480@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705211524060.29480@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21 2007, Christoph Lameter wrote:
> Ok booting SLUB without "slub_debug" and having
> 
> CONFIG_DEBUG_LOCK_ALLOC
> CONFIG_LOCKDEP
> 
> will trigger the problem.
> 
> So I guess the issue is that lockdep does a slab alloc while we get the 
> slab lock during slab alloc?

If I have CONFIG_SLUB_DEBUG set, then box boots fine. If I don't have it
set, then it hard hangs sometime after boot:

[...]
ReiserFS: sda2: Using r5 hash to sort names
VFS: Mounted root (reiserfs filesystem) readonly.
Freeing unused kernel memory: 180k freed

which is usually followed by messages bringing up the network link, etc.
Let me know which tests you want run, or which patches to try.

-- 
Jens Axboe

