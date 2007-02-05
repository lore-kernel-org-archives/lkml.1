Return-Path: <linux-kernel-owner+w=401wt.eu-S1751940AbXBERJK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751940AbXBERJK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 12:09:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751954AbXBERJJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 12:09:09 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56140 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751940AbXBERJI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 12:09:08 -0500
Date: Mon, 5 Feb 2007 18:05:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] MTD: fix DOC2000/2001/2001PLUS build error
Message-ID: <20070205170501.GA6537@elte.hu>
References: <Pine.LNX.4.64.0702041057090.8424@woody.linux-foundation.org> <20070205084523.GA21858@elte.hu> <1170682488.29759.795.camel@pmac.infradead.org> <20070205155627.GA8354@elte.hu> <1170692539.29759.856.camel@pmac.infradead.org> <20070205162635.GA755@elte.hu> <20070205163152.GA2464@elte.hu> <Pine.LNX.4.64.0702050852160.8424@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702050852160.8424@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -5.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-5.3 required=5.9 tests=ALL_TRUSTED,BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Me, I'd like to say I want "default firewall built in", and not have 
> to see *any* of the crap. And that's exactly why "select" is a good 
> thing.

yeah. For a long time i wanted to do something like that for all the 
kernel debugging options, to by default only offer a simple menu of:

 ( ) Debug Disabled
 (*) Transparent Low-Overhead Debugging
 ( ) Transparent Medium-Overhead Debugging
 ( ) Transparent High-Overhead Debugging
 ( ) Custom Debugging

so say softlockup-detect or spinlock-sleep checks would be enabled by 
Low-Overhead Debugging, but slab-debug or lockdep would only be enabled 
by the High-Overhead Debugging option.

and all the zillions of debug options would only show up if "Custom 
Debugging" is selected. Plus this would have the advantage that if we 
add a new debug option, and the tester already has a .config with say 
"Transparent Low-Overhead Debugging" enabled - Kconfig would pick the 
right value for that new debug option. This would remove the need and 
desire to 'default y' certain debugging features to get them tested ...

	Ingo
