Return-Path: <linux-kernel-owner+w=401wt.eu-S1754898AbZGCJbH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898AbZGCJbH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 05:31:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752972AbZGCJa4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 05:30:56 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41740 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752952AbZGCJaz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 05:30:55 -0400
Date: Fri, 3 Jul 2009 11:30:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Arjan van de Ven <arjan@infradead.org>, Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Anton Blanchard <anton@samba.org>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 1/2 -tip] perf_counter: Add generalized hardware
	vectored co-processor support for AMD and Intel Corei7/Nehalem
Message-ID: <20090703093032.GI3902@elte.hu>
References: <1246440815.3403.3.camel@hpdv5.satnam> <1246440909.3403.5.camel@hpdv5.satnam> <1246440977.3403.7.camel@hpdv5.satnam> <1246441043.3403.9.camel@hpdv5.satnam> <20090701112007.GD15958@elte.hu> <20090701112704.GF15958@elte.hu> <1246448441.6940.3.camel@hpdv5.satnam> <20090701114928.GI15958@elte.hu> <1246527872.13659.2.camel@hpdv5.satnam> <1246606736.2322.9.camel@jaswinder.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246606736.2322.9.camel@jaswinder.satnam>
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

> > $ ./perf list shows vector events like :
> > 
> >   vec-adds OR add                          [Hardware vector event]
> >   vec-muls OR multiply                     [Hardware vector event]
> >   vec-divs OR divide                       [Hardware vector event]
> >   vec-idle-cycles OR vec-empty-cycles      [Hardware vector event]
> >   vec-stall-cycles OR vec-busy-cycles      [Hardware vector event]
> >   vec-ops OR vec-operations                [Hardware vector event]

btw., why does this printout SHOUT the 'or'? It's certainly not an 
important piece of information. Something like:

   vec-adds | add                          [Hardware vector event]
   vec-muls | multiply                     [Hardware vector event]
   vec-divs | divide                       [Hardware vector event]
   vec-idle-cycles | vec-empty-cycles      [Hardware vector event]
   vec-stall-cycles | vec-busy-cycles      [Hardware vector event]
   vec-ops | vec-operations                [Hardware vector event]

looks better on all levels.

	Ingo
