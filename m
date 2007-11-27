Return-Path: <linux-kernel-owner+w=401wt.eu-S1756857AbXK0LR2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756857AbXK0LR2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 06:17:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753693AbXK0LRV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 06:17:21 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35050 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753588AbXK0LRU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 06:17:20 -0500
Date: Tue, 27 Nov 2007 12:17:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: sched_yield: delete sysctl_sched_compat_yield
Message-ID: <20071127111707.GA18727@elte.hu>
References: <1196155985.25646.31.camel@ymzhang>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1196155985.25646.31.camel@ymzhang>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0357]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Zhang, Yanmin <yanmin_zhang@linux.intel.com> wrote:

> If echo "1">/proc/sys/kernel/sched_compat_yield before starting 
> volanoMark testing, the result is very good with kernel 2.6.24-rc3 on 
> my 16-core tigerton.

yep, that's known and has been discussed in detail on lkml. Java should 
use something more suitable than sched_yield for its locking. Yield will 
always be dependent on scheduling details and _some_ category of apps 
will always hurt. That's why we offer the sched_compat_yield flag.

	Ingo
