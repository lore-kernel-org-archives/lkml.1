Return-Path: <linux-kernel-owner+w=401wt.eu-S933501AbXIBKCz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933501AbXIBKCz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 06:02:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755897AbXIBKCs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 06:02:48 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57851 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755734AbXIBKCr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 06:02:47 -0400
Date: Sun, 2 Sep 2007 12:02:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Track accurate idle time with tick_sched.idle_sleeptime
Message-ID: <20070902100215.GB26138@elte.hu>
References: <20070827215611.GA30396@linux-os.sc.intel.com> <p73bqcmvxc6.fsf@bingen.suse.de> <20070902072806.GC5075@elte.hu> <20070902074622.GA16045@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070902074622.GA16045@one.firstfloor.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.0.3
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.2639]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> > at least the current out-of-idle code already does what amounts to a 
> > PM-timer read when exiting from C2 or C3 mode. The
> 
> C2/C3 are already slow. I more worry about C1.

C2/C3 are only slow in older CPUs - and they are getting faster and 
faster. (also, newer systems do less of C1, due to increased energy 
awareness.)

would be nice to measure the overhead/impact i suspect.

	Ingo
