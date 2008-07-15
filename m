Return-Path: <linux-kernel-owner+w=401wt.eu-S1757199AbYGOIfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757199AbYGOIfb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 04:35:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754710AbYGOIfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 04:35:23 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53775 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752709AbYGOIfW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 04:35:22 -0400
Date: Tue, 15 Jul 2008 10:35:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git pull] x86 changes for v2.6.27
Message-ID: <20080715083507.GB2600@elte.hu>
References: <20080714135034.GA7013@elte.hu> <alpine.LFD.1.10.0807141346170.3305@woody.linux-foundation.org> <alpine.LFD.1.10.0807141459440.2944@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0807141459440.2944@woody.linux-foundation.org>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Mon, 14 Jul 2008, Linus Torvalds wrote:
> > 
> > Things like this _really_ irritate me:
> > 
> > 	Memtest (MEMTEST) [Y/n/?] (NEW) ?
> 
> .. and now I get all the FTRACE stuff _individually_, with MMIOTRACE 
> (which is likely the _least_ interesting one for any normal person) 
> being turned on by default.
> 
> Ingo, you _really_ need to look at those Kconfig options. They're 
> insane.

... sorry about that - will send patches later today for all default-y 
stuff that slipped through.

default-y is handy for the development period, and i usually turn it off 
when it's close to go upstream (like i made stackprotector default-off), 
but things slip through ...

	Ingo
