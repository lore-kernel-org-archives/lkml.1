Return-Path: <linux-kernel-owner+w=401wt.eu-S1758699AbYHNVTX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758699AbYHNVTX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 17:19:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753618AbYHNVTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 17:19:14 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38759 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858AbYHNVTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 17:19:13 -0400
Date: Thu, 14 Aug 2008 23:20:36 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Steven Rostedt <srostedt@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Roland McGrath <roland@redhat.com>,
       Ulrich Drepper <drepper@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Clark Williams <williams@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86 alternatives : fix LOCK_PREFIX race with preemptible kernel and CPU hotplug
Message-ID: <20080814212036.GD13814@one.firstfloor.org>
References: <20080814205815.GA14076@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080814205815.GA14076@Krystal>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So, unless these calculus are completely bogus, the difference between the nop
> and the DS case seems not to be statistically significant.

My understanding was that the nops only make a measurable difference in the 
-pg/mcount/ftrace patched out case where every function call starts with a 5
byte nop.

Presumably function calls are much more common than lock prefix operations.

-Andi
