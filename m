Return-Path: <linux-kernel-owner+w=401wt.eu-S1756351AbZAIMp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756351AbZAIMp0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 07:45:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753500AbZAIMpL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 07:45:11 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50327 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753496AbZAIMpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 07:45:09 -0500
Date: Fri, 9 Jan 2009 12:44:12 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: linux-ide@vger.kernel.org, Jeff Garzik <jgarzik@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: todays git: WARNING: at drivers/ata/libata-sff.c:1017
 ata_sff_hsm_move+0x45e/0x750()
Message-ID: <20090109124412.619330ea@lxorguk.ukuu.org.uk>
In-Reply-To: <200901091334.55823.borntraeger@de.ibm.com>
References: <200901091334.55823.borntraeger@de.ibm.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Jan 2009 13:34:55 +0100
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> Hello,
> 
> with todays git I lots of these warnings:
> 
> [    1.246807] ata1.00: ATA-7: ST910021AS, 4.06, max UDMA/100
> [    1.253066] ata1.00: 195371568 sectors, multi 16: LBA48
> [    1.262561] ata2.00: ATAPI: HL-DT-ST DVDRAM GSA-U10N, 1.05, max UDMA/33
> [    1.273159] ata1.00: configured for UDMA/100
> [    1.275279] ata2.00: configured for UDMA/33
> [    1.285546] scsi 0:0:0:0: Direct-Access     ATA      ST910021AS       4.06 PQ: 0 ANSI: 5
> [    1.292049] sd 0:0:0:0: Attached scsi generic sg0 type 0
> [    1.298427] sd 0:0:0:0: [sda] 195371568 512-byte hardware sectors: (100 GB/93.1 GiB)
> [    1.299631] scsi 1:0:0:0: CD-ROM            HL-DT-ST DVDRAM GSA-U10N  1.05 PQ: 0 ANSI: 5
> [    1.311059] sd 0:0:0:0: [sda] Write Protect is off
> [    1.317409] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [    1.317426] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    1.318378] ------------[ cut here ]------------
> [    1.318380] WARNING: at drivers/ata/libata-sff.c:1017 ata_sff_hsm_move+0x45e/0x750()
> [    1.318381] Hardware name: 64575GG

Can you see if this goes away if you back out all Arjan's async stuff.
Then if not can you back out my 32bit PIO patch and see if that is the
trigger.

Alan
