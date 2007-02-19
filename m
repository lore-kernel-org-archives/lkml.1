Return-Path: <linux-kernel-owner+w=401wt.eu-S932498AbXBSTV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932498AbXBSTV4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 14:21:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932505AbXBSTV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 14:21:56 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:59876 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932498AbXBSTVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 14:21:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=N7s1775SCZPjilXJ+c5lhOFJNFnfK93sskhx8BeJzkZ5k2/hX1ck9JBFbnS/HAJrzCNFGuRUiavnBPnVmak8LEN2sjO7laTRpHlV6h6X7vu6HNksv5SBzlwZSJcfkJSXgTYiwJp8dLk1nIe0BixS4falBC4d7DMObedZtwVO08Y=
From: auxsvr@gmail.com
To: linux-kernel@vger.kernel.org
Subject: ata command timeout
Date: Mon, 19 Feb 2007 21:19:50 +0200
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200702192119.50954.auxsvr@gmail.com>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have been running 2.6.18 for two months and the last couple of days these 
error messages have appeared in my logs 
(sata_promise kernel module, sda:SATA sdb:PATA disks):

                                               ata1: command timeout
Feb 17 22:23:14 linux kernel: ata1: no sense translation for status: 0x40
Feb 17 22:23:14 linux kernel: ata1: translated ATA stat/err 0x40/00 to SCSI 
SK/ASC/ASCQ 0xb/00/00
Feb 17 22:23:14 linux kernel: ata1: status=0x40 { DriveReady }
Feb 17 22:23:14 linux kernel: sd 0:0:0:0: SCSI error: return code = 0x08000002
Feb 17 22:23:14 linux kernel: sda: Current: sense key: Aborted Command
Feb 17 22:23:14 linux kernel:     Additional sense: No additional sense 
information
Feb 17 22:23:14 linux kernel: end_request: I/O error, dev sda, sector 
145179585
Feb 17 22:23:14 linux kernel: Buffer I/O error on device sda2, logical block 
2787300
Feb 17 22:23:14 linux kernel: lost page write due to I/O error on sda2

and 

                                               ata1: command timeout
Feb 19 20:39:31 linux kernel: ata1: no sense translation for status: 0x40
Feb 19 20:39:31 linux kernel: ata1: translated ATA stat/err 0x40/00 to SCSI 
SK/ASC/ASCQ 0xb/00/00
Feb 19 20:39:31 linux kernel: ata1: status=0x40 { DriveReady }
Feb 19 20:39:31 linux kernel: sd 0:0:0:0: SCSI error: return code = 0x08000002
Feb 19 20:39:31 linux kernel: sda: Current: sense key: Aborted Command
Feb 19 20:39:31 linux kernel:     Additional sense: No additional sense 
information
Feb 19 20:39:31 linux kernel: end_request: I/O error, dev sda, sector 89553479

without any other ill-effects that I know of(I did smart tests on the drive; 
all passed successfully).
I have read that hddtemp may be the cause of this (I am running version 0.3) 
so is there any reason
to worry and prepare for a HDD replacement?

Kind regards.
