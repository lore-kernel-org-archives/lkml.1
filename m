Return-Path: <linux-kernel-owner+w=401wt.eu-S1754534AbXLCOdx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534AbXLCOdx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 09:33:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752848AbXLCOdq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 09:33:46 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35811 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752592AbXLCOdp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 09:33:45 -0500
Date: Mon, 3 Dec 2007 15:33:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Radoslaw Szkodzinski <lkml@astralstorm.puszkin.org>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [feature] automatically detect hung TASK_UNINTERRUPTIBLE tasks
Message-ID: <20071203143300.GA9518@elte.hu>
References: <20071203115900.GB8432@elte.hu> <20071203121357.GB2986@one.firstfloor.org> <20071203122833.GA20232@elte.hu> <20071203124144.GC2986@one.firstfloor.org> <20071203130003.GA26372@elte.hu> <20071203131442.GA4004@one.firstfloor.org> <20071203132955.GA31354@elte.hu> <20071203134801.GB4004@one.firstfloor.org> <20071203135547.GA4245@elte.hu> <20071203141739.GC4719@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071203141739.GC4719@one.firstfloor.org>
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


* Andi Kleen <andi@firstfloor.org> wrote:

> > debugging feature can be disabled/enabled on a wide scale already:
> > 
> >  - in the .config
> > 
> >  - runtime, temporarily, via:
> > 
> >      echo 0 > /proc/sys/kernel/hung_task_timeout_secs
> 
> That won't address my concerns about already "breaking" (as in 
> frightening the user etc.) common error handling scenarios by default.

wow, now you again use big scary words like "breaking" and 
"frightening", with is a nice addition to the ticking timebomb 
metaphore.

Andi, sadly you are not listening AT ALL, you are repeating the same 
argument again and again that has been disputed and countered. Either 
come up with a new argument or please stop wasting everyone's time.

It is undisputable that for most users an unexplained hang is far more 
"frightening" than a hang followed by an explanation in the syslog. That 
is a _hard fact_, and if you cannot accept that it's really your 
cognitive problem not ours...

	Ingo
