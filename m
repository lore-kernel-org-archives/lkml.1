Return-Path: <linux-kernel-owner+w=401wt.eu-S1753913AbXGOT0y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913AbXGOT0y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 15:26:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750881AbXGOT0q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 15:26:46 -0400
Received: from linux.dunaweb.hu ([62.77.196.1]:33267 "EHLO linux.dunaweb.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750832AbXGOT0q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 15:26:46 -0400
Message-ID: <469A74D6.20006@dunaweb.hu>
Date: Sun, 15 Jul 2007 21:26:14 +0200
From: Zoltan Boszormenyi <zboszor@dunaweb.hu>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Jeff Garzik <jgarzik@pobox.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: DVD-playing, ide-cd vs scsi-cd drivers
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have an FC6 machine with a Pioneer DVD-RW and
I occasionally watch DVDs on it. (Xine+libdvdcss
from Livna works just fine.) I compiled 2.6.22-rc7-git5
before with ide-cd but now I changed the driver to
pata_amd to see it works before I upgrade to FC7.
Now DVD-playing doesn't work, I got this in the log
when I tried to play a DVD in Xine.

UDF-fs: Partition marked readonly; forcing readonly mount
UDF-fs INFO UDF 0.9.8.1 (2004/29/09) Mounting volume 'TW10Y', timestamp 
2004/12/16 14:30 (1078)
SELinux: initialized (dev sr0, type udf), uses genfs_contexts
sr 6:0:0:0: [sr0] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
sr 6:0:0:0: [sr0] Sense Key : Hardware Error [current]
sr 6:0:0:0: [sr0] Add. Sense: Logical unit communication CRC error 
(Ultra-DMA/32)
end_request: I/O error, dev sr0, sector 1476
Buffer I/O error on device sr0, logical block 369
Buffer I/O error on device sr0, logical block 370
Buffer I/O error on device sr0, logical block 371
Buffer I/O error on device sr0, logical block 372
Buffer I/O error on device sr0, logical block 373
Buffer I/O error on device sr0, logical block 374
Buffer I/O error on device sr0, logical block 375
Buffer I/O error on device sr0, logical block 376
Buffer I/O error on device sr0, logical block 377
Buffer I/O error on device sr0, logical block 378
sr 6:0:0:0: [sr0] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
sr 6:0:0:0: [sr0] Sense Key : Hardware Error [current]
sr 6:0:0:0: [sr0] Add. Sense: Logical unit communication CRC error 
(Ultra-DMA/32)
end_request: I/O error, dev sr0, sector 9126328
printk: 5 messages suppressed.
Buffer I/O error on device sr0, logical block 2281582
Buffer I/O error on device sr0, logical block 2281583
Buffer I/O error on device sr0, logical block 2281584
Buffer I/O error on device sr0, logical block 2281585
Buffer I/O error on device sr0, logical block 2281586
Buffer I/O error on device sr0, logical block 2281587
Buffer I/O error on device sr0, logical block 2281588
Buffer I/O error on device sr0, logical block 2281589
Buffer I/O error on device sr0, logical block 2281590
Buffer I/O error on device sr0, logical block 2281591
sr 6:0:0:0: [sr0] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
sr 6:0:0:0: [sr0] Sense Key : Hardware Error [current]
sr 6:0:0:0: [sr0] Add. Sense: Logical unit communication CRC error 
(Ultra-DMA/32)
end_request: I/O error, dev sr0, sector 1464
sr 6:0:0:0: [sr0] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
sr 6:0:0:0: [sr0] Sense Key : Hardware Error [current]
sr 6:0:0:0: [sr0] Add. Sense: Logical unit communication CRC error 
(Ultra-DMA/32)
end_request: I/O error, dev sr0, sector 1820
sr 6:0:0:0: [sr0] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
sr 6:0:0:0: [sr0] Sense Key : Hardware Error [current]
sr 6:0:0:0: [sr0] Add. Sense: Logical unit communication CRC error 
(Ultra-DMA/32)
end_request: I/O error, dev sr0, sector 64420
sr 6:0:0:0: [sr0] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
sr 6:0:0:0: [sr0] Sense Key : Hardware Error [current]
sr 6:0:0:0: [sr0] Add. Sense: Logical unit communication CRC error 
(Ultra-DMA/32)
end_request: I/O error, dev sr0, sector 2163840
sr 6:0:0:0: [sr0] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
sr 6:0:0:0: [sr0] Sense Key : Hardware Error [current]
sr 6:0:0:0: [sr0] Add. Sense: Logical unit communication CRC error 
(Ultra-DMA/32)
end_request: I/O error, dev sr0, sector 2163840
sr 6:0:0:0: [sr0] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
sr 6:0:0:0: [sr0] Sense Key : Hardware Error [current]
sr 6:0:0:0: [sr0] Add. Sense: Logical unit communication CRC error 
(Ultra-DMA/32)
end_request: I/O error, dev sr0, sector 4258944
sr 6:0:0:0: [sr0] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
sr 6:0:0:0: [sr0] Sense Key : Hardware Error [current]
sr 6:0:0:0: [sr0] Add. Sense: Logical unit communication CRC error 
(Ultra-DMA/32)
end_request: I/O error, dev sr0, sector 6356860
sr 6:0:0:0: [sr0] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
sr 6:0:0:0: [sr0] Sense Key : Hardware Error [current]
sr 6:0:0:0: [sr0] Add. Sense: Logical unit communication CRC error 
(Ultra-DMA/32)
end_request: I/O error, dev sr0, sector 8453752
sr 6:0:0:0: [sr0] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
sr 6:0:0:0: [sr0] Sense Key : Hardware Error [current]
sr 6:0:0:0: [sr0] Add. Sense: Logical unit communication CRC error 
(Ultra-DMA/32)
end_request: I/O error, dev sr0, sector 9127460

I changed the driver back to old IDE and DVD-playing works again
so it's not a hardware error. Is there something I forgot to compile in
or is it a handicap in the SCSI CD drivers?

Best regards,
Zoltán Böszörményi


