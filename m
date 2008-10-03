Return-Path: <linux-kernel-owner+w=401wt.eu-S1754566AbYJCJEp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566AbYJCJEp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 05:04:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752619AbYJCJEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 05:04:37 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54190 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752400AbYJCJEg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 05:04:36 -0400
Date: Fri, 3 Oct 2008 11:04:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 01/31] cpumask: Documentation
Message-ID: <20081003090416.GE27551@elte.hu>
References: <20080929180250.111209000@polaris-admin.engr.sgi.com> <200810010849.46874.rusty@rustcorp.com.au> <20081001091325.GA12503@elte.hu> <200810021036.29054.rusty@rustcorp.com.au> <48E4C488.9020408@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48E4C488.9020408@sgi.com>
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


* Mike Travis <travis@sgi.com> wrote:

> Absolutely!  I may have my own concerns and preferences but the end 
> goal is far more important.  I'll take a look at it today.  [My only 
> other pressing matter is convincing Ingo to accept the SCIR driver (or 
> tell me how I need to change it so it is acceptable), so my management 
> is happy... ;-)]

it's getting off topic, but i really dont get it why you cannot go via 
the standard LEDS framework, and why you have to hook into the x86 idle 
notifiers. (which we are hoping to get rid of)

RAS does not need that precise accounting. It just needs a heartbeat 
timer that tells it how to do the pretty lights and to report whether 
the CPU is still alive. Something that seems to be fully within the 
scope of LEDS. What am i missing?

	Ingo
