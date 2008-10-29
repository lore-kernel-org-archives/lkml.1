Return-Path: <linux-kernel-owner+w=401wt.eu-S1754051AbYJ2QW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051AbYJ2QW2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 12:22:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753511AbYJ2QWS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 12:22:18 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52069 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752472AbYJ2QWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 12:22:17 -0400
Date: Wed, 29 Oct 2008 17:21:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Noonan <steven@uplinklabs.net>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH] ftrace: fix trace_nop config select
Message-ID: <20081029162151.GA12529@elte.hu>
References: <200810281802.m9SI2fYX030138@hera.kernel.org> <20081029091857.GA4414@osiris.boeblingen.de.ibm.com> <alpine.DEB.1.10.0810291113500.2865@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0810291113500.2865@gandalf.stny.rr.com>
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

> The trace_nop is the tracer that is defined when no tracer is set in
> the ftrace infrastructure.
> 
> The trace_nop was mistakenly selected by HAVE_FTRACE due to the confusion
> between ftrace infrastructure and the ftrace function tracer (which has
> been solved by renaming the function tracer).
> 
> This patch changes the select to the approriate TRACING.
> 
> This patch should fix compile errors on architectures that do not define
> the FUNCTION_TRACER.
> 
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> ---
>  kernel/trace/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

applied to tip/tracing/urgent, thanks Steve!

	Ingo
