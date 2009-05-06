Return-Path: <linux-kernel-owner+w=401wt.eu-S1760509AbZEFU1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760509AbZEFU1q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 16:27:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759922AbZEFU1c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 16:27:32 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48248 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760473AbZEFU1b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 16:27:31 -0400
Date: Wed, 6 May 2009 22:25:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Matt Mackall <mpm@selenic.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>, Jake Edge <jake@lwn.net>,
       security@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       James Morris <jmorris@namei.org>, linux-security-module@vger.kernel.org,
       Eric Paris <eparis@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Roland McGrath <roland@redhat.com>, mingo@redhat.com,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Dave Jones <davej@redhat.com>
Subject: Re: [Security] [PATCH] proc: avoid information leaks to
	non-privileged processes
Message-ID: <20090506202517.GA27544@elte.hu>
References: <20090504125124.0f469970@infradead.org> <m1vdogbows.fsf@fess.ebiederm.org> <alpine.LFD.2.01.0905041514350.4983@localhost.localdomain> <20090505055011.GE31071@waste.org> <20090505063156.GA24504@elte.hu> <m14ow0ynjm.fsf@fess.ebiederm.org> <20090505195246.GC21973@elte.hu> <20090505202219.GL31071@waste.org> <20090506103034.GA25203@elte.hu> <20090506162543.GT31071@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090506162543.GT31071@waste.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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


* Matt Mackall <mpm@selenic.com> wrote:

> On Wed, May 06, 2009 at 12:30:34PM +0200, Ingo Molnar wrote:
> > (Also, obviously "only" covering 95% of the Linux systems has its 
> > use as well. Most other architectures have their own cycle counters 
> > as well.)
> 
> X86 might be 95% of desktop. But it's a small fraction of Linux 
> systems once you count cell phones, video players, TVs, cameras, 
> GPS devices, cars, routers, etc. almost none of which are 
> x86-based. In fact, just Linux cell phones (with about an 8% share 
> of a 1.2billion devices per year market) dwarf Linux desktops 
> (maybe 5% of a 200m/y market).

Firstly, the cycle counter is just one out of several layers there. 
So it's a hyperbole to suggest that i'm somehow not caring about 
architectures that dont have a cycle counter. I'm simply making use 
of a cheaply accessed and fast-changing variable on hw that has it.

Also, are those systems really going to be attacked locally, 
brute-forcing a PRNG? Servers and desktops are the more likely 
targets. They both have the necessary computing power to run 
statistical analysis locally fast enough and have an actual value to 
be attacked.

And, even if we ignored those factors, ad argumendo, you would still 
be wrong IMHO: what matters really in this context isnt even any 
artificial 'share' metric - but the people willing to improve and 
fix the upstream kernel, and the reasons why they do that, and the 
platforms they use.

And amongst our contributors and testers, willing to run and improve 
the latest upstream kernel, x86 has a larger than 95% share. Look at 
kerneloops.org stats. Or bugzilla. Or lkml.

If embedded matters that much, make it show up as a real factor on 
those upstream forums. Lets call this Ingo's Law: if something 
doesnt improve the upstream kernel, directly or indirectly, it does 
not exist ;-)

	Ingo
