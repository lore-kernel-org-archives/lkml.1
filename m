Return-Path: <linux-kernel-owner+w=401wt.eu-S1754754AbZCHVFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754AbZCHVFs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 17:05:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754174AbZCHVFj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 17:05:39 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54484 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753953AbZCHVFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 17:05:38 -0400
Date: Sun, 8 Mar 2009 22:05:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@redhat.com, jaswinder@kernel.org, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] x86: perf_counter cleanup
Message-ID: <20090308210521.GA17491@elte.hu>
References: <tip-e255357764f92afcafafbd4879b222b8c752065a@git.kernel.org> <1236545948.22914.3648.camel@twins> <49B432A4.7010807@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49B432A4.7010807@zytor.com>
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


* H. Peter Anvin <hpa@zytor.com> wrote:

> Peter Zijlstra wrote:
> > On Sun, 2009-03-08 at 15:52 +0000, Jaswinder Singh Rajput wrote:
> >> Commit-ID:  e255357764f92afcafafbd4879b222b8c752065a
> >> Gitweb:     http://git.kernel.org/tip/e255357764f92afcafafbd4879b222b8c752065a
> >> Author:     "Jaswinder Singh Rajput" <jaswinder@kernel.org>
> >> AuthorDate: Sun, 8 Mar 2009 17:09:49 +0530
> >> Commit:     Ingo Molnar <mingo@elte.hu>
> >> CommitDate: Sun, 8 Mar 2009 16:26:50 +0100
> >>
> >> x86: perf_counter cleanup
> >>
> >> Remove unused variables and duplicate header file.
> > 
> > Why did you commit this?
> > 
> > Until someone from AMD steps up and either tells us they're 
> > going to be 48bits _ALWAYS_ or that it's impossible to 
> > detect dynamically, I'd rather try and get the dynamic thing 
> > working.
> 
> That would be good, but there really is absolutely no reason 
> to leave in variables which are unused in the current code and 
> therefore give a gcc warning.  It's not like adding new 
> declaration is hard.

yeah. Adding a TODO there might be worth doing though.

	Ingo
