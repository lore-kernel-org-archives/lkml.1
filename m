Return-Path: <linux-kernel-owner+w=401wt.eu-S1756880AbZBSUgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756880AbZBSUgV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 15:36:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752219AbZBSUgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 15:36:12 -0500
Received: from brick.kernel.dk ([93.163.65.50]:29164 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751746AbZBSUgL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 15:36:11 -0500
Date: Thu, 19 Feb 2009 21:33:44 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Steven Whitehouse <swhiteho@redhat.com>, cluster-devel@redhat.com,
       linux-kernel@vger.kernel.org, linux-btrace@vger.kernel.org
Subject: Re: GFS2: Add blktrace support to glocks
Message-ID: <20090219203344.GO29783@kernel.dk>
References: <1235062539.9571.771.camel@quoit> <20090219185919.GB28490@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090219185919.GB28490@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 19 2009, Christoph Hellwig wrote:
> On Thu, Feb 19, 2009 at 04:55:39PM +0000, Steven Whitehouse wrote:
> > Hi,
> > 
> > Since I last posted this pair of patches, I've done some extensive
> > updating of the kernel patch, so it should now be happy to compile
> > under all possible Kconfigs (fingers crossed) and also its a fair
> > bit cleaner too.
> > 
> > I'm adding the linux-btrace list, since I didn't know about that
> > list when I made the initial posting.
> > 
> > Since there is probably more GFS2 changes than blktrace changes, I
> > could push this through the GFS2 tree. Let me know if you'd prefer
> > it to go via the blktrace tree. I'd like to be able to push this
> > in at the next merge window if possible. This patch is against the
> > head of the GFS2 -nmw git tree (obviously that makes no difference
> > to the blktrace side of the patch).
> > 
> > An updated blktrace userland patch follows in the next email, although
> > the changes from the last version are fairly minor,
> 
> Umm, why would you put fs internal stuff into blktrace?  Just use
> the generic ringbuffer directly and trace into that one.

Agree, some months ago this would have made more sense, since it was
easy to just piggy back on top of blktrace. But now tracing is easily
available, so going that route makes more sense now. Especially since
this lock tracking doesn't need much of what blkparse offers anyway.

-- 
Jens Axboe

