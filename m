Return-Path: <linux-kernel-owner+w=401wt.eu-S1755805AbYISUug@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755805AbYISUug (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 16:50:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754231AbYISUu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 16:50:28 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:4104 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753937AbYISUu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 16:50:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=DvWNq+r4yo4416W8EqYiwuPMw831Wx8fNTW6EcGOojcZgsW4O+NWeZAN936CP1aS5/
         zz7amnZTJ4WfUNla6SPZJKKKneC4AIFeFdmmUiTzTUVrUVpe7cZypg4IgKgT+Qu3VPaH
         Mymc2fLZuDGSE9BgsaKM2AbiCwHgwgRMfLj68=
Message-ID: <86802c440809191350h21327c76l55d2134d7667f5d0@mail.gmail.com>
Date: Fri, 19 Sep 2008 13:50:26 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
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

On Fri, Sep 19, 2008 at 1:40 PM, Chris Li <lkml@chrisli.org> wrote:
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

can you boot with pci=earlydump ?

YH
