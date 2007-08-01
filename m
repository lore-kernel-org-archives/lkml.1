Return-Path: <linux-kernel-owner+w=401wt.eu-S1764225AbXHAMXe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764225AbXHAMXe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 08:23:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761429AbXHAMXY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 08:23:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39428 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761166AbXHAMXX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 08:23:23 -0400
Date: Wed, 1 Aug 2007 14:23:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Mike Galbraith <efault@gmx.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: CFS review
Message-ID: <20070801122308.GA25429@elte.hu>
References: <20070711211638.GE18767@one.firstfloor.org> <20070711214649.GK14435@v2.random> <alpine.LFD.0.999.0707111500210.20061@woody.linux-foundation.org> <Pine.LNX.4.64.0707130415520.1818@scrub.home> <1184302024.6709.11.camel@Homer.simpson.net> <Pine.LNX.4.64.0707131728070.1817@scrub.home> <1184389456.6632.13.camel@Homer.simpson.net> <Pine.LNX.4.64.0708010439050.1817@scrub.home> <20070801112229.GA11710@elte.hu> <Pine.LNX.4.64.0708011346510.1817@scrub.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708011346510.1817@scrub.home>
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

> On Wed, 1 Aug 2007, Ingo Molnar wrote:
> 
> > > [...] e.g. in this example there are three tasks that run only for 
> > > about 1ms every 3ms, but they get far more time than should have 
> > > gotten fairly:
> > > 
> > >  4544 roman     20   0  1796  520  432 S 32.1  0.4   0:21.08 lt
> > >  4545 roman     20   0  1796  344  256 R 32.1  0.3   0:21.07 lt
> > >  4546 roman     20   0  1796  344  256 R 31.7  0.3   0:21.07 lt
> > >  4547 roman     20   0  1532  272  216 R  3.3  0.2   0:01.94 l
> > 
> > Mike and me have managed to reproduce similarly looking 'top' output, 
> > but it takes some effort: we had to deliberately run a non-TSC 
> > sched_clock(), CONFIG_HZ=100, !CONFIG_NO_HZ and !CONFIG_HIGH_RES_TIMERS.
> 
> I used my old laptop for these tests, where tsc is indeed disabled due 
> to instability. Otherwise the kernel was configured with 
> CONFIG_HZ=1000.

please send all the debug info and source code we asked for - thanks!

	Ingo
