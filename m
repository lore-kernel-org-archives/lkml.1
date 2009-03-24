Return-Path: <linux-kernel-owner+w=401wt.eu-S1755450AbZCXIMO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450AbZCXIMO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 04:12:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753929AbZCXIL7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 04:11:59 -0400
Received: from www.tglx.de ([62.245.132.106]:40102 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753832AbZCXIL6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 04:11:58 -0400
Date: Tue, 24 Mar 2009 09:11:38 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Announce] 2.6.29-rc8-rt2
In-Reply-To: <1237864404.3441.8.camel@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0903240907390.29264@localhost.localdomain>
References: <1235619922.31774.17.camel@localhost.localdomain>  <1236984825.10748.17.camel@localhost.localdomain>  <alpine.LFD.2.00.0903140845430.29264@localhost.localdomain>  <1237661053.3196.10.camel@localhost.localdomain>  <20090321184904.GA19352@elte.hu>
  <1237662372.3574.2.camel@localhost.localdomain>  <1237663624.3200.3.camel@localhost.localdomain>  <1237687635.3424.1.camel@localhost.localdomain>  <20090322130937.GA22848@elte.hu>  <1237758228.18021.8.camel@localhost.localdomain>  <20090323080724.GA13569@elte.hu>
 <1237864404.3441.8.camel@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Mar 2009, Fernando Lopez-Lezcano wrote:
> without all the funny numbers this is what remains on screen:
>
>   native_cpu_die
>   _cpu_down
>   disable_nonboot_cpus
>   kernel_power_off
>   sys_reboot
>   __hrtimer_start_range_ns
>   default_spin_lock_flags
>   __spin_lock_irqsave
>   __spin_lock_irqrestore
>   hrtimer_try_to_cancel
>   hrtimer_cancel
>   do_nanosleep
>   hrtimer_nanosleep
>   hrtimer_wakeup
>   path_put
>   audit_syscall_entry
>   audit_syscall_exit
>   sysenter_do_call
> Code: 00 00 6a 00 ff 15 08 49 85 c0 58 etc etc etc
> EIP [<c06f2549>] text_poke+0x163/0x181 SS:ESP 0068:f4567ddc

Hmm. Do you have CONFIG_HAVE_DYNAMIC_FTRACE=y in your config ? If yes,
can you please disable it ?

> -- [end trace db3e80122adba82c ]---
> init: rc0 main process (3047) killed by SEGV signal
> 
> (I can take a picture if that would help - I don't have a second machine
> with a serial port to try to capture the whole thing)

That'd be very helpful.
 
Thanks,

	tglx
