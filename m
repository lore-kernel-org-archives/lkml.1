Return-Path: <linux-kernel-owner+w=401wt.eu-S1758257AbYGBUlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758257AbYGBUlS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 16:41:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753998AbYGBUlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 16:41:06 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:23174 "EHLO
	pd3mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753938AbYGBUlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 16:41:05 -0400
Date: Wed, 02 Jul 2008 13:40:57 -0700
From: Adam Williamson <awilliamson@mandriva.com>
Subject: Re: [Bug #10868] Oops on loading ipaq module since 2.6.26,
	prevents use of device
In-reply-to: <200806301509.09013.oliver@neukum.org>
To: Oliver Neukum <oliver@neukum.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Adrian Bunk <bunk@kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@redhat.com>, bugme-daemon@bugzilla.kernel.org
Message-id: <1215031257.6054.201.camel@lenovo.local.net>
Organization: Mandriva
MIME-version: 1.0
X-Mailer: Evolution 2.22.2-3mdv2009.0
Content-type: multipart/mixed; boundary="=-Cd8mhDVOn3ETUxeHH0p2"
References: <RzbtSgMztjP.A.jRD._spXIB@albercik>
 <200806251741.23589.oliver@neukum.org>
 <1214594934.6054.117.camel@lenovo.local.net>
 <200806301509.09013.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Cd8mhDVOn3ETUxeHH0p2
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Mon, 2008-06-30 at 15:09 +0200, Oliver Neukum wrote:
> Am Freitag 27 Juni 2008 21:28:54 schrieb Adam Williamson:
> > On Wed, 2008-06-25 at 17:41 +0200, Oliver Neukum wrote:
> > > Am Mittwoch 25 Juni 2008 04:05:13 schrieb Adam Williamson:
> > > > On Mon, 2008-06-23 at 20:41 +0200, Oliver Neukum wrote:
> > > > 
> > > > > It is the module option "debug" for usb-serial.
> > > > 
> > > > OK, here you go:
> > > 
> > > Please also set the debug module parameter for the ipaq module.
> > 
> > OK.
> 
> Your device is considered to have two ports but not enough endpoints.
> Please provide the output of "lsusb -v"

Here's the lsusb stanza for the device.
-- 
adamw

--=-Cd8mhDVOn3ETUxeHH0p2
Content-Disposition: attachment; filename=26_lsusb.txt
Content-Type: text/plain; name=26_lsusb.txt; charset=utf-8
Content-Transfer-Encoding: 7bit

Bus 003 Device 002: ID 03f0:1016 Hewlett-Packard Jornada 548 / iPAQ HW6515 Pocket PC 
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.00
  bDeviceClass          255 Vendor Specific Class
  bDeviceSubClass       255 Vendor Specific Subclass
  bDeviceProtocol       255 Vendor Specific Protocol
  bMaxPacketSize0        16
  idVendor           0x03f0 Hewlett-Packard
  idProduct          0x1016 Jornada 548 / iPAQ HW6515 Pocket PC 
  bcdDevice            0.00
  iManufacturer           0 
  iProduct                0 
  iSerial                 0 
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           32
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0x80
      (Bus Powered)
    MaxPower               50mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x04  EP 4 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               0
Device Status:     0x0000
  (Bus Powered)
--=-Cd8mhDVOn3ETUxeHH0p2--

