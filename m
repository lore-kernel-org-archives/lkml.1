Return-Path: <linux-kernel-owner+w=401wt.eu-S1754484AbXLEUET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484AbXLEUET (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 15:04:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752161AbXLEUEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 15:04:09 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40023 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752453AbXLEUEI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 15:04:08 -0500
Date: Wed, 5 Dec 2007 21:03:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jie Chen <chen@jlab.org>
Cc: Simon Holm Th??gersen <odie@cs.aau.dk>, Eric Dumazet <dada1@cosmosbay.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: Possible bug from kernel 2.6.22 and above, 2.6.24-rc4
Message-ID: <20071205200343.GA14570@elte.hu>
References: <4744ADA9.7040905@cosmosbay.com> <4744E0DC.7050808@jlab.org> <1195698770.11808.4.camel@odie.local> <4744F042.4070002@jlab.org> <20071204131707.GA4232@elte.hu> <4756C3D9.9030107@jlab.org> <20071205154014.GA6491@elte.hu> <4756D058.1070500@jlab.org> <20071205164723.GA25641@elte.hu> <4756E44E.8080607@jlab.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4756E44E.8080607@jlab.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Jie Chen <chen@jlab.org> wrote:

> Since I am using affinity flag to bind each thread to a different 
> core, the synchronization overhead should increases as the number of 
> cores/threads increases. But what we observed in the new kernel is the 
> opposite. The barrier overhead of two threads is 8.93 micro seconds vs 
> 1.86 microseconds for 8 threads (the old kernel is 0.49 vs 1.86). This 
> will confuse most of people who study the 
> synchronization/communication scalability. I know my test code is not 
> real-world computation which usually use up all cores. I hope I have 
> explained myself clearly. Thank you very much.

btw., could you try to not use the affinity mask and let the scheduler 
manage the spreading of tasks? It generally has a better knowledge about 
how tasks interrelate.

	Ingo
