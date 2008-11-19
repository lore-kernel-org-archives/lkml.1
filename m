Return-Path: <linux-kernel-owner+w=401wt.eu-S1754125AbYKSRpU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125AbYKSRpU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 12:45:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752965AbYKSRpH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 12:45:07 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43939 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752857AbYKSRpF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 12:45:05 -0500
Date: Wed, 19 Nov 2008 18:44:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Max Krasnyansky <maxk@qualcomm.com>
Cc: Nish Aravamudan <nish.aravamudan@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Dimitri Sivanich <sivanich@sgi.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Using cpusets for configuration/isolation [Was Re: RT sched:
	cpupri_vec lock contention with def_root_domain and no load balance]
Message-ID: <20081119174448.GB31560@elte.hu>
References: <29495f1d0811071123x37d910a8w6c1604b8159954ec@mail.gmail.com> <4923731E.7010601@qualcomm.com> <20081119125135.GB20475@elte.hu> <49243F7C.9090109@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49243F7C.9090109@qualcomm.com>
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


* Max Krasnyansky <maxk@qualcomm.com> wrote:

> Ingo Molnar wrote:
> > * Max Krasnyansky <maxk@qualcomm.com> wrote:
> > 
> >> What you described is almost exactly what I did in my original 
> >> cpu isolation patch, which did get NAKed :). Basically I used 
> >> global cpu_isolated_map and exposed 'isolated' bit, etc.
> > 
> > Please extend cpusets according to the plan outlined by PeterZ a 
> > few months ago - that's the right place to do partitioning.
> 
> Already did. It's all in mainline. The part you quoted was just 
> pointing out that the original approach was not correct.

Yeah, we have bits of it (i merged them, and i still remember them ;-) 
- but we still dont have the "system set" concept suggested by Peter 
though. We could go further and make it really easy to partition all 
scheduling and irq aspects of the system via cpusets.

	Ingo
