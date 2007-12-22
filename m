Return-Path: <linux-kernel-owner+w=401wt.eu-S1753266AbXLVOsa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266AbXLVOsa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 09:48:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751571AbXLVOsV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 09:48:21 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:36092 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbXLVOsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 09:48:21 -0500
Date: Sat, 22 Dec 2007 06:47:19 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz, torvalds@linux-foundation.org
Subject: Re: [patch] Make MMCONFIG space (extended PCI config space) a
 driver opt-in issue
Message-ID: <20071222064719.73fdd9a4@laptopd505.fenrus.org>
In-Reply-To: <476D1D16.5090703@garzik.org>
References: <20071222043139.0cd59804@laptopd505.fenrus.org>
	<476D1D16.5090703@garzik.org>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Dec 2007 09:20:06 -0500
Jeff Garzik <jeff@garzik.org> wrote:

> Arjan van de Ven wrote:
> > Hi,
> > 
> > Linus really wants the extended (4Kb) PCI configuration space
> > (using MCFG acpi table etc) to be opt-in, since there's many issues
> > with it and most drivers don't even use/need it. The idea behind
> > opt-in is that if you don't use it, you don't get to suffer the
> > bugs...
> > 
> > Booted on my 64 bit test machine; sadly it has a defunct BIOS that
> > doesn't have a working MCFG.
> > 
> > 
> > From: Arjan van de Ven <arjan@linux.intel.com>
> > Subject: Make MMCONFIG space a driver opt-in
> > 
> > There are many issues with using the extended PCI configuration
> > space (CPU, Chipset and most of all BIOS bugs). This while the vast
> > majority of drivers and devices don't even use/need to use the
> > memory mapped access methods since they don't use the config space
> > beyond the traditional 256 bytes.
> > 
> > This patch makes accessing the extended config space a driver
> > choice, via the
> > 
> > pci_enable_ext_config(pdev)
> 
> Yuck.  And, Linus is just being silly.  Wait a year then turn on 
> MMCONFIG :)  It took PCI MSI a while to mature, but is finally
> getting there.
> 

Do you hate the name or the concept? I'm certainly open for a better name.... 
