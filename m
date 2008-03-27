Return-Path: <linux-kernel-owner+w=401wt.eu-S1757425AbYC0Gng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757425AbYC0Gng (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 02:43:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754350AbYC0Gn1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 02:43:27 -0400
Received: from hapkido.dreamhost.com ([66.33.216.122]:58422 "EHLO
	hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863AbYC0Gn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 02:43:26 -0400
Message-ID: <47EB41B1.5070901@greyfade.us>
Date: Wed, 26 Mar 2008 23:41:53 -0700
From: Charles Banas <greywolf@greyfade.us>
User-Agent: Thunderbird 2.0.0.12 (X11/20080321)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oliver@neukum.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: [PATCH] usb-serial: fix regression in Visor/Palm OS module for
 kernels >= 2.6.24
References: <20080327001557.GA16176@enigma.swatter.net> <Pine.LNX.4.44L0.0803262252420.21714-100000@netrider.rowland.org> <20080327050725.GC11011@enigma.swatter.net>
In-Reply-To: <20080327050725.GC11011@enigma.swatter.net>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/mixed;
 boundary="------------040304040602000305080208"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040304040602000305080208
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Brad Sawatzky wrote:
| I only have one PalmOS USB device and can only provide data for that unit.
| As mentioned in the initial post I think it is very suggestive that
there is
| a kernel bug report saying that both a Treo90 and a Treo750p that
exhibited
| identical symptoms.  I'd bet a beer that that the kernel also reports 3
| bulk out endpoints for those devices, but I can't prove it.
|

Attached is the lspci -v output for my Treo 90. I see two bulk out
endpoints.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFH60Gxi1yS1BuzIvgRAuh7AKCR/JXrulXICE33R8pXKvie8VZIbwCeOZa1
zjFCIEC3DaOTHPplI0iWAfg=
=c6GN
-----END PGP SIGNATURE-----

--------------040304040602000305080208
Content-Type: text/plain;
 name="treo90"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="treo90"


Bus 002 Device 003: ID 082d:0200 Handspring 
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0         8
  idVendor           0x082d Handspring
  idProduct          0x0200 
  bcdDevice            1.00
  iManufacturer           0 
  iProduct                0 
  iSerial                 0 
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           46
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xa0
      (Bus Powered)
      Remote Wakeup
    MaxPower                2mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           4
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0 
      bInterfaceProtocol      0 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x01  EP 1 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0008  1x 8 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0008  1x 8 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x03  EP 3 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x84  EP 4 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               0
Device Status:     0x0001
  Self Powered

--------------040304040602000305080208
Content-Type: application/octet-stream;
 name="treo90.sig"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="treo90.sig"

iD8DBQBH60Gxi1yS1BuzIvgRAnI3AJ93ULQeh7JL0e/CvcHLsOhohY2zXwCglFMJFdXdz5jo
lHVJYZ7A0E8niRk=
--------------040304040602000305080208--
