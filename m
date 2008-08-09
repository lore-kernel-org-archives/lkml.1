Return-Path: <linux-kernel-owner+w=401wt.eu-S1758385AbYHIAve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758385AbYHIAve (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 20:51:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752230AbYHIAv0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 20:51:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:53410 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbYHIAv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 20:51:26 -0400
Date: Fri, 8 Aug 2008 20:51:23 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Andi Kleen <andi@firstfloor.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Roland McGrath <roland@redhat.com>,
       Ulrich Drepper <drepper@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Clark Williams <williams@redhat.com>
Subject: Re: [PATCH 0/5] ftrace: to kill a daemon
In-Reply-To: <489CE90D.1040902@goop.org>
Message-ID: <alpine.DEB.1.10.0808082050140.3707@gandalf.stny.rr.com>
References: <20080807182013.984175558@goodmis.org> <20080807184741.GB18164@Krystal> <alpine.DEB.1.10.0808071639420.9449@gandalf.stny.rr.com> <20080808172259.GB8244@Krystal> <alpine.DEB.1.10.0808081334010.4436@gandalf.stny.rr.com> <20080808174607.GG8244@Krystal>
 <alpine.DEB.1.10.0808081410380.6116@gandalf.stny.rr.com> <20080808182104.GA11376@Krystal> <alpine.DEB.1.10.0808081432400.8922@gandalf.stny.rr.com> <20080808190506.GD11376@Krystal> <alpine.DEB.1.10.0808081750590.16691@gandalf.stny.rr.com> <87tzdv2g05.fsf@basil.nowhere.org>
 <alpine.DEB.1.10.0808082030500.1396@gandalf.stny.rr.com> <489CE90D.1040902@goop.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 8 Aug 2008, Jeremy Fitzhardinge wrote:

> Steven Rostedt wrote:
> > I wish we had a true 5 byte nop. 
> 
> 0x66 0x66 0x66 0x66 0x90
> 

But I quote you:

> Unfortunately, aside from P6_NOP5, none of the standard asm/nops.h nops 
> are suitable.  Something like "0x66, 0x66, 0x66, 0x66, 0x90" would work
> everywhere, but its possible putting more than 3 prefixes on the 
> instruction will kick the decoder into a slow path, which may have a 
> noticable effect.

I guess the next step is to test if it is slow.

-- Steve

