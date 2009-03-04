Return-Path: <linux-kernel-owner+w=401wt.eu-S1755624AbZCDKeb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755624AbZCDKeb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 05:34:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750896AbZCDKeX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 05:34:23 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49174 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750768AbZCDKeX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 05:34:23 -0500
Date: Wed, 4 Mar 2009 11:34:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Tejun Heo <tj@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: 32bit panic on 4 sockets
Message-ID: <20090304103405.GA4879@elte.hu>
References: <86802c440903031458p4a72f8c8x6f91e9f58ac6bc26@mail.gmail.com> <86802c440903031751y136b506uc163dd2c9023de9b@mail.gmail.com> <49ADE201.7010506@kernel.org> <86802c440903032257l6607972dqe2390958b18454bd@mail.gmail.com> <1236155659.5330.6837.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236155659.5330.6837.camel@laptop>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Tue, 2009-03-03 at 22:57 -0800, Yinghai Lu wrote:
> > On Tue, Mar 3, 2009 at 6:05 PM, Tejun Heo <tj@kernel.org> wrote:
> > > Looks like a genuine bootmem bug.  Cc'ing Johannes and
> > > quoting whole body.
> > 
> > it is x86 32bit numa code problem. it assume bootmem will 
> > sit on first node only.
> 
> Seems a bit daft to run a 32bit kernel on such a machine.. at 
> some point we should just give up and not push this 32 bit 
> madness any further.

it works just fine on a lot of systems - and since we keep 
unifying a lot of these codepaths we are better off keeping it 
all working.

	Ingo
