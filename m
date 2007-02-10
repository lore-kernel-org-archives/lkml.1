Return-Path: <linux-kernel-owner+w=401wt.eu-S1751771AbXBJSxM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751771AbXBJSxM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 13:53:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751783AbXBJSxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 13:53:12 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:34804 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751771AbXBJSxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 13:53:11 -0500
Date: Sat, 10 Feb 2007 19:06:43 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: <rol@as2917.net>
Cc: "'Robert Hancock'" <hancockr@shaw.ca>,
       "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>
Subject: Re: AHCI - remove probing of ata2
Message-ID: <20070210190643.2e865cc9@localhost.localdomain>
In-Reply-To: <00c601c74d42$c81b2170$2101a8c0@donald>
References: <00ba01c74d39$604fddf0$2101a8c0@donald>
	<00c601c74d42$c81b2170$2101a8c0@donald>
X-Mailer: Claws Mail 2.7.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Feb 2007 19:39:21 +0100
"Paul Rolland" <rol@as2917.net> wrote:

> > I've been trying this, but I ended with the ICH7 not detecting anymore
> > my IDE disks... 
> > Should try again, maybe I missed something.
> 
> Done a new built, and I now have :
> 
> Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
> ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
> hda: Maxtor 6L200P0, ATA DISK drive
> hdb: ASUS CRW-5232A3, ATAPI CD/DVD-ROM drive

You have the old driver 0n 0x1F0


> PCI: Device 0000:02:00.0 not available because of resource collisions
> ahci: probe of 0000:02:00.0 failed with error -22
> ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 22 (level, low) -> IRQ 22
> ata: 0x1F0 IDE port busy

And the new drivers trying to manage the same port

> CONFIG_IDE=y
> CONFIG_BLK_DEV_IDE=y

Set those to "N" and try again

