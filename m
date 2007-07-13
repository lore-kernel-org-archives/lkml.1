Return-Path: <linux-kernel-owner+w=401wt.eu-S1759443AbXGMErS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759443AbXGMErS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 00:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750870AbXGMErL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 00:47:11 -0400
Received: from mail.gmx.net ([213.165.64.20]:46084 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750755AbXGMErK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 00:47:10 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+xKGI3Zuqx0MQb2jFH2CGiqZMVkVPNiEmtRMNsav
	6EJhA59y0HxmWk
Subject: Re: x86 status was Re: -mm merge plans for 2.6.23
From: Mike Galbraith <efault@gmx.de>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrea Arcangeli <andrea@suse.de>, Andi Kleen <andi@firstfloor.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>
In-Reply-To: <Pine.LNX.4.64.0707130415520.1818@scrub.home>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
	 <p734pkbyuu4.fsf@bingen.suse.de> <20070711174252.GA16793@elte.hu>
	 <20070711211638.GE18767@one.firstfloor.org>
	 <20070711214649.GK14435@v2.random>
	 <alpine.LFD.0.999.0707111500210.20061@woody.linux-foundation.org>
	 <Pine.LNX.4.64.0707130415520.1818@scrub.home>
Content-Type: text/plain
Date: Fri, 13 Jul 2007 06:47:04 +0200
Message-Id: <1184302024.6709.11.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-07-13 at 04:23 +0200, Roman Zippel wrote:
> Hi,

Hi,

> The new scheduler does _a_lot_ of heavy 64 bit calculations without any 
> attempt to scale that down a little...

See prio_to_weight[], prio_to_wmult[] and sysctl_sched_stat_granularity.
Perhaps more can be done, but "without any attempt..." isn't accurate.

	-Mike

