Return-Path: <linux-kernel-owner+w=401wt.eu-S934096AbXGQQ2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934096AbXGQQ2T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 12:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758089AbXGQQ2K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 12:28:10 -0400
Received: from smtpout05-04.prod.mesa1.secureserver.net ([64.202.165.221]:54371
	"HELO smtpout05.prod.mesa1.secureserver.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1754697AbXGQQ2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 12:28:08 -0400
Message-ID: <469CEE14.4050109@seclark.us>
Date: Tue, 17 Jul 2007 12:28:04 -0400
From: Stephen Clark <Stephen.Clark@seclark.us>
Reply-To: Stephen.Clark@seclark.us
User-Agent: Mozilla/5.0 (X11; U; Linux 2.2.16-22smp i686; en-US; m18) Gecko/20010110 Netscape6/6.5
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: ali_pata sets my udma to 33 when it should be 66
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I just upgraded my HP N5430 laptop to fedora 7 with a 2.6.21 kernel.
It used to be udma/66 under the old ide driver.

ata1: PATA max UDMA/100 cmd 0x000101f0 ctl 0x000103f6 bmdma 0x00011000 
irq 14
ata2: PATA max UDMA/100 cmd 0x00010170 ctl 0x00010376 bmdma 0x00011008 
irq 15
scsi0 : pata_ali
ata1.00: ata_hpa_resize 1: sectors = 39070080, hpa_sectors = 39070080
ata1.00: ATA-5: HITACHI_DK23CA-20, 00H1A0A3, max UDMA/100
ata1.00: 39070080 sectors, multi 16: LBA
ata1.00: ata_hpa_resize 1: sectors = 39070080, hpa_sectors = 39070080
ata1.00: configured for UDMA/33

How can this be fixed?

Thanks,
Steve

-- 

"They that give up essential liberty to obtain temporary safety, 
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty 
decreases."  (Thomas Jefferson)



