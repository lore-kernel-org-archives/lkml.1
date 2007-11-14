Return-Path: <linux-kernel-owner+w=401wt.eu-S1760111AbXKNQ1z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760111AbXKNQ1z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 11:27:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755816AbXKNQ1s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 11:27:48 -0500
Received: from mail.gmx.net ([213.165.64.20]:47430 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754283AbXKNQ1r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 11:27:47 -0500
X-Authenticated: #7313500
X-Provags-ID: V01U2FsdGVkX19Iz/BklO5Ii9YfbTzX6idXH6/qQ7q8EX0t6G7qll
	5qxAliFW7YIwGo
From: Jan-Simon =?iso-8859-1?q?M=F6ller?= <dl9pf@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: Re: sata NCQ blacklist entry
Date: Wed, 14 Nov 2007 17:27:43 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
References: <20071107111813.GA9064@dudweiler.stuttgart.redhat.com> <200711132155.15506.dl9pf@gmx.de>
In-Reply-To: <200711132155.15506.dl9pf@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200711141727.43136.dl9pf@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag 13 November 2007 21:55:15 schrieb Jan-Simon Möller:
> Hi!
>
> Just using kernel 2.6.24-rc2 (325d22df7b19e0116aff3391d3a03f73d0634ded).
>
> When booting the system hangs, using the emergency-sync a couple of times
> gets the system to go on at some point.
> Its always around starting X/Firewall (can't actually say whats done in
> this moment).

It was smartd starting - after that i got the stuck state reported in my last 
mail. With smartd off i only get this:



dmesg | grep ata

ACPI: SSDT 7F6D3C3F, 02DD (r1 SataRe SataAhci     1000 INTL 20060912)
PERCPU: Allocating 46968 bytes of per cpu data
Memory: 2048732k/2087744k available (2219k kernel code, 38624k reserved, 992k 
data, 344k init)
ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
libata version 3.00 loaded.
ata1: SATA max UDMA/133 abar m2048@0xfc404000 port 0xfc404100 irq 4347
ata2: SATA max UDMA/133 abar m2048@0xfc404000 port 0xfc404180 irq 4347
ata3: SATA max UDMA/133 abar m2048@0xfc404000 port 0xfc404200 irq 4347
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ATA-8: WDC WD2500BEVS-22UST0, 01.01A01, max UDMA/133
ata1.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 31/32)
ata1.00: configured for UDMA/133
ata2: SATA link down (SStatus 0 SControl 300)
ata3: SATA link down (SStatus 0 SControl 300)
ata_piix 0000:00:1f.1: version 2.12
scsi3 : ata_piix
scsi4 : ata_piix
ata4: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x1810 irq 14
ata5: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x1818 irq 15
ata4.00: ATAPI: HL-DT-ST DVDRAM GSA-T20N, WW01, max UDMA/33
ata4.00: configured for UDMA/33
EXT3-fs: mounted filesystem with ordered data mode.
ata1.00: exception Emask 0x2 SAct 0xc SErr 0x0 action 0x2 frozen
ata1.00: spurious completions during NCQ issue=0x0 SAct=0xc 
FIS=004040a1:00000002
ata1.00: cmd 61/08:10:24:e1:db/00:00:06:00:00/40 tag 2 cdb 0x0 data 4096 out
ata1.00: status: { DRDY }
ata1.00: cmd 61/10:18:d4:df:db/00:00:06:00:00/40 tag 3 cdb 0x0 data 8192 out
ata1.00: status: { DRDY }
ata1: soft resetting link
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: configured for UDMA/133
ata1: EH complete
ata1.00: exception Emask 0x2 SAct 0x4 SErr 0x0 action 0x2 frozen
ata1.00: spurious completions during NCQ issue=0x0 SAct=0x4 
FIS=004040a1:00000002
ata1.00: cmd 61/08:10:c7:fb:18/00:00:0e:00:00/40 tag 2 cdb 0x0 data 4096 out
ata1.00: status: { DRDY }
ata1: soft resetting link
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: configured for UDMA/133
ata1: EH complete
ata1.00: exception Emask 0x2 SAct 0x60 SErr 0x0 action 0x2 frozen
ata1.00: spurious completions during NCQ issue=0x0 SAct=0x60 
FIS=004040a1:00000010
ata1.00: cmd 61/08:28:07:fb:18/00:00:0e:00:00/40 tag 5 cdb 0x0 data 4096 out
ata1.00: status: { DRDY }
ata1.00: cmd 61/08:30:c7:fb:18/00:00:0e:00:00/40 tag 6 cdb 0x0 data 4096 out
ata1.00: status: { DRDY }
ata1: soft resetting link
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: configured for UDMA/133
ata1: EH complete


Best regards
Jan-Simon
