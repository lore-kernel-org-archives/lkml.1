Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1751794AbYLROeN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751794AbYLROeN (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 09:34:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751826AbYLROdp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 09:33:45 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:33434 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751762AbYLROdo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 09:33:44 -0500
Date: Thu, 18 Dec 2008 15:33:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh <jaswinderlinux@gmail.com>
Cc: Jaswinder Singh <jaswinder@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] x86: traps.c declare functions before they get used
Message-ID: <20081218143335.GA10548@elte.hu>
References: <1229360145.15326.5.camel@jaswinder.satnam> <20081216201956.GA14505@elte.hu> <3f9a31f40812162028j5a0e12f5h2215daae12ce3441@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f9a31f40812162028j5a0e12f5h2215daae12ce3441@mail.gmail.com>
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


* Jaswinder Singh <jaswinderlinux@gmail.com> wrote:

> Hello Ingo,
> 
> On Wed, Dec 17, 2008 at 1:49 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >> +#ifndef CONFIG_MATH_EMULATION
> >>  asmlinkage void math_emulate(long);
> >>  #endif
> >
> > uhm, shouldnt that #ifndef CONFIG_MATH_EMULATION be #ifdef
> > CONFIG_MATH_EMULATION?
> >
> 
> Sorry, but it seems correct to me in traps case will be opposite.
> 
> If someone tries to access math_emulate() and MATH_EMULATION is not 
> defined then he will be trapped ;-)

you should build-test your patch with MATH_EMULATION enabled.

	Ingo
