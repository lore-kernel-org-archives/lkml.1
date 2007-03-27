Return-Path: <linux-kernel-owner+w=401wt.eu-S964868AbXC0Hc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964868AbXC0Hc6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 03:32:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965310AbXC0Hc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 03:32:58 -0400
Received: from www.osadl.org ([213.239.205.134]:56756 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S964868AbXC0Hc5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 03:32:57 -0400
Subject: Re: + hrtimers-fix-reprogramming-smp-race.patch added to -mm tree
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@osdl.org>
Cc: mingo@elte.hu, michal.k.k.piotrowski@gmail.com,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <200703261946.l2QJkevj028804@shell0.pdx.osdl.net>
References: <200703261946.l2QJkevj028804@shell0.pdx.osdl.net>
Content-Type: text/plain
Date: Tue, 27 Mar 2007 09:32:47 +0200
Message-Id: <1174980767.4023.11.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-26 at 12:46 -0700, akpm@linux-foundation.org wrote:
> The patch titled
>      hrtimers: fix reprogramming SMP race
> has been added to the -mm tree.  Its filename is
>      hrtimers-fix-reprogramming-smp-race.patch
> 
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> 
> See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
> out what to do about this
> 
> ------------------------------------------------------
> Subject: hrtimers: fix reprogramming SMP race
> From: Ingo Molnar <mingo@elte.hu>
> 
> hrtimer_start() incorrectly set the 'reprogram' flag to enqueue_hrtimer(),
> which should only be 1 if the hrtimer is queued to the current CPU.
> 
> Doing otherwise could result in a reprogramming of the current CPU's
> clockevents device, with a timer that is not queued to it - resulting in a
> bogus next expiry value.

Doh.

> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Acked-by: Thomas Gleixner <tglx@linutronix.de>

Andrew, this should go into 2.6.21 as well.

	tglx



