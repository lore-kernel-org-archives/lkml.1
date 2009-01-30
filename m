Return-Path: <linux-kernel-owner+w=401wt.eu-S1754254AbZA3KvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254AbZA3KvS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 05:51:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752362AbZA3KvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 05:51:05 -0500
Received: from mail.gmx.net ([213.165.64.20]:46915 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752050AbZA3KvC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 05:51:02 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18OHWlBgxcO8X7KIkKwJd2vvW2F+lMB9gp3/v7sj+
	6yi/RC0xGFqJoQ
Subject: Re: scheduler nice 19 versus 'idle' behavior / static low-priority
	scheduling
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Nathanael Hoyle <nhoyle@hoyletech.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable <stable@kernel.org>
In-Reply-To: <1233312042.4495.167.camel@laptop>
References: <1233294584.28741.2.camel@localhost>
	 <1233305433.4495.154.camel@laptop>  <1233306030.17301.36.camel@localhost>
	 <1233306223.4495.159.camel@laptop>  <1233310700.7816.7.camel@localhost>
	 <1233311516.6280.4.camel@marge.simson.net>
	 <1233312042.4495.167.camel@laptop>
Content-Type: text/plain
Date: Fri, 30 Jan 2009 11:50:57 +0100
Message-Id: <1233312657.6769.3.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-01-30 at 11:40 +0100, Peter Zijlstra wrote:
> On Fri, 2009-01-30 at 11:31 +0100, Mike Galbraith wrote:
> > On Fri, 2009-01-30 at 05:18 -0500, Nathanael Hoyle wrote:
> > 
> > > Ok, I'm now running:
> > > 
> > > Linux nightmare 2.6.28.2-nhoyle #1 SMP Fri Jan 30 04:50:03 EST 2009
> > > x86_64 Intel(R) Core(TM)2 Quad CPU Q9450 @ 2.66GHz GenuineIntel
> > > GNU/Linux
> > > 
> > > Initial conclusion is that whatever defects were corrected (non
> > > SCHED_IDLE specific defects that is), the newer kernel version does the
> > > trick.  Video playback is as smooth as ever when running foldingathome
> > > at simple nice 19 priority.
> > 
> > Good to hear, thanks for testing.
> > 
> > Peter, since 27 is a long term maintenance kernel, do you think 1af5f73
> > and 046e7f7 (at least) are 27.stable candidates?
> 
> 1af5f730fc1bf7c62ec9fb2d307206e18bf40a69 and
> e17036dac189dd034c092a91df56aa740db7146d you mean?

Yeah.

> I guess that makes sense.

(adds cc)

	-Mike

