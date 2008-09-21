Return-Path: <linux-kernel-owner+w=401wt.eu-S1754650AbYIUAXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650AbYIUAXS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 20:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751931AbYIUAXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 20:23:05 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:4138 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782AbYIUAXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 20:23:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=YnBS497LQF4VBp+VwM9QICKqGWMPtrOrjZ5Rr8ZYI8kOtOdcNbYIdsSMNAMlIH9aJH
         6+JiXyv8O5MhpdGLbXB8G8mluTOiU/uSwNYDE4LA8JoyeQ91suY/8TbtIldnD2HHHCc8
         1EvkRnhgz9JNk0iF6/Ifk2ZiNHJvAaRriRH4Q=
Message-ID: <21d7e9970809201723h22a0b5c8m4486a3e823021d39@mail.gmail.com>
Date: Sun, 21 Sep 2008 10:23:03 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "Chris Li" <lkml@chrisli.org>
Subject: Re: irq 19: nobody cared
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <70318cbf0809191340t4e9d4caft6656713576cd2084@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <70318cbf0809191340t4e9d4caft6656713576cd2084@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 20, 2008 at 6:40 AM, Chris Li <lkml@chrisli.org> wrote:
> Hi,
>
> I run into this irq nobody care problem on a dell vostro 200 machine.
> I test the latest git tree. The problem is there as well.
> I also update the BIOS to the latest version. Doesn't help either.
>
> It seem the IRQ in question is shared between UHCI and SATA controller.
> So I am not sure it is a SATA problem or a USB problem.

Has it got bluetooth?

If so try turning it off. Don't ask why.

Dave.
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
> Thanks
>
> Chris
>
