Return-Path: <linux-kernel-owner+w=401wt.eu-S1753838AbYJaJb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838AbYJaJb3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 05:31:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752004AbYJaJbT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 05:31:19 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40156 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751353AbYJaJbT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 05:31:19 -0400
Date: Fri, 31 Oct 2008 10:30:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, peterz@infradead.org, torvalds@linux-foundation.org,
       srostedt@redhat.com
Subject: Re: [PATCH] hardirq.h clean up
Message-ID: <20081031093030.GC30317@elte.hu>
References: <20081030200831.467420488@goodmis.org> <20081030201127.820600693@goodmis.org> <20081030133228.824e3f69.akpm@linux-foundation.org> <alpine.DEB.1.10.0810301645100.21031@gandalf.stny.rr.com> <20081030141048.904c82e1.akpm@linux-foundation.org> <alpine.DEB.1.10.0810310002320.28140@gandalf.stny.rr.com> <alpine.DEB.1.10.0810310016230.28140@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0810310016230.28140@gandalf.stny.rr.com>
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

> 
> This patch converts the CPP macros of __irq_enter, __irq_exit,
> nmi_enter, and nmi_exit into static inlines.
> 
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> ---
>  include/linux/hardirq.h |   53 ++++++++++++++++++++++++------------------------
>  1 file changed, 27 insertions(+), 26 deletions(-)

makes sense, but have you done build-testing (and cross-build-testing) 
of this? I remember that this area was include-file-dependencies-hell 
in the past.

perhaps with your simulate-old-arch patch on x86 we could tickle some 
of the issues that trigger here.

	Ingo
