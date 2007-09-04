Return-Path: <linux-kernel-owner+w=401wt.eu-S1754030AbXIDLTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030AbXIDLTS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 07:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753092AbXIDLTF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 07:19:05 -0400
Received: from mi0.bluebottle.com ([206.188.25.15]:40004 "EHLO
	mi0.bluebottle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005AbXIDLTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 07:19:03 -0400
DomainKey-Signature: a=rsa-sha1; s=mail; d=bluebottle.com; c=nofws; q=dns;
	h=received:from:to:cc:subject:date:mime-version:
	content-type:content-transfer-encoding:x-priority:
	x-msmail-priority:x-mailer:x-mimeole:x-trusted-delivery;
	b=KGW5q5TO/7C1JezLRps3qqLZPKRSlIfiz6aL4TAyDofG4QrZl5hNgQvSONqeTgV9u
	Wq0tiM9wvV26aaa9n8RN6naJOde7Vgr3qvzMiKtIWAio1/hryjzjJZTyvGoudG7
Message-Id: <200709041119.l84BJ1H8008726@mi0.bluebottle.com>
From: "n" <xellos@bluebottle.com>
To: "n" <xellos@bluebottle.com>, "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       <patrizio.bassi@gmail.com>
Cc: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>,
       "Kernel," <linux-kernel@vger.kernel.org>,
       "IDE/ATA development list" <linux-ide@vger.kernel.org>,
       "Alan Cox" <alan@redhat.com>,
       "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>
Subject: pata_pdc202xx_old bug?  (ATA bus error)
Date: Tue, 4 Sep 2007 04:19:04 -0700
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="Windows-1252";
	reply-type=response
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3138
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3138
X-Trusted-Delivery: <c111299ef24070e7921410aa9cd92e2d>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

anyone come up with a patch/fix for this?

i also tried this drive on the system ide ports and it worked fine (also 
uses libata drivers, nforce2), it seems to be something wrong in the 
"pata_pdc202xx_old" code.
what can i do to get this fixed?
the drive is a seagate.
i dont know what  res 51/84:00:3f:00:00/00:00:00:00:00/e0 Emask 0x10 (ATA 
bus error) means

this is a really strange and hard to reproduce bug since all my other drives 
work (all maxtors , and one wd) just the seagate gets this error (and only 
on the PDC20267 card)
thanks.

ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
ata3.00: (BMDMA stat 0x4)
ata3.00: cmd ca/00:01:3f:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 512 out
         res 51/84:00:3f:00:00/00:00:00:00:00/e0 Emask 0x10 (ATA bus error)
ata3: soft resetting port
ata3.00: configured for UDMA/100
ata3: EH complete
ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
ata3.00: (BMDMA stat 0x4)
ata3.00: cmd ca/00:01:3f:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 512 out
         res 51/84:00:3f:00:00/00:00:00:00:00/e0 Emask 0x10 (ATA bus error)
ata3: soft resetting port
ata3.00: configured for UDMA/100
ata3: EH complete
sd 2:0:0:0: [sde] 234441648 512-byte hardware sectors (120034 MB)
ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
ata3.00: (BMDMA stat 0x4)
ata3.00: cmd ca/00:01:3f:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 512 out
         res 51/84:00:3f:00:00/00:00:00:00:00/e0 Emask 0x10 (ATA bus error)
ata3: soft resetting port
ata3.00: configured for UDMA/100
ata3: EH complete
sd 2:0:0:0: [sde] Write Protect is off
sd 2:0:0:0: [sde] Mode Sense: 00 3a 00 00
ata3.00: limiting speed to UDMA/66:PIO4
ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
ata3.00: (BMDMA stat 0x4)
ata3.00: cmd ca/00:01:3f:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 512 out
         res 51/84:00:3f:00:00/00:00:00:00:00/e0 Emask 0x10 (ATA bus error)
ata3: soft resetting port
ata3.00: configured for UDMA/66
ata3: EH complete
ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
ata3.00: (BMDMA stat 0x4)
ata3.00: cmd ca/00:01:3f:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 512 out
         res 51/84:00:3f:00:00/00:00:00:00:00/e0 Emask 0x10 (ATA bus error)
ata3: soft resetting port
ata3.00: configured for UDMA/66
ata3: EH complete
sd 2:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support 
DPO or FUA
ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
ata3.00: (BMDMA stat 0x4)
ata3.00: cmd ca/00:01:3f:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 512 out
         res 51/84:00:3f:00:00/00:00:00:00:00/e0 Emask 0x10 (ATA bus error)
ata3: soft resetting port
ata3.00: configured for UDMA/66
sd 2:0:0:0: [sde] Result: hostbyte=0x00 driverbyte=0x08
sd 2:0:0:0: [sde] Sense Key : 0xb [current] [descriptor]
Descriptor sense data with sense descriptors (in hex):
        72 0b 47 00 00 00 00 0c 00 0a 80 00 00 00 00 00
        00 00 00 3f
sd 2:0:0:0: [sde] ASC=0x47 ASCQ=0x0
end_request: I/O error, dev sde, sector 63
ata3: EH complete
sd 2:0:0:0: [sde] 234441648 512-byte hardware sectors (120034 MB)
Filesystem "sde1": Disabling barriers, trial barrier write failed
sd 2:0:0:0: [sde] Write Protect is off
sd 2:0:0:0: [sde] Mode Sense: 00 3a 00 00
XFS mounting filesystem sde1
sd 2:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support 
DPO or FUA
sd 2:0:0:0: [sde] 234441648 512-byte hardware sectors (120034 MB)
sd 2:0:0:0: [sde] Write Protect is off
sd 2:0:0:0: [sde] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support 
DPO or FUA
ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
ata3.00: (BMDMA stat 0x4)
ata3.00: cmd ca/00:00:17:b6:fc/00:00:00:00:00/e6 tag 0 cdb 0x0 data 131072 
out
         res 51/84:00:17:b6:fc/00:00:00:00:00/e6 Emask 0x10 (ATA bus error)
ata3: soft resetting port
ata3.00: configured for UDMA/66
ata3: EH complete
ata3.00: limiting speed to UDMA/33:PIO4
ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
ata3.00: (BMDMA stat 0x4)
ata3.00: cmd ca/00:00:17:b6:fc/00:00:00:00:00/e6 tag 0 cdb 0x0 data 131072 
out
         res 51/84:00:17:b6:fc/00:00:00:00:00/e6 Emask 0x10 (ATA bus error)
ata3: soft resetting port
ata3.00: configured for UDMA/33
ata3: EH complete
ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
ata3.00: (BMDMA stat 0x4)
ata3.00: cmd ca/00:00:17:b6:fc/00:00:00:00:00/e6 tag 0 cdb 0x0 data 131072 
out
         res 51/84:00:17:b6:fc/00:00:00:00:00/e6 Emask 0x10 (ATA bus error)
ata3: soft resetting port
ata3.00: configured for UDMA/33
ata3: EH complete
ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
ata3.00: (BMDMA stat 0x4)
ata3.00: cmd ca/00:00:17:b6:fc/00:00:00:00:00/e6 tag 0 cdb 0x0 data 131072 
out
         res 51/84:00:17:b6:fc/00:00:00:00:00/e6 Emask 0x10 (ATA bus error)
ata3: soft resetting port
ata3.00: configured for UDMA/33
ata3: EH complete
ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
ata3.00: (BMDMA stat 0x4)
ata3.00: cmd ca/00:00:17:b6:fc/00:00:00:00:00/e6 tag 0 cdb 0x0 data 131072 
out
         res 51/84:00:17:b6:fc/00:00:00:00:00/e6 Emask 0x10 (ATA bus error)
ata3: soft resetting port
ata3.00: configured for UDMA/33
ata3: EH complete
ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
ata3.00: (BMDMA stat 0x4)
ata3.00: cmd ca/00:00:17:b6:fc/00:00:00:00:00/e6 tag 0 cdb 0x0 data 131072 
out
         res 51/84:00:17:b6:fc/00:00:00:00:00/e6 Emask 0x10 (ATA bus error)
ata3: soft resetting port
ata3.00: configured for UDMA/33
sd 2:0:0:0: [sde] Result: hostbyte=0x00 driverbyte=0x08
sd 2:0:0:0: [sde] Sense Key : 0xb [current] [descriptor]
Descriptor sense data with sense descriptors (in hex):
        72 0b 47 00 00 00 00 0c 00 0a 80 00 00 00 00 00
        06 fc b6 17
sd 2:0:0:0: [sde] ASC=0x47 ASCQ=0x0
end_request: I/O error, dev sde, sector 117224983
ata3: EH complete
ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
ata3.00: (BMDMA stat 0x4)
ata3.00: cmd ca/00:00:17:b7:fc/00:00:00:00:00/e6 tag 0 cdb 0x0 data 131072 
out
         res 51/84:00:17:b7:fc/00:00:00:00:00/e6 Emask 0x10 (ATA bus error)
ata3: soft resetting port
ata3.00: configured for UDMA/33
ata3: EH complete
ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
ata3.00: (BMDMA stat 0x4)
ata3.00: cmd ca/00:00:17:b7:fc/00:00:00:00:00/e6 tag 0 cdb 0x0 data 131072 
out
         res 51/84:00:17:b7:fc/00:00:00:00:00/e6 Emask 0x10 (ATA bus error)
ata3: soft resetting port
ata3.00: configured for UDMA/33
ata3: EH complete
ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
ata3.00: (BMDMA stat 0x4)
ata3.00: cmd ca/00:00:17:b7:fc/00:00:00:00:00/e6 tag 0 cdb 0x0 data 131072 
out
         res 51/84:00:17:b7:fc/00:00:00:00:00/e6 Emask 0x10 (ATA bus error)
ata3: soft resetting port
ata3.00: configured for UDMA/33
ata3: EH complete
ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
ata3.00: (BMDMA stat 0x4)
ata3.00: cmd ca/00:00:17:b7:fc/00:00:00:00:00/e6 tag 0 cdb 0x0 data 131072 
out
         res 51/84:00:17:b7:fc/00:00:00:00:00/e6 Emask 0x10 (ATA bus error)
ata3: soft resetting port
ata3.00: configured for UDMA/33
ata3: EH complete
ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
ata3.00: (BMDMA stat 0x4)
ata3.00: cmd ca/00:00:17:b7:fc/00:00:00:00:00/e6 tag 0 cdb 0x0 data 131072 
out
         res 51/84:00:17:b7:fc/00:00:00:00:00/e6 Emask 0x10 (ATA bus error)
ata3: soft resetting port
ata3.00: configured for UDMA/33
ata3: EH complete
ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
ata3.00: (BMDMA stat 0x4)
ata3.00: cmd ca/00:00:17:b7:fc/00:00:00:00:00/e6 tag 0 cdb 0x0 data 131072 
out
         res 51/84:00:17:b7:fc/00:00:00:00:00/e6 Emask 0x10 (ATA bus error)
ata3: soft resetting port
ata3.00: configured for UDMA/33
sd 2:0:0:0: [sde] Result: hostbyte=0x00 driverbyte=0x08
sd 2:0:0:0: [sde] Sense Key : 0xb [current] [descriptor]
Descriptor sense data with sense descriptors (in hex):
        72 0b 47 00 00 00 00 0c 00 0a 80 00 00 00 00 00
        06 fc b7 17
sd 2:0:0:0: [sde] ASC=0x47 ASCQ=0x0
end_request: I/O error, dev sde, sector 117225239
ata3: EH complete
xfs_force_shutdown(sde1,0x1) called from line 423 of file fs/xfs/xfs_rw.c. 
Return address = 0xc01e6258
Filesystem "sde1": I/O Error Detected.  Shutting down filesystem: sde1
Please umount the filesystem, and rectify the problem(s)
I/O error in filesystem ("sde1") meta-data dev sde1 block 0x6fcb5d8 
("xlog_bwrite") error 5 buf count 262144
XFS: failed to locate log tail
XFS: log mount/recovery failed: error 5
XFS: log mount failed

----------------------------------------------------------------------
Get a free email account with anti spam protection.
http://www.bluebottle.com/tag/2

