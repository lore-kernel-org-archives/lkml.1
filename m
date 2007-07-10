Return-Path: <linux-kernel-owner+w=401wt.eu-S1762643AbXGJHav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762643AbXGJHav (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 03:30:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752517AbXGJHao
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 03:30:44 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39748 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752119AbXGJHan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 03:30:43 -0400
Date: Tue, 10 Jul 2007 00:29:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Alessandro Suardi" <alessandro.suardi@gmail.com>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>
Subject: Re: clocksource change of behavior in 2.6.22 compared to 2.6.20
 causes massive system clock slowdown
Message-Id: <20070710002935.f082b7c3.akpm@linux-foundation.org>
In-Reply-To: <5a4c581d0707090727q15eff62ax1fdb1271754cc2d2@mail.gmail.com>
References: <5a4c581d0707090727q15eff62ax1fdb1271754cc2d2@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jul 2007 16:27:59 +0200 "Alessandro Suardi" <alessandro.suardi@gmail.com> wrote:

> My oldish AMD K7-800's clock began falling behind after
>  rebooting from 2.6.20 (and 109 days uptime with a spotless
>  clock) into 2.6.22; time lost is about four minutes each hour.
> 
> Turns out that 2.6.22 marks my TSC as unstable and starts
>  using PIT instead. Rebooting 2.6.22 with clocksource=tsc
>  gets the original stable system time back.
> 
> Not sure whether this is supposed to be the default way of
>  fixing the issue on older machines, though; if anyone sees
>  a problem with this, I'm up for providing more information.
> 
> [root@donkey ~]# cd /sys/devices/system/clocksource/clocksource0/
> [root@donkey clocksource0]# cat available_clocksource
> pit jiffies tsc
> [root@donkey clocksource0]# cat current_clocksource
> tsc
> [root@donkey clocksource0]# uname -a
> Linux donkey 2.6.22 #1 PREEMPT Mon Jul 9 13:26:38 CEST 2007 i686
> athlon i386 GNU/Linux
> [root@donkey clocksource0]# cat /proc/cpuinfo
> processor       : 0
> vendor_id       : AuthenticAMD
> cpu family      : 6
> model           : 4
> model name      : AMD Athlon(tm) Processor
> stepping        : 2
> cpu MHz         : 800.068
> cache size      : 256 KB
> fdiv_bug        : no
> hlt_bug         : no
> f00f_bug        : no
> coma_bug        : no
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 1
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 sep mtrr pge mca
> cmov pat pse36 mmx fxsr syscall mmxext 3dnowext 3dnow
> bogomips        : 1603.17
> clflush size    : 32
> 

(cc's added)
