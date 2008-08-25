Return-Path: <linux-kernel-owner+w=401wt.eu-S1756763AbYHYSe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756763AbYHYSe4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 14:34:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755993AbYHYSem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 14:34:42 -0400
Received: from [93.163.65.50] ([93.163.65.50]:1373 "EHLO kernel.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756590AbYHYSel (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 14:34:41 -0400
Date: Mon, 25 Aug 2008 20:34:38 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, nix@esperi.org.uk, adobriyan@gmail.com
Subject: Re: [PATCH 0/2] bio: blk_rq_map_* bounce support fixes
Message-ID: <20080825183437.GO20055@kernel.dk>
References: <871w0eb9nx.fsf@hades.wkstn.nix> <1219641773-25856-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1219641773-25856-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25 2008, FUJITA Tomonori wrote:
> This patchset fixes blk_rq_map_user_iov and blk_rq_map_kern bounce
> support, which were introduced in 2.6.26. They can't handle READ
> requests that partially completed.
> 
> This is against the for-linus branch in the block tree.
> 
> I think that we can clean up the code a bit (e.g. bio_copy_kern could
> use __bio_copy_iov) but the patches need to go to the stable tree so I
> kept the change to a minimum.

Agree, for 2.6.27 lets keep it at the simplest. I've applied it, thanks
a lot for fixing this!

-- 
Jens Axboe

