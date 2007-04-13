Return-Path: <linux-kernel-owner+w=401wt.eu-S1030185AbXDMWQ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030185AbXDMWQ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 18:16:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030468AbXDMWQ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 18:16:57 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:30191 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030314AbXDMWQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 18:16:56 -0400
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair
	Scheduler [CFS]
From: Daniel Walker <dwalker@mvista.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20070413202100.GA9957@elte.hu>
References: <20070413202100.GA9957@elte.hu>
Content-Type: text/plain
Date: Fri, 13 Apr 2007 15:15:46 -0700
Message-Id: <1176502546.3129.79.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-04-13 at 22:21 +0200, Ingo Molnar wrote:
> [announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
> 
> i'm pleased to announce the first release of the "Modular Scheduler Core
> and Completely Fair Scheduler [CFS]" patchset:
> 
>    http://redhat.com/~mingo/cfs-scheduler/sched-modular+cfs.patch
> 
> This project is a complete rewrite of the Linux task scheduler. My goal
> is to address various feature requests and to fix deficiencies in the
> vanilla scheduler that were suggested/found in the past few years, both
> for desktop scheduling and for server scheduling workloads.

I'm not in love with the current or other schedulers, so I'm indifferent
to this change. However, I was reviewing your release notes and the
patch and found myself wonder what the logarithmic complexity of this
new scheduler is .. I assumed it would also be constant time , but the
__enqueue_task_fair doesn't appear to be constant time (rbtree insert
complexity).. Maybe that's not a critical path , but I thought I would
at least comment on it.

Daniel

