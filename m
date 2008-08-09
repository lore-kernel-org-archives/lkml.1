Return-Path: <linux-kernel-owner+w=401wt.eu-S1752573AbYHILpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573AbYHILpb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 07:45:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751338AbYHILpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 07:45:23 -0400
Received: from mail-in-16.arcor-online.net ([151.189.21.56]:59613 "EHLO
	mail-in-16.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751466AbYHILpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 07:45:22 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: [PATCH 0/5] ftrace: to kill a daemon
To: Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
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
Reply-To: 7eggert@gmx.de
Date: Sat, 09 Aug 2008 13:50:14 +0200
References: <aYipy-5FM-9@gated-at.bofh.it> <aYiIP-6bN-11@gated-at.bofh.it> <aYkAT-15Q-1@gated-at.bofh.it> <aYDX5-fa-31@gated-at.bofh.it> <aYE6H-tg-21@gated-at.bofh.it> <aYEgj-Fc-17@gated-at.bofh.it> <aYEJq-1xB-23@gated-at.bofh.it> <aYET8-1L7-17@gated-at.bofh.it> <aYFcq-2f2-11@gated-at.bofh.it> <aYFvP-2Vc-25@gated-at.bofh.it> <aYJIZ-15G-7@gated-at.bofh.it> <aYKvs-2gQ-7@gated-at.bofh.it> <aYKF1-2qs-7@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1KRmxa-0001S5-E0@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt <rostedt@goodmis.org> wrote:
> On Sat, 9 Aug 2008, Andi Kleen wrote:
>> Steven Rostedt <rostedt@goodmis.org> writes:

>> > I'm stubborn, I want to get it right _and_ keep it fast.
>> 
>> For me it would seem better to just not use two part 5 byte nops
>> instead of adding such hacks.  I doubt there are that many of them
>> anyways. I bet you won't be able to measure any difference between the
>> different nop types in any macro benchmark.
> 
> I wish we had a true 5 byte nop. The alternative is a jmp 0, which is
> measurable.

Did you try short jumps? (0xeb 0x03 0x?? 0x?? 0x??)

