Return-Path: <linux-kernel-owner+w=401wt.eu-S936020AbZDJLt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936020AbZDJLt4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 07:49:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764340AbZDJLti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 07:49:38 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54556 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760799AbZDJLtg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 07:49:36 -0400
Date: Fri, 10 Apr 2009 13:49:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pavel Machek <pavel@ucw.cz>
Cc: Avi Kivity <avi@redhat.com>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@linux.intel.com,
       rjw@sisk.pl, linux-tip-commits@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [tip:x86/setup] x86, setup: "glove box" BIOS calls --
	infrastructure
Message-ID: <20090410114901.GJ21506@elte.hu>
References: <49DE7F79.4030106@zytor.com> <tip-7a734e7dd93b9aea08ed51036a9a0e2c9dfd8dac@git.kernel.org> <20090410080444.GC16512@elf.ucw.cz> <20090410103934.GA21506@elte.hu> <20090410104648.GA31516@elf.ucw.cz> <20090410112546.GD21506@elte.hu> <20090410113824.GA18823@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090410113824.GA18823@elf.ucw.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pavel Machek <pavel@ucw.cz> wrote:

> > "BIOS people" are operating in a completely different culture. 
> > Time to market, hardware workarounds, short-term 
> > differentiators, secret bootstrap sequences and code compactness 
> > are king in that space. Code quality is dead last in the list. I 
> > strongly doubt that given the radically conflicting priorities a 
> > reasonable dialogue can be established.
> 
> "BIOS people" control stuff like SMM mode. We can workaround some 
> BIOS problems, but definitely not all of them.
> 
> For servers, I guess Linux has enough of market share that we 
> could certify known-good servers (and maybe warn against 
> known-bad).

Server space is somewhat less of a problem BIOS quality wise: the 
design cycles are longer, the features are more complex and the 
profit margins are higher - which all results in saner practices and 
more care. They even do server BIOS fixes for Linux.

The problem are the "Does it boot Windows? Ship it, forget it, 
buldoze the factory" kind of desktop operations.

	Ingo
