Return-Path: <linux-kernel-owner+w=401wt.eu-S1760472AbXEWQDb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760472AbXEWQDb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 12:03:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756921AbXEWQDX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 12:03:23 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:52796 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755773AbXEWQDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 12:03:22 -0400
Date: Wed, 23 May 2007 08:59:58 -0700
From: Greg KH <greg@kroah.com>
To: Manu Abraham <abraham.manu@gmail.com>
Cc: linux-pci@atrey.karlin.mff.cuni.cz,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: PCIE
Message-ID: <20070523155958.GA5282@kroah.com>
References: <46543045.3030904@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46543045.3030904@gmail.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2007 at 04:15:01PM +0400, Manu Abraham wrote:
> Hi,
> 
> Do the PCI Express chipsets also use the same PCI API ?

At the Linux kernel driver level, yes, they do.

> The device
> specifications are thus for the device that i am looking at:
> 
>  PCI Express interface
> 
>     * Compliant to PCI Express Base Specification 1.0a
>     * The PCI Express circuit supports isochronous data traffic intended
> for uninterrupted transfer of streaming data like video streaming
>           o x1 PCI Express endpoint (2.5 Gbit/s)
>           o Data and clock recovery from serial stream
>           o Low jitter and BER
>     * Type 0 configuration space header
>           o 64-bit addressing
>           o Single BAR; programmable address range of 17 bits, 18 bits,
> 19 bits or 20 bits dependent on application requirements
>     * PCI Express capabilities
>           o 128 bytes write packet size and 64 bytes read packet size
>           o MSI support
>           o Software directed power management of four device power
> states (D0 to D3)
>           o Active state power management of link states
>           o Vendor specific capability for VC1 support; after reset VC1
> isochronous capability is disabled
> 
> I have been trying the said card with a normal PCI style driver, but
> while booting the kernel (2.6.21.1) i do get a message like this (an
> Intel DP965LT motherboard with BIOS version:
> MQ96510J.86A.1612.2006.1227.1513)
> Also accessing the interrupt registers causes a hard freeze, for which
> only the RESET button seems to be of any help.
> 
> Uncompressing Linux .. Ok, booting the kernel.
> BIOS bug, no explicit IRQ entries, using default mptable. (tell your hw
> vendor)
> PCI: Failed to allocate mem resource #6:20000@30000000 for 0000:01:00.0
> 
> Any ideas as to what could be wrong ?

What type of PCI device is this?  What driver is controlling it?  What
is the output of 'lspci -v' at boot time?

thanks,

greg k-h
