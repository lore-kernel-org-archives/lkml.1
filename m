Return-Path: <linux-kernel-owner+w=401wt.eu-S1755545AbYHaRTQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545AbYHaRTQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 13:19:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752942AbYHaRTE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 13:19:04 -0400
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:44148 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752832AbYHaRTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 13:19:03 -0400
Date: Sun, 31 Aug 2008 19:18:36 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: David Witbrodt <dawitbro@sbcglobal.net>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: split e820 reserved entries record to late v2
Message-ID: <20080831171836.GA20894@electric-eye.fr.zoreil.com>
References: <757514.62388.qm@web82108.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <757514.62388.qm@web82108.mail.mud.yahoo.com>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Witbrodt <dawitbro@sbcglobal.net> :
[...]
> ===== SETTERM OUTPUT =====
> Clocksource tsc unstable (delta = -98677795 ns)
> NETDEV WATCHDOG: eth0 (r8169): transmit timed out
> ------------[ cut here ]------------
> WARNING: at net/sched/sch_generic.c:221 dev_watchdog+0x21e/0x250()
> Modules linked in: ipv6 cpufreq_userspace pcspkr 8250_pnp 8250 serial_core evdev
> Pid: 0, comm: swapper Not tainted 2.6.27-rc4.080829.yh-patches-tip #1
> Call Trace:
[...]
>  [<ffffffff8020a8d6>] cpu_idle+0x56/0xa0
> ---[ end trace 28095e4c2b529c2a ]---
> r8169: eth0: link up
> ===== END SETTERM OUTPUT =====
> 
> Other than this strangeness, everything seems OK with your patches.  This
> looks like some random networking annoyance to me, not really related to
> the regression patches, but I'll let better minds be the judge of that.

Could you enable CONFIG_PRINTK_TIME ?

Even if the networking driver manages to negotiate the link, this is
the kind of message which upsets people (myself included :o) ).

-- 
Ueimor
