Return-Path: <linux-kernel-owner+w=401wt.eu-S1764625AbXKTVxw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764625AbXKTVxw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 16:53:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756388AbXKTVx1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 16:53:27 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48413 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753344AbXKTVxZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 16:53:25 -0500
Date: Tue, 20 Nov 2007 22:53:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Fabio Comolli <fabio.comolli@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch/backport] CFS scheduler, -v24, for v2.6.24-rc3,
	v2.6.23.8, v2.6.22.13, v2.6.21.7
Message-ID: <20071120215313.GD24156@elte.hu>
References: <20071119151756.GA25446@elte.hu> <b637ec0b0711201238i746ca9bala3812ca93479c6fa@mail.gmail.com> <20071120204103.GC10008@elte.hu> <b637ec0b0711201247m4038a2cds5924ddbd43db6f8e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b637ec0b0711201247m4038a2cds5924ddbd43db6f8e@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Fabio Comolli <fabio.comolli@gmail.com> wrote:

> Hi
> 
> On Nov 20, 2007 9:41 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Fabio Comolli <fabio.comolli@gmail.com> wrote:
> >
> > > Hi.
> > > First, thanks for this patch. I don't have numbers but working with my
> > > laptop feels much better.
> >
> > curious: what scheduler/kernel version have you used before?
> 
> I was using 2.6.23.1 with ck patches.

are you sure? The last -ck patch i can find is for .22:

  http://www.kernel.org/pub/linux/kernel/people/ck/patches/2.6/

or have they been forward ported? (if yes, do you have an URL for that)

(my guess is you used the 2.6.23.1 scheduler (CFS), so the improvement 
you felt on the laptop is relative to 2.6.23-vanilla in essence - which 
is good news.)

> > > Just a question: does the patch include the fix (divide by 
> > > zero....) you just posted in the stable review for 2.6.23.9?
> >
> > yeah.
> 
> OK, thanks. Have you already tried to apply the patch to 2.6.23.9? 
> Shall we expect some other rejects?

hm:

The latest stable version of the Linux kernel is:           2.6.23.8

so there's no 23.9 yet.

	Ingo
