Return-Path: <linux-kernel-owner+w=401wt.eu-S1752734AbYJ0Mzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734AbYJ0Mzl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 08:55:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751305AbYJ0Mzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 08:55:33 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44294 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750846AbYJ0Mzd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 08:55:33 -0400
Date: Mon, 27 Oct 2008 13:55:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>,
       Mike Travis <travis@sgi.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -tip/cpus4096-v2] cpumask: fix cpumask of
	call_function_data
Message-ID: <20081027125512.GD12461@elte.hu>
References: <49015358.9050308@ct.jp.nec.com> <200810242215.19440.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810242215.19440.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0045]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rusty Russell <rusty@rustcorp.com.au> wrote:

> On Friday 24 October 2008 15:47:20 Hiroshi Shimamoto wrote:
> > From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> 
> Ingo, because of these concerns I recommend you revert 
> d4de5ac3b5e70928c86e3e5ac311f16cbf2e9ab3 (cpumask: 
> smp_call_function_many()) for now, and apply this less contentious 
> version.

ok - applied it to tip/cpus4096-v2, thanks Rusty!

If there's any chance for this in v2.6.28 then only if we disable the 
dynamic API branch altogether [CONFIG_MAXCPUS] and keep that for 
v2.6.29. This means we'd bring in the API changes which should have 
trivial impact only - and none of the riskier changes.

Hm?

Andrew, have we missed the boat on this?

	Ingo
