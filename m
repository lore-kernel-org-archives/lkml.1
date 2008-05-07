Return-Path: <linux-kernel-owner+w=401wt.eu-S1760200AbYEGE00@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760200AbYEGE00 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 00:26:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752671AbYEGE0S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 00:26:18 -0400
Received: from smtp.enter.net ([216.193.128.24]:4355 "EHLO smtp.enter.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752610AbYEGE0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 00:26:16 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: WARNING: at arch/x86/kernel/genapic_64.c:86
Date: Wed, 7 May 2008 00:26:13 -0400
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>
References: <c4e36d110804220204h3043e526xee3966876355cde0@mail.gmail.com> <200805070041.55369.rjw@sisk.pl>
In-Reply-To: <200805070041.55369.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805070026.13836.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 May 2008 18:41:55 Rafael J. Wysocki wrote:
> On Tuesday, 22 of April 2008, Zdenek Kabelac wrote:
> > Hello
> >
> > I've update to the current commit 2.6.25
> > 8a81f2738f10ca817c975cec893aa58497e873b2
>
> Does it still happen with the current -git?

I see this error as well, but only with the currently functional 2.6.25 
version I'm running ATM. It isn't there when I boot the not fully functional 
linux-next builds I've been testing.

DRH

> > I get this boot WARNING:
> >
> >  tbxface-0598 [00] tb_load_namespace     : ACPI Tables successfully
> > acquired evxfevnt-0091 [00] enable                : Transition to ACPI
> > mode successful ------------[ cut here ]------------
> > WARNING: at arch/x86/kernel/genapic_64.c:86 read_apic_id+0x81/0x90()
> > Modules linked in:
> > Pid: 1, comm: swapper Not tainted 2.6.25 #57
> >
> > Call Trace:
> >  [<ffffffff8103d64f>] warn_on_slowpath+0x5f/0x90
> >  [<ffffffff81062afa>] ? get_lock_stats+0x2a/0x70
> >  [<ffffffff81062b4e>] ? put_lock_stats+0xe/0x30
> >  [<ffffffff81038b56>] ? set_cpus_allowed_ptr+0x86/0x120
> >  [<ffffffff812ee295>] ? _spin_unlock_irqrestore+0x65/0x90
> >  [<ffffffff810649e1>] ? trace_hardirqs_on+0x131/0x190
> >  [<ffffffff812ee275>] ? _spin_unlock_irqrestore+0x45/0x90
> >  [<ffffffff810233f1>] read_apic_id+0x81/0x90
> >  [<ffffffff814bdcde>] verify_local_APIC+0xc4/0x186
> >  [<ffffffff814bcaaf>] native_smp_prepare_cpus+0x16e/0x38f
> >  [<ffffffff814b139b>] kernel_init+0x5a/0x31b
> >  [<ffffffff810649e1>] ? trace_hardirqs_on+0x131/0x190
> >  [<ffffffff812ee1ed>] ? _spin_unlock_irq+0x3d/0x80
> >  [<ffffffff812edbd9>] ? trace_hardirqs_on_thunk+0x35/0x3a
> >  [<ffffffff810649e1>] ? trace_hardirqs_on+0x131/0x190
> >  [<ffffffff8100d548>] child_rip+0xa/0x12
> >  [<ffffffff8100cc33>] ? restore_args+0x0/0x30
> >  [<ffffffff814b1341>] ? kernel_init+0x0/0x31b
> >  [<ffffffff8100d53e>] ? child_rip+0x0/0x12
> >
> > ---[ end trace ca143223eefdc828 ]---
> > ------------[ cut here ]------------
> > WARNING: at arch/x86/kernel/genapic_64.c:86 read_apic_id+0x81/0x90()
> > Modules linked in:
> > Pid: 1, comm: swapper Not tainted 2.6.25 #57
> >
> > Call Trace:
> >  [<ffffffff8103d64f>] warn_on_slowpath+0x5f/0x90
> >  [<ffffffff81062afa>] ? get_lock_stats+0x2a/0x70
> >  [<ffffffff81062b4e>] ? put_lock_stats+0xe/0x30
> >  [<ffffffff81038b56>] ? set_cpus_allowed_ptr+0x86/0x120
> >  [<ffffffff812ee295>] ? _spin_unlock_irqrestore+0x65/0x90
> >  [<ffffffff810649e1>] ? trace_hardirqs_on+0x131/0x190
> >  [<ffffffff812ee275>] ? _spin_unlock_irqrestore+0x45/0x90
> >  [<ffffffff810233f1>] read_apic_id+0x81/0x90
> >  [<ffffffff814bdd00>] verify_local_APIC+0xe6/0x186
> >  [<ffffffff814bcaaf>] native_smp_prepare_cpus+0x16e/0x38f
> >  [<ffffffff814b139b>] kernel_init+0x5a/0x31b
> >  [<ffffffff810649e1>] ? trace_hardirqs_on+0x131/0x190
> >  [<ffffffff812ee1ed>] ? _spin_unlock_irq+0x3d/0x80
> >  [<ffffffff812edbd9>] ? trace_hardirqs_on_thunk+0x35/0x3a
> >  [<ffffffff810649e1>] ? trace_hardirqs_on+0x131/0x190
> >  [<ffffffff8100d548>] child_rip+0xa/0x12
> >  [<ffffffff8100cc33>] ? restore_args+0x0/0x30
> >  [<ffffffff814b1341>] ? kernel_init+0x0/0x31b
> >  [<ffffffff8100d53e>] ? child_rip+0x0/0x12
> >
> > ---[ end trace ca143223eefdc828 ]---
> > CPU0: Intel(R) Core(TM)2 Duo CPU     T7500  @ 2.20GHz stepping 0a
> > Using local APIC timer interrupts.
> >
> >
> >
> > Zdenek
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel"
> > in the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/



-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.
