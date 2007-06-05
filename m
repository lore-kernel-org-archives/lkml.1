Return-Path: <linux-kernel-owner+w=401wt.eu-S1764018AbXFEJYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764018AbXFEJYQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 05:24:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761905AbXFEJYE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 05:24:04 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41507 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761487AbXFEJYB (ORCPT <rfc822;Linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 05:24:01 -0400
Date: Tue, 5 Jun 2007 11:23:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Matt Mackall <mpm@selenic.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, akpm@linux-foundation.org,
       Linux-kernel@vger.kernel.org
Subject: Re: Interesting interaction between lguest and CFS
Message-ID: <20070605092344.GA20600@elte.hu>
References: <20070604173710.GR11166@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070604173710.GR11166@waste.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Matt Mackall <mpm@selenic.com> wrote:

> Ok, my transcoding just finished as I was writing this. So I've 
> reproduced the problem with this Python script that I had handy:
> 
> memload.py:
> #!/usr/bin/python
> a = "a" * 16 * 1024 * 1024
> while 1:
>     b = a[1:] + "b"
>     a = b[1:] + "c"

i suspect the same latency is triggered by a simple infinite loop too:

	while : ; do : ; done &

correct?

	Ingo
