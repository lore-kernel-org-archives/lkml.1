Return-Path: <linux-kernel-owner+w=401wt.eu-S1754283AbXLEUrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283AbXLEUrU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 15:47:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751656AbXLEUrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 15:47:13 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46600 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751617AbXLEUrM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 15:47:12 -0500
Date: Wed, 5 Dec 2007 21:46:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jie Chen <chen@jlab.org>
Cc: Simon Holm Th??gersen <odie@cs.aau.dk>, Eric Dumazet <dada1@cosmosbay.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: Possible bug from kernel 2.6.22 and above, 2.6.24-rc4
Message-ID: <20071205204645.GC25694@elte.hu>
References: <1195698770.11808.4.camel@odie.local> <4744F042.4070002@jlab.org> <20071204131707.GA4232@elte.hu> <4756C3D9.9030107@jlab.org> <20071205154014.GA6491@elte.hu> <4756D058.1070500@jlab.org> <20071205164723.GA25641@elte.hu> <4756E44E.8080607@jlab.org> <20071205200343.GA14570@elte.hu> <475708A7.4030708@jlab.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <475708A7.4030708@jlab.org>
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

> I just disabled the affinity mask and reran the test. There were no 
> significant changes for two threads (barrier overhead is around 9 
> microseconds). As for 8 threads, the barrier overhead actually drops a 
> little, which is good. Let me know whether I can be any help. Thank 
> you very much.

sorry to be dense, but could you give me instructions how i could remove 
the affinity mask and test the "barrier overhead" myself? I have built 
"pthread_sync" and it outputs numbers for me - which one would be the 
barrier overhead: Reference_time_1 ?

	Ingo
