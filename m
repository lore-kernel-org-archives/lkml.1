Return-Path: <linux-kernel-owner+w=401wt.eu-S1755546AbZHULbt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755546AbZHULbt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 07:31:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755044AbZHULbt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 07:31:49 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36181 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752078AbZHULbs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 07:31:48 -0400
Date: Fri, 21 Aug 2009 13:31:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Kyle McMartin <kyle@mcmartin.ca>, "Carlos R. Mafra" <crmafra@gmail.com>
Cc: Gregory Haskins <gregory.haskins@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: perf: Problem compiling /tools/perf/Documentation in 2.6.31-rc6
Message-ID: <20090821113134.GB24647@elte.hu>
References: <4A8D9D56.5080107@gmail.com> <20090820221528.GS25206@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090820221528.GS25206@bombadil.infradead.org>
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


* Kyle McMartin <kyle@mcmartin.ca> wrote:

> On Thu, Aug 20, 2009 at 03:00:38PM -0400, Gregory Haskins wrote:
> > Hi Ingo,
> > 
> > I'm seeing this in 2.6.31-rc6:
> > 
> > ghaskins@dev:~/sandbox/git/fabric/linux-2.6/tools/perf/Documentation> make
> >     SUBDIR ../
> > make[1]: `PERF-VERSION-FILE' is up to date.
> >     ASCIIDOC perf-examples.html
> > ERROR: perf-examples.txt: line 1: manpage document title is mandatory
> > FAILED: perf-examples.txt: line 8: illegal style name: From an e-mail by
> > Ingo Molnar
> > make: *** [perf-examples.html] Error 1
> > 
> > It could very well be pilot error.  Any ideas?
> > 
> 
> This was fixed in a recent commit to tip, probably upstream by now.
> http://git.kernel.org/?p=linux/kernel/git/x86/linux-2.6-tip.git;a=commitdiff;h=2932cffc89e9a1476b28a59896fa4f81e0d4f131

Yeah, the fix is upstream now, Linus pulled it two days ago.

	Ingo
