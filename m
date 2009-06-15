Return-Path: <linux-kernel-owner+w=401wt.eu-S935274AbZFOVnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935274AbZFOVnT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 17:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934602AbZFOVnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 17:43:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50851 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755451AbZFOVnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 17:43:06 -0400
Message-ID: <4A36BF61.10901@zytor.com>
Date: Mon, 15 Jun 2009 14:38:41 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
       paulus@samba.org, acme@redhat.com, linux-kernel@vger.kernel.org,
       penberg@cs.helsinki.fi, vegard.nossum@gmail.com, efault@gmx.de,
       jeremy@goop.org, npiggin@suse.de, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf_counter: x86: Fix call-chain	support
 to use NMI-safe methods
References: <20090615184858.GD6520@Krystal> <1245091917.6741.185.camel@laptop> <20090615185907.GF6520@Krystal> <1245092561.6741.205.camel@laptop> <4A369CD8.3090505@zytor.com> <20090615192720.GA9056@Krystal> <4A36A1C7.6080005@zytor.com> <20090615210119.GD24554@elte.hu> <20090615211207.GB12919@Krystal> <20090615211605.GC27100@elte.hu> <20090615213429.GD12919@Krystal>
In-Reply-To: <20090615213429.GD12919@Krystal>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> 
> As the maintainer of the out-of-tree LTTng tracer, which hooks in the
> page fault handler with tracepoints, and which can build almost entirely
> as modules, I am very tempted to argue that having the nmi-code entirely
> robust wrt in-kernel page faults would be a very-nice-to-have feature.
> 

I doubt that is ever going to be reliable, due to reentrancy issues.

	-hpa
