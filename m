Return-Path: <linux-kernel-owner+w=401wt.eu-S1753938AbXLBWVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938AbXLBWVS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 17:21:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751384AbXLBWVE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 17:21:04 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38653 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751130AbXLBWVC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 17:21:02 -0500
Date: Sun, 2 Dec 2007 23:20:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [feature] automatically detect hung TASK_UNINTERRUPTIBLE tasks
Message-ID: <20071202222040.GA31707@elte.hu>
References: <20071201092037.GA32544@elte.hu> <p737ijwylet.fsf@bingen.suse.de> <20071202185945.GA25990@elte.hu> <20071202114152.3bf4332d@laptopd505.fenrus.org> <20071202200953.GA23994@one.firstfloor.org> <20071202202602.GA16480@elte.hu> <20071202204725.GA25891@one.firstfloor.org> <20071202211027.GA32282@elte.hu> <20071202211925.GA26414@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071202211925.GA26414@one.firstfloor.org>
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

> > Until now users had little direct recourse to get such problems 
> > fixed. (we had sysrq-t, but that included no real metric of how long 
> > a task was
> 
> Actually task delay accounting can measure this now.  iirc someone had 
> a latencytop based on it already.

Delay accounting (or the /proc/<PID>/sched fields that i added recently) 
only get updated once a task has finished its unreasonably long delay 
and has scheduled. So lockups or extremely long delays _wont be 
detected_ this way. This is a debugging facility that clearly belongs 
into the kernel. Your arguments just make no objective sense.

	Ingo
