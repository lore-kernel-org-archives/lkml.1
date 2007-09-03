Return-Path: <linux-kernel-owner+w=401wt.eu-S1756141AbXICSyY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141AbXICSyY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 14:54:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753786AbXICSyS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 14:54:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36419 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752939AbXICSyR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 14:54:17 -0400
Date: Mon, 3 Sep 2007 20:54:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org,
       Mike Galbraith <efault@gmx.de>
Subject: Re: [ANNOUNCE/RFC] Really Simple Really Fair Scheduler
Message-ID: <20070903185403.GA23479@elte.hu>
References: <20070902120154.GA23769@elte.hu> <Pine.LNX.4.64.0709032030320.1817@scrub.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0709032030320.1817@scrub.home>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Roman Zippel <zippel@linux-m68k.org> wrote:

> Hi,
> 
> On Sun, 2 Sep 2007, Ingo Molnar wrote:
> 
> > Roman, as an addendum to my review, please find below a prototype patch 
> > i've just written that implements RSRFS (Really Simple Really Fair 
> > Scheduler) ontop of CFS. It is intended to demonstrate the essence of 
> > the math you have presented via your patch. (it has no nice levels 
> > support yet, to make the math really apparent to everyone interested)
> 
> It simplifies the math too much, the nice level weighting is an 
> essential part of the math and without it one can't really understand 
> the problem I'm trying to solve. At http://lkml.org/lkml/2007/9/3/168 
> I provide an example of the math, which more acurately demonstrates 
> the essential math.

as i mentioned it above, in the first level review i'm mainly interested 
in your patch's behavior wrt. simple nice-0 tasks, how they run and how 
they sleep and wake up. Nothing else. Why? That's what 99% of the Linux 
tasks do after all. So could you please confirm whether that aspect of 
what i wrote (both in words and in code) is correct?

If this basic model is correct, we can look further. If this basic model 
is flawed, no amount of weighting, nice level logic, rounding behavior 
can fix it. I'm sure you agree with that too.

That's why i wrote this prototype, please confirm or deny whether i 
correctly understood how you intend to handle nice-0 tasks. (From your 
mails i read a part-acknowledgement of that but i'd like to see a more 
clear acknowledgement - or please mention any issues if you know about 
them.) Thanks!

	Ingo
