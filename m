Return-Path: <linux-kernel-owner+w=401wt.eu-S1752530AbYIQKFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530AbYIQKFu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 06:05:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754737AbYIQKFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 06:05:38 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54007 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751801AbYIQKFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 06:05:38 -0400
Date: Wed, 17 Sep 2008 12:05:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: David Howells <dhowells@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched_clock: fix jiffie fallback clock
Message-ID: <20080917100518.GA9916@elte.hu>
References: <1221503179.7154.2.camel@lappy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1221503179.7154.2.camel@lappy.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0358]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> David pointed out that the default sched_clock() fallback is broken in 
> that it wraps too soon. Fix this by using the 64 bit jiffie value so 
> that we're large enough to overflow properly.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> CC: David Howells <dhowells@redhat.com>

applied to tip/sched/urgent, thanks Peter!

	Ingo
