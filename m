Return-Path: <linux-kernel-owner+w=401wt.eu-S1757745AbZJLSiZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757745AbZJLSiZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 14:38:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757731AbZJLSiZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 14:38:25 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41216 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757728AbZJLSiY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 14:38:24 -0400
Date: Mon, 12 Oct 2009 20:37:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Thomas Gleixner <tglx@linutronix.de>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [patch 0/4] DEBUG_RCU_HEAD: Debug and fix racy call_rcu() users
Message-ID: <20091012183725.GI17138@elte.hu>
References: <20091006143727.868480435@polymtl.ca> <20091012180739.GE17138@elte.hu> <20091012183007.GA12445@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091012183007.GA12445@Krystal>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> * Ingo Molnar (mingo@elte.hu) wrote:
> > 
> > * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> > 
> > > Here is a patchset, done on 2.6.30.9, which permits to detect and fix 
> > > racy call_rcu() users.
> > 
> > Nice idea - but any reason why this isnt using the debugojects 
> > framework? That debugging framework is upstream already and allows this 
> > kind of object lifetime debugging - in a much broader way.
> > 
> 
> Other than: it did not occur to me, no, there is no reason for not using
> debugobjects there. :-)
> 
> As long as we can tag the object as
> - initialized
> - active
> - inactive
> 
> And dump a nice fat warning when the object is activated twice, that
> should suffice. Now time is a bit short on my side, but I'll keep in
> mind to respin a version on top of debugobjects soon.

ok, thanks.

Commit to check would be:

  237fc6e: add hrtimer specific debugobjects code
  c6f3a97: debugobjects: add timer specific object debugging code

	Ingo
