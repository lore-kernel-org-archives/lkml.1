Return-Path: <linux-kernel-owner+w=401wt.eu-S965811AbXHJUX1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965811AbXHJUX1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 16:23:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965671AbXHJUXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 16:23:14 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:52276 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965653AbXHJUXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 16:23:11 -0400
Date: Fri, 10 Aug 2007 22:24:29 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Meelis Roos <mroos@linux.ee>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: New section mismatch warnings on ppc
Message-ID: <20070810202429.GB4133@uranus.ravnborg.org>
References: <Pine.SOC.4.64.0708102222200.14225@math.ut.ee>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.SOC.4.64.0708102222200.14225@math.ut.ee>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 10, 2007 at 10:30:09PM +0300, Meelis Roos wrote:
> Tried 2.6.23-rc2+git on ARCH=ppc machine:
> 
>   MODPOST vmlinux.o
> WARNING: vmlinux.o(.text+0x24): Section mismatch: reference to .init.text:early_init (between '__start' and '__after_mmu_off')
> WARNING: vmlinux.o(.text+0x3298): Section mismatch: reference to .init.text:machine_init (between 'start_here' and 'set_context')
> WARNING: vmlinux.o(.text+0x329c): Section mismatch: reference to .init.text:MMU_init (between 'start_here' and 'set_context')
> WARNING: vmlinux.o(.text+0x32c6): Section mismatch: reference to .init.text:start_kernel (between 'start_here' and 'set_context')
> WARNING: vmlinux.o(.text+0x32ca): Section mismatch: reference to .init.text:start_kernel (between 'start_here' and 'set_context')
> WARNING: vmlinux.o(.text+0x11b814): Section mismatch: reference to .init.text:pcibios_fixup_bus (between 'pci_scan_child_bus' and 'pci_scan_bus_parented')
> WARNING: vmlinux.o(.text+0x11c1a0): Section mismatch: reference to .init.text:pcibios_setup (between 'pci_setup' and 'pci_init')

I usually do not care about ppc. Had it been powerpc I would look into these.
Do you see them with powerpc too?

	Sam
