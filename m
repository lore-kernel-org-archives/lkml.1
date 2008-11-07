Return-Path: <linux-kernel-owner+w=401wt.eu-S1753461AbYKGOdw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461AbYKGOdw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 09:33:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751568AbYKGOdn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 09:33:43 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:46237 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751536AbYKGOdn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 09:33:43 -0500
Date: Fri, 7 Nov 2008 15:32:16 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][v3] blktrace: conversion to tracepoints
Message-ID: <20081107143215.GR21867@kernel.dk>
References: <20081029120556.GD28123@ghostprotocols.net> <20081029131855.GC31673@kernel.dk> <20081029194323.GA25056@ghostprotocols.net> <20081030073134.GM31673@kernel.dk> <491450E4.2080802@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <491450E4.2080802@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07 2008, Alan D. Brunelle wrote:
> 
> > 
> > I'll apply this for 2.6.29. I'm assuming you have tested this as well?
> > 
> 
> FYI: I tested this on a 16-way AMD x86_64 box (128GB RAM, a couple of
> Smart Array (CCISS) P800's). Running Jens' for-2.6.29 git tree versus a
> recent Linus 2.6.28-rc3 tree. I was doing kernel makes (10 passes for
> both kernels), and found that things worked just fine. All values below
> are in seconds:
> 
> 2.6.28-rc3:
> 
>     Part     Min     Avg     Max     Dev
> -------- ------- ------- ------- -------
>    untar  17.996  22.565  23.522   1.690
>   mk-cfg   3.279   3.454   3.529   0.070
>  mk-kern 140.837 141.557 142.549   0.626
> mk-clean  10.460  11.604  12.710   0.758
> -------- ------- ------- ------- -------
>    Combd 172.941 179.180 181.600   2.470
> ======== ======= ======= ======= =======
>    %sys   7.67%   7.78%   8.03%   0.114
> 
> 
> Jens' origin/for-2.6.29:
> 
>     Part     Min     Avg     Max     Dev
> -------- ------- ------- ------- -------
>    untar  18.138  22.576  24.279   1.693
>   mk-cfg   3.270   3.483   3.751   0.118
>  mk-kern 141.290 142.115 142.666   0.439
> mk-clean   8.263   9.609  10.211   0.624
> -------- ------- ------- ------- -------
>    Combd 173.736 177.783 179.654   1.786
> ======== ======= ======= ======= =======
>    %sys   7.77%   7.85%   8.01%   0.074
> 
> 
> Not sure why the 'make clean' portion of the runs went noticeably better
> with the newer code, but in any event, I don't see much difference
> elsewhere, and for sure the blktrace portion of things worked correctly.
> [blktrace + blkparse + blkrawverify + btt all worked just fine out of
> the box.]

Thanks a lot for running that test Alan, I think it looks fine!

-- 
Jens Axboe

