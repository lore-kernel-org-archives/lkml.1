Return-Path: <linux-kernel-owner+w=401wt.eu-S1758935AbXKMQrd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758935AbXKMQrd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 11:47:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754925AbXKMQrW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 11:47:22 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41033 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751963AbXKMQrU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 11:47:20 -0500
Date: Tue, 13 Nov 2007 17:46:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mark Lord <liml@rtr.ca>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, protasnb@gmail.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       alsa-devel@alsa-project.org, linux-ide@vger.kernel.org,
       linux-pcmcia@lists.infradead.org, linux-input@atrey.karlin.mff.cuni.cz,
       bugme-daemon@bugzilla.kernel.org
Subject: Re: [BUG] New Kernel Bugs
Message-ID: <20071113164650.GA28493@elte.hu>
References: <20071113031553.3c7b5c16.akpm@linux-foundation.org> <20071113.033946.114918709.davem@davemloft.net> <20071113034916.2556edd7.akpm@linux-foundation.org> <20071113.035824.40509981.davem@davemloft.net> <20071113041259.79c9a8c5.akpm@linux-foundation.org> <20071113134029.GA30978@elte.hu> <4739AFE0.20705@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4739AFE0.20705@rtr.ca>
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


* Mark Lord <liml@rtr.ca> wrote:

> Ingo Molnar wrote:
> ..
>> This is all QA-101 that _cannot be argued against on a rational basis_, 
>> it's just that these sorts of things have been largely ignored for years, 
>> in favor of the all-too-easy "open source means many eyeballs and that is 
>> our QA" answer, which is a _good_ answer but by far not the most 
>> intelligent answer! Today "many eyeballs" is simply not good enough and 
>> nature (and other OS projects) will route us around if we dont change.
> ..
>
> QA-101 and "many eyeballs" are not at all in opposition.

yes, absolutely so - that's why i used the "good" qualifier. "Good is 
not good enough" calls for additional efforts to make it more efficient, 
not for the abolition of the many eyeballs concept (which would be 
absurd). So what i wanted to say is that _sole_ reliance on the large 
numbers of eyeballs is a fundamental mistake. It's even sometimes used 
as an excuse to merge questionable stuff. "we'll find any bugs, many 
eyeballs will make bugs shallow". In reality the many eyeballs are not 
infinite, nor should they be taken for granted if they are used for 
bogus things. We have to make sure the eyeballs stay 'many', and we also 
have to make sure they are not wasted. It's a physical resource that 
must be intelligently handled. Its positive effects can be easily wasted 
and we do that today.

for example git-bisect was godsent. I remember that years ago bisection 
of a bug was a very laborous task so that it was only used as a final, 
last-ditch approach for really nasty bugs. Today we can autonomouly 
bisect build bugs via a simple shell command around "git-bisect run", 
without any human interaction! This freed up testing resources 
enormously and made bisection one of the _first_ things that are tried 
when bugs are met. We just need more of this (distros should offer 
pre-built kernel rpm 'farms' for every important commit point and 
automated tools for users to easily specify breakage points, without 
them having to install those kernels individually) , and everyone should 
be aware of the fact that we still suck (we merge too much crap and 
still dont have good enough tools to de-crappify what we merge) and that 
we are losing testers.

	Ingo
