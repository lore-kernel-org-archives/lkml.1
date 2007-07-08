Return-Path: <linux-kernel-owner+w=401wt.eu-S1753799AbXGHL0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753799AbXGHL0r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 07:26:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750999AbXGHL0j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 07:26:39 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:57407 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbXGHL0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 07:26:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=By8XhjiK6oyJyGor4VSjBDLnuv9HQM1mooUVJUNEA5/Ie7cpXCehXmSlnDwcYWSpy4QWzXL3jbom2Gu40YfNoytr0/iinB5D+jMG/K4tL1ZMaEx9f4u/4RJcwKGtr5VDR0RfnnY8uaObnhOOGxw2dnxA5U7o5hD/xzfVzd116Ks=
Message-ID: <6bffcb0e0707080426y545b105arfe921f21eafa9a91@mail.gmail.com>
Date: Sun, 8 Jul 2007 13:26:37 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "WebLab Help" <help@wecltd.eu>
Subject: Re: Oops in kernel 2.6.22 rc3
Cc: linux-kernel@vger.kernel.org, "Thomas Gleixner" <tglx@linutronix.de>,
       "Ingo Molnar" <mingo@elte.hu>, "Dipankar Sarma" <dipankar@in.ibm.com>
In-Reply-To: <aohr4divd.15j5uve@arsen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <aohr4divd.15j5uve@arsen.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 08/07/07, WebLab Help <help@wecltd.eu> wrote:
> Hello,
>
> I hope you can help me with the following problem.
> One of my systems got some bigger problems, it stops and/or reboots every few days.
> Today I was able to make a screenshot of the kernel oops, it's attached to this email. Because I made it via a digital photography and typing it in again it's possible that there are typos in it but I hope everything is fine.

Please send this photo and config file.

> Remarks: It's a new system - I'm unsure if possibly unreliable hardware also can cause Oopses or if Ooopses everytime are caused by errors in the kernel itself. If it's caused by the hardware - is there a chance to get a hint by the oops pointing to the components causing the errors?

There are some hints about hardware testing in chapter 6
http://www.stardust.webpages.pl/files/handbook/handbook-en-0.3-rc1.pdf

>
> Thank you very much in advance!
>
> Best regards
> Stefan Helbing
> BUG: unable to handle kernel NULL pointer dereference at virtual address 00000000
>  printing eip:
> 00000000
> *pdpt = 000000001966d001
> *pde = 0000000000000000
> Oops: 0010 [#1]
> SMP
> Modules linked in: nfsd exportfs softdog ipt_REJECT ipt_LOG xt_state xt_limit xt_tpcudp iptable_filter nf_conntrack_ftp nf_conntrack_ipv4 nf_conntrack ip_tables x_tables core_temp it87 hwmon_vid hwmon i2c_isa nfs lockd sunrpc 3c59x i2c_i801 unix
> CPU:    0
> EIP:    0060:[<00000000>]    Not tainted VLI
> EFLAGS: 00010206   (2.6.22-rc3-i386 #1)
> EIP is at run_init_process+0x3fefff50/0x20
> eax: f3601344   ebx: 00000000   ecx: c13207c0   edx: f3601344
> esi: c3616720   edi: 00000009   ebp: c042c710   esp: d907df60
> ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
> Process mv (pid: 28651, ti=d907c000 task=d9981030 task.ti=d907c000)
> Stack: c01288dc c361679c 00000000 c0429040 c0128ae7 c011dee8 00000001 c03ecce8
>        c042c760 c0429040 c011dc64 00000000 00000007 00000046 00000812 00000003
>        00012000 c011dc68 00000000 c010c0da b7faa000 c01039c8 b7faa000 00002000
> Call Trace:
>  [<c01288dc>] rcu_do_batch+0x1c/0x90
>  [<c0128ea7>] rcu_process_callbacks+0x17/0x30
>  [<c011dee8>] tasklet_action+0x58/0xa0
>  [<c011dc64>] __do_softirq+0xc4/0xe0
>  [<c011dcb8>] do_softirq+0x38/0x40
>  [<c010c0da>] smp_apic_timer_interrupt+0x2a/0x40
>  [<c01039c8>] apic_timer_interrupt+0x28/0x30
>  =======================
> Code:  Bad EIP value.
> EIP: [<00000000>] run_init_process+0x3fefff50/0x20 SS:ESP 0068:d907df60
> Kernel panic - not syncing: Fatal exception in interrupt
>
>

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
