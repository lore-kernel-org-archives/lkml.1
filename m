Return-Path: <linux-kernel-owner+w=401wt.eu-S1752418AbZJEOjE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752418AbZJEOjE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 10:39:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751751AbZJEOjD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 10:39:03 -0400
Received: from fanny.its.uu.se ([130.238.4.241]:44325 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751722AbZJEOjC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 10:39:02 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19146.1202.511428.691521@pilspetsen.it.uu.se>
Date: Mon, 5 Oct 2009 16:37:38 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: <linux-ide@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: sata_via: SError: { UnrecovData Proto TrStaTrns }
In-Reply-To: <m3my46yo5g.fsf@intrepid.localdomain>
References: <m3my46yo5g.fsf@intrepid.localdomain>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Halasa writes:
 > Hi,
 > 
 > What could that be?
 > VIA VT6421A mini-PCI card and SATA SSD from Transcend. IXP425 (ARM)
 > little-endian CPU. 128 MB RAM - VT6421A can access only the first 64 MB
 > of system RAM, but there is bounce buffering (a la swiotlb) for the
 > rest.
 > 
 > Sometimes it produces:
 > 
 > ata1.00: exception Emask 0x12 SAct 0x0 SErr 0x1000500 action 0x6
 > ata1.00: BMDMA stat 0x5
 > ata1: SError: { UnrecovData Proto TrStaTrns }
 > ata1.00: cmd c8/00:20:b7:18:38/00:00:00:00:00/e0 tag 0 dma 16384 in
 >          res 51/40:20:b7:18:38/00:00:00:00:00/e0 Emask 0x12 (ATA bus error)
 > ata1.00: status: { DRDY ERR }
 > ata1.00: error: { UNC }
 > ata1: hard resetting link
 > ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
 > ata1.00: configured for UDMA/100
 > ata1: EH complete
 > 
 > Any ideas?

Try again with a known good SATA disk instead of the SSD.

What is the make and model of that mini-PCI card?
