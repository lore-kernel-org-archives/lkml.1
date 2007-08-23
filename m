Return-Path: <linux-kernel-owner+w=401wt.eu-S1761347AbXHWKi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761347AbXHWKi4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 06:38:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759272AbXHWKiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 06:38:46 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43598 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758815AbXHWKin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 06:38:43 -0400
Date: Thu, 23 Aug 2007 12:38:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: nickpiggin@yahoo.com.au, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [patch] sched: fix broken smt/mc optimizations with CFS
Message-ID: <20070823103835.GA10435@elte.hu>
References: <20070816010150.GG10033@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070816010150.GG10033@linux-os.sc.intel.com>
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


* Siddha, Suresh B <suresh.b.siddha@intel.com> wrote:

> Ingo, let me know if there any side effects of this change. Thanks.
> ---
> 
> On a four package system with HT - HT load balancing optimizations 
> were broken. For example, if two tasks end up running on two logical 
> threads of one of the packages, scheduler is not able to pull one of 
> the tasks to a completely idle package.

thanks, i've applied your fix to my queue.

	Ingo
