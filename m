Return-Path: <linux-kernel-owner+w=401wt.eu-S1755870AbZBKBRd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870AbZBKBRd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 20:17:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753509AbZBKBRX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 20:17:23 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:63909 "EHLO
	VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752952AbZBKBRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 20:17:22 -0500
X-BigFish: VS-34(zz119bM1432R98dR1805M3117K103dKzz10c0jzzz2dh6bh63h)
X-Spam-TCS-SCL: 2:0
Message-ID: <499226F9.5000307@am.sony.com>
Date: Tue, 10 Feb 2009 17:16:41 -0800
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: frank.rowand@am.sony.com
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: wuzj@lemote.com
CC: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: the current status of RT_PREEMPT for mips
References: <20955.222.92.8.142.1234138032.squirrel@mail.lemote.com>
In-Reply-To: <20955.222.92.8.142.1234138032.squirrel@mail.lemote.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Feb 2009 01:16:49.0674 (UTC) FILETIME=[6A2B6EA0:01C98BE6]
X-SEL-encryption-scan: scanned
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wuzj@lemote.com wrote:
> HI!
> 
> I'm planning to port RE_PREEMPT to loongson2f(a mipsel compatible
> processor), the "FAQ" web page of RTWiKi(rt.wiki.kernel.org) shows that
> "There are systems representing the x86, x86_64, ARM, MIPS, and Power
> architectures using the CONFIG_PREEMPT_RT patch.", does it means that
> RT_PREEMPT support  MIPS architecture? because i can not find any more
> information about it, I tried to use the latest RT_PREEMPT on qemu
> 0.9.1/mipssim, it can not boot, so I come to get your help, could you give
> any current status of RT_PREEMPT for mips? such as:
> 
> 1. does the latest RT_PREEMPT(for linux 2.6.26.8) support MIPS
> architecture? or any older one support it?
> 2. if Yes, which MIPS processors have been successfully running RT_PREEMPT?
> 
> looking forward to your reply, thanks!
> 
> Best Regards,
> falcon

I do not have information for current versions of the kernel, but last year
I was running 2.6.24-rt1 on a Toshiba tx4937 to do some experiments.

I have a few trivial patches for the latency tracer, but if you use a newer
kernel they are not needed because ftrace replaced the latency tracer
in 2.6.24-rt2.

-Frank Rowand
Sony Corporation of America

