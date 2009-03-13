Return-Path: <linux-kernel-owner+w=401wt.eu-S1757591AbZCMA6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757591AbZCMA6S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 20:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755274AbZCMA6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 20:58:06 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41125 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754981AbZCMA6F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 20:58:05 -0400
Date: Fri, 13 Mar 2009 01:57:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, Mike Travis <travis@sgi.com>
Subject: Re: [PULL] x86 cpumask work
Message-ID: <20090313005743.GE19544@elte.hu>
References: <200903121453.45163.rusty@rustcorp.com.au> <20090312102645.GA25792@elte.hu> <20090312103733.GA29585@elte.hu> <200903130924.48885.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903130924.48885.rusty@rustcorp.com.au>
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

> On Thursday 12 March 2009 21:07:33 Ingo Molnar wrote:
> > 
> > * Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > * Rusty Russell <rusty@rustcorp.com.au> wrote:
> > > 
> > > > Phew.  One core patch (the first one), the rest x86-specific.
> > 
> > hm, how much testing did this tree get? It crashes fast and hard 
> > in -tip testing:
> 
> Missing a core patch (it even got a compile warning with that 
> config).

Unfortunately i cannot (yet) escallate compile warnings into 
build failures automatically due to still-widespread upstream 
ignorance wrt. how to treat the problem of compiler warnings.

People have allowed the kernel to become a panopticum of weird 
bogus GCC warnings and use that cloaka of hall of shame of 
dozens of false positive warnings as an excuse to not annotate 
warnings. Doing that ignores the thousands and thousands of 
correct warnings that were seen and where code got fixed for 
good - where the compiler saved us from worse.
 
This stupid, self-defeating behavior of intentionally letting 
false-positive compiler warnings around has been going on for a 
decade. It adds an avoidable constant to the cost of Linux 
development (like here) and it takes time to unwind.

So it's manual work and sometimes i notice them amongst a 
boatload of other warnings, sometimes i dont.

> But there's something else wrong.  Firing up my 64-bit test 
> box now.

Great - so you can reproduce. Thanks,

	Ingo
