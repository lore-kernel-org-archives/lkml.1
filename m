Return-Path: <linux-kernel-owner+w=401wt.eu-S936363AbXJST6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936363AbXJST6i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 15:58:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934609AbXJST6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 15:58:05 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:43874 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753761AbXJST6B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 15:58:01 -0400
Date: Fri, 19 Oct 2007 14:57:49 -0500
To: Shane Huang <chunhao.huang@hotmail.com>
Cc: davem@davemloft.net, gregkh@suse.de, htejun@gmail.com,
       brice.goglin@gmail.com, david.gaarenstroom@gmail.com,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       shane.huang@amd.com, jgarzik@pobox.com, linux-ide@vger.kernel.org
Subject: Re: [patch] PCI: disable MSI on more ATI NorthBridges
Message-ID: <20071019195749.GK29903@austin.ibm.com>
References: <BLU112-W5125F6D8BEB3DF6359D53E29F0@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BLU112-W5125F6D8BEB3DF6359D53E29F0@phx.gbl>
User-Agent: Mutt/1.5.11
From: linas@austin.ibm.com (Linas Vepstas)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2007 at 09:17:23PM +0800, Shane Huang wrote:
> Since we have little experience on PCI and MSI here, we had to try to

As someone else pointed out, AMD should have *lots* of people with
pci and msi experience on the payroll.  (Folks here buy AMD-designed 
pci chips ...)

> ONLY
> comment out the pci_intx() call in drivers/ata/ahci.c
> My system can boot up too with MSI enabled!
> 
> So does it mean that the root cause is our SB700 SATA controller
> has a hardware bug where setting INTX_DISABLE in the PCI COMMAND
> register masks MSI interrupts too? 

That's what it sounds like, to me.

> And what is the software solution or workaround?

Not sure. Sounds like the device driver needs a quirk for this part.

The over-worked Jeff Garzik is the maintainer for that driver.

You should probably provide the pci device id for this beast.

--linas

