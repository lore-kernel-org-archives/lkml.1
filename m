Return-Path: <linux-kernel-owner+w=401wt.eu-S1757294AbYJWQGq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757294AbYJWQGq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 12:06:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755122AbYJWQGc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 12:06:32 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42185 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751746AbYJWQGb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 12:06:31 -0400
Date: Thu, 23 Oct 2008 18:06:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Mike Travis <travis@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [bug #2] Re: [PATCH 00/35] cpumask: Replace cpumask_t with
	struct cpumask
Message-ID: <20081023160610.GA8853@elte.hu>
References: <20081023020826.051012000@polaris-admin.engr.sgi.com> <20081023125529.GA18327@elte.hu> <20081023142025.GA18804@elte.hu> <200810240201.15037.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810240201.15037.rusty@rustcorp.com.au>
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


* Rusty Russell <rusty@rustcorp.com.au> wrote:

> On Friday 24 October 2008 01:20:25 Ingo Molnar wrote:
> > Thomas has started a -tip cross-build test, and there's massive
> > cross-build failures as well due to the cpumask changes:
> 
> Yes.  linux-next reported the same thing.  I've backed out various 
> arch changes for this reason.
>
> > it seems to me that this commit is massively borked:
> >
> >   4a792c2: cpumask: make CONFIG_NR_CPUS always valid
> 
> Yep.  This is the big one I dropped.  There are a few others; Mike is 
> just porting the changes across to your tree now.

guys. I already spent hours integrating the "latest" of this stuff today 
and established baseline quality for it on x86. I've dropped 4a792c2 and 
pushed out a new tip/cpus4096-v2, please send append-only patches for 
the rest of the changes.

	Ingo
