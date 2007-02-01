Return-Path: <linux-kernel-owner+w=401wt.eu-S1422986AbXBAUYk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422986AbXBAUYk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 15:24:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422987AbXBAUYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 15:24:40 -0500
Received: from brick.kernel.dk ([62.242.22.158]:12945 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422986AbXBAUYj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 15:24:39 -0500
Date: Thu, 1 Feb 2007 21:26:47 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andrew Morton <akpm@osdl.org>, David Chinner <dgc@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.20-rc6-mm3
Message-ID: <20070201202646.GR10305@kernel.dk>
References: <20070129204528.eb8d695e.akpm@osdl.org> <Pine.LNX.4.64.0701311559310.11853@schroedinger.engr.sgi.com> <20070131162422.6bccc52c.akpm@osdl.org> <Pine.LNX.4.64.0701311626160.12104@schroedinger.engr.sgi.com> <20070131163638.290f40c1.akpm@osdl.org> <20070201062018.GC33919298@melbourne.sgi.com> <20070131231253.fdebc9f5.akpm@osdl.org> <Pine.LNX.4.64.0702011055310.7010@schroedinger.engr.sgi.com> <20070201191857.GQ10305@kernel.dk> <Pine.LNX.4.64.0702011214230.10061@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702011214230.10061@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 01 2007, Christoph Lameter wrote:
> On Thu, 1 Feb 2007, Jens Axboe wrote:
> 
> > for xfs_buf_wait_unpin() and xfs_buf_lock(). Does this fix it?
> 
> No it still hangs consistently. This time at an earlier spot.

That looks like barriers, could you try with those disabled? Sorry for
making you go through this, I can't debug and fix it myself before
monday.

-- 
Jens Axboe

