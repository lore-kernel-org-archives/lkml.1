Return-Path: <linux-kernel-owner+w=401wt.eu-S1756881AbYGZRg2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756881AbYGZRg2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 13:36:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753552AbYGZRgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 13:36:18 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46309 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753445AbYGZRgS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 13:36:18 -0400
Date: Sat, 26 Jul 2008 19:34:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Patrick McHardy <kaber@trash.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       David Miller <davem@davemloft.net>, herbert@gondor.apana.org.au,
       w@1wt.eu, davidn@davidnewall.com, torvalds@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       stefanr@s5r6.in-berlin.de, rjw@sisk.pl, ilpo.jarvinen@helsinki.fi,
       Dave Jones <davej@redhat.com>
Subject: Re: [regression] nf_iterate(), BUG: unable to handle kernel NULL
	pointer dereference
Message-ID: <20080726173450.GA2242@elte.hu>
References: <20080724115957.GA25701@elte.hu> <48886FA6.6050908@trash.net> <84144f020807240544q507e1b7cv220d1afbae0ee0f0@mail.gmail.com> <48887A71.5010209@trash.net> <1216905812.5897.6.camel@penberg-laptop> <48888434.3030207@trash.net> <1216906476.12021.4.camel@penberg-laptop> <20080724115127.6cfbb616.akpm@linux-foundation.org> <20080724193532.GC1694@elte.hu> <488B4C1D.3020506@trash.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <488B4C1D.3020506@trash.net>
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


* Patrick McHardy <kaber@trash.net> wrote:

> Ingo Molnar wrote:
>> * Andrew Morton <akpm@linux-foundation.org> wrote:
>>
>>> Ingo, did this patch actually fix something over there?
>>
>> not that i know of. I'll do some re-tests tomorrow to make sure.
>
> I managed to reproduce the bug you reported, but it reliably goes away 
> if I add Pekka's patch. Did you get a chance to retest already?

not yet - please consider it fixed, i'll let you know if something 
similar to that occurs.

	Ingo
