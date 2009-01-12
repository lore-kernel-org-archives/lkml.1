Return-Path: <linux-kernel-owner+w=401wt.eu-S1753437AbZALNO0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437AbZALNO0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 08:14:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751494AbZALNOS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 08:14:18 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52506 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750891AbZALNOS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 08:14:18 -0500
Date: Mon, 12 Jan 2009 14:14:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: Brian Rogers <brian@xyzw.org>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [BUG] How to get real-time priority using idle priority
Message-ID: <20090112131406.GB670@elte.hu>
References: <4969D0D7.2060401@xyzw.org> <1231736941.6003.7.camel@marge.simson.net> <1231765433.5789.35.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231765433.5789.35.camel@marge.simson.net>
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


* Mike Galbraith <efault@gmx.de> wrote:

> > I haven't been able to reproduce complete hangs, but with your proggy 
> > adapted to my quad, _and_ the addition of a SCHED_NORMAL hog, I can 
> > reproduce some very bad interactivity, including massive character 
> > repeats while attempting to type, and general "lurchiness" (_bad_ 
> > wakeup latency).  I'll poke it with a sharp stick or two.
> 
> Would you mind trying the below?

i've applied your fix to tip/sched/urgent and merged it into tip/master.

Brian, you might want to test tip/master, as per:

 http://people.redhat.com/mingo/tip.git/README

which now has this fix included. Can you make it break?

	Ingo
