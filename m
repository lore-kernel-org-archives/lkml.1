Return-Path: <linux-kernel-owner+w=401wt.eu-S1755844AbZC2B6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755844AbZC2B6e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 21:58:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751702AbZC2B6Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 21:58:24 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56877 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014AbZC2B6Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 21:58:24 -0400
Date: Sun, 29 Mar 2009 03:58:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git-pull -tip] x86: include inverse Xmas tree patches
Message-ID: <20090329015805.GA20846@elte.hu>
References: <1238251730.2526.2.camel@ht.satnam> <20090328150746.GA3268@x200.localdomain> <20090328190350.GA30214@uranus.ravnborg.org> <49CEA3CD.105@kernel.org> <alpine.LFD.2.00.0903290025280.3397@localhost.localdomain> <20090328233438.GA4957@elte.hu> <alpine.LFD.2.00.0903290035390.3397@localhost.localdomain> <alpine.LFD.2.00.0903290055080.3397@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0903290055080.3397@localhost.localdomain>
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


* Thomas Gleixner <tglx@linutronix.de> wrote:

> I just run the following on current git:
> 
> # FS=`find -type f`; for F in $FS; do grep -c "#include" $F; done | sort -n | uniq -c
> 
> The top 5 are:
> 
> lib/locking-selftest.c:	108 (justified as this includes all the test cases)
> fs/compat_ioctl.c		 88 (maybe ok as it is the all in one kitchen sink)
> arch/x86/kernel/setup.c:	 76 (completely nuts)

[yep]

> init/main.c:			 62 (needs to be looked at)
> security/selinux/hooks.c	 61 (needs to be looked at, spotted at least 5 which can be removed)
> 
> 1400 files have more than 20 includes. 5375 more than 10.
> 
> I think it's well justified to sit down and work on a tool which 
> helps us analyse and distangle that mess.

yeah.

	Ingo
