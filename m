Return-Path: <linux-kernel-owner+w=401wt.eu-S1756625AbYHKTvs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756625AbYHKTvs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 15:51:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752079AbYHKTvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 15:51:40 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34491 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751708AbYHKTvj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 15:51:39 -0400
Date: Mon, 11 Aug 2008 21:51:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Alan Mayer <ajm@sgi.com>, jeremy@goop.org, rusty@rustcorp.com.au,
       suresh.b.siddha@intel.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, Dean Nelson <dcn@sgi.com>,
       Cliff Wickman <cpw@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <Yinghai.lu@amd.com>
Subject: Re: [PATCH] x86_64:  (NEW) Dynamically allocate arch specific
	system vectors
Message-ID: <20080811195102.GL12788@elte.hu>
References: <489C6844.9050902@sgi.com> <20080811165930.GI4524@elte.hu> <48A0737F.9010207@sgi.com> <m1y733mjdh.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1y733mjdh.fsf@frodo.ebiederm.org>
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


* Eric W. Biederman <ebiederm@xmission.com> wrote:

> Alan Mayer <ajm@sgi.com> writes:
> 
> > Okay, here it is as an attachment.  I think my email client is munging it.
> > I haven't been able to fix it, apparently.
> >
> > I, too, would like to know what Eric thinks.
> 
> I think arch/x86 is about to fall over from accidental complexity of 
> the irq handling. [...]

it was in that state for many years already ;-) Unification, cleanups of 
other historic messes and the constant push for new hw support just made 
it stand out more visibly. IRQ and APIC code unification is definitely 
the final (and by far hardest) major step of x86 unification.

> [...]  Looking at your problem and the problem of killing NR_IRQS I 
> spent way to much time playing with it this weekend then I should 
> have, but I think I have found a path that works and is fairly easily 
> verifiable.

cool :-)

> I have a patch series that gets me 90% of the way there, and the rest 
> appears easy but I don't have any time to mess with it right now.  I 
> will try and post it something in the next couple of days.

i'm very interested in it, even if it's incomplete and wont build/boot 
at all. So please consider posting your existing incomplete series as an 
RFC right now, maybe we can help finish it sooner than you will find the 
time? We can put it into a new tip/x86/irq-unification branch, without 
merging it into tip/master just yet.

	Ingo
