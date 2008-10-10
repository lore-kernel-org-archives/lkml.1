Return-Path: <linux-kernel-owner+w=401wt.eu-S1753933AbYJJFke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933AbYJJFke (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 01:40:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752169AbYJJFkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 01:40:23 -0400
Received: from casper.infradead.org ([85.118.1.10]:38211 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495AbYJJFkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 01:40:22 -0400
Subject: Re: [tbench regression fixes]: digging out smelly deadmen.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Evgeniy Polyakov <s0mbre@tservice.net.ru>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>
In-Reply-To: <20081009231759.GA8664@tservice.net.ru>
References: <20081009231759.GA8664@tservice.net.ru>
Content-Type: text/plain
Date: Fri, 10 Oct 2008 07:40:05 +0200
Message-Id: <1223617206.7382.54.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-10-10 at 03:17 +0400, Evgeniy Polyakov wrote:

> I was so lucky to 'guess' (just after couple of hundreds of compilations),
> that it corresponds to 8f4d37ec073c17e2d4aa8851df5837d798606d6f commit about
> high-resolution timers, attached patch against 2.6.25 brings tbench
> performance for the 2.6.25 kernel tree to 455 MB/s.

can you try

echo NO_HRTICK > /debug/sched_features

on .27 like kernels?

Also, what clocksource do those machines use?

cat /sys/devices/system/clocksource/clocksource0/current_clocksource

As to, a7be37ac8e1565e00880531f4e2aff421a21c803, could you try
tip/master? I reworked some of the wakeup preemption code in there.

Thanks for looking into this issue!

