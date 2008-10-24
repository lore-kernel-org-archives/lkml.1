Return-Path: <linux-kernel-owner+w=401wt.eu-S1758054AbYJXVsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758054AbYJXVsh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 17:48:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754491AbYJXVs2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 17:48:28 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48238 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751341AbYJXVsZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 17:48:25 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Folkert van Heusden <folkert@vanheusden.com>
Subject: Re: [2.6.27-rc7] oops in usbcore
Date: Fri, 24 Oct 2008 23:53:08 +0200
User-Agent: KMail/1.9.9
Cc: Oliver Neukum <oliver@neukum.org>, linux-kernel@vger.kernel.org,
       USB list <linux-usb@vger.kernel.org>
References: <20081009082946.GG23933@vanheusden.com> <200810091033.43665.oliver@neukum.org> <20081009084205.GI23933@vanheusden.com>
In-Reply-To: <20081009084205.GI23933@vanheusden.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810242353.08576.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 9 of October 2008, Folkert van Heusden wrote:
> > > lpc-ntpd is a atomic clock receiver driver doing read()-calls on an fd
> > > from a serial device (connected via usb), nothing fancy
> > > (http://vanheusden.com/lpc-ntpd/ ).
> > 
> > Which devices? Please post lsusb -v
> 
> thegate:/home/folkert# lsusb  -v > lsusb
> cannot read device status, Broken pipe (32)
> 
> Isn't that error odd?
> 
> The output is:
> 
> Bus 004 Device 006: ID 046d:08b2 Logitech, Inc. QuickCam Pro 4000
> Device Descriptor:
>   bLength                18
>   bDescriptorType         1
>   bcdUSB               1.10
>   bDeviceClass            0 (Defined at Interface level)
>   bDeviceSubClass         0 
>   bDeviceProtocol         0 
>   bMaxPacketSize0         8
>   idVendor           0x046d Logitech, Inc.
>   idProduct          0x08b2 QuickCam Pro 4000
>   bcdDevice            0.00
>   iManufacturer           0 
>   iProduct                0 
>   iSerial                 0 
>   bNumConfigurations      1
>   Configuration Descriptor:
>     bLength                 9
>     bDescriptorType         2
>     wTotalLength          490
>     bNumInterfaces          3
>     bConfigurationValue     1
>     iConfiguration          0 
>     bmAttributes         0xa0
>       (Bus Powered)
>       Remote Wakeup
>     MaxPower              500mA
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        0
>       bAlternateSetting       0
>       bNumEndpoints           2
>       bInterfaceClass       255 Vendor Specific Class
>       bInterfaceSubClass      0 
>       bInterfaceProtocol      0 
>       iInterface              0 
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x82  EP 2 IN
>         bmAttributes            3
>           Transfer Type            Interrupt
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0001  1x 1 bytes
>         bInterval              32
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x85  EP 5 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0000  1x 0 bytes
>         bInterval               1
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        0
>       bAlternateSetting       1
>       bNumEndpoints           2
>       bInterfaceClass       255 Vendor Specific Class
>       bInterfaceSubClass      0 
>       bInterfaceProtocol      0 
>       iInterface              0 
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x82  EP 2 IN
>         bmAttributes            3
>           Transfer Type            Interrupt
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0001  1x 1 bytes
>         bInterval              32
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x85  EP 5 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x00c4  1x 196 bytes
>         bInterval               1
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        0
>       bAlternateSetting       2
>       bNumEndpoints           2
>       bInterfaceClass       255 Vendor Specific Class
>       bInterfaceSubClass      0 
>       bInterfaceProtocol      0 
>       iInterface              0 
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x82  EP 2 IN
>         bmAttributes            3
>           Transfer Type            Interrupt
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0001  1x 1 bytes
>         bInterval              32
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x85  EP 5 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0124  1x 292 bytes
>         bInterval               1
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        0
>       bAlternateSetting       3
>       bNumEndpoints           2
>       bInterfaceClass       255 Vendor Specific Class
>       bInterfaceSubClass      0 
>       bInterfaceProtocol      0 
>       iInterface              0 
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x82  EP 2 IN
>         bmAttributes            3
>           Transfer Type            Interrupt
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0001  1x 1 bytes
>         bInterval              32
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x85  EP 5 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x01c0  1x 448 bytes
>         bInterval               1
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        0
>       bAlternateSetting       4
>       bNumEndpoints           2
>       bInterfaceClass       255 Vendor Specific Class
>       bInterfaceSubClass      0 
>       bInterfaceProtocol      0 
>       iInterface              0 
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x82  EP 2 IN
>         bmAttributes            3
>           Transfer Type            Interrupt
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0001  1x 1 bytes
>         bInterval              32
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x85  EP 5 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0250  1x 592 bytes
>         bInterval               1
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        0
>       bAlternateSetting       5
>       bNumEndpoints           2
>       bInterfaceClass       255 Vendor Specific Class
>       bInterfaceSubClass      0 
>       bInterfaceProtocol      0 
>       iInterface              0 
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x82  EP 2 IN
>         bmAttributes            3
>           Transfer Type            Interrupt
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0001  1x 1 bytes
>         bInterval              32
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x85  EP 5 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x02c0  1x 704 bytes
>         bInterval               1
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        0
>       bAlternateSetting       6
>       bNumEndpoints           2
>       bInterfaceClass       255 Vendor Specific Class
>       bInterfaceSubClass      0 
>       bInterfaceProtocol      0 
>       iInterface              0 
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x82  EP 2 IN
>         bmAttributes            3
>           Transfer Type            Interrupt
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0001  1x 1 bytes
>         bInterval              32
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x85  EP 5 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0308  1x 776 bytes
>         bInterval               1
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        0
>       bAlternateSetting       7
>       bNumEndpoints           2
>       bInterfaceClass       255 Vendor Specific Class
>       bInterfaceSubClass      0 
>       bInterfaceProtocol      0 
>       iInterface              0 
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x82  EP 2 IN
>         bmAttributes            3
>           Transfer Type            Interrupt
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0001  1x 1 bytes
>         bInterval              32
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x85  EP 5 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0348  1x 840 bytes
>         bInterval               1
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        0
>       bAlternateSetting       8
>       bNumEndpoints           2
>       bInterfaceClass       255 Vendor Specific Class
>       bInterfaceSubClass      0 
>       bInterfaceProtocol      0 
>       iInterface              0 
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x82  EP 2 IN
>         bmAttributes            3
>           Transfer Type            Interrupt
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0001  1x 1 bytes
>         bInterval              32
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x85  EP 5 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0380  1x 896 bytes
>         bInterval               1
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        0
>       bAlternateSetting       9
>       bNumEndpoints           2
>       bInterfaceClass       255 Vendor Specific Class
>       bInterfaceSubClass      0 
>       bInterfaceProtocol      0 
>       iInterface              0 
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x82  EP 2 IN
>         bmAttributes            3
>           Transfer Type            Interrupt
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0001  1x 1 bytes
>         bInterval              32
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x85  EP 5 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x03c0  1x 960 bytes
>         bInterval               1
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        0
>       bAlternateSetting      10
>       bNumEndpoints           2
>       bInterfaceClass       255 Vendor Specific Class
>       bInterfaceSubClass      0 
>       bInterfaceProtocol      0 
>       iInterface              0 
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x82  EP 2 IN
>         bmAttributes            3
>           Transfer Type            Interrupt
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0001  1x 1 bytes
>         bInterval              32
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x85  EP 5 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x03c0  1x 960 bytes
>         bInterval               1
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        1
>       bAlternateSetting       0
>       bNumEndpoints           0
>       bInterfaceClass         1 Audio
>       bInterfaceSubClass      1 Control Device
>       bInterfaceProtocol      0 
>       iInterface              0 
>       AudioControl Interface Descriptor:
>         bLength                 9
>         bDescriptorType        36
>         bDescriptorSubtype      1 (HEADER)
>         bcdADC               1.00
>         wTotalLength           38
>         bInCollection           1
>         baInterfaceNr( 0)       2
>       AudioControl Interface Descriptor:
>         bLength                12
>         bDescriptorType        36
>         bDescriptorSubtype      2 (INPUT_TERMINAL)
>         bTerminalID             1
>         wTerminalType      0x0201 Microphone
>         bAssocTerminal          0
>         bNrChannels             1
>         wChannelConfig     0x0000
>         iChannelNames           0 
>         iTerminal               0 
>       AudioControl Interface Descriptor:
>         bLength                 8
>         bDescriptorType        36
>         bDescriptorSubtype      6 (FEATURE_UNIT)
>         bUnitID                 2
>         bSourceID               1
>         bControlSize            1
>         bmaControls( 0)      0x03
>           Mute
>           Volume
>         iFeature                0 
>       AudioControl Interface Descriptor:
>         bLength                 9
>         bDescriptorType        36
>         bDescriptorSubtype      3 (OUTPUT_TERMINAL)
>         bTerminalID             3
>         wTerminalType      0x0101 USB Streaming
>         bAssocTerminal          0
>         bSourceID               2
>         iTerminal               0 
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        2
>       bAlternateSetting       0
>       bNumEndpoints           0
>       bInterfaceClass         1 Audio
>       bInterfaceSubClass      2 Streaming
>       bInterfaceProtocol      0 
>       iInterface              0 
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        2
>       bAlternateSetting       1
>       bNumEndpoints           1
>       bInterfaceClass         1 Audio
>       bInterfaceSubClass      2 Streaming
>       bInterfaceProtocol      0 
>       iInterface              0 
>       AudioStreaming Interface Descriptor:
>         bLength                 7
>         bDescriptorType        36
>         bDescriptorSubtype      1 (AS_GENERAL)
>         bTerminalLink           3
>         bDelay                  1 frames
>         wFormatTag              1 PCM
>       AudioStreaming Interface Descriptor:
>         bLength                11
>         bDescriptorType        36
>         bDescriptorSubtype      2 (FORMAT_TYPE)
>         bFormatType             1 (FORMAT_TYPE_I)
>         bNrChannels             1
>         bSubframeSize           2
>         bBitResolution         16
>         bSamFreqType            1 Discrete
>         tSamFreq[ 0]        44100
>       Endpoint Descriptor:
>         bLength                 9
>         bDescriptorType         5
>         bEndpointAddress     0x84  EP 4 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x005a  1x 90 bytes
>         bInterval               1
>         bRefresh                0
>         bSynchAddress           0
>         AudioControl Endpoint Descriptor:
>           bLength                 7
>           bDescriptorType        37
>           bDescriptorSubtype      1 (EP_GENERAL)
>           bmAttributes         0x00
>           bLockDelayUnits         0 Undefined
>           wLockDelay              0 Undefined
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        2
>       bAlternateSetting       2
>       bNumEndpoints           1
>       bInterfaceClass         1 Audio
>       bInterfaceSubClass      2 Streaming
>       bInterfaceProtocol      0 
>       iInterface              0 
>       AudioStreaming Interface Descriptor:
>         bLength                 7
>         bDescriptorType        36
>         bDescriptorSubtype      1 (AS_GENERAL)
>         bTerminalLink           3
>         bDelay                  1 frames
>         wFormatTag              1 PCM
>       AudioStreaming Interface Descriptor:
>         bLength                11
>         bDescriptorType        36
>         bDescriptorSubtype      2 (FORMAT_TYPE)
>         bFormatType             1 (FORMAT_TYPE_I)
>         bNrChannels             1
>         bSubframeSize           2
>         bBitResolution         16
>         bSamFreqType            1 Discrete
>         tSamFreq[ 0]        22050
>       Endpoint Descriptor:
>         bLength                 9
>         bDescriptorType         5
>         bEndpointAddress     0x84  EP 4 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x002e  1x 46 bytes
>         bInterval               1
>         bRefresh                0
>         bSynchAddress           0
>         AudioControl Endpoint Descriptor:
>           bLength                 7
>           bDescriptorType        37
>           bDescriptorSubtype      1 (EP_GENERAL)
>           bmAttributes         0x00
>           bLockDelayUnits         0 Undefined
>           wLockDelay              0 Undefined
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        2
>       bAlternateSetting       3
>       bNumEndpoints           1
>       bInterfaceClass         1 Audio
>       bInterfaceSubClass      2 Streaming
>       bInterfaceProtocol      0 
>       iInterface              0 
>       AudioStreaming Interface Descriptor:
>         bLength                 7
>         bDescriptorType        36
>         bDescriptorSubtype      1 (AS_GENERAL)
>         bTerminalLink           3
>         bDelay                  1 frames
>         wFormatTag              1 PCM
>       AudioStreaming Interface Descriptor:
>         bLength                11
>         bDescriptorType        36
>         bDescriptorSubtype      2 (FORMAT_TYPE)
>         bFormatType             1 (FORMAT_TYPE_I)
>         bNrChannels             1
>         bSubframeSize           2
>         bBitResolution         16
>         bSamFreqType            1 Discrete
>         tSamFreq[ 0]        11025
>       Endpoint Descriptor:
>         bLength                 9
>         bDescriptorType         5
>         bEndpointAddress     0x84  EP 4 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0019  1x 25 bytes
>         bInterval               1
>         bRefresh                0
>         bSynchAddress           0
>         AudioControl Endpoint Descriptor:
>           bLength                 7
>           bDescriptorType        37
>           bDescriptorSubtype      1 (EP_GENERAL)
>           bmAttributes         0x00
>           bLockDelayUnits         0 Undefined
>           wLockDelay              0 Undefined
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        2
>       bAlternateSetting       4
>       bNumEndpoints           1
>       bInterfaceClass         1 Audio
>       bInterfaceSubClass      2 Streaming
>       bInterfaceProtocol      0 
>       iInterface              0 
>       AudioStreaming Interface Descriptor:
>         bLength                 7
>         bDescriptorType        36
>         bDescriptorSubtype      1 (AS_GENERAL)
>         bTerminalLink           3
>         bDelay                  1 frames
>         wFormatTag              1 PCM
>       AudioStreaming Interface Descriptor:
>         bLength                11
>         bDescriptorType        36
>         bDescriptorSubtype      2 (FORMAT_TYPE)
>         bFormatType             1 (FORMAT_TYPE_I)
>         bNrChannels             1
>         bSubframeSize           2
>         bBitResolution         16
>         bSamFreqType            1 Discrete
>         tSamFreq[ 0]         8000
>       Endpoint Descriptor:
>         bLength                 9
>         bDescriptorType         5
>         bEndpointAddress     0x84  EP 4 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0010  1x 16 bytes
>         bInterval               1
>         bRefresh                0
>         bSynchAddress           0
>         AudioControl Endpoint Descriptor:
>           bLength                 7
>           bDescriptorType        37
>           bDescriptorSubtype      1 (EP_GENERAL)
>           bmAttributes         0x00
>           bLockDelayUnits         0 Undefined
>           wLockDelay              0 Undefined
> 
> Bus 004 Device 007: ID 0403:e88b Future Technology Devices International, Ltd Precision Clock MSF USB
> Device Descriptor:
>   bLength                18
>   bDescriptorType         1
>   bcdUSB               2.00
>   bDeviceClass            0 (Defined at Interface level)
>   bDeviceSubClass         0 
>   bDeviceProtocol         0 
>   bMaxPacketSize0         8
>   idVendor           0x0403 Future Technology Devices International, Ltd
>   idProduct          0xe88b Precision Clock MSF USB
>   bcdDevice            6.00
>   iManufacturer           1 GUDEADS
>   iProduct                2 Precision Clock USB
>   iSerial                 3 FTQQJ1MO
>   bNumConfigurations      1
>   Configuration Descriptor:
>     bLength                 9
>     bDescriptorType         2
>     wTotalLength           32
>     bNumInterfaces          1
>     bConfigurationValue     1
>     iConfiguration          0 
>     bmAttributes         0x80
>       (Bus Powered)
>     MaxPower              100mA
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        0
>       bAlternateSetting       0
>       bNumEndpoints           2
>       bInterfaceClass       255 Vendor Specific Class
>       bInterfaceSubClass    255 Vendor Specific Subclass
>       bInterfaceProtocol    255 Vendor Specific Protocol
>       iInterface              2 Precision Clock USB
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x81  EP 1 IN
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0040  1x 64 bytes
>         bInterval               0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x02  EP 2 OUT
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0040  1x 64 bytes
>         bInterval               0
> Device Status:     0x0000
>   (Bus Powered)
> 
> Bus 004 Device 005: ID 05e3:0608 Genesys Logic, Inc. USB-2.0 4-Port HUB
> Device Descriptor:
>   bLength                18
>   bDescriptorType         1
>   bcdUSB               2.00
>   bDeviceClass            9 Hub
>   bDeviceSubClass         0 Unused
>   bDeviceProtocol         1 Single TT
>   bMaxPacketSize0        64
>   idVendor           0x05e3 Genesys Logic, Inc.
>   idProduct          0x0608 USB-2.0 4-Port HUB
>   bcdDevice            7.02
>   iManufacturer           0 
>   iProduct                1 USB2.0 Hub
>   iSerial                 0 
>   bNumConfigurations      1
>   Configuration Descriptor:
>     bLength                 9
>     bDescriptorType         2
>     wTotalLength           25
>     bNumInterfaces          1
>     bConfigurationValue     1
>     iConfiguration          0 
>     bmAttributes         0xe0
>       Self Powered
>       Remote Wakeup
>     MaxPower              100mA
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        0
>       bAlternateSetting       0
>       bNumEndpoints           1
>       bInterfaceClass         9 Hub
>       bInterfaceSubClass      0 Unused
>       bInterfaceProtocol      0 Full speed (or root) hub
>       iInterface              0 
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x81  EP 1 IN
>         bmAttributes            3
>           Transfer Type            Interrupt
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0001  1x 1 bytes
>         bInterval              12
> Hub Descriptor:
>   bLength               9
>   bDescriptorType      41
>   nNbrPorts             4
>   wHubCharacteristic 0x00e9
>     Per-port power switching
>     Per-port overcurrent protection
>     TT think time 32 FS bits
>     Port indicators
>   bPwrOn2PwrGood       50 * 2 milli seconds
>   bHubContrCurrent    100 milli Ampere
>   DeviceRemovable    0x00
>   PortPwrCtrlMask    0xff
>  Hub Port Status:
>    Port 1: 0000.0100 power
>    Port 2: 0000.0100 power
>    Port 3: 0000.0100 power
>    Port 4: 0000.0103 power enable connect
> Device Qualifier (for other device speed):
>   bLength                10
>   bDescriptorType         6
>   bcdUSB               2.00
>   bDeviceClass            9 Hub
>   bDeviceSubClass         0 Unused
>   bDeviceProtocol         0 Full speed (or root) hub
>   bMaxPacketSize0        64
>   bNumConfigurations      1
> Device Status:     0x0003
>   Self Powered
>   Remote Wakeup Enabled
> 
> Bus 004 Device 003: ID 05e3:0608 Genesys Logic, Inc. USB-2.0 4-Port HUB
> Device Descriptor:
>   bLength                18
>   bDescriptorType         1
>   bcdUSB               2.00
>   bDeviceClass            9 Hub
>   bDeviceSubClass         0 Unused
>   bDeviceProtocol         1 Single TT
>   bMaxPacketSize0        64
>   idVendor           0x05e3 Genesys Logic, Inc.
>   idProduct          0x0608 USB-2.0 4-Port HUB
>   bcdDevice            7.02
>   iManufacturer           0 
>   iProduct                1 USB2.0 Hub
>   iSerial                 0 
>   bNumConfigurations      1
>   Configuration Descriptor:
>     bLength                 9
>     bDescriptorType         2
>     wTotalLength           25
>     bNumInterfaces          1
>     bConfigurationValue     1
>     iConfiguration          0 
>     bmAttributes         0xe0
>       Self Powered
>       Remote Wakeup
>     MaxPower              100mA
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        0
>       bAlternateSetting       0
>       bNumEndpoints           1
>       bInterfaceClass         9 Hub
>       bInterfaceSubClass      0 Unused
>       bInterfaceProtocol      0 Full speed (or root) hub
>       iInterface              0 
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x81  EP 1 IN
>         bmAttributes            3
>           Transfer Type            Interrupt
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0001  1x 1 bytes
>         bInterval              12
> Hub Descriptor:
>   bLength               9
>   bDescriptorType      41
>   nNbrPorts             4
>   wHubCharacteristic 0x00e0
>     Ganged power switching
>     Ganged overcurrent protection
>     TT think time 32 FS bits
>     Port indicators
>   bPwrOn2PwrGood       50 * 2 milli seconds
>   bHubContrCurrent    100 milli Ampere
>   DeviceRemovable    0x00
>   PortPwrCtrlMask    0xff
>  Hub Port Status:
>    Port 1: 0000.0103 power enable connect
>    Port 2: 0000.0100 power
>    Port 3: 0000.0100 power
>    Port 4: 0000.0100 power
> Device Qualifier (for other device speed):
>   bLength                10
>   bDescriptorType         6
>   bcdUSB               2.00
>   bDeviceClass            9 Hub
>   bDeviceSubClass         0 Unused
>   bDeviceProtocol         0 Full speed (or root) hub
>   bMaxPacketSize0        64
>   bNumConfigurations      1
> Device Status:     0x0003
>   Self Powered
>   Remote Wakeup Enabled
> 
> Bus 004 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
> Device Descriptor:
>   bLength                18
>   bDescriptorType         1
>   bcdUSB               2.00
>   bDeviceClass            9 Hub
>   bDeviceSubClass         0 Unused
>   bDeviceProtocol         0 Full speed (or root) hub
>   bMaxPacketSize0        64
>   idVendor           0x1d6b Linux Foundation
>   idProduct          0x0002 2.0 root hub
>   bcdDevice            2.06
>   iManufacturer           3 Linux 2.6.27-rc7-c7-c7temp-100hz-ch341 ehci_hcd
>   iProduct                2 EHCI Host Controller
>   iSerial                 1 0000:00:10.4
>   bNumConfigurations      1
>   Configuration Descriptor:
>     bLength                 9
>     bDescriptorType         2
>     wTotalLength           25
>     bNumInterfaces          1
>     bConfigurationValue     1
>     iConfiguration          0 
>     bmAttributes         0xe0
>       Self Powered
>       Remote Wakeup
>     MaxPower                0mA
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        0
>       bAlternateSetting       0
>       bNumEndpoints           1
>       bInterfaceClass         9 Hub
>       bInterfaceSubClass      0 Unused
>       bInterfaceProtocol      0 Full speed (or root) hub
>       iInterface              0 
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x81  EP 1 IN
>         bmAttributes            3
>           Transfer Type            Interrupt
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0004  1x 4 bytes
>         bInterval              12
> Hub Descriptor:
>   bLength               9
>   bDescriptorType      41
>   nNbrPorts             6
>   wHubCharacteristic 0x000a
>     No power switching (usb 1.0)
>     Per-port overcurrent protection
>   bPwrOn2PwrGood       10 * 2 milli seconds
>   bHubContrCurrent      0 milli Ampere
>   DeviceRemovable    0x00
>   PortPwrCtrlMask    0xff
>  Hub Port Status:
>    Port 1: 0000.0100 power
>    Port 2: 0000.0503 highspeed power enable connect
>    Port 3: 0000.0100 power
>    Port 4: 0000.0503 highspeed power enable connect
>    Port 5: 0000.0100 power
>    Port 6: 0000.0100 power
> Device Status:     0x0003
>   Self Powered
>   Remote Wakeup Enabled
> 
> Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Device Descriptor:
>   bLength                18
>   bDescriptorType         1
>   bcdUSB               1.10
>   bDeviceClass            9 Hub
>   bDeviceSubClass         0 Unused
>   bDeviceProtocol         0 Full speed (or root) hub
>   bMaxPacketSize0        64
>   idVendor           0x1d6b Linux Foundation
>   idProduct          0x0001 1.1 root hub
>   bcdDevice            2.06
>   iManufacturer           3 Linux 2.6.27-rc7-c7-c7temp-100hz-ch341 uhci_hcd
>   iProduct                2 UHCI Host Controller
>   iSerial                 1 0000:00:10.2
>   bNumConfigurations      1
>   Configuration Descriptor:
>     bLength                 9
>     bDescriptorType         2
>     wTotalLength           25
>     bNumInterfaces          1
>     bConfigurationValue     1
>     iConfiguration          0 
>     bmAttributes         0xe0
>       Self Powered
>       Remote Wakeup
>     MaxPower                0mA
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        0
>       bAlternateSetting       0
>       bNumEndpoints           1
>       bInterfaceClass         9 Hub
>       bInterfaceSubClass      0 Unused
>       bInterfaceProtocol      0 Full speed (or root) hub
>       iInterface              0 
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x81  EP 1 IN
>         bmAttributes            3
>           Transfer Type            Interrupt
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0002  1x 2 bytes
>         bInterval             255
> Hub Descriptor:
>   bLength               9
>   bDescriptorType      41
>   nNbrPorts             2
>   wHubCharacteristic 0x000a
>     No power switching (usb 1.0)
>     Per-port overcurrent protection
>   bPwrOn2PwrGood        1 * 2 milli seconds
>   bHubContrCurrent      0 milli Ampere
>   DeviceRemovable    0x00
>   PortPwrCtrlMask    0xff
>  Hub Port Status:
>    Port 1: 0000.0100 power
>    Port 2: 0000.0100 power
> Device Status:     0x0003
>   Self Powered
>   Remote Wakeup Enabled
> 
> Bus 002 Device 002: ID 0d50:0008 Cleware GmbH 
> Device Descriptor:
>   bLength                18
>   bDescriptorType         1
>   bcdUSB               1.10
>   bDeviceClass            0 (Defined at Interface level)
>   bDeviceSubClass         0 
>   bDeviceProtocol         0 
>   bMaxPacketSize0         8
>   idVendor           0x0d50 Cleware GmbH
>   idProduct          0x0008 
>   bcdDevice            0.19
>   iManufacturer           1 Cleware GmbH
>   iProduct                2 USB-Ampel
>   iSerial                 3 00023D9
>   bNumConfigurations      1
>   Configuration Descriptor:
>     bLength                 9
>     bDescriptorType         2
>     wTotalLength           34
>     bNumInterfaces          1
>     bConfigurationValue     1
>     iConfiguration          0 
>     bmAttributes         0x80
>       (Bus Powered)
>     MaxPower              440mA
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        0
>       bAlternateSetting       0
>       bNumEndpoints           1
>       bInterfaceClass         3 Human Interface Device
>       bInterfaceSubClass      0 No Subclass
>       bInterfaceProtocol      0 None
>       iInterface              0 
>         HID Device Descriptor:
>           bLength                 9
>           bDescriptorType        33
>           bcdHID               1.00
>           bCountryCode            0 Not supported
>           bNumDescriptors         1
>           bDescriptorType        34 Report
>           wDescriptorLength      48
>          Report Descriptors: 
>            ** UNAVAILABLE **
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x81  EP 1 IN
>         bmAttributes            3
>           Transfer Type            Interrupt
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0008  1x 8 bytes
>         bInterval              50
> Device Status:     0x0000
>   (Bus Powered)
> 
> Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Device Descriptor:
>   bLength                18
>   bDescriptorType         1
>   bcdUSB               1.10
>   bDeviceClass            9 Hub
>   bDeviceSubClass         0 Unused
>   bDeviceProtocol         0 Full speed (or root) hub
>   bMaxPacketSize0        64
>   idVendor           0x1d6b Linux Foundation
>   idProduct          0x0001 1.1 root hub
>   bcdDevice            2.06
>   iManufacturer           3 Linux 2.6.27-rc7-c7-c7temp-100hz-ch341 uhci_hcd
>   iProduct                2 UHCI Host Controller
>   iSerial                 1 0000:00:10.1
>   bNumConfigurations      1
>   Configuration Descriptor:
>     bLength                 9
>     bDescriptorType         2
>     wTotalLength           25
>     bNumInterfaces          1
>     bConfigurationValue     1
>     iConfiguration          0 
>     bmAttributes         0xe0
>       Self Powered
>       Remote Wakeup
>     MaxPower                0mA
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        0
>       bAlternateSetting       0
>       bNumEndpoints           1
>       bInterfaceClass         9 Hub
>       bInterfaceSubClass      0 Unused
>       bInterfaceProtocol      0 Full speed (or root) hub
>       iInterface              0 
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x81  EP 1 IN
>         bmAttributes            3
>           Transfer Type            Interrupt
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0002  1x 2 bytes
>         bInterval             255
> Hub Descriptor:
>   bLength               9
>   bDescriptorType      41
>   nNbrPorts             2
>   wHubCharacteristic 0x000a
>     No power switching (usb 1.0)
>     Per-port overcurrent protection
>   bPwrOn2PwrGood        1 * 2 milli seconds
>   bHubContrCurrent      0 milli Ampere
>   DeviceRemovable    0x00
>   PortPwrCtrlMask    0xff
>  Hub Port Status:
>    Port 1: 0000.0303 lowspeed power enable connect
>    Port 2: 0000.0100 power
> Device Status:     0x0003
>   Self Powered
>   Remote Wakeup Enabled
> 
> Bus 001 Device 005: ID 4348:5523 WinChipHead USB->RS 232 adapter with Prolifec PL 2303 chipset
> Device Descriptor:
>   bLength                18
>   bDescriptorType         1
>   bcdUSB               1.10
>   bDeviceClass          255 Vendor Specific Class
>   bDeviceSubClass         0 
>   bDeviceProtocol         0 
>   bMaxPacketSize0         8
>   idVendor           0x4348 WinChipHead
>   idProduct          0x5523 USB->RS 232 adapter with Prolifec PL 2303 chipset
>   bcdDevice            2.50
>   iManufacturer           0 
>   iProduct                2 USB-SER!
>   iSerial                 0 
>   bNumConfigurations      1
>   Configuration Descriptor:
>     bLength                 9
>     bDescriptorType         2
>     wTotalLength           39
>     bNumInterfaces          1
>     bConfigurationValue     1
>     iConfiguration          0 
>     bmAttributes         0x80
>       (Bus Powered)
>     MaxPower               78mA
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        0
>       bAlternateSetting       0
>       bNumEndpoints           3
>       bInterfaceClass       255 Vendor Specific Class
>       bInterfaceSubClass      1 
>       bInterfaceProtocol      2 
>       iInterface              0 
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x82  EP 2 IN
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0020  1x 32 bytes
>         bInterval               0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x02  EP 2 OUT
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0020  1x 32 bytes
>         bInterval               0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x81  EP 1 IN
>         bmAttributes            3
>           Transfer Type            Interrupt
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0008  1x 8 bytes
>         bInterval               1
> Device Status:     0x0000
>   (Bus Powered)
> 
> Bus 001 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Device Descriptor:
>   bLength                18
>   bDescriptorType         1
>   bcdUSB               1.10
>   bDeviceClass            9 Hub
>   bDeviceSubClass         0 Unused
>   bDeviceProtocol         0 Full speed (or root) hub
>   bMaxPacketSize0        64
>   idVendor           0x1d6b Linux Foundation
>   idProduct          0x0001 1.1 root hub
>   bcdDevice            2.06
>   iManufacturer           3 Linux 2.6.27-rc7-c7-c7temp-100hz-ch341 uhci_hcd
>   iProduct                2 UHCI Host Controller
>   iSerial                 1 0000:00:10.0
>   bNumConfigurations      1
>   Configuration Descriptor:
>     bLength                 9
>     bDescriptorType         2
>     wTotalLength           25
>     bNumInterfaces          1
>     bConfigurationValue     1
>     iConfiguration          0 
>     bmAttributes         0xe0
>       Self Powered
>       Remote Wakeup
>     MaxPower                0mA
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        0
>       bAlternateSetting       0
>       bNumEndpoints           1
>       bInterfaceClass         9 Hub
>       bInterfaceSubClass      0 Unused
>       bInterfaceProtocol      0 Full speed (or root) hub
>       iInterface              0 
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x81  EP 1 IN
>         bmAttributes            3
>           Transfer Type            Interrupt
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0002  1x 2 bytes
>         bInterval             255
> Hub Descriptor:
>   bLength               9
>   bDescriptorType      41
>   nNbrPorts             2
>   wHubCharacteristic 0x000a
>     No power switching (usb 1.0)
>     Per-port overcurrent protection
>   bPwrOn2PwrGood        1 * 2 milli seconds
>   bHubContrCurrent      0 milli Ampere
>   DeviceRemovable    0x00
>   PortPwrCtrlMask    0xff
>  Hub Port Status:
>    Port 1: 0000.0103 power enable connect
>    Port 2: 0000.0100 power
> Device Status:     0x0003
>   Self Powered
>   Remote Wakeup Enabled
> 
> 
> > But you do get this oops even without running that script, don't you?   
> 
> No, only with that script.

Is this still reproducible in mainline?

If not, is it reproducible with 2.6.27 final?

Rafael
