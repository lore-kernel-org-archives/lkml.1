Return-Path: <linux-kernel-owner+w=401wt.eu-S1756250AbYDRHKH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756250AbYDRHKH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 03:10:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757381AbYDRHJs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 03:09:48 -0400
Received: from mail1.physik.fu-berlin.de ([160.45.35.12]:59568 "EHLO
	mail1.physik.fu-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756251AbYDRHJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 03:09:46 -0400
X-Greylist: delayed 2303 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Apr 2008 03:09:46 EDT
Subject: Re: [PATCH] usb-serial: option: Don't match Huawei driver CD images
From: Michael Karcher <karcher@physik.fu-berlin.de>
To: Greg KH <greg@kroah.com>
Cc: smurf@smurf.noris.de, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
In-Reply-To: <1208498494.14194.28.camel@hermes2.karcher.local>
References: <1208472569.14194.5.camel@hermes2.karcher.local>
	 <20080418032405.GB8754@kroah.com>
	 <1208498494.14194.28.camel@hermes2.karcher.local>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-3FzA2CY29+01oMGjRwNU"
Organization: Freie =?ISO-8859-1?Q?Universit=E4t?= Berlin
Date: Fri, 18 Apr 2008 08:30:41 +0200
Message-Id: <1208500241.4749.3.camel@hermes2.karcher.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
X-HELO-Warning: Remote host 89.247.224.62 (i59f7e03e.versanet.de) incorrectly presented itself as [192.168.0.121]
X-ZEDV-Virus-Scanned: No viruses found. [ClamAV 0.92/6817/Fri Apr 18 03:15:07 2008]
X-ZEDV-Spam-Level: ----
X-ZEDV-Spam-Checker-Version: SpamAssassin 3.2.3 (2007-08-08) on zs01.physik.fu-berlin.de
X-ZEDV-Spam-Status: No, score=-4.4 required=5.0 tests=ALL_TRUSTED,BAYES_00 autolearn=ham version=3.2.3
X-ZEDV-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
X-Scan-Signature: b9e1499828b6c04d20a5e4d082cc4c43
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-3FzA2CY29+01oMGjRwNU
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


Am Freitag, den 18.04.2008, 08:01 +0200 schrieb Michael Karcher:
> Am Donnerstag, den 17.04.2008, 20:24 -0700 schrieb Greg KH:
> > What is this patch against?  We have a change that went into 2.6.25
> > after 2.6.25-rc9 that should make this patch not be needed.
> The patch is developed against 2.6.25-rc8 + some git patches, but I have
> forward-ported it to current git.
>=20
> I *guess* you are talking about commit aad8a278 (USB: support more
> Huawei data card product IDs), as I could not find .
insert "any other patches applying to usb/usb-serial that might be
involved" before the full stop.
[...]

> > Can you try that release and verify this?
> I will try with a current git kernel without my patch and report back,
> but I will be surprised if the problem described above is gone. System
> is currently compiling.
Kernel compiled & booted. Won't work without the patch.

Relevant dmesg and lsusb -v output follows.

Regards,
  Michael Karcher

dmesg:
usb 2-1: new full speed USB device using uhci_hcd and address 2
usb 2-1: configuration #1 chosen from 1 choice
usbcore: registered new interface driver usbserial
drivers/usb/serial/usb-serial.c: USB Serial support registered for generic
usbcore: registered new interface driver usbserial_generic
drivers/usb/serial/usb-serial.c: USB Serial Driver core
drivers/usb/serial/usb-serial.c: USB Serial support registered for GSM mode=
m (1-port)
option 2-1:1.0: GSM modem (1-port) converter detected
usb 2-1: GSM modem (1-port) converter now attached to ttyUSB0
usbcore: registered new interface driver option
drivers/usb/serial/option.c: USB Driver for GSM modems: v0.7.1
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.

lsusb -v:
Bus 002 Device 002: ID 12d1:1001 Huawei Technologies Co., Ltd. E620 USB Mod=
em
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0=20
  bDeviceProtocol         0=20
  bMaxPacketSize0        64
  idVendor           0x12d1 Huawei Technologies Co., Ltd.
  idProduct          0x1001 E620 USB Modem
  bcdDevice            0.00
  iManufacturer           1 =EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=
=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD
  iProduct                2 HUAWEI Mobile
  iSerial                 1 =EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=
=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           32
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0=20
    bmAttributes         0xa0
      (Bus Powered)
      Remote Wakeup
    MaxPower              500mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass         8 Mass Storage
      bInterfaceSubClass      6 SCSI
      bInterfaceProtocol     80 Bulk (Zip)
      iInterface              0=20
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
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



--=-3FzA2CY29+01oMGjRwNU
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Dies ist ein digital signierter Nachrichtenteil

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBICEARzhek2R7EicoRAjfTAJ4ka7KgAX/ldIP36SjSHrN/pa8y0gCePO4C
CXNysWhWmxB1wsp6bu+9NMg=
=6wSP
-----END PGP SIGNATURE-----

--=-3FzA2CY29+01oMGjRwNU--

