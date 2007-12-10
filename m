Return-Path: <linux-kernel-owner+w=401wt.eu-S1754543AbXLJIhj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543AbXLJIhj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 03:37:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751407AbXLJIhc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 03:37:32 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54024 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751337AbXLJIhb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 03:37:31 -0500
Date: Mon, 10 Dec 2007 09:37:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Steven Rostedt <srostedt@redhat.com>,
       Gregory Haskins <ghaskins@novell.com>,
       LKML Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH git-sched 1/3] no need for 'affine wakeup' balancing in
	select_task_rq_fair() when task_cpu(p) == this_cpu
Message-ID: <20071210083717.GC22699@elte.hu>
References: <1197225382.6991.23.camel@earth>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1197225382.6991.23.camel@earth>
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


* Dmitry Adamushko <dmitry.adamushko@gmail.com> wrote:

> From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
> 
> No need to do a check for 'affine wakeup and passive balancing 
> possibilities' in select_task_rq_fair() when task_cpu(p) == this_cpu.
> 
> I guess, this part got missed upon introduction of per-sched_class 
> select_task_rq() in try_to_wake_up().

thanks, applied.

	Ingo
