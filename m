Return-Path: <linux-kernel-owner+w=401wt.eu-S932114AbXCDORg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932114AbXCDORg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 09:17:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932149AbXCDORf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 09:17:35 -0500
Received: from www.osadl.org ([213.239.205.134]:39364 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932114AbXCDORf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 09:17:35 -0500
Subject: Re: 2.6.21-rc2-git3 soft lockup detected on CPU#0 (crash dump
	kernel)
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <6bffcb0e0703031531h3f0a86c6sda2522c0ca504765@mail.gmail.com>
References: <6bffcb0e0703031531h3f0a86c6sda2522c0ca504765@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 04 Mar 2007 15:23:28 +0100
Message-Id: <1173018209.24738.135.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-03-04 at 00:31 +0100, Michal Piotrowski wrote:
> Hi,
> 
> I hit this bug again
> (http://www.ussg.iu.edu/hypermail/linux/kernel/0702.2/1643.html)
> 
> BUG: soft lockup detected on CPU#0!
>  [<c1604556>] show_trace_log_lvl+0x1a/0x2f
>  [<c1604c2c>] show_trace+0x12/0x14
>  [<c1604cde>] dump_stack+0x16/0x18
>  [<c16426e7>] softlockup_tick+0x97/0xa7
>  [<c161de38>] run_local_timers+0x12/0x14
>  [<c161e1ce>] update_process_times+0x3e/0x63
>  [<c162c44b>] tick_sched_timer+0x5d/0xa1
>  [<c1629715>] hrtimer_interrupt+0x11e/0x1b2
>  [<c160684e>] timer_interrupt+0xe/0x15
>  [<c164299e>] handle_IRQ_event+0x1a/0x46
>  [<c1643cfe>] handle_level_irq+0x81/0xcb
>  [<c1605dd8>] do_IRQ+0xb4/0xe0
> 
> This time it's a crash dump kernel without SMP.

Is the box stuck, or do you just get those softlockup messages from time
to time ?

	tglx


