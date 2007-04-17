Return-Path: <linux-kernel-owner+w=401wt.eu-S1751906AbXDQHTZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906AbXDQHTZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 03:19:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751943AbXDQHTZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 03:19:25 -0400
Received: from aa012msr.fastwebnet.it ([85.18.95.72]:51726 "EHLO
	aa012msr.fastwebnet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906AbXDQHTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 03:19:24 -0400
Date: Tue, 17 Apr 2007 09:18:59 +0200
From: Paolo Ornati <ornati@fastwebnet.it>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: Willy Tarreau <w@1wt.eu>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: [patch] CFS (Completely Fair Scheduler), v2
Message-ID: <20070417091859.78dc0062@localhost>
In-Reply-To: <200704170151.09244.gene.heskett@gmail.com>
References: <20070416220715.GA4071@elte.hu>
	<200704170053.58611.gene.heskett@gmail.com>
	<20070417052550.GA9491@1wt.eu>
	<200704170151.09244.gene.heskett@gmail.com>
X-Mailer: Claws Mail 2.6.1 (GTK+ 2.10.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Apr 2007 01:51:08 -0400
Gene Heskett <gene.heskett@gmail.com> wrote:

> FWIW, I've been using the CFQ I/O scheduler for quite a while, is it time I 
> gave the AS or Deadline versions another check?  They are all built in but I 
> don't know how to change the default on the fly, or even if it can be done.

easy :)

# cat /sys/block/DEVICE/queue/scheduler
as noop [cfq] ...

# echo IO_SCHED > /sys/block/DEVICE/queue/scheduler

-- 
	Paolo Ornati
	Linux 2.6.21-rc7 on x86_64
