Return-Path: <linux-kernel-owner+w=401wt.eu-S1753062AbYKMIvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753062AbYKMIvW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 03:51:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751454AbYKMIvN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 03:51:13 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38252 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751059AbYKMIvM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 03:51:12 -0500
Date: Thu, 13 Nov 2008 09:50:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       David Miller <davem@davemloft.net>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>, Pekka Paalanen <pq@iki.fi>
Subject: Re: [PATCH 0/3] ftrace updates for tip
Message-ID: <20081113085050.GE25479@elte.hu>
References: <20081112225235.056515739@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081112225235.056515739@goodmis.org>
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

> [
>   I added a bit more people to the Cc so that they are aware
>   of the pending renames that are coming.
> 
>    Namely, trace_entries will be renamed to buffer_size
>            iter_ctrl will be renamed to trace_options
> ]
> 
> Ingo,
> 
> The following patches are in:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> 
>     branch: tip/devel
> 
> 
> Steven Rostedt (3):
>       ftrace: rename trace_entries to buffer_size
>       ftrace: rename iter_ctrl to trace_options
>       ftrace: CPU buffer start annotation clean ups

i've applied them to tip/tracing/ftrace, with some small changes:

 12ef7d4: ftrace: CPU buffer start annotation clean ups
 ee6bce5: ftrace: rename iter_ctrl to trace_options
 1696b2b: ftrace: show buffer size in kilobytes
 a94c80e: ftrace: rename trace_entries to buffer_size_kb

as per Arjan's suggestion i changed buffer_size to buffer_size_kb - 
and also removed the kilobytes string from its output.

thanks Steve!

	Ingo
