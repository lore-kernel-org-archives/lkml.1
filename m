Return-Path: <linux-kernel-owner+w=401wt.eu-S1030399AbXBTVLP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030399AbXBTVLP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 16:11:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030404AbXBTVLP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 16:11:15 -0500
Received: from an-out-0708.google.com ([209.85.132.246]:17274 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030399AbXBTVLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 16:11:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=g7pU0fUNXl/NfEFQHOP79UV6uaHDSNLjuqb6fYHFpJYPn9tdJkFP5IA4xMuXaDYKVeHApUGmY+gUCDf8+lI1wT1ydwc7MkiwYDUzc/gKYsgCr5x4PGnbmeXHg8ihaHKTsvXhU9medeRWjtePSOhDu1TI2/DuVWtIJOkcEQ+EeaQ=
Message-ID: <b637ec0b0702201311o5063c4a1j9f8a1bbebc26c9c9@mail.gmail.com>
Date: Tue, 20 Feb 2007 16:11:12 -0500
From: "Fabio Comolli" <fabio.comolli@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.20-git - PATA UDMA/100 configured as UDMA/33
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>, "Jeff Garzik" <jeff@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.
I see a regression in latest -git (2.6.20-g91aa6931). My PATA hard
disk is not correctly configured:

---------------------------------------------------------------------------
libata version 2.10 loaded.
ata_piix 0000:00:1f.1: version 2.00ac7
ata1: PATA max UDMA/100 cmd 0x000101f0 ctl 0x000103f6 bmdma 0x000118c0 irq 14
ata2: PATA max UDMA/100 cmd 0x00010170 ctl 0x00010376 bmdma 0x000118c8 irq 15
scsi0 : ata_piix
ata1.00: ATA-6: TOSHIBA MK8025GAS, KA024A, max UDMA/100
ata1.00: 156301488 sectors, multi 16: LBA
ata1.01: ATAPI, max MWDMA2
ata1.00: configured for UDMA/33
ata1.01: configured for MWDMA2
scsi1 : ata_piix
ata2: port disabled. ignoring.
scsi 0:0:0:0: Direct-Access     ATA      TOSHIBA MK8025GA KA02 PQ: 0 ANSI: 5
-----------------------------------------------------------------------------

Linux-2.6.20 correctly configures the drive as UDMA/100.

Please let me know if you need more details.
Regards,
Fabio
