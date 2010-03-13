Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740Ab0CMLsY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 06:48:24 -0500
Received: from vs244178.vserver.de ([62.75.244.178]:34985 "EHLO
	smtp.eikelenboom.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595Ab0CMLsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 06:48:22 -0500
X-Greylist: delayed 2826 seconds by postgrey-1.27 at vger.kernel.org; Sat, 13 Mar 2010 06:48:21 EST
Date: Sat, 13 Mar 2010 12:01:13 +0100
From: Sander Eikelenboom <linux@eikelenboom.it>
Organization: Eikelenboom IT services
X-Priority: 3 (Normal)
Message-ID: <1622196186.20100313120113@eikelenboom.it>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, andiry.xu@amd.com,
       <libin.yang@amd.com>
Subject: Re: [2.6.34-rc1] Problem using USB 1.1 device on USB 3.0 xhci host controller
In-Reply-To: <20100312232538.GA13353@xanatos>
References: <1751702501.20100312174345@eikelenboom.it> <20100312232538.GA13353@xanatos>
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="----------110125428278FB3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------------110125428278FB3
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: quoted-printable

The patches applied cleanly, but the device doesn't work yet.
complete dmesg and lsusb -vvv attached.

Highlights from dmesg:

[    1.738043] usb 9-3: skipped 4 descriptors after interface
[    1.738045] usb 9-3: skipped 2 descriptors after interface
[    1.738048] usb 9-3: skipped 1 descriptor after endpoint
[    1.738050] usb 9-3: skipped 2 descriptors after interface
[    1.738053] usb 9-3: skipped 1 descriptor after endpoint
[    1.738055] usb 9-3: skipped 2 descriptors after interface
[    1.738057] usb 9-3: skipped 1 descriptor after endpoint
[    1.738059] usb 9-3: skipped 2 descriptors after interface
[    1.738061] usb 9-3: skipped 1 descriptor after endpoint
[    1.741021] xhci_hcd 0000:03:00.0: WARN: short transfer on control ep
[    1.742039] usb 9-3: default language 0x0409
[    1.765016] xhci_hcd 0000:03:00.0: WARN: short transfer on control ep
[    1.766036] usb 9-3: udev 2, busnum 9, minor =3D 1025
[    1.766038] usb 9-3: New USB device found, idVendor=3D0471, idProduct=3D=
0311
[    1.766244] usb 9-3: New USB device strings: Mfr=3D0, Product=3D0, Seria=
lNumber=3D1
[    1.766448] usb 9-3: SerialNumber: 01680000EA164101
[    1.766811] usb 9-3: usb_probe_device
[    1.766813] usb 9-3: configuration #1 chosen from 1 choice
[    1.767184] usb 9-3: Successful Endpoint Configure command
[    1.769035] usb 9-3: adding 9-3:1.0 (config #1, interface 0)
[    1.769151] usb 9-3: adding 9-3:1.1 (config #1, interface 1)
[    1.769235] usb 9-3: adding 9-3:1.2 (config #1, interface 2)

[    4.483174] pwc: Philips PCVC740K (ToUCam Pro)/PCVC840 (ToUCam II) USB w=
ebcam detected.
[    4.515833] xhci_hcd 0000:03:00.0: WARN: short transfer on control ep
[    4.516894] pwc: Registered as video0.
[    4.518834] xhci_hcd 0000:03:00.0: WARN: Stalled endpoint
[    4.520834] xhci_hcd 0000:03:00.0: WARN: Stalled endpoint
[    4.521051] Philips webcam 9-3:1.1: usb_probe_interface
[    4.521053] Philips webcam 9-3:1.1: usb_probe_interface - got id
[    4.521058] Philips webcam 9-3:1.2: usb_probe_interface
[    4.521060] Philips webcam 9-3:1.2: usb_probe_interface - got id
[    4.521073] usbcore: registered new interface driver Philips webcam


And when trying to actually grab pictures from the device:

[   12.957593] usb 9-3: Successful Endpoint Configure command
[   12.967542] usb 9-3: ep 0x85 - urb len =3D 0x2580 (9600), addr =3D 0x7ac=
74000, num_trbs =3D 10
[   12.967553] usb 9-3: ep 0x85 - urb len =3D 0x2580 (9600), addr =3D 0x7af=
8c000, num_trbs =3D 10
[   12.985500] xhci_hcd 0000:03:00.0: WARN Event TRB for slot 1 ep 10 with =
no TDs queued?
[   20.946116] eth1: no IPv6 routers present
[   40.029279] usb 9-3: Successful Endpoint Configure command
[   40.039186] usb 9-3: ep 0x85 - urb len =3D 0x2580 (9600), addr =3D 0x7a8=
14000, num_trbs =3D 10
[   40.039198] usb 9-3: ep 0x85 - urb len =3D 0x2580 (9600), addr =3D 0x7b7=
34000, num_trbs =3D 10
[   40.057195] xhci_hcd 0000:03:00.0: WARN Event TRB for slot 1 ep 10 with =
no TDs queued?
[   40.216270] usb 9-3: Successful Endpoint Configure command
[   40.226183] usb 9-3: ep 0x85 - urb len =3D 0x2580 (9600), addr =3D 0x7a9=
c0000, num_trbs =3D 10
[   40.226193] usb 9-3: ep 0x85 - urb len =3D 0x2580 (9600), addr =3D 0x7a9=
8c000, num_trbs =3D 10
[   40.245183] xhci_hcd 0000:03:00.0: WARN Event TRB for slot 1 ep 10 with =
no TDs queued?
[   40.399261] usb 9-3: Successful Endpoint Configure command
[   40.408210] usb 9-3: ep 0x85 - urb len =3D 0x2580 (9600), addr =3D 0x7a9=
c0000, num_trbs =3D 10
[   40.408220] usb 9-3: ep 0x85 - urb len =3D 0x2580 (9600), addr =3D 0x7a9=
8c000, num_trbs =3D 10
[   47.145805] xhci_hcd 0000:03:00.0: WARN Event TRB for slot 1 ep 10 with =
no TDs queued?
[   48.076894] usb 9-3: Successful Endpoint Configure command
[   48.086805] usb 9-3: ep 0x85 - urb len =3D 0x2580 (9600), addr =3D 0x7b1=
80000, num_trbs =3D 10
[   48.086816] usb 9-3: ep 0x85 - urb len =3D 0x2580 (9600), addr =3D 0x7b4=
7c000, num_trbs =3D 10
[   48.105803] xhci_hcd 0000:03:00.0: WARN Event TRB for slot 1 ep 10 with =
no TDs queued?
[   48.263885] usb 9-3: Successful Endpoint Configure command
[   48.273796] usb 9-3: ep 0x85 - urb len =3D 0x2580 (9600), addr =3D 0x7bb=
a0000, num_trbs =3D 10
[   48.273807] usb 9-3: ep 0x85 - urb len =3D 0x2580 (9600), addr =3D 0x7af=
6c000, num_trbs =3D 10
[   48.292793] xhci_hcd 0000:03:00.0: WARN Event TRB for slot 1 ep 10 with =
no TDs queued?
[   48.446875] usb 9-3: Successful Endpoint Configure command
[   48.456784] usb 9-3: ep 0x85 - urb len =3D 0x2580 (9600), addr =3D 0x7bb=
a0000, num_trbs =3D 10
[   48.456794] usb 9-3: ep 0x85 - urb len =3D 0x2580 (9600), addr =3D 0x7af=
6c000, num_trbs =3D 10
[   51.778648] xhci_hcd 0000:03:00.0: WARN Event TRB for slot 1 ep 10 with =
no TDs queued?




Saturday, March 13, 2010, 12:25:38 AM, you wrote:

> On Fri, Mar 12, 2010 at 05:43:45PM +0100, Sander Eikelenboom wrote:
>> Hi Sarah,
>>=20
>> I'm trying to use an USB 1.1 device on a USB 3.0 host controller, but it=
 doesn't seem to work (tested with kernel versions up to 2.6.34-rc1):
>> - with lsusb I can only see a usb 3.0 root hub (with a USB 2.0 host cont=
roller, i'am always seeing the roothubs for lower speeds as well, so maybe =
this is the problem ?)
>> - with lsusb I can see the usb 1.1 device connected to the USB 3.0 root =
hub.
>> - the driver from the usb 1.1 device get loaded, but it gives errors, an=
d (it's a webcam) doesn't give video.
>> - the manufacturer claims it should be backwards compatible hardware.
>>=20
>> - Should this work with the current (expirimental) state of the xhci-hcd=
 driver in linux ?
>>=20
>> The hardware is (asus U3S6):
>> 03:00.0 USB Controller [0c03]: NEC Corporation Device [1033:0194] (rev 0=
3) (prog-if 30)
>>         Subsystem: ASUSTeK Computer Inc. Device [1043:8413]

> From the log files, it looks like your usb 1.1 device is a webcam; is
> that correct?

>> [    5.097306] pwc: Philips webcam module version 10.0.13 loaded.
>> [    5.097507] pwc: Supports Philips PCA645/646, PCVC675/680/690, PCVC72=
0[40]/730/740/750 & PCVC830/840.
>> [    5.097859] pwc: Also supports the Askey VC010, various Logitech Quic=
kcams, Samsung MPC-C10 and MPC-C30,
>> [    5.098215] pwc: the Creative WebCam 5 & Pro Ex, SOTEC Afina Eye and =
Visionite VCS-UC300 and VCS-UM100.
>> [    5.098557] pwc: Trace options: 0x0001
>> [    5.098576] Philips webcam 9-3:1.0: usb_probe_interface
>> [    5.098578] Philips webcam 9-3:1.0: usb_probe_interface - got id
> ...
>> [   13.116489] pwc: isoc_init() submit_urb 0 failed with error -22

> Webcams have isochronous endpoints, and the xHCI driver doesn't support
> isochronous transfers yet.  There are patches to add isochronous
> support, but they're still under going review.  They missed the 2.6.34
> merge window, so I'm not sure if they'll make it into 2.6.34 or 2.6.35.
> If you want to try them out, the latest versions of the patches are
> here:

> http://marc.info/?l=3Dlinux-usb&m=3D126838645617885&w=3D2
> http://marc.info/?l=3Dlinux-usb&m=3D126838648717923&w=3D2
> http://marc.info/?l=3Dlinux-usb&m=3D126838649217932&w=3D2

> Let me know if they work for you.

> Sarah Sharp

>> Bus 009 Device 002: ID 0471:0311 Philips PCVC740K ToUcam Pro [pwc]
>> Device Descriptor:
>>   bLength                18
>>   bDescriptorType         1
>>   bcdUSB               1.10
>>   bDeviceClass            0 (Defined at Interface level)
>>   bDeviceSubClass         0=20
>>   bDeviceProtocol         0=20
>>   bMaxPacketSize0         8
>>   idVendor           0x0471 Philips
>>   idProduct          0x0311 PCVC740K ToUcam Pro [pwc]
>>   bcdDevice            0.03
>>   iManufacturer           0=20
>>   iProduct                0=20
>>   iSerial                 1 01680000EA164101
>>   bNumConfigurations      1
>>   Configuration Descriptor:
>>     bLength                 9
>>     bDescriptorType         2
>>     wTotalLength          490
>>     bNumInterfaces          3
>>     bConfigurationValue     1
>>     iConfiguration          0=20
>>     bmAttributes         0xa0
>>       (Bus Powered)
>>       Remote Wakeup
>>     MaxPower              500mA
>>     Interface Descriptor:
>>       bLength                 9
>>       bDescriptorType         4
>>       bInterfaceNumber        0
>>       bAlternateSetting       0
>>       bNumEndpoints           2
>>       bInterfaceClass       255 Vendor Specific Class
>>       bInterfaceSubClass      0=20
>>       bInterfaceProtocol      0=20
>>       iInterface              0=20
>>       Endpoint Descriptor:
>>         bLength                 7
>>         bDescriptorType         5
>>         bEndpointAddress     0x82  EP 2 IN
>>         bmAttributes            3
>>           Transfer Type            Interrupt
>>           Synch Type               None
>>           Usage Type               Data
>>         wMaxPacketSize     0x0001  1x 1 bytes
>>         bInterval              32
>>       Endpoint Descriptor:
>>         bLength                 7
>>         bDescriptorType         5
>>         bEndpointAddress     0x85  EP 5 IN
>>         bmAttributes            1
>>           Transfer Type            Isochronous
>>           Synch Type               None
>>           Usage Type               Data
>>         wMaxPacketSize     0x0000  1x 0 bytes
>>         bInterval               1
>>     Interface Descriptor:
>>       bLength                 9
>>       bDescriptorType         4
>>       bInterfaceNumber        0
>>       bAlternateSetting       1
>>       bNumEndpoints           2
>>       bInterfaceClass       255 Vendor Specific Class
>>       bInterfaceSubClass      0=20
>>       bInterfaceProtocol      0=20
>>       iInterface              0=20
>>       Endpoint Descriptor:
>>         bLength                 7
>>         bDescriptorType         5
>>         bEndpointAddress     0x82  EP 2 IN
>>         bmAttributes            3
>>           Transfer Type            Interrupt
>>           Synch Type               None
>>           Usage Type               Data
>>         wMaxPacketSize     0x0001  1x 1 bytes
>>         bInterval              32
>>       Endpoint Descriptor:
>>         bLength                 7
>>         bDescriptorType         5
>>         bEndpointAddress     0x85  EP 5 IN
>>         bmAttributes            1
>>           Transfer Type            Isochronous
>>           Synch Type               None
>>           Usage Type               Data
>>         wMaxPacketSize     0x00c4  1x 196 bytes
>>         bInterval               1
>>     Interface Descriptor:
>>       bLength                 9
>>       bDescriptorType         4
>>       bInterfaceNumber        0
>>       bAlternateSetting       2
>>       bNumEndpoints           2
>>       bInterfaceClass       255 Vendor Specific Class
>>       bInterfaceSubClass      0=20
>>       bInterfaceProtocol      0=20
>>       iInterface              0=20
>>       Endpoint Descriptor:
>>         bLength                 7
>>         bDescriptorType         5
>>         bEndpointAddress     0x82  EP 2 IN
>>         bmAttributes            3
>>           Transfer Type            Interrupt
>>           Synch Type               None
>>           Usage Type               Data
>>         wMaxPacketSize     0x0001  1x 1 bytes
>>         bInterval              32
>>       Endpoint Descriptor:
>>         bLength                 7
>>         bDescriptorType         5
>>         bEndpointAddress     0x85  EP 5 IN
>>         bmAttributes            1
>>           Transfer Type            Isochronous
>>           Synch Type               None
>>           Usage Type               Data
>>         wMaxPacketSize     0x0124  1x 292 bytes
>>         bInterval               1
>>     Interface Descriptor:
>>       bLength                 9
>>       bDescriptorType         4
>>       bInterfaceNumber        0
>>       bAlternateSetting       3
>>       bNumEndpoints           2
>>       bInterfaceClass       255 Vendor Specific Class
>>       bInterfaceSubClass      0=20
>>       bInterfaceProtocol      0=20
>>       iInterface              0=20
>>       Endpoint Descriptor:
>>         bLength                 7
>>         bDescriptorType         5
>>         bEndpointAddress     0x82  EP 2 IN
>>         bmAttributes            3
>>           Transfer Type            Interrupt
>>           Synch Type               None
>>           Usage Type               Data
>>         wMaxPacketSize     0x0001  1x 1 bytes
>>         bInterval              32
>>       Endpoint Descriptor:
>>         bLength                 7
>>         bDescriptorType         5
>>         bEndpointAddress     0x85  EP 5 IN
>>         bmAttributes            1
>>           Transfer Type            Isochronous
>>           Synch Type               None
>>           Usage Type               Data
>>         wMaxPacketSize     0x01c0  1x 448 bytes
>>         bInterval               1
>>     Interface Descriptor:
>>       bLength                 9
>>       bDescriptorType         4
>>       bInterfaceNumber        0
>>       bAlternateSetting       4
>>       bNumEndpoints           2
>>       bInterfaceClass       255 Vendor Specific Class
>>       bInterfaceSubClass      0=20
>>       bInterfaceProtocol      0=20
>>       iInterface              0=20
>>       Endpoint Descriptor:
>>         bLength                 7
>>         bDescriptorType         5
>>         bEndpointAddress     0x82  EP 2 IN
>>         bmAttributes            3
>>           Transfer Type            Interrupt
>>           Synch Type               None
>>           Usage Type               Data
>>         wMaxPacketSize     0x0001  1x 1 bytes
>>         bInterval              32
>>       Endpoint Descriptor:
>>         bLength                 7
>>         bDescriptorType         5
>>         bEndpointAddress     0x85  EP 5 IN
>>         bmAttributes            1
>>           Transfer Type            Isochronous
>>           Synch Type               None
>>           Usage Type               Data
>>         wMaxPacketSize     0x0250  1x 592 bytes
>>         bInterval               1
>>     Interface Descriptor:
>>       bLength                 9
>>       bDescriptorType         4
>>       bInterfaceNumber        0
>>       bAlternateSetting       5
>>       bNumEndpoints           2
>>       bInterfaceClass       255 Vendor Specific Class
>>       bInterfaceSubClass      0=20
>>       bInterfaceProtocol      0=20
>>       iInterface              0=20
>>       Endpoint Descriptor:
>>         bLength                 7
>>         bDescriptorType         5
>>         bEndpointAddress     0x82  EP 2 IN
>>         bmAttributes            3
>>           Transfer Type            Interrupt
>>           Synch Type               None
>>           Usage Type               Data
>>         wMaxPacketSize     0x0001  1x 1 bytes
>>         bInterval              32
>>       Endpoint Descriptor:
>>         bLength                 7
>>         bDescriptorType         5
>>         bEndpointAddress     0x85  EP 5 IN
>>         bmAttributes            1
>>           Transfer Type            Isochronous
>>           Synch Type               None
>>           Usage Type               Data
>>         wMaxPacketSize     0x02c0  1x 704 bytes
>>         bInterval               1
>>     Interface Descriptor:
>>       bLength                 9
>>       bDescriptorType         4
>>       bInterfaceNumber        0
>>       bAlternateSetting       6
>>       bNumEndpoints           2
>>       bInterfaceClass       255 Vendor Specific Class
>>       bInterfaceSubClass      0=20
>>       bInterfaceProtocol      0=20
>>       iInterface              0=20
>>       Endpoint Descriptor:
>>         bLength                 7
>>         bDescriptorType         5
>>         bEndpointAddress     0x82  EP 2 IN
>>         bmAttributes            3
>>           Transfer Type            Interrupt
>>           Synch Type               None
>>           Usage Type               Data
>>         wMaxPacketSize     0x0001  1x 1 bytes
>>         bInterval              32
>>       Endpoint Descriptor:
>>         bLength                 7
>>         bDescriptorType         5
>>         bEndpointAddress     0x85  EP 5 IN
>>         bmAttributes            1
>>           Transfer Type            Isochronous
>>           Synch Type               None
>>           Usage Type               Data
>>         wMaxPacketSize     0x0308  1x 776 bytes
>>         bInterval               1
>>     Interface Descriptor:
>>       bLength                 9
>>       bDescriptorType         4
>>       bInterfaceNumber        0
>>       bAlternateSetting       7
>>       bNumEndpoints           2
>>       bInterfaceClass       255 Vendor Specific Class
>>       bInterfaceSubClass      0=20
>>       bInterfaceProtocol      0=20
>>       iInterface              0=20
>>       Endpoint Descriptor:
>>         bLength                 7
>>         bDescriptorType         5
>>         bEndpointAddress     0x82  EP 2 IN
>>         bmAttributes            3
>>           Transfer Type            Interrupt
>>           Synch Type               None
>>           Usage Type               Data
>>         wMaxPacketSize     0x0001  1x 1 bytes
>>         bInterval              32
>>       Endpoint Descriptor:
>>         bLength                 7
>>         bDescriptorType         5
>>         bEndpointAddress     0x85  EP 5 IN
>>         bmAttributes            1
>>           Transfer Type            Isochronous
>>           Synch Type               None
>>           Usage Type               Data
>>         wMaxPacketSize     0x0348  1x 840 bytes
>>         bInterval               1
>>     Interface Descriptor:
>>       bLength                 9
>>       bDescriptorType         4
>>       bInterfaceNumber        0
>>       bAlternateSetting       8
>>       bNumEndpoints           2
>>       bInterfaceClass       255 Vendor Specific Class
>>       bInterfaceSubClass      0=20
>>       bInterfaceProtocol      0=20
>>       iInterface              0=20
>>       Endpoint Descriptor:
>>         bLength                 7
>>         bDescriptorType         5
>>         bEndpointAddress     0x82  EP 2 IN
>>         bmAttributes            3
>>           Transfer Type            Interrupt
>>           Synch Type               None
>>           Usage Type               Data
>>         wMaxPacketSize     0x0001  1x 1 bytes
>>         bInterval              32
>>       Endpoint Descriptor:
>>         bLength                 7
>>         bDescriptorType         5
>>         bEndpointAddress     0x85  EP 5 IN
>>         bmAttributes            1
>>           Transfer Type            Isochronous
>>           Synch Type               None
>>           Usage Type               Data
>>         wMaxPacketSize     0x0380  1x 896 bytes
>>         bInterval               1
>>     Interface Descriptor:
>>       bLength                 9
>>       bDescriptorType         4
>>       bInterfaceNumber        0
>>       bAlternateSetting       9
>>       bNumEndpoints           2
>>       bInterfaceClass       255 Vendor Specific Class
>>       bInterfaceSubClass      0=20
>>       bInterfaceProtocol      0=20
>>       iInterface              0=20
>>       Endpoint Descriptor:
>>         bLength                 7
>>         bDescriptorType         5
>>         bEndpointAddress     0x82  EP 2 IN
>>         bmAttributes            3
>>           Transfer Type            Interrupt
>>           Synch Type               None
>>           Usage Type               Data
>>         wMaxPacketSize     0x0001  1x 1 bytes
>>         bInterval              32
>>       Endpoint Descriptor:
>>         bLength                 7
>>         bDescriptorType         5
>>         bEndpointAddress     0x85  EP 5 IN
>>         bmAttributes            1
>>           Transfer Type            Isochronous
>>           Synch Type               None
>>           Usage Type               Data
>>         wMaxPacketSize     0x03c0  1x 960 bytes
>>         bInterval               1
>>     Interface Descriptor:
>>       bLength                 9
>>       bDescriptorType         4
>>       bInterfaceNumber        0
>>       bAlternateSetting      10
>>       bNumEndpoints           2
>>       bInterfaceClass       255 Vendor Specific Class
>>       bInterfaceSubClass      0=20
>>       bInterfaceProtocol      0=20
>>       iInterface              0=20
>>       Endpoint Descriptor:
>>         bLength                 7
>>         bDescriptorType         5
>>         bEndpointAddress     0x82  EP 2 IN
>>         bmAttributes            3
>>           Transfer Type            Interrupt
>>           Synch Type               None
>>           Usage Type               Data
>>         wMaxPacketSize     0x0001  1x 1 bytes
>>         bInterval              32
>>       Endpoint Descriptor:
>>         bLength                 7
>>         bDescriptorType         5
>>         bEndpointAddress     0x85  EP 5 IN
>>         bmAttributes            1
>>           Transfer Type            Isochronous
>>           Synch Type               None
>>           Usage Type               Data
>>         wMaxPacketSize     0x03c0  1x 960 bytes
>>         bInterval               1
>>     Interface Descriptor:
>>       bLength                 9
>>       bDescriptorType         4
>>       bInterfaceNumber        1
>>       bAlternateSetting       0
>>       bNumEndpoints           0
>>       bInterfaceClass         1 Audio
>>       bInterfaceSubClass      1 Control Device
>>       bInterfaceProtocol      0=20
>>       iInterface              0=20
>>       AudioControl Interface Descriptor:
>>         bLength                 9
>>         bDescriptorType        36
>>         bDescriptorSubtype      1 (HEADER)
>>         bcdADC               1.00
>>         wTotalLength           38
>>         bInCollection           1
>>         baInterfaceNr( 0)       2
>>       AudioControl Interface Descriptor:
>>         bLength                12
>>         bDescriptorType        36
>>         bDescriptorSubtype      2 (INPUT_TERMINAL)
>>         bTerminalID             1
>>         wTerminalType      0x0201 Microphone
>>         bAssocTerminal          0
>>         bNrChannels             1
>>         wChannelConfig     0x0000
>>         iChannelNames           0=20
>>         iTerminal               0=20
>>       AudioControl Interface Descriptor:
>>         bLength                 8
>>         bDescriptorType        36
>>         bDescriptorSubtype      6 (FEATURE_UNIT)
>>         bUnitID                 2
>>         bSourceID               1
>>         bControlSize            1
>>         bmaControls( 0)      0x03
>>           Mute
>>           Volume
>>         iFeature                0=20
>>       AudioControl Interface Descriptor:
>>         bLength                 9
>>         bDescriptorType        36
>>         bDescriptorSubtype      3 (OUTPUT_TERMINAL)
>>         bTerminalID             3
>>         wTerminalType      0x0101 USB Streaming
>>         bAssocTerminal          0
>>         bSourceID               2
>>         iTerminal               0=20
>>     Interface Descriptor:
>>       bLength                 9
>>       bDescriptorType         4
>>       bInterfaceNumber        2
>>       bAlternateSetting       0
>>       bNumEndpoints           0
>>       bInterfaceClass         1 Audio
>>       bInterfaceSubClass      2 Streaming
>>       bInterfaceProtocol      0=20
>>       iInterface              0=20
>>     Interface Descriptor:
>>       bLength                 9
>>       bDescriptorType         4
>>       bInterfaceNumber        2
>>       bAlternateSetting       1
>>       bNumEndpoints           1
>>       bInterfaceClass         1 Audio
>>       bInterfaceSubClass      2 Streaming
>>       bInterfaceProtocol      0=20
>>       iInterface              0=20
>>       AudioStreaming Interface Descriptor:
>>         bLength                 7
>>         bDescriptorType        36
>>         bDescriptorSubtype      1 (AS_GENERAL)
>>         bTerminalLink           3
>>         bDelay                  1 frames
>>         wFormatTag              1 PCM
>>       AudioStreaming Interface Descriptor:
>>         bLength                11
>>         bDescriptorType        36
>>         bDescriptorSubtype      2 (FORMAT_TYPE)
>>         bFormatType             1 (FORMAT_TYPE_I)
>>         bNrChannels             1
>>         bSubframeSize           2
>>         bBitResolution         16
>>         bSamFreqType            1 Discrete
>>         tSamFreq[ 0]        44100
>>       Endpoint Descriptor:
>>         bLength                 9
>>         bDescriptorType         5
>>         bEndpointAddress     0x84  EP 4 IN
>>         bmAttributes            1
>>           Transfer Type            Isochronous
>>           Synch Type               None
>>           Usage Type               Data
>>         wMaxPacketSize     0x005a  1x 90 bytes
>>         bInterval               1
>>         bRefresh                0
>>         bSynchAddress           0
>>         AudioControl Endpoint Descriptor:
>>           bLength                 7
>>           bDescriptorType        37
>>           bDescriptorSubtype      1 (EP_GENERAL)
>>           bmAttributes         0x00
>>           bLockDelayUnits         0 Undefined
>>           wLockDelay              0 Undefined
>>     Interface Descriptor:
>>       bLength                 9
>>       bDescriptorType         4
>>       bInterfaceNumber        2
>>       bAlternateSetting       2
>>       bNumEndpoints           1
>>       bInterfaceClass         1 Audio
>>       bInterfaceSubClass      2 Streaming
>>       bInterfaceProtocol      0=20
>>       iInterface              0=20
>>       AudioStreaming Interface Descriptor:
>>         bLength                 7
>>         bDescriptorType        36
>>         bDescriptorSubtype      1 (AS_GENERAL)
>>         bTerminalLink           3
>>         bDelay                  1 frames
>>         wFormatTag              1 PCM
>>       AudioStreaming Interface Descriptor:
>>         bLength                11
>>         bDescriptorType        36
>>         bDescriptorSubtype      2 (FORMAT_TYPE)
>>         bFormatType             1 (FORMAT_TYPE_I)
>>         bNrChannels             1
>>         bSubframeSize           2
>>         bBitResolution         16
>>         bSamFreqType            1 Discrete
>>         tSamFreq[ 0]        22050
>>       Endpoint Descriptor:
>>         bLength                 9
>>         bDescriptorType         5
>>         bEndpointAddress     0x84  EP 4 IN
>>         bmAttributes            1
>>           Transfer Type            Isochronous
>>           Synch Type               None
>>           Usage Type               Data
>>         wMaxPacketSize     0x002e  1x 46 bytes
>>         bInterval               1
>>         bRefresh                0
>>         bSynchAddress           0
>>         AudioControl Endpoint Descriptor:
>>           bLength                 7
>>           bDescriptorType        37
>>           bDescriptorSubtype      1 (EP_GENERAL)
>>           bmAttributes         0x00
>>           bLockDelayUnits         0 Undefined
>>           wLockDelay              0 Undefined
>>     Interface Descriptor:
>>       bLength                 9
>>       bDescriptorType         4
>>       bInterfaceNumber        2
>>       bAlternateSetting       3
>>       bNumEndpoints           1
>>       bInterfaceClass         1 Audio
>>       bInterfaceSubClass      2 Streaming
>>       bInterfaceProtocol      0=20
>>       iInterface              0=20
>>       AudioStreaming Interface Descriptor:
>>         bLength                 7
>>         bDescriptorType        36
>>         bDescriptorSubtype      1 (AS_GENERAL)
>>         bTerminalLink           3
>>         bDelay                  1 frames
>>         wFormatTag              1 PCM
>>       AudioStreaming Interface Descriptor:
>>         bLength                11
>>         bDescriptorType        36
>>         bDescriptorSubtype      2 (FORMAT_TYPE)
>>         bFormatType             1 (FORMAT_TYPE_I)
>>         bNrChannels             1
>>         bSubframeSize           2
>>         bBitResolution         16
>>         bSamFreqType            1 Discrete
>>         tSamFreq[ 0]        11025
>>       Endpoint Descriptor:
>>         bLength                 9
>>         bDescriptorType         5
>>         bEndpointAddress     0x84  EP 4 IN
>>         bmAttributes            1
>>           Transfer Type            Isochronous
>>           Synch Type               None
>>           Usage Type               Data
>>         wMaxPacketSize     0x0019  1x 25 bytes
>>         bInterval               1
>>         bRefresh                0
>>         bSynchAddress           0
>>         AudioControl Endpoint Descriptor:
>>           bLength                 7
>>           bDescriptorType        37
>>           bDescriptorSubtype      1 (EP_GENERAL)
>>           bmAttributes         0x00
>>           bLockDelayUnits         0 Undefined
>>           wLockDelay              0 Undefined
>>     Interface Descriptor:
>>       bLength                 9
>>       bDescriptorType         4
>>       bInterfaceNumber        2
>>       bAlternateSetting       4
>>       bNumEndpoints           1
>>       bInterfaceClass         1 Audio
>>       bInterfaceSubClass      2 Streaming
>>       bInterfaceProtocol      0=20
>>       iInterface              0=20
>>       AudioStreaming Interface Descriptor:
>>         bLength                 7
>>         bDescriptorType        36
>>         bDescriptorSubtype      1 (AS_GENERAL)
>>         bTerminalLink           3
>>         bDelay                  1 frames
>>         wFormatTag              1 PCM
>>       AudioStreaming Interface Descriptor:
>>         bLength                11
>>         bDescriptorType        36
>>         bDescriptorSubtype      2 (FORMAT_TYPE)
>>         bFormatType             1 (FORMAT_TYPE_I)
>>         bNrChannels             1
>>         bSubframeSize           2
>>         bBitResolution         16
>>         bSamFreqType            1 Discrete
>>         tSamFreq[ 0]         8000
>>       Endpoint Descriptor:
>>         bLength                 9
>>         bDescriptorType         5
>>         bEndpointAddress     0x84  EP 4 IN
>>         bmAttributes            1
>>           Transfer Type            Isochronous
>>           Synch Type               None
>>           Usage Type               Data
>>         wMaxPacketSize     0x0010  1x 16 bytes
>>         bInterval               1
>>         bRefresh                0
>>         bSynchAddress           0
>>         AudioControl Endpoint Descriptor:
>>           bLength                 7
>>           bDescriptorType        37
>>           bDescriptorSubtype      1 (EP_GENERAL)
>>           bmAttributes         0x00
>>           bLockDelayUnits         0 Undefined
>>           wLockDelay              0 Undefined
>> Device Status:     0x0002
>>   (Bus Powered)
>>   Remote Wakeup Enabled
>>=20
>> Bus 009 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
>> Device Descriptor:
>>   bLength                18
>>   bDescriptorType         1
>>   bcdUSB               3.00
>>   bDeviceClass            9 Hub
>>   bDeviceSubClass         0 Unused
>>   bDeviceProtocol         3=20
>>   bMaxPacketSize0         9
>>   idVendor           0x1d6b Linux Foundation
>>   idProduct          0x0003 3.0 root hub
>>   bcdDevice            2.06
>>   iManufacturer           3 Linux 2.6.34-rc1 xhci_hcd
>>   iProduct                2 xHCI Host Controller
>>   iSerial                 1 0000:03:00.0
>>   bNumConfigurations      1
>>   Configuration Descriptor:
>>     bLength                 9
>>     bDescriptorType         2
>>     wTotalLength           25
>>     bNumInterfaces          1
>>     bConfigurationValue     1
>>     iConfiguration          0=20
>>     bmAttributes         0xe0
>>       Self Powered
>>       Remote Wakeup
>>     MaxPower                0mA
>>     Interface Descriptor:
>>       bLength                 9
>>       bDescriptorType         4
>>       bInterfaceNumber        0
>>       bAlternateSetting       0
>>       bNumEndpoints           1
>>       bInterfaceClass         9 Hub
>>       bInterfaceSubClass      0 Unused
>>       bInterfaceProtocol      0 Full speed (or root) hub
>>       iInterface              0=20
>>       Endpoint Descriptor:
>>         bLength                 7
>>         bDescriptorType         5
>>         bEndpointAddress     0x81  EP 1 IN
>>         bmAttributes            3
>>           Transfer Type            Interrupt
>>           Synch Type               None
>>           Usage Type               Data
>>         wMaxPacketSize     0x0004  1x 4 bytes
>>         bInterval              12
>> Hub Descriptor:
>>   bLength               9
>>   bDescriptorType      41
>>   nNbrPorts             4
>>   wHubCharacteristic 0x0009
>>     Per-port power switching
>>     Per-port overcurrent protection
>>     TT think time 8 FS bits
>>   bPwrOn2PwrGood       10 * 2 milli seconds
>>   bHubContrCurrent      0 milli Ampere
>>   DeviceRemovable    0x00
>>   PortPwrCtrlMask    0xff
>>  Hub Port Status:
>>    Port 1: 0000.0100 power
>>    Port 2: 0000.0100 power
>>    Port 3: 0000.0103 power enable connect
>>    Port 4: 0000.0100 power
>> Device Status:     0x0003
>>   Self Powered
>>   Remote Wakeup Enabled




--=20
Best regards,
 Sander                            mailto:linux@eikelenboom.it
------------110125428278FB3
Content-Type: text/plain;
 name="dmesg-with-patch.txt"
Content-transfer-encoding: base64
Content-Disposition: attachment;
 filename="dmesg-with-patch.txt"

WyAgICAwLjAwMDAwMF0gSW5pdGlhbGl6aW5nIGNncm91cCBzdWJzeXMgY3B1c2V0DQpbICAg
IDAuMDAwMDAwXSBJbml0aWFsaXppbmcgY2dyb3VwIHN1YnN5cyBjcHUNClsgICAgMC4wMDAw
MDBdIExpbnV4IHZlcnNpb24gMi42LjM0LXJjMSAocm9vdEB4ZW50ZXN0KSAoZ2NjIHZlcnNp
b24gNC4zLjIgKERlYmlhbiA0LjMuMi0xLjEpICkgIzMgU01QIFNhdCBNYXIgMTMgMDM6NTE6
MDIgQ0VUIDIwMTANClsgICAgMC4wMDAwMDBdIENvbW1hbmQgbGluZTogcm9vdD0vZGV2L3Nk
YTEgcm8gY29uc29sZT10dHkwDQpbICAgIDAuMDAwMDAwXSBCSU9TLXByb3ZpZGVkIHBoeXNp
Y2FsIFJBTSBtYXA6DQpbICAgIDAuMDAwMDAwXSAgQklPUy1lODIwOiAwMDAwMDAwMDAwMDAw
MDAwIC0gMDAwMDAwMDAwMDA5ZjQwMCAodXNhYmxlKQ0KWyAgICAwLjAwMDAwMF0gIEJJT1Mt
ZTgyMDogMDAwMDAwMDAwMDA5ZjQwMCAtIDAwMDAwMDAwMDAwYTAwMDAgKHJlc2VydmVkKQ0K
WyAgICAwLjAwMDAwMF0gIEJJT1MtZTgyMDogMDAwMDAwMDAwMDBlNDAwMCAtIDAwMDAwMDAw
MDAxMDAwMDAgKHJlc2VydmVkKQ0KWyAgICAwLjAwMDAwMF0gIEJJT1MtZTgyMDogMDAwMDAw
MDAwMDEwMDAwMCAtIDAwMDAwMDAwN2NiNzAwMDAgKHVzYWJsZSkNClsgICAgMC4wMDAwMDBd
ICBCSU9TLWU4MjA6IDAwMDAwMDAwN2NiNzAwMDAgLSAwMDAwMDAwMDdjYjdlMDAwIChBQ1BJ
IGRhdGEpDQpbICAgIDAuMDAwMDAwXSAgQklPUy1lODIwOiAwMDAwMDAwMDdjYjdlMDAwIC0g
MDAwMDAwMDA3Y2JkMDAwMCAoQUNQSSBOVlMpDQpbICAgIDAuMDAwMDAwXSAgQklPUy1lODIw
OiAwMDAwMDAwMDdjYmQwMDAwIC0gMDAwMDAwMDA3Y2MwMDAwMCAocmVzZXJ2ZWQpDQpbICAg
IDAuMDAwMDAwXSAgQklPUy1lODIwOiAwMDAwMDAwMGZlZDAwMDAwIC0gMDAwMDAwMDBmZWQw
MTEwMCAocmVzZXJ2ZWQpDQpbICAgIDAuMDAwMDAwXSAgQklPUy1lODIwOiAwMDAwMDAwMGZl
ZDAyMDAwIC0gMDAwMDAwMDBmZWQxNGMwMCAocmVzZXJ2ZWQpDQpbICAgIDAuMDAwMDAwXSAg
QklPUy1lODIwOiAwMDAwMDAwMGZlZDIwMDAwIC0gMDAwMDAwMDBmZWQ0MDAwMCAocmVzZXJ2
ZWQpDQpbICAgIDAuMDAwMDAwXSAgQklPUy1lODIwOiAwMDAwMDAwMGZlZTAwMDAwIC0gMDAw
MDAwMDBmZWUwMTAwMCAocmVzZXJ2ZWQpDQpbICAgIDAuMDAwMDAwXSAgQklPUy1lODIwOiAw
MDAwMDAwMGZmZTAwMDAwIC0gMDAwMDAwMDEwMDAwMDAwMCAocmVzZXJ2ZWQpDQpbICAgIDAu
MDAwMDAwXSBOWCAoRXhlY3V0ZSBEaXNhYmxlKSBwcm90ZWN0aW9uOiBhY3RpdmUNClsgICAg
MC4wMDAwMDBdIERNSSBwcmVzZW50Lg0KWyAgICAwLjAwMDAwMF0gQU1JIEJJT1MgZGV0ZWN0
ZWQ6IEJJT1MgbWF5IGNvcnJ1cHQgbG93IFJBTSwgd29ya2luZyBhcm91bmQgaXQuDQpbICAg
IDAuMDAwMDAwXSBlODIwIHVwZGF0ZSByYW5nZTogMDAwMDAwMDAwMDAwMDAwMCAtIDAwMDAw
MDAwMDAwMTAwMDAgKHVzYWJsZSkgPT0+IChyZXNlcnZlZCkNClsgICAgMC4wMDAwMDBdIGU4
MjAgdXBkYXRlIHJhbmdlOiAwMDAwMDAwMDAwMDAwMDAwIC0gMDAwMDAwMDAwMDAwMTAwMCAo
dXNhYmxlKSA9PT4gKHJlc2VydmVkKQ0KWyAgICAwLjAwMDAwMF0gZTgyMCByZW1vdmUgcmFu
Z2U6IDAwMDAwMDAwMDAwYTAwMDAgLSAwMDAwMDAwMDAwMTAwMDAwICh1c2FibGUpDQpbICAg
IDAuMDAwMDAwXSBObyBBR1AgYnJpZGdlIGZvdW5kDQpbICAgIDAuMDAwMDAwXSBsYXN0X3Bm
biA9IDB4N2NiNzAgbWF4X2FyY2hfcGZuID0gMHg0MDAwMDAwMDANClsgICAgMC4wMDAwMDBd
IE1UUlIgZGVmYXVsdCB0eXBlOiB1bmNhY2hhYmxlDQpbICAgIDAuMDAwMDAwXSBNVFJSIGZp
eGVkIHJhbmdlcyBlbmFibGVkOg0KWyAgICAwLjAwMDAwMF0gICAwMDAwMC05RkZGRiB3cml0
ZS1iYWNrDQpbICAgIDAuMDAwMDAwXSAgIEEwMDAwLUJGRkZGIHVuY2FjaGFibGUNClsgICAg
MC4wMDAwMDBdICAgQzAwMDAtQ0JGRkYgd3JpdGUtcHJvdGVjdA0KWyAgICAwLjAwMDAwMF0g
ICBDQzAwMC1ERkZGRiB1bmNhY2hhYmxlDQpbICAgIDAuMDAwMDAwXSAgIEUwMDAwLUVGRkZG
IHdyaXRlLXRocm91Z2gNClsgICAgMC4wMDAwMDBdICAgRjAwMDAtRkZGRkYgd3JpdGUtcHJv
dGVjdA0KWyAgICAwLjAwMDAwMF0gTVRSUiB2YXJpYWJsZSByYW5nZXMgZW5hYmxlZDoNClsg
ICAgMC4wMDAwMDBdICAgMCBiYXNlIDAwMDAwMDAwMCBtYXNrIEY4MDAwMDAwMCB3cml0ZS1i
YWNrDQpbICAgIDAuMDAwMDAwXSAgIDEgYmFzZSAwN0NDMDAwMDAgbWFzayBGRkZDMDAwMDAg
dW5jYWNoYWJsZQ0KWyAgICAwLjAwMDAwMF0gICAyIGJhc2UgMDdEMDAwMDAwIG1hc2sgRkZG
MDAwMDAwIHVuY2FjaGFibGUNClsgICAgMC4wMDAwMDBdICAgMyBiYXNlIDA3RTAwMDAwMCBt
YXNrIEZGRTAwMDAwMCB1bmNhY2hhYmxlDQpbICAgIDAuMDAwMDAwXSAgIDQgZGlzYWJsZWQN
ClsgICAgMC4wMDAwMDBdICAgNSBkaXNhYmxlZA0KWyAgICAwLjAwMDAwMF0gICA2IGRpc2Fi
bGVkDQpbICAgIDAuMDAwMDAwXSAgIDcgZGlzYWJsZWQNClsgICAgMC4wMDAwMDBdIHg4NiBQ
QVQgZW5hYmxlZDogY3B1IDAsIG9sZCAweDcwNDA2MDAwNzA0MDYsIG5ldyAweDcwMTA2MDAw
NzAxMDYNClsgICAgMC4wMDAwMDBdIFNjYW5uaW5nIDAgYXJlYXMgZm9yIGxvdyBtZW1vcnkg
Y29ycnVwdGlvbg0KWyAgICAwLjAwMDAwMF0gbW9kaWZpZWQgcGh5c2ljYWwgUkFNIG1hcDoN
ClsgICAgMC4wMDAwMDBdICBtb2RpZmllZDogMDAwMDAwMDAwMDAwMDAwMCAtIDAwMDAwMDAw
MDAwMTAwMDAgKHJlc2VydmVkKQ0KWyAgICAwLjAwMDAwMF0gIG1vZGlmaWVkOiAwMDAwMDAw
MDAwMDEwMDAwIC0gMDAwMDAwMDAwMDA5ZjQwMCAodXNhYmxlKQ0KWyAgICAwLjAwMDAwMF0g
IG1vZGlmaWVkOiAwMDAwMDAwMDAwMDlmNDAwIC0gMDAwMDAwMDAwMDBhMDAwMCAocmVzZXJ2
ZWQpDQpbICAgIDAuMDAwMDAwXSAgbW9kaWZpZWQ6IDAwMDAwMDAwMDAwZTQwMDAgLSAwMDAw
MDAwMDAwMTAwMDAwIChyZXNlcnZlZCkNClsgICAgMC4wMDAwMDBdICBtb2RpZmllZDogMDAw
MDAwMDAwMDEwMDAwMCAtIDAwMDAwMDAwN2NiNzAwMDAgKHVzYWJsZSkNClsgICAgMC4wMDAw
MDBdICBtb2RpZmllZDogMDAwMDAwMDA3Y2I3MDAwMCAtIDAwMDAwMDAwN2NiN2UwMDAgKEFD
UEkgZGF0YSkNClsgICAgMC4wMDAwMDBdICBtb2RpZmllZDogMDAwMDAwMDA3Y2I3ZTAwMCAt
IDAwMDAwMDAwN2NiZDAwMDAgKEFDUEkgTlZTKQ0KWyAgICAwLjAwMDAwMF0gIG1vZGlmaWVk
OiAwMDAwMDAwMDdjYmQwMDAwIC0gMDAwMDAwMDA3Y2MwMDAwMCAocmVzZXJ2ZWQpDQpbICAg
IDAuMDAwMDAwXSAgbW9kaWZpZWQ6IDAwMDAwMDAwZmVkMDAwMDAgLSAwMDAwMDAwMGZlZDAx
MTAwIChyZXNlcnZlZCkNClsgICAgMC4wMDAwMDBdICBtb2RpZmllZDogMDAwMDAwMDBmZWQw
MjAwMCAtIDAwMDAwMDAwZmVkMTRjMDAgKHJlc2VydmVkKQ0KWyAgICAwLjAwMDAwMF0gIG1v
ZGlmaWVkOiAwMDAwMDAwMGZlZDIwMDAwIC0gMDAwMDAwMDBmZWQ0MDAwMCAocmVzZXJ2ZWQp
DQpbICAgIDAuMDAwMDAwXSAgbW9kaWZpZWQ6IDAwMDAwMDAwZmVlMDAwMDAgLSAwMDAwMDAw
MGZlZTAxMDAwIChyZXNlcnZlZCkNClsgICAgMC4wMDAwMDBdICBtb2RpZmllZDogMDAwMDAw
MDBmZmUwMDAwMCAtIDAwMDAwMDAxMDAwMDAwMDAgKHJlc2VydmVkKQ0KWyAgICAwLjAwMDAw
MF0gaW5pdGlhbCBtZW1vcnkgbWFwcGVkIDogMCAtIDIwMDAwMDAwDQpbICAgIDAuMDAwMDAw
XSBmb3VuZCBTTVAgTVAtdGFibGUgYXQgW2ZmZmY4ODAwMDAwZmY3ODBdIGZmNzgwDQpbICAg
IDAuMDAwMDAwXSBpbml0X21lbW9yeV9tYXBwaW5nOiAwMDAwMDAwMDAwMDAwMDAwLTAwMDAw
MDAwN2NiNzAwMDANClsgICAgMC4wMDAwMDBdICAwMDAwMDAwMDAwIC0gMDA3Y2EwMDAwMCBw
YWdlIDJNDQpbICAgIDAuMDAwMDAwXSAgMDA3Y2EwMDAwMCAtIDAwN2NiNzAwMDAgcGFnZSA0
aw0KWyAgICAwLjAwMDAwMF0ga2VybmVsIGRpcmVjdCBtYXBwaW5nIHRhYmxlcyB1cCB0byA3
Y2I3MDAwMCBAIDE2MDAwLTFhMDAwDQpbICAgIDAuMDAwMDAwXSBSQU1ESVNLOiAzN2NlNDAw
MCAtIDM3ZmVmMGY4DQpbICAgIDAuMDAwMDAwXSBBQ1BJOiBSU0RQIDAwMDAwMDAwMDAwZmIw
ODAgMDAwMjQgKHYwMiBBQ1BJQU0pDQpbICAgIDAuMDAwMDAwXSBBQ1BJOiBYU0RUIDAwMDAw
MDAwN2NiNzAxMDAgMDAwNjQgKHYwMSBBX01fSV8gT0VNWFNEVCAgMDUwMDA5MjcgTVNGVCAw
MDAwMDA5NykNClsgICAgMC4wMDAwMDBdIEFDUEk6IEZBQ1AgMDAwMDAwMDA3Y2I3MDI5MCAw
MDBGNCAodjAzIEFfTV9JXyBPRU1GQUNQICAwNTAwMDkyNyBNU0ZUIDAwMDAwMDk3KQ0KWyAg
ICAwLjAwMDAwMF0gQUNQSTogRFNEVCAwMDAwMDAwMDdjYjcwNDQwIDA4NDFGICh2MDEgIEEx
MDY1IEExMDY1MDAwIDAwMDAwMDAwIElOVEwgMjAwNjAxMTMpDQpbICAgIDAuMDAwMDAwXSBB
Q1BJOiBGQUNTIDAwMDAwMDAwN2NiN2UwMDAgMDAwNDANClsgICAgMC4wMDAwMDBdIEFDUEk6
IEFQSUMgMDAwMDAwMDA3Y2I3MDM5MCAwMDA2QyAodjAxIEFfTV9JXyBPRU1BUElDICAwNTAw
MDkyNyBNU0ZUIDAwMDAwMDk3KQ0KWyAgICAwLjAwMDAwMF0gQUNQSTogTUNGRyAwMDAwMDAw
MDdjYjcwNDAwIDAwMDNDICh2MDEgQV9NX0lfIE9FTU1DRkcgIDA1MDAwOTI3IE1TRlQgMDAw
MDAwOTcpDQpbICAgIDAuMDAwMDAwXSBBQ1BJOiBPRU1CIDAwMDAwMDAwN2NiN2UwNDAgMDAw
ODkgKHYwMSBBX01fSV8gQU1JX09FTSAgMDUwMDA5MjcgTVNGVCAwMDAwMDA5NykNClsgICAg
MC4wMDAwMDBdIEFDUEk6IEhQRVQgMDAwMDAwMDA3Y2I3ODg2MCAwMDAzOCAodjAxIEFfTV9J
XyBPRU1IUEVUICAwNTAwMDkyNyBNU0ZUIDAwMDAwMDk3KQ0KWyAgICAwLjAwMDAwMF0gQUNQ
STogR1NDSSAwMDAwMDAwMDdjYjdlMGQwIDAyMDI0ICh2MDEgQV9NX0lfIEdNQ0hTQ0kgIDA1
MDAwOTI3IE1TRlQgMDAwMDAwOTcpDQpbICAgIDAuMDAwMDAwXSBBQ1BJOiBETUFSIDAwMDAw
MDAwN2NiODAxMDAgMDAxNTggKHYwMSAgICBBTUkgIE9FTURNQVIgMDAwMDAwMDEgTVNGVCAw
MDAwMDA5NykNClsgICAgMC4wMDAwMDBdIEFDUEk6IFNTRFQgMDAwMDAwMDA3Y2I4MTFkMCAw
MEE3QyAodjAxIERwZ1BtbSAgICBDcHVQbSAwMDAwMDAxMiBJTlRMIDIwMDYwMTEzKQ0KWyAg
ICAwLjAwMDAwMF0gQUNQSTogTG9jYWwgQVBJQyBhZGRyZXNzIDB4ZmVlMDAwMDANClsgICAg
MC4wMDAwMDBdIFpvbmUgUEZOIHJhbmdlczoNClsgICAgMC4wMDAwMDBdICAgRE1BICAgICAg
MHgwMDAwMDAxMCAtPiAweDAwMDAxMDAwDQpbICAgIDAuMDAwMDAwXSAgIERNQTMyICAgIDB4
MDAwMDEwMDAgLT4gMHgwMDEwMDAwMA0KWyAgICAwLjAwMDAwMF0gICBOb3JtYWwgICBlbXB0
eQ0KWyAgICAwLjAwMDAwMF0gTW92YWJsZSB6b25lIHN0YXJ0IFBGTiBmb3IgZWFjaCBub2Rl
DQpbICAgIDAuMDAwMDAwXSBlYXJseV9ub2RlX21hcFsyXSBhY3RpdmUgUEZOIHJhbmdlcw0K
WyAgICAwLjAwMDAwMF0gICAgIDA6IDB4MDAwMDAwMTAgLT4gMHgwMDAwMDA5Zg0KWyAgICAw
LjAwMDAwMF0gICAgIDA6IDB4MDAwMDAxMDAgLT4gMHgwMDA3Y2I3MA0KWyAgICAwLjAwMDAw
MF0gT24gbm9kZSAwIHRvdGFscGFnZXM6IDUxMDcxOQ0KWyAgICAwLjAwMDAwMF0gICBETUEg
em9uZTogNTYgcGFnZXMgdXNlZCBmb3IgbWVtbWFwDQpbICAgIDAuMDAwMDAwXSAgIERNQSB6
b25lOiAwIHBhZ2VzIHJlc2VydmVkDQpbICAgIDAuMDAwMDAwXSAgIERNQSB6b25lOiAzOTI3
IHBhZ2VzLCBMSUZPIGJhdGNoOjANClsgICAgMC4wMDAwMDBdICAgRE1BMzIgem9uZTogNjky
OSBwYWdlcyB1c2VkIGZvciBtZW1tYXANClsgICAgMC4wMDAwMDBdICAgRE1BMzIgem9uZTog
NDk5ODA3IHBhZ2VzLCBMSUZPIGJhdGNoOjMxDQpbICAgIDAuMDAwMDAwXSBBQ1BJOiBQTS1U
aW1lciBJTyBQb3J0OiAweDgwOA0KWyAgICAwLjAwMDAwMF0gQUNQSTogTG9jYWwgQVBJQyBh
ZGRyZXNzIDB4ZmVlMDAwMDANClsgICAgMC4wMDAwMDBdIEFDUEk6IExBUElDIChhY3BpX2lk
WzB4MDFdIGxhcGljX2lkWzB4MDBdIGVuYWJsZWQpDQpbICAgIDAuMDAwMDAwXSBBQ1BJOiBM
QVBJQyAoYWNwaV9pZFsweDAyXSBsYXBpY19pZFsweDAxXSBlbmFibGVkKQ0KWyAgICAwLjAw
MDAwMF0gQUNQSTogTEFQSUMgKGFjcGlfaWRbMHgwM10gbGFwaWNfaWRbMHgwMl0gZW5hYmxl
ZCkNClsgICAgMC4wMDAwMDBdIEFDUEk6IExBUElDIChhY3BpX2lkWzB4MDRdIGxhcGljX2lk
WzB4MDNdIGVuYWJsZWQpDQpbICAgIDAuMDAwMDAwXSBBQ1BJOiBJT0FQSUMgKGlkWzB4MDRd
IGFkZHJlc3NbMHhmZWMwMDAwMF0gZ3NpX2Jhc2VbMF0pDQpbICAgIDAuMDAwMDAwXSBJT0FQ
SUNbMF06IGFwaWNfaWQgNCwgdmVyc2lvbiAzMiwgYWRkcmVzcyAweGZlYzAwMDAwLCBHU0kg
MC0yMw0KWyAgICAwLjAwMDAwMF0gQUNQSTogSU5UX1NSQ19PVlIgKGJ1cyAwIGJ1c19pcnEg
MCBnbG9iYWxfaXJxIDIgZGZsIGRmbCkNClsgICAgMC4wMDAwMDBdIEFDUEk6IElOVF9TUkNf
T1ZSIChidXMgMCBidXNfaXJxIDkgZ2xvYmFsX2lycSA5IGhpZ2ggbGV2ZWwpDQpbICAgIDAu
MDAwMDAwXSBBQ1BJOiBJUlEwIHVzZWQgYnkgb3ZlcnJpZGUuDQpbICAgIDAuMDAwMDAwXSBB
Q1BJOiBJUlEyIHVzZWQgYnkgb3ZlcnJpZGUuDQpbICAgIDAuMDAwMDAwXSBBQ1BJOiBJUlE5
IHVzZWQgYnkgb3ZlcnJpZGUuDQpbICAgIDAuMDAwMDAwXSBVc2luZyBBQ1BJIChNQURUKSBm
b3IgU01QIGNvbmZpZ3VyYXRpb24gaW5mb3JtYXRpb24NClsgICAgMC4wMDAwMDBdIEFDUEk6
IEhQRVQgaWQ6IDB4ODA4NmE3MDEgYmFzZTogMHhmZWQwMDAwMA0KWyAgICAwLjAwMDAwMF0g
U01QOiBBbGxvd2luZyA0IENQVXMsIDAgaG90cGx1ZyBDUFVzDQpbICAgIDAuMDAwMDAwXSBu
cl9pcnFzX2dzaTogMjQNClsgICAgMC4wMDAwMDBdIGVhcmx5X3JlcyBhcnJheSBpcyBkb3Vi
bGVkIHRvIDY0IGF0IFsxODAwMCAtIDE4N2ZmXQ0KWyAgICAwLjAwMDAwMF0gUE06IFJlZ2lz
dGVyZWQgbm9zYXZlIG1lbW9yeTogMDAwMDAwMDAwMDA5ZjAwMCAtIDAwMDAwMDAwMDAwYTAw
MDANClsgICAgMC4wMDAwMDBdIFBNOiBSZWdpc3RlcmVkIG5vc2F2ZSBtZW1vcnk6IDAwMDAw
MDAwMDAwYTAwMDAgLSAwMDAwMDAwMDAwMGU0MDAwDQpbICAgIDAuMDAwMDAwXSBQTTogUmVn
aXN0ZXJlZCBub3NhdmUgbWVtb3J5OiAwMDAwMDAwMDAwMGU0MDAwIC0gMDAwMDAwMDAwMDEw
MDAwMA0KWyAgICAwLjAwMDAwMF0gQWxsb2NhdGluZyBQQ0kgcmVzb3VyY2VzIHN0YXJ0aW5n
IGF0IDdjYzAwMDAwIChnYXA6IDdjYzAwMDAwOjgyMTAwMDAwKQ0KWyAgICAwLjAwMDAwMF0g
Qm9vdGluZyBwYXJhdmlydHVhbGl6ZWQga2VybmVsIG9uIGJhcmUgaGFyZHdhcmUNClsgICAg
MC4wMDAwMDBdIHNldHVwX3BlcmNwdTogTlJfQ1BVUzo4IG5yX2NwdW1hc2tfYml0czo4IG5y
X2NwdV9pZHM6NCBucl9ub2RlX2lkczoxDQpbICAgIDAuMDAwMDAwXSBQRVJDUFU6IEVtYmVk
ZGVkIDI5IHBhZ2VzL2NwdSBAZmZmZjg4MDAwMjAwMDAwMCBzODc3ODQgcjgxOTIgZDIyODA4
IHU1MjQyODgNClsgICAgMC4wMDAwMDBdIHBjcHUtYWxsb2M6IHM4Nzc4NCByODE5MiBkMjI4
MDggdTUyNDI4OCBhbGxvYz0xKjIwOTcxNTINClsgICAgMC4wMDAwMDBdIHBjcHUtYWxsb2M6
IFswXSAwIDEgMiAzIA0KWyAgICAwLjAwMDAwMF0gQnVpbHQgMSB6b25lbGlzdHMgaW4gWm9u
ZSBvcmRlciwgbW9iaWxpdHkgZ3JvdXBpbmcgb24uICBUb3RhbCBwYWdlczogNTAzNzM0DQpb
ICAgIDAuMDAwMDAwXSBLZXJuZWwgY29tbWFuZCBsaW5lOiByb290PS9kZXYvc2RhMSBybyBj
b25zb2xlPXR0eTANClsgICAgMC4wMDAwMDBdIFBJRCBoYXNoIHRhYmxlIGVudHJpZXM6IDQw
OTYgKG9yZGVyOiAzLCAzMjc2OCBieXRlcykNClsgICAgMC4wMDAwMDBdIERlbnRyeSBjYWNo
ZSBoYXNoIHRhYmxlIGVudHJpZXM6IDI2MjE0NCAob3JkZXI6IDksIDIwOTcxNTIgYnl0ZXMp
DQpbICAgIDAuMDAwMDAwXSBJbm9kZS1jYWNoZSBoYXNoIHRhYmxlIGVudHJpZXM6IDEzMTA3
MiAob3JkZXI6IDgsIDEwNDg1NzYgYnl0ZXMpDQpbICAgIDAuMDAwMDAwXSB4c2F2ZS94cnN0
b3I6IGVuYWJsZWQgeHN0YXRlX2J2IDB4MywgY250eHQgc2l6ZSAweDI0MA0KWyAgICAwLjAw
MDAwMF0gQ2hlY2tpbmcgYXBlcnR1cmUuLi4NClsgICAgMC4wMDAwMDBdIE5vIEFHUCBicmlk
Z2UgZm91bmQNClsgICAgMC4wMDAwMDBdIFN1YnRyYWN0ICg1MSBlYXJseSByZXNlcnZhdGlv
bnMpDQpbICAgIDAuMDAwMDAwXSAgICMxIFswMDAxMDAwMDAwIC0gMDAwMWU5ZjQ5NF0gICBU
RVhUIERBVEEgQlNTDQpbICAgIDAuMDAwMDAwXSAgICMyIFswMDM3Y2U0MDAwIC0gMDAzN2Zl
ZjBmOF0gICAgICAgICBSQU1ESVNLDQpbICAgIDAuMDAwMDAwXSAgICMzIFswMDAxZWEwMDAw
IC0gMDAwMWVhMDI5OF0gICAgICAgICAgICAgQlJLDQpbICAgIDAuMDAwMDAwXSAgICM0IFsw
MDAwMGZmNzkwIC0gMDAwMDEwMDAwMF0gICBCSU9TIHJlc2VydmVkDQpbICAgIDAuMDAwMDAw
XSAgICM1IFswMDAwMGZmNzgwIC0gMDAwMDBmZjc5MF0gICAgTVAtdGFibGUgbXBmDQpbICAg
IDAuMDAwMDAwXSAgICM2IFswMDAwMDlmNDAwIC0gMDAwMDBlM2RhMF0gICBCSU9TIHJlc2Vy
dmVkDQpbICAgIDAuMDAwMDAwXSAgICM3IFswMDAwMGUzZjg0IC0gMDAwMDBmZjc4MF0gICBC
SU9TIHJlc2VydmVkDQpbICAgIDAuMDAwMDAwXSAgICM4IFswMDAwMGUzZGEwIC0gMDAwMDBl
M2Y4NF0gICAgTVAtdGFibGUgbXBjDQpbICAgIDAuMDAwMDAwXSAgICM5IFswMDAwMDEwMDAw
IC0gMDAwMDAxMjAwMF0gICAgICBUUkFNUE9MSU5FDQpbICAgIDAuMDAwMDAwXSAgICMxMCBb
MDAwMDAxMjAwMCAtIDAwMDAwMTYwMDBdICAgICBBQ1BJIFdBS0VVUA0KWyAgICAwLjAwMDAw
MF0gICAjMTEgWzAwMDAwMTYwMDAgLSAwMDAwMDE4MDAwXSAgICAgICAgIFBHVEFCTEUNClsg
ICAgMC4wMDAwMDBdICAgIzEyIFswMDAxZWEwMmMwIC0gMDAwMWVhMTJjMF0gICAgICAgICBC
T09UTUVNDQpbICAgIDAuMDAwMDAwXSAgICMxMyBbMDAwMWU5ZjRjMCAtIDAwMDFlOWY2NDBd
ICAgICAgICAgQk9PVE1FTQ0KWyAgICAwLjAwMDAwMF0gICAjMTQgWzAwMDI2YTIwMDAgLSAw
MDA0MmEyMDAwXSAgICAgICAgIEJPT1RNRU0NClsgICAgMC4wMDAwMDBdICAgIzE1IFswMDAx
ZTlmNjQwIC0gMDAwMWU5ZjdjMF0gICAgICAgICBCT09UTUVNDQpbICAgIDAuMDAwMDAwXSAg
ICMxNiBbMDAwMWVhMTJjMCAtIDAwMDFlYWQyYzBdICAgICAgICAgQk9PVE1FTQ0KWyAgICAw
LjAwMDAwMF0gICAjMTcgWzAwMDFlYWUwMDAgLSAwMDAxZWFmMDAwXSAgICAgICAgIEJPT1RN
RU0NClsgICAgMC4wMDAwMDBdICAgIzE4IFswMDAxZTlmN2MwIC0gMDAwMWU5ZjgwMV0gICAg
ICAgICBCT09UTUVNDQpbICAgIDAuMDAwMDAwXSAgICMxOSBbMDAwMWU5Zjg0MCAtIDAwMDFl
OWY4ODNdICAgICAgICAgQk9PVE1FTQ0KWyAgICAwLjAwMDAwMF0gICAjMjAgWzAwMDFlOWY4
YzAgLSAwMDAxZTlmYjk4XSAgICAgICAgIEJPT1RNRU0NClsgICAgMC4wMDAwMDBdICAgIzIx
IFswMDAxZTlmYmMwIC0gMDAwMWU5ZmMyOF0gICAgICAgICBCT09UTUVNDQpbICAgIDAuMDAw
MDAwXSAgICMyMiBbMDAwMWU5ZmM0MCAtIDAwMDFlOWZjYThdICAgICAgICAgQk9PVE1FTQ0K
WyAgICAwLjAwMDAwMF0gICAjMjMgWzAwMDFlOWZjYzAgLSAwMDAxZTlmZDI4XSAgICAgICAg
IEJPT1RNRU0NClsgICAgMC4wMDAwMDBdICAgIzI0IFswMDAxZTlmZDQwIC0gMDAwMWU5ZmRh
OF0gICAgICAgICBCT09UTUVNDQpbICAgIDAuMDAwMDAwXSAgICMyNSBbMDAwMWU5ZmRjMCAt
IDAwMDFlOWZlMjhdICAgICAgICAgQk9PVE1FTQ0KWyAgICAwLjAwMDAwMF0gICAjMjYgWzAw
MDFlOWZlNDAgLSAwMDAxZTlmZWE4XSAgICAgICAgIEJPT1RNRU0NClsgICAgMC4wMDAwMDBd
ICAgIzI3IFswMDAxZTlmZWMwIC0gMDAwMWU5ZmYyOF0gICAgICAgICBCT09UTUVNDQpbICAg
IDAuMDAwMDAwXSAgICMyOCBbMDAwMWU5ZmY0MCAtIDAwMDFlOWZmYThdICAgICAgICAgQk9P
VE1FTQ0KWyAgICAwLjAwMDAwMF0gICAjMjkgWzAwMDFlYWQyYzAgLSAwMDAxZWFkMzI4XSAg
ICAgICAgIEJPT1RNRU0NClsgICAgMC4wMDAwMDBdICAgIzMwIFswMDAxZWFkMzQwIC0gMDAw
MWVhZDNhOF0gICAgICAgICBCT09UTUVNDQpbICAgIDAuMDAwMDAwXSAgICMzMSBbMDAwMWVh
ZDNjMCAtIDAwMDFlYWQ0MjhdICAgICAgICAgQk9PVE1FTQ0KWyAgICAwLjAwMDAwMF0gICAj
MzIgWzAwMDFlYWQ0NDAgLSAwMDAxZWFkNGE4XSAgICAgICAgIEJPT1RNRU0NClsgICAgMC4w
MDAwMDBdICAgIzMzIFswMDAxZTlmZmMwIC0gMDAwMWU5ZmZlMF0gICAgICAgICBCT09UTUVN
DQpbICAgIDAuMDAwMDAwXSAgICMzNCBbMDAwMWVhZDRjMCAtIDAwMDFlYWQ0ZGZdICAgICAg
ICAgQk9PVE1FTQ0KWyAgICAwLjAwMDAwMF0gICAjMzUgWzAwMDFlYWQ1MDAgLSAwMDAxZWFk
NTFmXSAgICAgICAgIEJPT1RNRU0NClsgICAgMC4wMDAwMDBdICAgIzM2IFswMDAyMDAwMDAw
IC0gMDAwMjAxZDAwMF0gICAgICAgICBCT09UTUVNDQpbICAgIDAuMDAwMDAwXSAgICMzNyBb
MDAwMjA4MDAwMCAtIDAwMDIwOWQwMDBdICAgICAgICAgQk9PVE1FTQ0KWyAgICAwLjAwMDAw
MF0gICAjMzggWzAwMDIxMDAwMDAgLSAwMDAyMTFkMDAwXSAgICAgICAgIEJPT1RNRU0NClsg
ICAgMC4wMDAwMDBdICAgIzM5IFswMDAyMTgwMDAwIC0gMDAwMjE5ZDAwMF0gICAgICAgICBC
T09UTUVNDQpbICAgIDAuMDAwMDAwXSAgICM0MCBbMDAwMWVhZDU0MCAtIDAwMDFlYWQ1NDhd
ICAgICAgICAgQk9PVE1FTQ0KWyAgICAwLjAwMDAwMF0gICAjNDEgWzAwMDFlYWQ1ODAgLSAw
MDAxZWFkNTg4XSAgICAgICAgIEJPT1RNRU0NClsgICAgMC4wMDAwMDBdICAgIzQyIFswMDAx
ZWFkNWMwIC0gMDAwMWVhZDVkMF0gICAgICAgICBCT09UTUVNDQpbICAgIDAuMDAwMDAwXSAg
ICM0MyBbMDAwMWVhZDYwMCAtIDAwMDFlYWQ2MjBdICAgICAgICAgQk9PVE1FTQ0KWyAgICAw
LjAwMDAwMF0gICAjNDQgWzAwMDFlYWQ2NDAgLSAwMDAxZWFkNzcwXSAgICAgICAgIEJPT1RN
RU0NClsgICAgMC4wMDAwMDBdICAgIzQ1IFswMDAxZWFkNzgwIC0gMDAwMWVhZDdkMF0gICAg
ICAgICBCT09UTUVNDQpbICAgIDAuMDAwMDAwXSAgICM0NiBbMDAwMWVhZDgwMCAtIDAwMDFl
YWQ4NTBdICAgICAgICAgQk9PVE1FTQ0KWyAgICAwLjAwMDAwMF0gICAjNDcgWzAwMDFlYWYw
MDAgLSAwMDAxZWI3MDAwXSAgICAgICAgIEJPT1RNRU0NClsgICAgMC4wMDAwMDBdICAgIzQ4
IFswMDAyMTlkMDAwIC0gMDAwMjM5ZDAwMF0gICAgICAgICBCT09UTUVNDQpbICAgIDAuMDAw
MDAwXSAgICM0OSBbMDAwMWViNzAwMCAtIDAwMDFmYjcwMDBdICAgICAgICAgQk9PVE1FTQ0K
WyAgICAwLjAwMDAwMF0gICAjNTAgWzAwMDFlYWQ4ODAgLSAwMDAxZWFkYWMwXSAgICAgICAg
IEJPT1RNRU0NClsgICAgMC4wMDAwMDBdICAxOCA0MCAtIDgwIDlmDQpbICAgIDAuMDAwMDAw
XSAgMTAwIDEwMCAtIDEwMDAgMTAwMA0KWyAgICAwLjAwMDAwMF0gIDFmYjcgMWZjMCAtIDIw
MDAgMjAwMA0KWyAgICAwLjAwMDAwMF0gIDIwMWQgMjA0MCAtIDIwODAgMjA4MA0KWyAgICAw
LjAwMDAwMF0gIDIwOWQgMjBjMCAtIDIxMDAgMjEwMA0KWyAgICAwLjAwMDAwMF0gIDIxMWQg
MjE0MCAtIDIxODAgMjE4MA0KWyAgICAwLjAwMDAwMF0gIDIzOWQgMjNjMCAtIDI2ODAgMjZh
Mg0KWyAgICAwLjAwMDAwMF0gIDQyYTIgNDJjMCAtIDM3Y2MwIDM3Y2U0DQpbICAgIDAuMDAw
MDAwXSAgMzdmZjAgMzgwMDAgLSA3Y2I0MCA3Y2I3MA0KWyAgICAwLjAwMDAwMF0gTWVtb3J5
OiAxOTkyNDQ4ay8yMDQzMzI4ayBhdmFpbGFibGUgKDYzOTZrIGtlcm5lbCBjb2RlLCA0NTJr
IGFic2VudCwgNTA0MjhrIHJlc2VydmVkLCA2ODk2ayBkYXRhLCA1NjRrIGluaXQpDQpbICAg
IDAuMDAwMDAwXSBTTFVCOiBHZW5zbGFicz0xMywgSFdhbGlnbj02NCwgT3JkZXI9MC0zLCBN
aW5PYmplY3RzPTAsIENQVXM9NCwgTm9kZXM9MQ0KWyAgICAwLjAwMDAwMF0gSGllcmFyY2hp
Y2FsIFJDVSBpbXBsZW1lbnRhdGlvbi4NClsgICAgMC4wMDAwMDBdIE5SX0lSUVM6NDM1MiBu
cl9pcnFzOjQ0MA0KWyAgICAwLjAwMDAwMF0gRXh0ZW5kZWQgQ01PUyB5ZWFyOiAyMDAwDQpb
ICAgIDAuMDAwMDAwXSBDb25zb2xlOiBjb2xvdXIgVkdBKyA4MHgyNQ0KWyAgICAwLjAwMDAw
MF0gY29uc29sZSBbdHR5MF0gZW5hYmxlZA0KWyAgICAwLjAwMDAwMF0gaHBldCBjbG9ja2V2
ZW50IHJlZ2lzdGVyZWQNClsgICAgMC4wMDAwMDBdIEZhc3QgVFNDIGNhbGlicmF0aW9uIHVz
aW5nIFBJVA0KWyAgICAwLjAwMDAwMF0gRGV0ZWN0ZWQgMjY2Ni43NzEgTUh6IHByb2Nlc3Nv
ci4NClsgICAgMC4wMDIwMDRdIENhbGlicmF0aW5nIGRlbGF5IGxvb3AgKHNraXBwZWQpLCB2
YWx1ZSBjYWxjdWxhdGVkIHVzaW5nIHRpbWVyIGZyZXF1ZW5jeS4uIDUzMzMuNTQgQm9nb01J
UFMgKGxwaj0yNjY2NzcxKQ0KWyAgICAwLjAwMjM5Ml0gU2VjdXJpdHkgRnJhbWV3b3JrIGlu
aXRpYWxpemVkDQpbICAgIDAuMDAyNTc4XSBTRUxpbnV4OiAgSW5pdGlhbGl6aW5nLg0KWyAg
ICAwLjAwMjc2Nl0gU0VMaW51eDogIFN0YXJ0aW5nIGluIHBlcm1pc3NpdmUgbW9kZQ0KWyAg
ICAwLjAwMjc3M10gTW91bnQtY2FjaGUgaGFzaCB0YWJsZSBlbnRyaWVzOiAyNTYNClsgICAg
MC4wMDMxMjBdIEluaXRpYWxpemluZyBjZ3JvdXAgc3Vic3lzIG5zDQpbICAgIDAuMDAzMzAw
XSBJbml0aWFsaXppbmcgY2dyb3VwIHN1YnN5cyBjcHVhY2N0DQpbICAgIDAuMDAzNDgwXSBJ
bml0aWFsaXppbmcgY2dyb3VwIHN1YnN5cyBmcmVlemVyDQpbICAgIDAuMDAzNjc2XSBDUFU6
IFBoeXNpY2FsIFByb2Nlc3NvciBJRDogMA0KWyAgICAwLjAwMzg1M10gQ1BVOiBQcm9jZXNz
b3IgQ29yZSBJRDogMA0KWyAgICAwLjAwNDAwM10gbWNlOiBDUFUgc3VwcG9ydHMgNiBNQ0Ug
YmFua3MNClsgICAgMC4wMDQxODVdIHVzaW5nIG13YWl0IGluIGlkbGUgdGhyZWFkcy4NClsg
ICAgMC4wMDQzNjJdIFBlcmZvcm1hbmNlIEV2ZW50czogQ29yZTIgZXZlbnRzLCBJbnRlbCBQ
TVUgZHJpdmVyLg0KWyAgICAwLjAwNDYwOF0gLi4uIHZlcnNpb246ICAgICAgICAgICAgICAg
IDINClsgICAgMC4wMDQ3OTFdIC4uLiBiaXQgd2lkdGg6ICAgICAgICAgICAgICA0MA0KWyAg
ICAwLjAwNTAwMV0gLi4uIGdlbmVyaWMgcmVnaXN0ZXJzOiAgICAgIDINClsgICAgMC4wMDUx
ODNdIC4uLiB2YWx1ZSBtYXNrOiAgICAgICAgICAgICAwMDAwMDBmZmZmZmZmZmZmDQpbICAg
IDAuMDA1MzY4XSAuLi4gbWF4IHBlcmlvZDogICAgICAgICAgICAgMDAwMDAwMDA3ZmZmZmZm
Zg0KWyAgICAwLjAwNTU1NF0gLi4uIGZpeGVkLXB1cnBvc2UgZXZlbnRzOiAgIDMNClsgICAg
MC4wMDU3NDNdIC4uLiBldmVudCBtYXNrOiAgICAgICAgICAgICAwMDAwMDAwNzAwMDAwMDAz
DQpbICAgIDAuMDA2OTExXSBBQ1BJOiBDb3JlIHJldmlzaW9uIDIwMTAwMTIxDQpbICAgIDAu
MDE3MzU3XSBTZXR0aW5nIEFQSUMgcm91dGluZyB0byBmbGF0DQpbICAgIDAuMDE3ODM0XSAu
LlRJTUVSOiB2ZWN0b3I9MHgzMCBhcGljMT0wIHBpbjE9MiBhcGljMj0tMSBwaW4yPS0xDQpb
ICAgIDAuMDI4MDI2XSBDUFUwOiBJbnRlbChSKSBDb3JlKFRNKTIgUXVhZCBDUFUgICAgUTk0
MDAgIEAgMi42NkdIeiBzdGVwcGluZyAwYQ0KWyAgICAwLjAyODk5OV0gQm9vdGluZyBOb2Rl
ICAgMCwgUHJvY2Vzc29ycyAgIzEgIzIgIzMgT2suDQpbICAgIDAuMjQ1MDA1XSBCcm91Z2h0
IHVwIDQgQ1BVcw0KWyAgICAwLjI0NTIwM10gVG90YWwgb2YgNCBwcm9jZXNzb3JzIGFjdGl2
YXRlZCAoMjEzMzEuMTIgQm9nb01JUFMpLg0KWyAgICAwLjI0NzA4Ml0gVGltZTogIDI6NTQ6
MTUgIERhdGU6IDAzLzEzLzEwDQpbICAgIDAuMjQ4MDQxXSBORVQ6IFJlZ2lzdGVyZWQgcHJv
dG9jb2wgZmFtaWx5IDE2DQpbICAgIDAuMjQ4MjQ2XSBBQ1BJOiBidXMgdHlwZSBwY2kgcmVn
aXN0ZXJlZA0KWyAgICAwLjI0OTAzNl0gUENJOiBNTUNPTkZJRyBmb3IgZG9tYWluIDAwMDAg
W2J1cyAwMC1mZl0gYXQgW21lbSAweGUwMDAwMDAwLTB4ZWZmZmZmZmZdIChiYXNlIDB4ZTAw
MDAwMDApDQpbICAgIDAuMjQ5MzY2XSBQQ0k6IG5vdCB1c2luZyBNTUNPTkZJRw0KWyAgICAw
LjI0OTU0OV0gUENJOiBVc2luZyBjb25maWd1cmF0aW9uIHR5cGUgMSBmb3IgYmFzZSBhY2Nl
c3MNClsgICAgMC4yNjYwNDhdIGJpbzogY3JlYXRlIHNsYWIgPGJpby0wPiBhdCAwDQpbICAg
IDAuMjY3NDQ5XSBBQ1BJOiBFQzogTG9vayB1cCBFQyBpbiBEU0RUDQpbICAgIDAuMjY4NjY5
XSBBQ1BJOiBFeGVjdXRlZCAxIGJsb2NrcyBvZiBtb2R1bGUtbGV2ZWwgZXhlY3V0YWJsZSBB
TUwgY29kZQ0KWyAgICAwLjI3NTYyM10gQUNQSTogSW50ZXJwcmV0ZXIgZW5hYmxlZA0KWyAg
ICAwLjI3NTgxMl0gQUNQSTogKHN1cHBvcnRzIFMwIFMxIFMzIFM0IFM1KQ0KWyAgICAwLjI3
NzAwM10gQUNQSTogVXNpbmcgSU9BUElDIGZvciBpbnRlcnJ1cHQgcm91dGluZw0KWyAgICAw
LjI3NzIzOF0gUENJOiBNTUNPTkZJRyBmb3IgZG9tYWluIDAwMDAgW2J1cyAwMC1mZl0gYXQg
W21lbSAweGUwMDAwMDAwLTB4ZWZmZmZmZmZdIChiYXNlIDB4ZTAwMDAwMDApDQpbICAgIDAu
Mjc4MzkwXSBQQ0k6IE1NQ09ORklHIGF0IFttZW0gMHhlMDAwMDAwMC0weGVmZmZmZmZmXSBy
ZXNlcnZlZCBpbiBBQ1BJIG1vdGhlcmJvYXJkIHJlc291cmNlcw0KWyAgICAwLjMwNzA3Nl0g
QUNQSSBXYXJuaW5nOiBJbmNvcnJlY3QgY2hlY2tzdW0gaW4gdGFibGUgW09FTUJdIC0gQzUs
IHNob3VsZCBiZSBCQyAoMjAxMDAxMjEvdGJ1dGlscy0zMTQpDQpbICAgIDAuMzA4MTUwXSBB
Q1BJOiBObyBkb2NrIGRldmljZXMgZm91bmQuDQpbICAgIDAuMzA4MzM4XSBQQ0k6IFVzaW5n
IGhvc3QgYnJpZGdlIHdpbmRvd3MgZnJvbSBBQ1BJOyBpZiBuZWNlc3NhcnksIHVzZSAicGNp
PW5vY3JzIiBhbmQgcmVwb3J0IGEgYnVnDQpbICAgIDAuMzA4ODAxXSBBQ1BJOiBQQ0kgUm9v
dCBCcmlkZ2UgW1BDSTBdICgwMDAwOjAwKQ0KWyAgICAwLjMwOTIzOF0gcGNpX3Jvb3QgUE5Q
MEEwODowMDogaG9zdCBicmlkZ2Ugd2luZG93IFtpbyAgMHgwMDAwLTB4MGNmN10NClsgICAg
MC4zMDk0MjddIHBjaV9yb290IFBOUDBBMDg6MDA6IGhvc3QgYnJpZGdlIHdpbmRvdyBbaW8g
IDB4MGQwMC0weGZmZmZdDQpbICAgIDAuMzA5NjE2XSBwY2lfcm9vdCBQTlAwQTA4OjAwOiBo
b3N0IGJyaWRnZSB3aW5kb3cgW21lbSAweDAwMGEwMDAwLTB4MDAwYmZmZmZdDQpbICAgIDAu
MzEwMDAyXSBwY2lfcm9vdCBQTlAwQTA4OjAwOiBob3N0IGJyaWRnZSB3aW5kb3cgW21lbSAw
eDAwMGQwMDAwLTB4MDAwZGZmZmZdDQpbICAgIDAuMzEwMzM3XSBwY2lfcm9vdCBQTlAwQTA4
OjAwOiBob3N0IGJyaWRnZSB3aW5kb3cgW21lbSAweDdjYzAwMDAwLTB4ZGZmZmZmZmZdDQpb
ICAgIDAuMzEwNjc1XSBwY2lfcm9vdCBQTlAwQTA4OjAwOiBob3N0IGJyaWRnZSB3aW5kb3cg
W21lbSAweGYwMDAwMDAwLTB4ZmZmZmZmZmZdDQpbICAgIDAuMzExMDUyXSBwY2kgMDAwMDow
MDowMS4wOiBQTUUjIHN1cHBvcnRlZCBmcm9tIEQwIEQzaG90IEQzY29sZA0KWyAgICAwLjMx
MTA1NV0gcGNpIDAwMDA6MDA6MDEuMDogUE1FIyBkaXNhYmxlZA0KWyAgICAwLjMxMTA3MV0g
cGNpIDAwMDA6MDA6MDIuMDogcmVnIDEwOiBbbWVtIDB4ZmUwMDAwMDAtMHhmZTNmZmZmZiA2
NGJpdF0NClsgICAgMC4zMTEwNzZdIHBjaSAwMDAwOjAwOjAyLjA6IHJlZyAxODogW21lbSAw
eGQwMDAwMDAwLTB4ZGZmZmZmZmYgNjRiaXQgcHJlZl0NClsgICAgMC4zMTEwNzldIHBjaSAw
MDAwOjAwOjAyLjA6IHJlZyAyMDogW2lvICAweGJjMDAtMHhiYzA3XQ0KWyAgICAwLjMxMTEy
N10gcGNpIDAwMDA6MDA6MDMuMDogcmVnIDEwOiBbbWVtIDB4ZmU2ZmIwMDAtMHhmZTZmYjAw
ZiA2NGJpdF0NClsgICAgMC4zMTExODFdIHBjaSAwMDAwOjAwOjAzLjA6IFBNRSMgc3VwcG9y
dGVkIGZyb20gRDAgRDNob3QgRDNjb2xkDQpbICAgIDAuMzExMTg1XSBwY2kgMDAwMDowMDow
My4wOiBQTUUjIGRpc2FibGVkDQpbICAgIDAuMzExMjMyXSBwY2kgMDAwMDowMDoxOS4wOiBy
ZWcgMTA6IFttZW0gMHhmZTZjMDAwMC0weGZlNmRmZmZmXQ0KWyAgICAwLjMxMTIzN10gcGNp
IDAwMDA6MDA6MTkuMDogcmVnIDE0OiBbbWVtIDB4ZmU2ZmEwMDAtMHhmZTZmYWZmZl0NClsg
ICAgMC4zMTEyNDJdIHBjaSAwMDAwOjAwOjE5LjA6IHJlZyAxODogW2lvICAweGI4ODAtMHhi
ODlmXQ0KWyAgICAwLjMxMTI3M10gcGNpIDAwMDA6MDA6MTkuMDogUE1FIyBzdXBwb3J0ZWQg
ZnJvbSBEMCBEM2hvdCBEM2NvbGQNClsgICAgMC4zMTEyNzZdIHBjaSAwMDAwOjAwOjE5LjA6
IFBNRSMgZGlzYWJsZWQNClsgICAgMC4zMTEzMTRdIHBjaSAwMDAwOjAwOjFhLjA6IHJlZyAy
MDogW2lvICAweGI0MDAtMHhiNDFmXQ0KWyAgICAwLjMxMTM2Nl0gcGNpIDAwMDA6MDA6MWEu
MTogcmVnIDIwOiBbaW8gIDB4YjQ4MC0weGI0OWZdDQpbICAgIDAuMzExNDE4XSBwY2kgMDAw
MDowMDoxYS4yOiByZWcgMjA6IFtpbyAgMHhiODAwLTB4YjgxZl0NClsgICAgMC4zMTE0Njld
IHBjaSAwMDAwOjAwOjFhLjc6IHJlZyAxMDogW21lbSAweGZlNmY5MDAwLTB4ZmU2ZjkzZmZd
DQpbICAgIDAuMzExNTE0XSBwY2kgMDAwMDowMDoxYS43OiBQTUUjIHN1cHBvcnRlZCBmcm9t
IEQwIEQzaG90IEQzY29sZA0KWyAgICAwLjMxMTUxOF0gcGNpIDAwMDA6MDA6MWEuNzogUE1F
IyBkaXNhYmxlZA0KWyAgICAwLjMxMTU0NV0gcGNpIDAwMDA6MDA6MWIuMDogcmVnIDEwOiBb
bWVtIDB4ZmU2ZjAwMDAtMHhmZTZmM2ZmZiA2NGJpdF0NClsgICAgMC4zMTE1NzhdIHBjaSAw
MDAwOjAwOjFiLjA6IFBNRSMgc3VwcG9ydGVkIGZyb20gRDAgRDNob3QgRDNjb2xkDQpbICAg
IDAuMzExNTgxXSBwY2kgMDAwMDowMDoxYi4wOiBQTUUjIGRpc2FibGVkDQpbICAgIDAuMzEx
NjMwXSBwY2kgMDAwMDowMDoxYy4wOiBQTUUjIHN1cHBvcnRlZCBmcm9tIEQwIEQzaG90IEQz
Y29sZA0KWyAgICAwLjMxMTYzM10gcGNpIDAwMDA6MDA6MWMuMDogUE1FIyBkaXNhYmxlZA0K
WyAgICAwLjMxMTY4N10gcGNpIDAwMDA6MDA6MWMuNDogUE1FIyBzdXBwb3J0ZWQgZnJvbSBE
MCBEM2hvdCBEM2NvbGQNClsgICAgMC4zMTE2OTBdIHBjaSAwMDAwOjAwOjFjLjQ6IFBNRSMg
ZGlzYWJsZWQNClsgICAgMC4zMTE3MzldIHBjaSAwMDAwOjAwOjFkLjA6IHJlZyAyMDogW2lv
ICAweGFjMDAtMHhhYzFmXQ0KWyAgICAwLjMxMTgwMV0gcGNpIDAwMDA6MDA6MWQuMTogcmVn
IDIwOiBbaW8gIDB4YjAwMC0weGIwMWZdDQpbICAgIDAuMzExODUzXSBwY2kgMDAwMDowMDox
ZC4yOiByZWcgMjA6IFtpbyAgMHhiMDgwLTB4YjA5Zl0NClsgICAgMC4zMTE5MDVdIHBjaSAw
MDAwOjAwOjFkLjc6IHJlZyAxMDogW21lbSAweGZlNmY4MDAwLTB4ZmU2ZjgzZmZdDQpbICAg
IDAuMzEyMDMzXSBwY2kgMDAwMDowMDoxZC43OiBQTUUjIHN1cHBvcnRlZCBmcm9tIEQwIEQz
aG90IEQzY29sZA0KWyAgICAwLjMxMjAzN10gcGNpIDAwMDA6MDA6MWQuNzogUE1FIyBkaXNh
YmxlZA0KWyAgICAwLjMxMjE2M10gcGNpIDAwMDA6MDA6MWYuMjogcmVnIDEwOiBbaW8gIDB4
MDAwMC0weDAwMDddDQpbICAgIDAuMzEyMTY4XSBwY2kgMDAwMDowMDoxZi4yOiByZWcgMTQ6
IFtpbyAgMHgwMDAwLTB4MDAwM10NClsgICAgMC4zMTIxNzJdIHBjaSAwMDAwOjAwOjFmLjI6
IHJlZyAxODogW2lvICAweDAwMDAtMHgwMDA3XQ0KWyAgICAwLjMxMjE3Nl0gcGNpIDAwMDA6
MDA6MWYuMjogcmVnIDFjOiBbaW8gIDB4MDAwMC0weDAwMDNdDQpbICAgIDAuMzEyMTgxXSBw
Y2kgMDAwMDowMDoxZi4yOiByZWcgMjA6IFtpbyAgMHhmZjkwLTB4ZmY5Zl0NClsgICAgMC4z
MTIxODVdIHBjaSAwMDAwOjAwOjFmLjI6IHJlZyAyNDogW2lvICAweGZmYTAtMHhmZmFmXQ0K
WyAgICAwLjMxMjIyMV0gcGNpIDAwMDA6MDA6MWYuMzogcmVnIDEwOiBbbWVtIDB4ZmU2ZWYw
MDAtMHhmZTZlZjBmZiA2NGJpdF0NClsgICAgMC4zMTIyMzJdIHBjaSAwMDAwOjAwOjFmLjM6
IHJlZyAyMDogW2lvICAweDA0MDAtMHgwNDFmXQ0KWyAgICAwLjMxMjI2Ml0gcGNpIDAwMDA6
MDA6MWYuNTogcmVnIDEwOiBbaW8gIDB4YTg4MC0weGE4ODddDQpbICAgIDAuMzEyMjY2XSBw
Y2kgMDAwMDowMDoxZi41OiByZWcgMTQ6IFtpbyAgMHhhODAwLTB4YTgwM10NClsgICAgMC4z
MTIyNzFdIHBjaSAwMDAwOjAwOjFmLjU6IHJlZyAxODogW2lvICAweGE0ODAtMHhhNDg3XQ0K
WyAgICAwLjMxMjI3NV0gcGNpIDAwMDA6MDA6MWYuNTogcmVnIDFjOiBbaW8gIDB4YTQwMC0w
eGE0MDNdDQpbICAgIDAuMzEyMjc5XSBwY2kgMDAwMDowMDoxZi41OiByZWcgMjA6IFtpbyAg
MHhhMDgwLTB4YTA4Zl0NClsgICAgMC4zMTIyODRdIHBjaSAwMDAwOjAwOjFmLjU6IHJlZyAy
NDogW2lvICAweGEwMDAtMHhhMDBmXQ0KWyAgICAwLjMxMjM0MF0gcGNpIDAwMDA6MDE6MDAu
MDogcmVnIDEwOiBbbWVtIDB4ZmU3ZTAwMDAtMHhmZTdmZmZmZl0NClsgICAgMC4zMTIzNzFd
IHBjaSAwMDAwOjAxOjAwLjA6IFBNRSMgc3VwcG9ydGVkIGZyb20gRDAgRDNob3QgRDNjb2xk
DQpbICAgIDAuMzEyMzc0XSBwY2kgMDAwMDowMTowMC4wOiBQTUUjIGRpc2FibGVkDQpbICAg
IDAuMzEyMzg2XSBwY2kgMDAwMDowMDowMS4wOiBQQ0kgYnJpZGdlIHRvIFtidXMgMDEtMDRd
DQpbICAgIDAuMzEyNTcxXSBwY2kgMDAwMDowMDowMS4wOiAgIGJyaWRnZSB3aW5kb3cgW2lv
ICAweGMwMDAtMHhjZmZmXQ0KWyAgICAwLjMxMjU3M10gcGNpIDAwMDA6MDA6MDEuMDogICBi
cmlkZ2Ugd2luZG93IFttZW0gMHhmZTcwMDAwMC0weGZlOWZmZmZmXQ0KWyAgICAwLjMxMjU3
Nl0gcGNpIDAwMDA6MDA6MDEuMDogICBicmlkZ2Ugd2luZG93IFttZW0gMHhmZmYwMDAwMCAt
IDAwMGZmZmZmIHByZWZdIHJlZyByZWFkaW5nDQpbICAgIDAuMzEyNjUzXSBwY2kgMDAwMDow
MjowMS4wOiBQTUUjIHN1cHBvcnRlZCBmcm9tIEQwIEQzaG90IEQzY29sZA0KWyAgICAwLjMx
MjY1Nl0gcGNpIDAwMDA6MDI6MDEuMDogUE1FIyBkaXNhYmxlZA0KWyAgICAwLjMxMjcwOF0g
cGNpIDAwMDA6MDI6MDIuMDogUE1FIyBzdXBwb3J0ZWQgZnJvbSBEMCBEM2hvdCBEM2NvbGQN
ClsgICAgMC4zMTI3MTFdIHBjaSAwMDAwOjAyOjAyLjA6IFBNRSMgZGlzYWJsZWQNClsgICAg
MC4zMTI3NDFdIHBjaSAwMDAwOjAxOjAwLjA6IFBDSSBicmlkZ2UgdG8gW2J1cyAwMi0wNF0N
ClsgICAgMC4zMTI5NDhdIHBjaSAwMDAwOjAxOjAwLjA6ICAgYnJpZGdlIHdpbmRvdyBbaW8g
IDB4YzAwMC0weGNmZmZdDQpbICAgIDAuMzEyOTUxXSBwY2kgMDAwMDowMTowMC4wOiAgIGJy
aWRnZSB3aW5kb3cgW21lbSAweGZlODAwMDAwLTB4ZmU5ZmZmZmZdDQpbICAgIDAuMzEyOTU1
XSBwY2kgMDAwMDowMTowMC4wOiAgIGJyaWRnZSB3aW5kb3cgW21lbSAweGZmZjAwMDAwIC0g
MDAwZmZmZmYgcHJlZl0gcmVnIHJlYWRpbmcNClsgICAgMC4zMTMwMjJdIHBjaSAwMDAwOjAz
OjAwLjA6IHJlZyAxMDogW21lbSAweGZlOGZlMDAwLTB4ZmU4ZmZmZmYgNjRiaXRdDQpbICAg
IDAuMzEzMDc4XSBwY2kgMDAwMDowMzowMC4wOiBQTUUjIHN1cHBvcnRlZCBmcm9tIEQwIEQz
aG90DQpbICAgIDAuMzEzMDgyXSBwY2kgMDAwMDowMzowMC4wOiBQTUUjIGRpc2FibGVkDQpb
ICAgIDAuMzEzMDk4XSBwY2kgMDAwMDowMjowMS4wOiBQQ0kgYnJpZGdlIHRvIFtidXMgMDMt
MDNdDQpbICAgIDAuMzEzMjg3XSBwY2kgMDAwMDowMjowMS4wOiAgIGJyaWRnZSB3aW5kb3cg
W2lvICBmMDAwIC0gMDAwMF0gcmVnIHJlYWRpbmcNClsgICAgMC4zMTMyOTBdIHBjaSAwMDAw
OjAyOjAxLjA6ICAgYnJpZGdlIHdpbmRvdyBbbWVtIDB4ZmU4MDAwMDAtMHhmZThmZmZmZl0N
ClsgICAgMC4zMTMyOTVdIHBjaSAwMDAwOjAyOjAxLjA6ICAgYnJpZGdlIHdpbmRvdyBbbWVt
IDB4ZmZmMDAwMDAgLSAwMDBmZmZmZiBwcmVmXSByZWcgcmVhZGluZw0KWyAgICAwLjMxMzM0
N10gcGNpIDAwMDA6MDQ6MDAuMDogcmVnIDEwOiBbaW8gIDB4Y2MwMC0weGNjMDddDQpbICAg
IDAuMzEzMzUzXSBwY2kgMDAwMDowNDowMC4wOiByZWcgMTQ6IFtpbyAgMHhjODgwLTB4Yzg4
M10NClsgICAgMC4zMTMzNThdIHBjaSAwMDAwOjA0OjAwLjA6IHJlZyAxODogW2lvICAweGM4
MDAtMHhjODA3XQ0KWyAgICAwLjMxMzM2NF0gcGNpIDAwMDA6MDQ6MDAuMDogcmVnIDFjOiBb
aW8gIDB4YzQ4MC0weGM0ODNdDQpbICAgIDAuMzEzMzY5XSBwY2kgMDAwMDowNDowMC4wOiBy
ZWcgMjA6IFtpbyAgMHhjNDAwLTB4YzQwZl0NClsgICAgMC4zMTMzNzVdIHBjaSAwMDAwOjA0
OjAwLjA6IHJlZyAyNDogW21lbSAweGZlOWZmODAwLTB4ZmU5ZmZmZmZdDQpbICAgIDAuMzEz
MzgxXSBwY2kgMDAwMDowNDowMC4wOiByZWcgMzA6IFttZW0gMHhmZTllMDAwMC0weGZlOWVm
ZmZmIHByZWZdDQpbICAgIDAuMzEzNDA0XSBwY2kgMDAwMDowNDowMC4wOiBQTUUjIHN1cHBv
cnRlZCBmcm9tIEQzaG90DQpbICAgIDAuMzEzNDA3XSBwY2kgMDAwMDowNDowMC4wOiBQTUUj
IGRpc2FibGVkDQpbICAgIDAuMzEzNDE4XSBwY2kgMDAwMDowMjowMi4wOiBQQ0kgYnJpZGdl
IHRvIFtidXMgMDQtMDRdDQpbICAgIDAuMzEzNjA3XSBwY2kgMDAwMDowMjowMi4wOiAgIGJy
aWRnZSB3aW5kb3cgW2lvICAweGMwMDAtMHhjZmZmXQ0KWyAgICAwLjMxMzYxMF0gcGNpIDAw
MDA6MDI6MDIuMDogICBicmlkZ2Ugd2luZG93IFttZW0gMHhmZTkwMDAwMC0weGZlOWZmZmZm
XQ0KWyAgICAwLjMxMzYxNV0gcGNpIDAwMDA6MDI6MDIuMDogICBicmlkZ2Ugd2luZG93IFtt
ZW0gMHhmZmYwMDAwMCAtIDAwMGZmZmZmIHByZWZdIHJlZyByZWFkaW5nDQpbICAgIDAuMzEz
NjU3XSBwY2kgMDAwMDowMDoxYy4wOiBQQ0kgYnJpZGdlIHRvIFtidXMgMDYtMDZdDQpbICAg
IDAuMzEzODYzXSBwY2kgMDAwMDowMDoxYy4wOiAgIGJyaWRnZSB3aW5kb3cgW2lvICBmMDAw
IC0gMDAwMF0gcmVnIHJlYWRpbmcNClsgICAgMC4zMTM4NjZdIHBjaSAwMDAwOjAwOjFjLjA6
ICAgYnJpZGdlIHdpbmRvdyBbbWVtIDB4ZmZmMDAwMDAgLSAweDAwMGZmZmZmXSByZWcgcmVh
ZGluZw0KWyAgICAwLjMxMzg3MV0gcGNpIDAwMDA6MDA6MWMuMDogICBicmlkZ2Ugd2luZG93
IFttZW0gMHhmZDcwMDAwMC0weGZkN2ZmZmZmIDY0Yml0IHByZWZdDQpbICAgIDAuMzEzOTI1
XSBwY2kgMDAwMDowNTowMC4wOiByZWcgMTA6IFtpbyAgMHhkYzAwLTB4ZGMwN10NClsgICAg
MC4zMTM5MzJdIHBjaSAwMDAwOjA1OjAwLjA6IHJlZyAxNDogW2lvICAweGQ4ODAtMHhkODgz
XQ0KWyAgICAwLjMxMzkzOV0gcGNpIDAwMDA6MDU6MDAuMDogcmVnIDE4OiBbaW8gIDB4ZDgw
MC0weGQ4MDddDQpbICAgIDAuMzEzOTQ1XSBwY2kgMDAwMDowNTowMC4wOiByZWcgMWM6IFtp
byAgMHhkNDgwLTB4ZDQ4M10NClsgICAgMC4zMTM5NTJdIHBjaSAwMDAwOjA1OjAwLjA6IHJl
ZyAyMDogW2lvICAweGQ0MDAtMHhkNDBmXQ0KWyAgICAwLjMxMzk1OV0gcGNpIDAwMDA6MDU6
MDAuMDogcmVnIDI0OiBbbWVtIDB4ZmVhZmYwMDAtMHhmZWFmZjFmZl0NClsgICAgMC4zMTM5
OTRdIHBjaSAwMDAwOjA1OjAwLjA6IHN1cHBvcnRzIEQxDQpbICAgIDAuMzEzOTk1XSBwY2kg
MDAwMDowNTowMC4wOiBQTUUjIHN1cHBvcnRlZCBmcm9tIEQwIEQxIEQzaG90DQpbICAgIDAu
MzE0MDAyXSBwY2kgMDAwMDowNTowMC4wOiBQTUUjIGRpc2FibGVkDQpbICAgIDAuMzE0MDE1
XSBwY2kgMDAwMDowMDoxYy40OiBQQ0kgYnJpZGdlIHRvIFtidXMgMDUtMDVdDQpbICAgIDAu
MzE0MjAyXSBwY2kgMDAwMDowMDoxYy40OiAgIGJyaWRnZSB3aW5kb3cgW2lvICAweGQwMDAt
MHhkZmZmXQ0KWyAgICAwLjMxNDIwNV0gcGNpIDAwMDA6MDA6MWMuNDogICBicmlkZ2Ugd2lu
ZG93IFttZW0gMHhmZWEwMDAwMC0weGZlYWZmZmZmXQ0KWyAgICAwLjMxNDIxMF0gcGNpIDAw
MDA6MDA6MWMuNDogICBicmlkZ2Ugd2luZG93IFttZW0gMHhmZmYwMDAwMCAtIDAwMGZmZmZm
IHByZWZdIHJlZyByZWFkaW5nDQpbICAgIDAuMzE0MjQ2XSBwY2kgMDAwMDowNzowMC4wOiBy
ZWcgMTA6IFttZW0gMHhmZDgwMDAwMC0weGZkZmZmZmZmIHByZWZdDQpbICAgIDAuMzE0MjUx
XSBwY2kgMDAwMDowNzowMC4wOiByZWcgMTQ6IFttZW0gMHhmZWJmMDAwMC0weGZlYmZmZmZm
XQ0KWyAgICAwLjMxNDI1N10gcGNpIDAwMDA6MDc6MDAuMDogcmVnIDE4OiBbaW8gIDB4ZWMw
MC0weGVjN2ZdDQpbICAgIDAuMzE0Mjc1XSBwY2kgMDAwMDowNzowMC4wOiByZWcgMzA6IFtt
ZW0gMHhmZWJlMDAwMC0weGZlYmVmZmZmIHByZWZdDQpbICAgIDAuMzE0MjkwXSBwY2kgMDAw
MDowNzowMC4wOiBzdXBwb3J0cyBEMg0KWyAgICAwLjMxNDMxNl0gcGNpIDAwMDA6MDc6MDMu
MDogcmVnIDEwOiBbbWVtIDB4ZmViZGYwMDAtMHhmZWJkZmZmZl0NClsgICAgMC4zMTQzNTRd
IHBjaSAwMDAwOjA3OjAzLjA6IHN1cHBvcnRzIEQxIEQyDQpbICAgIDAuMzE0MzU1XSBwY2kg
MDAwMDowNzowMy4wOiBQTUUjIHN1cHBvcnRlZCBmcm9tIEQwIEQxIEQyIEQzaG90DQpbICAg
IDAuMzE0MzU5XSBwY2kgMDAwMDowNzowMy4wOiBQTUUjIGRpc2FibGVkDQpbICAgIDAuMzE0
Mzk0XSBwY2kgMDAwMDowMDoxZS4wOiBQQ0kgYnJpZGdlIHRvIFtidXMgMDctMDddIChzdWJ0
cmFjdGl2ZSBkZWNvZGUpDQpbICAgIDAuMzE0NTc5XSBwY2kgMDAwMDowMDoxZS4wOiAgIGJy
aWRnZSB3aW5kb3cgW2lvICAweGUwMDAtMHhlZmZmXQ0KWyAgICAwLjMxNDU4Ml0gcGNpIDAw
MDA6MDA6MWUuMDogICBicmlkZ2Ugd2luZG93IFttZW0gMHhmZWIwMDAwMC0weGZlYmZmZmZm
XQ0KWyAgICAwLjMxNDU4N10gcGNpIDAwMDA6MDA6MWUuMDogICBicmlkZ2Ugd2luZG93IFtt
ZW0gMHhmZDgwMDAwMC0weGZkZmZmZmZmIDY0Yml0IHByZWZdDQpbICAgIDAuMzE0NTg5XSBw
Y2kgMDAwMDowMDoxZS4wOiAgIGJyaWRnZSB3aW5kb3cgW2lvICAweDAwMDAtMHgwY2Y3XSAo
c3VidHJhY3RpdmUgZGVjb2RlKQ0KWyAgICAwLjMxNDU5MV0gcGNpIDAwMDA6MDA6MWUuMDog
ICBicmlkZ2Ugd2luZG93IFtpbyAgMHgwZDAwLTB4ZmZmZl0gKHN1YnRyYWN0aXZlIGRlY29k
ZSkNClsgICAgMC4zMTQ1OTNdIHBjaSAwMDAwOjAwOjFlLjA6ICAgYnJpZGdlIHdpbmRvdyBb
bWVtIDB4MDAwYTAwMDAtMHgwMDBiZmZmZl0gKHN1YnRyYWN0aXZlIGRlY29kZSkNClsgICAg
MC4zMTQ1OTVdIHBjaSAwMDAwOjAwOjFlLjA6ICAgYnJpZGdlIHdpbmRvdyBbbWVtIDB4MDAw
ZDAwMDAtMHgwMDBkZmZmZl0gKHN1YnRyYWN0aXZlIGRlY29kZSkNClsgICAgMC4zMTQ1OTdd
IHBjaSAwMDAwOjAwOjFlLjA6ICAgYnJpZGdlIHdpbmRvdyBbbWVtIDB4N2NjMDAwMDAtMHhk
ZmZmZmZmZl0gKHN1YnRyYWN0aXZlIGRlY29kZSkNClsgICAgMC4zMTQ1OTldIHBjaSAwMDAw
OjAwOjFlLjA6ICAgYnJpZGdlIHdpbmRvdyBbbWVtIDB4ZjAwMDAwMDAtMHhmZmZmZmZmZl0g
KHN1YnRyYWN0aXZlIGRlY29kZSkNClsgICAgMC4zMTQ2MTJdIHBjaV9idXMgMDAwMDowMDog
b24gTlVNQSBub2RlIDANClsgICAgMC4zMTQ2MTZdIEFDUEk6IFBDSSBJbnRlcnJ1cHQgUm91
dGluZyBUYWJsZSBbXF9TQl8uUENJMC5fUFJUXQ0KWyAgICAwLjMxNDc2MF0gQUNQSTogUENJ
IEludGVycnVwdCBSb3V0aW5nIFRhYmxlIFtcX1NCXy5QQ0kwLlAwUDEuX1BSVF0NClsgICAg
MC4zMTQ4NDZdIEFDUEk6IFBDSSBJbnRlcnJ1cHQgUm91dGluZyBUYWJsZSBbXF9TQl8uUENJ
MC5QMFA0Ll9QUlRdDQpbICAgIDAuMzE0OTAzXSBBQ1BJOiBQQ0kgSW50ZXJydXB0IFJvdXRp
bmcgVGFibGUgW1xfU0JfLlBDSTAuUDBQOC5fUFJUXQ0KWyAgICAwLjMxNDk4M10gQUNQSTog
UENJIEludGVycnVwdCBSb3V0aW5nIFRhYmxlIFtcX1NCXy5QQ0kwLlAwUDIuX1BSVF0NClsg
ICAgMC4zMzUwNzhdIEFDUEk6IFBDSSBJbnRlcnJ1cHQgTGluayBbTE5LQV0gKElSUXMgMyA0
IDUgNiA3ICoxMCAxMSAxMiAxNCAxNSkNClsgICAgMC4zMzU1NjddIEFDUEk6IFBDSSBJbnRl
cnJ1cHQgTGluayBbTE5LQl0gKElSUXMgMyA0IDUgNiA3IDEwICoxMSAxMiAxNCAxNSkNClsg
ICAgMC4zMzYwOTFdIEFDUEk6IFBDSSBJbnRlcnJ1cHQgTGluayBbTE5LQ10gKElSUXMgMyA0
ICo1IDYgNyAxMCAxMSAxMiAxNCAxNSkNClsgICAgMC4zMzY3NDRdIEFDUEk6IFBDSSBJbnRl
cnJ1cHQgTGluayBbTE5LRF0gKElSUXMgMyA0ICo1IDYgNyAxMCAxMSAxMiAxNCAxNSkNClsg
ICAgMC4zMzc1MTJdIEFDUEk6IFBDSSBJbnRlcnJ1cHQgTGluayBbTE5LRV0gKElSUXMgKjMg
NCA1IDYgNyAxMCAxMSAxMiAxNCAxNSkNClsgICAgMC4zMzgwOTBdIEFDUEk6IFBDSSBJbnRl
cnJ1cHQgTGluayBbTE5LRl0gKElSUXMgMyA0IDUgNiAqNyAxMCAxMSAxMiAxNCAxNSkNClsg
ICAgMC4zMzg3NDZdIEFDUEk6IFBDSSBJbnRlcnJ1cHQgTGluayBbTE5LR10gKElSUXMgMyA0
IDUgNiA3ICoxMCAxMSAxMiAxNCAxNSkNClsgICAgMC4zMzk0NzVdIEFDUEk6IFBDSSBJbnRl
cnJ1cHQgTGluayBbTE5LSF0gKElSUXMgMyA0IDUgNiA3IDEwICoxMSAxMiAxNCAxNSkNClsg
ICAgMC4zNDAwNDBdIHZnYWFyYjogZGV2aWNlIGFkZGVkOiBQQ0k6MDAwMDowNzowMC4wLGRl
Y29kZXM9aW8rbWVtLG93bnM9aW8rbWVtLGxvY2tzPW5vbmUNClsgICAgMC4zNDAzODFdIHZn
YWFyYjogbG9hZGVkDQpbICAgIDAuMzQxMDI2XSBTQ1NJIHN1YnN5c3RlbSBpbml0aWFsaXpl
ZA0KWyAgICAwLjM0MTIwMl0gbGliYXRhIHZlcnNpb24gMy4wMCBsb2FkZWQuDQpbICAgIDAu
MzQyMDQ4XSB1c2Jjb3JlOiByZWdpc3RlcmVkIG5ldyBpbnRlcmZhY2UgZHJpdmVyIHVzYmZz
DQpbICAgIDAuMzQyMDQ4XSB1c2Jjb3JlOiByZWdpc3RlcmVkIG5ldyBpbnRlcmZhY2UgZHJp
dmVyIGh1Yg0KWyAgICAwLjM0MjIwMF0gdXNiY29yZTogcmVnaXN0ZXJlZCBuZXcgZGV2aWNl
IGRyaXZlciB1c2INClsgICAgMC4zNDMwMjVdIEFkdmFuY2VkIExpbnV4IFNvdW5kIEFyY2hp
dGVjdHVyZSBEcml2ZXIgVmVyc2lvbiAxLjAuMjIuMS4NClsgICAgMC4zNDMyMDVdIFBDSTog
VXNpbmcgQUNQSSBmb3IgSVJRIHJvdXRpbmcNClsgICAgMC4zNDMzODldIFBDSTogcGNpX2Nh
Y2hlX2xpbmVfc2l6ZSBzZXQgdG8gNjQgYnl0ZXMNClsgICAgMC4zNDM0OTRdIHJlc2VydmUg
UkFNIGJ1ZmZlcjogMDAwMDAwMDAwMDA5ZjQwMCAtIDAwMDAwMDAwMDAwOWZmZmYgDQpbICAg
IDAuMzQzNDk2XSByZXNlcnZlIFJBTSBidWZmZXI6IDAwMDAwMDAwN2NiNzAwMDAgLSAwMDAw
MDAwMDdmZmZmZmZmIA0KWyAgICAwLjM0NDA0Ml0gY2ZnODAyMTE6IENhbGxpbmcgQ1JEQSB0
byB1cGRhdGUgd29ybGQgcmVndWxhdG9yeSBkb21haW4NClsgICAgMC4zNDQwNDJdIE5ldExh
YmVsOiBJbml0aWFsaXppbmcNClsgICAgMC4zNDQxNzldIE5ldExhYmVsOiAgZG9tYWluIGhh
c2ggc2l6ZSA9IDEyOA0KWyAgICAwLjM0NDM3Nl0gTmV0TGFiZWw6ICBwcm90b2NvbHMgPSBV
TkxBQkVMRUQgQ0lQU092NA0KWyAgICAwLjM0NDU2NF0gTmV0TGFiZWw6ICB1bmxhYmVsZWQg
dHJhZmZpYyBhbGxvd2VkIGJ5IGRlZmF1bHQNClsgICAgMC4zNDUwNTBdICAgYWxsb2MgaXJx
X2Rlc2MgZm9yIDI0IG9uIG5vZGUgMA0KWyAgICAwLjM0NTA1MV0gICBhbGxvYyBrc3RhdF9p
cnFzIG9uIG5vZGUgMA0KWyAgICAwLjM0NTA1N10gICBhbGxvYyBpcnFfZGVzYyBmb3IgMjUg
b24gbm9kZSAwDQpbICAgIDAuMzQ1MDU4XSAgIGFsbG9jIGtzdGF0X2lycXMgb24gbm9kZSAw
DQpbICAgIDAuMzQ1MDYyXSAgIGFsbG9jIGlycV9kZXNjIGZvciAyNiBvbiBub2RlIDANClsg
ICAgMC4zNDUwNjNdICAgYWxsb2Mga3N0YXRfaXJxcyBvbiBub2RlIDANClsgICAgMC4zNDUw
NjddICAgYWxsb2MgaXJxX2Rlc2MgZm9yIDI3IG9uIG5vZGUgMA0KWyAgICAwLjM0NTA2OF0g
ICBhbGxvYyBrc3RhdF9pcnFzIG9uIG5vZGUgMA0KWyAgICAwLjM0NTA3MF0gSFBFVDogOCB0
aW1lcnMgaW4gdG90YWwsIDQgdGltZXJzIHdpbGwgYmUgdXNlZCBmb3IgcGVyLWNwdSB0aW1l
cg0KWyAgICAwLjM0NTI2NV0gaHBldDA6IGF0IE1NSU8gMHhmZWQwMDAwMCwgSVJRcyAyLCA4
LCAyNCwgMjUsIDI2LCAyNywgMCwgMA0KWyAgICAwLjM0NTc0NV0gaHBldDA6IDggY29tcGFy
YXRvcnMsIDY0LWJpdCAxNC4zMTgxODAgTUh6IGNvdW50ZXINClsgICAgMC4zNDkwMjBdIGhw
ZXQ6IGhwZXQyIGlycSAyNCBmb3IgTVNJDQpbICAgIDAuMzUwMDE3XSBocGV0OiBocGV0MyBp
cnEgMjUgZm9yIE1TSQ0KWyAgICAwLjQxNDAyMF0gaHBldDogaHBldDQgaXJxIDI2IGZvciBN
U0kNClsgICAgMC41NTIwMjVdIGhwZXQ6IGhwZXQ1IGlycSAyNyBmb3IgTVNJDQpbICAgIDAu
NTU3MDAzXSBTd2l0Y2hpbmcgdG8gY2xvY2tzb3VyY2UgdHNjDQpbICAgIDAuNTcwNzIzXSBw
bnA6IFBuUCBBQ1BJIGluaXQNClsgICAgMC41NzA4NjddIEFDUEk6IGJ1cyB0eXBlIHBucCBy
ZWdpc3RlcmVkDQpbICAgIDAuNTc0OTY5XSBwbnA6IFBuUCBBQ1BJOiBmb3VuZCAxOCBkZXZp
Y2VzDQpbICAgIDAuNTc1MTcyXSBBQ1BJOiBBQ1BJIGJ1cyB0eXBlIHBucCB1bnJlZ2lzdGVy
ZWQNClsgICAgMC41NzUzNjNdIHN5c3RlbSAwMDowMTogW21lbSAweGZlZDE0MDAwLTB4ZmVk
MTlmZmZdIGNvdWxkIG5vdCBiZSByZXNlcnZlZA0KWyAgICAwLjU3NTU1M10gc3lzdGVtIDAw
OjAxOiBbbWVtIDB4ZmVkOTAwMDAtMHhmZWQ5M2ZmZl0gaGFzIGJlZW4gcmVzZXJ2ZWQNClsg
ICAgMC41NzU3NDZdIHN5c3RlbSAwMDowNzogW2lvICAweDAyOTAtMHgwMjlmXSBoYXMgYmVl
biByZXNlcnZlZA0KWyAgICAwLjU3NTkzNl0gc3lzdGVtIDAwOjA4OiBbaW8gIDB4MDRkMC0w
eDA0ZDFdIGhhcyBiZWVuIHJlc2VydmVkDQpbICAgIDAuNTc2MTQ1XSBzeXN0ZW0gMDA6MDg6
IFtpbyAgMHgwODAwLTB4MDg3Zl0gaGFzIGJlZW4gcmVzZXJ2ZWQNClsgICAgMC41NzYzMjdd
IHN5c3RlbSAwMDowODogW2lvICAweDA1MDAtMHgwNTdmXSBoYXMgYmVlbiByZXNlcnZlZA0K
WyAgICAwLjU3NjUxMF0gc3lzdGVtIDAwOjA4OiBbbWVtIDB4ZmVkMDgwMDAtMHhmZWQwOGZm
Zl0gaGFzIGJlZW4gcmVzZXJ2ZWQNClsgICAgMC41NzY2OTNdIHN5c3RlbSAwMDowODogW21l
bSAweGZlZDFjMDAwLTB4ZmVkMWZmZmZdIGhhcyBiZWVuIHJlc2VydmVkDQpbICAgIDAuNTc2
ODc3XSBzeXN0ZW0gMDA6MDg6IFttZW0gMHhmZWQyMDAwMC0weGZlZDNmZmZmXSBoYXMgYmVl
biByZXNlcnZlZA0KWyAgICAwLjU3NzA4MV0gc3lzdGVtIDAwOjA4OiBbbWVtIDB4ZmVkNTAw
MDAtMHhmZWQ4ZmZmZl0gaGFzIGJlZW4gcmVzZXJ2ZWQNClsgICAgMC41NzcyNjhdIHN5c3Rl
bSAwMDowYjogW21lbSAweGZmYzAwMDAwLTB4ZmZkZmZmZmZdIGhhcyBiZWVuIHJlc2VydmVk
DQpbICAgIDAuNTc3NDU0XSBzeXN0ZW0gMDA6MGQ6IFttZW0gMHhmZWMwMDAwMC0weGZlYzAw
ZmZmXSBjb3VsZCBub3QgYmUgcmVzZXJ2ZWQNClsgICAgMC41Nzc2MzhdIHN5c3RlbSAwMDow
ZDogW21lbSAweGZlZTAwMDAwLTB4ZmVlMDBmZmZdIGhhcyBiZWVuIHJlc2VydmVkDQpbICAg
IDAuNTc3ODI2XSBzeXN0ZW0gMDA6MTA6IFttZW0gMHhlMDAwMDAwMC0weGVmZmZmZmZmXSBo
YXMgYmVlbiByZXNlcnZlZA0KWyAgICAwLjU3ODAzNl0gc3lzdGVtIDAwOjExOiBbbWVtIDB4
MDAwMDAwMDAtMHgwMDA5ZmZmZl0gY291bGQgbm90IGJlIHJlc2VydmVkDQpbICAgIDAuNTc4
MjI2XSBzeXN0ZW0gMDA6MTE6IFttZW0gMHgwMDBjMDAwMC0weDAwMGNmZmZmXSBoYXMgYmVl
biByZXNlcnZlZA0KWyAgICAwLjU3ODQxN10gc3lzdGVtIDAwOjExOiBbbWVtIDB4MDAwZTAw
MDAtMHgwMDBmZmZmZl0gY291bGQgbm90IGJlIHJlc2VydmVkDQpbICAgIDAuNTc4NjA3XSBz
eXN0ZW0gMDA6MTE6IFttZW0gMHgwMDEwMDAwMC0weDdjYmZmZmZmXSBjb3VsZCBub3QgYmUg
cmVzZXJ2ZWQNClsgICAgMC41Nzg4MDFdIHN5c3RlbSAwMDoxMTogW21lbSAweGUwMDAwMDAw
LTB4ZmZmZmZmZmZdIGNvdWxkIG5vdCBiZSByZXNlcnZlZA0KWyAgICAwLjU4NDI1Nl0gUENJ
OiBtYXggYnVzIGRlcHRoOiAzIHBjaV90cnlfbnVtOiA0DQpbICAgIDAuNTg0MjkzXSBwY2kg
MDAwMDowMjowMS4wOiBQQ0kgYnJpZGdlIHRvIFtidXMgMDMtMDNdDQpbICAgIDAuNTg0NDgw
XSBwY2kgMDAwMDowMjowMS4wOiAgIGJyaWRnZSB3aW5kb3cgW2lvICBkaXNhYmxlZF0NClsg
ICAgMC41ODQ2NjldIHBjaSAwMDAwOjAyOjAxLjA6ICAgYnJpZGdlIHdpbmRvdyBbbWVtIDB4
ZmU4MDAwMDAtMHhmZThmZmZmZl0NClsgICAgMC41ODQ4NjBdIHBjaSAwMDAwOjAyOjAxLjA6
ICAgYnJpZGdlIHdpbmRvdyBbbWVtIHByZWYgZGlzYWJsZWRdDQpbICAgIDAuNTg1MDczXSBw
Y2kgMDAwMDowMjowMi4wOiBQQ0kgYnJpZGdlIHRvIFtidXMgMDQtMDRdDQpbICAgIDAuNTg1
MjY1XSBwY2kgMDAwMDowMjowMi4wOiAgIGJyaWRnZSB3aW5kb3cgW2lvICAweGMwMDAtMHhj
ZmZmXQ0KWyAgICAwLjU4NTQ1OF0gcGNpIDAwMDA6MDI6MDIuMDogICBicmlkZ2Ugd2luZG93
IFttZW0gMHhmZTkwMDAwMC0weGZlOWZmZmZmXQ0KWyAgICAwLjU4NTY0OV0gcGNpIDAwMDA6
MDI6MDIuMDogICBicmlkZ2Ugd2luZG93IFttZW0gcHJlZiBkaXNhYmxlZF0NClsgICAgMC41
ODU4MzldIHBjaSAwMDAwOjAxOjAwLjA6IFBDSSBicmlkZ2UgdG8gW2J1cyAwMi0wNF0NClsg
ICAgMC41ODYwNDRdIHBjaSAwMDAwOjAxOjAwLjA6ICAgYnJpZGdlIHdpbmRvdyBbaW8gIDB4
YzAwMC0weGNmZmZdDQpbICAgIDAuNTg2MjM0XSBwY2kgMDAwMDowMTowMC4wOiAgIGJyaWRn
ZSB3aW5kb3cgW21lbSAweGZlODAwMDAwLTB4ZmU5ZmZmZmZdDQpbICAgIDAuNTg2NDI1XSBw
Y2kgMDAwMDowMTowMC4wOiAgIGJyaWRnZSB3aW5kb3cgW21lbSBwcmVmIGRpc2FibGVkXQ0K
WyAgICAwLjU4NjYyMV0gcGNpIDAwMDA6MDA6MDEuMDogUENJIGJyaWRnZSB0byBbYnVzIDAx
LTA0XQ0KWyAgICAwLjU4NjgwOV0gcGNpIDAwMDA6MDA6MDEuMDogICBicmlkZ2Ugd2luZG93
IFtpbyAgMHhjMDAwLTB4Y2ZmZl0NClsgICAgMC41ODcwMDldIHBjaSAwMDAwOjAwOjAxLjA6
ICAgYnJpZGdlIHdpbmRvdyBbbWVtIDB4ZmU3MDAwMDAtMHhmZTlmZmZmZl0NClsgICAgMC41
ODcyMDVdIHBjaSAwMDAwOjAwOjAxLjA6ICAgYnJpZGdlIHdpbmRvdyBbbWVtIHByZWYgZGlz
YWJsZWRdDQpbICAgIDAuNTg3Mzk1XSBwY2kgMDAwMDowMDoxYy4wOiBQQ0kgYnJpZGdlIHRv
IFtidXMgMDYtMDZdDQpbICAgIDAuNTg3NTgxXSBwY2kgMDAwMDowMDoxYy4wOiAgIGJyaWRn
ZSB3aW5kb3cgW2lvICBkaXNhYmxlZF0NClsgICAgMC41ODc3NzBdIHBjaSAwMDAwOjAwOjFj
LjA6ICAgYnJpZGdlIHdpbmRvdyBbbWVtIGRpc2FibGVkXQ0KWyAgICAwLjU4Nzk1OF0gcGNp
IDAwMDA6MDA6MWMuMDogICBicmlkZ2Ugd2luZG93IFttZW0gMHhmZDcwMDAwMC0weGZkN2Zm
ZmZmIDY0Yml0IHByZWZdDQpbICAgIDAuNTg4MzE3XSBwY2kgMDAwMDowMDoxYy40OiBQQ0kg
YnJpZGdlIHRvIFtidXMgMDUtMDVdDQpbICAgIDAuNTg4NTA0XSBwY2kgMDAwMDowMDoxYy40
OiAgIGJyaWRnZSB3aW5kb3cgW2lvICAweGQwMDAtMHhkZmZmXQ0KWyAgICAwLjU4ODY5NF0g
cGNpIDAwMDA6MDA6MWMuNDogICBicmlkZ2Ugd2luZG93IFttZW0gMHhmZWEwMDAwMC0weGZl
YWZmZmZmXQ0KWyAgICAwLjU4ODg4NV0gcGNpIDAwMDA6MDA6MWMuNDogICBicmlkZ2Ugd2lu
ZG93IFttZW0gcHJlZiBkaXNhYmxlZF0NClsgICAgMC41ODkwOThdIHBjaSAwMDAwOjAwOjFl
LjA6IFBDSSBicmlkZ2UgdG8gW2J1cyAwNy0wN10NClsgICAgMC41ODkyODhdIHBjaSAwMDAw
OjAwOjFlLjA6ICAgYnJpZGdlIHdpbmRvdyBbaW8gIDB4ZTAwMC0weGVmZmZdDQpbICAgIDAu
NTg5NDgwXSBwY2kgMDAwMDowMDoxZS4wOiAgIGJyaWRnZSB3aW5kb3cgW21lbSAweGZlYjAw
MDAwLTB4ZmViZmZmZmZdDQpbICAgIDAuNTg5NjcxXSBwY2kgMDAwMDowMDoxZS4wOiAgIGJy
aWRnZSB3aW5kb3cgW21lbSAweGZkODAwMDAwLTB4ZmRmZmZmZmYgNjRiaXQgcHJlZl0NClsg
ICAgMC41OTAwMzJdICAgYWxsb2MgaXJxX2Rlc2MgZm9yIDE2IG9uIG5vZGUgLTENClsgICAg
MC41OTAwMzRdICAgYWxsb2Mga3N0YXRfaXJxcyBvbiBub2RlIC0xDQpbICAgIDAuNTkwMDM4
XSBwY2kgMDAwMDowMDowMS4wOiBQQ0kgSU5UIEEgLT4gR1NJIDE2IChsZXZlbCwgbG93KSAt
PiBJUlEgMTYNClsgICAgMC41OTAyMjldIHBjaSAwMDAwOjAwOjAxLjA6IHNldHRpbmcgbGF0
ZW5jeSB0aW1lciB0byA2NA0KWyAgICAwLjU5MDIzNV0gcGNpIDAwMDA6MDE6MDAuMDogUENJ
IElOVCBBIC0+IEdTSSAxNiAobGV2ZWwsIGxvdykgLT4gSVJRIDE2DQpbICAgIDAuNTkwNDI2
XSBwY2kgMDAwMDowMTowMC4wOiBzZXR0aW5nIGxhdGVuY3kgdGltZXIgdG8gNjQNClsgICAg
MC41OTA0MzFdICAgYWxsb2MgaXJxX2Rlc2MgZm9yIDE3IG9uIG5vZGUgLTENClsgICAgMC41
OTA0MzNdICAgYWxsb2Mga3N0YXRfaXJxcyBvbiBub2RlIC0xDQpbICAgIDAuNTkwNDM1XSBw
Y2kgMDAwMDowMjowMS4wOiBQQ0kgSU5UIEEgLT4gR1NJIDE3IChsZXZlbCwgbG93KSAtPiBJ
UlEgMTcNClsgICAgMC41OTA2MjBdIHBjaSAwMDAwOjAyOjAxLjA6IHNldHRpbmcgbGF0ZW5j
eSB0aW1lciB0byA2NA0KWyAgICAwLjU5MDYyNl0gICBhbGxvYyBpcnFfZGVzYyBmb3IgMTgg
b24gbm9kZSAtMQ0KWyAgICAwLjU5MDYyN10gICBhbGxvYyBrc3RhdF9pcnFzIG9uIG5vZGUg
LTENClsgICAgMC41OTA2MzBdIHBjaSAwMDAwOjAyOjAyLjA6IFBDSSBJTlQgQSAtPiBHU0kg
MTggKGxldmVsLCBsb3cpIC0+IElSUSAxOA0KWyAgICAwLjU5MDgxNF0gcGNpIDAwMDA6MDI6
MDIuMDogc2V0dGluZyBsYXRlbmN5IHRpbWVyIHRvIDY0DQpbICAgIDAuNTkwODIwXSBwY2kg
MDAwMDowMDoxYy4wOiBQQ0kgSU5UIEEgLT4gR1NJIDE3IChsZXZlbCwgbG93KSAtPiBJUlEg
MTcNClsgICAgMC41OTEwMjRdIHBjaSAwMDAwOjAwOjFjLjA6IHNldHRpbmcgbGF0ZW5jeSB0
aW1lciB0byA2NA0KWyAgICAwLjU5MTAzMF0gcGNpIDAwMDA6MDA6MWMuNDogUENJIElOVCBB
IC0+IEdTSSAxNyAobGV2ZWwsIGxvdykgLT4gSVJRIDE3DQpbICAgIDAuNTkxMjE0XSBwY2kg
MDAwMDowMDoxYy40OiBzZXR0aW5nIGxhdGVuY3kgdGltZXIgdG8gNjQNClsgICAgMC41OTEy
MTldIHBjaSAwMDAwOjAwOjFlLjA6IHNldHRpbmcgbGF0ZW5jeSB0aW1lciB0byA2NA0KWyAg
ICAwLjU5MTIyMl0gcGNpX2J1cyAwMDAwOjAwOiByZXNvdXJjZSA0IFtpbyAgMHgwMDAwLTB4
MGNmN10NClsgICAgMC41OTEyMjRdIHBjaV9idXMgMDAwMDowMDogcmVzb3VyY2UgNSBbaW8g
IDB4MGQwMC0weGZmZmZdDQpbICAgIDAuNTkxMjI2XSBwY2lfYnVzIDAwMDA6MDA6IHJlc291
cmNlIDYgW21lbSAweDAwMGEwMDAwLTB4MDAwYmZmZmZdDQpbICAgIDAuNTkxMjI4XSBwY2lf
YnVzIDAwMDA6MDA6IHJlc291cmNlIDcgW21lbSAweDAwMGQwMDAwLTB4MDAwZGZmZmZdDQpb
ICAgIDAuNTkxMjMwXSBwY2lfYnVzIDAwMDA6MDA6IHJlc291cmNlIDggW21lbSAweDdjYzAw
MDAwLTB4ZGZmZmZmZmZdDQpbICAgIDAuNTkxMjMyXSBwY2lfYnVzIDAwMDA6MDA6IHJlc291
cmNlIDkgW21lbSAweGYwMDAwMDAwLTB4ZmZmZmZmZmZdDQpbICAgIDAuNTkxMjM0XSBwY2lf
YnVzIDAwMDA6MDE6IHJlc291cmNlIDAgW2lvICAweGMwMDAtMHhjZmZmXQ0KWyAgICAwLjU5
MTIzNV0gcGNpX2J1cyAwMDAwOjAxOiByZXNvdXJjZSAxIFttZW0gMHhmZTcwMDAwMC0weGZl
OWZmZmZmXQ0KWyAgICAwLjU5MTIzN10gcGNpX2J1cyAwMDAwOjAyOiByZXNvdXJjZSAwIFtp
byAgMHhjMDAwLTB4Y2ZmZl0NClsgICAgMC41OTEyMzldIHBjaV9idXMgMDAwMDowMjogcmVz
b3VyY2UgMSBbbWVtIDB4ZmU4MDAwMDAtMHhmZTlmZmZmZl0NClsgICAgMC41OTEyNDFdIHBj
aV9idXMgMDAwMDowMzogcmVzb3VyY2UgMSBbbWVtIDB4ZmU4MDAwMDAtMHhmZThmZmZmZl0N
ClsgICAgMC41OTEyNDJdIHBjaV9idXMgMDAwMDowNDogcmVzb3VyY2UgMCBbaW8gIDB4YzAw
MC0weGNmZmZdDQpbICAgIDAuNTkxMjQ0XSBwY2lfYnVzIDAwMDA6MDQ6IHJlc291cmNlIDEg
W21lbSAweGZlOTAwMDAwLTB4ZmU5ZmZmZmZdDQpbICAgIDAuNTkxMjQ2XSBwY2lfYnVzIDAw
MDA6MDY6IHJlc291cmNlIDIgW21lbSAweGZkNzAwMDAwLTB4ZmQ3ZmZmZmYgNjRiaXQgcHJl
Zl0NClsgICAgMC41OTEyNDhdIHBjaV9idXMgMDAwMDowNTogcmVzb3VyY2UgMCBbaW8gIDB4
ZDAwMC0weGRmZmZdDQpbICAgIDAuNTkxMjQ5XSBwY2lfYnVzIDAwMDA6MDU6IHJlc291cmNl
IDEgW21lbSAweGZlYTAwMDAwLTB4ZmVhZmZmZmZdDQpbICAgIDAuNTkxMjUxXSBwY2lfYnVz
IDAwMDA6MDc6IHJlc291cmNlIDAgW2lvICAweGUwMDAtMHhlZmZmXQ0KWyAgICAwLjU5MTI1
M10gcGNpX2J1cyAwMDAwOjA3OiByZXNvdXJjZSAxIFttZW0gMHhmZWIwMDAwMC0weGZlYmZm
ZmZmXQ0KWyAgICAwLjU5MTI1NV0gcGNpX2J1cyAwMDAwOjA3OiByZXNvdXJjZSAyIFttZW0g
MHhmZDgwMDAwMC0weGZkZmZmZmZmIDY0Yml0IHByZWZdDQpbICAgIDAuNTkxMjU3XSBwY2lf
YnVzIDAwMDA6MDc6IHJlc291cmNlIDQgW2lvICAweDAwMDAtMHgwY2Y3XQ0KWyAgICAwLjU5
MTI1OF0gcGNpX2J1cyAwMDAwOjA3OiByZXNvdXJjZSA1IFtpbyAgMHgwZDAwLTB4ZmZmZl0N
ClsgICAgMC41OTEyNjBdIHBjaV9idXMgMDAwMDowNzogcmVzb3VyY2UgNiBbbWVtIDB4MDAw
YTAwMDAtMHgwMDBiZmZmZl0NClsgICAgMC41OTEyNjJdIHBjaV9idXMgMDAwMDowNzogcmVz
b3VyY2UgNyBbbWVtIDB4MDAwZDAwMDAtMHgwMDBkZmZmZl0NClsgICAgMC41OTEyNjNdIHBj
aV9idXMgMDAwMDowNzogcmVzb3VyY2UgOCBbbWVtIDB4N2NjMDAwMDAtMHhkZmZmZmZmZl0N
ClsgICAgMC41OTEyNjVdIHBjaV9idXMgMDAwMDowNzogcmVzb3VyY2UgOSBbbWVtIDB4ZjAw
MDAwMDAtMHhmZmZmZmZmZl0NClsgICAgMC41OTEyODZdIE5FVDogUmVnaXN0ZXJlZCBwcm90
b2NvbCBmYW1pbHkgMg0KWyAgICAwLjU5MTUwMV0gSVAgcm91dGUgY2FjaGUgaGFzaCB0YWJs
ZSBlbnRyaWVzOiA2NTUzNiAob3JkZXI6IDcsIDUyNDI4OCBieXRlcykNClsgICAgMC41OTE5
NDddIFRDUCBlc3RhYmxpc2hlZCBoYXNoIHRhYmxlIGVudHJpZXM6IDI2MjE0NCAob3JkZXI6
IDEwLCA0MTk0MzA0IGJ5dGVzKQ0KWyAgICAwLjU5Mzg3Nl0gVENQIGJpbmQgaGFzaCB0YWJs
ZSBlbnRyaWVzOiA2NTUzNiAob3JkZXI6IDgsIDEwNDg1NzYgYnl0ZXMpDQpbICAgIDAuNTk0
NTc3XSBUQ1A6IEhhc2ggdGFibGVzIGNvbmZpZ3VyZWQgKGVzdGFibGlzaGVkIDI2MjE0NCBi
aW5kIDY1NTM2KQ0KWyAgICAwLjU5NDc2N10gVENQIHJlbm8gcmVnaXN0ZXJlZA0KWyAgICAw
LjU5NDk1MF0gVURQIGhhc2ggdGFibGUgZW50cmllczogMTAyNCAob3JkZXI6IDMsIDMyNzY4
IGJ5dGVzKQ0KWyAgICAwLjU5NTE3M10gVURQLUxpdGUgaGFzaCB0YWJsZSBlbnRyaWVzOiAx
MDI0IChvcmRlcjogMywgMzI3NjggYnl0ZXMpDQpbICAgIDAuNTk1NDg4XSBORVQ6IFJlZ2lz
dGVyZWQgcHJvdG9jb2wgZmFtaWx5IDENClsgICAgMC41OTU4OThdIFJQQzogUmVnaXN0ZXJl
ZCB1ZHAgdHJhbnNwb3J0IG1vZHVsZS4NClsgICAgMC41OTYxMDldIFJQQzogUmVnaXN0ZXJl
ZCB0Y3AgdHJhbnNwb3J0IG1vZHVsZS4NClsgICAgMC41OTYyOTNdIFJQQzogUmVnaXN0ZXJl
ZCB0Y3AgTkZTdjQuMSBiYWNrY2hhbm5lbCB0cmFuc3BvcnQgbW9kdWxlLg0KWyAgICAwLjU5
NjUwNV0gcGNpIDAwMDA6MDA6MWEuMDogdWhjaV9jaGVja19hbmRfcmVzZXRfaGM6IGNtZCA9
IDB4MDAwMA0KWyAgICAwLjU5NjUwNl0gcGNpIDAwMDA6MDA6MWEuMDogUGVyZm9ybWluZyBm
dWxsIHJlc2V0DQpbICAgIDAuNTk2NTIyXSBwY2kgMDAwMDowMDoxYS4xOiB1aGNpX2NoZWNr
X2FuZF9yZXNldF9oYzogY21kID0gMHgwMDAwDQpbICAgIDAuNTk2NTIzXSBwY2kgMDAwMDow
MDoxYS4xOiBQZXJmb3JtaW5nIGZ1bGwgcmVzZXQNClsgICAgMC41OTY1MzhdIHBjaSAwMDAw
OjAwOjFhLjI6IHVoY2lfY2hlY2tfYW5kX3Jlc2V0X2hjOiBjbWQgPSAweDAwMDANClsgICAg
MC41OTY1NDBdIHBjaSAwMDAwOjAwOjFhLjI6IFBlcmZvcm1pbmcgZnVsbCByZXNldA0KWyAg
ICAwLjU5NjU5MF0gcGNpIDAwMDA6MDA6MWQuMDogdWhjaV9jaGVja19hbmRfcmVzZXRfaGM6
IGNtZCA9IDB4MDAwMA0KWyAgICAwLjU5NjU5MV0gcGNpIDAwMDA6MDA6MWQuMDogUGVyZm9y
bWluZyBmdWxsIHJlc2V0DQpbICAgIDAuNTk2NjA2XSBwY2kgMDAwMDowMDoxZC4xOiB1aGNp
X2NoZWNrX2FuZF9yZXNldF9oYzogY21kID0gMHgwMDAwDQpbICAgIDAuNTk2NjA4XSBwY2kg
MDAwMDowMDoxZC4xOiBQZXJmb3JtaW5nIGZ1bGwgcmVzZXQNClsgICAgMC41OTY2MjNdIHBj
aSAwMDAwOjAwOjFkLjI6IHVoY2lfY2hlY2tfYW5kX3Jlc2V0X2hjOiBjbWQgPSAweDAwMDAN
ClsgICAgMC41OTY2MjRdIHBjaSAwMDAwOjAwOjFkLjI6IFBlcmZvcm1pbmcgZnVsbCByZXNl
dA0KWyAgICAwLjU5NjY4MF0gcGNpIDAwMDA6MDc6MDAuMDogQm9vdCB2aWRlbyBkZXZpY2UN
ClsgICAgMC41OTY2ODVdIFBDSTogQ0xTIDMyIGJ5dGVzLCBkZWZhdWx0IDY0DQpbICAgIDAu
NTk2NzM5XSBUcnlpbmcgdG8gdW5wYWNrIHJvb3RmcyBpbWFnZSBhcyBpbml0cmFtZnMuLi4N
ClsgICAgMC42NDkyMDNdIEZyZWVpbmcgaW5pdHJkIG1lbW9yeTogMzExNmsgZnJlZWQNClsg
ICAgMC42NTA4MzNdIGt2bTogYWxyZWFkeSBsb2FkZWQgdGhlIG90aGVyIG1vZHVsZQ0KWyAg
ICAwLjY1MzIxMl0gbWljcm9jb2RlOiBDUFUwIHNpZz0weDEwNjdhLCBwZj0weDEwLCByZXZp
c2lvbj0weGEwNw0KWyAgICAwLjY1MzQxNl0gbWljcm9jb2RlOiBDUFUxIHNpZz0weDEwNjdh
LCBwZj0weDEwLCByZXZpc2lvbj0weGEwNw0KWyAgICAwLjY1MzYxOF0gbWljcm9jb2RlOiBD
UFUyIHNpZz0weDEwNjdhLCBwZj0weDEwLCByZXZpc2lvbj0weGEwNw0KWyAgICAwLjY1Mzgx
MF0gbWljcm9jb2RlOiBDUFUzIHNpZz0weDEwNjdhLCBwZj0weDEwLCByZXZpc2lvbj0weGEw
Nw0KWyAgICAwLjY1NDEyOF0gbWljcm9jb2RlOiBNaWNyb2NvZGUgVXBkYXRlIERyaXZlcjog
djIuMDAgPHRpZ3JhbkBhaXZhemlhbi5mc25ldC5jby51az4sIFBldGVyIE9ydWJhDQpbICAg
IDAuNjU0NDc3XSBTY2FubmluZyBmb3IgbG93IG1lbW9yeSBjb3JydXB0aW9uIGV2ZXJ5IDYw
IHNlY29uZHMNClsgICAgMC42NTQ5OTFdIGF1ZGl0OiBpbml0aWFsaXppbmcgbmV0bGluayBz
b2NrZXQgKGRpc2FibGVkKQ0KWyAgICAwLjY1NTIwN10gdHlwZT0yMDAwIGF1ZGl0KDEyNjg0
NDg4NTQuNjU1OjEpOiBpbml0aWFsaXplZA0KWyAgICAwLjY3NDg5Nl0gSHVnZVRMQiByZWdp
c3RlcmVkIDIgTUIgcGFnZSBzaXplLCBwcmUtYWxsb2NhdGVkIDAgcGFnZXMNClsgICAgMC42
Nzg3MTBdIFZGUzogRGlzayBxdW90YXMgZHF1b3RfNi41LjINClsgICAgMC42Nzg5NzRdIERx
dW90LWNhY2hlIGhhc2ggdGFibGUgZW50cmllczogNTEyIChvcmRlciAwLCA0MDk2IGJ5dGVz
KQ0KWyAgICAwLjY4MDIyN10gZnVzZSBpbml0IChBUEkgdmVyc2lvbiA3LjEzKQ0KWyAgICAw
LjY4MTAzOV0gQnRyZnMgbG9hZGVkDQpbICAgIDAuNjgxMjI4XSBtc2dtbmkgaGFzIGJlZW4g
c2V0IHRvIDM4OTcNClsgICAgMC42ODE1MTZdIFNFTGludXg6ICBSZWdpc3RlcmluZyBuZXRm
aWx0ZXIgaG9va3MNClsgICAgMC42ODIxODRdIGFsZzogTm8gdGVzdCBmb3Igc3Rkcm5nIChr
cm5nKQ0KWyAgICAwLjY4MjQ5MV0gQmxvY2sgbGF5ZXIgU0NTSSBnZW5lcmljIChic2cpIGRy
aXZlciB2ZXJzaW9uIDAuNCBsb2FkZWQgKG1ham9yIDI1MykNClsgICAgMC42ODI4MzNdIGlv
IHNjaGVkdWxlciBub29wIHJlZ2lzdGVyZWQNClsgICAgMC42ODMwMzRdIGlvIHNjaGVkdWxl
ciBkZWFkbGluZSByZWdpc3RlcmVkDQpbICAgIDAuNjgzMzU0XSBpbyBzY2hlZHVsZXIgY2Zx
IHJlZ2lzdGVyZWQgKGRlZmF1bHQpDQpbICAgIDAuNjgzNjY2XSBwY2llcG9ydCAwMDAwOjAw
OjAxLjA6IHNldHRpbmcgbGF0ZW5jeSB0aW1lciB0byA2NA0KWyAgICAwLjY4MzY4Ml0gICBh
bGxvYyBpcnFfZGVzYyBmb3IgMjggb24gbm9kZSAtMQ0KWyAgICAwLjY4MzY4M10gICBhbGxv
YyBrc3RhdF9pcnFzIG9uIG5vZGUgLTENClsgICAgMC42ODM2OTBdIHBjaWVwb3J0IDAwMDA6
MDA6MDEuMDogaXJxIDI4IGZvciBNU0kvTVNJLVgNClsgICAgMC42ODM4MjJdIHBjaWVwb3J0
IDAwMDA6MDA6MWMuMDogc2V0dGluZyBsYXRlbmN5IHRpbWVyIHRvIDY0DQpbICAgIDAuNjgz
ODQ1XSAgIGFsbG9jIGlycV9kZXNjIGZvciAyOSBvbiBub2RlIC0xDQpbICAgIDAuNjgzODQ2
XSAgIGFsbG9jIGtzdGF0X2lycXMgb24gbm9kZSAtMQ0KWyAgICAwLjY4Mzg1Ml0gcGNpZXBv
cnQgMDAwMDowMDoxYy4wOiBpcnEgMjkgZm9yIE1TSS9NU0ktWA0KWyAgICAwLjY4Mzk5NV0g
cGNpZXBvcnQgMDAwMDowMDoxYy40OiBzZXR0aW5nIGxhdGVuY3kgdGltZXIgdG8gNjQNClsg
ICAgMC42ODQwMzJdICAgYWxsb2MgaXJxX2Rlc2MgZm9yIDMwIG9uIG5vZGUgLTENClsgICAg
MC42ODQwMzNdICAgYWxsb2Mga3N0YXRfaXJxcyBvbiBub2RlIC0xDQpbICAgIDAuNjg0MDM5
XSBwY2llcG9ydCAwMDAwOjAwOjFjLjQ6IGlycSAzMCBmb3IgTVNJL01TSS1YDQpbICAgIDAu
Njg0MTU5XSBwY2llcG9ydCAwMDAwOjAxOjAwLjA6IHNldHRpbmcgbGF0ZW5jeSB0aW1lciB0
byA2NA0KWyAgICAwLjY4NDE4M10gICBhbGxvYyBpcnFfZGVzYyBmb3IgMzEgb24gbm9kZSAt
MQ0KWyAgICAwLjY4NDE4NV0gICBhbGxvYyBrc3RhdF9pcnFzIG9uIG5vZGUgLTENClsgICAg
MC42ODQxOTFdIHBjaWVwb3J0IDAwMDA6MDE6MDAuMDogaXJxIDMxIGZvciBNU0kvTVNJLVgN
ClsgICAgMC42ODQzMzddIHBjaWVwb3J0IDAwMDA6MDI6MDEuMDogc2V0dGluZyBsYXRlbmN5
IHRpbWVyIHRvIDY0DQpbICAgIDAuNjg0MzYxXSAgIGFsbG9jIGlycV9kZXNjIGZvciAzMiBv
biBub2RlIC0xDQpbICAgIDAuNjg0MzYzXSAgIGFsbG9jIGtzdGF0X2lycXMgb24gbm9kZSAt
MQ0KWyAgICAwLjY4NDM2OV0gcGNpZXBvcnQgMDAwMDowMjowMS4wOiBpcnEgMzIgZm9yIE1T
SS9NU0ktWA0KWyAgICAwLjY4NDUwN10gcGNpZXBvcnQgMDAwMDowMjowMi4wOiBzZXR0aW5n
IGxhdGVuY3kgdGltZXIgdG8gNjQNClsgICAgMC42ODQ1MzJdICAgYWxsb2MgaXJxX2Rlc2Mg
Zm9yIDMzIG9uIG5vZGUgLTENClsgICAgMC42ODQ1MzNdICAgYWxsb2Mga3N0YXRfaXJxcyBv
biBub2RlIC0xDQpbICAgIDAuNjg0NTQwXSBwY2llcG9ydCAwMDAwOjAyOjAyLjA6IGlycSAz
MyBmb3IgTVNJL01TSS1YDQpbICAgIDAuNjg0ODM0XSBwY2lfaG90cGx1ZzogUENJIEhvdCBQ
bHVnIFBDSSBDb3JlIHZlcnNpb246IDAuNQ0KWyAgICAwLjY4NTQzMl0gaW5wdXQ6IFBvd2Vy
IEJ1dHRvbiBhcyAvZGV2aWNlcy9MTlhTWVNUTTowMC9MTlhTWUJVUzowMC9QTlAwQzBDOjAw
L2lucHV0L2lucHV0MA0KWyAgICAwLjY4NTc3NF0gQUNQSTogUG93ZXIgQnV0dG9uIFtQV1JC
XQ0KWyAgICAwLjY4NjAzOF0gaW5wdXQ6IFBvd2VyIEJ1dHRvbiBhcyAvZGV2aWNlcy9MTlhT
WVNUTTowMC9MTlhQV1JCTjowMC9pbnB1dC9pbnB1dDENClsgICAgMC42ODYzNzddIEFDUEk6
IFBvd2VyIEJ1dHRvbiBbUFdSRl0NClsgICAgMC42ODcxNTJdIEFDUEk6IFNTRFQgMDAwMDAw
MDA3Y2I4MDI2MCAwMDIzNSAodjAxIERwZ1BtbSAgUDAwMUlzdCAwMDAwMDAxMSBJTlRMIDIw
MDYwMTEzKQ0KWyAgICAwLjY4ODA2Nl0gQUNQSTogU1NEVCAwMDAwMDAwMDdjYjgwYjYwIDAw
NEIyICh2MDEgIFBtUmVmICBQMDAxQ3N0IDAwMDAzMDAxIElOVEwgMjAwNjAxMTMpDQpbICAg
IDAuNjg5MDY5XSBNb25pdG9yLU13YWl0IHdpbGwgYmUgdXNlZCB0byBlbnRlciBDLTEgc3Rh
dGUNClsgICAgMC42ODkxMTddIE1vbml0b3ItTXdhaXQgd2lsbCBiZSB1c2VkIHRvIGVudGVy
IEMtMiBzdGF0ZQ0KWyAgICAwLjY4OTE3NF0gTW9uaXRvci1Nd2FpdCB3aWxsIGJlIHVzZWQg
dG8gZW50ZXIgQy0zIHN0YXRlDQpbICAgIDAuNjg5MTg2XSBNYXJraW5nIFRTQyB1bnN0YWJs
ZSBkdWUgdG8gVFNDIGhhbHRzIGluIGlkbGUNClsgICAgMC42ODk0NDZdIFN3aXRjaGluZyB0
byBjbG9ja3NvdXJjZSBocGV0DQpbICAgIDAuNjg5ODk4XSBBQ1BJOiBTU0RUIDAwMDAwMDAw
N2NiODA0YTAgMDAyMzUgKHYwMSBEcGdQbW0gIFAwMDJJc3QgMDAwMDAwMTIgSU5UTCAyMDA2
MDExMykNClsgICAgMC42OTA3NDhdIEFDUEk6IFNTRFQgMDAwMDAwMDA3Y2I4MTAyMCAwMDA4
NSAodjAxICBQbVJlZiAgUDAwMkNzdCAwMDAwMzAwMCBJTlRMIDIwMDYwMTEzKQ0KWyAgICAw
LjY5NjMzOV0gQUNQSTogU1NEVCAwMDAwMDAwMDdjYjgwNmUwIDAwMjM1ICh2MDEgRHBnUG1t
ICBQMDAzSXN0IDAwMDAwMDEyIElOVEwgMjAwNjAxMTMpDQpbICAgIDAuNjk3MTQ2XSBBQ1BJ
OiBTU0RUIDAwMDAwMDAwN2NiODEwYjAgMDAwODUgKHYwMSAgUG1SZWYgIFAwMDNDc3QgMDAw
MDMwMDAgSU5UTCAyMDA2MDExMykNClsgICAgMC42OTg3NTBdIEFDUEk6IFNTRFQgMDAwMDAw
MDA3Y2I4MDkyMCAwMDIzNSAodjAxIERwZ1BtbSAgUDAwNElzdCAwMDAwMDAxMiBJTlRMIDIw
MDYwMTEzKQ0KWyAgICAwLjY5OTU2OV0gQUNQSTogU1NEVCAwMDAwMDAwMDdjYjgxMTQwIDAw
MDg1ICh2MDEgIFBtUmVmICBQMDA0Q3N0IDAwMDAzMDAwIElOVEwgMjAwNjAxMTMpDQpbICAg
IDAuNzAzMjMyXSBYRU5GUzogbm90IHJlZ2lzdGVyaW5nIGZpbGVzeXN0ZW0gb24gbm9uLXhl
biBwbGF0Zm9ybQ0KWyAgICAwLjcwODAzNF0gTm9uLXZvbGF0aWxlIG1lbW9yeSBkcml2ZXIg
djEuMw0KWyAgICAwLjcwODMzMF0gTGludXggYWdwZ2FydCBpbnRlcmZhY2UgdjAuMTAzDQpb
ICAgIDAuNzA4NTkxXSBhZ3BnYXJ0LWludGVsIDAwMDA6MDA6MDAuMDogSW50ZWwgUTQ1L1E0
MyBDaGlwc2V0DQpbICAgIDAuNzA5NzAyXSBhZ3BnYXJ0LWludGVsIDAwMDA6MDA6MDAuMDog
ZGV0ZWN0ZWQgMzI3NjRLIHN0b2xlbiBtZW1vcnkNClsgICAgMC44MjE1MjRdIGFncGdhcnQt
aW50ZWwgMDAwMDowMDowMC4wOiBBR1AgYXBlcnR1cmUgaXMgMjU2TSBAIDB4ZDAwMDAwMDAN
ClsgICAgMC44MjE4NzhdIFtkcm1dIEluaXRpYWxpemVkIGRybSAxLjEuMCAyMDA2MDgxMA0K
WyAgICAwLjgyMjE1N10gU2VyaWFsOiA4MjUwLzE2NTUwIGRyaXZlciwgNCBwb3J0cywgSVJR
IHNoYXJpbmcgZW5hYmxlZA0KWyAgICAxLjA2NjExN10gc2VyaWFsODI1MDogdHR5UzAgYXQg
SS9PIDB4M2Y4IChpcnEgPSA0KSBpcyBhIDE2NTUwQQ0KWyAgICAxLjA2Njk0Nl0gMDA6MGM6
IHR0eVMwIGF0IEkvTyAweDNmOCAoaXJxID0gNCkgaXMgYSAxNjU1MEENClsgICAgMS4wNzAx
MjBdIGJyZDogbW9kdWxlIGxvYWRlZA0KWyAgICAxLjA3MTYzNV0gbG9vcDogbW9kdWxlIGxv
YWRlZA0KWyAgICAxLjA3MjI3N10gYWhjaSAwMDAwOjA0OjAwLjA6IHZlcnNpb24gMy4wDQpb
ICAgIDEuMDcyMjkxXSBhaGNpIDAwMDA6MDQ6MDAuMDogUENJIElOVCBBIC0+IEdTSSAxOCAo
bGV2ZWwsIGxvdykgLT4gSVJRIDE4DQpbICAgIDEuMDcyNTE3XSAgIGFsbG9jIGlycV9kZXNj
IGZvciAzNCBvbiBub2RlIC0xDQpbICAgIDEuMDcyNTE5XSAgIGFsbG9jIGtzdGF0X2lycXMg
b24gbm9kZSAtMQ0KWyAgICAxLjA3MjUyN10gYWhjaSAwMDAwOjA0OjAwLjA6IGlycSAzNCBm
b3IgTVNJL01TSS1YDQpbICAgIDEuMDcyNTY4XSBhaGNpIDAwMDA6MDQ6MDAuMDogQUhDSSAw
MDAxLjAwMDAgMzIgc2xvdHMgMiBwb3J0cyA2IEdicHMgMHgzIGltcGwgU0FUQSBtb2RlDQpb
ICAgIDEuMDcyOTA3XSBhaGNpIDAwMDA6MDQ6MDAuMDogZmxhZ3M6IDY0Yml0IG5jcSBzbnRm
IGxlZCBvbmx5IHBtcCBmYnMgcGlvIHNsdW0gcGFydCBzeHMgDQpbICAgIDEuMDczMjkzXSBh
aGNpIDAwMDA6MDQ6MDAuMDogc2V0dGluZyBsYXRlbmN5IHRpbWVyIHRvIDY0DQpbICAgIDEu
MDczMjk5XSBhaGNpIDAwMDA6MDQ6MDAuMDogVGhlIHBvcnQgaXMgbm90IGNhcGFibGUgb2Yg
RkJTDQpbICAgIDEuMDczNTI2XSBhaGNpIDAwMDA6MDQ6MDAuMDogVGhlIHBvcnQgaXMgbm90
IGNhcGFibGUgb2YgRkJTDQpbICAgIDEuMDczODIyXSBzY3NpMCA6IGFoY2kNClsgICAgMS4w
NzQyMjldIHNjc2kxIDogYWhjaQ0KWyAgICAxLjA3NDU2NF0gYXRhMTogU0FUQSBtYXggVURN
QS8xMzMgYWJhciBtMjA0OEAweGZlOWZmODAwIHBvcnQgMHhmZTlmZjkwMCBpcnEgMzQNClsg
ICAgMS4wNzQ5MDVdIGF0YTI6IFNBVEEgbWF4IFVETUEvMTMzIGFiYXIgbTIwNDhAMHhmZTlm
ZjgwMCBwb3J0IDB4ZmU5ZmY5ODAgaXJxIDM0DQpbICAgIDEuMDc1Mzg2XSBhdGFfcGlpeCAw
MDAwOjAwOjFmLjI6IHZlcnNpb24gMi4xMw0KWyAgICAxLjA3NTM5NF0gICBhbGxvYyBpcnFf
ZGVzYyBmb3IgMjIgb24gbm9kZSAtMQ0KWyAgICAxLjA3NTM5NV0gICBhbGxvYyBrc3RhdF9p
cnFzIG9uIG5vZGUgLTENClsgICAgMS4wNzUzOTldIGF0YV9waWl4IDAwMDA6MDA6MWYuMjog
UENJIElOVCBCIC0+IEdTSSAyMiAobGV2ZWwsIGxvdykgLT4gSVJRIDIyDQpbICAgIDEuMDc1
NTkxXSBhdGFfcGlpeCAwMDAwOjAwOjFmLjI6IE1BUCBbIFAwIFAyIFAxIFAzIF0NClsgICAg
MS4wNzU5NTJdIGF0YV9waWl4IDAwMDA6MDA6MWYuMjogc2V0dGluZyBsYXRlbmN5IHRpbWVy
IHRvIDY0DQpbICAgIDEuMDc2MDMzXSBzY3NpMiA6IGF0YV9waWl4DQpbICAgIDEuMDc2NDc5
XSBzY3NpMyA6IGF0YV9waWl4DQpbICAgIDEuMDc4MDY0XSBhdGEzOiBTQVRBIG1heCBVRE1B
LzEzMyBjbWQgMHgxZjAgY3RsIDB4M2Y2IGJtZG1hIDB4ZmY5MCBpcnEgMTQNClsgICAgMS4w
NzgyODBdIGF0YTQ6IFNBVEEgbWF4IFVETUEvMTMzIGNtZCAweDE3MCBjdGwgMHgzNzYgYm1k
bWEgMHhmZjk4IGlycSAxNQ0KWyAgICAxLjA3ODQ5OV0gYXRhX3BpaXggMDAwMDowMDoxZi41
OiBQQ0kgSU5UIEIgLT4gR1NJIDIyIChsZXZlbCwgbG93KSAtPiBJUlEgMjINClsgICAgMS4w
Nzg3MjldIGF0YV9waWl4IDAwMDA6MDA6MWYuNTogTUFQIFsgUDAgLS0gUDEgLS0gXQ0KWyAg
ICAxLjA3OTEwMl0gYXRhX3BpaXggMDAwMDowMDoxZi41OiBzZXR0aW5nIGxhdGVuY3kgdGlt
ZXIgdG8gNjQNClsgICAgMS4wNzkxNzBdIHNjc2k0IDogYXRhX3BpaXgNClsgICAgMS4wNzk1
NTZdIHNjc2k1IDogYXRhX3BpaXgNClsgICAgMS4wODA5NDNdIGF0YTU6IFNBVEEgbWF4IFVE
TUEvMTMzIGNtZCAweGE4ODAgY3RsIDB4YTgwMCBibWRtYSAweGEwODAgaXJxIDIyDQpbICAg
IDEuMDgxMTYxXSBhdGE2OiBTQVRBIG1heCBVRE1BLzEzMyBjbWQgMHhhNDgwIGN0bCAweGE0
MDAgYm1kbWEgMHhhMDg4IGlycSAyMg0KWyAgICAxLjA4MTg1NV0gSW50ZWwoUikgUFJPLzEw
MDAgTmV0d29yayBEcml2ZXIgLSB2ZXJzaW9uIDcuMy4yMS1rNS1OQVBJDQpbICAgIDEuMDgy
MDU4XSBDb3B5cmlnaHQgKGMpIDE5OTktMjAwNiBJbnRlbCBDb3Jwb3JhdGlvbi4NClsgICAg
MS4wODIzNDRdIGUxMDAwZTogSW50ZWwoUikgUFJPLzEwMDAgTmV0d29yayBEcml2ZXIgLSAx
LjAuMi1rMg0KWyAgICAxLjA4MjUzNl0gZTEwMDBlOiBDb3B5cmlnaHQgKGMpIDE5OTkgLSAy
MDA5IEludGVsIENvcnBvcmF0aW9uLg0KWyAgICAxLjA4Mjc0NF0gICBhbGxvYyBpcnFfZGVz
YyBmb3IgMjAgb24gbm9kZSAtMQ0KWyAgICAxLjA4Mjc0NV0gICBhbGxvYyBrc3RhdF9pcnFz
IG9uIG5vZGUgLTENClsgICAgMS4wODI3NDldIGUxMDAwZSAwMDAwOjAwOjE5LjA6IFBDSSBJ
TlQgQSAtPiBHU0kgMjAgKGxldmVsLCBsb3cpIC0+IElSUSAyMA0KWyAgICAxLjA4Mjk0NF0g
ZTEwMDBlIDAwMDA6MDA6MTkuMDogc2V0dGluZyBsYXRlbmN5IHRpbWVyIHRvIDY0DQpbICAg
IDEuMDgzMDA4XSAgIGFsbG9jIGlycV9kZXNjIGZvciAzNSBvbiBub2RlIC0xDQpbICAgIDEu
MDgzMDA5XSAgIGFsbG9jIGtzdGF0X2lycXMgb24gbm9kZSAtMQ0KWyAgICAxLjA4MzAyMV0g
ZTEwMDBlIDAwMDA6MDA6MTkuMDogaXJxIDM1IGZvciBNU0kvTVNJLVgNClsgICAgMS4yMTI3
OTZdIDAwMDA6MDA6MTkuMDogZXRoMDogKFBDSSBFeHByZXNzOjIuNUdCL3M6V2lkdGggeDEp
IDAwOjIzOjU0OjlhOjQ2OmVhDQpbICAgIDEuMjEzMTUyXSAwMDAwOjAwOjE5LjA6IGV0aDA6
IEludGVsKFIpIFBSTy8xMDAwIE5ldHdvcmsgQ29ubmVjdGlvbg0KWyAgICAxLjIxMzM5M10g
MDAwMDowMDoxOS4wOiBldGgwOiBNQUM6IDgsIFBIWTogOCwgUEJBIE5vOiBmZmZmZmYtMGZm
DQpbICAgIDEuMjEzNzQxXSBlMTAwOiBJbnRlbChSKSBQUk8vMTAwIE5ldHdvcmsgRHJpdmVy
LCAzLjUuMjQtazItTkFQSQ0KWyAgICAxLjIxMzkzMF0gZTEwMDogQ29weXJpZ2h0KGMpIDE5
OTktMjAwNiBJbnRlbCBDb3Jwb3JhdGlvbg0KWyAgICAxLjIxNDM3MV0gc2t5MjogZHJpdmVy
IHZlcnNpb24gMS4yNw0KWyAgICAxLjIxNDc5N10gdHVuOiBVbml2ZXJzYWwgVFVOL1RBUCBk
ZXZpY2UgZHJpdmVyLCAxLjYNClsgICAgMS4yMTQ5ODJdIHR1bjogKEMpIDE5OTktMjAwNCBN
YXggS3Jhc255YW5za3kgPG1heGtAcXVhbGNvbW0uY29tPg0KWyAgICAxLjIxNTQzMV0gY29u
c29sZSBbbmV0Y29uMF0gZW5hYmxlZA0KWyAgICAxLjIxNTYxN10gbmV0Y29uc29sZTogbmV0
d29yayBsb2dnaW5nIHN0YXJ0ZWQNClsgICAgMS4yMTYwNzldIGVoY2lfaGNkOiBVU0IgMi4w
ICdFbmhhbmNlZCcgSG9zdCBDb250cm9sbGVyIChFSENJKSBEcml2ZXINClsgICAgMS4yMTYy
OTFdIGVoY2lfaGNkOiBibG9jayBzaXplczogcWggMTA0IHF0ZCA5NiBpdGQgMTkyIHNpdGQg
OTYNClsgICAgMS4yMTYzMDZdIGVoY2lfaGNkIDAwMDA6MDA6MWEuNzogUENJIElOVCBDIC0+
IEdTSSAxOCAobGV2ZWwsIGxvdykgLT4gSVJRIDE4DQpbICAgIDEuMjE2NTEwXSBlaGNpX2hj
ZCAwMDAwOjAwOjFhLjc6IHNldHRpbmcgbGF0ZW5jeSB0aW1lciB0byA2NA0KWyAgICAxLjIx
NjUxM10gZWhjaV9oY2QgMDAwMDowMDoxYS43OiBFSENJIEhvc3QgQ29udHJvbGxlcg0KWyAg
ICAxLjIxNjcxN10gZHJpdmVycy91c2IvY29yZS9pbm9kZS5jOiBjcmVhdGluZyBmaWxlICdk
ZXZpY2VzJw0KWyAgICAxLjIxNjcyMV0gZHJpdmVycy91c2IvY29yZS9pbm9kZS5jOiBjcmVh
dGluZyBmaWxlICcwMDEnDQpbICAgIDEuMjE2ODI4XSBlaGNpX2hjZCAwMDAwOjAwOjFhLjc6
IG5ldyBVU0IgYnVzIHJlZ2lzdGVyZWQsIGFzc2lnbmVkIGJ1cyBudW1iZXIgMQ0KWyAgICAx
LjIxNzE5MV0gZWhjaV9oY2QgMDAwMDowMDoxYS43OiByZXNldCBoY3NfcGFyYW1zIDB4MTAz
MjA2IGRiZz0xIGNjPTMgcGNjPTIgb3JkZXJlZCAhcHBjIHBvcnRzPTYNClsgICAgMS4yMTcx
OTVdIGVoY2lfaGNkIDAwMDA6MDA6MWEuNzogcmVzZXQgaGNjX3BhcmFtcyA2ODcxIHRocmVz
aCA3IHVmcmFtZXMgMTAyNCA2NCBiaXQgYWRkcg0KWyAgICAxLjIxNzIxMl0gZWhjaV9oY2Qg
MDAwMDowMDoxYS43OiBkZWJ1ZyBwb3J0IDENClsgICAgMS4yMTc0MDldIGVoY2lfaGNkIDAw
MDA6MDA6MWEuNzogcmVzZXQgY29tbWFuZCAwODAwMDIgKHBhcmspPTAgaXRocmVzaD04IHBl
cmlvZD0xMDI0IFJlc2V0IEhBTFQNClsgICAgMS4yMjEzMDFdIGVoY2lfaGNkIDAwMDA6MDA6
MWEuNzogY2FjaGUgbGluZSBzaXplIG9mIDMyIGlzIG5vdCBzdXBwb3J0ZWQNClsgICAgMS4y
MjEzMDNdIGVoY2lfaGNkIDAwMDA6MDA6MWEuNzogc3VwcG9ydHMgVVNCIHJlbW90ZSB3YWtl
dXANClsgICAgMS4yMjEzMTRdIGVoY2lfaGNkIDAwMDA6MDA6MWEuNzogaXJxIDE4LCBpbyBt
ZW0gMHhmZTZmOTAwMA0KWyAgICAxLjIyMTUwNl0gZWhjaV9oY2QgMDAwMDowMDoxYS43OiBy
ZXNldCBjb21tYW5kIDA4MDAwMiAocGFyayk9MCBpdGhyZXNoPTggcGVyaW9kPTEwMjQgUmVz
ZXQgSEFMVA0KWyAgICAxLjIyNTM4OF0gZWhjaV9oY2QgMDAwMDowMDoxYS43OiBpbml0IGNv
bW1hbmQgMDEwMDAxIChwYXJrKT0wIGl0aHJlc2g9MSBwZXJpb2Q9MTAyNCBSVU4NClsgICAg
MS4yMzEwMTVdIGVoY2lfaGNkIDAwMDA6MDA6MWEuNzogVVNCIDIuMCBzdGFydGVkLCBFSENJ
IDEuMDANClsgICAgMS4yMzEyMjldIHVzYiB1c2IxOiBkZWZhdWx0IGxhbmd1YWdlIDB4MDQw
OQ0KWyAgICAxLjIzMTIzNF0gdXNiIHVzYjE6IHVkZXYgMSwgYnVzbnVtIDEsIG1pbm9yID0g
MA0KWyAgICAxLjIzMTIzNl0gdXNiIHVzYjE6IE5ldyBVU0IgZGV2aWNlIGZvdW5kLCBpZFZl
bmRvcj0xZDZiLCBpZFByb2R1Y3Q9MDAwMg0KWyAgICAxLjIzMTQzN10gdXNiIHVzYjE6IE5l
dyBVU0IgZGV2aWNlIHN0cmluZ3M6IE1mcj0zLCBQcm9kdWN0PTIsIFNlcmlhbE51bWJlcj0x
DQpbICAgIDEuMjMxNzcwXSB1c2IgdXNiMTogUHJvZHVjdDogRUhDSSBIb3N0IENvbnRyb2xs
ZXINClsgICAgMS4yMzE5NTRdIHVzYiB1c2IxOiBNYW51ZmFjdHVyZXI6IExpbnV4IDIuNi4z
NC1yYzEgZWhjaV9oY2QNClsgICAgMS4yMzIxNTRdIHVzYiB1c2IxOiBTZXJpYWxOdW1iZXI6
IDAwMDA6MDA6MWEuNw0KWyAgICAxLjIzMjQ2NF0gdXNiIHVzYjE6IHVzYl9wcm9iZV9kZXZp
Y2UNClsgICAgMS4yMzI0NjZdIHVzYiB1c2IxOiBjb25maWd1cmF0aW9uICMxIGNob3NlbiBm
cm9tIDEgY2hvaWNlDQpbICAgIDEuMjMyNDcxXSB1c2IgdXNiMTogYWRkaW5nIDEtMDoxLjAg
KGNvbmZpZyAjMSwgaW50ZXJmYWNlIDApDQpbICAgIDEuMjMyNTczXSBodWIgMS0wOjEuMDog
dXNiX3Byb2JlX2ludGVyZmFjZQ0KWyAgICAxLjIzMjU3NF0gaHViIDEtMDoxLjA6IHVzYl9w
cm9iZV9pbnRlcmZhY2UgLSBnb3QgaWQNClsgICAgMS4yMzI1NzZdIGh1YiAxLTA6MS4wOiBV
U0IgaHViIGZvdW5kDQpbICAgIDEuMjMyNzYyXSBodWIgMS0wOjEuMDogNiBwb3J0cyBkZXRl
Y3RlZA0KWyAgICAxLjIzMjk0NF0gaHViIDEtMDoxLjA6IHN0YW5kYWxvbmUgaHViDQpbICAg
IDEuMjMyOTQ1XSBodWIgMS0wOjEuMDogbm8gcG93ZXIgc3dpdGNoaW5nICh1c2IgMS4wKQ0K
WyAgICAxLjIzMjk0Nl0gaHViIDEtMDoxLjA6IGluZGl2aWR1YWwgcG9ydCBvdmVyLWN1cnJl
bnQgcHJvdGVjdGlvbg0KWyAgICAxLjIzMjk0OF0gaHViIDEtMDoxLjA6IHBvd2VyIG9uIHRv
IHBvd2VyIGdvb2QgdGltZTogMjBtcw0KWyAgICAxLjIzMjk1MV0gaHViIDEtMDoxLjA6IGxv
Y2FsIHBvd2VyIHNvdXJjZSBpcyBnb29kDQpbICAgIDEuMjMyOTUzXSBodWIgMS0wOjEuMDog
dHJ5aW5nIHRvIGVuYWJsZSBwb3J0IHBvd2VyIG9uIG5vbi1zd2l0Y2hhYmxlIGh1Yg0KWyAg
ICAxLjIzMjk3Nl0gZHJpdmVycy91c2IvY29yZS9pbm9kZS5jOiBjcmVhdGluZyBmaWxlICcw
MDEnDQpbICAgIDEuMjMzMDE0XSAgIGFsbG9jIGlycV9kZXNjIGZvciAyMyBvbiBub2RlIC0x
DQpbICAgIDEuMjMzMDE2XSAgIGFsbG9jIGtzdGF0X2lycXMgb24gbm9kZSAtMQ0KWyAgICAx
LjIzMzAyMF0gZWhjaV9oY2QgMDAwMDowMDoxZC43OiBQQ0kgSU5UIEEgLT4gR1NJIDIzIChs
ZXZlbCwgbG93KSAtPiBJUlEgMjMNClsgICAgMS4yMzMyMzJdIGVoY2lfaGNkIDAwMDA6MDA6
MWQuNzogc2V0dGluZyBsYXRlbmN5IHRpbWVyIHRvIDY0DQpbICAgIDEuMjMzMjM1XSBlaGNp
X2hjZCAwMDAwOjAwOjFkLjc6IEVIQ0kgSG9zdCBDb250cm9sbGVyDQpbICAgIDEuMjMzNDQx
XSBkcml2ZXJzL3VzYi9jb3JlL2lub2RlLmM6IGNyZWF0aW5nIGZpbGUgJzAwMicNClsgICAg
MS4yMzM1NDddIGVoY2lfaGNkIDAwMDA6MDA6MWQuNzogbmV3IFVTQiBidXMgcmVnaXN0ZXJl
ZCwgYXNzaWduZWQgYnVzIG51bWJlciAyDQpbICAgIDEuMjMzODc1XSBlaGNpX2hjZCAwMDAw
OjAwOjFkLjc6IHJlc2V0IGhjc19wYXJhbXMgMHgxMDMyMDYgZGJnPTEgY2M9MyBwY2M9MiBv
cmRlcmVkICFwcGMgcG9ydHM9Ng0KWyAgICAxLjIzMzg3OF0gZWhjaV9oY2QgMDAwMDowMDox
ZC43OiByZXNldCBoY2NfcGFyYW1zIDY4NzEgdGhyZXNoIDcgdWZyYW1lcyAxMDI0IDY0IGJp
dCBhZGRyDQpbICAgIDEuMjMzODk1XSBlaGNpX2hjZCAwMDAwOjAwOjFkLjc6IGRlYnVnIHBv
cnQgMQ0KWyAgICAxLjIzNDA3NV0gZWhjaV9oY2QgMDAwMDowMDoxZC43OiByZXNldCBjb21t
YW5kIDA4MDAwMiAocGFyayk9MCBpdGhyZXNoPTggcGVyaW9kPTEwMjQgUmVzZXQgSEFMVA0K
WyAgICAxLjIzNzk2MV0gZWhjaV9oY2QgMDAwMDowMDoxZC43OiBjYWNoZSBsaW5lIHNpemUg
b2YgMzIgaXMgbm90IHN1cHBvcnRlZA0KWyAgICAxLjIzNzk2M10gZWhjaV9oY2QgMDAwMDow
MDoxZC43OiBzdXBwb3J0cyBVU0IgcmVtb3RlIHdha2V1cA0KWyAgICAxLjIzNzk3Ml0gZWhj
aV9oY2QgMDAwMDowMDoxZC43OiBpcnEgMjMsIGlvIG1lbSAweGZlNmY4MDAwDQpbICAgIDEu
MjM4MTc4XSBlaGNpX2hjZCAwMDAwOjAwOjFkLjc6IHJlc2V0IGNvbW1hbmQgMDgwMDAyIChw
YXJrKT0wIGl0aHJlc2g9OCBwZXJpb2Q9MTAyNCBSZXNldCBIQUxUDQpbICAgIDEuMjQyMDQ4
XSBlaGNpX2hjZCAwMDAwOjAwOjFkLjc6IGluaXQgY29tbWFuZCAwMTAwMDEgKHBhcmspPTAg
aXRocmVzaD0xIHBlcmlvZD0xMDI0IFJVTg0KWyAgICAxLjI0NzAxNV0gZWhjaV9oY2QgMDAw
MDowMDoxZC43OiBVU0IgMi4wIHN0YXJ0ZWQsIEVIQ0kgMS4wMA0KWyAgICAxLjI0NzIzNF0g
dXNiIHVzYjI6IGRlZmF1bHQgbGFuZ3VhZ2UgMHgwNDA5DQpbICAgIDEuMjQ3MjM5XSB1c2Ig
dXNiMjogdWRldiAxLCBidXNudW0gMiwgbWlub3IgPSAxMjgNClsgICAgMS4yNDcyNDBdIHVz
YiB1c2IyOiBOZXcgVVNCIGRldmljZSBmb3VuZCwgaWRWZW5kb3I9MWQ2YiwgaWRQcm9kdWN0
PTAwMDINClsgICAgMS4yNDc0NDFdIHVzYiB1c2IyOiBOZXcgVVNCIGRldmljZSBzdHJpbmdz
OiBNZnI9MywgUHJvZHVjdD0yLCBTZXJpYWxOdW1iZXI9MQ0KWyAgICAxLjI0Nzc3NF0gdXNi
IHVzYjI6IFByb2R1Y3Q6IEVIQ0kgSG9zdCBDb250cm9sbGVyDQpbICAgIDEuMjQ3OTU0XSB1
c2IgdXNiMjogTWFudWZhY3R1cmVyOiBMaW51eCAyLjYuMzQtcmMxIGVoY2lfaGNkDQpbICAg
IDEuMjQ4MTQ4XSB1c2IgdXNiMjogU2VyaWFsTnVtYmVyOiAwMDAwOjAwOjFkLjcNClsgICAg
MS4yNDg0NTBdIHVzYiB1c2IyOiB1c2JfcHJvYmVfZGV2aWNlDQpbICAgIDEuMjQ4NDUxXSB1
c2IgdXNiMjogY29uZmlndXJhdGlvbiAjMSBjaG9zZW4gZnJvbSAxIGNob2ljZQ0KWyAgICAx
LjI0ODQ1Nl0gdXNiIHVzYjI6IGFkZGluZyAyLTA6MS4wIChjb25maWcgIzEsIGludGVyZmFj
ZSAwKQ0KWyAgICAxLjI0ODU1Nl0gaHViIDItMDoxLjA6IHVzYl9wcm9iZV9pbnRlcmZhY2UN
ClsgICAgMS4yNDg1NThdIGh1YiAyLTA6MS4wOiB1c2JfcHJvYmVfaW50ZXJmYWNlIC0gZ290
IGlkDQpbICAgIDEuMjQ4NTU5XSBodWIgMi0wOjEuMDogVVNCIGh1YiBmb3VuZA0KWyAgICAx
LjI0ODczOF0gaHViIDItMDoxLjA6IDYgcG9ydHMgZGV0ZWN0ZWQNClsgICAgMS4yNDg5MTVd
IGh1YiAyLTA6MS4wOiBzdGFuZGFsb25lIGh1Yg0KWyAgICAxLjI0ODkxNl0gaHViIDItMDox
LjA6IG5vIHBvd2VyIHN3aXRjaGluZyAodXNiIDEuMCkNClsgICAgMS4yNDg5MTddIGh1YiAy
LTA6MS4wOiBpbmRpdmlkdWFsIHBvcnQgb3Zlci1jdXJyZW50IHByb3RlY3Rpb24NClsgICAg
MS4yNDg5MTldIGh1YiAyLTA6MS4wOiBwb3dlciBvbiB0byBwb3dlciBnb29kIHRpbWU6IDIw
bXMNClsgICAgMS4yNDg5MjJdIGh1YiAyLTA6MS4wOiBsb2NhbCBwb3dlciBzb3VyY2UgaXMg
Z29vZA0KWyAgICAxLjI0ODkyM10gaHViIDItMDoxLjA6IHRyeWluZyB0byBlbmFibGUgcG9y
dCBwb3dlciBvbiBub24tc3dpdGNoYWJsZSBodWINClsgICAgMS4yNDg5NDRdIGRyaXZlcnMv
dXNiL2NvcmUvaW5vZGUuYzogY3JlYXRpbmcgZmlsZSAnMDAxJw0KWyAgICAxLjI0OTE2NV0g
MTE2eDogZHJpdmVyIGlzcDExNngtaGNkLCAwMyBOb3YgMjAwNQ0KWyAgICAxLjI0OTQ0M10g
ZHJpdmVyIGlzcDEzNjItaGNkLCAyMDA1LTA0LTA0DQpbICAgIDEuMjQ5NzE5XSBvaGNpX2hj
ZDogVVNCIDEuMSAnT3BlbicgSG9zdCBDb250cm9sbGVyIChPSENJKSBEcml2ZXINClsgICAg
MS4yNDk5MDddIG9oY2lfaGNkOiBibG9jayBzaXplczogZWQgODAgdGQgOTYNClsgICAgMS4y
NTAwMDZdIHVoY2lfaGNkOiBVU0IgVW5pdmVyc2FsIEhvc3QgQ29udHJvbGxlciBJbnRlcmZh
Y2UgZHJpdmVyDQpbICAgIDEuMjUwMjI4XSB1aGNpX2hjZCAwMDAwOjAwOjFhLjA6IFBDSSBJ
TlQgQSAtPiBHU0kgMTYgKGxldmVsLCBsb3cpIC0+IElSUSAxNg0KWyAgICAxLjI1MDQzMV0g
dWhjaV9oY2QgMDAwMDowMDoxYS4wOiBzZXR0aW5nIGxhdGVuY3kgdGltZXIgdG8gNjQNClsg
ICAgMS4yNTA0MzRdIHVoY2lfaGNkIDAwMDA6MDA6MWEuMDogVUhDSSBIb3N0IENvbnRyb2xs
ZXINClsgICAgMS4yNTA2MjhdIGRyaXZlcnMvdXNiL2NvcmUvaW5vZGUuYzogY3JlYXRpbmcg
ZmlsZSAnMDAzJw0KWyAgICAxLjI1MDczNV0gdWhjaV9oY2QgMDAwMDowMDoxYS4wOiBuZXcg
VVNCIGJ1cyByZWdpc3RlcmVkLCBhc3NpZ25lZCBidXMgbnVtYmVyIDMNClsgICAgMS4yNTEw
NzddIHVoY2lfaGNkIDAwMDA6MDA6MWEuMDogZGV0ZWN0ZWQgMiBwb3J0cw0KWyAgICAxLjI1
MTI4M10gdWhjaV9oY2QgMDAwMDowMDoxYS4wOiB1aGNpX2NoZWNrX2FuZF9yZXNldF9oYzog
Y21kID0gMHgwMDAwDQpbICAgIDEuMjUxMjg0XSB1aGNpX2hjZCAwMDAwOjAwOjFhLjA6IFBl
cmZvcm1pbmcgZnVsbCByZXNldA0KWyAgICAxLjI1MTI5Nl0gdWhjaV9oY2QgMDAwMDowMDox
YS4wOiBzdXBwb3J0cyBVU0IgcmVtb3RlIHdha2V1cA0KWyAgICAxLjI1MTMwNl0gdWhjaV9o
Y2QgMDAwMDowMDoxYS4wOiBpcnEgMTYsIGlvIGJhc2UgMHgwMDAwYjQwMA0KWyAgICAxLjI1
MTUyMF0gdXNiIHVzYjM6IGRlZmF1bHQgbGFuZ3VhZ2UgMHgwNDA5DQpbICAgIDEuMjUxNTI1
XSB1c2IgdXNiMzogdWRldiAxLCBidXNudW0gMywgbWlub3IgPSAyNTYNClsgICAgMS4yNTE1
MjZdIHVzYiB1c2IzOiBOZXcgVVNCIGRldmljZSBmb3VuZCwgaWRWZW5kb3I9MWQ2YiwgaWRQ
cm9kdWN0PTAwMDENClsgICAgMS4yNTE3MTZdIHVzYiB1c2IzOiBOZXcgVVNCIGRldmljZSBz
dHJpbmdzOiBNZnI9MywgUHJvZHVjdD0yLCBTZXJpYWxOdW1iZXI9MQ0KWyAgICAxLjI1MjA1
NV0gdXNiIHVzYjM6IFByb2R1Y3Q6IFVIQ0kgSG9zdCBDb250cm9sbGVyDQpbICAgIDEuMjUy
MjY1XSB1c2IgdXNiMzogTWFudWZhY3R1cmVyOiBMaW51eCAyLjYuMzQtcmMxIHVoY2lfaGNk
DQpbICAgIDEuMjUyNDYyXSB1c2IgdXNiMzogU2VyaWFsTnVtYmVyOiAwMDAwOjAwOjFhLjAN
ClsgICAgMS4yNTI3NjNdIHVzYiB1c2IzOiB1c2JfcHJvYmVfZGV2aWNlDQpbICAgIDEuMjUy
NzY1XSB1c2IgdXNiMzogY29uZmlndXJhdGlvbiAjMSBjaG9zZW4gZnJvbSAxIGNob2ljZQ0K
WyAgICAxLjI1Mjc3MF0gdXNiIHVzYjM6IGFkZGluZyAzLTA6MS4wIChjb25maWcgIzEsIGlu
dGVyZmFjZSAwKQ0KWyAgICAxLjI1Mjg3MF0gaHViIDMtMDoxLjA6IHVzYl9wcm9iZV9pbnRl
cmZhY2UNClsgICAgMS4yNTI4NzJdIGh1YiAzLTA6MS4wOiB1c2JfcHJvYmVfaW50ZXJmYWNl
IC0gZ290IGlkDQpbICAgIDEuMjUyODczXSBodWIgMy0wOjEuMDogVVNCIGh1YiBmb3VuZA0K
WyAgICAxLjI1MzA1Nl0gaHViIDMtMDoxLjA6IDIgcG9ydHMgZGV0ZWN0ZWQNClsgICAgMS4y
NTMyNjJdIGh1YiAzLTA6MS4wOiBzdGFuZGFsb25lIGh1Yg0KWyAgICAxLjI1MzI2M10gaHVi
IDMtMDoxLjA6IG5vIHBvd2VyIHN3aXRjaGluZyAodXNiIDEuMCkNClsgICAgMS4yNTMyNjRd
IGh1YiAzLTA6MS4wOiBpbmRpdmlkdWFsIHBvcnQgb3Zlci1jdXJyZW50IHByb3RlY3Rpb24N
ClsgICAgMS4yNTMyNjZdIGh1YiAzLTA6MS4wOiBwb3dlciBvbiB0byBwb3dlciBnb29kIHRp
bWU6IDJtcw0KWyAgICAxLjI1MzI2OV0gaHViIDMtMDoxLjA6IGxvY2FsIHBvd2VyIHNvdXJj
ZSBpcyBnb29kDQpbICAgIDEuMjUzMjcwXSBodWIgMy0wOjEuMDogdHJ5aW5nIHRvIGVuYWJs
ZSBwb3J0IHBvd2VyIG9uIG5vbi1zd2l0Y2hhYmxlIGh1Yg0KWyAgICAxLjI1MzI4Ml0gZHJp
dmVycy91c2IvY29yZS9pbm9kZS5jOiBjcmVhdGluZyBmaWxlICcwMDEnDQpbICAgIDEuMjUz
MzA4XSBlaGNpX2hjZCAwMDAwOjAwOjFhLjc6IEhTIGNvbXBhbmlvbiBmb3IgMDAwMDowMDox
YS4wDQpbICAgIDEuMjUzMzI1XSAgIGFsbG9jIGlycV9kZXNjIGZvciAyMSBvbiBub2RlIC0x
DQpbICAgIDEuMjUzMzI3XSAgIGFsbG9jIGtzdGF0X2lycXMgb24gbm9kZSAtMQ0KWyAgICAx
LjI1MzMzMF0gdWhjaV9oY2QgMDAwMDowMDoxYS4xOiBQQ0kgSU5UIEIgLT4gR1NJIDIxIChs
ZXZlbCwgbG93KSAtPiBJUlEgMjENClsgICAgMS4yNTM1MjhdIHVoY2lfaGNkIDAwMDA6MDA6
MWEuMTogc2V0dGluZyBsYXRlbmN5IHRpbWVyIHRvIDY0DQpbICAgIDEuMjUzNTMxXSB1aGNp
X2hjZCAwMDAwOjAwOjFhLjE6IFVIQ0kgSG9zdCBDb250cm9sbGVyDQpbICAgIDEuMjUzNzE4
XSBkcml2ZXJzL3VzYi9jb3JlL2lub2RlLmM6IGNyZWF0aW5nIGZpbGUgJzAwNCcNClsgICAg
MS4yNTM4MjZdIHVoY2lfaGNkIDAwMDA6MDA6MWEuMTogbmV3IFVTQiBidXMgcmVnaXN0ZXJl
ZCwgYXNzaWduZWQgYnVzIG51bWJlciA0DQpbICAgIDEuMjU0MTc0XSB1aGNpX2hjZCAwMDAw
OjAwOjFhLjE6IGRldGVjdGVkIDIgcG9ydHMNClsgICAgMS4yNTQzNjddIHVoY2lfaGNkIDAw
MDA6MDA6MWEuMTogdWhjaV9jaGVja19hbmRfcmVzZXRfaGM6IGNtZCA9IDB4MDAwMA0KWyAg
ICAxLjI1NDM2OV0gdWhjaV9oY2QgMDAwMDowMDoxYS4xOiBQZXJmb3JtaW5nIGZ1bGwgcmVz
ZXQNClsgICAgMS4yNTQzODJdIHVoY2lfaGNkIDAwMDA6MDA6MWEuMTogc3VwcG9ydHMgVVNC
IHJlbW90ZSB3YWtldXANClsgICAgMS4yNTQzOTJdIHVoY2lfaGNkIDAwMDA6MDA6MWEuMTog
aXJxIDIxLCBpbyBiYXNlIDB4MDAwMGI0ODANClsgICAgMS4yNTQ2MDNdIHVzYiB1c2I0OiBk
ZWZhdWx0IGxhbmd1YWdlIDB4MDQwOQ0KWyAgICAxLjI1NDYwOF0gdXNiIHVzYjQ6IHVkZXYg
MSwgYnVzbnVtIDQsIG1pbm9yID0gMzg0DQpbICAgIDEuMjU0NjEwXSB1c2IgdXNiNDogTmV3
IFVTQiBkZXZpY2UgZm91bmQsIGlkVmVuZG9yPTFkNmIsIGlkUHJvZHVjdD0wMDAxDQpbICAg
IDEuMjU0ODA0XSB1c2IgdXNiNDogTmV3IFVTQiBkZXZpY2Ugc3RyaW5nczogTWZyPTMsIFBy
b2R1Y3Q9MiwgU2VyaWFsTnVtYmVyPTENClsgICAgMS4yNTUxNTRdIHVzYiB1c2I0OiBQcm9k
dWN0OiBVSENJIEhvc3QgQ29udHJvbGxlcg0KWyAgICAxLjI1NTM0N10gdXNiIHVzYjQ6IE1h
bnVmYWN0dXJlcjogTGludXggMi42LjM0LXJjMSB1aGNpX2hjZA0KWyAgICAxLjI1NTUzOF0g
dXNiIHVzYjQ6IFNlcmlhbE51bWJlcjogMDAwMDowMDoxYS4xDQpbICAgIDEuMjU1ODM5XSB1
c2IgdXNiNDogdXNiX3Byb2JlX2RldmljZQ0KWyAgICAxLjI1NTg0MV0gdXNiIHVzYjQ6IGNv
bmZpZ3VyYXRpb24gIzEgY2hvc2VuIGZyb20gMSBjaG9pY2UNClsgICAgMS4yNTU4NDVdIHVz
YiB1c2I0OiBhZGRpbmcgNC0wOjEuMCAoY29uZmlnICMxLCBpbnRlcmZhY2UgMCkNClsgICAg
MS4yNTU5NDZdIGh1YiA0LTA6MS4wOiB1c2JfcHJvYmVfaW50ZXJmYWNlDQpbICAgIDEuMjU1
OTQ3XSBodWIgNC0wOjEuMDogdXNiX3Byb2JlX2ludGVyZmFjZSAtIGdvdCBpZA0KWyAgICAx
LjI1NTk0OV0gaHViIDQtMDoxLjA6IFVTQiBodWIgZm91bmQNClsgICAgMS4yNTYxNDFdIGh1
YiA0LTA6MS4wOiAyIHBvcnRzIGRldGVjdGVkDQpbICAgIDEuMjU2MzQyXSBodWIgNC0wOjEu
MDogc3RhbmRhbG9uZSBodWINClsgICAgMS4yNTYzNDNdIGh1YiA0LTA6MS4wOiBubyBwb3dl
ciBzd2l0Y2hpbmcgKHVzYiAxLjApDQpbICAgIDEuMjU2MzQ0XSBodWIgNC0wOjEuMDogaW5k
aXZpZHVhbCBwb3J0IG92ZXItY3VycmVudCBwcm90ZWN0aW9uDQpbICAgIDEuMjU2MzQ2XSBo
dWIgNC0wOjEuMDogcG93ZXIgb24gdG8gcG93ZXIgZ29vZCB0aW1lOiAybXMNClsgICAgMS4y
NTYzNDldIGh1YiA0LTA6MS4wOiBsb2NhbCBwb3dlciBzb3VyY2UgaXMgZ29vZA0KWyAgICAx
LjI1NjM1MF0gaHViIDQtMDoxLjA6IHRyeWluZyB0byBlbmFibGUgcG9ydCBwb3dlciBvbiBu
b24tc3dpdGNoYWJsZSBodWINClsgICAgMS4yNTYzNjBdIGRyaXZlcnMvdXNiL2NvcmUvaW5v
ZGUuYzogY3JlYXRpbmcgZmlsZSAnMDAxJw0KWyAgICAxLjI1NjM4NF0gZWhjaV9oY2QgMDAw
MDowMDoxYS43OiBIUyBjb21wYW5pb24gZm9yIDAwMDA6MDA6MWEuMQ0KWyAgICAxLjI1NjQw
MV0gdWhjaV9oY2QgMDAwMDowMDoxYS4yOiBQQ0kgSU5UIEMgLT4gR1NJIDE4IChsZXZlbCwg
bG93KSAtPiBJUlEgMTgNClsgICAgMS4yNTY1OTZdIHVoY2lfaGNkIDAwMDA6MDA6MWEuMjog
c2V0dGluZyBsYXRlbmN5IHRpbWVyIHRvIDY0DQpbICAgIDEuMjU2NTk4XSB1aGNpX2hjZCAw
MDAwOjAwOjFhLjI6IFVIQ0kgSG9zdCBDb250cm9sbGVyDQpbICAgIDEuMjU2Nzg2XSBkcml2
ZXJzL3VzYi9jb3JlL2lub2RlLmM6IGNyZWF0aW5nIGZpbGUgJzAwNScNClsgICAgMS4yNTY4
OTJdIHVoY2lfaGNkIDAwMDA6MDA6MWEuMjogbmV3IFVTQiBidXMgcmVnaXN0ZXJlZCwgYXNz
aWduZWQgYnVzIG51bWJlciA1DQpbICAgIDEuMjU3MjQ2XSB1aGNpX2hjZCAwMDAwOjAwOjFh
LjI6IGRldGVjdGVkIDIgcG9ydHMNClsgICAgMS4yNTc0NDZdIHVoY2lfaGNkIDAwMDA6MDA6
MWEuMjogdWhjaV9jaGVja19hbmRfcmVzZXRfaGM6IGNtZCA9IDB4MDAwMA0KWyAgICAxLjI1
NzQ0OF0gdWhjaV9oY2QgMDAwMDowMDoxYS4yOiBQZXJmb3JtaW5nIGZ1bGwgcmVzZXQNClsg
ICAgMS4yNTc0NTldIHVoY2lfaGNkIDAwMDA6MDA6MWEuMjogc3VwcG9ydHMgVVNCIHJlbW90
ZSB3YWtldXANClsgICAgMS4yNTc0NjNdIHVoY2lfaGNkIDAwMDA6MDA6MWEuMjogaXJxIDE4
LCBpbyBiYXNlIDB4MDAwMGI4MDANClsgICAgMS4yNTc2NzFdIHVzYiB1c2I1OiBkZWZhdWx0
IGxhbmd1YWdlIDB4MDQwOQ0KWyAgICAxLjI1NzY3Nl0gdXNiIHVzYjU6IHVkZXYgMSwgYnVz
bnVtIDUsIG1pbm9yID0gNTEyDQpbICAgIDEuMjU3Njc4XSB1c2IgdXNiNTogTmV3IFVTQiBk
ZXZpY2UgZm91bmQsIGlkVmVuZG9yPTFkNmIsIGlkUHJvZHVjdD0wMDAxDQpbICAgIDEuMjU3
ODY2XSB1c2IgdXNiNTogTmV3IFVTQiBkZXZpY2Ugc3RyaW5nczogTWZyPTMsIFByb2R1Y3Q9
MiwgU2VyaWFsTnVtYmVyPTENClsgICAgMS4yNTgyMTVdIHVzYiB1c2I1OiBQcm9kdWN0OiBV
SENJIEhvc3QgQ29udHJvbGxlcg0KWyAgICAxLjI1ODQwOF0gdXNiIHVzYjU6IE1hbnVmYWN0
dXJlcjogTGludXggMi42LjM0LXJjMSB1aGNpX2hjZA0KWyAgICAxLjI1ODU5NV0gdXNiIHVz
YjU6IFNlcmlhbE51bWJlcjogMDAwMDowMDoxYS4yDQpbICAgIDEuMjU4ODk5XSB1c2IgdXNi
NTogdXNiX3Byb2JlX2RldmljZQ0KWyAgICAxLjI1ODkwMV0gdXNiIHVzYjU6IGNvbmZpZ3Vy
YXRpb24gIzEgY2hvc2VuIGZyb20gMSBjaG9pY2UNClsgICAgMS4yNTg5MDVdIHVzYiB1c2I1
OiBhZGRpbmcgNS0wOjEuMCAoY29uZmlnICMxLCBpbnRlcmZhY2UgMCkNClsgICAgMS4yNTkw
MDRdIGh1YiA1LTA6MS4wOiB1c2JfcHJvYmVfaW50ZXJmYWNlDQpbICAgIDEuMjU5MDA2XSBo
dWIgNS0wOjEuMDogdXNiX3Byb2JlX2ludGVyZmFjZSAtIGdvdCBpZA0KWyAgICAxLjI1OTAw
N10gaHViIDUtMDoxLjA6IFVTQiBodWIgZm91bmQNClsgICAgMS4yNTkyMDddIGh1YiA1LTA6
MS4wOiAyIHBvcnRzIGRldGVjdGVkDQpbICAgIDEuMjU5Mzk5XSBodWIgNS0wOjEuMDogc3Rh
bmRhbG9uZSBodWINClsgICAgMS4yNTk0MDBdIGh1YiA1LTA6MS4wOiBubyBwb3dlciBzd2l0
Y2hpbmcgKHVzYiAxLjApDQpbICAgIDEuMjU5NDAyXSBodWIgNS0wOjEuMDogaW5kaXZpZHVh
bCBwb3J0IG92ZXItY3VycmVudCBwcm90ZWN0aW9uDQpbICAgIDEuMjU5NDAzXSBodWIgNS0w
OjEuMDogcG93ZXIgb24gdG8gcG93ZXIgZ29vZCB0aW1lOiAybXMNClsgICAgMS4yNTk0MDZd
IGh1YiA1LTA6MS4wOiBsb2NhbCBwb3dlciBzb3VyY2UgaXMgZ29vZA0KWyAgICAxLjI1OTQw
OF0gaHViIDUtMDoxLjA6IHRyeWluZyB0byBlbmFibGUgcG9ydCBwb3dlciBvbiBub24tc3dp
dGNoYWJsZSBodWINClsgICAgMS4yNTk0MThdIGRyaXZlcnMvdXNiL2NvcmUvaW5vZGUuYzog
Y3JlYXRpbmcgZmlsZSAnMDAxJw0KWyAgICAxLjI1OTQzOF0gZWhjaV9oY2QgMDAwMDowMDox
YS43OiBIUyBjb21wYW5pb24gZm9yIDAwMDA6MDA6MWEuMg0KWyAgICAxLjI1OTQ1Nl0gdWhj
aV9oY2QgMDAwMDowMDoxZC4wOiBQQ0kgSU5UIEEgLT4gR1NJIDIzIChsZXZlbCwgbG93KSAt
PiBJUlEgMjMNClsgICAgMS4yNTk2NDhdIHVoY2lfaGNkIDAwMDA6MDA6MWQuMDogc2V0dGlu
ZyBsYXRlbmN5IHRpbWVyIHRvIDY0DQpbICAgIDEuMjU5NjUwXSB1aGNpX2hjZCAwMDAwOjAw
OjFkLjA6IFVIQ0kgSG9zdCBDb250cm9sbGVyDQpbICAgIDEuMjU5ODM2XSBkcml2ZXJzL3Vz
Yi9jb3JlL2lub2RlLmM6IGNyZWF0aW5nIGZpbGUgJzAwNicNClsgICAgMS4yNTk5NDRdIHVo
Y2lfaGNkIDAwMDA6MDA6MWQuMDogbmV3IFVTQiBidXMgcmVnaXN0ZXJlZCwgYXNzaWduZWQg
YnVzIG51bWJlciA2DQpbICAgIDEuMjYwMzA1XSB1aGNpX2hjZCAwMDAwOjAwOjFkLjA6IGRl
dGVjdGVkIDIgcG9ydHMNClsgICAgMS4yNjA1MDBdIHVoY2lfaGNkIDAwMDA6MDA6MWQuMDog
dWhjaV9jaGVja19hbmRfcmVzZXRfaGM6IGNtZCA9IDB4MDAwMA0KWyAgICAxLjI2MDUwMl0g
dWhjaV9oY2QgMDAwMDowMDoxZC4wOiBQZXJmb3JtaW5nIGZ1bGwgcmVzZXQNClsgICAgMS4y
NjA1MTNdIHVoY2lfaGNkIDAwMDA6MDA6MWQuMDogc3VwcG9ydHMgVVNCIHJlbW90ZSB3YWtl
dXANClsgICAgMS4yNjA1MTddIHVoY2lfaGNkIDAwMDA6MDA6MWQuMDogaXJxIDIzLCBpbyBi
YXNlIDB4MDAwMGFjMDANClsgICAgMS4yNjA3MjVdIHVzYiB1c2I2OiBkZWZhdWx0IGxhbmd1
YWdlIDB4MDQwOQ0KWyAgICAxLjI2MDczMF0gdXNiIHVzYjY6IHVkZXYgMSwgYnVzbnVtIDYs
IG1pbm9yID0gNjQwDQpbICAgIDEuMjYwNzMxXSB1c2IgdXNiNjogTmV3IFVTQiBkZXZpY2Ug
Zm91bmQsIGlkVmVuZG9yPTFkNmIsIGlkUHJvZHVjdD0wMDAxDQpbICAgIDEuMjYwOTIwXSB1
c2IgdXNiNjogTmV3IFVTQiBkZXZpY2Ugc3RyaW5nczogTWZyPTMsIFByb2R1Y3Q9MiwgU2Vy
aWFsTnVtYmVyPTENClsgICAgMS4yNjEyNzhdIHVzYiB1c2I2OiBQcm9kdWN0OiBVSENJIEhv
c3QgQ29udHJvbGxlcg0KWyAgICAxLjI2MTQ2OV0gdXNiIHVzYjY6IE1hbnVmYWN0dXJlcjog
TGludXggMi42LjM0LXJjMSB1aGNpX2hjZA0KWyAgICAxLjI2MTY1NV0gdXNiIHVzYjY6IFNl
cmlhbE51bWJlcjogMDAwMDowMDoxZC4wDQpbICAgIDEuMjYxOTU0XSB1c2IgdXNiNjogdXNi
X3Byb2JlX2RldmljZQ0KWyAgICAxLjI2MTk1Nl0gdXNiIHVzYjY6IGNvbmZpZ3VyYXRpb24g
IzEgY2hvc2VuIGZyb20gMSBjaG9pY2UNClsgICAgMS4yNjE5NjBdIHVzYiB1c2I2OiBhZGRp
bmcgNi0wOjEuMCAoY29uZmlnICMxLCBpbnRlcmZhY2UgMCkNClsgICAgMS4yNjIwNjhdIGh1
YiA2LTA6MS4wOiB1c2JfcHJvYmVfaW50ZXJmYWNlDQpbICAgIDEuMjYyMDcwXSBodWIgNi0w
OjEuMDogdXNiX3Byb2JlX2ludGVyZmFjZSAtIGdvdCBpZA0KWyAgICAxLjI2MjA3MV0gaHVi
IDYtMDoxLjA6IFVTQiBodWIgZm91bmQNClsgICAgMS4yNjIyNzBdIGh1YiA2LTA6MS4wOiAy
IHBvcnRzIGRldGVjdGVkDQpbICAgIDEuMjYyNDUyXSBodWIgNi0wOjEuMDogc3RhbmRhbG9u
ZSBodWINClsgICAgMS4yNjI0NTNdIGh1YiA2LTA6MS4wOiBubyBwb3dlciBzd2l0Y2hpbmcg
KHVzYiAxLjApDQpbICAgIDEuMjYyNDU0XSBodWIgNi0wOjEuMDogaW5kaXZpZHVhbCBwb3J0
IG92ZXItY3VycmVudCBwcm90ZWN0aW9uDQpbICAgIDEuMjYyNDU1XSBodWIgNi0wOjEuMDog
cG93ZXIgb24gdG8gcG93ZXIgZ29vZCB0aW1lOiAybXMNClsgICAgMS4yNjI0NThdIGh1YiA2
LTA6MS4wOiBsb2NhbCBwb3dlciBzb3VyY2UgaXMgZ29vZA0KWyAgICAxLjI2MjQ2MF0gaHVi
IDYtMDoxLjA6IHRyeWluZyB0byBlbmFibGUgcG9ydCBwb3dlciBvbiBub24tc3dpdGNoYWJs
ZSBodWINClsgICAgMS4yNjI0NzBdIGRyaXZlcnMvdXNiL2NvcmUvaW5vZGUuYzogY3JlYXRp
bmcgZmlsZSAnMDAxJw0KWyAgICAxLjI2MjQ5NF0gZWhjaV9oY2QgMDAwMDowMDoxZC43OiBI
UyBjb21wYW5pb24gZm9yIDAwMDA6MDA6MWQuMA0KWyAgICAxLjI2MjUwN10gICBhbGxvYyBp
cnFfZGVzYyBmb3IgMTkgb24gbm9kZSAtMQ0KWyAgICAxLjI2MjUwOV0gICBhbGxvYyBrc3Rh
dF9pcnFzIG9uIG5vZGUgLTENClsgICAgMS4yNjI1MTJdIHVoY2lfaGNkIDAwMDA6MDA6MWQu
MTogUENJIElOVCBCIC0+IEdTSSAxOSAobGV2ZWwsIGxvdykgLT4gSVJRIDE5DQpbICAgIDEu
MjYyNjk5XSB1aGNpX2hjZCAwMDAwOjAwOjFkLjE6IHNldHRpbmcgbGF0ZW5jeSB0aW1lciB0
byA2NA0KWyAgICAxLjI2MjcwMV0gdWhjaV9oY2QgMDAwMDowMDoxZC4xOiBVSENJIEhvc3Qg
Q29udHJvbGxlcg0KWyAgICAxLjI2Mjg4NF0gZHJpdmVycy91c2IvY29yZS9pbm9kZS5jOiBj
cmVhdGluZyBmaWxlICcwMDcnDQpbICAgIDEuMjYyOTkyXSB1aGNpX2hjZCAwMDAwOjAwOjFk
LjE6IG5ldyBVU0IgYnVzIHJlZ2lzdGVyZWQsIGFzc2lnbmVkIGJ1cyBudW1iZXIgNw0KWyAg
ICAxLjI2MzM0MF0gdWhjaV9oY2QgMDAwMDowMDoxZC4xOiBkZXRlY3RlZCAyIHBvcnRzDQpb
ICAgIDEuMjYzNTI1XSB1aGNpX2hjZCAwMDAwOjAwOjFkLjE6IHVoY2lfY2hlY2tfYW5kX3Jl
c2V0X2hjOiBjbWQgPSAweDAwMDANClsgICAgMS4yNjM1MjddIHVoY2lfaGNkIDAwMDA6MDA6
MWQuMTogUGVyZm9ybWluZyBmdWxsIHJlc2V0DQpbICAgIDEuMjYzNTM4XSB1aGNpX2hjZCAw
MDAwOjAwOjFkLjE6IHN1cHBvcnRzIFVTQiByZW1vdGUgd2FrZXVwDQpbICAgIDEuMjYzNTQ4
XSB1aGNpX2hjZCAwMDAwOjAwOjFkLjE6IGlycSAxOSwgaW8gYmFzZSAweDAwMDBiMDAwDQpb
ICAgIDEuMjYzNzU0XSB1c2IgdXNiNzogZGVmYXVsdCBsYW5ndWFnZSAweDA0MDkNClsgICAg
MS4yNjM3NTldIHVzYiB1c2I3OiB1ZGV2IDEsIGJ1c251bSA3LCBtaW5vciA9IDc2OA0KWyAg
ICAxLjI2Mzc2MV0gdXNiIHVzYjc6IE5ldyBVU0IgZGV2aWNlIGZvdW5kLCBpZFZlbmRvcj0x
ZDZiLCBpZFByb2R1Y3Q9MDAwMQ0KWyAgICAxLjI2Mzk1MF0gdXNiIHVzYjc6IE5ldyBVU0Ig
ZGV2aWNlIHN0cmluZ3M6IE1mcj0zLCBQcm9kdWN0PTIsIFNlcmlhbE51bWJlcj0xDQpbICAg
IDEuMjY0MzA3XSB1c2IgdXNiNzogUHJvZHVjdDogVUhDSSBIb3N0IENvbnRyb2xsZXINClsg
ICAgMS4yNjQ0OTZdIHVzYiB1c2I3OiBNYW51ZmFjdHVyZXI6IExpbnV4IDIuNi4zNC1yYzEg
dWhjaV9oY2QNClsgICAgMS4yNjQ2ODNdIHVzYiB1c2I3OiBTZXJpYWxOdW1iZXI6IDAwMDA6
MDA6MWQuMQ0KWyAgICAxLjI2NDk4M10gdXNiIHVzYjc6IHVzYl9wcm9iZV9kZXZpY2UNClsg
ICAgMS4yNjQ5ODRdIHVzYiB1c2I3OiBjb25maWd1cmF0aW9uICMxIGNob3NlbiBmcm9tIDEg
Y2hvaWNlDQpbICAgIDEuMjY0OTg5XSB1c2IgdXNiNzogYWRkaW5nIDctMDoxLjAgKGNvbmZp
ZyAjMSwgaW50ZXJmYWNlIDApDQpbICAgIDEuMjY1MDkyXSBodWIgNy0wOjEuMDogdXNiX3By
b2JlX2ludGVyZmFjZQ0KWyAgICAxLjI2NTA5M10gaHViIDctMDoxLjA6IHVzYl9wcm9iZV9p
bnRlcmZhY2UgLSBnb3QgaWQNClsgICAgMS4yNjUwOTVdIGh1YiA3LTA6MS4wOiBVU0IgaHVi
IGZvdW5kDQpbICAgIDEuMjY1MzAyXSBodWIgNy0wOjEuMDogMiBwb3J0cyBkZXRlY3RlZA0K
WyAgICAxLjI2NTQ5Ml0gaHViIDctMDoxLjA6IHN0YW5kYWxvbmUgaHViDQpbICAgIDEuMjY1
NDkzXSBodWIgNy0wOjEuMDogbm8gcG93ZXIgc3dpdGNoaW5nICh1c2IgMS4wKQ0KWyAgICAx
LjI2NTQ5NF0gaHViIDctMDoxLjA6IGluZGl2aWR1YWwgcG9ydCBvdmVyLWN1cnJlbnQgcHJv
dGVjdGlvbg0KWyAgICAxLjI2NTQ5NV0gaHViIDctMDoxLjA6IHBvd2VyIG9uIHRvIHBvd2Vy
IGdvb2QgdGltZTogMm1zDQpbICAgIDEuMjY1NDk4XSBodWIgNy0wOjEuMDogbG9jYWwgcG93
ZXIgc291cmNlIGlzIGdvb2QNClsgICAgMS4yNjU1MDBdIGh1YiA3LTA6MS4wOiB0cnlpbmcg
dG8gZW5hYmxlIHBvcnQgcG93ZXIgb24gbm9uLXN3aXRjaGFibGUgaHViDQpbICAgIDEuMjY1
NTEyXSBkcml2ZXJzL3VzYi9jb3JlL2lub2RlLmM6IGNyZWF0aW5nIGZpbGUgJzAwMScNClsg
ICAgMS4yNjU1MzVdIGVoY2lfaGNkIDAwMDA6MDA6MWQuNzogSFMgY29tcGFuaW9uIGZvciAw
MDAwOjAwOjFkLjENClsgICAgMS4yNjU1NDldIHVoY2lfaGNkIDAwMDA6MDA6MWQuMjogUENJ
IElOVCBDIC0+IEdTSSAxOCAobGV2ZWwsIGxvdykgLT4gSVJRIDE4DQpbICAgIDEuMjY1NzQ1
XSB1aGNpX2hjZCAwMDAwOjAwOjFkLjI6IHNldHRpbmcgbGF0ZW5jeSB0aW1lciB0byA2NA0K
WyAgICAxLjI2NTc0N10gdWhjaV9oY2QgMDAwMDowMDoxZC4yOiBVSENJIEhvc3QgQ29udHJv
bGxlcg0KWyAgICAxLjI2NTkzOF0gZHJpdmVycy91c2IvY29yZS9pbm9kZS5jOiBjcmVhdGlu
ZyBmaWxlICcwMDgnDQpbICAgIDEuMjY2MDUzXSB1aGNpX2hjZCAwMDAwOjAwOjFkLjI6IG5l
dyBVU0IgYnVzIHJlZ2lzdGVyZWQsIGFzc2lnbmVkIGJ1cyBudW1iZXIgOA0KWyAgICAxLjI2
NjQxNV0gdWhjaV9oY2QgMDAwMDowMDoxZC4yOiBkZXRlY3RlZCAyIHBvcnRzDQpbICAgIDEu
MjY2NjAyXSB1aGNpX2hjZCAwMDAwOjAwOjFkLjI6IHVoY2lfY2hlY2tfYW5kX3Jlc2V0X2hj
OiBjbWQgPSAweDAwMDANClsgICAgMS4yNjY2MDNdIHVoY2lfaGNkIDAwMDA6MDA6MWQuMjog
UGVyZm9ybWluZyBmdWxsIHJlc2V0DQpbICAgIDEuMjY2NjE1XSB1aGNpX2hjZCAwMDAwOjAw
OjFkLjI6IHN1cHBvcnRzIFVTQiByZW1vdGUgd2FrZXVwDQpbICAgIDEuMjY2NjE5XSB1aGNp
X2hjZCAwMDAwOjAwOjFkLjI6IGlycSAxOCwgaW8gYmFzZSAweDAwMDBiMDgwDQpbICAgIDEu
MjY2ODI5XSB1c2IgdXNiODogZGVmYXVsdCBsYW5ndWFnZSAweDA0MDkNClsgICAgMS4yNjY4
MzRdIHVzYiB1c2I4OiB1ZGV2IDEsIGJ1c251bSA4LCBtaW5vciA9IDg5Ng0KWyAgICAxLjI2
NjgzNV0gdXNiIHVzYjg6IE5ldyBVU0IgZGV2aWNlIGZvdW5kLCBpZFZlbmRvcj0xZDZiLCBp
ZFByb2R1Y3Q9MDAwMQ0KWyAgICAxLjI2NzAyOF0gdXNiIHVzYjg6IE5ldyBVU0IgZGV2aWNl
IHN0cmluZ3M6IE1mcj0zLCBQcm9kdWN0PTIsIFNlcmlhbE51bWJlcj0xDQpbICAgIDEuMjY3
MzkxXSB1c2IgdXNiODogUHJvZHVjdDogVUhDSSBIb3N0IENvbnRyb2xsZXINClsgICAgMS4y
Njc1NzVdIHVzYiB1c2I4OiBNYW51ZmFjdHVyZXI6IExpbnV4IDIuNi4zNC1yYzEgdWhjaV9o
Y2QNClsgICAgMS4yNjc3NjNdIHVzYiB1c2I4OiBTZXJpYWxOdW1iZXI6IDAwMDA6MDA6MWQu
Mg0KWyAgICAxLjI2ODA3MV0gdXNiIHVzYjg6IHVzYl9wcm9iZV9kZXZpY2UNClsgICAgMS4y
NjgwNzNdIHVzYiB1c2I4OiBjb25maWd1cmF0aW9uICMxIGNob3NlbiBmcm9tIDEgY2hvaWNl
DQpbICAgIDEuMjY4MDc4XSB1c2IgdXNiODogYWRkaW5nIDgtMDoxLjAgKGNvbmZpZyAjMSwg
aW50ZXJmYWNlIDApDQpbICAgIDEuMjY4MTg0XSBodWIgOC0wOjEuMDogdXNiX3Byb2JlX2lu
dGVyZmFjZQ0KWyAgICAxLjI2ODE4Nl0gaHViIDgtMDoxLjA6IHVzYl9wcm9iZV9pbnRlcmZh
Y2UgLSBnb3QgaWQNClsgICAgMS4yNjgxODddIGh1YiA4LTA6MS4wOiBVU0IgaHViIGZvdW5k
DQpbICAgIDEuMjY4Mzc2XSBodWIgOC0wOjEuMDogMiBwb3J0cyBkZXRlY3RlZA0KWyAgICAx
LjI3MjQ1Nl0gaHViIDgtMDoxLjA6IHN0YW5kYWxvbmUgaHViDQpbICAgIDEuMjcyNDU3XSBo
dWIgOC0wOjEuMDogbm8gcG93ZXIgc3dpdGNoaW5nICh1c2IgMS4wKQ0KWyAgICAxLjI3MjQ1
OV0gaHViIDgtMDoxLjA6IGluZGl2aWR1YWwgcG9ydCBvdmVyLWN1cnJlbnQgcHJvdGVjdGlv
bg0KWyAgICAxLjI3MjQ2MF0gaHViIDgtMDoxLjA6IHBvd2VyIG9uIHRvIHBvd2VyIGdvb2Qg
dGltZTogMm1zDQpbICAgIDEuMjcyNDYzXSBodWIgOC0wOjEuMDogbG9jYWwgcG93ZXIgc291
cmNlIGlzIGdvb2QNClsgICAgMS4yNzI0NjVdIGh1YiA4LTA6MS4wOiB0cnlpbmcgdG8gZW5h
YmxlIHBvcnQgcG93ZXIgb24gbm9uLXN3aXRjaGFibGUgaHViDQpbICAgIDEuMjcyNDc1XSBk
cml2ZXJzL3VzYi9jb3JlL2lub2RlLmM6IGNyZWF0aW5nIGZpbGUgJzAwMScNClsgICAgMS4y
NzI1MDBdIGVoY2lfaGNkIDAwMDA6MDA6MWQuNzogSFMgY29tcGFuaW9uIGZvciAwMDAwOjAw
OjFkLjINClsgICAgMS4yNzI2MjBdIHhoY2lfaGNkIDAwMDA6MDM6MDAuMDogUENJIElOVCBB
IC0+IEdTSSAxNyAobGV2ZWwsIGxvdykgLT4gSVJRIDE3DQpbICAgIDEuMjcyODE4XSB4aGNp
X2hjZCAwMDAwOjAzOjAwLjA6IHNldHRpbmcgbGF0ZW5jeSB0aW1lciB0byA2NA0KWyAgICAx
LjI3MjgyMV0geGhjaV9oY2QgMDAwMDowMzowMC4wOiB4SENJIEhvc3QgQ29udHJvbGxlcg0K
WyAgICAxLjI3MzAwOF0gZHJpdmVycy91c2IvY29yZS9pbm9kZS5jOiBjcmVhdGluZyBmaWxl
ICcwMDknDQpbICAgIDEuMjczMTIxXSB4aGNpX2hjZCAwMDAwOjAzOjAwLjA6IG5ldyBVU0Ig
YnVzIHJlZ2lzdGVyZWQsIGFzc2lnbmVkIGJ1cyBudW1iZXIgOQ0KWyAgICAxLjI3MzU4OF0g
eGhjaV9oY2QgMDAwMDowMzowMC4wOiBzdXBwb3J0cyBVU0IgcmVtb3RlIHdha2V1cA0KWyAg
ICAxLjI3MzU5OF0geGhjaV9oY2QgMDAwMDowMzowMC4wOiBpcnEgMTcsIGlvIG1lbSAweGZl
OGZlMDAwDQpbICAgIDEuMjczODE0XSB1c2IgdXNiOTogY29uZmlnIDEgaW50ZXJmYWNlIDAg
YWx0c2V0dGluZyAwIGVuZHBvaW50IDB4ODEgaGFzIG5vIFN1cGVyU3BlZWQgY29tcGFuaW9u
IGRlc2NyaXB0b3INClsgICAgMS4yNzQxNjRdIHVzYiB1c2I5OiBkZWZhdWx0IGxhbmd1YWdl
IDB4MDQwOQ0KWyAgICAxLjI3NDE2OF0gdXNiIHVzYjk6IHVkZXYgMSwgYnVzbnVtIDksIG1p
bm9yID0gMTAyNA0KWyAgICAxLjI3NDE3MF0gdXNiIHVzYjk6IE5ldyBVU0IgZGV2aWNlIGZv
dW5kLCBpZFZlbmRvcj0xZDZiLCBpZFByb2R1Y3Q9MDAwMw0KWyAgICAxLjI3NDM2N10gdXNi
IHVzYjk6IE5ldyBVU0IgZGV2aWNlIHN0cmluZ3M6IE1mcj0zLCBQcm9kdWN0PTIsIFNlcmlh
bE51bWJlcj0xDQpbICAgIDEuMjc0NzA1XSB1c2IgdXNiOTogUHJvZHVjdDogeEhDSSBIb3N0
IENvbnRyb2xsZXINClsgICAgMS4yNzQ4OTJdIHVzYiB1c2I5OiBNYW51ZmFjdHVyZXI6IExp
bnV4IDIuNi4zNC1yYzEgeGhjaV9oY2QNClsgICAgMS4yNzUwODJdIHVzYiB1c2I5OiBTZXJp
YWxOdW1iZXI6IDAwMDA6MDM6MDAuMA0KWyAgICAxLjI3NTM5NF0gdXNiIHVzYjk6IHVzYl9w
cm9iZV9kZXZpY2UNClsgICAgMS4yNzUzOTZdIHVzYiB1c2I5OiBjb25maWd1cmF0aW9uICMx
IGNob3NlbiBmcm9tIDEgY2hvaWNlDQpbICAgIDEuMjc1Mzk4XSB4SENJIHhoY2lfYWRkX2Vu
ZHBvaW50IGNhbGxlZCBmb3Igcm9vdCBodWINClsgICAgMS4yNzU0MDBdIHhIQ0kgeGhjaV9j
aGVja19iYW5kd2lkdGggY2FsbGVkIGZvciByb290IGh1Yg0KWyAgICAxLjI3NTQwNF0gdXNi
IHVzYjk6IGFkZGluZyA5LTA6MS4wIChjb25maWcgIzEsIGludGVyZmFjZSAwKQ0KWyAgICAx
LjI3NTUwNl0gaHViIDktMDoxLjA6IHVzYl9wcm9iZV9pbnRlcmZhY2UNClsgICAgMS4yNzU1
MDhdIGh1YiA5LTA6MS4wOiB1c2JfcHJvYmVfaW50ZXJmYWNlIC0gZ290IGlkDQpbICAgIDEu
Mjc1NTA5XSBodWIgOS0wOjEuMDogVVNCIGh1YiBmb3VuZA0KWyAgICAxLjI3NTY5NF0gaHVi
IDktMDoxLjA6IDQgcG9ydHMgZGV0ZWN0ZWQNClsgICAgMS4yNzU4NzVdIGh1YiA5LTA6MS4w
OiBzdGFuZGFsb25lIGh1Yg0KWyAgICAxLjI3NTg3Nl0gaHViIDktMDoxLjA6IGluZGl2aWR1
YWwgcG9ydCBwb3dlciBzd2l0Y2hpbmcNClsgICAgMS4yNzU4NzhdIGh1YiA5LTA6MS4wOiBp
bmRpdmlkdWFsIHBvcnQgb3Zlci1jdXJyZW50IHByb3RlY3Rpb24NClsgICAgMS4yNzU4Nzld
IGh1YiA5LTA6MS4wOiBUVCByZXF1aXJlcyBhdCBtb3N0IDggRlMgYml0IHRpbWVzICg2NjYg
bnMpDQpbICAgIDEuMjc1ODgxXSBodWIgOS0wOjEuMDogcG93ZXIgb24gdG8gcG93ZXIgZ29v
ZCB0aW1lOiAyMG1zDQpbICAgIDEuMjc1ODg0XSBodWIgOS0wOjEuMDogbG9jYWwgcG93ZXIg
c291cmNlIGlzIGdvb2QNClsgICAgMS4yNzU4ODVdIGh1YiA5LTA6MS4wOiBlbmFibGluZyBw
b3dlciBvbiBhbGwgcG9ydHMNClsgICAgMS4yNzU5MTBdIGRyaXZlcnMvdXNiL2NvcmUvaW5v
ZGUuYzogY3JlYXRpbmcgZmlsZSAnMDAxJw0KWyAgICAxLjI3NjAzMl0gc2w4MTE6IGRyaXZl
ciBzbDgxMS1oY2QsIDE5IE1heSAyMDA1DQpbICAgIDEuMjc2NDIzXSByOGE2NjU5N19oY2Q6
IGRyaXZlciByOGE2NjU5N19oY2QsIDIwMDktMDUtMjYNClsgICAgMS4yNzcxOTVdIHVzYmNv
cmU6IHJlZ2lzdGVyZWQgbmV3IGludGVyZmFjZSBkcml2ZXIgdXNibHANClsgICAgMS4yNzcz
ODRdIEluaXRpYWxpemluZyBVU0IgTWFzcyBTdG9yYWdlIGRyaXZlci4uLg0KWyAgICAxLjI3
NzY4MF0gdXNiY29yZTogcmVnaXN0ZXJlZCBuZXcgaW50ZXJmYWNlIGRyaXZlciB1c2Itc3Rv
cmFnZQ0KWyAgICAxLjI3Nzg2Ml0gVVNCIE1hc3MgU3RvcmFnZSBzdXBwb3J0IHJlZ2lzdGVy
ZWQuDQpbICAgIDEuMjc4MTY1XSB1c2Jjb3JlOiByZWdpc3RlcmVkIG5ldyBpbnRlcmZhY2Ug
ZHJpdmVyIGxpYnVzdWFsDQpbICAgIDEuMjc4NTMyXSBQTlA6IFBTLzIgQ29udHJvbGxlciBb
UE5QMDMwMzpQUzJLLFBOUDBmMDM6UFMyTV0gYXQgMHg2MCwweDY0IGlycSAxLDEyDQpbICAg
IDEuMjgxMzk2XSBzZXJpbzogaTgwNDIgS0JEIHBvcnQgYXQgMHg2MCwweDY0IGlycSAxDQpb
ICAgIDEuMjgxNTk0XSBzZXJpbzogaTgwNDIgQVVYIHBvcnQgYXQgMHg2MCwweDY0IGlycSAx
Mg0KWyAgICAxLjI4MTk5OV0gbWljZTogUFMvMiBtb3VzZSBkZXZpY2UgY29tbW9uIGZvciBh
bGwgbWljZQ0KWyAgICAxLjI4MjYyMl0gcnRjX2Ntb3MgMDA6MDM6IFJUQyBjYW4gd2FrZSBm
cm9tIFM0DQpbICAgIDEuMjgyOTA5XSBydGNfY21vcyAwMDowMzogcnRjIGNvcmU6IHJlZ2lz
dGVyZWQgcnRjX2Ntb3MgYXMgcnRjMA0KWyAgICAxLjI4MzEyNl0gcnRjMDogYWxhcm1zIHVw
IHRvIG9uZSBtb250aCwgeTNrLCAxMTQgYnl0ZXMgbnZyYW0sIGhwZXQgaXJxcw0KWyAgICAx
LjI4MzQ0N10gaTgwMV9zbWJ1cyAwMDAwOjAwOjFmLjM6IFBDSSBJTlQgQyAtPiBHU0kgMTgg
KGxldmVsLCBsb3cpIC0+IElSUSAxOA0KWyAgICAxLjI4Mzc4NV0gQUNQSTogSS9PIHJlc291
cmNlIDAwMDA6MDA6MWYuMyBbMHg0MDAtMHg0MWZdIGNvbmZsaWN0cyB3aXRoIEFDUEkgcmVn
aW9uIFNNUkcgWzB4NDAwLTB4NDBmXQ0KWyAgICAxLjI4NDEzM10gQUNQSTogSWYgYW4gQUNQ
SSBkcml2ZXIgaXMgYXZhaWxhYmxlIGZvciB0aGlzIGRldmljZSwgeW91IHNob3VsZCB1c2Ug
aXQgaW5zdGVhZCBvZiB0aGUgbmF0aXZlIGRyaXZlcg0KWyAgICAxLjI4NDkzNF0gZGV2aWNl
LW1hcHBlcjogaW9jdGw6IDQuMTcuMC1pb2N0bCAoMjAxMC0wMy0wNSkgaW5pdGlhbGlzZWQ6
IGRtLWRldmVsQHJlZGhhdC5jb20NClsgICAgMS4yODY3MjBdIGNwdWlkbGU6IHVzaW5nIGdv
dmVybm9yIGxhZGRlcg0KWyAgICAxLjI4OTI4NF0gY3B1aWRsZTogdXNpbmcgZ292ZXJub3Ig
bWVudQ0KWyAgICAxLjI5MTU1OV0gdXNiY29yZTogcmVnaXN0ZXJlZCBuZXcgaW50ZXJmYWNl
IGRyaXZlciBoaWRkZXYNClsgICAgMS4yOTE4MDhdIHVzYmNvcmU6IHJlZ2lzdGVyZWQgbmV3
IGludGVyZmFjZSBkcml2ZXIgdXNiaGlkDQpbICAgIDEuMjkxOTkxXSB1c2JoaWQ6IFVTQiBI
SUQgY29yZSBkcml2ZXINClsgICAgMS4yOTQ2MTJdIEhEQSBJbnRlbCAwMDAwOjAwOjFiLjA6
IFBDSSBJTlQgQSAtPiBHU0kgMjIgKGxldmVsLCBsb3cpIC0+IElSUSAyMg0KWyAgICAxLjI5
NDk3OV0gICBhbGxvYyBpcnFfZGVzYyBmb3IgMzYgb24gbm9kZSAtMQ0KWyAgICAxLjI5NDk4
MV0gICBhbGxvYyBrc3RhdF9pcnFzIG9uIG5vZGUgLTENClsgICAgMS4yOTQ5OTBdIEhEQSBJ
bnRlbCAwMDAwOjAwOjFiLjA6IGlycSAzNiBmb3IgTVNJL01TSS1YDQpbICAgIDEuMjk1MDE3
XSBIREEgSW50ZWwgMDAwMDowMDoxYi4wOiBzZXR0aW5nIGxhdGVuY3kgdGltZXIgdG8gNjQN
ClsgICAgMS4zMDYwMTZdIGlucHV0OiBBVCBUcmFuc2xhdGVkIFNldCAyIGtleWJvYXJkIGFz
IC9kZXZpY2VzL3BsYXRmb3JtL2k4MDQyL3NlcmlvMC9pbnB1dC9pbnB1dDINClsgICAgMS4z
MTAxMzFdIEFMU0EgZGV2aWNlIGxpc3Q6DQpbICAgIDEuMzEwMzMzXSAgICMwOiBIREEgSW50
ZWwgYXQgMHhmZTZmMDAwMCBpcnEgMzYNClsgICAgMS4zMTA1NzZdIE5ldGZpbHRlciBtZXNz
YWdlcyB2aWEgTkVUTElOSyB2MC4zMC4NClsgICAgMS4zMTA3ODZdIG5mX2Nvbm50cmFjayB2
ZXJzaW9uIDAuNS4wICgxNjM4NCBidWNrZXRzLCA2NTUzNiBtYXgpDQpbICAgIDEuMzExMTUx
XSBjdG5ldGxpbmsgdjAuOTM6IHJlZ2lzdGVyaW5nIHdpdGggbmZuZXRsaW5rLg0KWyAgICAx
LjMxMTcyMV0gaXBfdGFibGVzOiAoQykgMjAwMC0yMDA2IE5ldGZpbHRlciBDb3JlIFRlYW0N
ClsgICAgMS4zMTE5MzFdIFRDUCBjdWJpYyByZWdpc3RlcmVkDQpbICAgIDEuMzEyMTI0XSBJ
bml0aWFsaXppbmcgWEZSTSBuZXRsaW5rIHNvY2tldA0KWyAgICAxLjMxMjc2MV0gTkVUOiBS
ZWdpc3RlcmVkIHByb3RvY29sIGZhbWlseSAxMA0KWyAgICAxLjMxMzU1MV0gaXA2X3RhYmxl
czogKEMpIDIwMDAtMjAwNiBOZXRmaWx0ZXIgQ29yZSBUZWFtDQpbICAgIDEuMzEzNzc5XSBJ
UHY2IG92ZXIgSVB2NCB0dW5uZWxpbmcgZHJpdmVyDQpbICAgIDEuMzE0NDMxXSBORVQ6IFJl
Z2lzdGVyZWQgcHJvdG9jb2wgZmFtaWx5IDE3DQpbICAgIDEuMzE2NTA3XSBQTTogUmVzdW1l
IGZyb20gZGlzayBmYWlsZWQuDQpbICAgIDEuMzE2NTE4XSByZWdpc3RlcmVkIHRhc2tzdGF0
cyB2ZXJzaW9uIDENClsgICAgMS4zMTcwMTRdICAgTWFnaWMgbnVtYmVyOiAyOjU4OjkxNQ0K
WyAgICAxLjMzMzMwMl0gaHViIDEtMDoxLjA6IHN0YXRlIDcgcG9ydHMgNiBjaGcgMDAwMCBl
dnQgMDAwMA0KWyAgICAxLjM0OTM0N10gaHViIDItMDoxLjA6IHN0YXRlIDcgcG9ydHMgNiBj
aGcgMDAwMCBldnQgMDAwMA0KWyAgICAxLjM1MjQ0MV0gaHViIDMtMDoxLjA6IHN0YXRlIDcg
cG9ydHMgMiBjaGcgMDAwMCBldnQgMDAwMA0KWyAgICAxLjM1NTEyN10gaHViIDQtMDoxLjA6
IHN0YXRlIDcgcG9ydHMgMiBjaGcgMDAwMCBldnQgMDAwMA0KWyAgICAxLjM1OTEwM10gaHVi
IDUtMDoxLjA6IHN0YXRlIDcgcG9ydHMgMiBjaGcgMDAwMCBldnQgMDAwMA0KWyAgICAxLjM2
MjA5OF0gaHViIDYtMDoxLjA6IHN0YXRlIDcgcG9ydHMgMiBjaGcgMDAwMCBldnQgMDAwMA0K
WyAgICAxLjM2NTEwNV0gaHViIDctMDoxLjA6IHN0YXRlIDcgcG9ydHMgMiBjaGcgMDAwMCBl
dnQgMDAwMA0KWyAgICAxLjM3MjI5NV0gaHViIDgtMDoxLjA6IHN0YXRlIDcgcG9ydHMgMiBj
aGcgMDAwMCBldnQgMDAwMA0KWyAgICAxLjM3NTA5NF0gaHViIDktMDoxLjA6IHBvcnQgMzog
c3RhdHVzIDAxMDEgY2hhbmdlIDAwMDENClsgICAgMS4zODExMDBdIGF0YTI6IFNBVEEgbGlu
ayBkb3duIChTU3RhdHVzIDAgU0NvbnRyb2wgMzcwKQ0KWyAgICAxLjM4MTEwOF0gYXRhMTog
U0FUQSBsaW5rIGRvd24gKFNTdGF0dXMgMCBTQ29udHJvbCAzNzApDQpbICAgIDEuMzk3NzE1
XSBhdGE1OiBTQVRBIGxpbmsgZG93biAoU1N0YXR1cyAwIFNDb250cm9sIDMwMCkNClsgICAg
MS40MDgzMzRdIGF0YTY6IFNBVEEgbGluayBkb3duIChTU3RhdHVzIDAgU0NvbnRyb2wgMzAw
KQ0KWyAgICAxLjQ3MDMwOV0gbG9naXBzMnBwOiBEZXRlY3RlZCB1bmtub3duIGxvZ2l0ZWNo
IG1vdXNlIG1vZGVsIDU3DQpbICAgIDEuNDc1MDk0XSBodWIgOS0wOjEuMDogc3RhdGUgNyBw
b3J0cyA0IGNoZyAwMDA4IGV2dCAwMDAwDQpbICAgIDEuNDc1MTAxXSBodWIgOS0wOjEuMDog
cG9ydCAzLCBzdGF0dXMgMDEwMSwgY2hhbmdlIDAwMDAsIDEyIE1iL3MNClsgICAgMS41Nzcx
NTNdIHVzYiA5LTM6IG5ldyBmdWxsIHNwZWVkIFVTQiBkZXZpY2UgdXNpbmcgeGhjaV9oY2Qg
YW5kIGFkZHJlc3MgMA0KWyAgICAxLjU5NDA0MV0gdXNiIDktMzogZXAwIG1heHBhY2tldCA9
IDgNClsgICAgMS41OTQxNzBdIHVzYiA5LTM6IFN1Y2Nlc3NmdWwgZXZhbHVhdGUgY29udGV4
dCBjb21tYW5kDQpbICAgIDEuNjk4NzQ3XSBhdGE0LjAwOiBTQVRBIGxpbmsgZG93biAoU1N0
YXR1cyAwIFNDb250cm9sIDMwMCkNClsgICAgMS42OTg5NDRdIGF0YTQuMDE6IFNBVEEgbGlu
ayBkb3duIChTU3RhdHVzIDAgU0NvbnRyb2wgMzAwKQ0KWyAgICAxLjczODA0M10gdXNiIDkt
Mzogc2tpcHBlZCA0IGRlc2NyaXB0b3JzIGFmdGVyIGludGVyZmFjZQ0KWyAgICAxLjczODA0
NV0gdXNiIDktMzogc2tpcHBlZCAyIGRlc2NyaXB0b3JzIGFmdGVyIGludGVyZmFjZQ0KWyAg
ICAxLjczODA0OF0gdXNiIDktMzogc2tpcHBlZCAxIGRlc2NyaXB0b3IgYWZ0ZXIgZW5kcG9p
bnQNClsgICAgMS43MzgwNTBdIHVzYiA5LTM6IHNraXBwZWQgMiBkZXNjcmlwdG9ycyBhZnRl
ciBpbnRlcmZhY2UNClsgICAgMS43MzgwNTNdIHVzYiA5LTM6IHNraXBwZWQgMSBkZXNjcmlw
dG9yIGFmdGVyIGVuZHBvaW50DQpbICAgIDEuNzM4MDU1XSB1c2IgOS0zOiBza2lwcGVkIDIg
ZGVzY3JpcHRvcnMgYWZ0ZXIgaW50ZXJmYWNlDQpbICAgIDEuNzM4MDU3XSB1c2IgOS0zOiBz
a2lwcGVkIDEgZGVzY3JpcHRvciBhZnRlciBlbmRwb2ludA0KWyAgICAxLjczODA1OV0gdXNi
IDktMzogc2tpcHBlZCAyIGRlc2NyaXB0b3JzIGFmdGVyIGludGVyZmFjZQ0KWyAgICAxLjcz
ODA2MV0gdXNiIDktMzogc2tpcHBlZCAxIGRlc2NyaXB0b3IgYWZ0ZXIgZW5kcG9pbnQNClsg
ICAgMS43NDEwMjFdIHhoY2lfaGNkIDAwMDA6MDM6MDAuMDogV0FSTjogc2hvcnQgdHJhbnNm
ZXIgb24gY29udHJvbCBlcA0KWyAgICAxLjc0MjAzOV0gdXNiIDktMzogZGVmYXVsdCBsYW5n
dWFnZSAweDA0MDkNClsgICAgMS43NjUwMTZdIHhoY2lfaGNkIDAwMDA6MDM6MDAuMDogV0FS
Tjogc2hvcnQgdHJhbnNmZXIgb24gY29udHJvbCBlcA0KWyAgICAxLjc2NjAzNl0gdXNiIDkt
MzogdWRldiAyLCBidXNudW0gOSwgbWlub3IgPSAxMDI1DQpbICAgIDEuNzY2MDM4XSB1c2Ig
OS0zOiBOZXcgVVNCIGRldmljZSBmb3VuZCwgaWRWZW5kb3I9MDQ3MSwgaWRQcm9kdWN0PTAz
MTENClsgICAgMS43NjYyNDRdIHVzYiA5LTM6IE5ldyBVU0IgZGV2aWNlIHN0cmluZ3M6IE1m
cj0wLCBQcm9kdWN0PTAsIFNlcmlhbE51bWJlcj0xDQpbICAgIDEuNzY2NDQ4XSB1c2IgOS0z
OiBTZXJpYWxOdW1iZXI6IDAxNjgwMDAwRUExNjQxMDENClsgICAgMS43NjY4MTFdIHVzYiA5
LTM6IHVzYl9wcm9iZV9kZXZpY2UNClsgICAgMS43NjY4MTNdIHVzYiA5LTM6IGNvbmZpZ3Vy
YXRpb24gIzEgY2hvc2VuIGZyb20gMSBjaG9pY2UNClsgICAgMS43NjcxODRdIHVzYiA5LTM6
IFN1Y2Nlc3NmdWwgRW5kcG9pbnQgQ29uZmlndXJlIGNvbW1hbmQNClsgICAgMS43NjkwMzVd
IHVzYiA5LTM6IGFkZGluZyA5LTM6MS4wIChjb25maWcgIzEsIGludGVyZmFjZSAwKQ0KWyAg
ICAxLjc2OTE1MV0gdXNiIDktMzogYWRkaW5nIDktMzoxLjEgKGNvbmZpZyAjMSwgaW50ZXJm
YWNlIDEpDQpbICAgIDEuNzY5MjM1XSB1c2IgOS0zOiBhZGRpbmcgOS0zOjEuMiAoY29uZmln
ICMxLCBpbnRlcmZhY2UgMikNClsgICAgMS43NjkzMTldIGRyaXZlcnMvdXNiL2NvcmUvaW5v
ZGUuYzogY3JlYXRpbmcgZmlsZSAnMDAyJw0KWyAgICAxLjgzOTE0Ml0gYXRhMy4wMDogU0FU
QSBsaW5rIHVwIDEuNSBHYnBzIChTU3RhdHVzIDExMyBTQ29udHJvbCAzMDApDQpbICAgIDEu
ODM5MzU2XSBhdGEzLjAxOiBTQVRBIGxpbmsgZG93biAoU1N0YXR1cyAwIFNDb250cm9sIDMw
MCkNClsgICAgMS44NDIyMTldIGF0YTMuMDA6IEFUQS03OiBXREMgV0Q4MDBKRC02ME1TQTEs
IDEwLjAxRTAxLCBtYXggVURNQS8xMDANClsgICAgMS44NDI0MDldIGF0YTMuMDA6IDE1NjMw
MTQ4OCBzZWN0b3JzLCBtdWx0aSAxNjogTEJBNDggTkNRIChkZXB0aCAwLzMyKQ0KWyAgICAx
Ljg0NTIyNF0gYXRhMy4wMDogY29uZmlndXJlZCBmb3IgVURNQS8xMDANClsgICAgMS44NDU1
MDldIHNjc2kgMjowOjA6MDogRGlyZWN0LUFjY2VzcyAgICAgQVRBICAgICAgV0RDIFdEODAw
SkQtNjBNUyAxMC4wIFBROiAwIEFOU0k6IDUNClsgICAgMS44NDYyNjldIHNkIDI6MDowOjA6
IFtzZGFdIDE1NjMwMTQ4OCA1MTItYnl0ZSBsb2dpY2FsIGJsb2NrczogKDgwLjAgR0IvNzQu
NSBHaUIpDQpbICAgIDEuODQ2NDI0XSBzZCAyOjA6MDowOiBBdHRhY2hlZCBzY3NpIGdlbmVy
aWMgc2cwIHR5cGUgMA0KWyAgICAxLjg0NjkyNV0gc2QgMjowOjA6MDogW3NkYV0gV3JpdGUg
UHJvdGVjdCBpcyBvZmYNClsgICAgMS44NDcxMjZdIHNkIDI6MDowOjA6IFtzZGFdIE1vZGUg
U2Vuc2U6IDAwIDNhIDAwIDAwDQpbICAgIDEuODQ3MTQ4XSBzZCAyOjA6MDowOiBbc2RhXSBX
cml0ZSBjYWNoZTogZW5hYmxlZCwgcmVhZCBjYWNoZTogZW5hYmxlZCwgZG9lc24ndCBzdXBw
b3J0IERQTyBvciBGVUENClsgICAgMS44NDc2MDVdICBzZGE6IHNkYTEgc2RhMiA8IHNkYTUg
Pg0KWyAgICAxLjg4NzIwOV0gc2QgMjowOjA6MDogW3NkYV0gQXR0YWNoZWQgU0NTSSBkaXNr
DQpbICAgIDEuODg3NDQwXSBGcmVlaW5nIHVudXNlZCBrZXJuZWwgbWVtb3J5OiA1NjRrIGZy
ZWVkDQpbICAgIDEuODg3NzY3XSBXcml0ZSBwcm90ZWN0aW5nIHRoZSBrZXJuZWwgcmVhZC1v
bmx5IGRhdGE6IDEyMjg4aw0KWyAgICAxLjg4ODIzN10gRnJlZWluZyB1bnVzZWQga2VybmVs
IG1lbW9yeTogMTc3MmsgZnJlZWQNClsgICAgMS44ODkwMjddIEZyZWVpbmcgdW51c2VkIGtl
cm5lbCBtZW1vcnk6IDExNTZrIGZyZWVkDQpbICAgIDEuOTM3MTk3XSBpbnB1dDogSW1FeFBT
LzIgTG9naXRlY2ggRXhwbG9yZXIgTW91c2UgYXMgL2RldmljZXMvcGxhdGZvcm0vaTgwNDIv
c2VyaW8xL2lucHV0L2lucHV0Mw0KWyAgICAyLjI2NTY0N10gUE06IFN0YXJ0aW5nIG1hbnVh
bCByZXN1bWUgZnJvbSBkaXNrDQpbICAgIDIuMjY1ODM0XSBQTTogUmVzdW1lIGZyb20gcGFy
dGl0aW9uIDg6NQ0KWyAgICAyLjI2NTgzNV0gUE06IENoZWNraW5nIGhpYmVybmF0aW9uIGlt
YWdlLg0KWyAgICAyLjI2NjAwMl0gUE06IEVycm9yIC0yMiBjaGVja2luZyBpbWFnZSBmaWxl
DQpbICAgIDIuMjY2MDAzXSBQTTogUmVzdW1lIGZyb20gZGlzayBmYWlsZWQuDQpbICAgIDIu
MjcwODc1XSBQTTogTWFya2luZyBub3NhdmUgcGFnZXM6IDAwMDAwMDAwMDAwOWYwMDAgLSAw
MDAwMDAwMDAwMTAwMDAwDQpbICAgIDIuMjcwODc5XSBQTTogQmFzaWMgbWVtb3J5IGJpdG1h
cHMgY3JlYXRlZA0KWyAgICAyLjI4NTIzMF0gUE06IEJhc2ljIG1lbW9yeSBiaXRtYXBzIGZy
ZWVkDQpbICAgIDIuMzI3NjMwXSBram91cm5hbGQgc3RhcnRpbmcuICBDb21taXQgaW50ZXJ2
YWwgNSBzZWNvbmRzDQpbICAgIDIuMzI3NjY3XSBFWFQzLWZzIChzZGExKTogbW91bnRlZCBm
aWxlc3lzdGVtIHdpdGggd3JpdGViYWNrIGRhdGEgbW9kZQ0KWyAgICAyLjQ1NDAzMl0gdXNi
IHVzYjM6IHN1c3BlbmRfcmggKGF1dG8tc3RvcCkNClsgICAgMi40NTQwNTJdIHVzYiB1c2I0
OiBzdXNwZW5kX3JoIChhdXRvLXN0b3ApDQpbICAgIDIuNDU0MDcwXSB1c2IgdXNiNTogc3Vz
cGVuZF9yaCAoYXV0by1zdG9wKQ0KWyAgICAyLjQ1NDA4N10gdXNiIHVzYjY6IHN1c3BlbmRf
cmggKGF1dG8tc3RvcCkNClsgICAgMi40NTQxMDVdIHVzYiB1c2I3OiBzdXNwZW5kX3JoIChh
dXRvLXN0b3ApDQpbICAgIDIuNDU0MTIzXSB1c2IgdXNiODogc3VzcGVuZF9yaCAoYXV0by1z
dG9wKQ0KWyAgICAzLjYxMzk3OF0gdWRldmQgdmVyc2lvbiAxMjUgc3RhcnRlZA0KWyAgICA0
LjQyMTQ2MV0gTGludXggdmlkZW8gY2FwdHVyZSBpbnRlcmZhY2U6IHYyLjAwDQpbICAgIDQu
NDgxODMzXSBwd2M6IFBoaWxpcHMgd2ViY2FtIG1vZHVsZSB2ZXJzaW9uIDEwLjAuMTMgbG9h
ZGVkLg0KWyAgICA0LjQ4MjA0Ml0gcHdjOiBTdXBwb3J0cyBQaGlsaXBzIFBDQTY0NS82NDYs
IFBDVkM2NzUvNjgwLzY5MCwgUENWQzcyMFs0MF0vNzMwLzc0MC83NTAgJiBQQ1ZDODMwLzg0
MC4NClsgICAgNC40ODI0MzZdIHB3YzogQWxzbyBzdXBwb3J0cyB0aGUgQXNrZXkgVkMwMTAs
IHZhcmlvdXMgTG9naXRlY2ggUXVpY2tjYW1zLCBTYW1zdW5nIE1QQy1DMTAgYW5kIE1QQy1D
MzAsDQpbICAgIDQuNDgyNzkxXSBwd2M6IHRoZSBDcmVhdGl2ZSBXZWJDYW0gNSAmIFBybyBF
eCwgU09URUMgQWZpbmEgRXllIGFuZCBWaXNpb25pdGUgVkNTLVVDMzAwIGFuZCBWQ1MtVU0x
MDAuDQpbICAgIDQuNDgzMTUyXSBwd2M6IFRyYWNlIG9wdGlvbnM6IDB4MDAwMQ0KWyAgICA0
LjQ4MzE3MV0gUGhpbGlwcyB3ZWJjYW0gOS0zOjEuMDogdXNiX3Byb2JlX2ludGVyZmFjZQ0K
WyAgICA0LjQ4MzE3M10gUGhpbGlwcyB3ZWJjYW0gOS0zOjEuMDogdXNiX3Byb2JlX2ludGVy
ZmFjZSAtIGdvdCBpZA0KWyAgICA0LjQ4MzE3NF0gcHdjOiBQaGlsaXBzIFBDVkM3NDBLIChU
b1VDYW0gUHJvKS9QQ1ZDODQwIChUb1VDYW0gSUkpIFVTQiB3ZWJjYW0gZGV0ZWN0ZWQuDQpb
ICAgIDQuNTE1ODMzXSB4aGNpX2hjZCAwMDAwOjAzOjAwLjA6IFdBUk46IHNob3J0IHRyYW5z
ZmVyIG9uIGNvbnRyb2wgZXANClsgICAgNC41MTY4OTRdIHB3YzogUmVnaXN0ZXJlZCBhcyB2
aWRlbzAuDQpbICAgIDQuNTE4ODM0XSB4aGNpX2hjZCAwMDAwOjAzOjAwLjA6IFdBUk46IFN0
YWxsZWQgZW5kcG9pbnQNClsgICAgNC41MjA4MzRdIHhoY2lfaGNkIDAwMDA6MDM6MDAuMDog
V0FSTjogU3RhbGxlZCBlbmRwb2ludA0KWyAgICA0LjUyMTA1MV0gUGhpbGlwcyB3ZWJjYW0g
OS0zOjEuMTogdXNiX3Byb2JlX2ludGVyZmFjZQ0KWyAgICA0LjUyMTA1M10gUGhpbGlwcyB3
ZWJjYW0gOS0zOjEuMTogdXNiX3Byb2JlX2ludGVyZmFjZSAtIGdvdCBpZA0KWyAgICA0LjUy
MTA1OF0gUGhpbGlwcyB3ZWJjYW0gOS0zOjEuMjogdXNiX3Byb2JlX2ludGVyZmFjZQ0KWyAg
ICA0LjUyMTA2MF0gUGhpbGlwcyB3ZWJjYW0gOS0zOjEuMjogdXNiX3Byb2JlX2ludGVyZmFj
ZSAtIGdvdCBpZA0KWyAgICA0LjUyMTA3M10gdXNiY29yZTogcmVnaXN0ZXJlZCBuZXcgaW50
ZXJmYWNlIGRyaXZlciBQaGlsaXBzIHdlYmNhbQ0KWyAgICA1LjUwODA4OV0gQWRkaW5nIDMy
MjkwMjhrIHN3YXAgb24gL2Rldi9zZGE1LiAgUHJpb3JpdHk6LTEgZXh0ZW50czoxIGFjcm9z
czozMjI5MDI4ayANClsgICAgNS43NzcwOTNdIEVYVDMtZnMgKHNkYTEpOiB1c2luZyBpbnRl
cm5hbCBqb3VybmFsDQpbICAgIDguMzg5MTk5XSBlMTAwMGUgMDAwMDowMDoxOS4wOiBpcnEg
MzUgZm9yIE1TSS9NU0ktWA0KWyAgICA4LjQ0MDA2Ml0gZTEwMDBlIDAwMDA6MDA6MTkuMDog
aXJxIDM1IGZvciBNU0kvTVNJLVgNClsgICAgOC40NDA0MDVdIEFERFJDT05GKE5FVERFVl9V
UCk6IGV0aDE6IGxpbmsgaXMgbm90IHJlYWR5DQpbICAgIDkuOTc4OTA2XSBlMTAwMGU6IGV0
aDEgTklDIExpbmsgaXMgVXAgMTAwIE1icHMgRnVsbCBEdXBsZXgsIEZsb3cgQ29udHJvbDog
UlgvVFgNClsgICAgOS45NzkyNjZdIDAwMDA6MDA6MTkuMDogZXRoMTogMTAvMTAwIHNwZWVk
OiBkaXNhYmxpbmcgVFNPDQpbICAgIDkuOTc5NzcyXSBBRERSQ09ORihORVRERVZfQ0hBTkdF
KTogZXRoMTogbGluayBiZWNvbWVzIHJlYWR5DQpbICAgMTIuOTU3NTkzXSB1c2IgOS0zOiBT
dWNjZXNzZnVsIEVuZHBvaW50IENvbmZpZ3VyZSBjb21tYW5kDQpbICAgMTIuOTY3NTQyXSB1
c2IgOS0zOiBlcCAweDg1IC0gdXJiIGxlbiA9IDB4MjU4MCAoOTYwMCksIGFkZHIgPSAweDdh
Yzc0MDAwLCBudW1fdHJicyA9IDEwDQpbICAgMTIuOTY3NTUzXSB1c2IgOS0zOiBlcCAweDg1
IC0gdXJiIGxlbiA9IDB4MjU4MCAoOTYwMCksIGFkZHIgPSAweDdhZjhjMDAwLCBudW1fdHJi
cyA9IDEwDQpbICAgMTIuOTg1NTAwXSB4aGNpX2hjZCAwMDAwOjAzOjAwLjA6IFdBUk4gRXZl
bnQgVFJCIGZvciBzbG90IDEgZXAgMTAgd2l0aCBubyBURHMgcXVldWVkPw0KWyAgIDIwLjk0
NjExNl0gZXRoMTogbm8gSVB2NiByb3V0ZXJzIHByZXNlbnQNClsgICA0MC4wMjkyNzldIHVz
YiA5LTM6IFN1Y2Nlc3NmdWwgRW5kcG9pbnQgQ29uZmlndXJlIGNvbW1hbmQNClsgICA0MC4w
MzkxODZdIHVzYiA5LTM6IGVwIDB4ODUgLSB1cmIgbGVuID0gMHgyNTgwICg5NjAwKSwgYWRk
ciA9IDB4N2E4MTQwMDAsIG51bV90cmJzID0gMTANClsgICA0MC4wMzkxOThdIHVzYiA5LTM6
IGVwIDB4ODUgLSB1cmIgbGVuID0gMHgyNTgwICg5NjAwKSwgYWRkciA9IDB4N2I3MzQwMDAs
IG51bV90cmJzID0gMTANClsgICA0MC4wNTcxOTVdIHhoY2lfaGNkIDAwMDA6MDM6MDAuMDog
V0FSTiBFdmVudCBUUkIgZm9yIHNsb3QgMSBlcCAxMCB3aXRoIG5vIFREcyBxdWV1ZWQ/DQpb
ICAgNDAuMjE2MjcwXSB1c2IgOS0zOiBTdWNjZXNzZnVsIEVuZHBvaW50IENvbmZpZ3VyZSBj
b21tYW5kDQpbICAgNDAuMjI2MTgzXSB1c2IgOS0zOiBlcCAweDg1IC0gdXJiIGxlbiA9IDB4
MjU4MCAoOTYwMCksIGFkZHIgPSAweDdhOWMwMDAwLCBudW1fdHJicyA9IDEwDQpbICAgNDAu
MjI2MTkzXSB1c2IgOS0zOiBlcCAweDg1IC0gdXJiIGxlbiA9IDB4MjU4MCAoOTYwMCksIGFk
ZHIgPSAweDdhOThjMDAwLCBudW1fdHJicyA9IDEwDQpbICAgNDAuMjQ1MTgzXSB4aGNpX2hj
ZCAwMDAwOjAzOjAwLjA6IFdBUk4gRXZlbnQgVFJCIGZvciBzbG90IDEgZXAgMTAgd2l0aCBu
byBURHMgcXVldWVkPw0KWyAgIDQwLjM5OTI2MV0gdXNiIDktMzogU3VjY2Vzc2Z1bCBFbmRw
b2ludCBDb25maWd1cmUgY29tbWFuZA0KWyAgIDQwLjQwODIxMF0gdXNiIDktMzogZXAgMHg4
NSAtIHVyYiBsZW4gPSAweDI1ODAgKDk2MDApLCBhZGRyID0gMHg3YTljMDAwMCwgbnVtX3Ry
YnMgPSAxMA0KWyAgIDQwLjQwODIyMF0gdXNiIDktMzogZXAgMHg4NSAtIHVyYiBsZW4gPSAw
eDI1ODAgKDk2MDApLCBhZGRyID0gMHg3YTk4YzAwMCwgbnVtX3RyYnMgPSAxMA0KWyAgIDQ3
LjE0NTgwNV0geGhjaV9oY2QgMDAwMDowMzowMC4wOiBXQVJOIEV2ZW50IFRSQiBmb3Igc2xv
dCAxIGVwIDEwIHdpdGggbm8gVERzIHF1ZXVlZD8NClsgICA0OC4wNzY4OTRdIHVzYiA5LTM6
IFN1Y2Nlc3NmdWwgRW5kcG9pbnQgQ29uZmlndXJlIGNvbW1hbmQNClsgICA0OC4wODY4MDVd
IHVzYiA5LTM6IGVwIDB4ODUgLSB1cmIgbGVuID0gMHgyNTgwICg5NjAwKSwgYWRkciA9IDB4
N2IxODAwMDAsIG51bV90cmJzID0gMTANClsgICA0OC4wODY4MTZdIHVzYiA5LTM6IGVwIDB4
ODUgLSB1cmIgbGVuID0gMHgyNTgwICg5NjAwKSwgYWRkciA9IDB4N2I0N2MwMDAsIG51bV90
cmJzID0gMTANClsgICA0OC4xMDU4MDNdIHhoY2lfaGNkIDAwMDA6MDM6MDAuMDogV0FSTiBF
dmVudCBUUkIgZm9yIHNsb3QgMSBlcCAxMCB3aXRoIG5vIFREcyBxdWV1ZWQ/DQpbICAgNDgu
MjYzODg1XSB1c2IgOS0zOiBTdWNjZXNzZnVsIEVuZHBvaW50IENvbmZpZ3VyZSBjb21tYW5k
DQpbICAgNDguMjczNzk2XSB1c2IgOS0zOiBlcCAweDg1IC0gdXJiIGxlbiA9IDB4MjU4MCAo
OTYwMCksIGFkZHIgPSAweDdiYmEwMDAwLCBudW1fdHJicyA9IDEwDQpbICAgNDguMjczODA3
XSB1c2IgOS0zOiBlcCAweDg1IC0gdXJiIGxlbiA9IDB4MjU4MCAoOTYwMCksIGFkZHIgPSAw
eDdhZjZjMDAwLCBudW1fdHJicyA9IDEwDQpbICAgNDguMjkyNzkzXSB4aGNpX2hjZCAwMDAw
OjAzOjAwLjA6IFdBUk4gRXZlbnQgVFJCIGZvciBzbG90IDEgZXAgMTAgd2l0aCBubyBURHMg
cXVldWVkPw0KWyAgIDQ4LjQ0Njg3NV0gdXNiIDktMzogU3VjY2Vzc2Z1bCBFbmRwb2ludCBD
b25maWd1cmUgY29tbWFuZA0KWyAgIDQ4LjQ1Njc4NF0gdXNiIDktMzogZXAgMHg4NSAtIHVy
YiBsZW4gPSAweDI1ODAgKDk2MDApLCBhZGRyID0gMHg3YmJhMDAwMCwgbnVtX3RyYnMgPSAx
MA0KWyAgIDQ4LjQ1Njc5NF0gdXNiIDktMzogZXAgMHg4NSAtIHVyYiBsZW4gPSAweDI1ODAg
KDk2MDApLCBhZGRyID0gMHg3YWY2YzAwMCwgbnVtX3RyYnMgPSAxMA0KWyAgIDUxLjc3ODY0
OF0geGhjaV9oY2QgMDAwMDowMzowMC4wOiBXQVJOIEV2ZW50IFRSQiBmb3Igc2xvdCAxIGVw
IDEwIHdpdGggbm8gVERzIHF1ZXVlZD8NCg==
------------110125428278FB3
Content-Type: text/plain;
 name="lsusb-with-patch.txt"
Content-transfer-encoding: base64
Content-Disposition: attachment;
 filename="lsusb-with-patch.txt"

DQpCdXMgMDAyIERldmljZSAwMDE6IElEIDFkNmI6MDAwMiBMaW51eCBGb3VuZGF0aW9uIDIu
MCByb290IGh1Yg0KRGV2aWNlIERlc2NyaXB0b3I6DQogIGJMZW5ndGggICAgICAgICAgICAg
ICAgMTgNCiAgYkRlc2NyaXB0b3JUeXBlICAgICAgICAgMQ0KICBiY2RVU0IgICAgICAgICAg
ICAgICAyLjAwDQogIGJEZXZpY2VDbGFzcyAgICAgICAgICAgIDkgSHViDQogIGJEZXZpY2VT
dWJDbGFzcyAgICAgICAgIDAgVW51c2VkDQogIGJEZXZpY2VQcm90b2NvbCAgICAgICAgIDAg
RnVsbCBzcGVlZCAob3Igcm9vdCkgaHViDQogIGJNYXhQYWNrZXRTaXplMCAgICAgICAgNjQN
CiAgaWRWZW5kb3IgICAgICAgICAgIDB4MWQ2YiBMaW51eCBGb3VuZGF0aW9uDQogIGlkUHJv
ZHVjdCAgICAgICAgICAweDAwMDIgMi4wIHJvb3QgaHViDQogIGJjZERldmljZSAgICAgICAg
ICAgIDIuMDYNCiAgaU1hbnVmYWN0dXJlciAgICAgICAgICAgMyBMaW51eCAyLjYuMzQtcmMx
IGVoY2lfaGNkDQogIGlQcm9kdWN0ICAgICAgICAgICAgICAgIDIgRUhDSSBIb3N0IENvbnRy
b2xsZXINCiAgaVNlcmlhbCAgICAgICAgICAgICAgICAgMSAwMDAwOjAwOjFkLjcNCiAgYk51
bUNvbmZpZ3VyYXRpb25zICAgICAgMQ0KICBDb25maWd1cmF0aW9uIERlc2NyaXB0b3I6DQog
ICAgYkxlbmd0aCAgICAgICAgICAgICAgICAgOQ0KICAgIGJEZXNjcmlwdG9yVHlwZSAgICAg
ICAgIDINCiAgICB3VG90YWxMZW5ndGggICAgICAgICAgIDI1DQogICAgYk51bUludGVyZmFj
ZXMgICAgICAgICAgMQ0KICAgIGJDb25maWd1cmF0aW9uVmFsdWUgICAgIDENCiAgICBpQ29u
ZmlndXJhdGlvbiAgICAgICAgICAwIA0KICAgIGJtQXR0cmlidXRlcyAgICAgICAgIDB4ZTAN
CiAgICAgIFNlbGYgUG93ZXJlZA0KICAgICAgUmVtb3RlIFdha2V1cA0KICAgIE1heFBvd2Vy
ICAgICAgICAgICAgICAgIDBtQQ0KICAgIEludGVyZmFjZSBEZXNjcmlwdG9yOg0KICAgICAg
Ykxlbmd0aCAgICAgICAgICAgICAgICAgOQ0KICAgICAgYkRlc2NyaXB0b3JUeXBlICAgICAg
ICAgNA0KICAgICAgYkludGVyZmFjZU51bWJlciAgICAgICAgMA0KICAgICAgYkFsdGVybmF0
ZVNldHRpbmcgICAgICAgMA0KICAgICAgYk51bUVuZHBvaW50cyAgICAgICAgICAgMQ0KICAg
ICAgYkludGVyZmFjZUNsYXNzICAgICAgICAgOSBIdWINCiAgICAgIGJJbnRlcmZhY2VTdWJD
bGFzcyAgICAgIDAgVW51c2VkDQogICAgICBiSW50ZXJmYWNlUHJvdG9jb2wgICAgICAwIEZ1
bGwgc3BlZWQgKG9yIHJvb3QpIGh1Yg0KICAgICAgaUludGVyZmFjZSAgICAgICAgICAgICAg
MCANCiAgICAgIEVuZHBvaW50IERlc2NyaXB0b3I6DQogICAgICAgIGJMZW5ndGggICAgICAg
ICAgICAgICAgIDcNCiAgICAgICAgYkRlc2NyaXB0b3JUeXBlICAgICAgICAgNQ0KICAgICAg
ICBiRW5kcG9pbnRBZGRyZXNzICAgICAweDgxICBFUCAxIElODQogICAgICAgIGJtQXR0cmli
dXRlcyAgICAgICAgICAgIDMNCiAgICAgICAgICBUcmFuc2ZlciBUeXBlICAgICAgICAgICAg
SW50ZXJydXB0DQogICAgICAgICAgU3luY2ggVHlwZSAgICAgICAgICAgICAgIE5vbmUNCiAg
ICAgICAgICBVc2FnZSBUeXBlICAgICAgICAgICAgICAgRGF0YQ0KICAgICAgICB3TWF4UGFj
a2V0U2l6ZSAgICAgMHgwMDA0ICAxeCA0IGJ5dGVzDQogICAgICAgIGJJbnRlcnZhbCAgICAg
ICAgICAgICAgMTINCkh1YiBEZXNjcmlwdG9yOg0KICBiTGVuZ3RoICAgICAgICAgICAgICAg
OQ0KICBiRGVzY3JpcHRvclR5cGUgICAgICA0MQ0KICBuTmJyUG9ydHMgICAgICAgICAgICAg
Ng0KICB3SHViQ2hhcmFjdGVyaXN0aWMgMHgwMDBhDQogICAgTm8gcG93ZXIgc3dpdGNoaW5n
ICh1c2IgMS4wKQ0KICAgIFBlci1wb3J0IG92ZXJjdXJyZW50IHByb3RlY3Rpb24NCiAgYlB3
ck9uMlB3ckdvb2QgICAgICAgMTAgKiAyIG1pbGxpIHNlY29uZHMNCiAgYkh1YkNvbnRyQ3Vy
cmVudCAgICAgIDAgbWlsbGkgQW1wZXJlDQogIERldmljZVJlbW92YWJsZSAgICAweDAwDQog
IFBvcnRQd3JDdHJsTWFzayAgICAweGZmDQogSHViIFBvcnQgU3RhdHVzOg0KICAgUG9ydCAx
OiAwMDAwLjAxMDAgcG93ZXINCiAgIFBvcnQgMjogMDAwMC4wMTAwIHBvd2VyDQogICBQb3J0
IDM6IDAwMDAuMDEwMCBwb3dlcg0KICAgUG9ydCA0OiAwMDAwLjAxMDAgcG93ZXINCiAgIFBv
cnQgNTogMDAwMC4wMTAwIHBvd2VyDQogICBQb3J0IDY6IDAwMDAuMDEwMCBwb3dlcg0KRGV2
aWNlIFN0YXR1czogICAgIDB4MDAwMw0KICBTZWxmIFBvd2VyZWQNCiAgUmVtb3RlIFdha2V1
cCBFbmFibGVkDQoNCkJ1cyAwMDggRGV2aWNlIDAwMTogSUQgMWQ2YjowMDAxIExpbnV4IEZv
dW5kYXRpb24gMS4xIHJvb3QgaHViDQpEZXZpY2UgRGVzY3JpcHRvcjoNCiAgYkxlbmd0aCAg
ICAgICAgICAgICAgICAxOA0KICBiRGVzY3JpcHRvclR5cGUgICAgICAgICAxDQogIGJjZFVT
QiAgICAgICAgICAgICAgIDEuMTANCiAgYkRldmljZUNsYXNzICAgICAgICAgICAgOSBIdWIN
CiAgYkRldmljZVN1YkNsYXNzICAgICAgICAgMCBVbnVzZWQNCiAgYkRldmljZVByb3RvY29s
ICAgICAgICAgMCBGdWxsIHNwZWVkIChvciByb290KSBodWINCiAgYk1heFBhY2tldFNpemUw
ICAgICAgICA2NA0KICBpZFZlbmRvciAgICAgICAgICAgMHgxZDZiIExpbnV4IEZvdW5kYXRp
b24NCiAgaWRQcm9kdWN0ICAgICAgICAgIDB4MDAwMSAxLjEgcm9vdCBodWINCiAgYmNkRGV2
aWNlICAgICAgICAgICAgMi4wNg0KICBpTWFudWZhY3R1cmVyICAgICAgICAgICAzIExpbnV4
IDIuNi4zNC1yYzEgdWhjaV9oY2QNCiAgaVByb2R1Y3QgICAgICAgICAgICAgICAgMiBVSENJ
IEhvc3QgQ29udHJvbGxlcg0KICBpU2VyaWFsICAgICAgICAgICAgICAgICAxIDAwMDA6MDA6
MWQuMg0KICBiTnVtQ29uZmlndXJhdGlvbnMgICAgICAxDQogIENvbmZpZ3VyYXRpb24gRGVz
Y3JpcHRvcjoNCiAgICBiTGVuZ3RoICAgICAgICAgICAgICAgICA5DQogICAgYkRlc2NyaXB0
b3JUeXBlICAgICAgICAgMg0KICAgIHdUb3RhbExlbmd0aCAgICAgICAgICAgMjUNCiAgICBi
TnVtSW50ZXJmYWNlcyAgICAgICAgICAxDQogICAgYkNvbmZpZ3VyYXRpb25WYWx1ZSAgICAg
MQ0KICAgIGlDb25maWd1cmF0aW9uICAgICAgICAgIDAgDQogICAgYm1BdHRyaWJ1dGVzICAg
ICAgICAgMHhlMA0KICAgICAgU2VsZiBQb3dlcmVkDQogICAgICBSZW1vdGUgV2FrZXVwDQog
ICAgTWF4UG93ZXIgICAgICAgICAgICAgICAgMG1BDQogICAgSW50ZXJmYWNlIERlc2NyaXB0
b3I6DQogICAgICBiTGVuZ3RoICAgICAgICAgICAgICAgICA5DQogICAgICBiRGVzY3JpcHRv
clR5cGUgICAgICAgICA0DQogICAgICBiSW50ZXJmYWNlTnVtYmVyICAgICAgICAwDQogICAg
ICBiQWx0ZXJuYXRlU2V0dGluZyAgICAgICAwDQogICAgICBiTnVtRW5kcG9pbnRzICAgICAg
ICAgICAxDQogICAgICBiSW50ZXJmYWNlQ2xhc3MgICAgICAgICA5IEh1Yg0KICAgICAgYklu
dGVyZmFjZVN1YkNsYXNzICAgICAgMCBVbnVzZWQNCiAgICAgIGJJbnRlcmZhY2VQcm90b2Nv
bCAgICAgIDAgRnVsbCBzcGVlZCAob3Igcm9vdCkgaHViDQogICAgICBpSW50ZXJmYWNlICAg
ICAgICAgICAgICAwIA0KICAgICAgRW5kcG9pbnQgRGVzY3JpcHRvcjoNCiAgICAgICAgYkxl
bmd0aCAgICAgICAgICAgICAgICAgNw0KICAgICAgICBiRGVzY3JpcHRvclR5cGUgICAgICAg
ICA1DQogICAgICAgIGJFbmRwb2ludEFkZHJlc3MgICAgIDB4ODEgIEVQIDEgSU4NCiAgICAg
ICAgYm1BdHRyaWJ1dGVzICAgICAgICAgICAgMw0KICAgICAgICAgIFRyYW5zZmVyIFR5cGUg
ICAgICAgICAgICBJbnRlcnJ1cHQNCiAgICAgICAgICBTeW5jaCBUeXBlICAgICAgICAgICAg
ICAgTm9uZQ0KICAgICAgICAgIFVzYWdlIFR5cGUgICAgICAgICAgICAgICBEYXRhDQogICAg
ICAgIHdNYXhQYWNrZXRTaXplICAgICAweDAwMDIgIDF4IDIgYnl0ZXMNCiAgICAgICAgYklu
dGVydmFsICAgICAgICAgICAgIDI1NQ0KSHViIERlc2NyaXB0b3I6DQogIGJMZW5ndGggICAg
ICAgICAgICAgICA5DQogIGJEZXNjcmlwdG9yVHlwZSAgICAgIDQxDQogIG5OYnJQb3J0cyAg
ICAgICAgICAgICAyDQogIHdIdWJDaGFyYWN0ZXJpc3RpYyAweDAwMGENCiAgICBObyBwb3dl
ciBzd2l0Y2hpbmcgKHVzYiAxLjApDQogICAgUGVyLXBvcnQgb3ZlcmN1cnJlbnQgcHJvdGVj
dGlvbg0KICBiUHdyT24yUHdyR29vZCAgICAgICAgMSAqIDIgbWlsbGkgc2Vjb25kcw0KICBi
SHViQ29udHJDdXJyZW50ICAgICAgMCBtaWxsaSBBbXBlcmUNCiAgRGV2aWNlUmVtb3ZhYmxl
ICAgIDB4MDANCiAgUG9ydFB3ckN0cmxNYXNrICAgIDB4ZmYNCiBIdWIgUG9ydCBTdGF0dXM6
DQogICBQb3J0IDE6IDAwMDAuMDEwMCBwb3dlcg0KICAgUG9ydCAyOiAwMDAwLjAxMDAgcG93
ZXINCkRldmljZSBTdGF0dXM6ICAgICAweDAwMDMNCiAgU2VsZiBQb3dlcmVkDQogIFJlbW90
ZSBXYWtldXAgRW5hYmxlZA0KDQpCdXMgMDA3IERldmljZSAwMDE6IElEIDFkNmI6MDAwMSBM
aW51eCBGb3VuZGF0aW9uIDEuMSByb290IGh1Yg0KRGV2aWNlIERlc2NyaXB0b3I6DQogIGJM
ZW5ndGggICAgICAgICAgICAgICAgMTgNCiAgYkRlc2NyaXB0b3JUeXBlICAgICAgICAgMQ0K
ICBiY2RVU0IgICAgICAgICAgICAgICAxLjEwDQogIGJEZXZpY2VDbGFzcyAgICAgICAgICAg
IDkgSHViDQogIGJEZXZpY2VTdWJDbGFzcyAgICAgICAgIDAgVW51c2VkDQogIGJEZXZpY2VQ
cm90b2NvbCAgICAgICAgIDAgRnVsbCBzcGVlZCAob3Igcm9vdCkgaHViDQogIGJNYXhQYWNr
ZXRTaXplMCAgICAgICAgNjQNCiAgaWRWZW5kb3IgICAgICAgICAgIDB4MWQ2YiBMaW51eCBG
b3VuZGF0aW9uDQogIGlkUHJvZHVjdCAgICAgICAgICAweDAwMDEgMS4xIHJvb3QgaHViDQog
IGJjZERldmljZSAgICAgICAgICAgIDIuMDYNCiAgaU1hbnVmYWN0dXJlciAgICAgICAgICAg
MyBMaW51eCAyLjYuMzQtcmMxIHVoY2lfaGNkDQogIGlQcm9kdWN0ICAgICAgICAgICAgICAg
IDIgVUhDSSBIb3N0IENvbnRyb2xsZXINCiAgaVNlcmlhbCAgICAgICAgICAgICAgICAgMSAw
MDAwOjAwOjFkLjENCiAgYk51bUNvbmZpZ3VyYXRpb25zICAgICAgMQ0KICBDb25maWd1cmF0
aW9uIERlc2NyaXB0b3I6DQogICAgYkxlbmd0aCAgICAgICAgICAgICAgICAgOQ0KICAgIGJE
ZXNjcmlwdG9yVHlwZSAgICAgICAgIDINCiAgICB3VG90YWxMZW5ndGggICAgICAgICAgIDI1
DQogICAgYk51bUludGVyZmFjZXMgICAgICAgICAgMQ0KICAgIGJDb25maWd1cmF0aW9uVmFs
dWUgICAgIDENCiAgICBpQ29uZmlndXJhdGlvbiAgICAgICAgICAwIA0KICAgIGJtQXR0cmli
dXRlcyAgICAgICAgIDB4ZTANCiAgICAgIFNlbGYgUG93ZXJlZA0KICAgICAgUmVtb3RlIFdh
a2V1cA0KICAgIE1heFBvd2VyICAgICAgICAgICAgICAgIDBtQQ0KICAgIEludGVyZmFjZSBE
ZXNjcmlwdG9yOg0KICAgICAgYkxlbmd0aCAgICAgICAgICAgICAgICAgOQ0KICAgICAgYkRl
c2NyaXB0b3JUeXBlICAgICAgICAgNA0KICAgICAgYkludGVyZmFjZU51bWJlciAgICAgICAg
MA0KICAgICAgYkFsdGVybmF0ZVNldHRpbmcgICAgICAgMA0KICAgICAgYk51bUVuZHBvaW50
cyAgICAgICAgICAgMQ0KICAgICAgYkludGVyZmFjZUNsYXNzICAgICAgICAgOSBIdWINCiAg
ICAgIGJJbnRlcmZhY2VTdWJDbGFzcyAgICAgIDAgVW51c2VkDQogICAgICBiSW50ZXJmYWNl
UHJvdG9jb2wgICAgICAwIEZ1bGwgc3BlZWQgKG9yIHJvb3QpIGh1Yg0KICAgICAgaUludGVy
ZmFjZSAgICAgICAgICAgICAgMCANCiAgICAgIEVuZHBvaW50IERlc2NyaXB0b3I6DQogICAg
ICAgIGJMZW5ndGggICAgICAgICAgICAgICAgIDcNCiAgICAgICAgYkRlc2NyaXB0b3JUeXBl
ICAgICAgICAgNQ0KICAgICAgICBiRW5kcG9pbnRBZGRyZXNzICAgICAweDgxICBFUCAxIElO
DQogICAgICAgIGJtQXR0cmlidXRlcyAgICAgICAgICAgIDMNCiAgICAgICAgICBUcmFuc2Zl
ciBUeXBlICAgICAgICAgICAgSW50ZXJydXB0DQogICAgICAgICAgU3luY2ggVHlwZSAgICAg
ICAgICAgICAgIE5vbmUNCiAgICAgICAgICBVc2FnZSBUeXBlICAgICAgICAgICAgICAgRGF0
YQ0KICAgICAgICB3TWF4UGFja2V0U2l6ZSAgICAgMHgwMDAyICAxeCAyIGJ5dGVzDQogICAg
ICAgIGJJbnRlcnZhbCAgICAgICAgICAgICAyNTUNCkh1YiBEZXNjcmlwdG9yOg0KICBiTGVu
Z3RoICAgICAgICAgICAgICAgOQ0KICBiRGVzY3JpcHRvclR5cGUgICAgICA0MQ0KICBuTmJy
UG9ydHMgICAgICAgICAgICAgMg0KICB3SHViQ2hhcmFjdGVyaXN0aWMgMHgwMDBhDQogICAg
Tm8gcG93ZXIgc3dpdGNoaW5nICh1c2IgMS4wKQ0KICAgIFBlci1wb3J0IG92ZXJjdXJyZW50
IHByb3RlY3Rpb24NCiAgYlB3ck9uMlB3ckdvb2QgICAgICAgIDEgKiAyIG1pbGxpIHNlY29u
ZHMNCiAgYkh1YkNvbnRyQ3VycmVudCAgICAgIDAgbWlsbGkgQW1wZXJlDQogIERldmljZVJl
bW92YWJsZSAgICAweDAwDQogIFBvcnRQd3JDdHJsTWFzayAgICAweGZmDQogSHViIFBvcnQg
U3RhdHVzOg0KICAgUG9ydCAxOiAwMDAwLjAxMDAgcG93ZXINCiAgIFBvcnQgMjogMDAwMC4w
MTAwIHBvd2VyDQpEZXZpY2UgU3RhdHVzOiAgICAgMHgwMDAzDQogIFNlbGYgUG93ZXJlZA0K
ICBSZW1vdGUgV2FrZXVwIEVuYWJsZWQNCg0KQnVzIDAwNiBEZXZpY2UgMDAxOiBJRCAxZDZi
OjAwMDEgTGludXggRm91bmRhdGlvbiAxLjEgcm9vdCBodWINCkRldmljZSBEZXNjcmlwdG9y
Og0KICBiTGVuZ3RoICAgICAgICAgICAgICAgIDE4DQogIGJEZXNjcmlwdG9yVHlwZSAgICAg
ICAgIDENCiAgYmNkVVNCICAgICAgICAgICAgICAgMS4xMA0KICBiRGV2aWNlQ2xhc3MgICAg
ICAgICAgICA5IEh1Yg0KICBiRGV2aWNlU3ViQ2xhc3MgICAgICAgICAwIFVudXNlZA0KICBi
RGV2aWNlUHJvdG9jb2wgICAgICAgICAwIEZ1bGwgc3BlZWQgKG9yIHJvb3QpIGh1Yg0KICBi
TWF4UGFja2V0U2l6ZTAgICAgICAgIDY0DQogIGlkVmVuZG9yICAgICAgICAgICAweDFkNmIg
TGludXggRm91bmRhdGlvbg0KICBpZFByb2R1Y3QgICAgICAgICAgMHgwMDAxIDEuMSByb290
IGh1Yg0KICBiY2REZXZpY2UgICAgICAgICAgICAyLjA2DQogIGlNYW51ZmFjdHVyZXIgICAg
ICAgICAgIDMgTGludXggMi42LjM0LXJjMSB1aGNpX2hjZA0KICBpUHJvZHVjdCAgICAgICAg
ICAgICAgICAyIFVIQ0kgSG9zdCBDb250cm9sbGVyDQogIGlTZXJpYWwgICAgICAgICAgICAg
ICAgIDEgMDAwMDowMDoxZC4wDQogIGJOdW1Db25maWd1cmF0aW9ucyAgICAgIDENCiAgQ29u
ZmlndXJhdGlvbiBEZXNjcmlwdG9yOg0KICAgIGJMZW5ndGggICAgICAgICAgICAgICAgIDkN
CiAgICBiRGVzY3JpcHRvclR5cGUgICAgICAgICAyDQogICAgd1RvdGFsTGVuZ3RoICAgICAg
ICAgICAyNQ0KICAgIGJOdW1JbnRlcmZhY2VzICAgICAgICAgIDENCiAgICBiQ29uZmlndXJh
dGlvblZhbHVlICAgICAxDQogICAgaUNvbmZpZ3VyYXRpb24gICAgICAgICAgMCANCiAgICBi
bUF0dHJpYnV0ZXMgICAgICAgICAweGUwDQogICAgICBTZWxmIFBvd2VyZWQNCiAgICAgIFJl
bW90ZSBXYWtldXANCiAgICBNYXhQb3dlciAgICAgICAgICAgICAgICAwbUENCiAgICBJbnRl
cmZhY2UgRGVzY3JpcHRvcjoNCiAgICAgIGJMZW5ndGggICAgICAgICAgICAgICAgIDkNCiAg
ICAgIGJEZXNjcmlwdG9yVHlwZSAgICAgICAgIDQNCiAgICAgIGJJbnRlcmZhY2VOdW1iZXIg
ICAgICAgIDANCiAgICAgIGJBbHRlcm5hdGVTZXR0aW5nICAgICAgIDANCiAgICAgIGJOdW1F
bmRwb2ludHMgICAgICAgICAgIDENCiAgICAgIGJJbnRlcmZhY2VDbGFzcyAgICAgICAgIDkg
SHViDQogICAgICBiSW50ZXJmYWNlU3ViQ2xhc3MgICAgICAwIFVudXNlZA0KICAgICAgYklu
dGVyZmFjZVByb3RvY29sICAgICAgMCBGdWxsIHNwZWVkIChvciByb290KSBodWINCiAgICAg
IGlJbnRlcmZhY2UgICAgICAgICAgICAgIDAgDQogICAgICBFbmRwb2ludCBEZXNjcmlwdG9y
Og0KICAgICAgICBiTGVuZ3RoICAgICAgICAgICAgICAgICA3DQogICAgICAgIGJEZXNjcmlw
dG9yVHlwZSAgICAgICAgIDUNCiAgICAgICAgYkVuZHBvaW50QWRkcmVzcyAgICAgMHg4MSAg
RVAgMSBJTg0KICAgICAgICBibUF0dHJpYnV0ZXMgICAgICAgICAgICAzDQogICAgICAgICAg
VHJhbnNmZXIgVHlwZSAgICAgICAgICAgIEludGVycnVwdA0KICAgICAgICAgIFN5bmNoIFR5
cGUgICAgICAgICAgICAgICBOb25lDQogICAgICAgICAgVXNhZ2UgVHlwZSAgICAgICAgICAg
ICAgIERhdGENCiAgICAgICAgd01heFBhY2tldFNpemUgICAgIDB4MDAwMiAgMXggMiBieXRl
cw0KICAgICAgICBiSW50ZXJ2YWwgICAgICAgICAgICAgMjU1DQpIdWIgRGVzY3JpcHRvcjoN
CiAgYkxlbmd0aCAgICAgICAgICAgICAgIDkNCiAgYkRlc2NyaXB0b3JUeXBlICAgICAgNDEN
CiAgbk5iclBvcnRzICAgICAgICAgICAgIDINCiAgd0h1YkNoYXJhY3RlcmlzdGljIDB4MDAw
YQ0KICAgIE5vIHBvd2VyIHN3aXRjaGluZyAodXNiIDEuMCkNCiAgICBQZXItcG9ydCBvdmVy
Y3VycmVudCBwcm90ZWN0aW9uDQogIGJQd3JPbjJQd3JHb29kICAgICAgICAxICogMiBtaWxs
aSBzZWNvbmRzDQogIGJIdWJDb250ckN1cnJlbnQgICAgICAwIG1pbGxpIEFtcGVyZQ0KICBE
ZXZpY2VSZW1vdmFibGUgICAgMHgwMA0KICBQb3J0UHdyQ3RybE1hc2sgICAgMHhmZg0KIEh1
YiBQb3J0IFN0YXR1czoNCiAgIFBvcnQgMTogMDAwMC4wMTAwIHBvd2VyDQogICBQb3J0IDI6
IDAwMDAuMDEwMCBwb3dlcg0KRGV2aWNlIFN0YXR1czogICAgIDB4MDAwMw0KICBTZWxmIFBv
d2VyZWQNCiAgUmVtb3RlIFdha2V1cCBFbmFibGVkDQoNCkJ1cyAwMDUgRGV2aWNlIDAwMTog
SUQgMWQ2YjowMDAxIExpbnV4IEZvdW5kYXRpb24gMS4xIHJvb3QgaHViDQpEZXZpY2UgRGVz
Y3JpcHRvcjoNCiAgYkxlbmd0aCAgICAgICAgICAgICAgICAxOA0KICBiRGVzY3JpcHRvclR5
cGUgICAgICAgICAxDQogIGJjZFVTQiAgICAgICAgICAgICAgIDEuMTANCiAgYkRldmljZUNs
YXNzICAgICAgICAgICAgOSBIdWINCiAgYkRldmljZVN1YkNsYXNzICAgICAgICAgMCBVbnVz
ZWQNCiAgYkRldmljZVByb3RvY29sICAgICAgICAgMCBGdWxsIHNwZWVkIChvciByb290KSBo
dWINCiAgYk1heFBhY2tldFNpemUwICAgICAgICA2NA0KICBpZFZlbmRvciAgICAgICAgICAg
MHgxZDZiIExpbnV4IEZvdW5kYXRpb24NCiAgaWRQcm9kdWN0ICAgICAgICAgIDB4MDAwMSAx
LjEgcm9vdCBodWINCiAgYmNkRGV2aWNlICAgICAgICAgICAgMi4wNg0KICBpTWFudWZhY3R1
cmVyICAgICAgICAgICAzIExpbnV4IDIuNi4zNC1yYzEgdWhjaV9oY2QNCiAgaVByb2R1Y3Qg
ICAgICAgICAgICAgICAgMiBVSENJIEhvc3QgQ29udHJvbGxlcg0KICBpU2VyaWFsICAgICAg
ICAgICAgICAgICAxIDAwMDA6MDA6MWEuMg0KICBiTnVtQ29uZmlndXJhdGlvbnMgICAgICAx
DQogIENvbmZpZ3VyYXRpb24gRGVzY3JpcHRvcjoNCiAgICBiTGVuZ3RoICAgICAgICAgICAg
ICAgICA5DQogICAgYkRlc2NyaXB0b3JUeXBlICAgICAgICAgMg0KICAgIHdUb3RhbExlbmd0
aCAgICAgICAgICAgMjUNCiAgICBiTnVtSW50ZXJmYWNlcyAgICAgICAgICAxDQogICAgYkNv
bmZpZ3VyYXRpb25WYWx1ZSAgICAgMQ0KICAgIGlDb25maWd1cmF0aW9uICAgICAgICAgIDAg
DQogICAgYm1BdHRyaWJ1dGVzICAgICAgICAgMHhlMA0KICAgICAgU2VsZiBQb3dlcmVkDQog
ICAgICBSZW1vdGUgV2FrZXVwDQogICAgTWF4UG93ZXIgICAgICAgICAgICAgICAgMG1BDQog
ICAgSW50ZXJmYWNlIERlc2NyaXB0b3I6DQogICAgICBiTGVuZ3RoICAgICAgICAgICAgICAg
ICA5DQogICAgICBiRGVzY3JpcHRvclR5cGUgICAgICAgICA0DQogICAgICBiSW50ZXJmYWNl
TnVtYmVyICAgICAgICAwDQogICAgICBiQWx0ZXJuYXRlU2V0dGluZyAgICAgICAwDQogICAg
ICBiTnVtRW5kcG9pbnRzICAgICAgICAgICAxDQogICAgICBiSW50ZXJmYWNlQ2xhc3MgICAg
ICAgICA5IEh1Yg0KICAgICAgYkludGVyZmFjZVN1YkNsYXNzICAgICAgMCBVbnVzZWQNCiAg
ICAgIGJJbnRlcmZhY2VQcm90b2NvbCAgICAgIDAgRnVsbCBzcGVlZCAob3Igcm9vdCkgaHVi
DQogICAgICBpSW50ZXJmYWNlICAgICAgICAgICAgICAwIA0KICAgICAgRW5kcG9pbnQgRGVz
Y3JpcHRvcjoNCiAgICAgICAgYkxlbmd0aCAgICAgICAgICAgICAgICAgNw0KICAgICAgICBi
RGVzY3JpcHRvclR5cGUgICAgICAgICA1DQogICAgICAgIGJFbmRwb2ludEFkZHJlc3MgICAg
IDB4ODEgIEVQIDEgSU4NCiAgICAgICAgYm1BdHRyaWJ1dGVzICAgICAgICAgICAgMw0KICAg
ICAgICAgIFRyYW5zZmVyIFR5cGUgICAgICAgICAgICBJbnRlcnJ1cHQNCiAgICAgICAgICBT
eW5jaCBUeXBlICAgICAgICAgICAgICAgTm9uZQ0KICAgICAgICAgIFVzYWdlIFR5cGUgICAg
ICAgICAgICAgICBEYXRhDQogICAgICAgIHdNYXhQYWNrZXRTaXplICAgICAweDAwMDIgIDF4
IDIgYnl0ZXMNCiAgICAgICAgYkludGVydmFsICAgICAgICAgICAgIDI1NQ0KSHViIERlc2Ny
aXB0b3I6DQogIGJMZW5ndGggICAgICAgICAgICAgICA5DQogIGJEZXNjcmlwdG9yVHlwZSAg
ICAgIDQxDQogIG5OYnJQb3J0cyAgICAgICAgICAgICAyDQogIHdIdWJDaGFyYWN0ZXJpc3Rp
YyAweDAwMGENCiAgICBObyBwb3dlciBzd2l0Y2hpbmcgKHVzYiAxLjApDQogICAgUGVyLXBv
cnQgb3ZlcmN1cnJlbnQgcHJvdGVjdGlvbg0KICBiUHdyT24yUHdyR29vZCAgICAgICAgMSAq
IDIgbWlsbGkgc2Vjb25kcw0KICBiSHViQ29udHJDdXJyZW50ICAgICAgMCBtaWxsaSBBbXBl
cmUNCiAgRGV2aWNlUmVtb3ZhYmxlICAgIDB4MDANCiAgUG9ydFB3ckN0cmxNYXNrICAgIDB4
ZmYNCiBIdWIgUG9ydCBTdGF0dXM6DQogICBQb3J0IDE6IDAwMDAuMDEwMCBwb3dlcg0KICAg
UG9ydCAyOiAwMDAwLjAxMDAgcG93ZXINCkRldmljZSBTdGF0dXM6ICAgICAweDAwMDMNCiAg
U2VsZiBQb3dlcmVkDQogIFJlbW90ZSBXYWtldXAgRW5hYmxlZA0KDQpCdXMgMDAxIERldmlj
ZSAwMDE6IElEIDFkNmI6MDAwMiBMaW51eCBGb3VuZGF0aW9uIDIuMCByb290IGh1Yg0KRGV2
aWNlIERlc2NyaXB0b3I6DQogIGJMZW5ndGggICAgICAgICAgICAgICAgMTgNCiAgYkRlc2Ny
aXB0b3JUeXBlICAgICAgICAgMQ0KICBiY2RVU0IgICAgICAgICAgICAgICAyLjAwDQogIGJE
ZXZpY2VDbGFzcyAgICAgICAgICAgIDkgSHViDQogIGJEZXZpY2VTdWJDbGFzcyAgICAgICAg
IDAgVW51c2VkDQogIGJEZXZpY2VQcm90b2NvbCAgICAgICAgIDAgRnVsbCBzcGVlZCAob3Ig
cm9vdCkgaHViDQogIGJNYXhQYWNrZXRTaXplMCAgICAgICAgNjQNCiAgaWRWZW5kb3IgICAg
ICAgICAgIDB4MWQ2YiBMaW51eCBGb3VuZGF0aW9uDQogIGlkUHJvZHVjdCAgICAgICAgICAw
eDAwMDIgMi4wIHJvb3QgaHViDQogIGJjZERldmljZSAgICAgICAgICAgIDIuMDYNCiAgaU1h
bnVmYWN0dXJlciAgICAgICAgICAgMyBMaW51eCAyLjYuMzQtcmMxIGVoY2lfaGNkDQogIGlQ
cm9kdWN0ICAgICAgICAgICAgICAgIDIgRUhDSSBIb3N0IENvbnRyb2xsZXINCiAgaVNlcmlh
bCAgICAgICAgICAgICAgICAgMSAwMDAwOjAwOjFhLjcNCiAgYk51bUNvbmZpZ3VyYXRpb25z
ICAgICAgMQ0KICBDb25maWd1cmF0aW9uIERlc2NyaXB0b3I6DQogICAgYkxlbmd0aCAgICAg
ICAgICAgICAgICAgOQ0KICAgIGJEZXNjcmlwdG9yVHlwZSAgICAgICAgIDINCiAgICB3VG90
YWxMZW5ndGggICAgICAgICAgIDI1DQogICAgYk51bUludGVyZmFjZXMgICAgICAgICAgMQ0K
ICAgIGJDb25maWd1cmF0aW9uVmFsdWUgICAgIDENCiAgICBpQ29uZmlndXJhdGlvbiAgICAg
ICAgICAwIA0KICAgIGJtQXR0cmlidXRlcyAgICAgICAgIDB4ZTANCiAgICAgIFNlbGYgUG93
ZXJlZA0KICAgICAgUmVtb3RlIFdha2V1cA0KICAgIE1heFBvd2VyICAgICAgICAgICAgICAg
IDBtQQ0KICAgIEludGVyZmFjZSBEZXNjcmlwdG9yOg0KICAgICAgYkxlbmd0aCAgICAgICAg
ICAgICAgICAgOQ0KICAgICAgYkRlc2NyaXB0b3JUeXBlICAgICAgICAgNA0KICAgICAgYklu
dGVyZmFjZU51bWJlciAgICAgICAgMA0KICAgICAgYkFsdGVybmF0ZVNldHRpbmcgICAgICAg
MA0KICAgICAgYk51bUVuZHBvaW50cyAgICAgICAgICAgMQ0KICAgICAgYkludGVyZmFjZUNs
YXNzICAgICAgICAgOSBIdWINCiAgICAgIGJJbnRlcmZhY2VTdWJDbGFzcyAgICAgIDAgVW51
c2VkDQogICAgICBiSW50ZXJmYWNlUHJvdG9jb2wgICAgICAwIEZ1bGwgc3BlZWQgKG9yIHJv
b3QpIGh1Yg0KICAgICAgaUludGVyZmFjZSAgICAgICAgICAgICAgMCANCiAgICAgIEVuZHBv
aW50IERlc2NyaXB0b3I6DQogICAgICAgIGJMZW5ndGggICAgICAgICAgICAgICAgIDcNCiAg
ICAgICAgYkRlc2NyaXB0b3JUeXBlICAgICAgICAgNQ0KICAgICAgICBiRW5kcG9pbnRBZGRy
ZXNzICAgICAweDgxICBFUCAxIElODQogICAgICAgIGJtQXR0cmlidXRlcyAgICAgICAgICAg
IDMNCiAgICAgICAgICBUcmFuc2ZlciBUeXBlICAgICAgICAgICAgSW50ZXJydXB0DQogICAg
ICAgICAgU3luY2ggVHlwZSAgICAgICAgICAgICAgIE5vbmUNCiAgICAgICAgICBVc2FnZSBU
eXBlICAgICAgICAgICAgICAgRGF0YQ0KICAgICAgICB3TWF4UGFja2V0U2l6ZSAgICAgMHgw
MDA0ICAxeCA0IGJ5dGVzDQogICAgICAgIGJJbnRlcnZhbCAgICAgICAgICAgICAgMTINCkh1
YiBEZXNjcmlwdG9yOg0KICBiTGVuZ3RoICAgICAgICAgICAgICAgOQ0KICBiRGVzY3JpcHRv
clR5cGUgICAgICA0MQ0KICBuTmJyUG9ydHMgICAgICAgICAgICAgNg0KICB3SHViQ2hhcmFj
dGVyaXN0aWMgMHgwMDBhDQogICAgTm8gcG93ZXIgc3dpdGNoaW5nICh1c2IgMS4wKQ0KICAg
IFBlci1wb3J0IG92ZXJjdXJyZW50IHByb3RlY3Rpb24NCiAgYlB3ck9uMlB3ckdvb2QgICAg
ICAgMTAgKiAyIG1pbGxpIHNlY29uZHMNCiAgYkh1YkNvbnRyQ3VycmVudCAgICAgIDAgbWls
bGkgQW1wZXJlDQogIERldmljZVJlbW92YWJsZSAgICAweDAwDQogIFBvcnRQd3JDdHJsTWFz
ayAgICAweGZmDQogSHViIFBvcnQgU3RhdHVzOg0KICAgUG9ydCAxOiAwMDAwLjAxMDAgcG93
ZXINCiAgIFBvcnQgMjogMDAwMC4wMTAwIHBvd2VyDQogICBQb3J0IDM6IDAwMDAuMDEwMCBw
b3dlcg0KICAgUG9ydCA0OiAwMDAwLjAxMDAgcG93ZXINCiAgIFBvcnQgNTogMDAwMC4wMTAw
IHBvd2VyDQogICBQb3J0IDY6IDAwMDAuMDEwMCBwb3dlcg0KRGV2aWNlIFN0YXR1czogICAg
IDB4MDAwMw0KICBTZWxmIFBvd2VyZWQNCiAgUmVtb3RlIFdha2V1cCBFbmFibGVkDQoNCkJ1
cyAwMDMgRGV2aWNlIDAwMTogSUQgMWQ2YjowMDAxIExpbnV4IEZvdW5kYXRpb24gMS4xIHJv
b3QgaHViDQpEZXZpY2UgRGVzY3JpcHRvcjoNCiAgYkxlbmd0aCAgICAgICAgICAgICAgICAx
OA0KICBiRGVzY3JpcHRvclR5cGUgICAgICAgICAxDQogIGJjZFVTQiAgICAgICAgICAgICAg
IDEuMTANCiAgYkRldmljZUNsYXNzICAgICAgICAgICAgOSBIdWINCiAgYkRldmljZVN1YkNs
YXNzICAgICAgICAgMCBVbnVzZWQNCiAgYkRldmljZVByb3RvY29sICAgICAgICAgMCBGdWxs
IHNwZWVkIChvciByb290KSBodWINCiAgYk1heFBhY2tldFNpemUwICAgICAgICA2NA0KICBp
ZFZlbmRvciAgICAgICAgICAgMHgxZDZiIExpbnV4IEZvdW5kYXRpb24NCiAgaWRQcm9kdWN0
ICAgICAgICAgIDB4MDAwMSAxLjEgcm9vdCBodWINCiAgYmNkRGV2aWNlICAgICAgICAgICAg
Mi4wNg0KICBpTWFudWZhY3R1cmVyICAgICAgICAgICAzIExpbnV4IDIuNi4zNC1yYzEgdWhj
aV9oY2QNCiAgaVByb2R1Y3QgICAgICAgICAgICAgICAgMiBVSENJIEhvc3QgQ29udHJvbGxl
cg0KICBpU2VyaWFsICAgICAgICAgICAgICAgICAxIDAwMDA6MDA6MWEuMA0KICBiTnVtQ29u
ZmlndXJhdGlvbnMgICAgICAxDQogIENvbmZpZ3VyYXRpb24gRGVzY3JpcHRvcjoNCiAgICBi
TGVuZ3RoICAgICAgICAgICAgICAgICA5DQogICAgYkRlc2NyaXB0b3JUeXBlICAgICAgICAg
Mg0KICAgIHdUb3RhbExlbmd0aCAgICAgICAgICAgMjUNCiAgICBiTnVtSW50ZXJmYWNlcyAg
ICAgICAgICAxDQogICAgYkNvbmZpZ3VyYXRpb25WYWx1ZSAgICAgMQ0KICAgIGlDb25maWd1
cmF0aW9uICAgICAgICAgIDAgDQogICAgYm1BdHRyaWJ1dGVzICAgICAgICAgMHhlMA0KICAg
ICAgU2VsZiBQb3dlcmVkDQogICAgICBSZW1vdGUgV2FrZXVwDQogICAgTWF4UG93ZXIgICAg
ICAgICAgICAgICAgMG1BDQogICAgSW50ZXJmYWNlIERlc2NyaXB0b3I6DQogICAgICBiTGVu
Z3RoICAgICAgICAgICAgICAgICA5DQogICAgICBiRGVzY3JpcHRvclR5cGUgICAgICAgICA0
DQogICAgICBiSW50ZXJmYWNlTnVtYmVyICAgICAgICAwDQogICAgICBiQWx0ZXJuYXRlU2V0
dGluZyAgICAgICAwDQogICAgICBiTnVtRW5kcG9pbnRzICAgICAgICAgICAxDQogICAgICBi
SW50ZXJmYWNlQ2xhc3MgICAgICAgICA5IEh1Yg0KICAgICAgYkludGVyZmFjZVN1YkNsYXNz
ICAgICAgMCBVbnVzZWQNCiAgICAgIGJJbnRlcmZhY2VQcm90b2NvbCAgICAgIDAgRnVsbCBz
cGVlZCAob3Igcm9vdCkgaHViDQogICAgICBpSW50ZXJmYWNlICAgICAgICAgICAgICAwIA0K
ICAgICAgRW5kcG9pbnQgRGVzY3JpcHRvcjoNCiAgICAgICAgYkxlbmd0aCAgICAgICAgICAg
ICAgICAgNw0KICAgICAgICBiRGVzY3JpcHRvclR5cGUgICAgICAgICA1DQogICAgICAgIGJF
bmRwb2ludEFkZHJlc3MgICAgIDB4ODEgIEVQIDEgSU4NCiAgICAgICAgYm1BdHRyaWJ1dGVz
ICAgICAgICAgICAgMw0KICAgICAgICAgIFRyYW5zZmVyIFR5cGUgICAgICAgICAgICBJbnRl
cnJ1cHQNCiAgICAgICAgICBTeW5jaCBUeXBlICAgICAgICAgICAgICAgTm9uZQ0KICAgICAg
ICAgIFVzYWdlIFR5cGUgICAgICAgICAgICAgICBEYXRhDQogICAgICAgIHdNYXhQYWNrZXRT
aXplICAgICAweDAwMDIgIDF4IDIgYnl0ZXMNCiAgICAgICAgYkludGVydmFsICAgICAgICAg
ICAgIDI1NQ0KSHViIERlc2NyaXB0b3I6DQogIGJMZW5ndGggICAgICAgICAgICAgICA5DQog
IGJEZXNjcmlwdG9yVHlwZSAgICAgIDQxDQogIG5OYnJQb3J0cyAgICAgICAgICAgICAyDQog
IHdIdWJDaGFyYWN0ZXJpc3RpYyAweDAwMGENCiAgICBObyBwb3dlciBzd2l0Y2hpbmcgKHVz
YiAxLjApDQogICAgUGVyLXBvcnQgb3ZlcmN1cnJlbnQgcHJvdGVjdGlvbg0KICBiUHdyT24y
UHdyR29vZCAgICAgICAgMSAqIDIgbWlsbGkgc2Vjb25kcw0KICBiSHViQ29udHJDdXJyZW50
ICAgICAgMCBtaWxsaSBBbXBlcmUNCiAgRGV2aWNlUmVtb3ZhYmxlICAgIDB4MDANCiAgUG9y
dFB3ckN0cmxNYXNrICAgIDB4ZmYNCiBIdWIgUG9ydCBTdGF0dXM6DQogICBQb3J0IDE6IDAw
MDAuMDEwMCBwb3dlcg0KICAgUG9ydCAyOiAwMDAwLjAxMDAgcG93ZXINCkRldmljZSBTdGF0
dXM6ICAgICAweDAwMDMNCiAgU2VsZiBQb3dlcmVkDQogIFJlbW90ZSBXYWtldXAgRW5hYmxl
ZA0KDQpCdXMgMDA0IERldmljZSAwMDE6IElEIDFkNmI6MDAwMSBMaW51eCBGb3VuZGF0aW9u
IDEuMSByb290IGh1Yg0KRGV2aWNlIERlc2NyaXB0b3I6DQogIGJMZW5ndGggICAgICAgICAg
ICAgICAgMTgNCiAgYkRlc2NyaXB0b3JUeXBlICAgICAgICAgMQ0KICBiY2RVU0IgICAgICAg
ICAgICAgICAxLjEwDQogIGJEZXZpY2VDbGFzcyAgICAgICAgICAgIDkgSHViDQogIGJEZXZp
Y2VTdWJDbGFzcyAgICAgICAgIDAgVW51c2VkDQogIGJEZXZpY2VQcm90b2NvbCAgICAgICAg
IDAgRnVsbCBzcGVlZCAob3Igcm9vdCkgaHViDQogIGJNYXhQYWNrZXRTaXplMCAgICAgICAg
NjQNCiAgaWRWZW5kb3IgICAgICAgICAgIDB4MWQ2YiBMaW51eCBGb3VuZGF0aW9uDQogIGlk
UHJvZHVjdCAgICAgICAgICAweDAwMDEgMS4xIHJvb3QgaHViDQogIGJjZERldmljZSAgICAg
ICAgICAgIDIuMDYNCiAgaU1hbnVmYWN0dXJlciAgICAgICAgICAgMyBMaW51eCAyLjYuMzQt
cmMxIHVoY2lfaGNkDQogIGlQcm9kdWN0ICAgICAgICAgICAgICAgIDIgVUhDSSBIb3N0IENv
bnRyb2xsZXINCiAgaVNlcmlhbCAgICAgICAgICAgICAgICAgMSAwMDAwOjAwOjFhLjENCiAg
Yk51bUNvbmZpZ3VyYXRpb25zICAgICAgMQ0KICBDb25maWd1cmF0aW9uIERlc2NyaXB0b3I6
DQogICAgYkxlbmd0aCAgICAgICAgICAgICAgICAgOQ0KICAgIGJEZXNjcmlwdG9yVHlwZSAg
ICAgICAgIDINCiAgICB3VG90YWxMZW5ndGggICAgICAgICAgIDI1DQogICAgYk51bUludGVy
ZmFjZXMgICAgICAgICAgMQ0KICAgIGJDb25maWd1cmF0aW9uVmFsdWUgICAgIDENCiAgICBp
Q29uZmlndXJhdGlvbiAgICAgICAgICAwIA0KICAgIGJtQXR0cmlidXRlcyAgICAgICAgIDB4
ZTANCiAgICAgIFNlbGYgUG93ZXJlZA0KICAgICAgUmVtb3RlIFdha2V1cA0KICAgIE1heFBv
d2VyICAgICAgICAgICAgICAgIDBtQQ0KICAgIEludGVyZmFjZSBEZXNjcmlwdG9yOg0KICAg
ICAgYkxlbmd0aCAgICAgICAgICAgICAgICAgOQ0KICAgICAgYkRlc2NyaXB0b3JUeXBlICAg
ICAgICAgNA0KICAgICAgYkludGVyZmFjZU51bWJlciAgICAgICAgMA0KICAgICAgYkFsdGVy
bmF0ZVNldHRpbmcgICAgICAgMA0KICAgICAgYk51bUVuZHBvaW50cyAgICAgICAgICAgMQ0K
ICAgICAgYkludGVyZmFjZUNsYXNzICAgICAgICAgOSBIdWINCiAgICAgIGJJbnRlcmZhY2VT
dWJDbGFzcyAgICAgIDAgVW51c2VkDQogICAgICBiSW50ZXJmYWNlUHJvdG9jb2wgICAgICAw
IEZ1bGwgc3BlZWQgKG9yIHJvb3QpIGh1Yg0KICAgICAgaUludGVyZmFjZSAgICAgICAgICAg
ICAgMCANCiAgICAgIEVuZHBvaW50IERlc2NyaXB0b3I6DQogICAgICAgIGJMZW5ndGggICAg
ICAgICAgICAgICAgIDcNCiAgICAgICAgYkRlc2NyaXB0b3JUeXBlICAgICAgICAgNQ0KICAg
ICAgICBiRW5kcG9pbnRBZGRyZXNzICAgICAweDgxICBFUCAxIElODQogICAgICAgIGJtQXR0
cmlidXRlcyAgICAgICAgICAgIDMNCiAgICAgICAgICBUcmFuc2ZlciBUeXBlICAgICAgICAg
ICAgSW50ZXJydXB0DQogICAgICAgICAgU3luY2ggVHlwZSAgICAgICAgICAgICAgIE5vbmUN
CiAgICAgICAgICBVc2FnZSBUeXBlICAgICAgICAgICAgICAgRGF0YQ0KICAgICAgICB3TWF4
UGFja2V0U2l6ZSAgICAgMHgwMDAyICAxeCAyIGJ5dGVzDQogICAgICAgIGJJbnRlcnZhbCAg
ICAgICAgICAgICAyNTUNCkh1YiBEZXNjcmlwdG9yOg0KICBiTGVuZ3RoICAgICAgICAgICAg
ICAgOQ0KICBiRGVzY3JpcHRvclR5cGUgICAgICA0MQ0KICBuTmJyUG9ydHMgICAgICAgICAg
ICAgMg0KICB3SHViQ2hhcmFjdGVyaXN0aWMgMHgwMDBhDQogICAgTm8gcG93ZXIgc3dpdGNo
aW5nICh1c2IgMS4wKQ0KICAgIFBlci1wb3J0IG92ZXJjdXJyZW50IHByb3RlY3Rpb24NCiAg
YlB3ck9uMlB3ckdvb2QgICAgICAgIDEgKiAyIG1pbGxpIHNlY29uZHMNCiAgYkh1YkNvbnRy
Q3VycmVudCAgICAgIDAgbWlsbGkgQW1wZXJlDQogIERldmljZVJlbW92YWJsZSAgICAweDAw
DQogIFBvcnRQd3JDdHJsTWFzayAgICAweGZmDQogSHViIFBvcnQgU3RhdHVzOg0KICAgUG9y
dCAxOiAwMDAwLjAxMDAgcG93ZXINCiAgIFBvcnQgMjogMDAwMC4wMTAwIHBvd2VyDQpEZXZp
Y2UgU3RhdHVzOiAgICAgMHgwMDAzDQogIFNlbGYgUG93ZXJlZA0KICBSZW1vdGUgV2FrZXVw
IEVuYWJsZWQNCg0KQnVzIDAwOSBEZXZpY2UgMDAyOiBJRCAwNDcxOjAzMTEgUGhpbGlwcyBQ
Q1ZDNzQwSyBUb1VjYW0gUHJvIFtwd2NdDQpEZXZpY2UgRGVzY3JpcHRvcjoNCiAgYkxlbmd0
aCAgICAgICAgICAgICAgICAxOA0KICBiRGVzY3JpcHRvclR5cGUgICAgICAgICAxDQogIGJj
ZFVTQiAgICAgICAgICAgICAgIDEuMTANCiAgYkRldmljZUNsYXNzICAgICAgICAgICAgMCAo
RGVmaW5lZCBhdCBJbnRlcmZhY2UgbGV2ZWwpDQogIGJEZXZpY2VTdWJDbGFzcyAgICAgICAg
IDAgDQogIGJEZXZpY2VQcm90b2NvbCAgICAgICAgIDAgDQogIGJNYXhQYWNrZXRTaXplMCAg
ICAgICAgIDgNCiAgaWRWZW5kb3IgICAgICAgICAgIDB4MDQ3MSBQaGlsaXBzDQogIGlkUHJv
ZHVjdCAgICAgICAgICAweDAzMTEgUENWQzc0MEsgVG9VY2FtIFBybyBbcHdjXQ0KICBiY2RE
ZXZpY2UgICAgICAgICAgICAwLjAzDQogIGlNYW51ZmFjdHVyZXIgICAgICAgICAgIDAgDQog
IGlQcm9kdWN0ICAgICAgICAgICAgICAgIDAgDQogIGlTZXJpYWwgICAgICAgICAgICAgICAg
IDEgMDE2ODAwMDBFQTE2NDEwMQ0KICBiTnVtQ29uZmlndXJhdGlvbnMgICAgICAxDQogIENv
bmZpZ3VyYXRpb24gRGVzY3JpcHRvcjoNCiAgICBiTGVuZ3RoICAgICAgICAgICAgICAgICA5
DQogICAgYkRlc2NyaXB0b3JUeXBlICAgICAgICAgMg0KICAgIHdUb3RhbExlbmd0aCAgICAg
ICAgICA0OTANCiAgICBiTnVtSW50ZXJmYWNlcyAgICAgICAgICAzDQogICAgYkNvbmZpZ3Vy
YXRpb25WYWx1ZSAgICAgMQ0KICAgIGlDb25maWd1cmF0aW9uICAgICAgICAgIDAgDQogICAg
Ym1BdHRyaWJ1dGVzICAgICAgICAgMHhhMA0KICAgICAgKEJ1cyBQb3dlcmVkKQ0KICAgICAg
UmVtb3RlIFdha2V1cA0KICAgIE1heFBvd2VyICAgICAgICAgICAgICA1MDBtQQ0KICAgIElu
dGVyZmFjZSBEZXNjcmlwdG9yOg0KICAgICAgYkxlbmd0aCAgICAgICAgICAgICAgICAgOQ0K
ICAgICAgYkRlc2NyaXB0b3JUeXBlICAgICAgICAgNA0KICAgICAgYkludGVyZmFjZU51bWJl
ciAgICAgICAgMA0KICAgICAgYkFsdGVybmF0ZVNldHRpbmcgICAgICAgMA0KICAgICAgYk51
bUVuZHBvaW50cyAgICAgICAgICAgMg0KICAgICAgYkludGVyZmFjZUNsYXNzICAgICAgIDI1
NSBWZW5kb3IgU3BlY2lmaWMgQ2xhc3MNCiAgICAgIGJJbnRlcmZhY2VTdWJDbGFzcyAgICAg
IDAgDQogICAgICBiSW50ZXJmYWNlUHJvdG9jb2wgICAgICAwIA0KICAgICAgaUludGVyZmFj
ZSAgICAgICAgICAgICAgMCANCiAgICAgIEVuZHBvaW50IERlc2NyaXB0b3I6DQogICAgICAg
IGJMZW5ndGggICAgICAgICAgICAgICAgIDcNCiAgICAgICAgYkRlc2NyaXB0b3JUeXBlICAg
ICAgICAgNQ0KICAgICAgICBiRW5kcG9pbnRBZGRyZXNzICAgICAweDgyICBFUCAyIElODQog
ICAgICAgIGJtQXR0cmlidXRlcyAgICAgICAgICAgIDMNCiAgICAgICAgICBUcmFuc2ZlciBU
eXBlICAgICAgICAgICAgSW50ZXJydXB0DQogICAgICAgICAgU3luY2ggVHlwZSAgICAgICAg
ICAgICAgIE5vbmUNCiAgICAgICAgICBVc2FnZSBUeXBlICAgICAgICAgICAgICAgRGF0YQ0K
ICAgICAgICB3TWF4UGFja2V0U2l6ZSAgICAgMHgwMDAxICAxeCAxIGJ5dGVzDQogICAgICAg
IGJJbnRlcnZhbCAgICAgICAgICAgICAgMzINCiAgICAgIEVuZHBvaW50IERlc2NyaXB0b3I6
DQogICAgICAgIGJMZW5ndGggICAgICAgICAgICAgICAgIDcNCiAgICAgICAgYkRlc2NyaXB0
b3JUeXBlICAgICAgICAgNQ0KICAgICAgICBiRW5kcG9pbnRBZGRyZXNzICAgICAweDg1ICBF
UCA1IElODQogICAgICAgIGJtQXR0cmlidXRlcyAgICAgICAgICAgIDENCiAgICAgICAgICBU
cmFuc2ZlciBUeXBlICAgICAgICAgICAgSXNvY2hyb25vdXMNCiAgICAgICAgICBTeW5jaCBU
eXBlICAgICAgICAgICAgICAgTm9uZQ0KICAgICAgICAgIFVzYWdlIFR5cGUgICAgICAgICAg
ICAgICBEYXRhDQogICAgICAgIHdNYXhQYWNrZXRTaXplICAgICAweDAwMDAgIDF4IDAgYnl0
ZXMNCiAgICAgICAgYkludGVydmFsICAgICAgICAgICAgICAgMQ0KICAgIEludGVyZmFjZSBE
ZXNjcmlwdG9yOg0KICAgICAgYkxlbmd0aCAgICAgICAgICAgICAgICAgOQ0KICAgICAgYkRl
c2NyaXB0b3JUeXBlICAgICAgICAgNA0KICAgICAgYkludGVyZmFjZU51bWJlciAgICAgICAg
MA0KICAgICAgYkFsdGVybmF0ZVNldHRpbmcgICAgICAgMQ0KICAgICAgYk51bUVuZHBvaW50
cyAgICAgICAgICAgMg0KICAgICAgYkludGVyZmFjZUNsYXNzICAgICAgIDI1NSBWZW5kb3Ig
U3BlY2lmaWMgQ2xhc3MNCiAgICAgIGJJbnRlcmZhY2VTdWJDbGFzcyAgICAgIDAgDQogICAg
ICBiSW50ZXJmYWNlUHJvdG9jb2wgICAgICAwIA0KICAgICAgaUludGVyZmFjZSAgICAgICAg
ICAgICAgMCANCiAgICAgIEVuZHBvaW50IERlc2NyaXB0b3I6DQogICAgICAgIGJMZW5ndGgg
ICAgICAgICAgICAgICAgIDcNCiAgICAgICAgYkRlc2NyaXB0b3JUeXBlICAgICAgICAgNQ0K
ICAgICAgICBiRW5kcG9pbnRBZGRyZXNzICAgICAweDgyICBFUCAyIElODQogICAgICAgIGJt
QXR0cmlidXRlcyAgICAgICAgICAgIDMNCiAgICAgICAgICBUcmFuc2ZlciBUeXBlICAgICAg
ICAgICAgSW50ZXJydXB0DQogICAgICAgICAgU3luY2ggVHlwZSAgICAgICAgICAgICAgIE5v
bmUNCiAgICAgICAgICBVc2FnZSBUeXBlICAgICAgICAgICAgICAgRGF0YQ0KICAgICAgICB3
TWF4UGFja2V0U2l6ZSAgICAgMHgwMDAxICAxeCAxIGJ5dGVzDQogICAgICAgIGJJbnRlcnZh
bCAgICAgICAgICAgICAgMzINCiAgICAgIEVuZHBvaW50IERlc2NyaXB0b3I6DQogICAgICAg
IGJMZW5ndGggICAgICAgICAgICAgICAgIDcNCiAgICAgICAgYkRlc2NyaXB0b3JUeXBlICAg
ICAgICAgNQ0KICAgICAgICBiRW5kcG9pbnRBZGRyZXNzICAgICAweDg1ICBFUCA1IElODQog
ICAgICAgIGJtQXR0cmlidXRlcyAgICAgICAgICAgIDENCiAgICAgICAgICBUcmFuc2ZlciBU
eXBlICAgICAgICAgICAgSXNvY2hyb25vdXMNCiAgICAgICAgICBTeW5jaCBUeXBlICAgICAg
ICAgICAgICAgTm9uZQ0KICAgICAgICAgIFVzYWdlIFR5cGUgICAgICAgICAgICAgICBEYXRh
DQogICAgICAgIHdNYXhQYWNrZXRTaXplICAgICAweDAwYzQgIDF4IDE5NiBieXRlcw0KICAg
ICAgICBiSW50ZXJ2YWwgICAgICAgICAgICAgICAxDQogICAgSW50ZXJmYWNlIERlc2NyaXB0
b3I6DQogICAgICBiTGVuZ3RoICAgICAgICAgICAgICAgICA5DQogICAgICBiRGVzY3JpcHRv
clR5cGUgICAgICAgICA0DQogICAgICBiSW50ZXJmYWNlTnVtYmVyICAgICAgICAwDQogICAg
ICBiQWx0ZXJuYXRlU2V0dGluZyAgICAgICAyDQogICAgICBiTnVtRW5kcG9pbnRzICAgICAg
ICAgICAyDQogICAgICBiSW50ZXJmYWNlQ2xhc3MgICAgICAgMjU1IFZlbmRvciBTcGVjaWZp
YyBDbGFzcw0KICAgICAgYkludGVyZmFjZVN1YkNsYXNzICAgICAgMCANCiAgICAgIGJJbnRl
cmZhY2VQcm90b2NvbCAgICAgIDAgDQogICAgICBpSW50ZXJmYWNlICAgICAgICAgICAgICAw
IA0KICAgICAgRW5kcG9pbnQgRGVzY3JpcHRvcjoNCiAgICAgICAgYkxlbmd0aCAgICAgICAg
ICAgICAgICAgNw0KICAgICAgICBiRGVzY3JpcHRvclR5cGUgICAgICAgICA1DQogICAgICAg
IGJFbmRwb2ludEFkZHJlc3MgICAgIDB4ODIgIEVQIDIgSU4NCiAgICAgICAgYm1BdHRyaWJ1
dGVzICAgICAgICAgICAgMw0KICAgICAgICAgIFRyYW5zZmVyIFR5cGUgICAgICAgICAgICBJ
bnRlcnJ1cHQNCiAgICAgICAgICBTeW5jaCBUeXBlICAgICAgICAgICAgICAgTm9uZQ0KICAg
ICAgICAgIFVzYWdlIFR5cGUgICAgICAgICAgICAgICBEYXRhDQogICAgICAgIHdNYXhQYWNr
ZXRTaXplICAgICAweDAwMDEgIDF4IDEgYnl0ZXMNCiAgICAgICAgYkludGVydmFsICAgICAg
ICAgICAgICAzMg0KICAgICAgRW5kcG9pbnQgRGVzY3JpcHRvcjoNCiAgICAgICAgYkxlbmd0
aCAgICAgICAgICAgICAgICAgNw0KICAgICAgICBiRGVzY3JpcHRvclR5cGUgICAgICAgICA1
DQogICAgICAgIGJFbmRwb2ludEFkZHJlc3MgICAgIDB4ODUgIEVQIDUgSU4NCiAgICAgICAg
Ym1BdHRyaWJ1dGVzICAgICAgICAgICAgMQ0KICAgICAgICAgIFRyYW5zZmVyIFR5cGUgICAg
ICAgICAgICBJc29jaHJvbm91cw0KICAgICAgICAgIFN5bmNoIFR5cGUgICAgICAgICAgICAg
ICBOb25lDQogICAgICAgICAgVXNhZ2UgVHlwZSAgICAgICAgICAgICAgIERhdGENCiAgICAg
ICAgd01heFBhY2tldFNpemUgICAgIDB4MDEyNCAgMXggMjkyIGJ5dGVzDQogICAgICAgIGJJ
bnRlcnZhbCAgICAgICAgICAgICAgIDENCiAgICBJbnRlcmZhY2UgRGVzY3JpcHRvcjoNCiAg
ICAgIGJMZW5ndGggICAgICAgICAgICAgICAgIDkNCiAgICAgIGJEZXNjcmlwdG9yVHlwZSAg
ICAgICAgIDQNCiAgICAgIGJJbnRlcmZhY2VOdW1iZXIgICAgICAgIDANCiAgICAgIGJBbHRl
cm5hdGVTZXR0aW5nICAgICAgIDMNCiAgICAgIGJOdW1FbmRwb2ludHMgICAgICAgICAgIDIN
CiAgICAgIGJJbnRlcmZhY2VDbGFzcyAgICAgICAyNTUgVmVuZG9yIFNwZWNpZmljIENsYXNz
DQogICAgICBiSW50ZXJmYWNlU3ViQ2xhc3MgICAgICAwIA0KICAgICAgYkludGVyZmFjZVBy
b3RvY29sICAgICAgMCANCiAgICAgIGlJbnRlcmZhY2UgICAgICAgICAgICAgIDAgDQogICAg
ICBFbmRwb2ludCBEZXNjcmlwdG9yOg0KICAgICAgICBiTGVuZ3RoICAgICAgICAgICAgICAg
ICA3DQogICAgICAgIGJEZXNjcmlwdG9yVHlwZSAgICAgICAgIDUNCiAgICAgICAgYkVuZHBv
aW50QWRkcmVzcyAgICAgMHg4MiAgRVAgMiBJTg0KICAgICAgICBibUF0dHJpYnV0ZXMgICAg
ICAgICAgICAzDQogICAgICAgICAgVHJhbnNmZXIgVHlwZSAgICAgICAgICAgIEludGVycnVw
dA0KICAgICAgICAgIFN5bmNoIFR5cGUgICAgICAgICAgICAgICBOb25lDQogICAgICAgICAg
VXNhZ2UgVHlwZSAgICAgICAgICAgICAgIERhdGENCiAgICAgICAgd01heFBhY2tldFNpemUg
ICAgIDB4MDAwMSAgMXggMSBieXRlcw0KICAgICAgICBiSW50ZXJ2YWwgICAgICAgICAgICAg
IDMyDQogICAgICBFbmRwb2ludCBEZXNjcmlwdG9yOg0KICAgICAgICBiTGVuZ3RoICAgICAg
ICAgICAgICAgICA3DQogICAgICAgIGJEZXNjcmlwdG9yVHlwZSAgICAgICAgIDUNCiAgICAg
ICAgYkVuZHBvaW50QWRkcmVzcyAgICAgMHg4NSAgRVAgNSBJTg0KICAgICAgICBibUF0dHJp
YnV0ZXMgICAgICAgICAgICAxDQogICAgICAgICAgVHJhbnNmZXIgVHlwZSAgICAgICAgICAg
IElzb2Nocm9ub3VzDQogICAgICAgICAgU3luY2ggVHlwZSAgICAgICAgICAgICAgIE5vbmUN
CiAgICAgICAgICBVc2FnZSBUeXBlICAgICAgICAgICAgICAgRGF0YQ0KICAgICAgICB3TWF4
UGFja2V0U2l6ZSAgICAgMHgwMWMwICAxeCA0NDggYnl0ZXMNCiAgICAgICAgYkludGVydmFs
ICAgICAgICAgICAgICAgMQ0KICAgIEludGVyZmFjZSBEZXNjcmlwdG9yOg0KICAgICAgYkxl
bmd0aCAgICAgICAgICAgICAgICAgOQ0KICAgICAgYkRlc2NyaXB0b3JUeXBlICAgICAgICAg
NA0KICAgICAgYkludGVyZmFjZU51bWJlciAgICAgICAgMA0KICAgICAgYkFsdGVybmF0ZVNl
dHRpbmcgICAgICAgNA0KICAgICAgYk51bUVuZHBvaW50cyAgICAgICAgICAgMg0KICAgICAg
YkludGVyZmFjZUNsYXNzICAgICAgIDI1NSBWZW5kb3IgU3BlY2lmaWMgQ2xhc3MNCiAgICAg
IGJJbnRlcmZhY2VTdWJDbGFzcyAgICAgIDAgDQogICAgICBiSW50ZXJmYWNlUHJvdG9jb2wg
ICAgICAwIA0KICAgICAgaUludGVyZmFjZSAgICAgICAgICAgICAgMCANCiAgICAgIEVuZHBv
aW50IERlc2NyaXB0b3I6DQogICAgICAgIGJMZW5ndGggICAgICAgICAgICAgICAgIDcNCiAg
ICAgICAgYkRlc2NyaXB0b3JUeXBlICAgICAgICAgNQ0KICAgICAgICBiRW5kcG9pbnRBZGRy
ZXNzICAgICAweDgyICBFUCAyIElODQogICAgICAgIGJtQXR0cmlidXRlcyAgICAgICAgICAg
IDMNCiAgICAgICAgICBUcmFuc2ZlciBUeXBlICAgICAgICAgICAgSW50ZXJydXB0DQogICAg
ICAgICAgU3luY2ggVHlwZSAgICAgICAgICAgICAgIE5vbmUNCiAgICAgICAgICBVc2FnZSBU
eXBlICAgICAgICAgICAgICAgRGF0YQ0KICAgICAgICB3TWF4UGFja2V0U2l6ZSAgICAgMHgw
MDAxICAxeCAxIGJ5dGVzDQogICAgICAgIGJJbnRlcnZhbCAgICAgICAgICAgICAgMzINCiAg
ICAgIEVuZHBvaW50IERlc2NyaXB0b3I6DQogICAgICAgIGJMZW5ndGggICAgICAgICAgICAg
ICAgIDcNCiAgICAgICAgYkRlc2NyaXB0b3JUeXBlICAgICAgICAgNQ0KICAgICAgICBiRW5k
cG9pbnRBZGRyZXNzICAgICAweDg1ICBFUCA1IElODQogICAgICAgIGJtQXR0cmlidXRlcyAg
ICAgICAgICAgIDENCiAgICAgICAgICBUcmFuc2ZlciBUeXBlICAgICAgICAgICAgSXNvY2hy
b25vdXMNCiAgICAgICAgICBTeW5jaCBUeXBlICAgICAgICAgICAgICAgTm9uZQ0KICAgICAg
ICAgIFVzYWdlIFR5cGUgICAgICAgICAgICAgICBEYXRhDQogICAgICAgIHdNYXhQYWNrZXRT
aXplICAgICAweDAyNTAgIDF4IDU5MiBieXRlcw0KICAgICAgICBiSW50ZXJ2YWwgICAgICAg
ICAgICAgICAxDQogICAgSW50ZXJmYWNlIERlc2NyaXB0b3I6DQogICAgICBiTGVuZ3RoICAg
ICAgICAgICAgICAgICA5DQogICAgICBiRGVzY3JpcHRvclR5cGUgICAgICAgICA0DQogICAg
ICBiSW50ZXJmYWNlTnVtYmVyICAgICAgICAwDQogICAgICBiQWx0ZXJuYXRlU2V0dGluZyAg
ICAgICA1DQogICAgICBiTnVtRW5kcG9pbnRzICAgICAgICAgICAyDQogICAgICBiSW50ZXJm
YWNlQ2xhc3MgICAgICAgMjU1IFZlbmRvciBTcGVjaWZpYyBDbGFzcw0KICAgICAgYkludGVy
ZmFjZVN1YkNsYXNzICAgICAgMCANCiAgICAgIGJJbnRlcmZhY2VQcm90b2NvbCAgICAgIDAg
DQogICAgICBpSW50ZXJmYWNlICAgICAgICAgICAgICAwIA0KICAgICAgRW5kcG9pbnQgRGVz
Y3JpcHRvcjoNCiAgICAgICAgYkxlbmd0aCAgICAgICAgICAgICAgICAgNw0KICAgICAgICBi
RGVzY3JpcHRvclR5cGUgICAgICAgICA1DQogICAgICAgIGJFbmRwb2ludEFkZHJlc3MgICAg
IDB4ODIgIEVQIDIgSU4NCiAgICAgICAgYm1BdHRyaWJ1dGVzICAgICAgICAgICAgMw0KICAg
ICAgICAgIFRyYW5zZmVyIFR5cGUgICAgICAgICAgICBJbnRlcnJ1cHQNCiAgICAgICAgICBT
eW5jaCBUeXBlICAgICAgICAgICAgICAgTm9uZQ0KICAgICAgICAgIFVzYWdlIFR5cGUgICAg
ICAgICAgICAgICBEYXRhDQogICAgICAgIHdNYXhQYWNrZXRTaXplICAgICAweDAwMDEgIDF4
IDEgYnl0ZXMNCiAgICAgICAgYkludGVydmFsICAgICAgICAgICAgICAzMg0KICAgICAgRW5k
cG9pbnQgRGVzY3JpcHRvcjoNCiAgICAgICAgYkxlbmd0aCAgICAgICAgICAgICAgICAgNw0K
ICAgICAgICBiRGVzY3JpcHRvclR5cGUgICAgICAgICA1DQogICAgICAgIGJFbmRwb2ludEFk
ZHJlc3MgICAgIDB4ODUgIEVQIDUgSU4NCiAgICAgICAgYm1BdHRyaWJ1dGVzICAgICAgICAg
ICAgMQ0KICAgICAgICAgIFRyYW5zZmVyIFR5cGUgICAgICAgICAgICBJc29jaHJvbm91cw0K
ICAgICAgICAgIFN5bmNoIFR5cGUgICAgICAgICAgICAgICBOb25lDQogICAgICAgICAgVXNh
Z2UgVHlwZSAgICAgICAgICAgICAgIERhdGENCiAgICAgICAgd01heFBhY2tldFNpemUgICAg
IDB4MDJjMCAgMXggNzA0IGJ5dGVzDQogICAgICAgIGJJbnRlcnZhbCAgICAgICAgICAgICAg
IDENCiAgICBJbnRlcmZhY2UgRGVzY3JpcHRvcjoNCiAgICAgIGJMZW5ndGggICAgICAgICAg
ICAgICAgIDkNCiAgICAgIGJEZXNjcmlwdG9yVHlwZSAgICAgICAgIDQNCiAgICAgIGJJbnRl
cmZhY2VOdW1iZXIgICAgICAgIDANCiAgICAgIGJBbHRlcm5hdGVTZXR0aW5nICAgICAgIDYN
CiAgICAgIGJOdW1FbmRwb2ludHMgICAgICAgICAgIDINCiAgICAgIGJJbnRlcmZhY2VDbGFz
cyAgICAgICAyNTUgVmVuZG9yIFNwZWNpZmljIENsYXNzDQogICAgICBiSW50ZXJmYWNlU3Vi
Q2xhc3MgICAgICAwIA0KICAgICAgYkludGVyZmFjZVByb3RvY29sICAgICAgMCANCiAgICAg
IGlJbnRlcmZhY2UgICAgICAgICAgICAgIDAgDQogICAgICBFbmRwb2ludCBEZXNjcmlwdG9y
Og0KICAgICAgICBiTGVuZ3RoICAgICAgICAgICAgICAgICA3DQogICAgICAgIGJEZXNjcmlw
dG9yVHlwZSAgICAgICAgIDUNCiAgICAgICAgYkVuZHBvaW50QWRkcmVzcyAgICAgMHg4MiAg
RVAgMiBJTg0KICAgICAgICBibUF0dHJpYnV0ZXMgICAgICAgICAgICAzDQogICAgICAgICAg
VHJhbnNmZXIgVHlwZSAgICAgICAgICAgIEludGVycnVwdA0KICAgICAgICAgIFN5bmNoIFR5
cGUgICAgICAgICAgICAgICBOb25lDQogICAgICAgICAgVXNhZ2UgVHlwZSAgICAgICAgICAg
ICAgIERhdGENCiAgICAgICAgd01heFBhY2tldFNpemUgICAgIDB4MDAwMSAgMXggMSBieXRl
cw0KICAgICAgICBiSW50ZXJ2YWwgICAgICAgICAgICAgIDMyDQogICAgICBFbmRwb2ludCBE
ZXNjcmlwdG9yOg0KICAgICAgICBiTGVuZ3RoICAgICAgICAgICAgICAgICA3DQogICAgICAg
IGJEZXNjcmlwdG9yVHlwZSAgICAgICAgIDUNCiAgICAgICAgYkVuZHBvaW50QWRkcmVzcyAg
ICAgMHg4NSAgRVAgNSBJTg0KICAgICAgICBibUF0dHJpYnV0ZXMgICAgICAgICAgICAxDQog
ICAgICAgICAgVHJhbnNmZXIgVHlwZSAgICAgICAgICAgIElzb2Nocm9ub3VzDQogICAgICAg
ICAgU3luY2ggVHlwZSAgICAgICAgICAgICAgIE5vbmUNCiAgICAgICAgICBVc2FnZSBUeXBl
ICAgICAgICAgICAgICAgRGF0YQ0KICAgICAgICB3TWF4UGFja2V0U2l6ZSAgICAgMHgwMzA4
ICAxeCA3NzYgYnl0ZXMNCiAgICAgICAgYkludGVydmFsICAgICAgICAgICAgICAgMQ0KICAg
IEludGVyZmFjZSBEZXNjcmlwdG9yOg0KICAgICAgYkxlbmd0aCAgICAgICAgICAgICAgICAg
OQ0KICAgICAgYkRlc2NyaXB0b3JUeXBlICAgICAgICAgNA0KICAgICAgYkludGVyZmFjZU51
bWJlciAgICAgICAgMA0KICAgICAgYkFsdGVybmF0ZVNldHRpbmcgICAgICAgNw0KICAgICAg
Yk51bUVuZHBvaW50cyAgICAgICAgICAgMg0KICAgICAgYkludGVyZmFjZUNsYXNzICAgICAg
IDI1NSBWZW5kb3IgU3BlY2lmaWMgQ2xhc3MNCiAgICAgIGJJbnRlcmZhY2VTdWJDbGFzcyAg
ICAgIDAgDQogICAgICBiSW50ZXJmYWNlUHJvdG9jb2wgICAgICAwIA0KICAgICAgaUludGVy
ZmFjZSAgICAgICAgICAgICAgMCANCiAgICAgIEVuZHBvaW50IERlc2NyaXB0b3I6DQogICAg
ICAgIGJMZW5ndGggICAgICAgICAgICAgICAgIDcNCiAgICAgICAgYkRlc2NyaXB0b3JUeXBl
ICAgICAgICAgNQ0KICAgICAgICBiRW5kcG9pbnRBZGRyZXNzICAgICAweDgyICBFUCAyIElO
DQogICAgICAgIGJtQXR0cmlidXRlcyAgICAgICAgICAgIDMNCiAgICAgICAgICBUcmFuc2Zl
ciBUeXBlICAgICAgICAgICAgSW50ZXJydXB0DQogICAgICAgICAgU3luY2ggVHlwZSAgICAg
ICAgICAgICAgIE5vbmUNCiAgICAgICAgICBVc2FnZSBUeXBlICAgICAgICAgICAgICAgRGF0
YQ0KICAgICAgICB3TWF4UGFja2V0U2l6ZSAgICAgMHgwMDAxICAxeCAxIGJ5dGVzDQogICAg
ICAgIGJJbnRlcnZhbCAgICAgICAgICAgICAgMzINCiAgICAgIEVuZHBvaW50IERlc2NyaXB0
b3I6DQogICAgICAgIGJMZW5ndGggICAgICAgICAgICAgICAgIDcNCiAgICAgICAgYkRlc2Ny
aXB0b3JUeXBlICAgICAgICAgNQ0KICAgICAgICBiRW5kcG9pbnRBZGRyZXNzICAgICAweDg1
ICBFUCA1IElODQogICAgICAgIGJtQXR0cmlidXRlcyAgICAgICAgICAgIDENCiAgICAgICAg
ICBUcmFuc2ZlciBUeXBlICAgICAgICAgICAgSXNvY2hyb25vdXMNCiAgICAgICAgICBTeW5j
aCBUeXBlICAgICAgICAgICAgICAgTm9uZQ0KICAgICAgICAgIFVzYWdlIFR5cGUgICAgICAg
ICAgICAgICBEYXRhDQogICAgICAgIHdNYXhQYWNrZXRTaXplICAgICAweDAzNDggIDF4IDg0
MCBieXRlcw0KICAgICAgICBiSW50ZXJ2YWwgICAgICAgICAgICAgICAxDQogICAgSW50ZXJm
YWNlIERlc2NyaXB0b3I6DQogICAgICBiTGVuZ3RoICAgICAgICAgICAgICAgICA5DQogICAg
ICBiRGVzY3JpcHRvclR5cGUgICAgICAgICA0DQogICAgICBiSW50ZXJmYWNlTnVtYmVyICAg
ICAgICAwDQogICAgICBiQWx0ZXJuYXRlU2V0dGluZyAgICAgICA4DQogICAgICBiTnVtRW5k
cG9pbnRzICAgICAgICAgICAyDQogICAgICBiSW50ZXJmYWNlQ2xhc3MgICAgICAgMjU1IFZl
bmRvciBTcGVjaWZpYyBDbGFzcw0KICAgICAgYkludGVyZmFjZVN1YkNsYXNzICAgICAgMCAN
CiAgICAgIGJJbnRlcmZhY2VQcm90b2NvbCAgICAgIDAgDQogICAgICBpSW50ZXJmYWNlICAg
ICAgICAgICAgICAwIA0KICAgICAgRW5kcG9pbnQgRGVzY3JpcHRvcjoNCiAgICAgICAgYkxl
bmd0aCAgICAgICAgICAgICAgICAgNw0KICAgICAgICBiRGVzY3JpcHRvclR5cGUgICAgICAg
ICA1DQogICAgICAgIGJFbmRwb2ludEFkZHJlc3MgICAgIDB4ODIgIEVQIDIgSU4NCiAgICAg
ICAgYm1BdHRyaWJ1dGVzICAgICAgICAgICAgMw0KICAgICAgICAgIFRyYW5zZmVyIFR5cGUg
ICAgICAgICAgICBJbnRlcnJ1cHQNCiAgICAgICAgICBTeW5jaCBUeXBlICAgICAgICAgICAg
ICAgTm9uZQ0KICAgICAgICAgIFVzYWdlIFR5cGUgICAgICAgICAgICAgICBEYXRhDQogICAg
ICAgIHdNYXhQYWNrZXRTaXplICAgICAweDAwMDEgIDF4IDEgYnl0ZXMNCiAgICAgICAgYklu
dGVydmFsICAgICAgICAgICAgICAzMg0KICAgICAgRW5kcG9pbnQgRGVzY3JpcHRvcjoNCiAg
ICAgICAgYkxlbmd0aCAgICAgICAgICAgICAgICAgNw0KICAgICAgICBiRGVzY3JpcHRvclR5
cGUgICAgICAgICA1DQogICAgICAgIGJFbmRwb2ludEFkZHJlc3MgICAgIDB4ODUgIEVQIDUg
SU4NCiAgICAgICAgYm1BdHRyaWJ1dGVzICAgICAgICAgICAgMQ0KICAgICAgICAgIFRyYW5z
ZmVyIFR5cGUgICAgICAgICAgICBJc29jaHJvbm91cw0KICAgICAgICAgIFN5bmNoIFR5cGUg
ICAgICAgICAgICAgICBOb25lDQogICAgICAgICAgVXNhZ2UgVHlwZSAgICAgICAgICAgICAg
IERhdGENCiAgICAgICAgd01heFBhY2tldFNpemUgICAgIDB4MDM4MCAgMXggODk2IGJ5dGVz
DQogICAgICAgIGJJbnRlcnZhbCAgICAgICAgICAgICAgIDENCiAgICBJbnRlcmZhY2UgRGVz
Y3JpcHRvcjoNCiAgICAgIGJMZW5ndGggICAgICAgICAgICAgICAgIDkNCiAgICAgIGJEZXNj
cmlwdG9yVHlwZSAgICAgICAgIDQNCiAgICAgIGJJbnRlcmZhY2VOdW1iZXIgICAgICAgIDAN
CiAgICAgIGJBbHRlcm5hdGVTZXR0aW5nICAgICAgIDkNCiAgICAgIGJOdW1FbmRwb2ludHMg
ICAgICAgICAgIDINCiAgICAgIGJJbnRlcmZhY2VDbGFzcyAgICAgICAyNTUgVmVuZG9yIFNw
ZWNpZmljIENsYXNzDQogICAgICBiSW50ZXJmYWNlU3ViQ2xhc3MgICAgICAwIA0KICAgICAg
YkludGVyZmFjZVByb3RvY29sICAgICAgMCANCiAgICAgIGlJbnRlcmZhY2UgICAgICAgICAg
ICAgIDAgDQogICAgICBFbmRwb2ludCBEZXNjcmlwdG9yOg0KICAgICAgICBiTGVuZ3RoICAg
ICAgICAgICAgICAgICA3DQogICAgICAgIGJEZXNjcmlwdG9yVHlwZSAgICAgICAgIDUNCiAg
ICAgICAgYkVuZHBvaW50QWRkcmVzcyAgICAgMHg4MiAgRVAgMiBJTg0KICAgICAgICBibUF0
dHJpYnV0ZXMgICAgICAgICAgICAzDQogICAgICAgICAgVHJhbnNmZXIgVHlwZSAgICAgICAg
ICAgIEludGVycnVwdA0KICAgICAgICAgIFN5bmNoIFR5cGUgICAgICAgICAgICAgICBOb25l
DQogICAgICAgICAgVXNhZ2UgVHlwZSAgICAgICAgICAgICAgIERhdGENCiAgICAgICAgd01h
eFBhY2tldFNpemUgICAgIDB4MDAwMSAgMXggMSBieXRlcw0KICAgICAgICBiSW50ZXJ2YWwg
ICAgICAgICAgICAgIDMyDQogICAgICBFbmRwb2ludCBEZXNjcmlwdG9yOg0KICAgICAgICBi
TGVuZ3RoICAgICAgICAgICAgICAgICA3DQogICAgICAgIGJEZXNjcmlwdG9yVHlwZSAgICAg
ICAgIDUNCiAgICAgICAgYkVuZHBvaW50QWRkcmVzcyAgICAgMHg4NSAgRVAgNSBJTg0KICAg
ICAgICBibUF0dHJpYnV0ZXMgICAgICAgICAgICAxDQogICAgICAgICAgVHJhbnNmZXIgVHlw
ZSAgICAgICAgICAgIElzb2Nocm9ub3VzDQogICAgICAgICAgU3luY2ggVHlwZSAgICAgICAg
ICAgICAgIE5vbmUNCiAgICAgICAgICBVc2FnZSBUeXBlICAgICAgICAgICAgICAgRGF0YQ0K
ICAgICAgICB3TWF4UGFja2V0U2l6ZSAgICAgMHgwM2MwICAxeCA5NjAgYnl0ZXMNCiAgICAg
ICAgYkludGVydmFsICAgICAgICAgICAgICAgMQ0KICAgIEludGVyZmFjZSBEZXNjcmlwdG9y
Og0KICAgICAgYkxlbmd0aCAgICAgICAgICAgICAgICAgOQ0KICAgICAgYkRlc2NyaXB0b3JU
eXBlICAgICAgICAgNA0KICAgICAgYkludGVyZmFjZU51bWJlciAgICAgICAgMA0KICAgICAg
YkFsdGVybmF0ZVNldHRpbmcgICAgICAxMA0KICAgICAgYk51bUVuZHBvaW50cyAgICAgICAg
ICAgMg0KICAgICAgYkludGVyZmFjZUNsYXNzICAgICAgIDI1NSBWZW5kb3IgU3BlY2lmaWMg
Q2xhc3MNCiAgICAgIGJJbnRlcmZhY2VTdWJDbGFzcyAgICAgIDAgDQogICAgICBiSW50ZXJm
YWNlUHJvdG9jb2wgICAgICAwIA0KICAgICAgaUludGVyZmFjZSAgICAgICAgICAgICAgMCAN
CiAgICAgIEVuZHBvaW50IERlc2NyaXB0b3I6DQogICAgICAgIGJMZW5ndGggICAgICAgICAg
ICAgICAgIDcNCiAgICAgICAgYkRlc2NyaXB0b3JUeXBlICAgICAgICAgNQ0KICAgICAgICBi
RW5kcG9pbnRBZGRyZXNzICAgICAweDgyICBFUCAyIElODQogICAgICAgIGJtQXR0cmlidXRl
cyAgICAgICAgICAgIDMNCiAgICAgICAgICBUcmFuc2ZlciBUeXBlICAgICAgICAgICAgSW50
ZXJydXB0DQogICAgICAgICAgU3luY2ggVHlwZSAgICAgICAgICAgICAgIE5vbmUNCiAgICAg
ICAgICBVc2FnZSBUeXBlICAgICAgICAgICAgICAgRGF0YQ0KICAgICAgICB3TWF4UGFja2V0
U2l6ZSAgICAgMHgwMDAxICAxeCAxIGJ5dGVzDQogICAgICAgIGJJbnRlcnZhbCAgICAgICAg
ICAgICAgMzINCiAgICAgIEVuZHBvaW50IERlc2NyaXB0b3I6DQogICAgICAgIGJMZW5ndGgg
ICAgICAgICAgICAgICAgIDcNCiAgICAgICAgYkRlc2NyaXB0b3JUeXBlICAgICAgICAgNQ0K
ICAgICAgICBiRW5kcG9pbnRBZGRyZXNzICAgICAweDg1ICBFUCA1IElODQogICAgICAgIGJt
QXR0cmlidXRlcyAgICAgICAgICAgIDENCiAgICAgICAgICBUcmFuc2ZlciBUeXBlICAgICAg
ICAgICAgSXNvY2hyb25vdXMNCiAgICAgICAgICBTeW5jaCBUeXBlICAgICAgICAgICAgICAg
Tm9uZQ0KICAgICAgICAgIFVzYWdlIFR5cGUgICAgICAgICAgICAgICBEYXRhDQogICAgICAg
IHdNYXhQYWNrZXRTaXplICAgICAweDAzYzAgIDF4IDk2MCBieXRlcw0KICAgICAgICBiSW50
ZXJ2YWwgICAgICAgICAgICAgICAxDQogICAgSW50ZXJmYWNlIERlc2NyaXB0b3I6DQogICAg
ICBiTGVuZ3RoICAgICAgICAgICAgICAgICA5DQogICAgICBiRGVzY3JpcHRvclR5cGUgICAg
ICAgICA0DQogICAgICBiSW50ZXJmYWNlTnVtYmVyICAgICAgICAxDQogICAgICBiQWx0ZXJu
YXRlU2V0dGluZyAgICAgICAwDQogICAgICBiTnVtRW5kcG9pbnRzICAgICAgICAgICAwDQog
ICAgICBiSW50ZXJmYWNlQ2xhc3MgICAgICAgICAxIEF1ZGlvDQogICAgICBiSW50ZXJmYWNl
U3ViQ2xhc3MgICAgICAxIENvbnRyb2wgRGV2aWNlDQogICAgICBiSW50ZXJmYWNlUHJvdG9j
b2wgICAgICAwIA0KICAgICAgaUludGVyZmFjZSAgICAgICAgICAgICAgMCANCiAgICAgIEF1
ZGlvQ29udHJvbCBJbnRlcmZhY2UgRGVzY3JpcHRvcjoNCiAgICAgICAgYkxlbmd0aCAgICAg
ICAgICAgICAgICAgOQ0KICAgICAgICBiRGVzY3JpcHRvclR5cGUgICAgICAgIDM2DQogICAg
ICAgIGJEZXNjcmlwdG9yU3VidHlwZSAgICAgIDEgKEhFQURFUikNCiAgICAgICAgYmNkQURD
ICAgICAgICAgICAgICAgMS4wMA0KICAgICAgICB3VG90YWxMZW5ndGggICAgICAgICAgIDM4
DQogICAgICAgIGJJbkNvbGxlY3Rpb24gICAgICAgICAgIDENCiAgICAgICAgYmFJbnRlcmZh
Y2VOciggMCkgICAgICAgMg0KICAgICAgQXVkaW9Db250cm9sIEludGVyZmFjZSBEZXNjcmlw
dG9yOg0KICAgICAgICBiTGVuZ3RoICAgICAgICAgICAgICAgIDEyDQogICAgICAgIGJEZXNj
cmlwdG9yVHlwZSAgICAgICAgMzYNCiAgICAgICAgYkRlc2NyaXB0b3JTdWJ0eXBlICAgICAg
MiAoSU5QVVRfVEVSTUlOQUwpDQogICAgICAgIGJUZXJtaW5hbElEICAgICAgICAgICAgIDEN
CiAgICAgICAgd1Rlcm1pbmFsVHlwZSAgICAgIDB4MDIwMSBNaWNyb3Bob25lDQogICAgICAg
IGJBc3NvY1Rlcm1pbmFsICAgICAgICAgIDANCiAgICAgICAgYk5yQ2hhbm5lbHMgICAgICAg
ICAgICAgMQ0KICAgICAgICB3Q2hhbm5lbENvbmZpZyAgICAgMHgwMDAwDQogICAgICAgIGlD
aGFubmVsTmFtZXMgICAgICAgICAgIDAgDQogICAgICAgIGlUZXJtaW5hbCAgICAgICAgICAg
ICAgIDAgDQogICAgICBBdWRpb0NvbnRyb2wgSW50ZXJmYWNlIERlc2NyaXB0b3I6DQogICAg
ICAgIGJMZW5ndGggICAgICAgICAgICAgICAgIDgNCiAgICAgICAgYkRlc2NyaXB0b3JUeXBl
ICAgICAgICAzNg0KICAgICAgICBiRGVzY3JpcHRvclN1YnR5cGUgICAgICA2IChGRUFUVVJF
X1VOSVQpDQogICAgICAgIGJVbml0SUQgICAgICAgICAgICAgICAgIDINCiAgICAgICAgYlNv
dXJjZUlEICAgICAgICAgICAgICAgMQ0KICAgICAgICBiQ29udHJvbFNpemUgICAgICAgICAg
ICAxDQogICAgICAgIGJtYUNvbnRyb2xzKCAwKSAgICAgIDB4MDMNCiAgICAgICAgICBNdXRl
DQogICAgICAgICAgVm9sdW1lDQogICAgICAgIGlGZWF0dXJlICAgICAgICAgICAgICAgIDAg
DQogICAgICBBdWRpb0NvbnRyb2wgSW50ZXJmYWNlIERlc2NyaXB0b3I6DQogICAgICAgIGJM
ZW5ndGggICAgICAgICAgICAgICAgIDkNCiAgICAgICAgYkRlc2NyaXB0b3JUeXBlICAgICAg
ICAzNg0KICAgICAgICBiRGVzY3JpcHRvclN1YnR5cGUgICAgICAzIChPVVRQVVRfVEVSTUlO
QUwpDQogICAgICAgIGJUZXJtaW5hbElEICAgICAgICAgICAgIDMNCiAgICAgICAgd1Rlcm1p
bmFsVHlwZSAgICAgIDB4MDEwMSBVU0IgU3RyZWFtaW5nDQogICAgICAgIGJBc3NvY1Rlcm1p
bmFsICAgICAgICAgIDANCiAgICAgICAgYlNvdXJjZUlEICAgICAgICAgICAgICAgMg0KICAg
ICAgICBpVGVybWluYWwgICAgICAgICAgICAgICAwIA0KICAgIEludGVyZmFjZSBEZXNjcmlw
dG9yOg0KICAgICAgYkxlbmd0aCAgICAgICAgICAgICAgICAgOQ0KICAgICAgYkRlc2NyaXB0
b3JUeXBlICAgICAgICAgNA0KICAgICAgYkludGVyZmFjZU51bWJlciAgICAgICAgMg0KICAg
ICAgYkFsdGVybmF0ZVNldHRpbmcgICAgICAgMA0KICAgICAgYk51bUVuZHBvaW50cyAgICAg
ICAgICAgMA0KICAgICAgYkludGVyZmFjZUNsYXNzICAgICAgICAgMSBBdWRpbw0KICAgICAg
YkludGVyZmFjZVN1YkNsYXNzICAgICAgMiBTdHJlYW1pbmcNCiAgICAgIGJJbnRlcmZhY2VQ
cm90b2NvbCAgICAgIDAgDQogICAgICBpSW50ZXJmYWNlICAgICAgICAgICAgICAwIA0KICAg
IEludGVyZmFjZSBEZXNjcmlwdG9yOg0KICAgICAgYkxlbmd0aCAgICAgICAgICAgICAgICAg
OQ0KICAgICAgYkRlc2NyaXB0b3JUeXBlICAgICAgICAgNA0KICAgICAgYkludGVyZmFjZU51
bWJlciAgICAgICAgMg0KICAgICAgYkFsdGVybmF0ZVNldHRpbmcgICAgICAgMQ0KICAgICAg
Yk51bUVuZHBvaW50cyAgICAgICAgICAgMQ0KICAgICAgYkludGVyZmFjZUNsYXNzICAgICAg
ICAgMSBBdWRpbw0KICAgICAgYkludGVyZmFjZVN1YkNsYXNzICAgICAgMiBTdHJlYW1pbmcN
CiAgICAgIGJJbnRlcmZhY2VQcm90b2NvbCAgICAgIDAgDQogICAgICBpSW50ZXJmYWNlICAg
ICAgICAgICAgICAwIA0KICAgICAgQXVkaW9TdHJlYW1pbmcgSW50ZXJmYWNlIERlc2NyaXB0
b3I6DQogICAgICAgIGJMZW5ndGggICAgICAgICAgICAgICAgIDcNCiAgICAgICAgYkRlc2Ny
aXB0b3JUeXBlICAgICAgICAzNg0KICAgICAgICBiRGVzY3JpcHRvclN1YnR5cGUgICAgICAx
IChBU19HRU5FUkFMKQ0KICAgICAgICBiVGVybWluYWxMaW5rICAgICAgICAgICAzDQogICAg
ICAgIGJEZWxheSAgICAgICAgICAgICAgICAgIDEgZnJhbWVzDQogICAgICAgIHdGb3JtYXRU
YWcgICAgICAgICAgICAgIDEgUENNDQogICAgICBBdWRpb1N0cmVhbWluZyBJbnRlcmZhY2Ug
RGVzY3JpcHRvcjoNCiAgICAgICAgYkxlbmd0aCAgICAgICAgICAgICAgICAxMQ0KICAgICAg
ICBiRGVzY3JpcHRvclR5cGUgICAgICAgIDM2DQogICAgICAgIGJEZXNjcmlwdG9yU3VidHlw
ZSAgICAgIDIgKEZPUk1BVF9UWVBFKQ0KICAgICAgICBiRm9ybWF0VHlwZSAgICAgICAgICAg
ICAxIChGT1JNQVRfVFlQRV9JKQ0KICAgICAgICBiTnJDaGFubmVscyAgICAgICAgICAgICAx
DQogICAgICAgIGJTdWJmcmFtZVNpemUgICAgICAgICAgIDINCiAgICAgICAgYkJpdFJlc29s
dXRpb24gICAgICAgICAxNg0KICAgICAgICBiU2FtRnJlcVR5cGUgICAgICAgICAgICAxIERp
c2NyZXRlDQogICAgICAgIHRTYW1GcmVxWyAwXSAgICAgICAgNDQxMDANCiAgICAgIEVuZHBv
aW50IERlc2NyaXB0b3I6DQogICAgICAgIGJMZW5ndGggICAgICAgICAgICAgICAgIDkNCiAg
ICAgICAgYkRlc2NyaXB0b3JUeXBlICAgICAgICAgNQ0KICAgICAgICBiRW5kcG9pbnRBZGRy
ZXNzICAgICAweDg0ICBFUCA0IElODQogICAgICAgIGJtQXR0cmlidXRlcyAgICAgICAgICAg
IDENCiAgICAgICAgICBUcmFuc2ZlciBUeXBlICAgICAgICAgICAgSXNvY2hyb25vdXMNCiAg
ICAgICAgICBTeW5jaCBUeXBlICAgICAgICAgICAgICAgTm9uZQ0KICAgICAgICAgIFVzYWdl
IFR5cGUgICAgICAgICAgICAgICBEYXRhDQogICAgICAgIHdNYXhQYWNrZXRTaXplICAgICAw
eDAwNWEgIDF4IDkwIGJ5dGVzDQogICAgICAgIGJJbnRlcnZhbCAgICAgICAgICAgICAgIDEN
CiAgICAgICAgYlJlZnJlc2ggICAgICAgICAgICAgICAgMA0KICAgICAgICBiU3luY2hBZGRy
ZXNzICAgICAgICAgICAwDQogICAgICAgIEF1ZGlvQ29udHJvbCBFbmRwb2ludCBEZXNjcmlw
dG9yOg0KICAgICAgICAgIGJMZW5ndGggICAgICAgICAgICAgICAgIDcNCiAgICAgICAgICBi
RGVzY3JpcHRvclR5cGUgICAgICAgIDM3DQogICAgICAgICAgYkRlc2NyaXB0b3JTdWJ0eXBl
ICAgICAgMSAoRVBfR0VORVJBTCkNCiAgICAgICAgICBibUF0dHJpYnV0ZXMgICAgICAgICAw
eDAwDQogICAgICAgICAgYkxvY2tEZWxheVVuaXRzICAgICAgICAgMCBVbmRlZmluZWQNCiAg
ICAgICAgICB3TG9ja0RlbGF5ICAgICAgICAgICAgICAwIFVuZGVmaW5lZA0KICAgIEludGVy
ZmFjZSBEZXNjcmlwdG9yOg0KICAgICAgYkxlbmd0aCAgICAgICAgICAgICAgICAgOQ0KICAg
ICAgYkRlc2NyaXB0b3JUeXBlICAgICAgICAgNA0KICAgICAgYkludGVyZmFjZU51bWJlciAg
ICAgICAgMg0KICAgICAgYkFsdGVybmF0ZVNldHRpbmcgICAgICAgMg0KICAgICAgYk51bUVu
ZHBvaW50cyAgICAgICAgICAgMQ0KICAgICAgYkludGVyZmFjZUNsYXNzICAgICAgICAgMSBB
dWRpbw0KICAgICAgYkludGVyZmFjZVN1YkNsYXNzICAgICAgMiBTdHJlYW1pbmcNCiAgICAg
IGJJbnRlcmZhY2VQcm90b2NvbCAgICAgIDAgDQogICAgICBpSW50ZXJmYWNlICAgICAgICAg
ICAgICAwIA0KICAgICAgQXVkaW9TdHJlYW1pbmcgSW50ZXJmYWNlIERlc2NyaXB0b3I6DQog
ICAgICAgIGJMZW5ndGggICAgICAgICAgICAgICAgIDcNCiAgICAgICAgYkRlc2NyaXB0b3JU
eXBlICAgICAgICAzNg0KICAgICAgICBiRGVzY3JpcHRvclN1YnR5cGUgICAgICAxIChBU19H
RU5FUkFMKQ0KICAgICAgICBiVGVybWluYWxMaW5rICAgICAgICAgICAzDQogICAgICAgIGJE
ZWxheSAgICAgICAgICAgICAgICAgIDEgZnJhbWVzDQogICAgICAgIHdGb3JtYXRUYWcgICAg
ICAgICAgICAgIDEgUENNDQogICAgICBBdWRpb1N0cmVhbWluZyBJbnRlcmZhY2UgRGVzY3Jp
cHRvcjoNCiAgICAgICAgYkxlbmd0aCAgICAgICAgICAgICAgICAxMQ0KICAgICAgICBiRGVz
Y3JpcHRvclR5cGUgICAgICAgIDM2DQogICAgICAgIGJEZXNjcmlwdG9yU3VidHlwZSAgICAg
IDIgKEZPUk1BVF9UWVBFKQ0KICAgICAgICBiRm9ybWF0VHlwZSAgICAgICAgICAgICAxIChG
T1JNQVRfVFlQRV9JKQ0KICAgICAgICBiTnJDaGFubmVscyAgICAgICAgICAgICAxDQogICAg
ICAgIGJTdWJmcmFtZVNpemUgICAgICAgICAgIDINCiAgICAgICAgYkJpdFJlc29sdXRpb24g
ICAgICAgICAxNg0KICAgICAgICBiU2FtRnJlcVR5cGUgICAgICAgICAgICAxIERpc2NyZXRl
DQogICAgICAgIHRTYW1GcmVxWyAwXSAgICAgICAgMjIwNTANCiAgICAgIEVuZHBvaW50IERl
c2NyaXB0b3I6DQogICAgICAgIGJMZW5ndGggICAgICAgICAgICAgICAgIDkNCiAgICAgICAg
YkRlc2NyaXB0b3JUeXBlICAgICAgICAgNQ0KICAgICAgICBiRW5kcG9pbnRBZGRyZXNzICAg
ICAweDg0ICBFUCA0IElODQogICAgICAgIGJtQXR0cmlidXRlcyAgICAgICAgICAgIDENCiAg
ICAgICAgICBUcmFuc2ZlciBUeXBlICAgICAgICAgICAgSXNvY2hyb25vdXMNCiAgICAgICAg
ICBTeW5jaCBUeXBlICAgICAgICAgICAgICAgTm9uZQ0KICAgICAgICAgIFVzYWdlIFR5cGUg
ICAgICAgICAgICAgICBEYXRhDQogICAgICAgIHdNYXhQYWNrZXRTaXplICAgICAweDAwMmUg
IDF4IDQ2IGJ5dGVzDQogICAgICAgIGJJbnRlcnZhbCAgICAgICAgICAgICAgIDENCiAgICAg
ICAgYlJlZnJlc2ggICAgICAgICAgICAgICAgMA0KICAgICAgICBiU3luY2hBZGRyZXNzICAg
ICAgICAgICAwDQogICAgICAgIEF1ZGlvQ29udHJvbCBFbmRwb2ludCBEZXNjcmlwdG9yOg0K
ICAgICAgICAgIGJMZW5ndGggICAgICAgICAgICAgICAgIDcNCiAgICAgICAgICBiRGVzY3Jp
cHRvclR5cGUgICAgICAgIDM3DQogICAgICAgICAgYkRlc2NyaXB0b3JTdWJ0eXBlICAgICAg
MSAoRVBfR0VORVJBTCkNCiAgICAgICAgICBibUF0dHJpYnV0ZXMgICAgICAgICAweDAwDQog
ICAgICAgICAgYkxvY2tEZWxheVVuaXRzICAgICAgICAgMCBVbmRlZmluZWQNCiAgICAgICAg
ICB3TG9ja0RlbGF5ICAgICAgICAgICAgICAwIFVuZGVmaW5lZA0KICAgIEludGVyZmFjZSBE
ZXNjcmlwdG9yOg0KICAgICAgYkxlbmd0aCAgICAgICAgICAgICAgICAgOQ0KICAgICAgYkRl
c2NyaXB0b3JUeXBlICAgICAgICAgNA0KICAgICAgYkludGVyZmFjZU51bWJlciAgICAgICAg
Mg0KICAgICAgYkFsdGVybmF0ZVNldHRpbmcgICAgICAgMw0KICAgICAgYk51bUVuZHBvaW50
cyAgICAgICAgICAgMQ0KICAgICAgYkludGVyZmFjZUNsYXNzICAgICAgICAgMSBBdWRpbw0K
ICAgICAgYkludGVyZmFjZVN1YkNsYXNzICAgICAgMiBTdHJlYW1pbmcNCiAgICAgIGJJbnRl
cmZhY2VQcm90b2NvbCAgICAgIDAgDQogICAgICBpSW50ZXJmYWNlICAgICAgICAgICAgICAw
IA0KICAgICAgQXVkaW9TdHJlYW1pbmcgSW50ZXJmYWNlIERlc2NyaXB0b3I6DQogICAgICAg
IGJMZW5ndGggICAgICAgICAgICAgICAgIDcNCiAgICAgICAgYkRlc2NyaXB0b3JUeXBlICAg
ICAgICAzNg0KICAgICAgICBiRGVzY3JpcHRvclN1YnR5cGUgICAgICAxIChBU19HRU5FUkFM
KQ0KICAgICAgICBiVGVybWluYWxMaW5rICAgICAgICAgICAzDQogICAgICAgIGJEZWxheSAg
ICAgICAgICAgICAgICAgIDEgZnJhbWVzDQogICAgICAgIHdGb3JtYXRUYWcgICAgICAgICAg
ICAgIDEgUENNDQogICAgICBBdWRpb1N0cmVhbWluZyBJbnRlcmZhY2UgRGVzY3JpcHRvcjoN
CiAgICAgICAgYkxlbmd0aCAgICAgICAgICAgICAgICAxMQ0KICAgICAgICBiRGVzY3JpcHRv
clR5cGUgICAgICAgIDM2DQogICAgICAgIGJEZXNjcmlwdG9yU3VidHlwZSAgICAgIDIgKEZP
Uk1BVF9UWVBFKQ0KICAgICAgICBiRm9ybWF0VHlwZSAgICAgICAgICAgICAxIChGT1JNQVRf
VFlQRV9JKQ0KICAgICAgICBiTnJDaGFubmVscyAgICAgICAgICAgICAxDQogICAgICAgIGJT
dWJmcmFtZVNpemUgICAgICAgICAgIDINCiAgICAgICAgYkJpdFJlc29sdXRpb24gICAgICAg
ICAxNg0KICAgICAgICBiU2FtRnJlcVR5cGUgICAgICAgICAgICAxIERpc2NyZXRlDQogICAg
ICAgIHRTYW1GcmVxWyAwXSAgICAgICAgMTEwMjUNCiAgICAgIEVuZHBvaW50IERlc2NyaXB0
b3I6DQogICAgICAgIGJMZW5ndGggICAgICAgICAgICAgICAgIDkNCiAgICAgICAgYkRlc2Ny
aXB0b3JUeXBlICAgICAgICAgNQ0KICAgICAgICBiRW5kcG9pbnRBZGRyZXNzICAgICAweDg0
ICBFUCA0IElODQogICAgICAgIGJtQXR0cmlidXRlcyAgICAgICAgICAgIDENCiAgICAgICAg
ICBUcmFuc2ZlciBUeXBlICAgICAgICAgICAgSXNvY2hyb25vdXMNCiAgICAgICAgICBTeW5j
aCBUeXBlICAgICAgICAgICAgICAgTm9uZQ0KICAgICAgICAgIFVzYWdlIFR5cGUgICAgICAg
ICAgICAgICBEYXRhDQogICAgICAgIHdNYXhQYWNrZXRTaXplICAgICAweDAwMTkgIDF4IDI1
IGJ5dGVzDQogICAgICAgIGJJbnRlcnZhbCAgICAgICAgICAgICAgIDENCiAgICAgICAgYlJl
ZnJlc2ggICAgICAgICAgICAgICAgMA0KICAgICAgICBiU3luY2hBZGRyZXNzICAgICAgICAg
ICAwDQogICAgICAgIEF1ZGlvQ29udHJvbCBFbmRwb2ludCBEZXNjcmlwdG9yOg0KICAgICAg
ICAgIGJMZW5ndGggICAgICAgICAgICAgICAgIDcNCiAgICAgICAgICBiRGVzY3JpcHRvclR5
cGUgICAgICAgIDM3DQogICAgICAgICAgYkRlc2NyaXB0b3JTdWJ0eXBlICAgICAgMSAoRVBf
R0VORVJBTCkNCiAgICAgICAgICBibUF0dHJpYnV0ZXMgICAgICAgICAweDAwDQogICAgICAg
ICAgYkxvY2tEZWxheVVuaXRzICAgICAgICAgMCBVbmRlZmluZWQNCiAgICAgICAgICB3TG9j
a0RlbGF5ICAgICAgICAgICAgICAwIFVuZGVmaW5lZA0KICAgIEludGVyZmFjZSBEZXNjcmlw
dG9yOg0KICAgICAgYkxlbmd0aCAgICAgICAgICAgICAgICAgOQ0KICAgICAgYkRlc2NyaXB0
b3JUeXBlICAgICAgICAgNA0KICAgICAgYkludGVyZmFjZU51bWJlciAgICAgICAgMg0KICAg
ICAgYkFsdGVybmF0ZVNldHRpbmcgICAgICAgNA0KICAgICAgYk51bUVuZHBvaW50cyAgICAg
ICAgICAgMQ0KICAgICAgYkludGVyZmFjZUNsYXNzICAgICAgICAgMSBBdWRpbw0KICAgICAg
YkludGVyZmFjZVN1YkNsYXNzICAgICAgMiBTdHJlYW1pbmcNCiAgICAgIGJJbnRlcmZhY2VQ
cm90b2NvbCAgICAgIDAgDQogICAgICBpSW50ZXJmYWNlICAgICAgICAgICAgICAwIA0KICAg
ICAgQXVkaW9TdHJlYW1pbmcgSW50ZXJmYWNlIERlc2NyaXB0b3I6DQogICAgICAgIGJMZW5n
dGggICAgICAgICAgICAgICAgIDcNCiAgICAgICAgYkRlc2NyaXB0b3JUeXBlICAgICAgICAz
Ng0KICAgICAgICBiRGVzY3JpcHRvclN1YnR5cGUgICAgICAxIChBU19HRU5FUkFMKQ0KICAg
ICAgICBiVGVybWluYWxMaW5rICAgICAgICAgICAzDQogICAgICAgIGJEZWxheSAgICAgICAg
ICAgICAgICAgIDEgZnJhbWVzDQogICAgICAgIHdGb3JtYXRUYWcgICAgICAgICAgICAgIDEg
UENNDQogICAgICBBdWRpb1N0cmVhbWluZyBJbnRlcmZhY2UgRGVzY3JpcHRvcjoNCiAgICAg
ICAgYkxlbmd0aCAgICAgICAgICAgICAgICAxMQ0KICAgICAgICBiRGVzY3JpcHRvclR5cGUg
ICAgICAgIDM2DQogICAgICAgIGJEZXNjcmlwdG9yU3VidHlwZSAgICAgIDIgKEZPUk1BVF9U
WVBFKQ0KICAgICAgICBiRm9ybWF0VHlwZSAgICAgICAgICAgICAxIChGT1JNQVRfVFlQRV9J
KQ0KICAgICAgICBiTnJDaGFubmVscyAgICAgICAgICAgICAxDQogICAgICAgIGJTdWJmcmFt
ZVNpemUgICAgICAgICAgIDINCiAgICAgICAgYkJpdFJlc29sdXRpb24gICAgICAgICAxNg0K
ICAgICAgICBiU2FtRnJlcVR5cGUgICAgICAgICAgICAxIERpc2NyZXRlDQogICAgICAgIHRT
YW1GcmVxWyAwXSAgICAgICAgIDgwMDANCiAgICAgIEVuZHBvaW50IERlc2NyaXB0b3I6DQog
ICAgICAgIGJMZW5ndGggICAgICAgICAgICAgICAgIDkNCiAgICAgICAgYkRlc2NyaXB0b3JU
eXBlICAgICAgICAgNQ0KICAgICAgICBiRW5kcG9pbnRBZGRyZXNzICAgICAweDg0ICBFUCA0
IElODQogICAgICAgIGJtQXR0cmlidXRlcyAgICAgICAgICAgIDENCiAgICAgICAgICBUcmFu
c2ZlciBUeXBlICAgICAgICAgICAgSXNvY2hyb25vdXMNCiAgICAgICAgICBTeW5jaCBUeXBl
ICAgICAgICAgICAgICAgTm9uZQ0KICAgICAgICAgIFVzYWdlIFR5cGUgICAgICAgICAgICAg
ICBEYXRhDQogICAgICAgIHdNYXhQYWNrZXRTaXplICAgICAweDAwMTAgIDF4IDE2IGJ5dGVz
DQogICAgICAgIGJJbnRlcnZhbCAgICAgICAgICAgICAgIDENCiAgICAgICAgYlJlZnJlc2gg
ICAgICAgICAgICAgICAgMA0KICAgICAgICBiU3luY2hBZGRyZXNzICAgICAgICAgICAwDQog
ICAgICAgIEF1ZGlvQ29udHJvbCBFbmRwb2ludCBEZXNjcmlwdG9yOg0KICAgICAgICAgIGJM
ZW5ndGggICAgICAgICAgICAgICAgIDcNCiAgICAgICAgICBiRGVzY3JpcHRvclR5cGUgICAg
ICAgIDM3DQogICAgICAgICAgYkRlc2NyaXB0b3JTdWJ0eXBlICAgICAgMSAoRVBfR0VORVJB
TCkNCiAgICAgICAgICBibUF0dHJpYnV0ZXMgICAgICAgICAweDAwDQogICAgICAgICAgYkxv
Y2tEZWxheVVuaXRzICAgICAgICAgMCBVbmRlZmluZWQNCiAgICAgICAgICB3TG9ja0RlbGF5
ICAgICAgICAgICAgICAwIFVuZGVmaW5lZA0KRGV2aWNlIFN0YXR1czogICAgIDB4MDAwMg0K
ICAoQnVzIFBvd2VyZWQpDQogIFJlbW90ZSBXYWtldXAgRW5hYmxlZA0KDQpCdXMgMDA5IERl
dmljZSAwMDE6IElEIDFkNmI6MDAwMyBMaW51eCBGb3VuZGF0aW9uIDMuMCByb290IGh1Yg0K
RGV2aWNlIERlc2NyaXB0b3I6DQogIGJMZW5ndGggICAgICAgICAgICAgICAgMTgNCiAgYkRl
c2NyaXB0b3JUeXBlICAgICAgICAgMQ0KICBiY2RVU0IgICAgICAgICAgICAgICAzLjAwDQog
IGJEZXZpY2VDbGFzcyAgICAgICAgICAgIDkgSHViDQogIGJEZXZpY2VTdWJDbGFzcyAgICAg
ICAgIDAgVW51c2VkDQogIGJEZXZpY2VQcm90b2NvbCAgICAgICAgIDMgDQogIGJNYXhQYWNr
ZXRTaXplMCAgICAgICAgIDkNCiAgaWRWZW5kb3IgICAgICAgICAgIDB4MWQ2YiBMaW51eCBG
b3VuZGF0aW9uDQogIGlkUHJvZHVjdCAgICAgICAgICAweDAwMDMgMy4wIHJvb3QgaHViDQog
IGJjZERldmljZSAgICAgICAgICAgIDIuMDYNCiAgaU1hbnVmYWN0dXJlciAgICAgICAgICAg
MyBMaW51eCAyLjYuMzQtcmMxIHhoY2lfaGNkDQogIGlQcm9kdWN0ICAgICAgICAgICAgICAg
IDIgeEhDSSBIb3N0IENvbnRyb2xsZXINCiAgaVNlcmlhbCAgICAgICAgICAgICAgICAgMSAw
MDAwOjAzOjAwLjANCiAgYk51bUNvbmZpZ3VyYXRpb25zICAgICAgMQ0KICBDb25maWd1cmF0
aW9uIERlc2NyaXB0b3I6DQogICAgYkxlbmd0aCAgICAgICAgICAgICAgICAgOQ0KICAgIGJE
ZXNjcmlwdG9yVHlwZSAgICAgICAgIDINCiAgICB3VG90YWxMZW5ndGggICAgICAgICAgIDI1
DQogICAgYk51bUludGVyZmFjZXMgICAgICAgICAgMQ0KICAgIGJDb25maWd1cmF0aW9uVmFs
dWUgICAgIDENCiAgICBpQ29uZmlndXJhdGlvbiAgICAgICAgICAwIA0KICAgIGJtQXR0cmli
dXRlcyAgICAgICAgIDB4ZTANCiAgICAgIFNlbGYgUG93ZXJlZA0KICAgICAgUmVtb3RlIFdh
a2V1cA0KICAgIE1heFBvd2VyICAgICAgICAgICAgICAgIDBtQQ0KICAgIEludGVyZmFjZSBE
ZXNjcmlwdG9yOg0KICAgICAgYkxlbmd0aCAgICAgICAgICAgICAgICAgOQ0KICAgICAgYkRl
c2NyaXB0b3JUeXBlICAgICAgICAgNA0KICAgICAgYkludGVyZmFjZU51bWJlciAgICAgICAg
MA0KICAgICAgYkFsdGVybmF0ZVNldHRpbmcgICAgICAgMA0KICAgICAgYk51bUVuZHBvaW50
cyAgICAgICAgICAgMQ0KICAgICAgYkludGVyZmFjZUNsYXNzICAgICAgICAgOSBIdWINCiAg
ICAgIGJJbnRlcmZhY2VTdWJDbGFzcyAgICAgIDAgVW51c2VkDQogICAgICBiSW50ZXJmYWNl
UHJvdG9jb2wgICAgICAwIEZ1bGwgc3BlZWQgKG9yIHJvb3QpIGh1Yg0KICAgICAgaUludGVy
ZmFjZSAgICAgICAgICAgICAgMCANCiAgICAgIEVuZHBvaW50IERlc2NyaXB0b3I6DQogICAg
ICAgIGJMZW5ndGggICAgICAgICAgICAgICAgIDcNCiAgICAgICAgYkRlc2NyaXB0b3JUeXBl
ICAgICAgICAgNQ0KICAgICAgICBiRW5kcG9pbnRBZGRyZXNzICAgICAweDgxICBFUCAxIElO
DQogICAgICAgIGJtQXR0cmlidXRlcyAgICAgICAgICAgIDMNCiAgICAgICAgICBUcmFuc2Zl
ciBUeXBlICAgICAgICAgICAgSW50ZXJydXB0DQogICAgICAgICAgU3luY2ggVHlwZSAgICAg
ICAgICAgICAgIE5vbmUNCiAgICAgICAgICBVc2FnZSBUeXBlICAgICAgICAgICAgICAgRGF0
YQ0KICAgICAgICB3TWF4UGFja2V0U2l6ZSAgICAgMHgwMDA0ICAxeCA0IGJ5dGVzDQogICAg
ICAgIGJJbnRlcnZhbCAgICAgICAgICAgICAgMTINCkh1YiBEZXNjcmlwdG9yOg0KICBiTGVu
Z3RoICAgICAgICAgICAgICAgOQ0KICBiRGVzY3JpcHRvclR5cGUgICAgICA0MQ0KICBuTmJy
UG9ydHMgICAgICAgICAgICAgNA0KICB3SHViQ2hhcmFjdGVyaXN0aWMgMHgwMDA5DQogICAg
UGVyLXBvcnQgcG93ZXIgc3dpdGNoaW5nDQogICAgUGVyLXBvcnQgb3ZlcmN1cnJlbnQgcHJv
dGVjdGlvbg0KICAgIFRUIHRoaW5rIHRpbWUgOCBGUyBiaXRzDQogIGJQd3JPbjJQd3JHb29k
ICAgICAgIDEwICogMiBtaWxsaSBzZWNvbmRzDQogIGJIdWJDb250ckN1cnJlbnQgICAgICAw
IG1pbGxpIEFtcGVyZQ0KICBEZXZpY2VSZW1vdmFibGUgICAgMHgwMA0KICBQb3J0UHdyQ3Ry
bE1hc2sgICAgMHhmZg0KIEh1YiBQb3J0IFN0YXR1czoNCiAgIFBvcnQgMTogMDAwMC4wMTAw
IHBvd2VyDQogICBQb3J0IDI6IDAwMDAuMDEwMCBwb3dlcg0KICAgUG9ydCAzOiAwMDAwLjAx
MDMgcG93ZXIgZW5hYmxlIGNvbm5lY3QNCiAgIFBvcnQgNDogMDAwMC4wMTAwIHBvd2VyDQpE
ZXZpY2UgU3RhdHVzOiAgICAgMHgwMDAzDQogIFNlbGYgUG93ZXJlZA0KICBSZW1vdGUgV2Fr
ZXVwIEVuYWJsZWQNCg==
------------110125428278FB3--

