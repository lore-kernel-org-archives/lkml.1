Return-Path: <linux-kernel-owner+w=401wt.eu-S1758957AbXITHSX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758957AbXITHSX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 03:18:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753258AbXITHSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 03:18:15 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37585 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752365AbXITHSO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 03:18:14 -0400
Date: Thu, 20 Sep 2007 09:17:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched: fix to use invalid sched_class
Message-ID: <20070920071730.GB29903@elte.hu>
References: <1190239539.19576.5.camel@earth> <46F1B872.1050307@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46F1B872.1050307@ct.jp.nec.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:

> Dmitry Adamushko wrote:
> >>> Hi Ingo,
> >>>
> >>> I found an issue about the scheduler.
> >>> If you need a test case, please let me know.
> >>> Here is a patch.
> >>> [ ... ]
> >>> The new thread should be valid scheduler class before queuing.
> >>> This patch fixes to set the suitable scheduler class.
> >> Nice fix! It's a 2.6.23 must-have fix - i'll push it out into the 
> >> scheduler tree. Thanks!
> > 
> > I think, the following approach would be a bit more appropriate
> > (the missing addition to the already existing "don't leak PI boosting prio"):
> > 
> > (not tested)
> > 
> Thank you for reviewing my patch.
> Yes, your approach looks better than mine.
> I've tested it and it looks working fine in my test case.
> I attached the test case.
> 
> Will you write a patch to replace mine?

thanks for testing it - we can queue Dmitry's clean-up for v2.6.24 
(please send me a patch for v2.6.23-rc7). The most important step was to 
get your fix into v2.6.23.

	Ingo

