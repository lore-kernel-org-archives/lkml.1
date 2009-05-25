Return-Path: <linux-kernel-owner+w=401wt.eu-S1754463AbZEYIGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754463AbZEYIGk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 04:06:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752196AbZEYIGY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 04:06:24 -0400
Received: from brick.kernel.dk ([93.163.65.50]:50529 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752023AbZEYIGY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 04:06:24 -0400
Date: Mon, 25 May 2009 10:06:25 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chris.mason@oracle.com,
       david@fromorbit.com, hch@infradead.org, akpm@linux-foundation.org
Subject: Re: [PATCH 0/11] Per-bdi writeback flusher threads #4
Message-ID: <20090525080625.GM11363@kernel.dk>
References: <1242811142.2560.33.camel@ymzhang> <20090520092528.GP11363@kernel.dk> <20090520111910.GS11363@kernel.dk> <1242887627.2560.45.camel@ymzhang> <20090521091033.GA6987@duck.suse.cz> <1242955708.2560.52.camel@ymzhang> <20090522081539.GM11363@kernel.dk> <20090522204401.GQ11363@kernel.dk> <20090523191500.GV11363@kernel.dk> <1243238558.2560.99.camel@ymzhang>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1243238558.2560.99.camel@ymzhang>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 25 2009, Zhang, Yanmin wrote:
> On Sat, 2009-05-23 at 21:15 +0200, Jens Axboe wrote:
> > On Fri, May 22 2009, Jens Axboe wrote:
> > > Please try with this combined patch against what you are running now, it
> > > should resolve the issue. It needs a bit more work, but I'm running out
> > > of time today. I'l get it finalized, cleaned up, and integrated. Then
> > > I'll post a new revision of the patch set.
> > > 
> > 
> > This one has been tested good and has a few more tweaks. So please try
> > that! It should be pretty close to final now, will repost the series on
> > monday.
> I ran the workload for 10 times and didn't trigger it yet. So the bug is
> fixed.

Goodness, thanks for retesting. Can you share some performance
comparisons and what hw/storage you are running it on?

The v5/v6 posting includes these fixes, so it should work fine now.

-- 
Jens Axboe

