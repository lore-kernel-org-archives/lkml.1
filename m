Return-Path: <linux-kernel-owner+w=401wt.eu-S1753634Ab0AMFkK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634Ab0AMFkK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 00:40:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753320Ab0AMFj7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 00:39:59 -0500
Received: from qmta08.emeryville.ca.mail.comcast.net ([76.96.30.80]:39214 "EHLO
	qmta08.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753072Ab0AMFj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 00:39:58 -0500
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
 barrier (v5)
From: Nicholas Miell <nmiell@comcast.net>
To: paulmck@linux.vnet.ibm.com
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       josh@joshtriplett.org, tglx@linutronix.de, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com, laijs@cn.fujitsu.com, dipankar@in.ibm.com
In-Reply-To: <20100113053126.GC6781@linux.vnet.ibm.com>
References: <20100113013757.GA29314@Krystal>
	 <1263358823.3874.10.camel@entropy>
	 <20100113053126.GC6781@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Jan 2010 21:39:56 -0800
Message-ID: <1263361196.3874.12.camel@entropy>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-01-12 at 21:31 -0800, Paul E. McKenney wrote:
> Why is it OK to ignore the developer's request for an expedited
> membarrer()?  The guy who expected the syscall to complete in a few
> microseconds might not be so happy to have it take many milliseconds.
> By the same token, the guy who specified non-expedited so as to minimally
> disturb other threads in the system might not be so happy to see them
> all be IPIed for no good reason.  ;-)
> 
> 							Thanx, Paul

Because the behavior is still correct, even if it is slower than you'd
expect. It doesn't really matter where the expedited flag goes, though,
because every future kernel will understand it.

-- 
Nicholas Miell <nmiell@comcast.net>

