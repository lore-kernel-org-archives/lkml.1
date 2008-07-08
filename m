Return-Path: <linux-kernel-owner+w=401wt.eu-S1754074AbYGHFRK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074AbYGHFRK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 01:17:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751059AbYGHFQz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 01:16:55 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51499 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750994AbYGHFQy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 01:16:54 -0400
Date: Tue, 8 Jul 2008 07:16:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [Bug #10872] x86_64 boot hang when CONFIG_NUMA=n
Message-ID: <20080708051629.GA12595@elte.hu>
References: <Vu1KV8Wj_GP.A.qW.DzLcIB@albercik> <uBi7uNfg81L.A.XLC.s0LcIB@albercik> <20080706111750.a6d77e81.randy.dunlap@oracle.com> <alpine.LFD.1.10.0807061133230.3016@woody.linux-foundation.org> <20080707063218.GC23583@elte.hu> <20080707113917.6fda3f7d.randy.dunlap@oracle.com> <20080707154042.04bb492e.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080707154042.04bb492e.randy.dunlap@oracle.com>
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


* Randy Dunlap <randy.dunlap@oracle.com> wrote:

> > $ git bisect start
> > $ git bisect bad v2.6.26-rc1
> > $ git bisect good v2.6.25
> > 
> > That's only about 1.29M lines of changes.
> 
> git bisect and normal rebooting did not find a problem.
> 
> I'll repeat this using kexec to boot the new kernel and see if that 
> locates any issues... since I normally use kexec to load/test new 
> kernels and that was how the failure occurred (occurs).

ah, so the hang only occurs if you kexec a post-v2.6.25 kernel? (from 
any other kernel, or from a post-v2.6.25 kernel?)

	Ingo
