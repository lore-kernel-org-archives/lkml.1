Return-Path: <linux-kernel-owner+w=401wt.eu-S1754323AbYAVMj6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754323AbYAVMj6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 07:39:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752486AbYAVMjt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 07:39:49 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52521 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752781AbYAVMjs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 07:39:48 -0500
Date: Tue, 22 Jan 2008 13:39:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: what's up for v2.6.25 in x86.git
Message-ID: <20080122123932.GB7304@elte.hu>
References: <20080121201437.GA31469@elte.hu> <200801221213.53490.nickpiggin@yahoo.com.au> <200801221228.21404.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801221228.21404.nickpiggin@yahoo.com.au>
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


* Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> On Tuesday 22 January 2008 12:13, Nick Piggin wrote:
> > On Tuesday 22 January 2008 07:14, Ingo Molnar wrote:
> > > Nick Piggin (5):
> > >       mm: fix PageUptodate memory ordering bug
> >
> > This should actually be named differently. It should be
> > called
> >
> > x86: don't unconditionally enable expensive SMP ppro workaround
> >
> > I actually had a more complete patch which printed a warning if
> > booting such a system without the config option.
> 
> Ah sorry, here is a refreshed version

looks good to me, but could you please send a delta patch against 
x86.git:

    http://redhat.com/~mingo/x86.git/README

and i'll backmerge it to your other patch (with the subject fixed, etc.) 
once it passes qa, etc. Thanks,

	Ingo
