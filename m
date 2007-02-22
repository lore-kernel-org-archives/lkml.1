Return-Path: <linux-kernel-owner+w=401wt.eu-S1751649AbXBVP0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751649AbXBVP0b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 10:26:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751650AbXBVP0b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 10:26:31 -0500
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:49894 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751648AbXBVP0b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 10:26:31 -0500
Date: Thu, 22 Feb 2007 17:26:29 +0200 (EET)
From: Meelis Roos <mroos@linux.ee>
To: Alan <alan@lxorguk.ukuu.org.uk>
cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: ata-piix ACPI errors
In-Reply-To: <20070222150641.037f7fbe@lxorguk.ukuu.org.uk>
Message-ID: <Pine.SOC.4.64.0702221614540.20840@math>
References: <Pine.SOC.4.64.0702221525480.20840@math>
 <20070222150641.037f7fbe@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Not in those but again note that the cable detection is broken 
> 
> > ata2.00: ATAPI, max UDMA/33

It shows UDMA/100 for HDD and UDMA/33 for DVD-ROM. Visual inspection 
confirms that this is correct - DVD-ROM has 40-pin cable and HDD has 
80-pin one. So at least the result is not wrong.

ata1: PATA max UDMA/100 cmd 0x000101f0 ctl 0x000103f6 bmdma 0x0001ffa0 irq 14
ata2: PATA max UDMA/100 cmd 0x00010170 ctl 0x00010376 bmdma 0x0001ffa8 irq 15
ata1.00: ATA-5: ST380021A, 3.19, max UDMA/100
ata1.00: configured for UDMA/100
ata2.00: ATAPI, max UDMA/33
ata2.00: configured for UDMA/33

Should the ATAPI line contain UDMA/100 if 40-pin cable is present??

-- 
Meelis Roos (mroos@linux.ee)
