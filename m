Return-Path: <linux-kernel-owner+w=401wt.eu-S1758258AbZDOINr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758258AbZDOINr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 04:13:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754680AbZDOINY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 04:13:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47754 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756856AbZDOINV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 04:13:21 -0400
Date: Wed, 15 Apr 2009 10:12:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Steven Rostedt <srostedt@redhat.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: TRACE_BRANCH_PROFILING breaks gcc warnings
Message-ID: <20090415081253.GE18192@elte.hu>
References: <1239748090.4205.26.camel@johannes.local> <1239748293.21121.60.camel@localhost.localdomain> <20090415073720.GC18192@elte.hu> <20090415074659.GA21764@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090415074659.GA21764@uranus.ravnborg.org>
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


* Sam Ravnborg <sam@ravnborg.org> wrote:

> > > This has been mentioned before, and I've asked about sending a 
> > > patch that would prevent TRACE_BRANCH_PROFILING from being 
> > > selected with an allyesconfig.
> > > 
> > > It is easy to do. I could make it a selection and not a 
> > > boolean and it will not select it as default, even for 
> > > allyes/modconfig
> 
> We should have a symbol that is only set for allyesconfig builds.
> 
> Then we could do something like:
> 
> config TRACE_BRANCH_PROFILING
> 	depends on !ALLYESCONFIG
> 
> The advantage is that it is obvious why we have defiend it like 
> this rather than some inverse symbols.
> 
> I looked at generating such symbol in kconfig long time ago but 
> never finished it.

ah, nice idea! Should be fairly simple to do, right?

The other option is to disable/remove the branch profiler 
altogether.

	Ingo
