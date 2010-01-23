Return-Path: <linux-kernel-owner+w=401wt.eu-S1753664Ab0AWJn3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664Ab0AWJn3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 04:43:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752731Ab0AWJn2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 04:43:28 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53137 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751487Ab0AWJn1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 04:43:27 -0500
Date: Sat, 23 Jan 2010 10:43:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>, Luca Zini <luca.zini@gmail.com>,
       aagaande@gmail.com, rdelcueto@hotmail.com,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Alex Chiang <achiang@hp.com>
Subject: Re: scheduler vs hardware? (was Re: another i7  (linux) bug?)
Message-ID: <20100123094315.GA16060@elte.hu>
References: <201001211258.23499.luca.zini@gmail.com>
 <20100121215438.GK17684@ldl.fc.hp.com>
 <1264144758.8074.22.camel@marge.simson.net>
 <1264150272.4283.1361.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1264150272.4283.1361.camel@laptop>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Fri, 2010-01-22 at 08:19 +0100, Mike Galbraith wrote:
> > > if I run a cpu intensive process with the lowest priority (19
> > > from man nice) I obtain much better performance that with the
> > > highest priority available (-20 from man nice).
> > >
> > > For example the same file is processed by lame in 8.7 seconds
> > > at the lowest priority, and in 12 seconds at the highest
> > > priority.  Before posting a bug I wold like to understand if
> > > this is a problem related to the i7 mobile (my processor is a
> > > i7 Q720).
> > > 
> > > As far as I tested on the same laptop series (dell studio 15),
> > > with the same kernel this problem does not exists.
> > 
> > So you only see this on the i7.  That's odd.  Can you try 33-rc5?
> > 
> > Posting a reliable reproducer would be nice.  It'd also be nice to see
> > what all is running when you see this, and where.
> 
> Using a sample from: http://lame.sourceforge.net/quality.php
> 
> My laptop does:
> 
> 
> # time nice -n 19 lame -b 256 -V0 -h youcantdothat.wav - > /dev/null

A 'perf stat --repeat 3' run would tell us more about the underlying reasons i 
think.

	Ingo
