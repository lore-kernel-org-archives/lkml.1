Return-Path: <linux-kernel-owner+w=401wt.eu-S933275AbXBXAdy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933275AbXBXAdy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 19:33:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933277AbXBXAdy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 19:33:54 -0500
Received: from vms040pub.verizon.net ([206.46.252.40]:55279 "EHLO
	vms040pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933275AbXBXAdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 19:33:54 -0500
Date: Fri, 23 Feb 2007 19:33:52 -0500
From: "Tom Morrison" <Tom.Morrison@Verizon.net>
Subject: RE: Problems with init of Marvell PCI Express SATA Card
In-reply-to: <20070224011754.5b8447dc@lxorguk.ukuu.org.uk>
To: "Alan" <alan@lxorguk.ukuu.org.uk>
Cc: <linux-kernel@vger.kernel.org>
Reply-to: <Tom.Morrison@Verizon.net>
Message-id: <CJEDIOAEPEPAEFLDLKIBCEJOCDAA.Tom.Morrison@Verizon.net>
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

got it! thank you for showing the error of my way...
and being so patient with me!  damm, that means
I gotta work this weekend...:-)...

-----Original Message-----
From: Alan [mailto:alan@lxorguk.ukuu.org.uk]
Sent: Friday, February 23, 2007 8:18 PM
To: Tom.Morrison@Verizon.net
Cc: linux-kernel@vger.kernel.org
Subject: Re: Problems with init of Marvell PCI Express SATA Card


> if you look in the sata_mv.c it has support for the 
> 7042 throughout it (exactly the same as PCI in fact - 
> its the same core chip - just different bus interface)...

For the 7042 with the TTI PCI identifier but not one with a Marvell ID -
what vendor/device does your device show up ?

The probe code uses the table in each driver to do matches. For the 7042
the only version it knows is

   { PCI_VDEVICE(TTI, 0x2310), chip_7042 },
