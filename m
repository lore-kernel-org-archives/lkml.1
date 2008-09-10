Return-Path: <linux-kernel-owner+w=401wt.eu-S1754387AbYIJThH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754387AbYIJThH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 15:37:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752015AbYIJTg4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 15:36:56 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:53975 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898AbYIJTgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 15:36:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=eGNQX665Z0kh1UZpmUnhv/krGbumpkZPDpMdPdCNeLZZGpVd0CCrVazP5Iict2tDsW
         QmmgT1VKwOgl/U8acZrBLyGhy1doMfyYuGJ4y/u4ijmmIlLoq5oBAOhkQNpCrgkBq2Xv
         9QyZGidX/ytXpUpauWIPsQwJ+5IUxLYj7GUpI=
Message-ID: <86802c440809101236r495373a3ofde53609dc7023b2@mail.gmail.com>
Date: Wed, 10 Sep 2008 12:36:54 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Justin Mattock" <justinmattock@gmail.com>
Subject: Re: [19.666764] Disabling IRQ #23
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <dd18b0c30809101206j3892e3dbpac9c48cfcaf2982f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dd18b0c30809101206j3892e3dbpac9c48cfcaf2982f@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2008 at 12:06 PM, Justin Mattock
<justinmattock@gmail.com> wrote:
> hello; I accidently erased the original thread
> appologize for starting a new one of the same,
> I've been noticing this message(below) appear
> every "X" amount of boot's(maybe ten or so);
> normally upon booting leaving me unable
> to login.
>
> below is dmesg of the message:
>
> [    0.400075] pci 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
..
> [    0.400104] pci 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
...
> [   10.848404] USB Universal Host Controller Interface driver v3.0
> [   10.857709] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
> [   10.867186] uhci_hcd 0000:00:1d.0: setting latency timer to 64
> [   10.876344] uhci_hcd 0000:00:1d.0: UHCI Host Controller
> [   10.885571] SELinux: initialized (dev usbfs, type usbfs), uses genfs_contexts
> [   10.894904] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned
> bus number 1
> [   10.904218] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00004080
> [   10.913838] usb usb1: configuration #1 chosen from 1 choice
> [   10.923378] hub 1-0:1.0: USB hub found
> [   10.932676] hub 1-0:1.0: 2 ports detected
..
> [   12.119258] usb 2-2: configuration #1 chosen from 1 choice
> [   12.140614] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
> [   12.149917] ehci_hcd 0000:00:1d.7: setting latency timer to 64
> [   12.159523] ehci_hcd 0000:00:1d.7: EHCI Host Controller
> [   12.168858] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned
> bus number 5
> [   12.182246] ehci_hcd 0000:00:1d.7: debug port 1
> [   12.191574] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
> [   12.200970] ehci_hcd 0000:00:1d.7: irq 23, io mem 0x50405400
> [   12.250079] usb 3-2: new full speed USB device using uhci_hcd and address 2
> [   12.270062] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00,
> driver 10 Dec 2004
> [   12.279955] usb usb5: configuration #1 chosen from 1 choice
> [   12.289791] hub 5-0:1.0: USB hub found
> [   12.299531] hub 5-0:1.0: 8 ports detected
> [   12.309416] ath_pci: svn r3359
> [   12.332576] hub 3-0:1.0: unable to enumerate USB device on port 2
> [   12.356208] ACPI: SBS HC: EC = 0xf78c8000, offset = 0x20, query_bit = 0x10
> [   12.478925] Symbol init_mm is marked as UNUSED, however this module
> is using it.
> [   12.488823] This symbol will go away in the future.
> [   12.498834] Please evalute if this is the right api to use and if
> it really is, submit a report the linux kernel mailinglist together
> with submitting your code for inclusion.

> [   18.821797] irq 23: nobody cared (try booting with the "irqpoll" option)
> [   18.830005] Pid: 2371, comm: swapon Tainted: P          2.6.27-rc6 #22
> [   18.830005]  [<c0151748>] __report_bad_irq+0x2e/0x6f
> [   18.830005]  [<c015196f>] note_interrupt+0x1e6/0x217
> [   18.830005]  [<c0150d47>] ? handle_IRQ_event+0x2a/0x5a
> [   18.830005]  [<c0151f20>] handle_fasteoi_irq+0x91/0xb6
> [   18.830005]  [<c0104ff2>] do_IRQ+0x6c/0x86
> [   18.830005]  [<c0103a6f>] common_interrupt+0x23/0x28
> [   18.830005]  [<c021007b>] ? blkdev_ioctl+0x4b0/0x719
> [   18.830005]  [<c0117347>] ? kunmap_atomic+0x4/0xa5
> [   18.830005]  [<c015fc58>] __do_fault+0x2ca/0x32a
> [   18.830005]  [<c0170cf0>] ? check_bytes_and_report+0x21/0x93
> [   18.830005]  [<c0161191>] handle_mm_fault+0x2de/0x62c
> [   18.830005]  [<c01635e3>] ? remove_vma+0x41/0x47
> [   18.830005]  [<c01727d0>] ? kmem_cache_free+0x80/0x96
> [   18.830005]  [<c039ebac>] do_page_fault+0x2d8/0x60c
> [   18.830005]  [<c0127a95>] ? irq_exit+0x53/0x6d
> [   18.830005]  [<c039e8d4>] ? do_page_fault+0x0/0x60c
> [   18.830005]  [<c039d2a2>] error_code+0x72/0x78
> [   18.830005]  =======================
> [   18.830005] handlers:
> [   18.830005] [<c02cc9fb>] (usb_hcd_irq+0x0/0x79)
> [   18.830005] [<c02cc9fb>] (usb_hcd_irq+0x0/0x79)
> [   18.830005] Disabling IRQ #23


uhci and ehci share one irq. and irq handers for them all registered....

or there is hub under that uhci again...

YH
