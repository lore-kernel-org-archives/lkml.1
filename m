Return-Path: <linux-kernel-owner+w=401wt.eu-S1752612AbYJAFxP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612AbYJAFxP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 01:53:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751710AbYJAFxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 01:53:05 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58345 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751697AbYJAFxE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 01:53:04 -0400
Date: Wed, 1 Oct 2008 07:52:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Pekka Paalanen <pq@iki.fi>, Frederic Weisbecker <fweisbec@gmail.com>,
       Martin Bligh <mbligh@google.com>, Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 1/2] ring_buffer: remove raw from local_irq_save
Message-ID: <20081001055235.GA25703@elte.hu>
References: <20081001042951.412019606@goodmis.org> <20081001043908.122153176@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081001043908.122153176@goodmis.org>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> The raw_local_irq_save causes issues with lockdep. We don't need it
> so replace them with local_irq_save.
> 
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> ---
>  kernel/trace/ring_buffer.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

applied to tip/tracing/ring-buffer, thanks Steve!

	Ingo
