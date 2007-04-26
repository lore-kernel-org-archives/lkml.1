Return-Path: <linux-kernel-owner+w=401wt.eu-S1031299AbXDZQFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031299AbXDZQFq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 12:05:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031300AbXDZQFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 12:05:46 -0400
Received: from mail.gmx.net ([213.165.64.20]:34365 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1031299AbXDZQFp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 12:05:45 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+qBJdM4pSqIEaatjo5fKpCQLuO44DyCvrOL4HqHw
	i2tQH65m1GghHz
Subject: Re: [patch] CFS scheduler, -v6
From: Mike Galbraith <efault@gmx.de>
To: Redeeman <redeeman@metanurb.dk>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       Mark Lord <lkml@rtr.ca>, Zach Carter <linux@zachcarter.com>,
       buddabrod <buddabrod@gmail.com>
In-Reply-To: <1177596399.14496.1.camel@localhost>
References: <20070425214704.GA32572@elte.hu>
	 <1177596399.14496.1.camel@localhost>
Content-Type: text/plain
Date: Thu, 26 Apr 2007 18:05:38 +0200
Message-Id: <1177603538.6145.6.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-04-26 at 16:06 +0200, Redeeman wrote:
> On Wed, 2007-04-25 at 23:47 +0200, Ingo Molnar wrote:
> <snip>
> > As usual, any sort of feedback, bugreport, fix and suggestion is more 
> > than welcome,
> 
> well, from my experiences with cfs on workstation/desktop, on amd64
> 2ghz, cfs doesent measure up to SD at all.
> 
> audio skips easily, with or without reniced X, and games are not as
> smooth. also it seems to be much lower throughput. vanilla seems much
> better by comparisin.

Can you give some details wrt these audio skips?  What are you doing,
and what is your config.  I don't see audio skips at all, unless I
intentionally beg for it via massive renice of X + a _very_ heavy CPU
client, and even then, only on UP (logical, one exec path).

	-Mike

