Return-Path: <linux-kernel-owner+w=401wt.eu-S1754908AbYJCH5l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908AbYJCH5l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 03:57:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753969AbYJCH5d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 03:57:33 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39620 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752905AbYJCH5c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 03:57:32 -0400
Date: Fri, 3 Oct 2008 09:57:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ftrace: move pc counter in irqstrace
Message-ID: <20081003075720.GB25408@elte.hu>
References: <alpine.DEB.1.10.0810021921500.26504@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0810021921500.26504@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0017]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> The assigning of the pc counter is in the wrong spot in the
> check_critical_timing function. The pc variable is used in the
> out jump.
> 
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> ---
>  kernel/trace/trace_irqsoff.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

applied to tip/tracing/ring-buffer, thanks Steven!

	Ingo
