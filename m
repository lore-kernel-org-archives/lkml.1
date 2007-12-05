Return-Path: <linux-kernel-owner+w=401wt.eu-S1754252AbXLEVWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754252AbXLEVWX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 16:22:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752084AbXLEVWP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 16:22:15 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54411 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751880AbXLEVWO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 16:22:14 -0500
Date: Wed, 5 Dec 2007 22:21:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Holger.Wolf@de.ibm.com, schwidefsky@de.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: Scheduler behaviour
Message-ID: <20071205212155.GA4764@elte.hu>
References: <475706E2.50805@linux.vnet.ibm.com> <1196889302.6353.29.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1196889302.6353.29.camel@lappy>
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> > We discovered performance degradation with dbench when using kernel 
> > 2.6.23 compared to kernel 2.6.22.
> 
> We've fixed a lot of regressions and made a lot of other changes to 
> the scheduler since .23. Could you please try the backport of the 
> latest scheduler on top of .23 to see if any of our recent work solved 
> your problem? (using a backport against .23 or even .22 allows you to 
> test just the scheduler changes in isolation)

actually, i'd suggest to use the CFS backport against .22 right away:

> http://people.redhat.com/mingo/cfs-scheduler/sched-cfs-v2.6.22.13-v24.patch

that would exclude all other changes that happened in 2.6.23.

	Ingo
