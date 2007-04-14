Return-Path: <linux-kernel-owner+w=401wt.eu-S1751610AbXDNX0H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751610AbXDNX0H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 19:26:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751623AbXDNX0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 19:26:07 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:4682 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610AbXDNX0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 19:26:05 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sat, 14 Apr 2007 16:26:04 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: William Lee Irwin III <wli@holomorphy.com>
cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair
 Scheduler [CFS]
In-Reply-To: <Pine.LNX.4.64.0704140008001.10930@alien.or.mcafeemobile.com>
Message-ID: <Pine.LNX.4.64.0704141623310.12147@alien.or.mcafeemobile.com>
References: <20070413202100.GA9957@elte.hu> <20070413222151.GD8915@holomorphy.com>
 <Pine.LNX.4.64.0704140008001.10930@alien.or.mcafeemobile.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Apr 2007, Davide Libenzi wrote:

> Haven't looked at the scheduler code yet, but for a similar problem I use 
> a time ring. The ring has Ns (2 power is better) slots (where tasks are 
> queued - in my case they were som sort of timers), and it has a current 
> base index (Ib), a current base time (Tb) and a time granularity (Tg). It 
> also has a bitmap with bits telling you which slots contains queued tasks. 
> An item (task) that has to be scheduled at time T, will be queued in the slot:
> 
> S = Ib + min((T - Tb) / Tg, Ns - 1);

... mod Ns, of course ;)


- Davide


