Return-Path: <linux-kernel-owner+w=401wt.eu-S1752443AbXDQIEL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752443AbXDQIEL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 04:04:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752490AbXDQIEL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 04:04:11 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:4632 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443AbXDQIEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 04:04:08 -0400
X-AuthUser: davidel@xmailserver.org
Date: Tue, 17 Apr 2007 01:03:46 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Ingo Molnar <mingo@elte.hu>
cc: Gene Heskett <gene.heskett@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: [patch] CFS (Completely Fair Scheduler), v2
In-Reply-To: <20070417061849.GA12385@elte.hu>
Message-ID: <Pine.LNX.4.64.0704170053410.30516@alien.or.mcafeemobile.com>
References: <20070416220715.GA4071@elte.hu> <200704170053.58611.gene.heskett@gmail.com>
 <20070417061849.GA12385@elte.hu>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Apr 2007, Ingo Molnar wrote:

> ok - fortunately the delta between -v2-rc0 and -v2-final is pretty 
> small. One difference is the child-runs-first fix. To restore the 
> parent-runs-first logic, do this: 
> 
> 	echo 0 > /proc/sys/kernel/sched_child_runs_first

Sorry, I did not follow the latest developments, but how many tunables we 
have so far in CFS? Are those for debug only or they're supposed to stay?
Weren't those listed inside the Axis of Evil (just to remain in topic :) 
till yesterday?


- Davide


