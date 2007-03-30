Return-Path: <linux-kernel-owner+w=401wt.eu-S1753949AbXC3Qzg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949AbXC3Qzg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 12:55:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753951AbXC3Qzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 12:55:36 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55129 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753949AbXC3Qzf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 12:55:35 -0400
Date: Fri, 30 Mar 2007 18:55:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc5-mm3
Message-ID: <20070330165522.GA4808@elte.hu>
References: <20070330010559.2a232d9a.akpm@linux-foundation.org> <6bffcb0e0703300931n1fb83ad3j2f857a8959c470b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6bffcb0e0703300931n1fb83ad3j2f857a8959c470b@mail.gmail.com>
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


* Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:

> It's my lucky Friday, kernel hangs shortly after
> 
> PM: Removing info for No Bus:vcsa1
> PM: Adding info for No Bus:vcs1
> PM: Adding info for No Bus:vcsa1
> PM: Removing info for No Bus:vcs1
> PM: Removing info for No Bus:vcsa1
> PM: Adding info for No Bus:vcs1
> PM: Adding info for No Bus:vcsa1
> PM: Adding info for No Bus:rtc
> Real Time Clock Driver v1.12ac
> 
> due to
> 
> GOOD
> mm-only-hrtimers-debug-patch.patch
> mm-only-hrtimers-debug-patch-fix.patch
> BAD
> 
> patches. Both patches works fine for me in vanilla tree.

hm. now that's a mystery ... Any way to figure out where it hangs? 
nmi_watchdog=1/2, softlockup, etc?

	Ingo
