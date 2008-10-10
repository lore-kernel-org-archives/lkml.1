Return-Path: <linux-kernel-owner+w=401wt.eu-S1760042AbYJJOAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760042AbYJJOAs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 10:00:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757324AbYJJOAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 10:00:40 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58410 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757283AbYJJOAj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 10:00:39 -0400
Date: Fri, 10 Oct 2008 16:00:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 2/6] tracepoint: Check if the probe has been registered
Message-ID: <20081010140023.GA13137@elte.hu>
References: <20081010111631.78545D1BDA2@perso1.free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081010111631.78545D1BDA2@perso1.free.fr>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0170]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> If we try to remove a probe that has not been already registered, the 
> tracepoint_entry_remove_probe() function will dereference a NULL 
> pointer. Check the probe before removing it to avoid crashes.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  kernel/tracepoint.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)

applied to tip/tracing/tracepoints, thanks Frederic!

Mathieu, Steve, any objections/observations?

	Ingo
