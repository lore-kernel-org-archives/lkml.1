Return-Path: <linux-kernel-owner+w=401wt.eu-S1750914AbXBVN3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750914AbXBVN3T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 08:29:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751589AbXBVN3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 08:29:19 -0500
Received: from [81.2.110.250] ([81.2.110.250]:44535 "EHLO lxorguk.ukuu.org.uk"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750914AbXBVN3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 08:29:19 -0500
Date: Thu, 22 Feb 2007 14:24:39 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Robert Hancock <hancockr@shaw.ca>, akpm@osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI driver support for pata
Message-ID: <20070222142439.50cff3e9@lxorguk.ukuu.org.uk>
In-Reply-To: <45DD3F20.7050907@pobox.com>
References: <fa.IjFXvdcBtWXV65pRZipPd0NVTOA@ifi.uio.no>
	<45DD2E12.6000705@shaw.ca>
	<45DD3F20.7050907@pobox.com>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > It does seem to drive the PATA controllers, but the cable detection 
> > doesn't seem to be working:

The cable detection is broken in the base code not in the ACPI driver.
It's totally hosed for most chipsets in PIIX.

> > scsi5 : pata_acpi
> > ata5.00: ATAPI, max UDMA/66
> > ata5.00: limited to UDMA/33 due to 40-wire cable
> > ata5.00: configured for UDMA/33
> 
> Honestly I don't think pata_acpi is the best way to go.

ACPI is the only way to do cable handling on the Nvidia PATA chipset. The
problem you see here is core libata breakage from some recent change,
it's broken most chipsets.

Alan
