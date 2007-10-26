Return-Path: <linux-kernel-owner+w=401wt.eu-S1757527AbXJZLX0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757527AbXJZLX0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 07:23:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751085AbXJZLXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 07:23:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58752 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751255AbXJZLXS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 07:23:18 -0400
Date: Fri, 26 Oct 2007 13:23:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: aim7 -30% regression in 2.6.24-rc1
Message-ID: <20071026112307.GA30406@elte.hu>
References: <1193391787.3019.174.camel@ymzhang>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1193391787.3019.174.camel@ymzhang>
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


* Zhang, Yanmin <yanmin_zhang@linux.intel.com> wrote:

> I tested 2.6.24-rc1 on my x86_64 machine which has 2 quad-core processors.
> 
> Comparing with 2.6.23, aim7 has about -30% regression. I did a bisect 
> and found patch 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=b5869ce7f68b233ceb81465a7644be0d9a5f3dbb 
> caused the issue.

weird, that's a commit diff - i.e. it changes no code.

> kbuild/SPECjbb2000/SPECjbb2005 also has big regressions. On my another 
> tigerton machine (4 quad-core processors), SPECjbb2005 has more than 
> -40% regression. I didn't do a bisect on such benchmark testing, but I 
> suspect the root cause is like aim7's.

these two commits might be relevant:

  7a6c6bcee029a978f866511d6e41dbc7301fde4c
  95dbb421d12fdd9796ed153853daf3679809274f

but a bisection result would be the best info.

	Ingo
