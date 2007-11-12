Return-Path: <linux-kernel-owner+w=401wt.eu-S1757645AbXKLGCw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757645AbXKLGCw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 01:02:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752341AbXKLGCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 01:02:44 -0500
Received: from mail4.tpgi.com.au ([203.12.160.61]:55299 "EHLO
	mail4.tpgi.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942AbXKLGCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 01:02:43 -0500
X-TPG-Antivirus: Passed
Subject: Re: cd/dvd inaccessible in 2.6.24-rc2
From: Will Trives <will@trivescon.com.au>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1194756033.5042.15.camel@Athas>
References: <1194668831.3436.14.camel@Athas>  <47364059.8000003@garzik.org>
	 <1194756033.5042.15.camel@Athas>
Content-Type: text/plain
Date: Mon, 12 Nov 2007 17:00:09 +1100
Message-Id: <1194847209.5012.2.camel@Athas>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,


My mistake, it looks like the issue is to do with writing only.

Mounting a standard DVD works fine with 2.6.24-rc2-git2.

As soon as I try to use wodim or load k3b, that's when drive gets locked
up.

The issue was still there with 2.6.23-git15 , I will continue to test
with previous ones.


Regards,

Will Trives


On Sun, 2007-11-11 at 15:40 +1100, Will Trives wrote:
> Hello Jeff,
> 
> Yes it is. I'll keep testing with previous kernels.
> 
> Dmesg does look different with 2.6.23 vs 2.6.24-rc2
> 
> This is 2.6.23 :
> 
> scsi8 : pata_jmicron
> scsi9 : pata_jmicron
> ata9: PATA max UDMA/100 cmd 0x000000000001c000 ctl 0x000000000001c102 bmdma 0x000000000001c400 irq 17
> ata10: PATA max UDMA/100 cmd 0x000000000001c200 ctl 0x000000000001c302 bmdma 0x000000000001c408 irq 17
> ata9.00: ATAPI: BENQ    DVD DD DW1640, BSRB, max UDMA/33
> ata9.00: configured for UDMA/33
> ata9: EH pending after completion, repeating EH (cnt=4)
> scsi 8:0:0:0: CD-ROM            BENQ     DVD DD DW1640    BSRB PQ: 0 ANSI: 5
> 
> 
> This is 2.6.24-rc2 :
> 
> scsi8 : pata_jmicron
> scsi9 : pata_jmicron
> ata9: PATA max UDMA/100 cmd 0xc000 ctl 0xc100 bmdma 0xc400 irq 17
> ata10: PATA max UDMA/100 cmd 0xc200 ctl 0xc300 bmdma 0xc408 irq 17
> ata9.00: ATAPI: BENQ DVD DD DW1640, BSRB, max UDMA/33
> ata9.00: configured for UDMA/33
> scsi 8:0:0:0: CD-ROM BENQ DVD DD DW1640 BSRB PQ: 0 ANSI: 5
> 
> Regards,
> 
> Will Trives
> 
> On Sat, 2007-11-10 at 18:35 -0500, Jeff Garzik wrote:
> > Will Trives wrote:
> > > Hello,
> > > 
> > > Motherboard: Gigabyte GA-P35-DS4 (rev. 1.1)
> > > Chipset: Intel P35 + ICH9R 
> > > PATA port runs off JMicron controller
> > > CD/DVD Device: BENQ DW1640 16X
> > > 
> > > I cannot access my dvd burner under 2.6.24-rc2, I have no problems under
> > > 2.6.23. Basically the drive is detected OK, everything looks ok but as
> > > soon as I go to use it errors like this occur:
> > 
> > Is 2.6.24-rc1 also broken?
> > 
> > 	Jeff
> > 
> > 

