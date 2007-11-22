Return-Path: <linux-kernel-owner+w=401wt.eu-S1752680AbXKVKQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680AbXKVKQv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 05:16:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751506AbXKVKQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 05:16:42 -0500
Received: from partizan.velesys.com ([213.184.230.195]:64437 "EHLO
	partizan.velesys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbXKVKQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 05:16:41 -0500
Date: Thu, 22 Nov 2007 12:17:50 +0200
From: "Kirill A. Shutemov" <k.shutemov@velesys.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
Subject: Re: 2.6.24-rc3-mm1: usb mouse doesn't work
Message-ID: <20071122101750.GC7085@localhost.localdomain>
References: <20071120204525.ff27ac98.akpm@linux-foundation.org> <20071121182346.GA4280@localhost.localdomain> <20071121142239.bff7206b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Bu8it7iiRSEf40bY"
Content-Disposition: inline
In-Reply-To: <20071121142239.bff7206b.akpm@linux-foundation.org>
X-Operating-System: ALT Linux Sisyphus (20070101) (Kernel 2.6.24-kas-alt1)
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--Bu8it7iiRSEf40bY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On [Wed, 21.11.2007 14:22], Andrew Morton wrote:
> On Wed, 21 Nov 2007 20:23:46 +0200
> "Kirill A. Shutemov" <k.shutemov@velesys.com> wrote:
>=20
> > USB mouse(Logitech M-BT58) doesn't work. TouchPad works.
> > dmesg after rmmod usbcore && modprobe uhci_hcd:
> >=20
> > usbcore: registered new interface driver usbfs
> > usbcore: registered new interface driver hub
> > usbcore: registered new device driver usb
> > USB Universal Host Controller Interface driver v3.0
> > ACPI: PCI Interrupt 0000:00:1d.0[A] -> Link [LNKE] -> GSI 10 (level, lo=
w)
> > -> IRQ 10
> > PCI: Setting latency timer of device 0000:00:1d.0 to 64
> > uhci_hcd 0000:00:1d.0: UHCI Host Controller
> > uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
> > uhci_hcd 0000:00:1d.0: irq 10, io base 0x0000bf80
> > usb usb1: configuration #1 chosen from 1 choice
> > hub 1-0:1.0: USB hub found
> > hub 1-0:1.0: 2 ports detected
> > usb usb1: new device found, idVendor=3D0000, idProduct=3D0000
> > usb usb1: new device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
> > usb usb1: Product: UHCI Host Controller
> > usb usb1: Manufacturer: Linux 2.6.24-kas-alt1 uhci_hcd
> > usb usb1: SerialNumber: 0000:00:1d.0
> > ACPI: PCI Interrupt 0000:00:1d.1[B] -> Link [LNKF] -> GSI 11 (level, lo=
w)
> > -> IRQ 11
> > PCI: Setting latency timer of device 0000:00:1d.1 to 64
> > uhci_hcd 0000:00:1d.1: UHCI Host Controller
> > uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
> > uhci_hcd 0000:00:1d.1: irq 11, io base 0x0000bf60
> > usb usb2: configuration #1 chosen from 1 choice
> > hub 2-0:1.0: USB hub found
> > hub 2-0:1.0: 2 ports detected
> > usb usb2: new device found, idVendor=3D0000, idProduct=3D0000
> > usb usb2: new device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
> > usb usb2: Product: UHCI Host Controller
> > usb usb2: Manufacturer: Linux 2.6.24-kas-alt1 uhci_hcd
> > usb usb2: SerialNumber: 0000:00:1d.1
> > ACPI: PCI Interrupt 0000:00:1d.2[C] -> Link [LNKG] -> GSI 9 (level, low)
> > -> IRQ 9
> > PCI: Setting latency timer of device 0000:00:1d.2 to 64
> > uhci_hcd 0000:00:1d.2: UHCI Host Controller
> > uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 3
> > uhci_hcd 0000:00:1d.2: irq 9, io base 0x0000bf40
> > usb usb3: configuration #1 chosen from 1 choice
> > hub 3-0:1.0: USB hub found
> > hub 3-0:1.0: 2 ports detected
> > usb usb3: new device found, idVendor=3D0000, idProduct=3D0000
> > usb usb3: new device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
> > usb usb3: Product: UHCI Host Controller
> > usb usb3: Manufacturer: Linux 2.6.24-kas-alt1 uhci_hcd
> > usb usb3: SerialNumber: 0000:00:1d.2
> > ACPI: PCI Interrupt 0000:00:1d.3[D] -> Link [LNKH] -> GSI 7 (level, low)
> > -> IRQ 7
> > PCI: Setting latency timer of device 0000:00:1d.3 to 64
> > uhci_hcd 0000:00:1d.3: UHCI Host Controller
> > uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 4
> > uhci_hcd 0000:00:1d.3: irq 7, io base 0x0000bf20
> > usb usb4: configuration #1 chosen from 1 choice
> > hub 4-0:1.0: USB hub found
> > hub 4-0:1.0: 2 ports detected
> > usb usb4: new device found, idVendor=3D0000, idProduct=3D0000
> > usb usb4: new device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
> > usb usb4: Product: UHCI Host Controller
> > usb usb4: Manufacturer: Linux 2.6.24-kas-alt1 uhci_hcd
> > usb usb4: SerialNumber: 0000:00:1d.3
> > uhci_hcd 0000:00:1d.3: FGR not stopped yet!
> >=20
>=20
> I've had some strangenesses with USB lately.  Sometimes running `lsusb'
> makes the USB system notice a newly attached device.

No. But I have new messages in dmesg:

uhci_hcd 0000:00:1d.3: FGR not stopped yet!
uhci_hcd 0000:00:1d.2: FGR not stopped yet!
uhci_hcd 0000:00:1d.1: FGR not stopped yet!
uhci_hcd 0000:00:1d.0: FGR not stopped yet!


> Is that "FGR not stopped yet!" messgae new behaviour?

It is a new message since 2.6.24-rc3. I have never try -mm tree before.

--=20
Regards,  Kirill A. Shutemov
 + Belarus, Minsk
 + Velesys LLC, http://www.velesys.com/
 + ALT Linux Team, http://www.altlinux.com/

--Bu8it7iiRSEf40bY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHRVdObWYnhzC5v6oRAsrHAJ4z7KJu0aD14XrmjayHaxhtqBxj5gCeOwQx
p4+EUtLK7rgLNJHwKPYLOks=
=mi+k
-----END PGP SIGNATURE-----

--Bu8it7iiRSEf40bY--
