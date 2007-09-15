Return-Path: <linux-kernel-owner+w=401wt.eu-S1759596AbXIOKsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759596AbXIOKsq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 06:48:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753548AbXIOKsi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 06:48:38 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50703 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751900AbXIOKsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 06:48:37 -0400
Date: Sat, 15 Sep 2007 03:48:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christian Volkmann <haveaniceday@cv-sv.de>
Cc: linux-kernel@vger.kernel.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: 2.6.23-rc6: usb 1-1: device not accepting address 2, error -62
Message-Id: <20070915034819.3e695370.akpm@linux-foundation.org>
In-Reply-To: <46EAFCF7.1030907@cv-sv.de>
References: <46EAFCF7.1030907@cv-sv.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Let's cc the USB mailing list.

On Fri, 14 Sep 2007 23:28:23 +0200 Christian Volkmann <haveaniceday@cv-sv.de> wrote:

> Hi everybody,
> 
> I have an error message with 2.6.23-rc6.
> This did not happen with 2.6.22.

Another one for Michal's dirt file.

> The kernel reports message like this:
>  <3>usb 1-1: device not accepting address 2, error -62
>  <3>hub 2-2.1:1.0: hub_port_status failed (err = -71)
> 
> Does this message harm or is something broken in 2.6.23-rc6 ?
> I get this kind of messages also with 2.6.23-rc3

Does the machine otherwise work OK?

Even if it does, I don't think we should be (newly) spraying scary messages
like that at people.

> Best regards,
> 
> Christian
> 
> 
> Please see below for:
> 
> grep -e hub -e usb boot.msg for a 2.6.23-rc6 boot. (that boot was without (err = -71)
> grep -e hub -e usb boot.msg for a 2.6.22 boot.
> lspci -vnn (2.6.22)
> lsusb -v (2.6.22)
> 
> 
> 2.6.23-rc6 boot.msg extract ( hub/usb )
> 
> <6>usbcore: registered new interface driver usbfs
> <6>usbcore: registered new interface driver hub
> <6>usbcore: registered new device driver usb
> <6>usb usb1: configuration #1 chosen from 1 choice
> <6>hub 1-0:1.0: USB hub found
> <6>hub 1-0:1.0: 2 ports detected
> <6>usb usb2: configuration #1 chosen from 1 choice
> <6>hub 2-0:1.0: USB hub found
> <6>hub 2-0:1.0: 2 ports detected
> <6>usb 1-1: new low speed USB device using ohci_hcd and address 2
> <6>usb usb3: configuration #1 chosen from 1 choice
> <6>hub 3-0:1.0: USB hub found
> <6>hub 3-0:1.0: 2 ports detected
> <6>usb usb4: configuration #1 chosen from 1 choice
> <6>hub 4-0:1.0: USB hub found
> <6>hub 4-0:1.0: 6 ports detected
> <6>usb usb5: configuration #1 chosen from 1 choice
> <6>hub 5-0:1.0: USB hub found
> <6>hub 5-0:1.0: 2 ports detected
> <3>usb 1-1: device not accepting address 2, error -62
> <6>usb 5-2: new full speed USB device using uhci_hcd and address 2
> <6>usb usb6: configuration #1 chosen from 1 choice
> <6>hub 6-0:1.0: USB hub found
> <6>hub 6-0:1.0: 4 ports detected
> <6>usb usb7: configuration #1 chosen from 1 choice
> <6>hub 7-0:1.0: USB hub found
> <6>hub 7-0:1.0: 2 ports detected
> <6>usb 1-1: new low speed USB device using ohci_hcd and address 4
> <6>usb 1-1: configuration #1 chosen from 1 choice
> <6>usb 2-1: new full speed USB device using ohci_hcd and address 2
> <6>usb 2-1: configuration #1 chosen from 1 choice
> <6>usb 6-2: new high speed USB device using ehci_hcd and address 2
> <6>usb 6-2: configuration #1 chosen from 1 choice
> <6>hub 6-2:1.0: USB hub found
> <6>hub 6-2:1.0: 2 ports detected
> <6>usbcore: registered new interface driver hiddev
> <6>input: USB HID v1.11 Mouse [USB Optical Mouse] on usb-0000:00:03.0-1
> <6>usbcore: registered new interface driver usbhid
> <6>drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
> <7>usb-storage: device found at 2
> <7>usb-storage: waiting for device to settle before scanning
> <6>usb 6-2.1: new high speed USB device using ehci_hcd and address 3
> <6>usb 6-2.1: configuration #1 chosen from 1 choice
> <6>hub 6-2.1:1.0: USB hub found
> <6>hub 6-2.1:1.0: 4 ports detected
> <6>usb 6-2.1.1: new high speed USB device using ehci_hcd and address 4
> <6>usb 6-2.1.1: configuration #1 chosen from 1 choice
> <7>usb-storage: device found at 4
> <7>usb-storage: waiting for device to settle before scanning
> <6>usbcore: registered new interface driver usb-storage
> <7>usb-storage: device scan complete
> <7>usb-storage: device scan complete
> 
> 2.6.22 boot.msg extract ( hub/usb )
> 
> <6>usbcore: registered new interface driver usbfs
> <6>usbcore: registered new interface driver hub
> <6>usbcore: registered new device driver usb
> <6>usb usb1: configuration #1 chosen from 1 choice
> <6>hub 1-0:1.0: USB hub found
> <6>hub 1-0:1.0: 2 ports detected
> <6>usb usb2: configuration #1 chosen from 1 choice
> <6>hub 2-0:1.0: USB hub found
> <6>hub 2-0:1.0: 2 ports detected
> <6>usb 1-1: new low speed USB device using ohci_hcd and address 2
> <6>usb usb3: configuration #1 chosen from 1 choice
> <6>hub 3-0:1.0: USB hub found
> <6>hub 3-0:1.0: 2 ports detected
> <6>usb 1-1: configuration #1 chosen from 1 choice
> <6>usb usb4: configuration #1 chosen from 1 choice
> <6>hub 4-0:1.0: USB hub found
> <6>hub 4-0:1.0: 6 ports detected
> <6>usb 1-1: USB disconnect, address 2
> <6>usb usb5: configuration #1 chosen from 1 choice
> <6>hub 5-0:1.0: USB hub found
> <6>hub 5-0:1.0: 4 ports detected
> <6>usb usb6: configuration #1 chosen from 1 choice
> <6>hub 6-0:1.0: USB hub found
> <6>hub 6-0:1.0: 2 ports detected
> <6>usb usb7: configuration #1 chosen from 1 choice
> <6>hub 7-0:1.0: USB hub found
> <6>hub 7-0:1.0: 2 ports detected
> <6>usb 5-2: new high speed USB device using ehci_hcd and address 2
> <6>usb 5-2: configuration #1 chosen from 1 choice
> <6>hub 5-2:1.0: USB hub found
> <6>hub 5-2:1.0: 2 ports detected
> <6>usb 1-1: new low speed USB device using ohci_hcd and address 3
> <6>usb 1-1: configuration #1 chosen from 1 choice
> <6>usbcore: registered new interface driver hiddev
> <6>usb 2-1: new full speed USB device using ohci_hcd and address 2
> <6>usb 2-1: configuration #1 chosen from 1 choice
> <6>usb 5-2.1: new high speed USB device using ehci_hcd and address 3
> <6>usb 5-2.1: configuration #1 chosen from 1 choice
> <6>hub 5-2.1:1.0: USB hub found
> <6>hub 5-2.1:1.0: 4 ports detected
> <6>input: USB HID v1.11 Mouse [USB Optical Mouse] on usb-0000:00:03.0-1
> <7>usb-storage: device found at 2
> <7>usb-storage: waiting for device to settle before scanning
> <6>usb 5-2.1.1: new high speed USB device using ehci_hcd and address 4
> <6>usb 5-2.1.1: configuration #1 chosen from 1 choice
> <6>usbcore: registered new interface driver usbhid
> <7>usb-storage: device found at 4
> <7>usb-storage: waiting for device to settle before scanning
> <6>usbcore: registered new interface driver usb-storage
> <6>drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
> <7>usb-storage: device scan complete
> <7>usb-storage: device scan complete
> 
> [system info snipped ]
>
