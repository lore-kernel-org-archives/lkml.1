Return-Path: <linux-kernel-owner+w=401wt.eu-S1756772AbXIEKvf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756772AbXIEKvf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 06:51:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755527AbXIEKv2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 06:51:28 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55341 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755454AbXIEKv1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 06:51:27 -0400
Date: Wed, 5 Sep 2007 12:51:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: Chuck Ebbert <cebbert@redhat.com>, nickpiggin@yahoo.com.au,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [patch] sched: fix broken smt/mc optimizations with CFS
Message-ID: <20070905105115.GB29959@elte.hu>
References: <20070816010150.GG10033@linux-os.sc.intel.com> <20070823115416.GA31027@elte.hu> <20070823121341.GA5775@elte.hu> <20070827191905.GE1894@linux-os.sc.intel.com> <20070827192324.GA29441@elte.hu> <20070827193103.GF1894@linux-os.sc.intel.com> <20070828222718.GI1894@linux-os.sc.intel.com> <46DDEBB9.3080501@redhat.com> <20070904234626.GB5187@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070904234626.GB5187@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.0.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1548]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Siddha, Suresh B <suresh.b.siddha@intel.com> wrote:

> > Seems this didn't get merged? Latest git as of today still has the code
> > as it was before this patch.
> 
> This is must fix for .23 and Ingo previously mentioned that he will push it
> for .23

yep, it's queued up and it will send it with the next batch. (this is 
the most important scheduler fix we have at the moment - there are 3 
other, smaller items queued up as well)

	Ingo
