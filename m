Return-Path: <linux-kernel-owner+w=401wt.eu-S1756960AbZDPAvJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756960AbZDPAvJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 20:51:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753296AbZDPAu4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 20:50:56 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44235 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752902AbZDPAuz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 20:50:55 -0400
Date: Thu, 16 Apr 2009 02:50:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, hpa@zytor.com,
       tglx@linutronix.de, rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
       davej@redhat.com
Subject: Re: Fix quilt merge error in acpi-cpufreq.c
Message-ID: <20090416005025.GA2779@elte.hu>
References: <49E62BD5.6090508@zytor.com> <alpine.LFD.2.00.0904151241490.4132@localhost.localdomain> <20090415133255.b6a33bfe.akpm@linux-foundation.org> <20090415210353.GA27368@elte.hu> <alpine.LFD.2.00.0904151406380.4042@localhost.localdomain> <20090415224017.GA18764@elte.hu> <alpine.LFD.2.00.0904151607010.4042@localhost.localdomain> <20090416000841.GA18185@elte.hu> <alpine.LFD.2.00.0904151717040.4042@localhost.localdomain> <alpine.LFD.2.00.0904151736140.4042@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904151736140.4042@localhost.localdomain>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Wed, 15 Apr 2009, Linus Torvalds wrote:
> > 
> > wouldn't you agree? Adding a "Impact: cleanup" wouldn't do 
> > anything to it, except make it not read as good English any 
> > more.
> > 
> > I like seeing explanations that read well.
> 
> Btw, I suspect that if the "Impact:" line is at the end, along 
> with the "Signed-off-by:" etc lines, it wouldn't be as disturbing 
> and I wouldn't react as negatively to it.
> 
> At least then it wouldn't break up the narrative, and it would 
> kind of fit with all the other "tagged" lines.

Yeah, that makes sense.

Or perhaps make it fit into the narrative but still have a 
recognizable structure to make sure it cannot be forgotten?

Something like:

 The impact of this change is that the build is fixed.
 The impact of this change is that the code gets cleaner.
 The impact of this change is that the CPU does not overheat.

although this sounds extremely artificial, circumvent and childish 
to me :-/

I guess i'm infected with the "Impact: " language already and my 
brain resists lingual inefficiencies ;-/ We've been using it for 
almost a year meanwhile.

	Ingo
