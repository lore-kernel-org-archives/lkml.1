Return-Path: <linux-kernel-owner+w=401wt.eu-S1761288AbXK1PmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761288AbXK1PmS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 10:42:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757234AbXK1PmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 10:42:09 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48905 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754897AbXK1PmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 10:42:08 -0500
Date: Wed, 28 Nov 2007 16:41:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: jdike@addtoit.com, user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: -rt doesn't compile for UML
Message-ID: <20071128154152.GA742@elte.hu>
References: <E1IxMK0-0006ae-2s@dorka.pomaz.szeredi.hu> <20071128125030.GB21791@elte.hu> <E1IxMfh-0006fN-HQ@dorka.pomaz.szeredi.hu> <20071128150840.GB5518@c2.user-mode-linux.org> <E1IxOzn-00075w-Gq@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1IxOzn-00075w-Gq@dorka.pomaz.szeredi.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Miklos Szeredi <miklos@szeredi.hu> wrote:

> > On Wed, Nov 28, 2007 at 02:09:45PM +0100, Miklos Szeredi wrote:
> > > kernel/latency_trace.c:28:21: error: asm/rtc.h: No such file or directory
> > 
> > For things like this, look at the host's asm/foo.h and see if it's
> > usable in UML (and contains things that you need).  If it is, just
> > make a asm-um/foo.h which just includes "asm/arch/foo.h".
> 
> Yeah, I know that trick :)
> 
> It doesn't help in this case.  I've gotten as far as realizing that 
> the latency tracer needs the irqflags tracing 
> (Documentation/irqflags-tracing.tx) and that UML doesn't yet support 
> that.

it doesnt need it - turn IRQOFF_TRACING off. You want FUNCTION_TRACING 
to work (and perhaps WAKEUP_TIMING) so that you can take a look at 
what's going on, right?

	Ingo
