Return-Path: <linux-kernel-owner+w=401wt.eu-S1764778AbXGYH2E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764778AbXGYH2E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 03:28:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755483AbXGYH1x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 03:27:53 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39221 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755123AbXGYH1w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 03:27:52 -0400
Date: Wed, 25 Jul 2007 09:27:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?S=E9bastien_Dugu=E9?= <sebastien.dugue@bull.net>
Cc: Linux RT Users <linux-rt-users@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jean Pierre Dion <jean-pierre.dion@bull.net>,
       Darren Hart <dvhltc@us.ibm.com>, john stultz <johnstul@us.ibm.com>,
       Josh Triplett <josht@linux.vnet.ibm.com>
Subject: Re: [PATCH RT] Fix RT balancing tasks pulling
Message-ID: <20070725072700.GC26955@elte.hu>
References: <20070724154202.224f12e8@frecb000686.frec.bull.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070724154202.224f12e8@frecb000686.frec.bull.fr>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Sébastien Dugué <sebastien.dugue@bull.net> wrote:

>   Hi Ingo, Thomas,
> 
>   this one-liner fixes a bug in balance_rt_tasks() which sometimes 
> manifests by having a lower prio task being scheduled while a higher 
> prio task is sitting waiting on another runqueue.
> 
>   This is pretty hard to reproduce on low cpu count machines, for 
> example, I had to have sched_football run in a loop for ~38h before it 
> failed on a dual HT Xeon box.

really nice catch! Applied.

	Ingo
