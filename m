Return-Path: <linux-kernel-owner+w=401wt.eu-S1758333AbYBMM2v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758333AbYBMM2v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 07:28:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753914AbYBMM2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 07:28:43 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48150 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752919AbYBMM2m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 07:28:42 -0500
Date: Wed, 13 Feb 2008 13:28:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alessandro Suardi <alessandro.suardi@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: 2.6.24-git2: Oracle 11g VKTM process enters R state on startup
	and is unkillable [still broken in 2.6.25-rc1]
Message-ID: <20080213122825.GA5722@elte.hu>
References: <5a4c581d0802110820l1fcbb1ffib874f268b4ab7eae@mail.gmail.com> <20080211204921.GA24806@elte.hu> <20080211221034.GA2587@elte.hu> <200802120012.35314.rjw@sisk.pl> <5a4c581d0802111531qf6fe2d0tf4878caefef958d3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5a4c581d0802111531qf6fe2d0tf4878caefef958d3@mail.gmail.com>
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


* Alessandro Suardi <alessandro.suardi@gmail.com> wrote:

> > > ok, we just found the reason for the 8-way crash, the delta fix 
> > > from Peter is below if any of you have tried the previous combo 
> > > patch. Updated sched.git as well, new HEAD is 
> > > fec13e45305d69fd0bd23b30bd05a0a42cf341f8.
> >
> > With the previous patch and this patch applied, the issue is not 
> > reproducible here.
> 
> The problem is fixed for me as well with the previous patch + the 
> patch below, VKTM now enters S state and Oracle shuts down properly 
> again.

thanks alot for testing this. The scheduler queue is now looking good in 
testing, will probably send a pull request to Linus later today.

	Ingo
