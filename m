Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031468Ab0B1HYT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 02:24:19 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46270 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031444Ab0B1HYS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 02:24:18 -0500
Date: Sun, 28 Feb 2010 08:23:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, roland@redhat.com,
       suresh.b.siddha@intel.com, tglx@linutronix.de, hjl.tools@gmail.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next requirements
Message-ID: <20100228072357.GB14205@elte.hu>
References: <20100211195614.886724710@sbs-t61.sc.intel.com>
 <201002271323.14402.rjw@sisk.pl>
 <20100227124710.GA21164@elte.hu>
 <201002272007.43042.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201002272007.43042.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> > In fact those rare ways of building and booting the kernel i mentioned are 
> > probably used _more_ than half of the architectures that linux-next 
> > build-tests ...
> 
> I don't know and you don't know either.  That's just pure speculation and 
> therefore meaningless.

We know various arch (and hardware) usage stats, such as:

  http://smolt.fedoraproject.org/static/stats/stats.html

Today's stats, done amongst users who are willing to opt in to the Smolt 
daemon:

       x86: 99.7%
   powerpc: 0.3%

x86 used to be 99.5 a year ago, so the world has become even more x86-centric.

There's also the kerneloops.org client, which shows in excess of 95% x86 usage 
as well. You can also grep the linux-kernel folder for arch signatures, etc.

And yes, there are millions of ARM (and MIPS) CPUs running Linux as well. 
(They are only as present as present their developers are: the users almost 
never show up on linux-kernel.)

Plus, a kernel subsystem maintainer like me who does lots of kernel 
infrastructure work can have a pretty good gut feeling about which 
architectures are actively helping out Linux, and which are just hanging on to 
the bandwagon.

So i respectfully disagree with your 'pure speculation' bit. Yes, it's 
somewhat of a guessing game, as so many things in life - but the trend is very 
clear.

	Ingo
