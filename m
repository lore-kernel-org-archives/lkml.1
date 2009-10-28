Return-Path: <linux-kernel-owner+w=401wt.eu-S932715AbZJ1I2v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932715AbZJ1I2v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 04:28:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932674AbZJ1I2v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 04:28:51 -0400
Received: from brick.kernel.dk ([93.163.65.50]:55517 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932669AbZJ1I2u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 04:28:50 -0400
Date: Wed, 28 Oct 2009 09:28:54 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: zach.brown@oracle.com, linux-aio <linux-aio@kvack.org>,
       Linux Kernel Mailing <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch v4 0/3] aio: implement request batching [more
	performance numbers]
Message-ID: <20091028082854.GU10727@kernel.dk>
References: <x49zl8976g3.fsf@segfault.boston.devel.redhat.com> <x49eipga02o.fsf@segfault.boston.devel.redhat.com> <20091006180628.GB5216@kernel.dk> <x49y6no8jxw.fsf@segfault.boston.devel.redhat.com> <20091007105259.GD8703@kernel.dk> <x49hbtk24o9.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49hbtk24o9.fsf@segfault.boston.devel.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 27 2009, Jeff Moyer wrote:
> Jens Axboe <jens.axboe@oracle.com> writes:
> 
> >> > Nice numbers! The patch looks good to me from a quick look, if you want
> >> > I can throw it into the testing mix tomorrow and see what kind of
> >> > improvements I see here. With performance increase of that magnitude, we
> >> > should get it in sooner rather than later.
> >> 
> > So here's a pretty basic test. It does random reads from a bunch of
> > devices, I tested both 4kb and 64kb block sizes. Queue depth used is 32
> > for both cases, but note that this test uses a thread per device (so the
> > queue depth is 32 per device). Results are averaged over 3 runs.
> > slat/clat are the submission and completion latencies, they are in
> > microseconds here.
> [...]
> > So pretty close, nothing earth shattering here. What the results above
> > do not show is that the 4kb test runs very stable with your patch.
> > Mainline fluctuates somewhat in the bandwidth, most likely due to the
> > varying depth.
> 
> OK, I don't think this patch set will see further testing without
> pulling it into someone's tree.  Jens, would you mind putting this into
> your for-2.6.33 queue?  Let me know if you need me to resend the
> patches.

Sure, I'll pull it in. I still have the patches, will ping you if it
doesn't apply cleanly.

-- 
Jens Axboe

