Return-Path: <linux-kernel-owner+w=401wt.eu-S1753012AbZBSLHJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753012AbZBSLHJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 06:07:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755483AbZBSLGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 06:06:54 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47111 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751626AbZBSLGy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 06:06:54 -0500
Date: Thu, 19 Feb 2009 12:06:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Tejun Heo <tj@kernel.org>, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, jeremy@goop.org,
       cpw@sgi.com
Subject: Re: [PATCHSET x86/core/percpu] implement dynamic percpu allocator
Message-ID: <20090219110631.GJ2354@elte.hu>
References: <1234958676-27618-1-git-send-email-tj@kernel.org> <20090218134331.GC1300@elte.hu> <200902192121.55157.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902192121.55157.rusty@rustcorp.com.au>
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


* Rusty Russell <rusty@rustcorp.com.au> wrote:

> On Thursday 19 February 2009 00:13:31 Ingo Molnar wrote:
> > 
> > * Tejun Heo <tj@kernel.org> wrote:
> > 
> > >   0001-vmalloc-call-flush_cache_vunmap-from-unmap_kernel.patch
> > >   0002-module-fix-out-of-range-memory-access.patch
> > 
> > Hm, these two seem to be .29 material too, agreed?
> > 
> > Rusty, if the fixes are fine with you i can put those two 
> > commits into tip/core/urgent straight away, the full string of 
> > 10 commits into tip/core/percpu and thus we'd avoid duplicate 
> > (or even conflicting) commits.
> 
> No, the second one is not .29 material; it's a nice, but 
> theoretical, fix.

Can it never trigger?

	Ingo
