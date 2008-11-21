Return-Path: <linux-kernel-owner+w=401wt.eu-S1755301AbYKUIbt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301AbYKUIbt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 03:31:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752881AbYKUIbi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 03:31:38 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:33348 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752603AbYKUIbh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 03:31:37 -0500
Date: Fri, 21 Nov 2008 09:30:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [Bug #11308] tbench regression on each kernel release from
	2.6.22 -&gt; 2.6.28
Message-ID: <20081121083044.GL16242@elte.hu>
References: <1ScKicKnTUE.A.VxH.DIHIJB@chimera> <NjF0-fuClJC.A.73B.cLHIJB@chimera> <20081117090648.GG28786@elte.hu> <Pine.LNX.4.64.0811191341570.23502@quilx.com> <Pine.LNX.4.64.0811201727070.9089@quilx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0811201727070.9089@quilx.com>
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


* Christoph Lameter <cl@linux-foundation.org> wrote:

> hmmm... Well we are almost there.
> 
> 2.6.22:
> 
> Throughput 2526.15 MB/sec 8 procs
> 
> 2.6.28-rc5:
> 
> Throughput 2486.2 MB/sec 8 procs
> 
> 8p Dell 1950 and the number of processors specified on the tbench 
> command line.

And with net-next we might even be able to get past that magic limit? 
net-next is linus-latest plus the latest and greatest networking bits:

 $ cat .git/config

 [remote "net-next"]
	url = git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next-2.6.git
	fetch = +refs/heads/*:refs/remotes/net-next/*

... so might be worth a test. Just to satisfy our curiosity and to 
possibly close the entry :-)

	Ingo
