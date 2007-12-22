Return-Path: <linux-kernel-owner+w=401wt.eu-S1755435AbXLVOUn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435AbXLVOUn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 09:20:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754015AbXLVOUP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 09:20:15 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:35080 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753269AbXLVOUM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 09:20:12 -0500
Message-ID: <476D1D16.5090703@garzik.org>
Date: Sat, 22 Dec 2007 09:20:06 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: linux-kernel@vger.kernel.org, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [patch] Make MMCONFIG space (extended PCI config space) a driver
 opt-in issue
References: <20071222043139.0cd59804@laptopd505.fenrus.org>
In-Reply-To: <20071222043139.0cd59804@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> Hi,
> 
> Linus really wants the extended (4Kb) PCI configuration space (using MCFG acpi table etc) to be opt-in, since there's many issues with it and most drivers don't even use/need it. The idea behind opt-in is that if you don't use it, you don't get to suffer the bugs...
> 
> Booted on my 64 bit test machine; sadly it has a defunct BIOS that doesn't have a working MCFG.
> 
> 
> From: Arjan van de Ven <arjan@linux.intel.com>
> Subject: Make MMCONFIG space a driver opt-in
> 
> There are many issues with using the extended PCI configuration space 
> (CPU, Chipset and most of all BIOS bugs). This while the vast majority of drivers
> and devices don't even use/need to use the memory mapped access methods since they
> don't use the config space beyond the traditional 256 bytes.
> 
> This patch makes accessing the extended config space a driver choice, via the
> 
> pci_enable_ext_config(pdev)

Yuck.  And, Linus is just being silly.  Wait a year then turn on 
MMCONFIG :)  It took PCI MSI a while to mature, but is finally getting 
there.

	Jeff





