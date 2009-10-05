Return-Path: <linux-kernel-owner+w=401wt.eu-S1753795AbZJEGcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753795AbZJEGcQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 02:32:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752973AbZJEGcP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 02:32:15 -0400
Received: from brick.kernel.dk ([93.163.65.50]:54042 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752576AbZJEGcP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 02:32:15 -0400
Date: Mon, 5 Oct 2009 08:31:38 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Philipp Reisner <philipp.reisner@linbit.com>, drbd-dev@linbit.com
Subject: Re: linux-next: block/drbd tree build failure
Message-ID: <20091005063138.GO26573@kernel.dk>
References: <20091005143552.977a2d4d.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091005143552.977a2d4d.sfr@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 05 2009, Stephen Rothwell wrote:
> Hi Jens,
> 
> Today's linux-next build (x86_64 allmodconfig) failed like this:
> 
> drivers/block/drbd/drbd_req.c: In function '_drbd_start_io_acct':
> drivers/block/drbd/drbd_req.c:43: error: subscripted value is neither array nor pointer
> drivers/block/drbd/drbd_req.c: In function '_drbd_end_io_acct':
> drivers/block/drbd/drbd_req.c:56: error: subscripted value is neither array nor pointer
> 
> I reported a similar error against the dbd tree, which was fixed, but now
> the commit that caused that error has been reverted and thus we get
> this :-(
> 
> I have reverted the drbd commits from the block tree for today.

That's probably my fault, not drbd. I moved it to a new branch since it
isn't going into 2.6.32, and perhaps dropped that fix along the way.
I'll look into it.

-- 
Jens Axboe

