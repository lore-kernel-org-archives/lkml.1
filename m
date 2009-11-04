Return-Path: <linux-kernel-owner+w=401wt.eu-S1751892AbZKDHvt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751892AbZKDHvt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 02:51:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751486AbZKDHvs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 02:51:48 -0500
Received: from [95.166.99.235] ([95.166.99.235]:39138 "EHLO kernel.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751039AbZKDHvr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 02:51:47 -0500
Date: Wed, 4 Nov 2009 08:51:52 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Corrado Zoccolo <czoccolo@gmail.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Fwd: [PATCH 0/5] cfq-iosched: improve latency for no-idle
	queues (v3)
Message-ID: <20091104075152.GX8742@kernel.dk>
References: <x493a4wsn5c.fsf@segfault.boston.devel.redhat.com> <x49fx8wbqd0.fsf@segfault.boston.devel.redhat.com> <4e5e476b0911030042q5963718aj5875c542e6f6cc40@mail.gmail.com> <x49ocnju35d.fsf@segfault.boston.devel.redhat.com> <4e5e476b0911030719m425c208cg311f44a91fad8342@mail.gmail.com> <4e5e476b0911031035l7caffcb7n36b6eddd399864e7@mail.gmail.com> <20091103201802.GL8742@kernel.dk> <x49ocnjqrs5.fsf@segfault.boston.devel.redhat.com> <20091103202836.GM8742@kernel.dk> <x49aaz3i807.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49aaz3i807.fsf@segfault.boston.devel.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 03 2009, Jeff Moyer wrote:
> Jens Axboe <jens.axboe@oracle.com> writes:
> 
> > On Tue, Nov 03 2009, Jeff Moyer wrote:
> >> Jens Axboe <jens.axboe@oracle.com> writes:
> >> 
> >> > Since for-linus contains conflicting changes, can you and Jeff please
> >> > double check that everything is still in order? The interesting bit here
> >> > is the merge with for-2.6.33 and the coop limit from Shaohua Li. I did
> >> > the straight forward merge, but we likely just need to drop that logic
> >> > since the coop concept is radically different given that we merge and
> >> > break queues in for-2.6.33.
> >> 
> >> Yeah, since I changed the meaning of the cfqq_coop flag, a lot of those
> >> tests are just plain wrong.  Let me play with it and I'll send you an
> >> incremental patch in a bit.
> >
> > Thanks, here's what I have. It's basically a revert of the commit in
> > question.
> 
> Your patch looks like a straight-forward revert.  I still think we need
> some guards in place, though.  For now, I think we can go with what you
> have, and I'll come up with some other mechanism to deal with this case.

Thanks Jeff, I'll merge it up and we can get things straightened out in
due time.

-- 
Jens Axboe

