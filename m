Return-Path: <linux-kernel-owner+w=401wt.eu-S1753847AbXLSR4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847AbXLSR4i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 12:56:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751902AbXLSR4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 12:56:30 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53926 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751896AbXLSR4a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 12:56:30 -0500
Date: Wed, 19 Dec 2007 18:56:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Parag Warudkar <parag.warudkar@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, ak@suse.de,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: Fix DMI out of memory problems
Message-ID: <20071219175604.GA7029@elte.hu>
References: <Pine.LNX.4.64.0712181848430.3663@mini.warudkars.net> <20071219104823.GI3521@elte.hu> <82e4877d0712190848r4168b3dp80e53fdcd7c82ce5@mail.gmail.com> <20071219165420.GA15291@elte.hu> <82e4877d0712190900y17670831k51429996f78e954a@mail.gmail.com> <20071219170631.GA18353@elte.hu> <82e4877d0712190909y6b449e0cgee3ba7363cd5e85b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <82e4877d0712190909y6b449e0cgee3ba7363cd5e85b@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Parag Warudkar <parag.warudkar@gmail.com> wrote:

> On Dec 19, 2007 12:06 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Parag Warudkar <parag.warudkar@gmail.com> wrote:
> >
> > > Here is the right one -
> > > 2.6.24-rc5  is without patch, 2.6.24-rc5-new is with patch.
> >
> > >  DMI present.
> > > -dmi_save_oem_strings_devices: out of memory.
> > > -dmi_string: out of memory.
> >
> > ok. I guess absent a real regression/bug reported by someone who gets
> > these messages, we can do your patches in 2.6.25. DMI stuff is quite
> > hardware dependent so it's hard to get the code tested well.
> >
> 
> Yep, I agree.
> 
> Andrew if you want to keep it in -mm till 2.6.25 - that'd hopefully 
> give it some testing.

i've added it to x86.git - that gets included in -mm.

	Ingo
