Return-Path: <linux-kernel-owner+w=401wt.eu-S1755284AbZALPYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284AbZALPYf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 10:24:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752484AbZALPYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 10:24:25 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47389 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752173AbZALPYZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 10:24:25 -0500
Date: Mon, 12 Jan 2009 16:24:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: Brian Rogers <brian@xyzw.org>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [BUG] How to get real-time priority using idle priority
Message-ID: <20090112152419.GA20003@elte.hu>
References: <4969D0D7.2060401@xyzw.org> <1231736941.6003.7.camel@marge.simson.net> <1231765433.5789.35.camel@marge.simson.net> <20090112131406.GB670@elte.hu> <1231773786.10060.0.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231773786.10060.0.camel@marge.simson.net>
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

> On Mon, 2009-01-12 at 14:14 +0100, Ingo Molnar wrote:
> > * Mike Galbraith <efault@gmx.de> wrote:
> > 
> > > > I haven't been able to reproduce complete hangs, but with your proggy 
> > > > adapted to my quad, _and_ the addition of a SCHED_NORMAL hog, I can 
> > > > reproduce some very bad interactivity, including massive character 
> > > > repeats while attempting to type, and general "lurchiness" (_bad_ 
> > > > wakeup latency).  I'll poke it with a sharp stick or two.
> > > 
> > > Would you mind trying the below?
> > 
> > i've applied your fix to tip/sched/urgent and merged it into tip/master.
> 
> BTW, I forgot the Reported-by: Brian Rogers <brian@xyzw.org> :-/

yeah, i noticed that and added it when i committed the change.

	Ingo
