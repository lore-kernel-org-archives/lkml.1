Return-Path: <linux-kernel-owner+w=401wt.eu-S1759397AbYBRMvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759397AbYBRMvY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 07:51:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751244AbYBRMvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 07:51:16 -0500
Received: from brick.kernel.dk ([87.55.233.238]:21226 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751237AbYBRMvQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 07:51:16 -0500
Date: Mon, 18 Feb 2008 13:51:12 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Ken Chen <kenneth.w.chen@intel.com>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, bcrl@kvack.org, linux-aio@kvack.org
Subject: Re: [RFC: 2.6 patch] fs/block_dev.c: remove #if 0'ed code
Message-ID: <20080218125112.GY23197@kernel.dk>
References: <20080217081741.GH3848@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080217081741.GH3848@cs181133002.pp.htv.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 17 2008, Adrian Bunk wrote:
> Commit b2e895dbd80c420bfc0937c3729b4afe073b3848 #if 0'ed this code stating:
> 
> <--  snip  -->
> 
>     [PATCH] revert blockdev direct io back to 2.6.19 version
>     
>     Andrew Vasquez is reporting as-iosched oopses and a 65% throughput
>     slowdown due to the recent special-casing of direct-io against
>     blockdevs.  We don't know why either of these things are occurring.
>     
>     The patch minimally reverts us back to the 2.6.19 code for a 2.6.20
>     release.
> 
> <--  snip  -->
> 
> It has since been dead code, and unless someone wants to revive it now 
> it's time to remove it.
> 
> This patch also makes bio_release_pages() static again and removes the 
> ki_bio_count member from struct kiocb, reverting changes that had been 
> done for this dead code.

I agree with this, if it's been sitting like that for a long time, might
as well just kill it. I've merged your patch, if no one complains it'll
go in during 2.6.25.

-- 
Jens Axboe

