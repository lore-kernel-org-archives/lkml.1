Return-Path: <linux-kernel-owner+w=401wt.eu-S933771AbXC1Kg5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933771AbXC1Kg5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 06:36:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933779AbXC1Kg5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 06:36:57 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:48097 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933771AbXC1Kg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 06:36:56 -0400
X-Greylist: delayed 1454 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Mar 2007 06:36:55 EDT
Message-ID: <460A3F54.4000301@gmail.com>
Date: Wed, 28 Mar 2007 12:11:32 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: PCI: cannot adjust BAR<X> (not I/O)
Content-Type: multipart/mixed;
 boundary="------------070607050100010408070401"
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070607050100010408070401
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hi Greg.

On an older Intel 430VX system, 2.6.20.4 complains a bit:

===
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Probing PCI hardware
PCI: Probing PCI hardware (bus 00)
0000:00:07.1: cannot adjust BAR0 (not I/O)
0000:00:07.1: cannot adjust BAR1 (not I/O)
0000:00:07.1: cannot adjust BAR2 (not I/O)
0000:00:07.1: cannot adjust BAR3 (not I/O)
Boot video device is 0000:00:08.0
pnp: the driver 'system' has been registered
pnp: match found with the PnP device '00:07' and the driver 'system'
NET: Registered protocol family 2
===

00:07.1 is IDE (lspci -s 7.1 -vv attached, due to wrap). It's no doubt 
safe to ignore but looks a bit alarming...

Rene.


--------------070607050100010408070401
Content-Type: text/plain;
 name="lspci"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="lspci"

00:07.1 IDE interface: Intel Corporation 82371SB PIIX3 IDE [Natoma/Triton II] (prog-if 80 [Master])
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Region 0: [virtual] Memory at 000001f0 (32-bit, non-prefetchable) [disabled] [size=8]
	Region 1: [virtual] Memory at 000003f0 (type 3, non-prefetchable) [disabled] [size=1]
	Region 2: [virtual] Memory at 00000170 (32-bit, non-prefetchable) [disabled] [size=8]
	Region 3: [virtual] Memory at 00000370 (type 3, non-prefetchable) [disabled] [size=1]
	Region 4: I/O ports at f000 [disabled] [size=16]


--------------070607050100010408070401--
