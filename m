Return-Path: <linux-kernel-owner+w=401wt.eu-S1766821AbXDSPoD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766821AbXDSPoD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 11:44:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766823AbXDSPoB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 11:44:01 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:4297 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766821AbXDSPoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 11:44:00 -0400
X-AuthUser: davidel@xmailserver.org
Date: Thu, 19 Apr 2007 08:43:41 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Ingo Molnar <mingo@elte.hu>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>, Nick Piggin <npiggin@suse.de>,
       William Lee Irwin III <wli@holomorphy.com>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Mike Galbraith <efault@gmx.de>, Con Kolivas <kernel@kolivas.org>,
       ck list <ck@vds.kolivas.org>, Bill Huey <billh@gnuppy.monkey.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair
 Scheduler [CFS]
In-Reply-To: <20070419080053.GA4106@elte.hu>
Message-ID: <Pine.LNX.4.64.0704190837420.31693@alien.or.mcafeemobile.com>
References: <20070418055525.GS11115@waste.org>
 <alpine.LFD.0.98.0704180742470.2828@woody.linux-foundation.org>
 <20070418152355.GU11115@waste.org> <alpine.LFD.0.98.0704181012470.2828@woody.linux-foundation.org>
 <20070418174945.GA7930@elte.hu> <20070418175936.GA11980@elte.hu>
 <alpine.LFD.0.98.0704181223190.2828@woody.linux-foundation.org>
 <Pine.LNX.4.64.0704181304250.25880@alien.or.mcafeemobile.com>
 <20070418214816.GA10902@elte.hu> <Pine.LNX.4.64.0704181515290.25880@alien.or.mcafeemobile.com>
 <20070419080053.GA4106@elte.hu>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Apr 2007, Ingo Molnar wrote:

> i disagree that the user 'would expect' this. Some users might. Others 
> would say: 'my 10-thread rendering engine is more important than a 
> 1-thread job because it's using 10 threads for a reason'. And the CFS 
> feedback so far strengthens this point: the default behavior of treating 
> the thread as a single scheduling (and CPU time accounting) unit works 
> pretty well on the desktop.
> 
> think about it in another, 'kernel policy' way as well: we'd like to 
> _encourage_ more parallel user applications. Hurting them by accounting 
> all threads together sends the exact opposite message.

There are counter argouments too. Like, not every user knows if a certain 
process is MT or not. I agree though that doing accounting and fairness at 
a depth lower then USER is messy, and not only for performance.


- Davide


