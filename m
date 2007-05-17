Return-Path: <linux-kernel-owner+w=401wt.eu-S1758688AbXEQTYB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758688AbXEQTYB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 15:24:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756856AbXEQTXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 15:23:53 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44251 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756651AbXEQTXx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 15:23:53 -0400
Date: Thu, 17 May 2007 21:23:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?B?VPZy9ms=?= Edvin <edwintorok@gmail.com>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: CFS Scheduler and real-time tasks
Message-ID: <20070517192343.GA24249@elte.hu>
References: <4354d3270705171214v25bc4834t5e28a08649761e91@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4354d3270705171214v25bc4834t5e28a08649761e91@mail.gmail.com>
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

> Is there something I am doing wrong, or is the precision decrease 
> expected, when running real-time tasks too?

yeah: real-time tasks are ueber-tasks that just get all CPU time 
immediately. I guess we could make SCHED_RR be covered by CFS accounting 
eventually.

> Very precise indeed, the default scheduler produces lots of different 
> timings there.

note: you ran it on a dual-core system and the SMP load-balancer needs 
time to gain precision in the non-RT test - so i'd suggest to test it 
much longer than 10 seconds: 300 seconds at least.

	Ingo
