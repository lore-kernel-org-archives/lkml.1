Return-Path: <linux-kernel-owner+w=401wt.eu-S1755947AbYJJJep@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947AbYJJJep (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 05:34:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751844AbYJJJeh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 05:34:37 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54900 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751554AbYJJJeg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 05:34:36 -0400
Date: Fri, 10 Oct 2008 11:34:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Tracepoints synchronize unregister static inline
Message-ID: <20081010093413.GA13996@elte.hu>
References: <20081003190133.GA12685@Krystal> <20081004124538.GF3728@elte.hu> <20081006143300.GB1366@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081006143300.GB1366@Krystal>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1632]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> * Ingo Molnar (mingo@elte.hu) wrote:
> > 
> > * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> > 
> > > Ingo, could you pull the following patch into -tip ?
> > 
> > sure - but it does not apply to tip/master. Some missing dependencies?
> > 
> > 	Ingo
> 
> Hi Ingo,
> 
> "Tracepoints synchronize unregister static inline"
> applies on top of
> "Tracepoints : tracepoint_synchronize_unregister()"
> 
> I posted earlier but does not seem to be in tip/master. Here is a repost
> :
> 
> Tracepoints : tracepoint_synchronize_unregister()

picked them up into tip/tracing/tracepoints:

1c38db9: tracepoints: synchronize unregister static inline
99067e3: tracepoints: tracepoint_synchronize_unregister()

thanks Mathieu!

	Ingo
