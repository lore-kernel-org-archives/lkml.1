Return-Path: <linux-kernel-owner+w=401wt.eu-S1763192AbXKOQgr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763192AbXKOQgr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 11:36:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757188AbXKOQgj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 11:36:39 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:52003 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757160AbXKOQgi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 11:36:38 -0500
Date: Thu, 15 Nov 2007 19:36:19 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Rusty Russel <rusty@rustcorp.com.au>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Paul E McKenney <paulmck@us.ibm.com>,
       Richard Gooch <rgooch@atnf.csiro.au>,
       Tigran Aivazian <tigran@aivazian.fs.co.uk>,
       Shoahua Li <shaohua.li@linux.com>, Ralf Baechle <ralf@linux-mips.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Nathan Lynch <ntl@pobox.com>, Paul Jackson <pj@sgi.com>,
       Christoph Lameter <clameter@sgi.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [RFC PATCH 3/3] cpu-hotplug: Replace per-subsystem mutexes with get_online_cpus()
Message-ID: <20071115163619.GA110@tv-sign.ru>
References: <20071115134924.GA15282@in.ibm.com> <20071115135336.GC15462@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071115135336.GC15462@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15, Gautham R Shenoy wrote:
>
> This patch converts the known per-subsystem mutexes to get_online_cpus
> put_online_cpus. It also eliminates the CPU_LOCK_ACQUIRE
> and CPU_LOCK_RELEASE hotplug notification events.
> 
> Signed-off-by: Gautham  R Shenoy <ego@in.ibm.com>
> ---
>  include/linux/notifier.h |    4 +---
>  kernel/cpu.c             |    4 ----
>  kernel/sched.c           |   25 +++++++++----------------
>  kernel/workqueue.c       |   35 +++++++++++++++--------------------
>  mm/slab.c                |   18 +++++++++++-------

Can't really comment the changes outside the workqueue.c, but imho the
whole series is very good.

Oleg.

