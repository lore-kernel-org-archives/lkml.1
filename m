Return-Path: <linux-kernel-owner+w=401wt.eu-S933267AbXBXALT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933267AbXBXALT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 19:11:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933276AbXBXALT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 19:11:19 -0500
Received: from vms044pub.verizon.net ([206.46.252.44]:64484 "EHLO
	vms044pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933267AbXBXALS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 19:11:18 -0500
Date: Fri, 23 Feb 2007 19:11:01 -0500
From: "Tom Morrison" <Tom.Morrison@Verizon.net>
Subject: RE: Problems with init of Marvell PCI Express SATA Card
In-reply-to: <20070224004809.30a0e105@lxorguk.ukuu.org.uk>
To: "Alan" <alan@lxorguk.ukuu.org.uk>
Cc: <linux-kernel@vger.kernel.org>
Reply-to: <Tom.Morrison@Verizon.net>
Message-id: <CJEDIOAEPEPAEFLDLKIBEEJNCDAA.Tom.Morrison@Verizon.net>
MIME-version: 1.0
X-MIMEOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Importance: Normal
X-Priority: 3 (Normal)
X-MSMail-priority: Normal
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan,

Where are you looking for sata_mv driver support.

if you look in the sata_mv.c it has support for the 
7042 throughout it (exactly the same as PCI in fact - 
its the same core chip - just different bus interface)...

but agreed an unknown device in the pci ids...or is 
there another place where I should be looking for 
7042 support?

or does it look in pci ids & if it doesn't know 
the registered device type (chip) - it doesn't 
probe it - even if it does a pci_register_device()?

????

I am sorry for being so Naive here - but obviously
there is a disconnect here (there is some PEBKAC...:-)

t

-----Original Message-----
From: Alan [mailto:alan@lxorguk.ukuu.org.uk]

>> PCI Express looks like PCI so generally there isn't 
>> specific support needed. The Marvell driver supports 
>> the 6101 and 6145 chipsets for PATA and for SATA 
>> the sata_mv driver supports the 5040, 5041, 5080, 5081,
>> 6040, 6041, 6042, 6080, 6081.

Alan
