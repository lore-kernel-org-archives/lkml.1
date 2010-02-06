Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958Ab0BFOrZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Feb 2010 09:47:25 -0500
Received: from www.tglx.de ([62.245.132.106]:57147 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751135Ab0BFOrY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Feb 2010 09:47:24 -0500
Date: Sat, 6 Feb 2010 15:46:50 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andreas Mohr <andi@lisas.de>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       John Stultz <johnstul@us.ibm.com>
Subject: Re: clocksource mutex deadlock, cat current_clocksource
 (2.6.33-rc6)
In-Reply-To: <20100206142141.GA12871@rhlx01.hs-esslingen.de>
Message-ID: <alpine.LFD.2.00.1002061534020.2811@localhost.localdomain>
References: <20100206142141.GA12871@rhlx01.hs-esslingen.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 6 Feb 2010, Andreas Mohr wrote:
> echo t > /proc/sysrq-trigger shows (full output on request):

At least the state of "kwatchdog" would be interesting.

> cat           D 00000000     0 19361   2959 0x00000000
>  de215ef8 00000046 00000000 00000000 c13b0294 dd45c380 dd45c5fc df9c6ef0
>  de215f28 de215f08 c13b0260 00000202 de215f28 c124fcae dd45c380 c13b0280
>  c13b0280 c13b0280 dd45c380 de215f08 ffffffff d9de1000 c13b0338 df9c6ef0
> Call Trace:
>  [<c124fcae>] mutex_lock_nested+0x157/0x23d
>  [<c104873e>] sysfs_show_current_clocksources+0x17/0x41
> 
> INFO: lockdep is turned off.

Why is lockdep turned off ?

Thanks,

	tglx
 
