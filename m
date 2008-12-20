Return-Path: <linux-kernel-owner+w=401wt.eu-S1754542AbYLTViT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542AbYLTViT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 16:38:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753743AbYLTViJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 16:38:09 -0500
Received: from mail.gmx.net ([213.165.64.20]:56737 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753733AbYLTViI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 16:38:08 -0500
X-Authenticated: #704063
X-Provags-ID: V01U2FsdGVkX18/FrNlyyU//r8ywq+hdC4Yr1F7Xux7ukiEFllu0m
	WtJjr1myu7wCiW
Date: Sat, 20 Dec 2008 22:38:01 +0100
From: Eric Sesterhenn <snakebyte@gmx.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       John Stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [BUG] Null pointer deref with hrtimer_try_to_cancel()
Message-ID: <20081220213801.GA29021@alice>
References: <20081219172549.GA25722@alice> <alpine.LFD.2.00.0812202117310.3376@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0812202117310.3376@localhost.localdomain>
X-Editor: Vim http://www.vim.org/
X-Info: http://www.snake-basket.de
X-Operating-System: Linux/2.6.28-rc8 (x86_64)
X-Uptime: 22:37:18 up 1 day, 13:40,  6 users,  load average: 0.02, 0.04,
	0.10
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Thomas Gleixner (tglx@linutronix.de) wrote:
> Impact: Prevent kernel crash with posix timer clockid CLOCK_MONOTONIC_RAW
> 
> commit 2d42244ae71d6c7b0884b5664cf2eda30fb2ae68 (clocksource:
> introduce CLOCK_MONOTONIC_RAW) introduced a new clockid, which is only
> available to read out the raw not NTP adjusted system time.

Thanks for the fast response, patch works for me.
Cant trigger the bug anymore.

Greetings, Eric
