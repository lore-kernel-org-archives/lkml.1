Return-Path: <linux-kernel-owner+w=401wt.eu-S1761615AbYF3NJF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761615AbYF3NJF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 09:09:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756940AbYF3NIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 09:08:47 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49319 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756337AbYF3NIq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 09:08:46 -0400
Date: Mon, 30 Jun 2008 15:08:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Johannes Weiner <hannes@saeurebad.de>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 3/3] softlockup: fix watchdog task wakeup frequency
Message-ID: <20080630130837.GA332@elte.hu>
References: <20080627000445.346130358@saeurebad.de> <20080627000805.504878592@saeurebad.de> <20080627120350.GB30872@elte.hu> <87prq3xdjv.fsf@skyscraper.fehenstaub.lan> <20080627124329.GA14576@elte.hu> <87d4m3xbzq.fsf@skyscraper.fehenstaub.lan> <87od5ms7yh.fsf@skyscraper.fehenstaub.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87od5ms7yh.fsf@skyscraper.fehenstaub.lan>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Johannes Weiner <hannes@saeurebad.de> wrote:

> > +	/*
> > +	 * Wake up the high-prio watchdog task twice per
> > +	 * threshold timespan.
> > +	 */
> > +	if (now > touch_timestamp + softlockup_thresh/2)
> >  		wake_up_process(per_cpu(watchdog_task, this_cpu));
> 
> That defeats patch 1/3 and I think it can be dropped (#1).

applied this updated patch to tip/core/softlockup. #3 didnt apply - 
could you send a delta patch against tip/core/softlockup please? You can 
pick it up via:

  http://people.redhat.com/mingo/tip.git/README

do:

  git-checkout -b core/softlockup tip/core/softlockup

to check it out.

	Ingo
