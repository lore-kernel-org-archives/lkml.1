Return-Path: <linux-kernel-owner+w=401wt.eu-S1751766AbXCDQ23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751766AbXCDQ23 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 11:28:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751809AbXCDQ23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 11:28:29 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:42934 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766AbXCDQ21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 11:28:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kUEbc1fD+tU45fufFJE0jL9dXzk4Tm7Rl729h3vAXQuObpz6t8l1AyriQU+SPb+f12kpgVRbV6IIp3CF57Dv1yp64/99MTEXdrDct532/Tz6lcInkouoPBwfQrKBFkM/yxD07QLbdVpzbp36DNIVPOAkHdhiBwiLabFGkAg2XC4=
Message-ID: <6bffcb0e0703040828j46a339c2ofabf7c0e20f6ae09@mail.gmail.com>
Date: Sun, 4 Mar 2007 17:28:25 +0100
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: tglx@linutronix.de
Subject: Re: 2.6.21-rc2-git3 soft lockup detected on CPU#0 (crash dump kernel)
Cc: "Ingo Molnar" <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1173022668.24738.141.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6bffcb0e0703031531h3f0a86c6sda2522c0ca504765@mail.gmail.com>
	 <1173018209.24738.135.camel@localhost.localdomain>
	 <6bffcb0e0703040636q5a4ed3ekf5a0461052e8e018@mail.gmail.com>
	 <1173022668.24738.141.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/07, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Sun, 2007-03-04 at 15:36 +0100, Michal Piotrowski wrote:
> > > > BUG: soft lockup detected on CPU#0!
> > > >  [<c1604556>] show_trace_log_lvl+0x1a/0x2f
> > > >  [<c1604c2c>] show_trace+0x12/0x14
> > > >  [<c1604cde>] dump_stack+0x16/0x18
> > > >  [<c16426e7>] softlockup_tick+0x97/0xa7
> > > >  [<c161de38>] run_local_timers+0x12/0x14
> > > >  [<c161e1ce>] update_process_times+0x3e/0x63
> > > >  [<c162c44b>] tick_sched_timer+0x5d/0xa1
> > > >  [<c1629715>] hrtimer_interrupt+0x11e/0x1b2
> > > >  [<c160684e>] timer_interrupt+0xe/0x15
> > > >  [<c164299e>] handle_IRQ_event+0x1a/0x46
> > > >  [<c1643cfe>] handle_level_irq+0x81/0xcb
> > > >  [<c1605dd8>] do_IRQ+0xb4/0xe0
> > > >
> > > > This time it's a crash dump kernel without SMP.
> > >
> > > Is the box stuck, or do you just get those softlockup messages from time
> > > to time ?
> >
> > The box stuck on it.
> >
> > I can reproduce this on 2.6.21-rc2-git3 and 2.6.20.1.
>
> Ahh. That's something different, i.e. unrelated to highres/dynticks.
> 2.6.20.1 does not have them.
>
> Can you please add "initcall_debug" and "ignore_loglevel" to the kernel
> command line ?

Here is a full serial console log
http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.21-rc2-git3-kdump/log.txt

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
