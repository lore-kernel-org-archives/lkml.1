Return-Path: <linux-kernel-owner+w=401wt.eu-S1756519AbYLDUGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756519AbYLDUGZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 15:06:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753635AbYLDUGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 15:06:15 -0500
Received: from kroah.org ([198.145.64.141]:47258 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753602AbYLDUGO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 15:06:14 -0500
Date: Thu, 4 Dec 2008 11:53:40 -0800
From: Greg KH <greg@kroah.com>
To: leonw@mailcan.com
Cc: Leon Woestenberg <leon.woestenberg@axon.tv>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/1] staging: Driver for Altera PCI Express Chaining
	DMA reference design"
Message-ID: <20081204195340.GA30442@kroah.com>
References: <20081201134557.4356327A85@heartbeat2.messagingengine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081201134557.4356327A85@heartbeat2.messagingengine.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2008 at 08:45:57AM -0500, leonw@mailcan.com wrote:
> Altera PCI Express Chaining DMA driver
> 
> A reference driver that exercises the Chaining DMA logic reference
> design generated along the Altera FPGA PCI Express soft or hard core,
> only if instantiated using the MegaWizard, not the SOPC builder, of
> Quartus 8.1.
> 
> This driver can be used to test the logic instantiation and PCI
> Express layers and acts as a starting point for driving custom logic
> connected to the PCI Express End Point Chaining DMA engines.
> 
> PATCH v3 has some checkpatch.sh cleanups and adds the TODO file.

I got a build error with this version, and had to remove the #include
<byteorder.h> line.

After that, I get the following build warnings:
  CC [M]  drivers/staging/altpciechdma/altpciechdma.o
drivers/staging/altpciechdma/altpciechdma.c: In function ‘dma_test’:
drivers/staging/altpciechdma/altpciechdma.c:541: warning: cast from pointer to integer of different size
drivers/staging/altpciechdma/altpciechdma.c:548: warning: assignment makes integer from pointer without a cast
drivers/staging/altpciechdma/altpciechdma.c: In function ‘probe’:
drivers/staging/altpciechdma/altpciechdma.c:803: warning: cast from pointer to integer of different size
drivers/staging/altpciechdma/altpciechdma.c:931: warning: label ‘err_rev’ defined but not used
drivers/staging/altpciechdma/altpciechdma.c:914: warning: label ‘err_cdev’ defined but not used
drivers/staging/altpciechdma/altpciechdma.c: At top level:
drivers/staging/altpciechdma/altpciechdma.c:416: warning: ‘ape_sg_to_chdma_table’ defined but not used

Also, sparse spits out a lot of warnings as well.

Care to send me a follow-on patch to fix these up?

thanks,

greg k-h
