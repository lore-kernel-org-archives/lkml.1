Return-Path: <linux-kernel-owner+w=401wt.eu-S1757813AbXJFGW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757813AbXJFGW0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 02:22:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751641AbXJFGWS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 02:22:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36879 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751810AbXJFGWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 02:22:17 -0400
Date: Sat, 6 Oct 2007 08:21:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paul Jackson <pj@sgi.com>
Cc: akpm@linux-foundation.org, nickpiggin@yahoo.com.au,
       randy.dunlap@oracle.com, menage@google.com,
       linux-kernel@vger.kernel.org, dino@in.ibm.com, cpw@sgi.com
Subject: Re: [PATCH] cpuset and sched domains: sched_load_balance flag fixes
Message-ID: <20071006062156.GA28237@elte.hu>
References: <20071003114401.32194.73464.sendpatchset@jackhammer.engr.sgi.com> <20071005161305.af27f452.akpm@linux-foundation.org> <20071005163918.46d40fed.pj@sgi.com> <20071006055324.GC23397@elte.hu> <20071005230141.63a1f6c3.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071005230141.63a1f6c3.pj@sgi.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul Jackson <pj@sgi.com> wrote:

> My plan had been to send Andrew something on Wednesday
> next week (five days from now), either what we have now,
> or with the improved cpuset-to-sched API, if Nick and I
> can work through that (well, if Nick can figure out what
> I broke, while I'm offline.)
> 
> Andrew or Ingo - you got any better plan?

i'd suggest we go with what we have now (i've run it for some reasonable 
time on various systems and it caused no breakages) - could you resend 
that? We cannot merge it via sched.git because it has some containers 
(or other?) dependencies, right?

	Ingo
