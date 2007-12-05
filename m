Return-Path: <linux-kernel-owner+w=401wt.eu-S1753086AbXLEQZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086AbXLEQZp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 11:25:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751565AbXLEQZh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 11:25:37 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54738 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751552AbXLEQZh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 11:25:37 -0500
Date: Wed, 5 Dec 2007 17:25:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Jie Chen <chen@jlab.org>, Simon Holm Th??gersen <odie@cs.aau.dk>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: Possible bug from kernel 2.6.22 and above, 2.6.24-rc4
Message-ID: <20071205162512.GA17994@elte.hu>
References: <4744966C.900@jlab.org> <4744ADA9.7040905@cosmosbay.com> <4744E0DC.7050808@jlab.org> <1195698770.11808.4.camel@odie.local> <4744F042.4070002@jlab.org> <20071204131707.GA4232@elte.hu> <4756C3D9.9030107@jlab.org> <20071205154014.GA6491@elte.hu> <4756CEEE.9050908@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4756CEEE.9050908@cosmosbay.com>
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


* Eric Dumazet <dada1@cosmosbay.com> wrote:

> $ gcc -O2 -o burner burner.c
> $ ./burner
> Time to perform the unit of work on one thread is 0.040328 s
> Time to perform the unit of work on 2 threads is 0.040221 s

ok, but this actually suggests that scheduling is fine for this, 
correct?

	Ingo
