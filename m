Return-Path: <linux-kernel-owner+w=401wt.eu-S1756984AbZF3Wmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756984AbZF3Wmv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 18:42:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754412AbZF3Wmn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 18:42:43 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39794 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754476AbZF3Wmm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 18:42:42 -0400
Date: Wed, 1 Jul 2009 00:42:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Paul Mackerras <paulus@samba.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] perf_counter: Add Generalized Hardware FPU
	support for AMD
Message-ID: <20090630224220.GI1241@elte.hu>
References: <1246267985.3185.3.camel@hpdv5.satnam> <20090630101105.GF6942@elte.hu> <1246368049.3026.11.camel@hpdv5.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246368049.3026.11.camel@hpdv5.satnam>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> > Plus things like mmx-3dnow are AMD specific, sse-sse2 is x86 
> > specific. We definitely want this general table, but the events 
> > should be truly general.
> 
> mmx and sse are available for both Intel and AMD. Thats why I 
> added both of them. Is it OK.

'3dnow' is an AMD marketing term. (and is long obsolete)

Nor did you answer (or understand) my sentence above: 'sse' is an 
x86 specific term.

I think a naming and enumeration scheme around the general concept 
of 'vectored co-processor' would be far less x86 specific.

Mockup:

        19583739  vec-adds               (   2.01x scaled)
        20856051  vec-muls               (   2.01x scaled)
        20856051  vec-divs               (   2.01x scaled)
     25100224054  vec-idle-cycles        (   1.99x scaled)
        12540131  vec-busy-cycles        (   1.99x scaled)
        42286702  vec-ops                (   2.01x scaled)

Paulus: would this categorization fit PowerPC too?

	Ingo
