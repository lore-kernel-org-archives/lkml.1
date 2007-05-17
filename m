Return-Path: <linux-kernel-owner+w=401wt.eu-S1761453AbXEQUNy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761453AbXEQUNy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 16:13:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757258AbXEQUNp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 16:13:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34511 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757213AbXEQUNo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 16:13:44 -0400
Date: Thu, 17 May 2007 22:13:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?B?VPZy9ms=?= Edvin <edwintorok@gmail.com>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: CFS Scheduler and real-time tasks
Message-ID: <20070517201338.GA1713@elte.hu>
References: <4354d3270705171214v25bc4834t5e28a08649761e91@mail.gmail.com> <20070517192343.GA24249@elte.hu> <4354d3270705171310x1d7770b2mb086f1fde7cffabd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4354d3270705171310x1d7770b2mb086f1fde7cffabd@mail.gmail.com>
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


* Török Edvin <edwintorok@gmail.com> wrote:

> On 5/17/07, Ingo Molnar <mingo@elte.hu> wrote:
> >
> >note: you ran it on a dual-core system and the SMP load-balancer needs
> >time to gain precision in the non-RT test - so i'd suggest to test it
> >much longer than 10 seconds: 300 seconds at least.
> 
> Thanks, running for 300 seconds shows only a 2% error. Even running a 
> I/O workload while running the massive_intr test keeps the same error.

hey, cool! Also try -v13 - it should be even more tighter.

> BTW, the system is more 'responsive'. For example starting 
> applications while running the tests, switching windows, moving 
> windows is much "smoother" than on default scheduler.

yeah :)

> [while true;do cp /usr/portage/distfiles/linux-2.6.21.tar.bz2 . && 
> sync && rm linux-2.6.21.tar.bz2 && sync; done]
> 
> ./massiv_new 9 300
> 020860  00017782
> 020858  00017774
> 
> RT JOB:020865   00003785
> 
> 020859  00017048
> 020862  00017387
> 020855  00017494
> 020861  00017245
> 020863  00017492
> 020864  00017122

looks pretty good!

	Ingo
