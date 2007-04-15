Return-Path: <linux-kernel-owner+w=401wt.eu-S1752927AbXDOMaV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927AbXDOMaV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 08:30:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752969AbXDOMaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 08:30:20 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:36381 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964AbXDOMaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 08:30:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:references:mime-version:content-type;
        b=BQvAeN2YLiGslyb8lmNkRy+3161IIIHYUQ+qWjYCRGKencYVu3WaYh2DH7N4hBC4Z3ImTJ64KOs7W4Rhn9/qN97ytwBxsolzLar13LRqTDYFBJMZzNrdlktpCsei3mk9AUMsbVLdPGfHXegVY/sABD5Yocn1ni0XkYhyqbF1lks=
Date: Sun, 15 Apr 2007 14:29:53 +0200 (CEST)
From: Esben Nielsen <nielsen.esben@googlemail.com>
X-X-Sender: simlo@frodo.shire
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair
 Scheduler [CFS]
In-Reply-To: <20070413202100.GA9957@elte.hu>
Message-ID: <Pine.LNX.4.64.0704151419140.11750@frodo.shire>
References: <20070413202100.GA9957@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Apr 2007, Ingo Molnar wrote:

> [announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
>
> i'm pleased to announce the first release of the "Modular Scheduler Core
> and Completely Fair Scheduler [CFS]" patchset:
>
>   http://redhat.com/~mingo/cfs-scheduler/sched-modular+cfs.patch
>
> This project is a complete rewrite of the Linux task scheduler. My goal
> is to address various feature requests and to fix deficiencies in the
> vanilla scheduler that were suggested/found in the past few years, both
> for desktop scheduling and for server scheduling workloads.
>
> [...]

I took a brief look at it. Have you tested priority inheritance?
As far as  I can see rt_mutex_setprio doesn't have much effect on 
SCHED_FAIR/SCHED_BATCH. I am looking for a place where such a task change 
scheduler class when boosted in rt_mutex_setprio().

Esben

