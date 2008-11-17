Return-Path: <linux-kernel-owner+w=401wt.eu-S1756339AbYKQFHg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756339AbYKQFHg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 00:07:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752502AbYKQFG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 00:06:27 -0500
Received: from ozlabs.org ([203.10.76.45]:46163 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752081AbYKQFGZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 00:06:25 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18720.59484.266300.486911@drongo.ozlabs.ibm.com>
Date: Mon, 17 Nov 2008 14:43:24 +1100
From: Paul Mackerras <paulus@samba.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Pekka Paalanen <pq@iki.fi>,
       linuxppc-dev@ozlabs.org, Rusty Russell <rusty@rustcorp.com.au>,
       Paul Mundt <lethal@linux-sh.org>, Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 1/7] ftrace, PPC: do not latency trace idle
In-Reply-To: <20081116212515.093117788@goodmis.org>
References: <20081116212428.938752312@goodmis.org>
	<20081116212515.093117788@goodmis.org>
X-Mailer: VM 8.0.11 under Emacs 22.2.1 (powerpc-unknown-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt writes:

> When idle is called, interrupts are disabled, but the idle function
> will still wake up on an interrupt. The problem is that the interrupt
> disabled latency tracer will take this call to idle as a latency.
> 
> This patch disables the latency tracing when going into idle.

Patch looks OK, but what is the connection with ftrace?

Paul.
