Return-Path: <linux-kernel-owner+w=401wt.eu-S1755235AbYKCJqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755235AbYKCJqx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 04:46:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754622AbYKCJqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 04:46:45 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37415 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754652AbYKCJqo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 04:46:44 -0500
Date: Mon, 3 Nov 2008 10:46:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH] fix compile breakage caused by x86: add
	->pre_time_init to x86_quirks
Message-ID: <20081103094627.GB10400@elte.hu>
References: <1225400831.19324.21.camel@localhost.localdomain> <20081030222308.GM30303@elte.hu> <1225475246.3264.10.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225475246.3264.10.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> On Thu, 2008-10-30 at 23:23 +0100, Ingo Molnar wrote:
> > * James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> > 
> > > >From da69eaed98248bf4b29e94d62a4e01a5c3758669 Mon Sep 17 00:00:00 2001
> > > From: James Bottomley <James.Bottomley@HansenPartnership.com>
> > > Date: Wed, 29 Oct 2008 13:14:29 -0500
> > > Subject: [VOYAGER] x86: add voyager pre_time_init_hook
> > > 
> > > This was introduced by:
> > > 
> > > Author: Yinghai Lu <yhlu.kernel@gmail.com>
> > > Date:   Sat Jul 19 18:02:26 2008 -0700
> > > 
> > >     x86: add ->pre_time_init to x86_quirks
> > > 
> > > In theory, voyager could also make use of the x86_quirks hooks but,
> > > unfortunately, they're not set up correctly for that to happen yet.
> > 
> > okay, so how about setting them up that way instead? That way we win 
> > twice: it becomes a tiny bit easier to add Voyager support to the 
> > generic platform code, and we also fix the build breakage.
> 
> Sure, it should be possible ... but reworking the current quirk 
> infrastructure would definitely be an enhancement, whereas this is a 
> compile fix for 2.6.28-rc

but it's an ugly compile fix that just prolongues the pain that the 
subarch code has been inflicting on us for many cycles. Please fix the 
underlying problem properly - it should not be hard and it will 
definitely be cleaner end result.

	Ingo
