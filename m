Return-Path: <linux-kernel-owner+w=401wt.eu-S1760127AbXJLHQa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760127AbXJLHQa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 03:16:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757326AbXJLHQW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 03:16:22 -0400
Received: from brick.kernel.dk ([87.55.233.238]:14650 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754929AbXJLHQW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 03:16:22 -0400
Date: Fri, 12 Oct 2007 09:16:36 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] more bio fallout
Message-ID: <20071012071631.GC5186@kernel.dk>
References: <20071012061747.GZ8181@ftp.linux.org.uk> <20071012071426.GB5186@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071012071426.GB5186@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 12 2007, Jens Axboe wrote:
> On Fri, Oct 12 2007, Al Viro wrote:
> 
> Thanks for this and the other patch that Linus already merged, I'll
> shove this into a git-branch-of-the-day to collect fallout that I'll
> submit to Linus. Andrew had already notified me of the gfs2/jfs/ocfs2
> breakage, but I had naively thought it only affected -mm additions.

Oh, and Linus don't apply this one if you beat me to submitting a pull
request, the bi_end_io() changes aren't complete (they need bi_size
check updated as well).

-- 
Jens Axboe

