Return-Path: <linux-kernel-owner+w=401wt.eu-S1755757AbYDJKSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755757AbYDJKSR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 06:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753723AbYDJKSG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 06:18:06 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:46352 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948AbYDJKSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 06:18:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=a4gv5ctwB5ooUVV5HRr0cSsa+qUkRdmRUW10vTy3+pp8Omf2V4+kqiUoaz/A0lwSVgm5Db/A/RRkrpKI3Jl1MrYwXgmCGkWxUhWUt69ktf4sWap+DyATd3TR3GcOzzqQxE0Q/d7HGwDjcxPY6FU0PAS0VdkpzjjKFFvTHdDZUo0=
Message-ID: <47FDE881.1030409@gmail.com>
Date: Thu, 10 Apr 2008 12:14:25 +0200
From: Jacek Luczak <difrost.kernel@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Andy Whitcroft <apw@shadowen.org>
Subject: Re: [BUG] linux-next: Tree for April 9 warning on CC_STACKPROTECTOR,
 followed by kernel panic
References: <20080409185309.b94c9d15.sfr@canb.auug.org.au> <47FDE045.4070509@linux.vnet.ibm.com>
In-Reply-To: <47FDE045.4070509@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kamalesh Babulal pisze:
> Hi Stephen,
> 
> The next-20080409 kernel warns while booting up on a x86_64 machine.
> When compiled the kernel with CONFIG_CC_STACKPROTECTOR=y, the warning
> is followed by the kernel panic.
> 
> Testing -fstack-protector-all feature
> No -fstack-protector-stack-frame!
> -fstack-protector-all test failed
> ------------[ cut here ]------------
> WARNING: at kernel/panic.c:365 __stack_chk_test+0x4b/0x50()
> Modules linked in:
> Pid: 1, comm: swapper Not tainted 2.6.25-rc8-next-20080409-autotest #1
> 
> Call Trace:
>  [<ffffffff80231f5e>] warn_on_slowpath+0x51/0x63
>  [<ffffffff80232d93>] printk+0x4e/0x56
>  [<ffffffff80382fcd>] extract_entropy+0x47/0x90
>  [<ffffffff80230000>] dup_mm+0xca/0x3fd
>  [<ffffffff80231eba>] __stack_chk_test_func+0x21/0x32
>  [<ffffffff80231fbb>] __stack_chk_test+0x4b/0x50
>  [<ffffffff808ba8f1>] kernel_init+0x189/0x2f9
>  [<ffffffff804ee221>] _spin_unlock_irq+0x9/0xc
>  [<ffffffff8020cb88>] child_rip+0xa/0x12
>  [<ffffffff808ba768>] kernel_init+0x0/0x2f9
>  [<ffffffff8020cb7e>] child_rip+0x0/0x12
> 
> ---[ end trace d88d2f3a71e3b32c ]---

Hi,

what version of GCC are you using?

-Jacek
