Return-Path: <linux-kernel-owner+w=401wt.eu-S1767106AbXEBVty@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767106AbXEBVty (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 17:49:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767123AbXEBVty
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 17:49:54 -0400
Received: from wr-out-0506.google.com ([64.233.184.237]:41509 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767106AbXEBVtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 17:49:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=pnmNRvvNNAAa8i++wZVauUkKiTnvOGpaWdN2L9e18ri0jfyS/OQMfT+Q/SGys7xSlR7M+f/ieqSDQLEx6YZyoghAbMWDBT5sTCNOF40ygO8ZIAFuEzYuog7qxDsihyUyFissChqSmIfQeAvkTCaCQcJpqqlnaBths9hdGB9bGSs=
Message-ID: <6bffcb0e0705021449i5ce6061eg6b684d08348b2d74@mail.gmail.com>
Date: Wed, 2 May 2007 23:49:50 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: tglx@linutronix.de
Subject: Re: 2.6.21-git4 BUG: soft lockup detected on CPU#1!
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1178142556.2340.24.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6bffcb0e0705021442k68d265b3m88746051aa95cb00@mail.gmail.com>
	 <1178142556.2340.24.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/07, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Wed, 2007-05-02 at 23:42 +0200, Michal Piotrowski wrote:
> > Hi Thomas,
> >
> > I hit this soft lockup
> >
> > [ 5401.599275] BUG: soft lockup detected on CPU#1!
> > [ 5401.603809]  [<c0105039>] show_trace_log_lvl+0x1a/0x2f
> > [ 5401.608980]  [<c0105720>] show_trace+0x12/0x14
> > [ 5401.613456]  [<c01057d2>] dump_stack+0x16/0x18
> > [ 5401.617934]  [<c01518e8>] softlockup_tick+0xa7/0xb9
> > [ 5401.622841]  [<c012a0b5>] run_local_timers+0x12/0x14
> > [ 5401.627829]  [<c012a482>] update_process_times+0x3e/0x63
> > [ 5401.633164]  [<c013a028>] tick_sched_timer+0x5d/0xa1
> > [ 5401.638160]  [<c01366fb>] hrtimer_interrupt+0x127/0x1b4
> > [ 5401.643415]  [<c0114c66>] smp_apic_timer_interrupt+0x72/0x84
> > [ 5401.649097]  [<c0104b2b>] apic_timer_interrupt+0x33/0x38
> > [ 5401.654437]  =======================
> > [ 5401.658055] Clocksource tsc unstable (delta = 9372000804 ns)
> > [ 5401.664061] Time: acpi_pm clocksource has been installed.
>
> Hmm. Looks like TSC going awry and the softlockup hits before the tsc
> watchdog logic kicks in.
>
> Was the system stable afterwards ?

It works.

>
>         tglx
>
>
>

Regards,
Michal

-- 
Michal K. K. Piotrowski
Kernel Monkeys
(http://kernel.wikidot.com/start)
