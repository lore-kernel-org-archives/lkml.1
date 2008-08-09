Return-Path: <linux-kernel-owner+w=401wt.eu-S1758891AbYHIAXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758891AbYHIAXd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 20:23:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754917AbYHIAXZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 20:23:25 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45891 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754810AbYHIAXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 20:23:25 -0400
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Roland McGrath <roland@redhat.com>,
       Ulrich Drepper <drepper@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Clark Williams <williams@redhat.com>
Subject: Re: [PATCH 0/5] ftrace: to kill a daemon
From: Andi Kleen <andi@firstfloor.org>
References: <20080807182013.984175558@goodmis.org>
	<20080807184741.GB18164@Krystal>
	<alpine.DEB.1.10.0808071639420.9449@gandalf.stny.rr.com>
	<20080808172259.GB8244@Krystal>
	<alpine.DEB.1.10.0808081334010.4436@gandalf.stny.rr.com>
	<20080808174607.GG8244@Krystal>
	<alpine.DEB.1.10.0808081410380.6116@gandalf.stny.rr.com>
	<20080808182104.GA11376@Krystal>
	<alpine.DEB.1.10.0808081432400.8922@gandalf.stny.rr.com>
	<20080808190506.GD11376@Krystal>
	<alpine.DEB.1.10.0808081750590.16691@gandalf.stny.rr.com>
Date: Sat, 09 Aug 2008 02:23:22 +0200
In-Reply-To: <alpine.DEB.1.10.0808081750590.16691@gandalf.stny.rr.com> (Steven Rostedt's message of "Fri, 8 Aug 2008 19:38:01 -0400 (EDT)")
Message-ID: <87tzdv2g05.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt <rostedt@goodmis.org> writes:

> I'm stubborn, I want to get it right _and_ keep it fast.

For me it would seem better to just not use two part 5 byte nops
instead of adding such hacks.  I doubt there are that many of them
anyways. I bet you won't be able to measure any difference between the
different nop types in any macro benchmark.

-Andi
