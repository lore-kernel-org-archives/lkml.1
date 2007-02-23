Return-Path: <linux-kernel-owner+w=401wt.eu-S932535AbXBWXGY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932535AbXBWXGY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 18:06:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932704AbXBWXGY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 18:06:24 -0500
Received: from vms040pub.verizon.net ([206.46.252.40]:60695 "EHLO
	vms040pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932535AbXBWXGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 18:06:23 -0500
Date: Fri, 23 Feb 2007 18:06:17 -0500
From: "Tom Morrison" <Tom.Morrison@Verizon.net>
Subject: Problems with init of Marvell PCI Express SATA Card
To: <linux-kernel@vger.kernel.org>
Reply-to: <Tom.Morrison@Verizon.net>
Message-id: <CJEDIOAEPEPAEFLDLKIBAEJLCDAA.Tom.Morrison@Verizon.net>
MIME-version: 1.0
X-MIMEOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Importance: Normal
X-Priority: 3 (Normal)
X-MSMail-priority: Normal
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I am running a relatively recent 2.6.20 
Linux kernels running on both an Intel 
x86 (XEON) as well as one a embedded 
powerPC target (MPC8548E).

I believe my PCI Express interface is 
working correctly on both the embedded 
target as well as - of course - on the 
XEON platform (I have other cards that 
I have working correctly).

The problem is that this Marvell PCI Express 
SATA Card is NOT being probed and thus, 
the SATA/ATA host interface is NOT being 
initialized, and thus the drive is NOT being 
detected/added able to be mounted...

I have more (in)sight into the embedded 
platform, and the SATA module is being 
built into /loaded by the kernel (it does 
a pci_device_register()), but nothing happens 
after that - I see before that the card IS 
being seen on the BUS - I can do a "lspci" 
after that - and the device is on the PCI bus...

I should also add that I have the identical
card on the PCI bus (6042 chip) and the
driver works flawlessly...

What am I doing wrong? Do I need to have 
the PCI ids in the kernel match identically 
what is on pci express sata card device?

Heck, if there is a PCI device register - 
why isn't there an associated probe - no 
matter what?

I apologze if my question is a little 
naive, I am not a PCI expert - I was hoping 
that this would go smoothly enough that I 
wouldn't need to become one!

thanks in advance for all your wisdom!

Sincerely,

Tom Morrison
Principal Software Engineer
EMPIRIX
20 Crosby Drive - Bedford, MA  01730
p: 781.266.3567 f: 781.266.3670
email: tmorrison@empirix.com
www.empirix.com


