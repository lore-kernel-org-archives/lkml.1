Return-Path: <linux-kernel-owner+w=401wt.eu-S1757251AbXH0MOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757251AbXH0MOn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 08:14:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757282AbXH0MOT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 08:14:19 -0400
Received: from cando-ltd.com ([62.253.227.66]:2409 "EHLO
	sideshow-bob.tisolutions.biz" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757270AbXH0MOS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 08:14:18 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.0.6487.1
content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: "exception Emask: 0x42" errors with 2.6.22.x and SATA drives
Date: Mon, 27 Aug 2007 13:14:15 +0100
Message-ID: <94439DDF32D7464A916B5068EFF76B3B0225E727@bart.tisolutions.biz>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: "exception Emask: 0x42" errors with 2.6.22.x and SATA drives
Thread-Index: AcfonCPpxeWDGVFDRcyWXfAWQ5rIXgABpsKg
From: "Dermot Bradley" <dermot.bradley@sla-mobile.com>
To: "Alistair John Strachan" <alistair@devzero.co.uk>
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>, <linux-kernel@vger.kernel.org>,
       "Jeff Garzik" <jeff@garzik.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I've added Jeff to CC in case he's interested about the workaround for
> this drive (I assume you're using the AHCI driver with your ATI
> controller).

Yupe, using AHCI.

I've just rebooted after adding that blacklist line to the kernel and
recompiling but it doesn't seem to have taken effect:

  ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
  ata1.00: ATA-7: WDC WD800BEVS-07RST0, 04.01G04, max UDMA/133
  ata1.00: 156301488 sectors, multi 1: LBA48 NCQ (depth 31/32)

If NCQ is disabled/blacklisted shouldn't the depth say 0/32 ?

I used the string "WDC WD800BEVS-07" in the patch, maybe I should use
"WDC WD800BEVS-07RST0" instead?

cat /sys/bus/scsi/devices/0\:0\:0\:0/model shows "WDC WD800BEVS-07"




Stirk, Lamont & Associates Ltd.
Registered Address: Thomas Andrews House, Queens Road, Belfast,  BT3 9DU
Registered in Northern Ireland, Number: NI 47983. VAT Number: 832 2778 22

