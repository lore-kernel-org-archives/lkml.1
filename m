Return-Path: <linux-kernel-owner+w=401wt.eu-S1759075AbYEYTCe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759075AbYEYTCe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 15:02:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757388AbYEYTCY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 15:02:24 -0400
Received: from www.tglx.de ([62.245.132.106]:57004 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756041AbYEYTCX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 15:02:23 -0400
Date: Sun, 25 May 2008 21:01:32 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Arjan van de Ven <arjan@infradead.org>
cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>, akpm@osdl.org,
       Ingo Molnar <mingo@elte.hu>, Clark Williams <clark.williams@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Gregory Haskins <ghaskins@novell.com>, Andi Kleen <ak@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] x86: enable preemption in delay
In-Reply-To: <20080525115305.79c12c8c@infradead.org>
Message-ID: <alpine.LFD.1.10.0805252100120.3295@apollo.tec.linutronix.de>
References: <Pine.LNX.4.58.0805242306280.3977@gandalf.stny.rr.com> <20080525115305.79c12c8c@infradead.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 May 2008, Arjan van de Ven wrote:

> On Sat, 24 May 2008 23:11:20 -0400 (EDT)
> Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > In git commit 35d5d08a085c56f153458c3f5d8ce24123617faf, Andrew Morton
> > placed preempt_disable around the entire delay due to TSC's not
> > working nicely on SMP.  Unfortunately for those that care about
> > latencies this is devastating! Especially when we have callers to
> > mdelay(8).
> 
> we used to have a WARN_ON if mdelay was called while preemptable..
> maybe we should put that back in?

We'd better have one which warns, when mdelay is called with
preemption disabled.

Thanks,
	tglx

