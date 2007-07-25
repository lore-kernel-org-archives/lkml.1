Return-Path: <linux-kernel-owner+w=401wt.eu-S1762150AbXGYI2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762150AbXGYI2u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 04:28:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753263AbXGYI2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 04:28:41 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59227 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753042AbXGYI2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 04:28:40 -0400
Date: Wed, 25 Jul 2007 10:28:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Rene Herman <rene.herman@gmail.com>
Cc: Valdis.Kletnieks@vt.edu, david@lang.hm,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ray Lee <ray-lk@madrabbit.org>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, ck list <ck@vds.kolivas.org>,
       Paul Jackson <pj@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: -mm merge plans for 2.6.23
Message-ID: <20070725082822.GA13098@elte.hu>
References: <46A57068.3070701@yahoo.com.au> <2c0942db0707232153j3670ef31kae3907dff1a24cb7@mail.gmail.com> <46A58B49.3050508@yahoo.com.au> <2c0942db0707240915h56e007e3l9110e24a065f2e73@mail.gmail.com> <46A6CC56.6040307@yahoo.com.au> <46A6D7D2.4050708@gmail.com> <Pine.LNX.4.64.0707242211210.2229@asgard.lang.hm> <46A6DFFD.9030202@gmail.com> <30701.1185347660@turing-police.cc.vt.edu> <46A7074B.50608@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46A7074B.50608@gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Rene Herman <rene.herman@gmail.com> wrote:

> Regardless, I'll stand by "[by disabling updatedb] the problem will 
> for a large part be solved" as I expect approximately 94.372 percent 
> of Linux desktop users couldn't care less about locate.

i think that approach is illogical: because Linux mis-handled a mixed 
workload the answer is to ... remove a portion of that workload?

To bring your approach to the extreme: what if Linux sucked at running 
more than two CPU-intense tasks at once. Most desktop users dont do 
that, so a probably larger than 94.372 percent of Linux desktop users 
couldn't care less about a proper scheduler. Still, anyone who builds a 
kernel (the average desktop user wont do that) while using firefox will 
attest to the fact that it's quite handy that the Linux scheduler can 
handle mixed workloads pretty well.

now, it might be the case that this mixed VM/VFS workload cannot be 
handled any more intelligently - but that wasnt your argument! The 
swap-prefetch patch certainly tried to do things more intelligently and 
the test-case (measurement app) Con provided showed visible improvements 
in swap-in latency. (and a good number of people posted those results)

	Ingo
