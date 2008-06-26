Return-Path: <linux-kernel-owner+w=401wt.eu-S1757494AbYFZPi1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757494AbYFZPi1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 11:38:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752394AbYFZPiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 11:38:08 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:48872 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197AbYFZPiG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 11:38:06 -0400
Date: Thu, 26 Jun 2008 17:37:40 +0200
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: 2.6.26-rc1 regression since 2.6.25 - problem in 2.6.26-rc8
	again
Message-ID: <20080626153740.GG4486@ics.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Muni-Spam-TestIP: 147.251.3.109
X-Muni-Envelope-From: xhejtman@anubis.ics.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Thu, 26 Jun 2008 17:37:43 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have another USB problem with Lenovo T61 Thinkpad.

I'm using kernel 2.6.26-rc8. I do use CONFIG_USB_SUSPEND.

If I attach USB disk (using EHCI driver), the disk is found and it is working.
If I remove the disk, undock the laptop, dock the laptop again and plug the
disk, the disk is not found at all until I remove and reinsert the EHCI
driver.

I noticed that if I do not unplug the disk berofe undocking, it works after
docking back.

If I undock with the disk removed, dmesg looks like this:
[85164.642906] usb 3-4.3: USB disconnect, address 5
[85171.901891] ACPI: \_SB_.GDCK - undocking
[85175.116094] eth0: Link is Down
[85183.063339] ACPI: \_SB_.GDCK - docking
[85185.238221] eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: None

nothing more past the eth0 message.

If I undock with the disk plugged in, dmesg looks like this:
[85407.425050] ACPI: \_SB_.GDCK - undocking
[85407.453467] usb 3-4: USB disconnect, address 3
[85407.453478] usb 3-4.3: USB disconnect, address 4
[85410.870520] eth0: Link is Down
[85420.340005] ACPI: \_SB_.GDCK - docking
[85420.829661] usb 3-4: new high speed USB device using ehci_hcd and address 5
[85420.952520] usb 3-4: configuration #1 chosen from 1 choice
[85420.960006] hub 3-4:1.0: USB hub found
[85420.960006] hub 3-4:1.0: 4 ports detected
[85421.066577] usb 3-4: New USB device found, idVendor=04b3, idProduct=4485
[85421.066583] usb 3-4: New USB device strings: Mfr=0, Product=0,
SerialNumber=0
[85422.540557] eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: None
[85426.366908] usb 3-4.3: new high speed USB device using ehci_hcd and address
6
[85426.465420] usb 3-4.3: configuration #1 chosen from 1 choice
[85426.485951] scsi9 : SCSI emulation for USB Mass Storage devices
[85426.485966] usb-storage: device found at 6
[85426.485966] usb-storage: waiting for device to settle before scanning
[85426.487217] usb 3-4.3: New USB device found, idVendor=152d, idProduct=2338
[85426.487217] usb 3-4.3: New USB device strings: Mfr=1, Product=2,
SerialNumber=5
[85426.487217] usb 3-4.3: Product: USB to ATA/ATAPI Bridge
[85426.487217] usb 3-4.3: Manufacturer: JMicron
[85426.487217] usb 3-4.3: SerialNumber: 222291142391
[85431.482899] usb-storage: device scan complete


any ideas?

-- 
Luká¹ Hejtmánek
