Return-Path: <linux-kernel-owner+w=401wt.eu-S1760045AbXEUI2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760045AbXEUI2y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 04:28:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755689AbXEUI2r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 04:28:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40441 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755251AbXEUI2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 04:28:47 -0400
Date: Mon, 21 May 2007 10:28:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: kernel@prachanda.info, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       tglx@linutronix.de
Subject: Re: bad networking related lag in v2.6.22-rc2
Message-ID: <20070521082805.GA17740@elte.hu>
References: <20070518102607.GA23151@elte.hu> <200705200246.22444.kernel@prachanda.hub> <20070521075824.GA11198@elte.hu> <20070521.012541.112621369.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070521.012541.112621369.davem@davemloft.net>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* David Miller <davem@davemloft.net> wrote:

> From: Ingo Molnar <mingo@elte.hu>
> Date: Mon, 21 May 2007 09:58:24 +0200
> 
> > what does 'top' show during an upload? Is any system related task
> > out of whack? Could you try to get a readprofile or an oprofile
> > output from the kernel, so that we can see what is slowing it down
> > so much? It could be something networking related in v2.6.22-rc2.
> 
> There is a driver specific problem that's been around for a while, but 
> it only effects 3c59x chips, is that what you have?

the problem first showed up in v2.6.22-rc1 and he didnt have it in 
v2.6.21 - does that still qualify his box for the 3c59x problem?

	Ingo
