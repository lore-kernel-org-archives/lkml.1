Return-Path: <linux-kernel-owner+w=401wt.eu-S1759936AbYDUMja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759936AbYDUMja (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 08:39:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756349AbYDUMjV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 08:39:21 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54126 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756251AbYDUMjU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 08:39:20 -0400
Date: Mon, 21 Apr 2008 14:39:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frans Pop <elendil@planet.nl>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [git pull] scheduler changes for v2.6.26
Message-ID: <20080421123903.GE9554@elte.hu>
References: <20080419181304.GB21353@elte.hu> <200804192147.43719.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804192147.43719.elendil@planet.nl>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0142]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frans Pop <elendil@planet.nl> wrote:

> Ingo Molnar wrote:
> > Ingo Molnar (12):
> >       sched: re-do "sched: fix fair sleepers"
> 
> Has the regression [1] that was traced to this change been fixed now?
> 
> The regression was confirmed to be also present in sched-devel.git at 
> the time of -rc8, so I'd expect it still to be valid unless of course 
> the cause was found since then.

Peter reported a similar interactivity problem to be gone, so lets 
re-try this again - the change makes sense and if you see problems it's 
hiding something we really want to fix. It would be nice if you could 
try sched-devel/latest because it has an improved ftrace "sched_switch" 
tracer where you can generate much longer traces of this incident. Try 
the new /debug/trace_entries runtime tunable.

	Ingo
