Return-Path: <linux-kernel-owner+w=401wt.eu-S1758304AbYHIAyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758304AbYHIAyS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 20:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751874AbYHIAyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 20:54:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36126 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751861AbYHIAyF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 20:54:05 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
X-Fcc: ~/Mail/linus
Cc: Andi Kleen <andi@firstfloor.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Ulrich Drepper <drepper@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Clark Williams <williams@redhat.com>
Subject: Re: [PATCH 0/5] ftrace: to kill a daemon
In-Reply-To: Steven Rostedt's message of  Friday, 8 August 2008 20:36:02 -0400 <alpine.DEB.1.10.0808082030500.1396@gandalf.stny.rr.com>
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
	<87tzdv2g05.fsf@basil.nowhere.org>
	<alpine.DEB.1.10.0808082030500.1396@gandalf.stny.rr.com>
X-Zippy-Says: I am KING BOMBA of Sicily!..I will marry LUCILLE BALL next Friday!
Message-Id: <20080809005326.E799F154208@magilla.localdomain>
Date: Fri,  8 Aug 2008 17:53:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Are we sure there aren't some good available 5-byte nops?

e.g. for 64-bit maybe 3e 48 8d 76 00
     for 32-bit maybe 3e 8d 74 26 00

Have the chip folks confirmed that exactly the set we have in
asm-x86/nops.h are the only optimal ones?


Thanks,
Roland
