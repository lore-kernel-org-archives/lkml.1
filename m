Return-Path: <linux-kernel-owner+w=401wt.eu-S965211AbXCHIFj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965211AbXCHIFj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 03:05:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965771AbXCHIFj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 03:05:39 -0500
Received: from nz-out-0506.google.com ([64.233.162.232]:15135 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965763AbXCHIFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 03:05:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=aSOUz3g9Rla36oXw636TyHiCFx3yKUsuCd0D2Bxt15tFd7kIDnW+rj6VbafvqMNuNhtRk1znq7OTzoWex6ucT4gx+MwdVQfxwr+/fqcShz2qOZtMkvS67X71ejQc6dJBmmweLog30cgy2LA2Q/FV7VQC97oILaSQlI8O5IIDDmI=
Message-ID: <45EFC3D1.208@gmail.com>
Date: Thu, 08 Mar 2007 17:05:37 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
CC: linux-ide@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>
Subject: Re: OOPS with 2.6.21rc2-git (ata: conflict with ide0/1)
References: <45EC9A67.8070204@intel.com>
In-Reply-To: <45EC9A67.8070204@intel.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[cc'ing Greg, Hi]

Kok, Auke wrote:
> 
> Attached dmesg. config.gz. here's the OOPS part.
> 
> ata_piix 0000:00:1f.2: version 2.10
> ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
> ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level, low) -> IRQ 19
> ata: 0x1F0 IDE port busy
> ata: conflict with ide0
> BUG: at drivers/pci/pci.c:846 pcim_pin_device()
>  [<c023838c>] pcim_pin_device+0x4c/0x60
>  [<c0371af6>] ata_pci_init_one+0x2d6/0x380
>  [<c023b968>] pci_get_device+0x18/0x20
>  [<c0378651>] piix_check_450nx_errata+0x31/0x110
>  [<c0238b90>] pci_intx+0x20/0x90
>  [<c0378a97>] piix_init_one+0x117/0x200
>  [<c023afca>] pci_call_probe+0xa/0x10
>  [<c023b01e>] __pci_device_probe+0x4e/0x60
>  [<c023b056>] pci_device_probe+0x26/0x60
>  [<c0295a94>] really_probe+0xb4/0x170
>  [<c023afa8>] pci_match_device+0xa8/0xc0
>  [<c0295c28>] driver_probe_device+0xc8/0xd0
>  [<c0465521>] klist_next+0x61/0xc0
>  [<c0295d30>] __driver_attach+0x80/0x90
>  [<c0294d0a>] bus_for_each_dev+0x3a/0x60
>  [<c0295d56>] driver_attach+0x16/0x20
>  [<c0295cb0>] __driver_attach+0x0/0x90
>  [<c029532f>] bus_add_driver+0x5f/0x110
>  [<c023b3d2>] __pci_register_driver+0x82/0xc0
>  [<c05c0b91>] piix_init+0x11/0x20
>  [<c059ab11>] do_initcalls+0x41/0x130
>  [<c0158acc>] register_irq_proc+0x9c/0xc0
>  [<c01b4462>] proc_mkdir_mode+0x42/0x60
>  [<c059ac30>] init+0x0/0xa0
>  [<c059ac7c>] init+0x4c/0xa0
>  [<c0104e7f>] kernel_thread_helper+0x7/0x18
>  =======================
> ata: 0x170 IDE port busy
> ata: conflict with ide1
> ata_piix: probe of 0000:00:1f.2 failed with error -16
> ata_piix 0000:00:1f.5: MAP [ P0 P2 P1 P3 ]

Patch pending in Greg's queue.

Thanks.

-- 
tejun
