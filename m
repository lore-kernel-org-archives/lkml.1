Return-Path: <linux-kernel-owner+w=401wt.eu-S933675AbXFFQEx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933675AbXFFQEx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 12:04:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759105AbXFFQEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 12:04:46 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:55460 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754868AbXFFQEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 12:04:46 -0400
Date: Wed, 6 Jun 2007 18:04:51 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Thomas Voegtle <tv@lio96.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.16.52 can't boot on Intel DG965SS
Message-ID: <20070606160451.GN5500@stusta.de>
References: <Pine.LNX.4.63.0706061436190.32355@er-systems.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.63.0706061436190.32355@er-systems.de>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2007 at 05:16:00PM +0200, Thomas Voegtle wrote:
> 
> Hi,
> 
> I want to use 2.6.16.y on the Intel DG965SS mainboard, but the kernel 
> stops booting:
> 
> ...
> ACPI: bus type pci registered
> PCI: Using MMCONFIG
> ACPI: Subsystem revision 20060127
> ACPI: Interpreter enabled
> ACPI: Using IOAPIC for interrupt routing
> ACPI: PCI Root Bridge [PCI0] (0000:00)
> ACPI: Assume root bridge [\_SB_.PCIO] bus is 0 
> 
> 
> 
> A Kernel 2.6.16.52 boots with pci=nommconf.
> A SuSE 10.1 installation cd boots with no special bootparams.
> A Kernel 2.6.17 vanilla boots with no special bootparams.
> 
> 
> So something is missing in 2.6.16.y, can anyone point me to a patch or 
> something else which enables this?
>...

Set in the kernel configuration:
  Bus options (PCI, PCMCIA, EISA, MCA, ISA)
    PCI access mode
to "Direct".

There are fixes in this area in 2.6.17, but that's something I'll not 
fiddle with in 2.6.16.

>       Thomas

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

