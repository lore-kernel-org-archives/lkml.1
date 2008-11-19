Return-Path: <linux-kernel-owner+w=401wt.eu-S1753923AbYKSUPY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923AbYKSUPY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 15:15:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752467AbYKSUPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 15:15:09 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60342 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752328AbYKSUPI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 15:15:08 -0500
Date: Wed, 19 Nov 2008 21:14:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [Bug #11308] tbench regression on each kernel release from
	2.6.22 -&gt; 2.6.28
Message-ID: <20081119201444.GB4765@elte.hu>
References: <1ScKicKnTUE.A.VxH.DIHIJB@chimera> <NjF0-fuClJC.A.73B.cLHIJB@chimera> <20081117090648.GG28786@elte.hu> <Pine.LNX.4.64.0811191341570.23502@quilx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0811191341570.23502@quilx.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Lameter <cl@linux-foundation.org> wrote:

> On Mon, 17 Nov 2008, Ingo Molnar wrote:
> 
> > Christoph, as per the recent analysis of Mike:
> >
> >  http://fixunix.com/kernel/556867-regression-benchmark-throughput-loss-a622cf6-f7160c7-pull.html
> >
> > all scheduler components of this regression have been eliminated.
> >
> > In fact his numbers show that scheduler speedups since 2.6.22 have
> > offset and hidden most other sources of tbench regression. (i.e. the
> > scheduler portion got 5% faster, hence it was able to offset a
> > slowdown of 5% in other areas of the kernel that tbench triggers)
> 
> Ok will rerun the tests tomorrow. Just got back from SC08 need some 
> time to catch up.
> 
> Looks like a lot of work was done on this issue. Thanks!

You might also want to try net-next:

 [remote "net-next"]
        url = git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next-2.6.git
        fetch = +refs/heads/*:refs/remotes/net-next/*

Some good stuff is in there too, impacting this workload.

	Ingo
