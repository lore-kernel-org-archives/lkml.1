Return-Path: <linux-kernel-owner+w=401wt.eu-S1757148AbZBTLHi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757148AbZBTLHi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 06:07:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751389AbZBTLH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 06:07:28 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56883 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281AbZBTLH1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 06:07:27 -0500
Date: Fri, 20 Feb 2009 12:06:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Gleb Natapov <gleb@redhat.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, Yinghai Lu <yinghai@kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: enable x2apic early at the first point
Message-ID: <20090220110651.GH28581@elte.hu>
References: <499DD40F.40102@kernel.org> <1235081612.14523.23.camel@vayu> <499DE05A.40804@kernel.org> <1235086118.14523.40.camel@vayu> <20090220083528.GB24555@elte.hu> <20090220090912.GA4632@redhat.com> <20090220094123.GJ24555@elte.hu> <20090220105804.GA24826@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090220105804.GA24826@redhat.com>
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


* Gleb Natapov <gleb@redhat.com> wrote:

> On Fri, Feb 20, 2009 at 10:41:23AM +0100, Ingo Molnar wrote:
> > 
> > * Gleb Natapov <gleb@redhat.com> wrote:
> > 
> > > > > I will post couple of patches, which revert's Gleb's patch 
> > > > > and another fix for the early boot failure issue, 
> > > > > tomorrow.
> > > 
> > > If you'll revert my patch it will not be possible to use 
> > > x2apic in KVM (at least without KVM implementing interrupt 
> > > remapping which is unneeded otherwise) and x2apic interface is 
> > > much better for vitalization. Instead of reverting the patch 
> > > it will be better to add check if x2apic can be used without 
> > > intr-remmaping (all CPUs belong to cluster 0) or allow 
> > > enabling of x2apic without IR if running as a guest.
> > 
> > yep, that would be required - because your patch can break real 
> > systems right now. Mind sending me a fix for it?
> > 
> > I've applied Yinghai's fix as well, so please base it on latest 
> > tip:master.
> > 
> OK. Will send next week.

ok, that's too long of a breakage window - i'll revert it then, 
please send a new version once you have it.

Thanks,

	Ingo
