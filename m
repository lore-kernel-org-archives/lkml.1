Return-Path: <linux-kernel-owner+w=401wt.eu-S1762732AbYEIMWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762732AbYEIMWY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 08:22:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754482AbYEIMWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 08:22:07 -0400
Received: from fonzie.hosting9000.com ([85.214.50.12]:40921 "EHLO
	fonzie.hosting9000.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762225AbYEIMWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 08:22:06 -0400
Message-ID: <482441E1.90403@googlemail.com>
Date: Fri, 09 May 2008 14:21:53 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Thomas Gleixner <tglx@linutronix.de>,
       John Stultz <johnstul@us.ibm.com>, hinko.kocevar@cetrtapot.si
Subject: Re: CONFIG_PRINTK_TIME broken on git HEAD ?
References: <48222C7C.2050807@googlemail.com> <20080507154155.2b472bb1.akpm@linux-foundation.org> <482233CD.70502@googlemail.com> <4822DD4E.3010000@googlemail.com> <1210245238.13978.199.camel@twins> <4822E23F.8040101@googlemail.com> <1210325973.13978.216.camel@twins> <20080509094224.GD16037@elte.hu>
In-Reply-To: <20080509094224.GD16037@elte.hu>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
>> Subject: sched: fixup sched-clock offset
>> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
>>
>> It could happen that ktime doesn't start at 0.
> 
> applied, thanks Peter. I'm wondering which clocks do this - HPET 
> perhaps?

The box is using TSC clocksource right now , for some reason in >=2.6.25* kernels HPET registered to late.

http://lkml.org/lkml/2008/5/8/164


> 
> 	Ingo
> 


Gabriel
