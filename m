Return-Path: <linux-kernel-owner+w=401wt.eu-S965580AbXAYGjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965580AbXAYGjO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 01:39:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965582AbXAYGjO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 01:39:14 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:57398 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965580AbXAYGjN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 01:39:13 -0500
Date: Thu, 25 Jan 2007 07:37:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Daniel Walker <dwalker@mvista.com>
Cc: john stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Veen <arjan@infradead.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: [patch 00/46] High resolution timer / dynamic tick update
Message-ID: <20070125063739.GB26764@elte.hu>
References: <20070123211159.178138000@localhost.localdomain> <1169604991.19471.95.camel@imap.mvista.com> <20070124070701.GA17654@elte.hu> <1169631016.19471.175.camel@imap.mvista.com> <1169668653.6905.49.camel@localhost.localdomain> <1169671890.19471.309.camel@imap.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1169671890.19471.309.camel@imap.mvista.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.8
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.8 required=5.9 tests=ALL_TRUSTED,BAYES_50 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	0.5 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4965]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Daniel Walker <dwalker@mvista.com> wrote:

> > Thomas' changes are more obviously purpose driven, and Daniel's 
> > appear more like just cleanups. So given that, if it were me, I'd 
> > put Thomas changes in first, and re-diff Daniel's non-redundant 
> > changes on top.
> 
> Seems backwards , clean ups should always go first. If Thomas had 
> started off my patch set his changes would have been smaller and 
> hopefully stronger. [...]

if it were the same area of code, and if all your cleanups were fine, 
i'd agree. But even assuming that all your cleanups are fine, this is 
90% /not/ the same area of code. Thomas's changes refactor the 
clockevents infrastructure, while passingly touching clocksources too, 
on an as-needed basis. Your changes touch the clocksource area of code. 
In that sense Thomas' changes are more important and you should be able 
to refactor your queue ontop of Thomas' (trivial) change to the 
clocksources code.

You are complaining that we didnt pick up your high-flux cleanups, but 
we pointed out our reasons. In fact we couldnt really even consider your 
queue because the last version of yours when we did ours was 2 months 
old and yours included the showstopper sched_clock() changes. Your queue 
had all the signs of abandonment, so your injection into this submission 
of the -hrt queue to suggest that your queue is suddenly a 'must have' 
is quite puzzling to me.

	Ingo
