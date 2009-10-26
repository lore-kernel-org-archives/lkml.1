Return-Path: <linux-kernel-owner+w=401wt.eu-S1752446AbZJZPBr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752446AbZJZPBr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 11:01:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751939AbZJZPBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 11:01:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35784 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751857AbZJZPBq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 11:01:46 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Corrado Zoccolo <czoccolo@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC 0/4] cfq: implement merging and breaking up of cfq_queues
References: <1256332492-24566-1-git-send-email-jmoyer@redhat.com>
	<4e5e476b0910241308s4a14fb69jbc6f8d35eb0ab78@mail.gmail.com>
	<x49ws2iz3gg.fsf@segfault.boston.devel.redhat.com>
	<20091026133422.GF10727@kernel.dk>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 26 Oct 2009 11:01:39 -0400
In-Reply-To: <20091026133422.GF10727@kernel.dk> (Jens Axboe's message of "Mon,
	26 Oct 2009 14:34:22 +0100")
Message-ID: <x49aazeyzak.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <jens.axboe@oracle.com> writes:

> On Mon, Oct 26 2009, Jeff Moyer wrote:
>> Corrado Zoccolo <czoccolo@gmail.com> writes:
>> 
>> > Hi Jeff,
>> > this series looks good.
>> 
>> Hi, Corrado.  Thanks again for the review!
>> 
>> > I like in particular the fact that you move seekiness detection in the cfqq.
>> > This can help with processes that issue sequential reads and seeky
>> > writes, or vice versa.
>> > Probably, also the think time could be made per-cfqq, so that the
>> > decision whether we should idle for a given cfqq is more precise.
>> 
>> I'll have to think about that one.  It would be good to know Jens'
>> opinion on the matter, too.
>
> Your implementation looks fine, as usual I'm mostly worried about
> performance impact and suitability (I hate having to work around
> issues). But the win is so large in some cases that we should just go
> ahead and merge it for .33, so I'll queue it up.

Great, thanks for the review.  In this case, however, I was wondering
what your opinion was about moving the think time calculation to be per
cfqq.  ;-)

> It would be nice to fix the in-kernel problem with NFS, since that is
> doable.

I'll see if I can get someone motivated to work on that.  I'm not sure
that I can devote much time to the issue myself, unfortunately.

Cheers,
Jeff
