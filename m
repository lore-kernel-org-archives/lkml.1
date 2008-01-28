Return-Path: <linux-kernel-owner+w=401wt.eu-S1765427AbYA1Xgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765427AbYA1Xgy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 18:36:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755397AbYA1Xgl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 18:36:41 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:39205 "EHLO
	pd2mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764572AbYA1Xgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 18:36:40 -0500
Date: Mon, 28 Jan 2008 17:38:36 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Blu Ray LG GGW-H20L crashes Linux
In-reply-to: <fa.QKOfoC0jShKF1yDA3BpSsRBOQzY@ifi.uio.no>
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: linux-kernel@vger.kernel.org
Message-id: <479E677C.9070301@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
References: <fa.QKOfoC0jShKF1yDA3BpSsRBOQzY@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Anton Mitterer wrote:
> Hi everybody.
> 
> I've just bought and installed a LG GGW-H20L Blu-Ray burner,...
> This is an SATA device, I'm running a 2.6.23.10 kernel (not the Debian
> version) on Debian sid (AMD64) and I use the proprietary nvidia drivers
> (169.07).
> The system is an Dual (!) DualCore AMD Opteron machine.
> (Please ask if you need further information)
> 
> The kernel seems to correctly identify the device (part of dmesg):
> Jan 28 23:22:28 fermat kernel: ata4: SATA link up 1.5 Gbps (SStatus 113
> SControl 300)
> Jan 28 23:22:28 fermat kernel: ata4.00: ATAPI: HL-DT-ST BD-RE  GGW-H20L,
> YL02, max UDMA/133
> Jan 28 23:22:28 fermat kernel: ata4.00: configured for UDMA/133
> Jan 28 23:22:28 fermat kernel: scsi 2:0:0:0: Direct-Access     ATA
> ST3750640AS      3.AA PQ: 0 ANSI: 5
> Jan 28 23:22:28 fermat kernel: ata3: bounce limit 0xFFFFFFFFFFFFFFFF,
> segment boundary 0xFFFFFFFF, hw segs 61
> Jan 28 23:22:28 fermat kernel: sd 2:0:0:0: [sdc] 1465149168 512-byte
> hardware sectors (750156 MB)
> Jan 28 23:22:28 fermat kernel: sd 2:0:0:0: [sdc] Write Protect is off
> Jan 28 23:22:28 fermat kernel: sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
> Jan 28 23:22:28 fermat kernel: sd 2:0:0:0: [sdc] Write cache: enabled,
> read cache: enabled, doesn't support DPO or FUA
> Jan 28 23:22:28 fermat kernel: sd 2:0:0:0: [sdc] 1465149168 512-byte
> hardware sectors (750156 MB)
> Jan 28 23:22:28 fermat kernel: sd 2:0:0:0: [sdc] Write Protect is off
> Jan 28 23:22:28 fermat kernel: sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
> Jan 28 23:22:28 fermat kernel: sd 2:0:0:0: [sdc] Write cache: enabled,
> read cache: enabled, doesn't support DPO or FUA
> Jan 28 23:22:28 fermat kernel:  sdc: sdc1
> Jan 28 23:22:28 fermat kernel: sd 2:0:0:0: [sdc] Attached SCSI disk
> Jan 28 23:22:28 fermat kernel: sd 2:0:0:0: Attached scsi generic sg2
> type 0
> Jan 28 23:22:28 fermat kernel: scsi 3:0:0:0: CD-ROM            HL-DT-ST
> BD-RE  GGW-H20L  YL02 PQ: 0 ANSI: 5
> Jan 28 23:22:28 fermat kernel: ata4: bounce limit 0xFFFFFFFF, segment
> boundary 0xFFFF, hw segs 127
> Jan 28 23:22:28 fermat kernel: sr0: scsi3-mmc drive: 0x/0x caddy
> Jan 28 23:22:28 fermat kernel: sr 3:0:0:0: Attached scsi CD-ROM sr0
> Jan 28 23:22:28 fermat kernel: sr 3:0:0:0: Attached scsi generic sg3
> type 5
> 
> 
> Anyway,... as soon as I insert an BluRay disc or an DVD my system
> crashes (it either freezes, that happened with the DVD-R, or it reboots,
> that happened with the BluRay disc).
> 
> There are no panics, oopses, or any other messages in the usual logs (at
> least I didn't recognize them ;) ).
> 
> Any ideas?
> 
> Thanks and best wishes,
> Chris.
> 
> btw: I'm cross posting this to lkml and debian-user,... hope nobody
> feels offended :-)

How much RAM is in your machine? There's a known problem with sata_nv 
ADMA with ATAPI devices and over 4GB of RAM. As a temporary workaround, 
you can boot with sata_nv.adma=0 on the kernel command line, or limit 
your memory with the mem= command line option so that memory over 4GB is 
not used.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

