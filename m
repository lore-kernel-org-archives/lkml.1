Return-Path: <linux-kernel-owner+w=401wt.eu-S1750880AbXBKVRh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750880AbXBKVRh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 16:17:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750895AbXBKVRh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 16:17:37 -0500
Received: from smtp19.orange.fr ([80.12.242.19]:21210 "EHLO smtp19.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750867AbXBKVRg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 16:17:36 -0500
X-ME-UUID: 20070211211734607.943F91C0008A@mwinf1923.orange.fr
Message-ID: <45CF87EE.5000401@wanadoo.fr>
Date: Sun, 11 Feb 2007 22:17:34 +0100
From: Thibaud Hulin <hulin.thibaud@wanadoo.fr>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Cc: alex14641@yahoo.com, oliver@neukum.org
Subject: Problem with USB ports and a dongle
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi !

I'm trying to use a dongle for ndiswrapper, but it fails because a 
problem of usb. Note that the problem appear when ndiswrapper is fully 
uninstalled (and others packages as ndiswrapper-utils, with modprobe -r, 
etc...).

So ; when I get on the first time the dongle, a lsusb give :
Bus 001 Device 002: ID 0457:0163 Silicon Integrated Systems Corps.
Bus 001 Device 001: ID 0000:0000
But, a few seconds later, the dongle is not recognize with sometimes an 
error -71.
Then, lsusb forget the driver and get :
Bus 001 Device 001: ID 0000:0000

How can I configure the kernel to have the good configuration ? I tried 
different ways, but it fails.

I already reinstalled the bios.

See at below for the result of these commands (when I try the dongle) :
"lspci -v |grep HCI"
"cat /var/log/messages" (the end)
"dmesg |grep usb"

Thanks for help,
Thibaud.

NB1 : thanks to Alex Davis and Oliver Neukum for advices and 
recommendations about check if the problem was from ndiswrapper or not. 
I hope there is not a special list for kernel USB ; if yes : apologizes, 
I couldn't find it.

NB2 : I'm not sure if this message is too long or not. I included the 
mention "End of the message" at last.

---------------

My hardware :
Computer : dell pentium mmx 233 mst
ram : 128 Mo
dongle : thomson WLG-1500A - chipset Sis163u
Kernel 2.6.19
Ubuntu Edgy

"lspci -v |grep HCI" :

00:01.2 USB Controller: Intel Corporation 82371AB/EB/MB PIIX4 USB (rev 
01) (prog-if 00 [UHCI])

-------------

"cat /var/log/messages"

Feb 11 21:41:08 localhost kernel: [ 6049.104000] usb 1-1: new full speed 
USB device using uhci_hcd and address 2
Feb 11 21:41:08 localhost kernel: [ 6049.252000] usb 1-1: configuration 
#1 chosen from 1 choice
Feb 11 21:41:12 localhost kernel: [ 6053.592000] usb 1-1: USB 
disconnect, address 2
Feb 11 21:41:12 localhost kernel: [ 6053.712000] usb 1-1: new full speed 
USB device using uhci_hcd and address 3
Feb 11 21:41:13 localhost kernel: [ 6053.860000] usb 1-1: configuration 
#1 chosen from 1 choice
Feb 11 21:41:15 localhost kernel: [ 6056.592000] usb 1-1: USB 
disconnect, address 3
Feb 11 21:41:15 localhost kernel: [ 6056.712000] usb 1-1: new full speed 
USB device using uhci_hcd and address 4
Feb 11 21:41:16 localhost kernel: [ 6056.856000] usb 1-1: configuration 
#1 chosen from 1 choice
Feb 11 21:41:19 localhost kernel: [ 6059.700000] usb 1-1: USB 
disconnect, address 4
Feb 11 21:41:19 localhost kernel: [ 6059.812000] usb 1-1: new full speed 
USB device using uhci_hcd and address 5
Feb 11 21:41:20 localhost kernel: [ 6059.960000] usb 1-1: configuration 
#1 chosen from 1 choice
Feb 11 21:41:20 localhost kernel: [ 6060.204000] usb 1-1: USB 
disconnect, address 5
Feb 11 21:41:20 localhost kernel: [ 6060.316000] usb 1-1: new full speed 
USB device using uhci_hcd and address 6
Feb 11 21:41:20 localhost kernel: [ 6060.464000] usb 1-1: configuration 
#1 chosen from 1 choice
Feb 11 21:41:21 localhost kernel: [ 6062.220000] usb 1-1: USB 
disconnect, address 6
Feb 11 21:41:21 localhost kernel: [ 6062.332000] usb 1-1: new full speed 
USB device using uhci_hcd and address 7
Feb 11 21:41:21 localhost kernel: [ 6062.480000] usb 1-1: configuration 
#1 chosen from 1 choice
Feb 11 21:41:22 localhost kernel: [ 6062.724000] usb 1-1: USB 
disconnect, address 7
Feb 11 21:41:22 localhost kernel: [ 6062.836000] usb 1-1: new full speed 
USB device using uhci_hcd and address 8
Feb 11 21:41:22 localhost kernel: [ 6062.984000] usb 1-1: configuration 
#1 chosen from 1 choice
Feb 11 21:41:22 localhost kernel: [ 6063.480000] usb 1-1: USB 
disconnect, address 8
Feb 11 21:41:22 localhost kernel: [ 6063.592000] usb 1-1: new full speed 
USB device using uhci_hcd and address 9
Feb 11 21:41:24 localhost kernel: [ 6064.452000] usb 1-1: new full speed 
USB device using uhci_hcd and address 10
Feb 11 21:41:24 localhost kernel: [ 6065.012000] usb 1-1: new full speed 
USB device using uhci_hcd and address 11
Feb 11 21:41:24 localhost kernel: [ 6065.532000] usb 1-1: new full speed 
USB device using uhci_hcd and address 12


-------------

dmesg |grep usb :

[   17.780000] usbcore: registered new interface driver usbfs
[   17.784000] usbcore: registered new interface driver hub
[   17.788000] usbcore: registered new device driver usb
[   17.808000] usb usb1: configuration #1 chosen from 1 choice
[   69.416000] usbcore: registered new interface driver ndiswrapper
[ 5916.300000] usbcore: deregistering interface driver ndiswrapper
[ 6049.104000] usb 1-1: new full speed USB device using uhci_hcd and 
address 2
[ 6049.252000] usb 1-1: configuration #1 chosen from 1 choice
[ 6053.592000] usb 1-1: USB disconnect, address 2
[ 6053.712000] usb 1-1: new full speed USB device using uhci_hcd and 
address 3
[ 6053.860000] usb 1-1: configuration #1 chosen from 1 choice
[ 6056.592000] usb 1-1: USB disconnect, address 3
[ 6056.712000] usb 1-1: new full speed USB device using uhci_hcd and 
address 4
[ 6056.856000] usb 1-1: configuration #1 chosen from 1 choice
[ 6059.700000] usb 1-1: USB disconnect, address 4
[ 6059.812000] usb 1-1: new full speed USB device using uhci_hcd and 
address 5
[ 6059.960000] usb 1-1: configuration #1 chosen from 1 choice
[ 6060.204000] usb 1-1: USB disconnect, address 5
[ 6060.316000] usb 1-1: new full speed USB device using uhci_hcd and 
address 6
[ 6060.464000] usb 1-1: configuration #1 chosen from 1 choice
[ 6062.220000] usb 1-1: USB disconnect, address 6
[ 6062.332000] usb 1-1: new full speed USB device using uhci_hcd and 
address 7
[ 6062.480000] usb 1-1: configuration #1 chosen from 1 choice
[ 6062.724000] usb 1-1: USB disconnect, address 7
[ 6062.836000] usb 1-1: new full speed USB device using uhci_hcd and 
address 8
[ 6062.984000] usb 1-1: configuration #1 chosen from 1 choice
[ 6063.480000] usb 1-1: USB disconnect, address 8
[ 6063.592000] usb 1-1: new full speed USB device using uhci_hcd and 
address 9
[ 6063.712000] usb 1-1: device descriptor read/64, error -71
[ 6064.340000] usb 1-1: device not accepting address 9, error -71
[ 6064.452000] usb 1-1: new full speed USB device using uhci_hcd and 
address 10
[ 6064.572000] usb 1-1: device descriptor read/64, error -71
[ 6064.796000] usb 1-1: device descriptor read/64, error -71
[ 6065.012000] usb 1-1: new full speed USB device using uhci_hcd and 
address 11
[ 6065.420000] usb 1-1: device not accepting address 11, error -71
[ 6065.532000] usb 1-1: new full speed USB device using uhci_hcd and 
address 12
[ 6065.940000] usb 1-1: device not accepting address 12, error -71

----------------

End of the message

