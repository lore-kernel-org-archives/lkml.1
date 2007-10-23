Return-Path: <linux-kernel-owner+w=401wt.eu-S1753377AbXJWKP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377AbXJWKP1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 06:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751750AbXJWKPP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 06:15:15 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:50810 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751148AbXJWKPN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 06:15:13 -0400
Message-ID: <471DC9A7.3080105@garzik.org>
Date: Tue, 23 Oct 2007 06:15:03 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Daniel Barkalow <barkalow@iabervon.org>
CC: Linas Vepstas <linas@austin.ibm.com>,
       Shane Huang <chunhao.huang@hotmail.com>, davem@davemloft.net,
       gregkh@suse.de, htejun@gmail.com, brice.goglin@gmail.com,
       david.gaarenstroom@gmail.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, shane.huang@amd.com,
       linux-ide@vger.kernel.org, Brice Goglin <brice@myri.com>
Subject: Re: [patch] PCI: disable MSI on more ATI NorthBridges
References: <BLU112-W5125F6D8BEB3DF6359D53E29F0@phx.gbl> <20071019195749.GK29903@austin.ibm.com> <471911BE.2000405@garzik.org> <Pine.LNX.4.64.0710221555190.32497@iabervon.org> <471D0ADC.7000005@garzik.org> <Pine.LNX.4.64.0710221700120.32497@iabervon.org>
In-Reply-To: <Pine.LNX.4.64.0710221700120.32497@iabervon.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Barkalow wrote:
> I have a device that supports MSI and INTX-disable, and, with MSI on (and 
> delivering interrupts successfully) also sends legacy interrupts (on 
> the IRQ that is no longer associated with the device) unless INTX is 
> disabled. Without the intx_disable(), the kernel disables the IRQ 
> entirely and breaks a random other device in my system.


That sort of behavior is an example of why I wrote pci_intx() in the 
first place, and employed it by default throughout the ATA drivers 
(before it migrated into PCI core).

	Jeff


