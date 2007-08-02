Return-Path: <linux-kernel-owner+w=401wt.eu-S1758950AbXHBTsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758950AbXHBTsl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 15:48:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758076AbXHBTsc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 15:48:32 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46851 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758071AbXHBTsc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 15:48:32 -0400
Date: Thu, 2 Aug 2007 21:48:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Martin Roehricht <ml@felicis.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Scheduling the highest priority task
Message-ID: <20070802194825.GA23245@elte.hu>
References: <8KLFD-G9-5@gated-at.bofh.it> <46B19CA1.7050204@felicis.org> <20070802114012.GA4067@elte.hu> <46B1F182.3010608@felicis.org> <20070802150350.GA3030@elte.hu> <46B1F4BA.4010107@felicis.org> <20070802151916.GA8688@elte.hu> <46B1FC6D.7010202@felicis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <46B1FC6D.7010202@felicis.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.0.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.5053]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Martin Roehricht <ml@felicis.org> wrote:

> On 08/02/2007 05:19 PM, Ingo Molnar wrote:
> >* Martin Roehricht <ml@felicis.org> wrote:
> >
> >>That's fine with me, that within the same priority-queue any task can 
> >>be chosen. But assume two tasks with highly different priorities, such 
> >>as 105 and 135 are scheduled on the same processor and one of them is 
> >>now to be migrated -- shouldn't be the queue with task P=105 
> >>considered first for migration by this code? Both tasks would use 
> >>different queues with their own linked lists, right?
> >
> >yes. What makes you believe that the lower priority one (prio 135) is 
> >chosen? [ as i said before, that will only be chosen if all tasks in the 
> >higher-priority queue (prio 105) are either already running on a CPU or 
> >have recently run so that the cache-hot logic skips them. ]
> 
> This believe is primarily based on my observations of multiple 
> benchmark runs and also on your statement earlier: »in the SMP 
> migration code, the 'old scheduler' indeed picks the lowest priority 
> one«.

oh, sorry, that was meant to be the 'highest priority one' :-/

so i think you got it all right, i just typoed that first sentence.

	Ingo
