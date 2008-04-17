Return-Path: <linux-kernel-owner+w=401wt.eu-S1764833AbYDQL4t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764833AbYDQL4t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 07:56:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752774AbYDQL4j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 07:56:39 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39921 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752772AbYDQL4i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 07:56:38 -0400
Date: Thu, 17 Apr 2008 13:56:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [v2.6.26] what's brewing in x86.git for v2.6.26
Message-ID: <20080417115623.GA16337@elte.hu>
References: <20080416202338.GA6007@elte.hu> <20080417002552.5742ad65.akpm@linux-foundation.org> <84144f020804170045s24cbb802u3358ec6b5d391a10@mail.gmail.com> <20080417012051.ed56f4ab.akpm@linux-foundation.org> <Pine.LNX.4.64.0804171130090.4929@sbz-30.cs.Helsinki.FI> <84144f020804170134k4c98f022xc247442592fb1a44@mail.gmail.com> <20080417014217.ab0453a9.akpm@linux-foundation.org> <20080417114900.GA17033@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080417114900.GA17033@infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Christoph Hellwig <hch@infradead.org> wrote:

> On Thu, Apr 17, 2008 at 01:42:17AM -0700, Andrew Morton wrote:
> > Apparently that code is not being proposed for merge and it all got
> > reimplemented and moved elsewhere.  I knew nothing of this.
> 
> It's not just you, I haven't heard anythinh either :) I'm also still 
> not comfortable with adding another quick-hacker interface instead of 
> making sure the existing one doesn't suck.

it's all in debugfs so no stable interface worries. Not much has changed 
since we last posted it to lkml. Posting the full patchset is 
impractical as it's in excess of 100 commits (but we did post various 
versions of it) - you can pick up the latest from:

   http://people.redhat.com/mingo/sched-devel.git/README

check out kernel/trace/. Usage: check out 
/sys/kernel/debug/tracing/README :-)

	Ingo
