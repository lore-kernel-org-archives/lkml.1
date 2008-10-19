Return-Path: <linux-kernel-owner+w=401wt.eu-S1751500AbYJSEGP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751500AbYJSEGP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 00:06:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750701AbYJSEGA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 00:06:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:40587 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698AbYJSEGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 00:06:00 -0400
Date: Sun, 19 Oct 2008 00:05:57 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Chris Li <lkml@chrisli.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: irq 19: nobody cared
Message-ID: <20081019040557.GA6337@goodmis.org>
References: <70318cbf0809191340t4e9d4caft6656713576cd2084@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <70318cbf0809191340t4e9d4caft6656713576cd2084@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2008 at 01:40:33PM -0700, Chris Li wrote:
> Hi,
> 
> I run into this irq nobody care problem on a dell vostro 200 machine.
> I test the latest git tree. The problem is there as well.
> I also update the BIOS to the latest version. Doesn't help either.
> 
> It seem the IRQ in question is shared between UHCI and SATA controller.
> So I am not sure it is a SATA problem or a USB problem.
> 
> usb 4-2: new full speed USB device using uhci_hcd and address 2
> irq 19: nobody cared (try booting with the "irqpoll" option)
> Pid: 427, comm: nash-hotplug Not tainted 2.6.27-rc6 #1
>  [<c045e3e0>] __report_bad_irq+0x2e/0x6f
>  [<c045e5ea>] note_interrupt+0x1c9/0x21b
>  [<c045db80>] ? handle_IRQ_event+0x2a/0x5a
>  [<c045eba8>] handle_fasteoi_irq+0x99/0xc0
>  [<c045eb0f>] ? handle_fasteoi_irq+0x0/0xc0
>  [<c04059d3>] do_IRQ+0x9a/0xc4
>  [<c0404467>] common_interrupt+0x23/0x28
>  [<c0403989>] ? sysenter_past_esp+0x3a/0x62
>  [<c0630000>] ? serial8250_probe+0x169/0x1c0
>  =======================
> 
> I attached the kernel config file, dmesg and /proc/interrupts.
> 
> Any suggestions? I am willing to try fancy patches.
> 

Hi Chris,

Do you still have this problem, without any "irqpoll" workarourd? If so,
can you boot with the "noapic" kernel command line parameter, and see if
that stops the warning?

Thanks,

-- Steve



