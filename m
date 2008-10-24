Return-Path: <linux-kernel-owner+w=401wt.eu-S1757076AbYJXR5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757076AbYJXR5U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 13:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752015AbYJXR5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 13:57:08 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:11621 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965AbYJXR5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 13:57:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=tlNXy9suNGXlcB1XOiLpZI2DyiQBAaMBIp//9sxsQKOS5CTwYhyjlLzDtIHK/OMYAN
         Y9QoLM43P7bTtwS24UHStbJYGPiTfBDH0XWA5+gpnS4zEcIaQ7f4UFymcFYAPihZmrY6
         QP9YMWF7woMEtLR0AJzTNyBadEXZihVv/CT9k=
Message-ID: <8db1092f0810241057j51f0b70eo3cea4499422f0d38@mail.gmail.com>
Date: Fri, 24 Oct 2008 19:57:03 +0200
From: "Maciej Rutecki" <maciej.rutecki@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: [Re: Linux 2.6.28-rc1] scsi 4:0:0:0: timing out command, waited 22s
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org,
       "SCSI development list" <linux-scsi@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During boot I have this message:

ata_piix 0000:00:1f.1: version 2.12
ata_piix 0000:00:1f.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
ata_piix 0000:00:1f.1: setting latency timer to 64
scsi4 : ata_piix
scsi5 : ata_piix
ata5: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x60a0 irq 14
ata6: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x60a8 irq 15
ata5.00: ATAPI: MATSHITADVD-RAM UJ-840S, 1.11, max MWDMA2
ata5.00: configured for MWDMA2
ata6: port disabled. ignoring.
scsi 4:0:0:0: timing out command, waited 22s
scsi 4:0:0:0: timing out command, waited 22s
scsi 4:0:0:0: timing out command, waited 22s
scsi 4:0:0:0: timing out command, waited 22s
scsi 4:0:0:0: timing out command, waited 22s
scsi 4:0:0:0: timing out command, waited 22s
	ata5: WARNING: synchronous SCSI scan failed without making any progress,
                  switching to async

DVD drive doesn't work. Under 2.6.27 (stable and -rc) works OK.

Dmesg ang config:
http://unixy.pl/maciek/download/kernel/2.6.28-rc1/

Regards
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
