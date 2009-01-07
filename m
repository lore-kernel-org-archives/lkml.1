Return-Path: <linux-kernel-owner+w=401wt.eu-S1757905AbZAGR73@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757905AbZAGR73 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 12:59:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753193AbZAGR7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 12:59:20 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54814 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753030AbZAGR7T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 12:59:19 -0500
Date: Wed, 7 Jan 2009 18:59:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] posix-cpu-timers: clock_gettime(CLOCK_*_CPUTIME_ID)
	goes backward
Message-ID: <20090107175903.GF24982@elte.hu>
References: <49547320.9010302@jp.fujitsu.com> <20081226084320.GC755@elte.hu> <1230282171.9487.278.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1230282171.9487.278.camel@twins>
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> Which reminds me, why do we still have this crap in the kernel? I 
> thought we pretty much showed the per-cpu itimer thing was utter crap? 
> -- can we pretty please either revert that or apply 
> http://lkml.org/lkml/2008/11/24/183 ?
> 
> Also, I really don't like the above, we now do the per-cpu loop with the 
> RQ lock held...

ok, i've applied it to tip/timers/urgent. This should solve the original 
itimer testcase as well, correct?

	Ingo
