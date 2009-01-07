Return-Path: <linux-kernel-owner+w=401wt.eu-S1759553AbZAGSt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759553AbZAGSt0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 13:49:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753321AbZAGStR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 13:49:17 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59367 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751732AbZAGStQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 13:49:16 -0500
Date: Wed, 7 Jan 2009 19:48:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Cc: Jaswinder Singh Rajput <jaswinder@infradead.org>,
       x86 maintainers <x86@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, James.Bottomley@hansenpartnership.com,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip 0/7] x86: move NON-SMP data from smp.h
Message-ID: <20090107184852.GB16193@elte.hu>
References: <1231329368.17961.29.camel@jaswinder.satnam> <20090107125152.GA3529@elte.hu> <20090107133327.GA4911@elte.hu> <3f9a31f40901070557r336020dctbe9549e8634b167@mail.gmail.com> <20090107150351.GB27606@elte.hu> <20090107151223.GA4899@elte.hu> <20090107151522.GA5341@elte.hu> <1231344766.3770.12.camel@jaswinder.satnam> <20090107173509.GD24982@elte.hu> <3f9a31f40901071043u5a112962l2dd7e1d88de8aae2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3f9a31f40901071043u5a112962l2dd7e1d88de8aae2@mail.gmail.com>
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


* Jaswinder Singh Rajput <jaswinderlinux@gmail.com> wrote:

> On Wed, Jan 7, 2009 at 11:05 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Jaswinder Singh Rajput <jaswinder@infradead.org> wrote:
> >
> >> I send new 4 patches:
> >>
> >> ﻿[PATCH -tip 1/4 V2] x86: smp.h move stack_processor_id declartion to cpu.h
> >> ﻿[PATCH -tip 2/4 V2] x86: smp.h move safe_smp_processor_id declartion to cpu.h
> >> ﻿[PATCH -tip 3/4 V2] x86: smp.h move cpu_physical_id declartion to cpu.h
> >> ﻿[PATCH -tip 4/4 V2] x86: smp.h move boot_cpu_id declartion to cpu.h
> >>
> >> Please accept them.
> >
> > Just to make sure: they should solve the 3 failures i reported?
> >
> 
> Yes.

ok, great.

> I am sorry for earlier errors messages.

no need to be sorry about that - we knew that this is a spaghetti of 
historic dependencies. We'll likely need a few more tries before we reach 
the desired end result.

	Ingo
