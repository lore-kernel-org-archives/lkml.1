Return-Path: <linux-kernel-owner+w=401wt.eu-S1750827AbXDQFvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750827AbXDQFvS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 01:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750848AbXDQFvR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 01:51:17 -0400
Received: from mail.gmx.net ([213.165.64.20]:41878 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750827AbXDQFvQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 01:51:16 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+CcSpE2XmC/b8n0psFNbpODnduchOV86W3z78uJ2
	ZzLzXE50q2bKGn
Subject: Re: [patch] CFS (Completely Fair Scheduler), v2
From: Mike Galbraith <efault@gmx.de>
To: Willy Tarreau <w@1wt.eu>
Cc: Gene Heskett <gene.heskett@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
In-Reply-To: <20070417052550.GA9491@1wt.eu>
References: <20070416220715.GA4071@elte.hu>
	 <200704170053.58611.gene.heskett@gmail.com>  <20070417052550.GA9491@1wt.eu>
Content-Type: text/plain
Date: Tue, 17 Apr 2007 07:51:09 +0200
Message-Id: <1176789069.6492.8.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-04-17 at 07:25 +0200, Willy Tarreau wrote:

> Have you tried previous version with the fair-fork patch ? It might be possible
> that your workload is sensible to the fork()'s child getting much CPU upon
> startup.

Dunno about that, but here's a possibly related datapoint.  I reported
to Ingo yesterday that I was sometimes losing control of my GUI (KDE)
under heavy IO.  I just reproduced it in mainline rc7.  If I start a
bonnie, and click around popping windows to the foreground, then poke
KDE's menu button, I may lose all GUI capability for a _very_ long time.
Here, with bonnie, that means until it gets past writing with putc, and
moves on to rewrite.  Ages.

	-Mike

