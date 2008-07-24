Return-Path: <linux-kernel-owner+w=401wt.eu-S1755143AbYGXTNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755143AbYGXTNS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 15:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753000AbYGXTNG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 15:13:06 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:6364 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752885AbYGXTNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 15:13:05 -0400
Subject: Re: [git pull] scheduler updates for v2.6.27, phase #2
From: Daniel Walker <dwalker@mvista.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20080724112412.GA12465@elte.hu>
References: <20080721153804.GA26072@elte.hu>
	 <1216657892.2294.34.camel@dhcp32.mvista.com>
	 <1216668182.7257.80.camel@twins>
	 <1216671393.2294.49.camel@dhcp32.mvista.com>
	 <1216896193.7257.267.camel@twins>  <20080724112412.GA12465@elte.hu>
Content-Type: text/plain; charset=utf-8
Date: Thu, 24 Jul 2008 15:12:40 -0400
Message-Id: <1216926760.15470.14.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-07-24 at 13:24 +0200, Ingo Molnar wrote:

> /me likes.
> 
> applied to tip/sched/urgent, thanks guys.

Anyone for seconds?

kernel/sched.c:1107: warning: ‘init_hrtick’ defined but not used

and sched on ARM,

linus/kernel/sched.c:4227: warning: unsupported argument to ‘__builtin_return_address’
linus/kernel/sched.c:4206: warning: unsupported argument to ‘__builtin_return_address’

Also some ftrace on ARM,

linus/kernel/trace/trace_irqsoff.c:254: warning: unsupported argument to ‘__builtin_return_address’
linus/kernel/trace/trace_irqsoff.c:260: warning: unsupported argument to ‘__builtin_return_address’
linus/kernel/trace/trace_irqsoff.c:316: warning: unsupported argument to ‘__builtin_return_address’
linus/kernel/trace/trace_irqsoff.c:309: warning: unsupported argument to ‘__builtin_return_address’
linus/kernel/trace/trace_irqsoff.c:254: warning: unsupported argument to ‘__builtin_return_address’
linus/kernel/trace/trace_irqsoff.c:260: warning: unsupported argument to ‘__builtin_return_address’

The above also happens in trace_sched_wakeup.c .

Daniel

