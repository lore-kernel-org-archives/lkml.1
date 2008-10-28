Return-Path: <linux-kernel-owner+w=401wt.eu-S1753086AbYJ1IyM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086AbYJ1IyM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 04:54:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752517AbYJ1Ix6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 04:53:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38171 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752398AbYJ1Ix5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 04:53:57 -0400
Date: Tue, 28 Oct 2008 09:53:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH][RESEND] tracing: fix a build error on alpha
Message-ID: <20081028085350.GN15734@elte.hu>
References: <4906D0AE.7020903@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4906D0AE.7020903@gmail.com>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> When tracing is enabled, some arch have included <linux/irqflags.h>
> on their <asm/system.h> but others like alpha or m68k don't.
> 
> Build error on alpha:
> 
> kernel/trace/trace.c: In function 'tracing_cpumask_write':
> kernel/trace/trace.c:2145: error: implicit declaration of function 'raw_local_irq_disable'
> kernel/trace/trace.c:2162: error: implicit declaration of function 'raw_local_irq_enable'
> 
> Tested on Alpha through a cross-compiler (should correct a similar issue on m68k).
> 
> Reported-by: Alexey Dobriyan <adobriyan@gmail.com>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>

applied to tip/tracing/urgent, thanks Frederic!

	Ingo
