Return-Path: <linux-kernel-owner+w=401wt.eu-S1759377AbYEPSdN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759377AbYEPSdN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 14:33:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755517AbYEPSc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 14:32:58 -0400
Received: from smtp2.sssup.it ([193.205.80.100]:52521 "EHLO smtp2.sssup.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753688AbYEPSc6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 14:32:58 -0400
Date: Fri, 16 May 2008 20:39:07 +0200
From: Fabio Checconi <fchecconi@gmail.com>
To: Matthew <jackdachef@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Daniel J Blueman <daniel.blueman@gmail.com>,
       Kasper Sandberg <lkml@metanurb.dk>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: performance "regression" in cfq compared to anticipatory, deadline and noop
Message-ID: <20080516183907.GB21073@gandalf.sssup.it>
References: <e85b9d30805141437u6a4b4caby1712c6f04bd4cc05@mail.gmail.com> <20080515070127.GH16217@kernel.dk> <20080515122156.GA11600@gandalf.sssup.it> <20080516064002.GL16217@kernel.dk> <20080516074628.GA17802@gandalf.sssup.it> <20080516074913.GW16217@kernel.dk> <20080516075715.GX16217@kernel.dk> <6278d2220805160153s280d304di37b3bb62d770b81@mail.gmail.com> <20080516085738.GY16217@kernel.dk> <e85b9d30805160823xa00f3fanb90616bdce10fc5d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e85b9d30805160823xa00f3fanb90616bdce10fc5d@mail.gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Matthew <jackdachef@gmail.com>
> Date: Fri, May 16, 2008 05:23:12PM +0200
>
...
> thanks for the 2 patches, please keep them coming :)
> 
> a short report (due to the time shortage):
> 
> I tested both patches this morning and got for both (still) around
> 52-58 MB/s (/dev/sdd & /dev/sde)
> 
> thanks & have a nice weekend :)

Maybe I've missed it but I cannot find the blktrace output for your
original test and for the test with the first patch posted by Jens
in this thread (the one completely removing the blk_start_queueing()
call), may I ask you if you can point me to them?

>From what I understood that patch didn't solve your issue, so the
following ones, that adopt a similar approach, are unlikely to do
any better.

Thank you in advance.
