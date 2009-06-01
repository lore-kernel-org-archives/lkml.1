Return-Path: <linux-kernel-owner+w=401wt.eu-S1753890AbZFASn4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890AbZFASn4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 14:43:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751789AbZFASnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 14:43:49 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49477 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751595AbZFASnt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 14:43:49 -0400
Date: Mon, 1 Jun 2009 20:43:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, jkacur@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, mtosatti@redhat.com,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
Subject: Re: [tip:perfcounters/core] perf_counter: Tidy up style details
Message-ID: <20090601184333.GA18874@elte.hu>
References: <tip-22a4f650d686eeaac3629dae1c4294381485efdf@git.kernel.org> <200906012022.13351.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906012022.13351.elendil@planet.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Frans Pop <elendil@planet.nl> wrote:

> tip-bot for Ingo Molnar wrote:
> > @@ -3526,7 +3529,7 @@ inherit_counter(struct perf_counter *parent_counter,
> >	/*
> >	* Make the child state follow the state of the parent counter,
> >	* not its hw_event.disabled bit.  We hold the parent's mutex,
> > -	* so we won't race with perf_counter_{en,dis}able_family.
> > +	* so we won't race with perf_counter_{en, dis}able_family.
> > 	*/
> > 	if (parent_counter->state >= PERF_COUNTER_STATE_INACTIVE)
> > 	child_counter->state = PERF_COUNTER_STATE_INACTIVE;
> 
> I wouldn't call this an improvement TBH.

yeah.

	Ingo
