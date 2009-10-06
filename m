Return-Path: <linux-kernel-owner+w=401wt.eu-S1756873AbZJFKFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756873AbZJFKFh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 06:05:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756820AbZJFKFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 06:05:37 -0400
Received: from www.tglx.de ([62.245.132.106]:35264 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756762AbZJFKFg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 06:05:36 -0400
Date: Tue, 6 Oct 2009 12:04:54 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Mehlan, Markus" <Markus.Mehlan@ritter.info>
cc: linux-kernel@vger.kernel.org
Subject: Re: AW: AW: clock_nanosleep: cyclic POSIX thread freezes during time
 setting
In-Reply-To: <40F775BBD072A346957E787B3D0DBE5F1C97B5@w2k3-46ex01.RITTER.LOCAL>
Message-ID: <alpine.LFD.2.00.0910061201210.2646@localhost.localdomain>
References: <40F775BBD072A346957E787B3D0DBE5F1C97AF@w2k3-46ex01.RITTER.LOCAL> <alpine.LFD.2.00.0910052044410.2646@localhost.localdomain> <40F775BBD072A346957E787B3D0DBE5F1C97B4@w2k3-46ex01.RITTER.LOCAL> <alpine.LFD.2.00.0910061112400.2646@localhost.localdomain>
 <40F775BBD072A346957E787B3D0DBE5F1C97B5@w2k3-46ex01.RITTER.LOCAL>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Oct 2009, Mehlan, Markus wrote:
> #
> # Kernel hacking
> #
> # CONFIG_PRINTK_TIME is not set
> CONFIG_ENABLE_WARN_DEPRECATED=y
> CONFIG_ENABLE_MUST_CHECK=y
> CONFIG_FRAME_WARN=1024
> CONFIG_MAGIC_SYSRQ=y
> # CONFIG_UNUSED_SYMBOLS is not set
> CONFIG_DEBUG_FS=y
> # CONFIG_HEADERS_CHECK is not set
> # CONFIG_DEBUG_KERNEL is not set
> CONFIG_RTMUTEX_CHECK=y
> # CONFIG_DEBUG_BUGVERBOSE is not set
> CONFIG_HAVE_FTRACE=y
> CONFIG_HAVE_DYNAMIC_FTRACE=y
> # CONFIG_EVENT_TRACER is not set
> # CONFIG_WAKEUP_LATENCY_HIST is not set
> # CONFIG_SAMPLES is not set
> # CONFIG_IRQSTACKS is not set
> # CONFIG_VIRQ_DEBUG is not set
> # CONFIG_BOOTX_TEXT is not set
> # CONFIG_PPC_EARLY_DEBUG is not set

CONFIG_FTRACE=y is missing.

I don't remember whether the older -rt kernels had ftrace support for
powerpc. 

Can you verify whether later -rt versions (29-rt or 31-rt) have the
same problem ?

Thanks,

	tglx
