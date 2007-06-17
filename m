Return-Path: <linux-kernel-owner+w=401wt.eu-S1760902AbXFQTHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760902AbXFQTHw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 15:07:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758182AbXFQTHm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 15:07:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36324 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760722AbXFQTHj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 15:07:39 -0400
Date: Sun, 17 Jun 2007 21:07:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pavel Machek <pavel@ucw.cz>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       parisc-linux@lists.parisc-linux.org, linux-mm@kvack.org,
       linux-arch@vger.kernel.org, Ollie Wild <aaw@google.com>,
       Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@suse.de>
Subject: Re: [patch 0/3] no MAX_ARG_PAGES -v2
Message-ID: <20070617190710.GA20682@elte.hu>
References: <20070613100334.635756997@chello.nl> <20070617183213.GA3892@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070617183213.GA3892@ucw.cz>
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


* Pavel Machek <pavel@ucw.cz> wrote:

> Hi!
> 
> > This patch-set aims at removing the current limit on argv+env space 
> > aka. MAX_ARG_PAGES.
> 
> Thanks a lot for solving this properly. I have been upping current 
> limits to some insane ammounts to work around this.

seconded! I have tried the patchset and it works great for me. This 
limitation of Linux has bothered me almost since i started using Linux 
more than a decade ago (i remember having run into it when running a 
script on an overly large directory), and it's perhaps the oldest still 
existing userspace-visible limitations of Linux. It was also a really 
hard nut to crack. Kudos Peter! I really cant wait to see this in 2.6.23
:-)

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
