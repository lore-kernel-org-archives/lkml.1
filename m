Return-Path: <linux-kernel-owner+w=401wt.eu-S1753887AbXEXWEx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887AbXEXWEx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 18:04:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751073AbXEXWEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 18:04:46 -0400
Received: from yurusanai.de ([85.25.62.54]:41666 "EHLO yurusanai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751011AbXEXWEp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 18:04:45 -0400
X-Greylist: delayed 2625 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 May 2007 18:04:45 EDT
Message-ID: <48969.80.228.60.226.1180041664.squirrel@yurusanai.de>
Date: Thu, 24 May 2007 23:21:04 +0200 (CEST)
Subject: HPT366 not enabled by kernel 2.6.21.2
From: "Pascal Schmidt" <pasukaru@yurusanai.de>
To: "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.9a
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hello!

I recently upgraded my kernel to 2.6.21 (.1 and .2 with identical
results) and my second IDE controller, a HPT366 on a PCI card,
doesn't get enabled any more. The latest previous kernel I used was
2.6.19.7, where the HPT366 worked.

Here's the HPT366 part of the 2.6.21.2 dmesg:

HPT366: IDE controller at PCI slot 0000:02:0a.0
ACPI: PCI Interrupt 0000:02:0a.0[A] -> GSI 18 (level, low) -> IRQ 18
HPT366: chipset revision 1
HPT366: using 33 MHz PCI clock
HPT366: 100% native mode on irq 18
HPT366: neither IDE port enabled (BIOS)
ACPI: PCI Interrupt 0000:02:0a.1[A] -> GSI 18 (level, low) -> IRQ 18
HPT366: using 33 MHz PCI clock
HPT366: neither IDE port enabled (BIOS)

There is a flash disk connected to the primary channel (master)
which also shows up in the controller's BIOS screen, so I don't
think it's true that both ports are disabled.

Under 2.6.17.9 the "neither IDE port enabled" message doesn't
happen and hde gets detected.

Please CC me on replies.

-- 
Ciao,
Pascal

