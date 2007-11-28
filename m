Return-Path: <linux-kernel-owner+w=401wt.eu-S1760687AbXK1O70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760687AbXK1O70 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 09:59:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753397AbXK1O7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 09:59:17 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50684 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751213AbXK1O7R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 09:59:17 -0500
Date: Wed, 28 Nov 2007 15:58:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Vlad Yasevich <vladislav.yasevich@hp.com>
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
       "David S. Miller" <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [build bug] SCTP, net/sctp/auth.c, ./net/rxrpc/ar-key.c fails
	to build
Message-ID: <20071128145804.GA23823@elte.hu>
References: <20071122153359.GA7268@elte.hu> <20071128124433.GA18378@elte.hu> <20071128124730.GA19498@elte.hu> <474D8820.5000000@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <474D8820.5000000@hp.com>
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
X-Mailing-List: linux-kernel@vger.kernel.org


* Vlad Yasevich <vladislav.yasevich@hp.com> wrote:

>>> this is a build regression over v2.6.23. config attached.
>>
>> the patch below fix it (or rather, works it around).
>>
>
> The patch is an OK workaround, but may not yield a working SCTP.
>
> Let me see if I can do better..

i'd be glad to test any patch. Note, the config was generated via 'make 
randconfig', for automated build and boot QA, and "working SCTP" is not 
something that is necessary for such a kernel to boot. So the workaround 
might be fine as well - not all config space combinations that are 
reachable via 'make randconfig' make "sense", but they should still 
build and boot fine.

	Ingo
