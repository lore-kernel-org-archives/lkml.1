Return-Path: <linux-kernel-owner+w=401wt.eu-S1752394AbZH1Lt7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752394AbZH1Lt7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 07:49:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752111AbZH1Lt6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 07:49:58 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40021 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751972AbZH1Lt5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 07:49:57 -0400
Date: Fri, 28 Aug 2009 13:49:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pierre Habouzit <pierre.habouzit@intersec.com>
Cc: Paul Mackerras <paulus@samba.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH v2] perf tools: do not complain if root is owning
	perf.data
Message-ID: <20090828114951.GA25148@elte.hu>
References: <1251291926-27174-1-git-send-email-pierre.habouzit@intersec.com> <20090826182459.GD13632@elte.hu> <20090827075902.GF19653@laphroaig.corp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090827075902.GF19653@laphroaig.corp>
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


* Pierre Habouzit <pierre.habouzit@intersec.com> wrote:

> This improves patch fa6963b24 so that perf.data stuff that has 
> been dumped as root can be read (annotate/report) by a user 
> without the use of the --force.
> 
> Rationale is that root has plenty of ways to screw us (usually) 
> that do not require twisted schemes involving specially crafting a 
> perf.data.
> 
> Signed-off-by: Pierre Habouzit <pierre.habouzit@intersec.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Paul Mackerras <paulus@samba.org>,
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
> Cc: <stable@kernel.org>
> ---
>     On Wed, Aug 26, 2009 at 08:24:59PM +0200, Ingo Molnar wrote:
>     > Ok, this makes sense - but i think we should do this in .32 only, 
>     > with a Cc: <stable@kernel.org> backport tag for .31.1.
> 
>     You're the boss ;)
> 
>     > Mind doing it against the latest perfcounters tree, which can be 
>     > found in -tip:
>     > 
>     >   http://people.redhat.com/mingo/tip.git/README
>     > 
>     > your current version does not apply cleanly as the surrounding code 
>     > has changed a bit already.
> 
>     Here it is, against perfcounters/core which I assume is the 
>     proper tip branch. [...]

Yeah, applied - thanks!

>     [...] Note that I'd suggest adding a README.Devel under 
>     tools/perf to explicit how patches should be submitted, at 
>     least to explain against which tree it's best to do our 
>     patches for submission, it could help people avoiding losing 
>     your time with unnecessary back-and-forth mails just to rebase 
>     a patch ;)

Agreed! Mind sending a patch for that, or adding a wiki page for 
that on perf.wiki.kernel.org? We could then add a link to that to 
tools/perf/Documentation/README.Devel or so :-)

	Ingo
