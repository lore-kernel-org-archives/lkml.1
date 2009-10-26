Return-Path: <linux-kernel-owner+w=401wt.eu-S1753992AbZJZNeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992AbZJZNeT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 09:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751243AbZJZNeT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 09:34:19 -0400
Received: from brick.kernel.dk ([93.163.65.50]:54890 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751023AbZJZNeS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 09:34:18 -0400
Date: Mon, 26 Oct 2009 14:34:22 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Corrado Zoccolo <czoccolo@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC 0/4] cfq: implement merging and breaking up of
	cfq_queues
Message-ID: <20091026133422.GF10727@kernel.dk>
References: <1256332492-24566-1-git-send-email-jmoyer@redhat.com> <4e5e476b0910241308s4a14fb69jbc6f8d35eb0ab78@mail.gmail.com> <x49ws2iz3gg.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49ws2iz3gg.fsf@segfault.boston.devel.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 26 2009, Jeff Moyer wrote:
> Corrado Zoccolo <czoccolo@gmail.com> writes:
> 
> > Hi Jeff,
> > this series looks good.
> 
> Hi, Corrado.  Thanks again for the review!
> 
> > I like in particular the fact that you move seekiness detection in the cfqq.
> > This can help with processes that issue sequential reads and seeky
> > writes, or vice versa.
> > Probably, also the think time could be made per-cfqq, so that the
> > decision whether we should idle for a given cfqq is more precise.
> 
> I'll have to think about that one.  It would be good to know Jens'
> opinion on the matter, too.

Your implementation looks fine, as usual I'm mostly worried about
performance impact and suitability (I hate having to work around
issues). But the win is so large in some cases that we should just go
ahead and merge it for .33, so I'll queue it up.

It would be nice to fix the in-kernel problem with NFS, since that is
doable.

-- 
Jens Axboe

