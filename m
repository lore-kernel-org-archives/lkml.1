Return-Path: <linux-kernel-owner+w=401wt.eu-S1754643AbYJQBNk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643AbYJQBNk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 21:13:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752492AbYJQBNb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 21:13:31 -0400
Received: from ozlabs.org ([203.10.76.45]:50663 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750986AbYJQBNa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 21:13:30 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18679.57954.270256.597333@cargo.ozlabs.ibm.com>
Date: Fri, 17 Oct 2008 11:54:58 +1100
From: Paul Mackerras <paulus@samba.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Miller <davem@davemloft.net>, benh@kernel.crashing.org,
       Ingo Molnar <mingo@redhat.com>
Subject: Re: [RFC patch 04/15] get_cycles() : powerpc64 HAVE_GET_CYCLES
	(update)
In-Reply-To: <20081017004328.GA29768@Krystal>
References: <20081016232729.699004293@polymtl.ca>
	<20081016234656.055839676@polymtl.ca>
	<18679.56239.74999.534588@cargo.ozlabs.ibm.com>
	<20081017004328.GA29768@Krystal>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers writes:

> Do you know if mtfb implies an instruction synchronization (isync) ? I

It doesn't.

> think that if it does not, the new get_cycles_barrier() might have to be
> used at some locations in the kernel code if more precise timestamp
> order is required.

OK.  I'll let you figure out where. :)

Paul.
