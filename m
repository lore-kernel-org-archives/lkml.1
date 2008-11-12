Return-Path: <linux-kernel-owner+w=401wt.eu-S1752343AbYKLKYi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752343AbYKLKYi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 05:24:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751822AbYKLKY3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 05:24:29 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40299 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751502AbYKLKY2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 05:24:28 -0500
Date: Wed, 12 Nov 2008 11:24:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 2/2] ring-buffer: no preempt for sched_clock
Message-ID: <20081112102403.GB24482@elte.hu>
References: <20081112050125.654925304@goodmis.org> <20081112050219.202854960@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081112050219.202854960@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Impact: disable preemption no calling sched_clock
> 
> The ring_buffer_time_stamp still uses sched_clock as its counter.
> But it is a bug to call it with preemption enabled. This requirement
> should not be pushed to the ring_buffer_time_stamp callers, so
> the ring_buffer_time_stamp needs to disable preemption when calling
> sched_clock.
> 
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> ---
>  kernel/trace/ring_buffer.c |    8 +++++++-
>  1 files changed, 7 insertions(+), 1 deletions(-)

applied to tip/tracing/urgent, thanks Steve!

	Ingo
