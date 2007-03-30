Return-Path: <linux-kernel-owner+w=401wt.eu-S1753943AbXC3QrB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943AbXC3QrB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 12:47:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753946AbXC3QrB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 12:47:01 -0400
Received: from mail.gmx.net ([213.165.64.20]:55355 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753943AbXC3QrA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 12:47:00 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+h2CkmSSyhrNSeoHOBKoFxW58ZXy3xnfIHx1MKR/
	X0h4D2EXZSGpOZ
Subject: Re: [test] hackbench.c interactivity results: vanilla versus
	SD/RSDL
From: Mike Galbraith <efault@gmx.de>
To: Xenofon Antidides <xantidides@yahoo.gr>
Cc: Ingo Molnar <mingo@elte.hu>, Con Kolivas <kernel@kolivas.org>,
       linux list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <325618.89505.qm@web26701.mail.ukl.yahoo.com>
References: <325618.89505.qm@web26701.mail.ukl.yahoo.com>
Content-Type: text/plain
Date: Fri, 30 Mar 2007 18:46:55 +0200
Message-Id: <1175273215.7185.3.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-30 at 15:05 +0000, Xenofon Antidides wrote:
> ----- Original Message ----
> From: Ingo Molnar <mingo@elte.hu>
> To: Con Kolivas <kernel@kolivas.org>
> Cc: linux list <linux-kernel@vger.kernel.org>; Andrew Morton <akpm@linux-foundation.org>; Mike Galbraith <efault@gmx.de>
> Sent: Thursday, March 29, 2007 9:22:49 PM
> Subject: [test] hackbench.c interactivity results: vanilla versus SD/RSDL
> 
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > * Con Kolivas <kernel@kolivas.org> wrote:
> > 
> > > I'm cautiously optimistic that we're at the thin edge of the bugfix 
> > > wedge now.
> [...]
> 
> > and the numbers he posted:
> > 
> >  http://marc.info/?l=linux-kernel&m=117448900626028&w=2
> 
> We been staring at these numbers for while now and we come to the conclusion they wrong.
> 
> The test is f is 3 tasks, two on different and one on same cpu as sh here:
> virgin 2.6.21-rc3-rsdl-smp
> top - 13:52:50 up 7 min, 12 users,  load average: 3.45, 2.89, 1.51
> 
>   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  P COMMAND
>  6560 root      31   0  2892 1236 1032 R   82  0.1   1:50.24 1 sh
>  6558 root      28   0  1428  276  228 S   42  0.0   1:00.09 1 f
>  6557 root      30   0  1424  280  228 R   35  0.0   1:00.25 0 f
>  6559 root      39   0  1424  276  228 R   33  0.0   0:58.36 0 f

This is a 1 second sample, tasks migrate.

	-Mike

