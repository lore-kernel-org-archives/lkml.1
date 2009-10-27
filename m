Return-Path: <linux-kernel-owner+w=401wt.eu-S1755997AbZJ0QQ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997AbZJ0QQ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 12:16:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755979AbZJ0QQ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 12:16:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49368 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755977AbZJ0QQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 12:16:56 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: zach.brown@oracle.com, linux-aio <linux-aio@kvack.org>,
       Linux Kernel Mailing <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch v4 0/3] aio: implement request batching [more performance numbers]
References: <x49zl8976g3.fsf@segfault.boston.devel.redhat.com>
	<x49eipga02o.fsf@segfault.boston.devel.redhat.com>
	<20091006180628.GB5216@kernel.dk>
	<x49y6no8jxw.fsf@segfault.boston.devel.redhat.com>
	<20091007105259.GD8703@kernel.dk>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 27 Oct 2009 12:16:22 -0400
In-Reply-To: <20091007105259.GD8703@kernel.dk> (Jens Axboe's message of "Wed,
	7 Oct 2009 12:52:59 +0200")
Message-ID: <x49hbtk24o9.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <jens.axboe@oracle.com> writes:

>> > Nice numbers! The patch looks good to me from a quick look, if you want
>> > I can throw it into the testing mix tomorrow and see what kind of
>> > improvements I see here. With performance increase of that magnitude, we
>> > should get it in sooner rather than later.
>> 
> So here's a pretty basic test. It does random reads from a bunch of
> devices, I tested both 4kb and 64kb block sizes. Queue depth used is 32
> for both cases, but note that this test uses a thread per device (so the
> queue depth is 32 per device). Results are averaged over 3 runs.
> slat/clat are the submission and completion latencies, they are in
> microseconds here.
[...]
> So pretty close, nothing earth shattering here. What the results above
> do not show is that the 4kb test runs very stable with your patch.
> Mainline fluctuates somewhat in the bandwidth, most likely due to the
> varying depth.

OK, I don't think this patch set will see further testing without
pulling it into someone's tree.  Jens, would you mind putting this into
your for-2.6.33 queue?  Let me know if you need me to resend the
patches.

Cheers,
Jeff
