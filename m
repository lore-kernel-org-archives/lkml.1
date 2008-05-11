Return-Path: <linux-kernel-owner+w=401wt.eu-S1755563AbYEKPTk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563AbYEKPTk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 11:19:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752652AbYEKPTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 11:19:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37603 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750885AbYEKPTa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 11:19:30 -0400
Date: Sun, 11 May 2008 17:19:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Sven Wegener <sven.wegener@stealer.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [git pull] scheduler fixes
Message-ID: <20080511151909.GA3887@elte.hu>
References: <20080511110306.GP19219@parisc-linux.org> <20080511114803.GA8289@parisc-linux.org> <20080511125049.GA22513@elte.hu> <20080511125216.GA25040@elte.hu> <20080511130226.GR19219@parisc-linux.org> <20080511132636.GA22878@parisc-linux.org> <20080511140017.GA2457@elte.hu> <20080511141818.GT19219@parisc-linux.org> <20080511144203.GB3220@elte.hu> <20080511144821.GW19219@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080511144821.GW19219@parisc-linux.org>
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


* Matthew Wilcox <matthew@wil.cx> wrote:

> > exactly what usecase is that? Perhaps it could be converted to an 
> > atomic counter + the wait_event() APIs.
> 
> Effectively, it's a completion.  It just works better with staggered 
> wakeups than it does with the naive completion.

So why not transform it to real completions instead? And if our current 
'struct completion' abstraction is insufficient for whatever reason, why 
not extend that instead?

	Ingo
