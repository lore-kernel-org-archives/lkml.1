Return-Path: <linux-kernel-owner+w=401wt.eu-S1761033AbXEUJhB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761033AbXEUJhB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 05:37:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755727AbXEUJgz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 05:36:55 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42190 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755224AbXEUJgy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 05:36:54 -0400
Date: Mon, 21 May 2007 11:36:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Bill Huey <billh@gnuppy.monkey.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Jason Baron <jbaron@redhat.com>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] lockdep: lock contention tracking
Message-ID: <20070521093639.GA29025@elte.hu>
References: <1179657026.5915.10.camel@lappy> <20070521060446.GA4593@gnuppy.monkey.org> <20070521060828.GB20277@elte.hu> <20070521064150.GC4442@gnuppy.monkey.org> <20070521075013.GA9419@elte.hu> <20070521091848.GB4593@gnuppy.monkey.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070521091848.GB4593@gnuppy.monkey.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Bill Huey <billh@gnuppy.monkey.org> wrote:

> I write lockstat without the knowledge that lockdep was replicating 
> the same work and I audited 1600 something lock points in the kernel 
> to convert the usage of C99 style initializers to something more 
> regular.

you got the history wrong i think: the first version of lockdep was 
released to lkml a year ago (May 2006), while the first time you 
mentioned your lock contention patch was November 2006 and you released 
it to lkml in December 2006 - so it was _you_ who was "replicating the 
same work", not lockdep :-) And this was pointed out to you very early 
on, many months ago.

and regarding C99 style lock initializers: the -rt project has been 
removing a whole heap of them in the past 2.5 years, since Oct 2004 or 
so, and regularly cleansed the upstream kernel for old-style 
initializers ever since then - so i'm not sure what you are referring 
to.

> I also did this without consideration of things like debuginfo since I 
> don't use those things.

btw., you dont even need CONFIG_DEBUG_INFO to get usable symbol names, 
CONFIG_KALLSYMS alone will do it too. (It's only if you really cannot 
tell from the lock symbol name and the function name what the entry is 
about - which is very rare - that you need to look at any debug-info)

	Ingo
