Return-Path: <linux-kernel-owner+w=401wt.eu-S1752014AbZAZLP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014AbZAZLP3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 06:15:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751139AbZAZLPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 06:15:20 -0500
Received: from xc.sipsolutions.net ([83.246.72.84]:32886 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbZAZLPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 06:15:19 -0500
Subject: Re: since 2.6.29-rc: apple infrared keeps system awake?
From: Johannes Berg <johannes@sipsolutions.net>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Matthew Garrett <mjg@redhat.com>, Samuel Ortiz <sameo@openedhand.com>
In-Reply-To: <alpine.LRH.1.10.0901261151320.26411@twin.jikos.cz>
References: <1232635779.4224.12.camel@johannes.local>
	 <alpine.LRH.1.10.0901261151320.26411@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-jP499EsATbYw2DXNP4lo"
Date: Mon, 26 Jan 2009 12:15:13 +0100
Message-Id: <1232968513.20525.1.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-jP499EsATbYw2DXNP4lo
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-01-26 at 11:52 +0100, Jiri Kosina wrote:
> On Thu, 22 Jan 2009, Johannes Berg wrote:
>=20
> > Ever since 2.6.29-rc, I see this in powertop on my macbook5,1:
> > Top causes for wakeups:
> >   24.1% ( 27.8)   USB device usb1 : OHCI Host Controller (Linux 2.6.29-=
rc2-wl-di
> >   21.5% ( 24.8)       <interrupt> : ohci_hcd:usb1=20
> >   14.5% ( 16.7)   USB device  1-5 : IR Receiver (Apple Computer, Inc.)=20
> > which is way way more than what it used to be, I never saw the IR=20
> > receiver before. I could bisect, but wondered if somebody had seen this=
=20
> > before?
>=20
> What driver is bound to this device? (what is the product ID?).

None, oddly, it seems. At least listing input devices doesn't seem to
show it.

Bus 003 Device 002: ID 05ac:8242 Apple, Inc.=20
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0=20
  bDeviceProtocol         0=20
  bMaxPacketSize0         8
  idVendor           0x05ac Apple, Inc.
  idProduct          0x8242=20
  bcdDevice            0.16
  iManufacturer           1 Apple Computer, Inc.
  iProduct                2 IR Receiver
  iSerial                 0=20
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           34
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          1 Apple Computer, Inc.
    bmAttributes         0xa0
      (Bus Powered)
      Remote Wakeup
    MaxPower              100mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         3 Human Interface Device
      bInterfaceSubClass      0 No Subclass
      bInterfaceProtocol      0 None
      iInterface              0=20
        HID Device Descriptor:
          bLength                 9
          bDescriptorType        33
          bcdHID               1.11
          bCountryCode            0 Not supported
          bNumDescriptors         1
          bDescriptorType        34 Report
          wDescriptorLength      42
         Report Descriptors:=20
           ** UNAVAILABLE **
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0008  1x 8 bytes
        bInterval              10
Device Status:     0x0000
  (Bus Powered)


johannes

--=-jP499EsATbYw2DXNP4lo
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJfZs+AAoJEKVg1VMiehFYHBkQAKfpol94zAW2wsl5wux/HzJr
4ljrmj8Fe8IKMWihqBqK6A7dBpK4QUhW6U4dnwggqkayAoGSPYeophZmLh4uCRqS
zT9F/qn1YI27B0w4lxvqprxleqUlE4Dm8ZlYOkPDhUKXKOz1FC6kvZCuUrbXV6A4
ovmvhyTUPmOTm0ZXLf9TPU/0A23UPxYZqZPFw+E9HaRSIo4KVg+vm6R9BEvJwIep
EOhXufqfsaZlP8B1ctdFc22zGJN9uIJC9sc5eNRHc5Tzg1d0UFXgjSNYpBbOxf8a
ODq0iZWCQD0HMZ2aGIhGoIQ0IkinllmUemO68SzyIhmtOssSWkin8MEMlXkZc1bi
G5Pt0wosBMOmvAjvKzR7q30hxFuigtdJeXJ5UYvIyFg0G0YRc4VJnMs+UHLuL2vY
NdKnmfFYQRXFB2JVM4/jqWxTo1SqpeCFObPk4xBKikSawNQ/j9UpNGhSj0alLpxI
3BSrv3p/TueAovm3GMm6kwLNgxuOGapb0wKy2YDeF64xoWkigVeaiecrj6mU300K
NsQpG/OZae0/7yPlWLDI5XjP88b9sMz2kXbmW/sVp/KhVoLyAsq9QsyZUknnk2dL
BWkICYhUhbaHeEDBk5TSIW0qcRXQ6Jfvpjw8nGCahDq6JvSnuC1pvVhAkwpJtZYT
rFM/2d3IwokYv3HmEsb5
=tkuk
-----END PGP SIGNATURE-----

--=-jP499EsATbYw2DXNP4lo--

