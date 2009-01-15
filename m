Return-Path: <linux-kernel-owner+w=401wt.eu-S1765319AbZAOTV6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765319AbZAOTV6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 14:21:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765570AbZAOTVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 14:21:32 -0500
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:44918 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765461AbZAOTVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 14:21:31 -0500
Date: Thu, 15 Jan 2009 11:21:29 -0800
From: Ira Snyder <iws@ovro.caltech.edu>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Rusty Russell <rusty@rustcorp.com.au>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       shemminger@vyatta.com, netdev@vger.kernel.org
Subject: Re: [PATCH RFC v5] net: add PCINet driver
Message-ID: <20090115192129.GB9091@ovro.caltech.edu>
Mail-Followup-To: Arnd Bergmann <arnd@arndb.de>,
	Rusty Russell <rusty@rustcorp.com.au>,
	David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
	linuxppc-dev@ozlabs.org, shemminger@vyatta.com,
	netdev@vger.kernel.org
References: <20090107195052.GA24981@ovro.caltech.edu> <200901151358.34250.arnd@arndb.de> <20090115165359.GA2230@ovro.caltech.edu> <200901151853.52202.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901151853.52202.arnd@arndb.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (ovro.ovro.caltech.edu); Thu, 15 Jan 2009 11:21:30 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2009 at 06:53:51PM +0100, Arnd Bergmann wrote:
> On Thursday 15 January 2009, Ira Snyder wrote:
> > 
> > These are PCI boards, not PCIe. The host computers are all Pentium3-M
> > systems. I tried enabling MSI on the Freescale boards in the driver, by
> > calling pci_enable_msi() during probe(), and it failed. 
> 
> That doesn't really mean anything, just that the PCI endpoint doesn't
> announce its capability to do MSI in the config space, or that it
> does not have an interrupt line. Since you basically implement the
> device on the FSL board, you should also be able to define the interrupt
> capabilities by writing to the config space.
> 
> Do you know what kind of chipset the host uses? It should be fairly
> simple to find out whether or not it can do MSI.
> 

I have another question for you Arnd.

What did you use as the host and guest drivers when you ran virtio over
PCI? Did you use two unmodified instances of virtio_net (one on host,
one on guest) for networking, or did you write new virtio drivers for
those? How about for virtio_console (if you ran it at all).

Thanks again,
Ira
