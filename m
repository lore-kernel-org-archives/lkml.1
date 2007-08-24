Return-Path: <linux-kernel-owner+w=401wt.eu-S934268AbXHXCpJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934268AbXHXCpJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 22:45:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933421AbXHXCo5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 22:44:57 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:5531 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932475AbXHXCo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 22:44:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Ivv9+f+MRk8yanGO16MiaFUAo/LZaXlciP974s5HjlXC04FCWXCh9FqzmELMUWuGJeCcaqxVhxSUWrj47G4AB1aVBwNPMulD16xpqXkI4VcZCXyu2Ucf7QTnFw47eMJEU+iziC1XeuAkV0EZq2TGcdJWPzThIJ/32mt9negUskU=
Message-ID: <443c85430708231944s102dff82u366a93824f7c2222@mail.gmail.com>
Date: Thu, 23 Aug 2007 22:44:55 -0400
From: TheOneKEA <theonekea@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Possible problems reading a DVD-RAM disc
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

While doing a long mega-copy from one side of a DVD-RAM disc formatted
with the vfat filesystem to an smbfs network share, I got lots and
lots of these in the dmesg:

Buffer I/O error on device sr0, logical block 4396
lost page write due to I/O error on sr0
sr 6:0:0:0: [sr0] Result: hostbyte=0x00 driverbyte=0x08
sr 6:0:0:0: [sr0] Sense Key : 0x7 [current]
sr 6:0:0:0: [sr0] <<vendor>> ASC=0x92 ASCQ=0x0ASC=0x92 ASCQ=0x0
end_request: I/O error, dev sr0, sector 17584
Buffer I/O error on device sr0, logical block 4396
lost page write due to I/O error on sr0

The DVD-RAM is detected like so (my system is an nVidia nForce 590
SLI, with kernel 2.6.22.1 and the new SCSI-using PATA/SATA drivers in
use):

pata_amd 0000:00:0c.0: version 0.3.8
PCI: Setting latency timer of device 0000:00:0c.0 to 64
scsi6 : pata_amd
scsi7 : pata_amd
ata7: PATA max UDMA/133 cmd 0x00000000000101f0 ctl 0x00000000000103f6
bmdma 0x000000000001f400 irq 14
ata8: PATA max UDMA/133 cmd 0x0000000000010170 ctl 0x0000000000010376
bmdma 0x000000000001f408 irq 15
ata7.00: ATAPI: MATSHITADVD-RAM LF-D310, A123, max UDMA/33
ata7.00: configured for UDMA/33
ata8: port disabled. ignoring.
scsi 6:0:0:0: CD-ROM            MATSHITA DVD-RAM LF-D310  A123 PQ: 0 ANSI: 5
sr0: scsi3-mmc drive: 0x/0x dvd-ram cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 6:0:0:0: Attached scsi CD-ROM sr0

Are the above errors related to media flaws, drive flaws, driver
flaws, or usage flaws (i.e. "I copied $LARGE_AMOUNT from a DVD-RAM
disc to a network share", "Don't do that.")?

-- 
SCREW THE ADS! http://adblock.mozdev.org/
