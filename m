Return-Path: <linux-kernel-owner+w=401wt.eu-S932374AbZHZLRP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932374AbZHZLRP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 07:17:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932376AbZHZLRO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 07:17:14 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54080 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932443AbZHZLRO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 07:17:14 -0400
Date: Wed, 26 Aug 2009 13:17:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
       Vegard Nossum <vegard.nossum@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: WARNING: kmemcheck: Caught 32-bit read from uninitialized
	memory (f6f6e1a4), by kmemleak's scan_block()
Message-ID: <20090826111704.GA25485@elte.hu>
References: <20090825084808.GA14003@elte.hu> <1251190466.7261.12.camel@penberg-laptop> <19f34abd0908250203h52257f52v306545a3d8890577@mail.gmail.com> <1251191507.26351.0.camel@penberg-laptop> <1251192069.15678.21.camel@pc1117.cambridge.arm.com> <1251192415.26351.5.camel@penberg-laptop> <1251192534.15678.29.camel@pc1117.cambridge.arm.com> <84144f020908250231k30ff4e9do20856bd1291f418c@mail.gmail.com> <20090825093423.GA12935@elte.hu> <84144f020908260348reec91f3v514317f039058d4d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020908260348reec91f3v514317f039058d4d@mail.gmail.com>
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


* Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> On Tue, Aug 25, 2009 at 12:34 PM, Ingo Molnar<mingo@elte.hu> wrote:
> >> On Tue, Aug 25, 2009 at 12:28 PM, Catalin
> >> Marinas<catalin.marinas@arm.com> wrote:
> >> >> Does this look OK to you?
> >> >
> >> > For the kmemleak.c part:
> >> >
> >> > Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> >>
> >> Vegard? Ingo? The patch is based on tip/out-of-tree so it 
> >> probably should go to the kmemleak tree?
> >
> > I'm testing it currently - but yeah, i'd agree that it should go 
> > into the kmemleak tree, with a .32 merge date or so.
> 
> Ingo/Vegard, ACK/NAK? I don't want my amazingly good patch to end 
> up in /dev/null so can we just shove it in kmemleak.git?

ack from me.

	Ingo
