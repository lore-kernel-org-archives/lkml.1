Return-Path: <linux-kernel-owner+w=401wt.eu-S1945966AbXBBQrZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945966AbXBBQrZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 11:47:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945969AbXBBQrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 11:47:25 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:58317 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1945966AbXBBQrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 11:47:24 -0500
Date: Fri, 2 Feb 2007 17:47:26 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Adam Kropelin <akropel1@rochester.rr.com>
Cc: linux-pci@atrey.karlin.mff.cuni.cz, Auke Kok <auke-jan.h.kok@intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: MSI failure on nForce 430 (WAS: intel 82571EB gigabit fails to see link on 2.6.20-rc5 in-tree e1000 driver (regression))
Message-ID: <20070202164726.GH3754@stusta.de>
References: <20070117190448.A20184@mail.kroptech.com> <45AEB79B.2010205@intel.com> <00d701c73c1f$b2bb2390$84163e05@kroptech.com> <45B1562C.8070503@intel.com> <011101c73c29$9f6f5db0$84163e05@kroptech.com> <45B16491.7030207@intel.com> <023401c73cca$05bc5f00$84163e05@kroptech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <023401c73cca$05bc5f00$84163e05@kroptech.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 20, 2007 at 02:34:37PM -0500, Adam Kropelin wrote:
> (cc: list trimmed and thread moved to linux-pci)
> 
> I have a PCI-E e1000 card that does not see interrupts on 2.6.20-rc5 
> unless CONFIG_PCI_MSI is disabled. An e1000 maintainer indicated that 
> the PHY state is correct, it's just that the interrupt is not getting 
> thru to the kernel. Interestingly, on 2.6.19 PHY interrupts get thru ok 
> with MSI enabled (link status responds appropriately) but packet tx 
> fails with timeout errors, implying that perhaps MAC interrupts are not 
> arriving.
> 
> I've attached the contents dmesg, 'lspci -vvv', and 'cat 
> /proc/interrupts' from 2.6.20-rc5.
> 
> This is an nForce 430 based chipset on a Dell E521 which has had 
> interrupt routing issues before. Prior to 2.6.19 it had to be booted 
> with 'noapic' in order to come up at all. It also had USB lockup 
> problems until I applied the latest BIOS update (v1.1.4). So a BIOS 
> interrupt routing bug with MSI is not out of the question.
> 
> I'm happy to gather more data or run tests...

Was this regression fixed by Eric's patch that is included in -rc7?

> --Adam

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

