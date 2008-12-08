Return-Path: <linux-kernel-owner+w=401wt.eu-S1753226AbYLHMfc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226AbYLHMfc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 07:35:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751854AbYLHMfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 07:35:23 -0500
Received: from vps1.tull.net ([66.180.172.116]:50435 "HELO vps1.tull.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751572AbYLHMfW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 07:35:22 -0500
Date: Mon, 8 Dec 2008 23:35:17 +1100
From: Nick Andrew <nick@nick-andrew.net>
To: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] fs: fix warning message with inserting a single	space
Message-ID: <20081208123517.GA3892@mail.local.tull.net>
References: <1228737252-31948-1-git-send-email-Hiroshi.DOYU@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1228737252-31948-1-git-send-email-Hiroshi.DOYU@nokia.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 08, 2008 at 01:54:12PM +0200, Hiroshi DOYU wrote:
> -			printk(KERN_WARNING "%s: %s passed in a files array"
> +			printk(KERN_WARNING "%s: %s passed in a files array "
>  				"with an index of 1!\n", __func__,
>  				s->s_type->name);

Yep. These look like the same kind of thing:

arch/powerpc/platforms/cell/iommu.c +1109
                                pr_debug("iommu: hash window doesn't fit in"
                                         "real DMA window\n");

arch/powerpc/platforms/cell/spider-pci.c +138
                pr_err("SPIDERPCI-IOWA:"
                       "Can't allocate struct spiderpci_iowa_private");

(space after a colon?)

arch/x86/kernel/microcode_intel.c +374
                        printk(KERN_ERR "microcode: error!"
                                        "Bad data in microcode data file\n");

arch/x86/kernel/microcode_amd.c +411
        printk(KERN_WARNING "microcode: AMD microcode update via /dev/cpu/microcode"
                        "is not supported\n");

arch/x86/kernel/pci-dma.c +303
                printk(KERN_INFO "PCI: VIA PCI bridge detected."
                                 "Disabling DAC.\n");

arch/x86/kernel/smpboot.c +412
                printk(KERN_WARNING "WARNING: SMP operation may be unreliable"
                                    "with B stepping processors.\n");

arch/x86/kernel/smpboot.c +420
                printk(KERN_INFO "WARNING: This combination of AMD"
                        "processors is not suitable for SMP.\n");

arch/x86/kernel/smpboot.c +1089
                printk(KERN_WARNING "weird, boot CPU (#%d) not listed"
                                    "by the BIOS.\n", hard_smp_processor_id());

arch/x86/kernel/smpboot.c +1127
                printk(KERN_ERR "... forcing use of dummy APIC emulation."
                                "(tell your hw vendor)\n");

arch/x86/mm/init_32.c +668
                        printk(KERN_WARNING "Warning only 4GB will be used."
                                "Use a HIGHMEM64G enabled kernel.\n");

arch/arm/common/dmabounce.c +510
                         "Never registered with dmabounce but attempting"
                         "to unregister!\n");

arch/arm/plat-omap/dma.c +1843
                        printk(KERN_WARNING "IRQ %04x for non-allocated DMA"
                                        "channel %d\n", status, ch);

arch/arm/plat-omap/mcbsp.c +874
                dev_err(&pdev->dev, "McBSP device initialized without"
                                "platform data\n");

arch/arm/mach-s3c2412/mach-jive.c +255
                printk(KERN_ERR "Unknown mtd set %ld specified,"
                       "using default.", set);

arch/arm/mach-pxa/trizeps4.c +354
                printk(KERN_ERR "trizeps4_mci_init: MMC/SD: can't request"
                                                "MMC card detect IRQ\n");

arch/arm/mach-pxa/mioa701.c +651
        printk(KERN_CRIT "Unregistering mioa701 suspend will hang next"
               "resume !!!\n");

arch/ia64/sn/kernel/io_common.c +354
                printk(KERN_WARNING "on node %d but only %d nodes online."
                       "Association set to undetermined.\n",

arch/ia64/kernel/kprobes.c +249
                        printk(KERN_WARNING "Kprobes on IP-Relative"
                                        "Predict is not supported\n");

Nick.
