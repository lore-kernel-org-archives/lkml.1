Return-Path: <linux-kernel-owner+w=401wt.eu-S1755487AbZINMj1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487AbZINMj1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 08:39:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755434AbZINMj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 08:39:27 -0400
Received: from brick.kernel.dk ([93.163.65.50]:47588 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755389AbZINMj0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 08:39:26 -0400
Date: Mon, 14 Sep 2009 14:39:29 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, hch@infradead.org, tytso@mit.edu,
       akpm@linux-foundation.org, trond.myklebust@fys.uio.no
Subject: Re: [PATCH 1/7] writeback: merely wakeup flusher thread if work
	allocation fails for WB_SYNC_NONE
Message-ID: <20090914123929.GF14984@kernel.dk>
References: <1252920994-11141-1-git-send-email-jens.axboe@oracle.com> <1252920994-11141-2-git-send-email-jens.axboe@oracle.com> <20090914123425.GF24075@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090914123425.GF24075@duck.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 14 2009, Jan Kara wrote:
> On Mon 14-09-09 11:36:28, Jens Axboe wrote:
> > From: Christoph Hellwig <hch@infradead.org>
> > 
> > Since it's an opportunistic writeback and not a data integrity action,
> > don't punt to blocking writeback. Just wakeup the thread and it will
> > flush old data.
> > 
> > Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
>   Looks good. Acked-by: Jan Kara <jack@suse.cz>

Thanks!

>  BTW, don't we miss Christoph's Signed-off-by?

We do, he didn't include one.

-- 
Jens Axboe

