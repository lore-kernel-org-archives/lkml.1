Return-Path: <linux-kernel-owner+w=401wt.eu-S933100AbXCETbY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933100AbXCETbY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 14:31:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933157AbXCETbY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 14:31:24 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52717 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933100AbXCETbX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 14:31:23 -0500
Date: Mon, 5 Mar 2007 20:30:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Daniel Walker <dwalker@mvista.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Emil Karlson <jkarlson@cc.hut.fi>,
       "Michael S. Tsirkin" <mst@mellanox.co.il>,
       Soeren Sonnenburg <kernel@nn7.de>
Subject: Re: [5/6] 2.6.21-rc2: known regressions
Message-ID: <20070305193025.GB26065@elte.hu>
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org> <20070305015040.GJ3441@stusta.de> <20070305075747.GA19838@elte.hu> <20070305001358.2eebbfae.akpm@linux-foundation.org> <1173108303.31337.18.camel@imap.mvista.com> <20070305152749.GA22258@elte.hu> <1173112936.31337.26.camel@imap.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1173112936.31337.26.camel@imap.mvista.com>
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


* Daniel Walker <dwalker@mvista.com> wrote:

> I used this simple test case given by you a long time ago,
> 
> main ()
> {
> iopl(3);
> for (;;) 
>         asm("cli");
> 
> }
> 
> This doesn't look like a regression tho, 2.6.19-rc6 has the same 
> behavior ..

hm, so this doesnt get detected as a lockup at all? That's bad and needs 
fixing ...

	Ingo
