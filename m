Return-Path: <linux-kernel-owner+w=401wt.eu-S1754788AbYI0TUv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788AbYI0TUv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 15:20:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753758AbYI0TUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 15:20:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58585 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753744AbYI0TUk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 15:20:40 -0400
Date: Sat, 27 Sep 2008 21:20:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Steven Noonan <steven@uplinklabs.net>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       Luis Rodriguez <Luis.Rodriguez@atheros.com>,
       "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [ath9k-devel] ath9k: massive unexplained latency in 2.6.27
	(rc5, rc6, probably others)
Message-ID: <20080927192019.GE18619@elte.hu>
References: <43e72e890809181508w5232a14ewbf2bf18fe90a92d5@mail.gmail.com> <f488382f0809181604l105535bkceecd44c590bc88b@mail.gmail.com> <43e72e890809181610h3a7729d8s4c8484d97b21932e@mail.gmail.com> <f488382f0809181952g628ab5a4nd86f396a08f4d6c8@mail.gmail.com> <20080919030125.GG7408@tesla> <f488382f0809190029n13b87ad1s153e5b983f301f31@mail.gmail.com> <20080919081733.GC19491@elte.hu> <f488382f0809190122k1b30cd9q22fd076c1e3eaa18@mail.gmail.com> <20080919083208.GA15730@elte.hu> <alpine.DEB.1.10.0809262117590.29360@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0809262117590.29360@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> I hate trips where my email box becomes filled. I skip over a lot of 
> emails that I should not have.
> 
> On Fri, 19 Sep 2008, Ingo Molnar wrote:
> > 
> > What is needed is to set kernel/trace/trace.c's tracing_disabled 
> > variable to 0. I've Cc:-ed Steve Rostedt - Steve, why is there no easy 
> > ad-hoc way to trigger a stop-tracing event without elaborate changes?
> 
> I think I added a way to do this. Hmm, I think it was in -rt that I added 
> it, and have not gotten around to sending you the updates.
> 
> Yes, we need an easy way to disable the tracer. I think we have 
> ftrace_disable() function. Perhaps that only disables tracing that 
> checks the tracing_disabled variable.

we have kill_ftrace(), but that will permanently zap it.

	Ingo
