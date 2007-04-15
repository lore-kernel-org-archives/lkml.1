Return-Path: <linux-kernel-owner+w=401wt.eu-S1752354AbXDOHyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354AbXDOHyw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 03:54:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752357AbXDOHyw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 03:54:52 -0400
Received: from mail.gmx.net ([213.165.64.20]:43122 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752277AbXDOHyv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 03:54:51 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/mAiUmfBnmLk8V5xQp/Gt4WxvSw1yYMvwUvK4ni6
	Oz6Yz941D8pTkW
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair
	Scheduler [CFS]
From: Mike Galbraith <efault@gmx.de>
To: Willy Tarreau <w@1wt.eu>
Cc: Ingo Molnar <mingo@elte.hu>, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20070414130101.GA2538@1wt.eu>
References: <20070413202100.GA9957@elte.hu>
	 <20070414020424.GB14544@wotan.suse.de> <20070414063254.GB14875@elte.hu>
	 <20070414064334.GA19463@elte.hu> <20070414080833.GL943@1wt.eu>
	 <20070414083625.GM943@1wt.eu> <20070414105338.GB19454@elte.hu>
	 <20070414130101.GA2538@1wt.eu>
Content-Type: text/plain
Date: Sun, 15 Apr 2007 09:54:48 +0200
Message-Id: <1176623688.30350.23.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-04-14 at 15:01 +0200, Willy Tarreau wrote:

> Well, I'll stop heating the room for now as I get out of ideas about how
> to defeat it. I'm convinced. I'm impatient to read about Mike's feedback
> with his workload which behaves strangely on RSDL. If it works OK here,
> it will be the proof that heuristics should not be needed.

You mean the X + mp3 player + audio visualization test?  X+Gforce
visualization have problems getting half of my box in the presence of
two other heavy cpu using tasks.  Behavior is _much_ better than
RSDL/SD, but the synchronous nature of X/client seems to be a problem.  

With this scheduler, renicing X/client does cure it, whereas with SD it
did not help one bit.  (I know a trivial way to cure that, and this
framework makes that possible without dorking up fairness as a general
policy.)

	-Mike

