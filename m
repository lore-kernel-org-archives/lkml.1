Return-Path: <linux-kernel-owner+w=401wt.eu-S1751732AbYKQFGs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751732AbYKQFGs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 00:06:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751242AbYKQFGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 00:06:22 -0500
Received: from ozlabs.org ([203.10.76.45]:46195 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750783AbYKQFGV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 00:06:21 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18720.63178.864933.911090@drongo.ozlabs.ibm.com>
Date: Mon, 17 Nov 2008 15:44:58 +1100
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
Subject: Re: [PATCH 4/7] ftrace, PPC: use probe_kernel API to modify code
In-Reply-To: <20081116212515.728019601@goodmis.org>
References: <20081116212428.938752312@goodmis.org>
	<20081116212515.728019601@goodmis.org>
X-Mailer: VM 8.0.11 under Emacs 22.2.1 (powerpc-unknown-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt writes:

> Impact: use cleaner probe_kernel API over assembly
> 
> Using probe_kernel_read/write interface is a much cleaner approach
> than the current assembly version.

Possibly naive question: how is it possible for the accesses to the
instructions to fault, given that we are called through kstop_machine
(according to the comment) and nothing else should be happening?

Paul.
