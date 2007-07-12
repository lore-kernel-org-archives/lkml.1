Return-Path: <linux-kernel-owner+w=401wt.eu-S965088AbXGLA2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965088AbXGLA2z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 20:28:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964974AbXGLASa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 20:18:30 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40968 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964950AbXGLASZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 20:18:25 -0400
Date: Thu, 12 Jul 2007 02:18:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: x86 status was Re: -mm merge plans for 2.6.23
Message-ID: <20070712001807.GB1946@elte.hu>
References: <p734pkbyuu4.fsf@bingen.suse.de> <20070711174252.GA16793@elte.hu> <alpine.LFD.0.999.0707111438530.20061@woody.linux-foundation.org> <1184191488.12353.160.camel@chaos> <alpine.LFD.0.999.0707111518020.20061@woody.linux-foundation.org> <1184194219.12353.170.camel@chaos> <alpine.LFD.0.999.0707111558250.20061@woody.linux-foundation.org> <20070711233618.GD25510@one.firstfloor.org> <20070711235852.GA625@elte.hu> <20070712000720.GA26585@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070712000720.GA26585@one.firstfloor.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> > i dont think "clean, modern x86 code" will ever happen - x86_64 has 
> > and is going to have the exact same type of crap. And i'll say a 
> > weird thing
> 
> Yes, but it will be new crap, but no old crap anymore.
> 
> If you always pile the new crap on the old crap at some point the 
> whole thing might fall over. 64bit was intended as a fresh start.

I think there's no such thing as a fresh start for a diverse 
architecture - the ia64 failure has proven that. x86_64 CPUs still do 
A20 emulation today (!). We still have people running industrial boards 
on real i386 DX CPUs, with the latest upstream kernel. 15 years ago an 
i386 DX was already quite obsolete. 32-bit is not going to go away in 
our lifetime, and we'll want to support it in a first-grade way. We 
better realize that prospect and have it right before our eyes in a 
single tree wherever it makes sense to share code - i'm certainly not 
talking about sharing mtrr/centaur.c or k8.c. (and i'm not necessarily 
suggesting to share io_apic.c either - although it's certainly 
borderline.)

	Ingo
