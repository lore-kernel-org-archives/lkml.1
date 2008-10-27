Return-Path: <linux-kernel-owner+w=401wt.eu-S1752603AbYJ0PqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603AbYJ0PqY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 11:46:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751281AbYJ0PqQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 11:46:16 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41980 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866AbYJ0PqQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 11:46:16 -0400
Date: Mon, 27 Oct 2008 16:46:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][RESEND] tracepoint: Check if the probe has been
	registered
Message-ID: <20081027154600.GO5704@elte.hu>
References: <48FF5F8F.6070202@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48FF5F8F.6070202@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0028]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> If we try to remove a probe that has not been already registered,
> the tracepoint_entry_remove_probe() function will dereference a NULL
> pointer.
> Check the probe before removing it to avoid crashes.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Acked-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> Acked-by: Steven Rostedt <srostedt@redhat.com>
> ---
>  kernel/tracepoint.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)

applied to tip/tracing/urgent, thanks Frederic!

	Ingo
