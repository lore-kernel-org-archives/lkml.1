Return-Path: <linux-kernel-owner+w=401wt.eu-S1753808AbYIWOXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808AbYIWOXu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 10:23:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751672AbYIWOXl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 10:23:41 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50559 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751515AbYIWOXl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 10:23:41 -0400
Date: Tue, 23 Sep 2008 16:23:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] sched: rework wakeup preemption
Message-ID: <20080923142324.GC14041@elte.hu>
References: <20080923133340.929758093@programming.kicks-ass.net> <20080923133501.046482664@programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080923133501.046482664@programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.3
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.2066]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> Rework the wakeup preemption to work on real runtime instead of
> the virtual runtime. This greatly simplifies the code.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

applied the five scheduler patches to tip/sched/devel, thanks Peter!

	Ingo
