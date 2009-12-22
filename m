Return-Path: <linux-kernel-owner+w=401wt.eu-S1752119AbZLVKdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119AbZLVKdV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 05:33:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751979AbZLVKdU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 05:33:20 -0500
Received: from smtp20.orange.fr ([80.12.242.26]:56464 "EHLO smtp20.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751870AbZLVKdT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 05:33:19 -0500
X-ME-UUID: 20091222103101291.46F912005947@mwinf2027.orange.fr
Subject: Re: No PCI-X / PCI-E cards ...
From: Xavier Bestel <xavier.bestel@free.fr>
To: Roland Dreier <rdreier@cisco.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <adahbrp43x7.fsf@roland-alpha.cisco.com>
References: <1260979057.23135.70.camel@skunk> <1261089592.8827.5.camel@bip>
	 <adahbrp43x7.fsf@roland-alpha.cisco.com>
Content-Type: text/plain
Date: Tue, 22 Dec 2009 11:30:57 +0100
Message-Id: <1261477857.22127.23.camel@skunk>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-12-17 at 14:43 -0800, Roland Dreier wrote:
> > [    0.184098] pci 0000:00:1c.0: BAR 13: can't allocate resource
> 
> When does this message appear?  Does it matter if the PCIe card is
> installed or not?  This 0000:00:1c.0 device is:
> 
> > 00:1c.0 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 1 (rev 02)
> 
> so it might be relevant.
> 
> Did you try all the PCIe slots?

I tried another slot, and it gave the same error:
[    0.203279] PCI: Using ACPI for IRQ routing
[    0.203279] pci 0000:00:1c.0: BAR 13: can't allocate resource

And the card still isn't visible through lspci.

How comes the kernel can't see that card ?

	Xav



