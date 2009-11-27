Return-Path: <linux-kernel-owner+w=401wt.eu-S1753720AbZK0HDO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720AbZK0HDO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 02:03:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751904AbZK0HDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 02:03:13 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51055 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751650AbZK0HDM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 02:03:12 -0500
Date: Fri, 27 Nov 2009 08:02:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/4 tip/sched/core] sched: rename preempt_notifier to
 sched_notifier and always enable it
Message-ID: <20091127070254.GA1547@elte.hu>
References: <1259239259.4273.82.camel@twins>
 <4B0F356B.3040206@kernel.org>
 <20091127045209.GA13914@elte.hu>
 <4B0F65DD.1090707@kernel.org>
 <20091127054621.GA25672@elte.hu>
 <4B0F6B32.4090401@kernel.org>
 <20091127061319.GA8620@elte.hu>
 <4B0F6EA9.6070105@kernel.org>
 <20091127062147.GB22149@elte.hu>
 <4B0F73CA.7090804@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B0F73CA.7090804@kernel.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tejun Heo <tj@kernel.org> wrote:

> > Please send all sched.c modifications via the scheduler tree. Going 
> > via other trees is fine when there's agreement by the maintainers - 
> > but this is one of the rare cases where that's not the case.
> 
> Yeah, sure.  So, two patchsets.  One for sched/core doing pure 
> reorganization without any functional changes.  The other for 
> sched/notifier (or whatever name you would prefer) which is purely for 
> development and testing and will not be pushed to Linus unless it 
> receives notifier framework cleanup.  wq#for-next will pull from 
> sched/notifier and be exported to linux-next but it will never be 
> submitted to Linus until sched/notifier is cleaned up.  Am I 
> understanding it correctly?

Yeah, that would be fine.

	Ingo
