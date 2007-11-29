Return-Path: <linux-kernel-owner+w=401wt.eu-S1762474AbXK2OQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762474AbXK2OQe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 09:16:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756321AbXK2OQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 09:16:28 -0500
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:39403 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756567AbXK2OQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 09:16:27 -0500
Date: Thu, 29 Nov 2007 15:16:11 +0100
To: Pete Zaitcev <zaitcev@redhat.com>
Cc: linux-usb@vger.kernel.org, kristoffer.ericson@gmail.com,
       drussell@redhat.com, johann.wilhelm@student.tugraz.at,
       linux-kernel@vger.kernel.org
Subject: Re: Add the infamous Huawei E220 to option.c
Message-ID: <20071129141611.GB27279@gamma.logic.tuwien.ac.at>
References: <20071128161305.b01167b3.zaitcev@redhat.com> <20071129141444.GA27279@gamma.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="azLHFNyN32YCQGCU"
Content-Disposition: inline
In-Reply-To: <20071129141444.GA27279@gamma.logic.tuwien.ac.at>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Norbert Preining <preining@logic.at>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Do, 29 Nov 2007, preining wrote:
> So to be clear: kernl 2.6.24-rc3 + your patch gives me permanent cycles
> and an error:
> 	option_start_huawei: HUAWEI E220 setup failed (1)
> I attach the syslog part which exhibits the behaviour.

Now really attached.

Best wishes

Norbert

-------------------------------------------------------------------------------
Dr. Norbert Preining <preining@logic.at>        Vienna University of Technology
Debian Developer <preining@debian.org>                         Debian TeX Group
gpg DSA: 0x09C5B094      fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
-------------------------------------------------------------------------------
YONDER BOGINE (n.)
The kind of restaurant advertised as 'just three minutes from this
cinema' which clearly nobody ever goes to and, even if they had ever
contemplated it, have certainly changed their mind since seeing the
advert.
			--- Douglas Adams, The Meaning of Liff

--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=syslog

usb 2-2: new full speed USB device using uhci_hcd and address 2
PM: Adding info for usb:2-2
PM: Adding info for No Bus:usbdev2.2_ep00
usb 2-2: configuration #1 chosen from 1 choice
PM: Adding info for usb:2-2:1.0
PM: Adding info for No Bus:usbdev2.2_ep83
PM: Adding info for No Bus:usbdev2.2_ep04
PM: Adding info for No Bus:usbdev2.2
Initializing USB Mass Storage driver...
scsi2 : SCSI emulation for USB Mass Storage devices
PM: Adding info for No Bus:host2
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usb-storage: device found at 2
usb-storage: waiting for device to settle before scanning
usbcore: registered new interface driver usbserial
drivers/usb/serial/usb-serial.c: USB Serial support registered for generic
usbcore: registered new interface driver usbserial_generic
drivers/usb/serial/usb-serial.c: USB Serial Driver core
drivers/usb/serial/usb-serial.c: USB Serial support registered for GSM modem (1-port)
usbcore: registered new interface driver option
drivers/usb/serial/option.c: USB Driver for GSM modems: v0.7.1
usb 2-2: USB disconnect, address 2
PM: Removing info for No Bus:usbdev2.2_ep83
PM: Removing info for No Bus:usbdev2.2_ep04
PM: Removing info for No Bus:host2
PM: Removing info for usb:2-2:1.0
PM: Removing info for No Bus:usbdev2.2
PM: Removing info for No Bus:usbdev2.2_ep00
PM: Removing info for usb:2-2
usb 2-2: new full speed USB device using uhci_hcd and address 3
PM: Adding info for usb:2-2
PM: Adding info for No Bus:usbdev2.3_ep00
usb 2-2: configuration #1 chosen from 1 choice
PM: Adding info for usb:2-2:1.0
usb-storage: probe of 2-2:1.0 failed with error -5
option 2-2:1.0: GSM modem (1-port) converter detected
option_start_huawei: HUAWEI E220 setup failed (1)
PM: Adding info for usb-serial:ttyUSB0
PM: Adding info for No Bus:ttyUSB0
usb 2-2: GSM modem (1-port) converter now attached to ttyUSB0
PM: Adding info for No Bus:usbdev2.3_ep81
PM: Adding info for No Bus:usbdev2.3_ep82
PM: Adding info for No Bus:usbdev2.3_ep02
PM: Adding info for usb:2-2:1.1
usb-storage: probe of 2-2:1.1 failed with error -5
option 2-2:1.1: GSM modem (1-port) converter detected
option_start_huawei: HUAWEI E220 setup failed (1)
PM: Adding info for usb-serial:ttyUSB1
PM: Adding info for No Bus:ttyUSB1
usb 2-2: GSM modem (1-port) converter now attached to ttyUSB1
PM: Adding info for No Bus:usbdev2.3_ep85
PM: Adding info for No Bus:usbdev2.3_ep05
PM: Adding info for usb:2-2:1.2
scsi5 : SCSI emulation for USB Mass Storage devices
PM: Adding info for No Bus:host5
PM: Adding info for No Bus:usbdev2.3_ep83
PM: Adding info for No Bus:usbdev2.3_ep04
PM: Adding info for No Bus:usbdev2.3
usb-storage: device found at 3
usb-storage: waiting for device to settle before scanning
PM: Adding info for No Bus:target5:0:0
scsi 5:0:0:0: CD-ROM            HUAWEI   Mass Storage     2.31 PQ: 0 ANSI: 2
PM: Adding info for scsi:5:0:0:0
PM: Adding info for No Bus:target5:0:1
PM: Removing info for No Bus:target5:0:1
PM: Adding info for No Bus:target5:0:2
PM: Removing info for No Bus:target5:0:2
PM: Adding info for No Bus:target5:0:3
PM: Removing info for No Bus:target5:0:3
PM: Adding info for No Bus:target5:0:4
PM: Removing info for No Bus:target5:0:4
PM: Adding info for No Bus:target5:0:5
PM: Removing info for No Bus:target5:0:5
PM: Adding info for No Bus:target5:0:6
PM: Removing info for No Bus:target5:0:6
PM: Adding info for No Bus:target5:0:7
PM: Removing info for No Bus:target5:0:7
usb-storage: device scan complete
sr0: scsi-1 drive
Uniform CD-ROM driver Revision: 3.20
sr 5:0:0:0: Attached scsi CD-ROM sr0
sd 0:0:0:0: Attached scsi generic sg0 type 0
sr 5:0:0:0: Attached scsi generic sg1 type 5
usb 2-2: reset full speed USB device using uhci_hcd and address 3
usb 2-2: reset full speed USB device using uhci_hcd and address 3
usb 2-2: device descriptor read/64, error -71
usb 2-2: USB disconnect, address 3
PM: Removing info for No Bus:usbdev2.3_ep81
PM: Removing info for No Bus:usbdev2.3_ep82
PM: Removing info for No Bus:usbdev2.3_ep02
PM: Removing info for No Bus:ttyUSB0
option1 ttyUSB0: GSM modem (1-port) converter now disconnected from ttyUSB0
PM: Removing info for usb-serial:ttyUSB0
option 2-2:1.0: device disconnected
PM: Removing info for usb:2-2:1.0
PM: Removing info for No Bus:usbdev2.3_ep85
PM: Removing info for No Bus:usbdev2.3_ep05
PM: Removing info for No Bus:ttyUSB1
option1 ttyUSB1: GSM modem (1-port) converter now disconnected from ttyUSB1
PM: Removing info for usb-serial:ttyUSB1
option 2-2:1.1: device disconnected
PM: Removing info for usb:2-2:1.1
PM: Removing info for No Bus:usbdev2.3_ep83
PM: Removing info for No Bus:usbdev2.3_ep04
PM: Removing info for scsi:5:0:0:0
PM: Removing info for No Bus:host5
PM: Removing info for usb:2-2:1.2
PM: Removing info for No Bus:usbdev2.3
PM: Removing info for No Bus:usbdev2.3_ep00
PM: Removing info for usb:2-2
PM: Removing info for No Bus:target5:0:0
usb 2-2: new full speed USB device using uhci_hcd and address 4
PM: Adding info for usb:2-2
PM: Adding info for No Bus:usbdev2.4_ep00
usb 2-2: configuration #1 chosen from 1 choice
PM: Adding info for usb:2-2:1.0
usb-storage: probe of 2-2:1.0 failed with error -5
option 2-2:1.0: GSM modem (1-port) converter detected
option_start_huawei: HUAWEI E220 setup failed (1)
PM: Adding info for usb-serial:ttyUSB0
PM: Adding info for No Bus:ttyUSB0
usb 2-2: GSM modem (1-port) converter now attached to ttyUSB0
PM: Adding info for No Bus:usbdev2.4_ep81
PM: Adding info for No Bus:usbdev2.4_ep82
PM: Adding info for No Bus:usbdev2.4_ep02
PM: Adding info for usb:2-2:1.1
usb-storage: probe of 2-2:1.1 failed with error -5
option 2-2:1.1: GSM modem (1-port) converter detected
option_start_huawei: HUAWEI E220 setup failed (1)
PM: Adding info for usb-serial:ttyUSB1
PM: Adding info for No Bus:ttyUSB1
usb 2-2: GSM modem (1-port) converter now attached to ttyUSB1
PM: Adding info for No Bus:usbdev2.4_ep85
PM: Adding info for No Bus:usbdev2.4_ep05
PM: Adding info for usb:2-2:1.2
scsi8 : SCSI emulation for USB Mass Storage devices
PM: Adding info for No Bus:host8
PM: Adding info for No Bus:usbdev2.4_ep83
PM: Adding info for No Bus:usbdev2.4_ep04
PM: Adding info for No Bus:usbdev2.4
usb-storage: device found at 4
usb-storage: waiting for device to settle before scanning
PM: Adding info for No Bus:target8:0:0
usb 2-2: reset full speed USB device using uhci_hcd and address 4
scsi 8:0:0:0: CD-ROM            HUAWEI   Mass Storage     2.31 PQ: 0 ANSI: 2
PM: Adding info for scsi:8:0:0:0
sr0: scsi-1 drive
sr 8:0:0:0: Attached scsi CD-ROM sr0
sr 8:0:0:0: Attached scsi generic sg1 type 5
PM: Adding info for No Bus:target8:0:1
PM: Removing info for No Bus:target8:0:1
PM: Adding info for No Bus:target8:0:2
PM: Removing info for No Bus:target8:0:2
PM: Adding info for No Bus:target8:0:3
PM: Removing info for No Bus:target8:0:3
PM: Adding info for No Bus:target8:0:4
PM: Removing info for No Bus:target8:0:4
PM: Adding info for No Bus:target8:0:5
PM: Removing info for No Bus:target8:0:5
PM: Adding info for No Bus:target8:0:6
PM: Removing info for No Bus:target8:0:6
PM: Adding info for No Bus:target8:0:7
PM: Removing info for No Bus:target8:0:7
usb-storage: device scan complete
usb 2-2: reset full speed USB device using uhci_hcd and address 4
usb 2-2: reset full speed USB device using uhci_hcd and address 4
usb 2-2: USB disconnect, address 4
PM: Removing info for No Bus:usbdev2.4_ep81
PM: Removing info for No Bus:usbdev2.4_ep82
PM: Removing info for No Bus:usbdev2.4_ep02
PM: Removing info for No Bus:ttyUSB0
option1 ttyUSB0: GSM modem (1-port) converter now disconnected from ttyUSB0
PM: Removing info for usb-serial:ttyUSB0
option 2-2:1.0: device disconnected
PM: Removing info for usb:2-2:1.0
PM: Removing info for No Bus:usbdev2.4_ep85
PM: Removing info for No Bus:usbdev2.4_ep05
PM: Removing info for No Bus:ttyUSB1
option1 ttyUSB1: GSM modem (1-port) converter now disconnected from ttyUSB1
PM: Removing info for usb-serial:ttyUSB1
option 2-2:1.1: device disconnected
PM: Removing info for usb:2-2:1.1
PM: Removing info for No Bus:usbdev2.4_ep83
PM: Removing info for No Bus:usbdev2.4_ep04
PM: Removing info for scsi:8:0:0:0
PM: Removing info for No Bus:host8
PM: Removing info for usb:2-2:1.2
PM: Removing info for No Bus:usbdev2.4
PM: Removing info for No Bus:usbdev2.4_ep00
PM: Removing info for usb:2-2
PM: Removing info for No Bus:target8:0:0
usb 2-2: new full speed USB device using uhci_hcd and address 5
PM: Adding info for usb:2-2
PM: Adding info for No Bus:usbdev2.5_ep00
usb 2-2: configuration #1 chosen from 1 choice
PM: Adding info for usb:2-2:1.0
usb-storage: probe of 2-2:1.0 failed with error -5
option 2-2:1.0: GSM modem (1-port) converter detected
option_start_huawei: HUAWEI E220 setup failed (1)
PM: Adding info for usb-serial:ttyUSB0
PM: Adding info for No Bus:ttyUSB0
usb 2-2: GSM modem (1-port) converter now attached to ttyUSB0
PM: Adding info for No Bus:usbdev2.5_ep81
PM: Adding info for No Bus:usbdev2.5_ep82
PM: Adding info for No Bus:usbdev2.5_ep02
PM: Adding info for usb:2-2:1.1
usb-storage: probe of 2-2:1.1 failed with error -5
option 2-2:1.1: GSM modem (1-port) converter detected
option_start_huawei: HUAWEI E220 setup failed (1)
PM: Adding info for usb-serial:ttyUSB1
PM: Adding info for No Bus:ttyUSB1
usb 2-2: GSM modem (1-port) converter now attached to ttyUSB1
PM: Adding info for No Bus:usbdev2.5_ep85
PM: Adding info for No Bus:usbdev2.5_ep05
PM: Adding info for usb:2-2:1.2
scsi11 : SCSI emulation for USB Mass Storage devices
PM: Adding info for No Bus:host11
PM: Adding info for No Bus:usbdev2.5_ep83
PM: Adding info for No Bus:usbdev2.5_ep04
PM: Adding info for No Bus:usbdev2.5
usb-storage: device found at 5
usb-storage: waiting for device to settle before scanning
PM: Adding info for No Bus:target11:0:0
usb 2-2: reset full speed USB device using uhci_hcd and address 5
scsi 11:0:0:0: CD-ROM            HUAWEI   Mass Storage     2.31 PQ: 0 ANSI: 2
PM: Adding info for scsi:11:0:0:0
sr0: scsi-1 drive
sr 11:0:0:0: Attached scsi CD-ROM sr0
sr 11:0:0:0: Attached scsi generic sg1 type 5
PM: Adding info for No Bus:target11:0:1
PM: Removing info for No Bus:target11:0:1
PM: Adding info for No Bus:target11:0:2
PM: Removing info for No Bus:target11:0:2
PM: Adding info for No Bus:target11:0:3
PM: Removing info for No Bus:target11:0:3
PM: Adding info for No Bus:target11:0:4
PM: Removing info for No Bus:target11:0:4
PM: Adding info for No Bus:target11:0:5
PM: Removing info for No Bus:target11:0:5
PM: Adding info for No Bus:target11:0:6
PM: Removing info for No Bus:target11:0:6
PM: Adding info for No Bus:target11:0:7
PM: Removing info for No Bus:target11:0:7
usb-storage: device scan complete
usb 2-2: USB disconnect, address 5
PM: Removing info for No Bus:usbdev2.5_ep81
PM: Removing info for No Bus:usbdev2.5_ep82
PM: Removing info for No Bus:usbdev2.5_ep02
PM: Removing info for No Bus:ttyUSB0
option1 ttyUSB0: GSM modem (1-port) converter now disconnected from ttyUSB0
PM: Removing info for usb-serial:ttyUSB0
option 2-2:1.0: device disconnected
PM: Removing info for usb:2-2:1.0
PM: Removing info for No Bus:usbdev2.5_ep85
PM: Removing info for No Bus:usbdev2.5_ep05
PM: Removing info for No Bus:ttyUSB1
option1 ttyUSB1: GSM modem (1-port) converter now disconnected from ttyUSB1
PM: Removing info for usb-serial:ttyUSB1
option 2-2:1.1: device disconnected
PM: Removing info for usb:2-2:1.1
PM: Removing info for No Bus:usbdev2.5_ep83
PM: Removing info for No Bus:usbdev2.5_ep04
PM: Removing info for scsi:11:0:0:0
PM: Removing info for No Bus:target11:0:0
PM: Removing info for No Bus:host11
PM: Removing info for usb:2-2:1.2
PM: Removing info for No Bus:usbdev2.5
PM: Removing info for No Bus:usbdev2.5_ep00
PM: Removing info for usb:2-2

--azLHFNyN32YCQGCU--
