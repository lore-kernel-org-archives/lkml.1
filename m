Return-Path: <linux-kernel-owner+w=401wt.eu-S1754534AbYJBI7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534AbYJBI7z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 04:59:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753210AbYJBI7q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 04:59:46 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43144 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752301AbYJBI7q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 04:59:46 -0400
Date: Thu, 2 Oct 2008 10:51:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, Jonathan Corbet <corbet@lwn.net>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Martin Bligh <mbligh@google.com>,
       Christoph Hellwig <hch@infradead.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH] ring_buffer: allocate buffer page pointer
Message-ID: <20081002085145.GA3202@elte.hu>
References: <alpine.DEB.1.10.0809292010530.8145@gandalf.stny.rr.com> <20080930034603.GA13801@Krystal> <alpine.DEB.1.10.0809292359030.19533@gandalf.stny.rr.com> <20080930092001.69849210@bike.lwn.net> <1222790072.24384.21.camel@twins> <alpine.LFD.2.00.0809300930090.3389@nehalem.linux-foundation.org> <alpine.DEB.1.10.0809301242550.1984@gandalf.stny.rr.com> <alpine.LFD.2.00.0809300958120.3389@nehalem.linux-foundation.org> <alpine.DEB.1.10.0810011114000.30777@gandalf.stny.rr.com> <20081002085030.GF26084@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081002085030.GF26084@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> applied to tip/tracing/ftrace, with the extended changlog below - i 
> think this commit warrants that extra mention.

that was for the type filter commit. The 3 patches i've picked up into 
tip/tracing/ring-buffer are:

 b6eeea4: ftrace: preempt disable over interrupt disable
 52abc82: ring_buffer: allocate buffer page pointer
 da78331: ftrace: type cast filter+verifier

Thanks,

	Ingo
