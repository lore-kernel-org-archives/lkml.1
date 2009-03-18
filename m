Return-Path: <linux-kernel-owner+w=401wt.eu-S1756118AbZCRJTL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756118AbZCRJTL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 05:19:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752924AbZCRJS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 05:18:56 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53231 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752282AbZCRJS4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 05:18:56 -0400
Date: Wed, 18 Mar 2009 10:18:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/ftrace: stop {irqs,preempt}soff tracers when
	tracing is stopped
Message-ID: <20090318091842.GA29053@elte.hu>
References: <1237325938-5240-1-git-send-email-fweisbec@gmail.com> <alpine.DEB.2.00.0903171745440.9036@gandalf.stny.rr.com> <20090317214926.GA5137@nowhere> <alpine.DEB.2.00.0903171757320.9036@gandalf.stny.rr.com> <20090317225454.GA5143@nowhere> <20090318085957.GB15416@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090318085957.GB15416@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> > I discussed about that with Steven on irc, and for now the v1 
> > should be applied as a temporary solution. We plan to simplify 
> > later the start/stop callbacks from each tracers that need it.
> 
> ok. Steve, could you please pick v1 up?

Committed it after all - there's more self-test failures (reported 
them earlier today) and i've picked up all fixlets that might fix 
them.

	Ingo
