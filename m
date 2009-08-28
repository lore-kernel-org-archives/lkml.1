Return-Path: <linux-kernel-owner+w=401wt.eu-S1751908AbZH1Fvs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908AbZH1Fvs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 01:51:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751824AbZH1Fvs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 01:51:48 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56212 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751821AbZH1Fvr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 01:51:47 -0400
Date: Fri, 28 Aug 2009 07:51:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 1/2] perf tools: Import trace saved cmdlines to threads
	base
Message-ID: <20090828055132.GA22240@elte.hu>
References: <1251427567-10551-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1251427567-10551-1-git-send-email-fweisbec@gmail.com>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Currently, perf has its own base of threads objects that resolve a 
> pid to a thread.
>
> This tables is built by the PERF_EVENT_COMM events.
> 
> But ftrace events may need more than this table: they sometimes 
> require to store task comms that are not profiled by perf.

What would be examples of such? Shouldnt we extend their tracing 
accordingly, so that we have all the comms we are interested in?

	Ingo
