Return-Path: <linux-kernel-owner+w=401wt.eu-S1754015AbYJBJok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015AbYJBJok (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 05:44:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752794AbYJBJoc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 05:44:32 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56683 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752623AbYJBJoc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 05:44:32 -0400
Date: Thu, 2 Oct 2008 11:43:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frank Mayhar <fmayhar@google.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [PATCH 2.6.27-rc5 incremental re-resubmit] Fix itimer/many
	thread hang.
Message-ID: <20081002094352.GB20569@elte.hu>
References: <20080914150923.GB26984@elte.hu> <1221502142.19012.35.camel@bobble.smo.corp.google.com> <20080916084143.GC17287@elte.hu> <1221678187.13420.17.camel@bobble.smo.corp.google.com> <20080918102353.GD20967@elte.hu> <1222114936.21579.20.camel@bobble.smo.corp.google.com> <1222291416.30299.6.camel@bobble.smo.corp.google.com> <20080930063313.GA23690@elte.hu> <1222792590.18031.9.camel@bobble.smo.corp.google.com> <1222878038.29322.2.camel@bobble.smo.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1222878038.29322.2.camel@bobble.smo.corp.google.com>
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


* Frank Mayhar <fmayhar@google.com> wrote:

> On Tue, 2008-09-30 at 09:36 -0700, Frank Mayhar wrote:
> > I'm picking up tip/master right now and will test your fix for this
> > shortly.
> 
> Okay, I've put it through its paces and everything appears to be 
> working well with Ingo's fix.

great, thanks for checking!

it has not caused any new problems in -tip testing either, and that 
means a couple of thousand test builds and test boots so far in the past 
week, so we've got the usual codepaths covered pretty well. With your 
test of the less common codepaths we should be pretty good in general.

	Ingo
