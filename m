Return-Path: <linux-kernel-owner+w=401wt.eu-S1759947AbXJLFqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759947AbXJLFqg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 01:46:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758165AbXJLFq1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 01:46:27 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51249 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755553AbXJLFq0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 01:46:26 -0400
Date: Fri, 12 Oct 2007 07:46:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Nicholas Miell <nmiell@comcast.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.23
Message-ID: <20071012054615.GA22256@elte.hu>
References: <alpine.LFD.0.999.0710091346490.5039@woody.linux-foundation.org> <1191996740.8694.7.camel@entropy> <20071010101452.GA25433@elte.hu> <200710111916.23633.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710111916.23633.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0011]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> ;) I think you snipped the important bit:
> 
> "the peak is terrible but it has virtually no dropoff and performs 
> better under load than the default 2.6.21 scheduler." (verbatim)

hm, i understood that peak remark to be in reference to FreeBSD's 
scheduler (which the FreeBSD guys are primarily interested in 
obviously), not v2.6.21 - but i could be wrong.

In any case, there is indeed a regression with sysbench and a low number 
of threads, and it's being fixed. The peak got improved visibly in 
sched-devel:

  http://people.redhat.com/mingo/misc/sysbench-sched-devel.jpg

but there is still some peak regression left, i'm testing a patch for 
that.

	Ingo
