Return-Path: <linux-kernel-owner+w=401wt.eu-S1758568AbXHKX1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758568AbXHKX1t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 19:27:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752386AbXHKX1m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 19:27:42 -0400
Received: from xenotime.net ([66.160.160.81]:38338 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751529AbXHKX1l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 19:27:41 -0400
Date: Sat, 11 Aug 2007 16:33:31 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: "Dave Young" <hidave.darkstar@gmail.com>
Cc: "Dave Jones" <davej@codemonkey.org.uk>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: two questions about the boot_delay
Message-Id: <20070811163331.b8ff4a6b.rdunlap@xenotime.net>
In-Reply-To: <a8e1da0708080039w1deed062hf5920e1257eb1cbb@mail.gmail.com>
References: <a8e1da0708080039w1deed062hf5920e1257eb1cbb@mail.gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Aug 2007 07:39:33 +0000 Dave Young wrote:

> Hi,
> I have tried the "slow down printk" , and I have two questions.
> 
> 1. why it depends the DEBUG_KERNEL? Sometimes we only need boot_delay
> to see the printk infomations.  How about set it as a standalone
> config option?

Is depending on DEBUG_KERNEL a problem?  If so, why?

It sure seems like a kernel debug option to me, although
I have no strong preference pro or con on this.

> 2. In My system if I boot with boot_delay=200 the early part of
> booting will be very slow, eapecially at the very beginning (after the
> compressing  and start kernel, it nearly stop here many minutes).
> 
> And I wonder if we can simply use mdelay in the boot_delay_msec(). I
> tested the mdelay , and the result is more accurate.

I wasn't convinced that loops_per_jiffy was always set for all
architectures that early during boot.  Did you audit and verify that
it is set early enough to use during boot_delay_msec()?
and if so, for all architectures?
What architectures did you test this on?


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
