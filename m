Return-Path: <linux-kernel-owner+w=401wt.eu-S1753703AbZEYRFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753703AbZEYRFi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 13:05:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751940AbZEYRFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 13:05:30 -0400
Received: from brick.kernel.dk ([93.163.65.50]:35960 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751582AbZEYRF3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 13:05:29 -0400
Date: Mon, 25 May 2009 19:05:30 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com
Subject: Re: [PATCH 0/11] Per-bdi writeback flusher threads #4
Message-ID: <20090525170530.GY11363@kernel.dk>
References: <1242649192-16263-1-git-send-email-jens.axboe@oracle.com> <4A1ABFE2.9050809@rsk.demon.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A1ABFE2.9050809@rsk.demon.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 25 2009, Richard Kennedy wrote:
> Hi Jens,
> 
> I've been testing this from your git version which builds as
> 2.6.30-rc6-00057-g81eabcf.
> 
> Unfortunately it's not doing too well.
> 
> When building a kernel with 'make -j 8' on my AMDX2 64bit, the screen
> repeatedly locked up for several minutes at a time,and my music player
> also froze.
> In total the full kernel build took over 80 minutes, normally it's only
> about 15.
> 
> However the machine seems to have recovered correctly, & now everything
> is back to normal.

Weird, perhaps you hit an unlucky revision. I only use the git branch
for development, and it's continually rebased to collect and split
patches and fixes. So I don't generally recommend to use that, just the
posted patches. I build -j8 or larger kernels with the writeback patches
all the time, and haven't seen any issues. That's on a core 2 quad. Just
for kicks, can you send me your .config?

I'll post a new revision tomorrow, if you could try that I'd appreciate
it!

> Maybe it does need the congestion handling after all?

No it does not, by the very nature of the bdi threads being blocking,
congestion is not relevant.

-- 
Jens Axboe

