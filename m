Return-Path: <linux-kernel-owner+w=401wt.eu-S1756010AbXFKWny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010AbXFKWny (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 18:43:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753354AbXFKWnr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 18:43:47 -0400
Received: from rtr.ca ([64.26.128.89]:1972 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752354AbXFKWnq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 18:43:46 -0400
Message-ID: <466DD020.2030307@rtr.ca>
Date: Mon, 11 Jun 2007 18:43:44 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [patch-mm 00/23] High resolution timer updates and x86_64	support
References: <20070610092437.118387863@inhelltoy.tec.linutronix.de>	 <466C7F44.1040309@rtr.ca> <1181539165.8176.38.camel@chaos>
In-Reply-To: <1181539165.8176.38.camel@chaos>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> Mark,
> 
> On Sun, 2007-06-10 at 18:46 -0400, Mark Lord wrote:
>> Do you know if there's anything specific in there that would fix
>> the start-up race condition with HRTIMERS on my machine here
>> (previously discussed, yet unresolved)?
>>
>> It still happens sporadically on boot-up -- maybe one in 10 boots without
>> any change in the kernel binary..
> 
> on which kernel version ?

Originally back with 2.6.21, but more recently on kernels as new as 2.6.22-rc3.

For now, I've simply grabbed your new patchset and applied it to 2.6.22-rc4-git*,
and I'll cry out again if the problem should recur with your latest stuff.

Thanks.

> 
> -------- Original Message --------
> Subject: [BUG] 2.6.21: Kernel won't boot with either/both of CONFIG_NO_HZ, CONFIG_HIGH_RES_TIMERS
> Date: Mon, 30 Apr 2007 16:17:00 -0400
> From: Mark Lord <lkml@rtr.ca>
> To: Linux Kernel <linux-kernel@vger.kernel.org>, tglx@linutronix.de
> CC: Linus Torvalds <torvalds@osdl.org>
> 
> I have a new notebook (Dell Inspiron 9400) with Core2-Duo T7400 @ 2.1Ghz.
> When either/both of CONFIG_NO_HZ, CONFIG_HIGH_RES_TIMERS is used,
> the 2.6.21 kernel hangs on startup just after printing one/both of these:
> 
> kernel: switched to high resolution mode on cpu 1
> kernel: switched to high resolution mode on cpu 0
> 
> 100% of the time.  The only fix I've found is to rebuild
> the kernel without those two options.
> 
> The failed kernel.config is attached.
> Here is /proc/cpuinfo and lspci -v.
> 
> Any help appreciated.

