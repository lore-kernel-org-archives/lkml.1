Return-Path: <linux-kernel-owner+w=401wt.eu-S1760066AbZFBHzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760066AbZFBHzm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 03:55:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759584AbZFBHzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 03:55:33 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54037 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758438AbZFBHzd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 03:55:33 -0400
Date: Tue, 2 Jun 2009 09:54:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jon Masters <jonathan@jonmasters.org>, linux-kernel@vger.kernel.org,
       jcm@redhat.com, tglx@linutronix.de, rostedt@goodmis.org
Subject: Re: [RFC PATCH 1/1] smi_detector: A System Management Interrupt
	detector
Message-ID: <20090602075450.GA12411@elte.hu>
References: <20090531163117.502167374@jonmasters.org> <20090531163343.771922592@jonmasters.org> <20090601205720.825d3048.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090601205720.825d3048.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Sun, 31 May 2009 12:31:18 -0400 Jon Masters <jonathan@jonmasters.org> wrote:
> 
> > This patch introduces a new SMI (System Management Interrupt) detector module
> > that can be used to detect high latencies within the system. It was originally
> > written for use in the RT kernel, but has wider applications.
> > 
> 
> Neat-looking code.
> 
> AFACIT it can be used on any platform.  Suppose that powerpcs or ia64s
> also mysteriously go to lunch like PC's do - I think the code will work
> for them too?  In which case the "smi" name is excessively specific. 
> Not a big deal though.

Yes, i wondered about that too - this is really a generic method 
that detects and measures hardware latencies.

Many of the internal smi_ prefixes can go - such a prefix is really 
only needed within a .c module if the symbol is exported.

The rest (and the whole facility) could be renamed to hwlat_, 
hw_latency_ or so - prominently documenting that on x86 it can find 
SMI latencies, etc.?

	Ingo
