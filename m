Return-Path: <linux-kernel-owner+w=401wt.eu-S1752927AbYJ0MCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927AbYJ0MCT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 08:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751634AbYJ0MCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 08:02:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60702 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750881AbYJ0MCJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 08:02:09 -0400
Date: Mon, 27 Oct 2008 13:02:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Paalanen <pq@iki.fi>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] trace: add the MMIO-tracer to the tracer menu
Message-ID: <20081027120202.GF5631@elte.hu>
References: <1224845357.4075.0.camel@twins> <20081024112535.GA19786@elte.hu> <alpine.DEB.1.10.0810240755290.25677@gandalf.stny.rr.com> <20081024200811.4609c09f@daedalus.pq.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081024200811.4609c09f@daedalus.pq.iki.fi>
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


* Pekka Paalanen <pq@iki.fi> wrote:

> > And doing this will remove the need about my question on depends 
> > on X86.
> 
> Yes, we can remove MMIOTRACE_HOOKS and replace it with just 
> MMIOTRACE. MMIOTRACE_HOOKS is a remnant from the time when I thought 
> that something else could also use the kmmio facilities.
> 
> Here's a compile-tested patch against current Ingo's tip/master.
> 
> From d4b97cd777c3382b784a9504281feccc9f2c4036 Mon Sep 17 00:00:00 2001
> From: Pekka Paalanen <pq@iki.fi>
> Date: Fri, 24 Oct 2008 18:59:56 +0300
> Subject: [PATCH] mmiotrace: Remove unneeded CONFIG_MMIOTRACE_HOOKS.
> 
> Signed-off-by: Pekka Paalanen <pq@iki.fi>
> ---
>  arch/x86/Kconfig.debug |    4 ----
>  arch/x86/mm/Makefile   |    3 +--
>  arch/x86/mm/fault.c    |    2 +-
>  3 files changed, 2 insertions(+), 7 deletions(-)

applied, thanks Pekka!

	Ingo
