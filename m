Return-Path: <linux-kernel-owner+w=401wt.eu-S1763307AbZAUIng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763307AbZAUIng (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 03:43:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754947AbZAUIn1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 03:43:27 -0500
Received: from mxpdbe2.wincor-nixdorf.com ([80.154.98.130]:49204 "EHLO
	mxpdbe2.wincor-nixdorf.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1749667AbZAUIn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 03:43:26 -0500
Message-ID: <4976DF6F.2010509@wincor-nixdorf.com>
Date: Wed, 21 Jan 2009 09:40:15 +0100
From: Niels de Vos <niels.devos@wincor-nixdorf.com>
Organization: Wincor Nixdorf International
User-Agent: Thunderbird 2.0.0.19 (X11/20090107)
MIME-Version: 1.0
To: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
CC: Michael Bramer <michael@debsupport.de>, linux-kernel@vger.kernel.org,
       linux-serial@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] drivers/serial/8250_pci.c (add support for '8-port RS-232
 MIC-3620 from advantech'
References: <20090118135359.GA3087@deb-support.de> <20090119145101.GA16732@ports.donpac.ru> <20090119235122.GE21026@deb-support.de> <20090120151216.GB16732@ports.donpac.ru>   <20090121075212.GA18485@deb-support.de> <4976DA3D.7050201@teltonika.lt>
In-Reply-To: <4976DA3D.7050201@teltonika.lt>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig8776343EEEEB49F777443A99"
X-OriginalArrivalTime: 21 Jan 2009 08:43:15.0747 (UTC) FILETIME=[4D3D0F30:01C97BA4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig8776343EEEEB49F777443A99
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Paulius Zaleckas wrote:
> Michael Bramer wrote:
=2E..
>> This Patch add the device information for the=20
>> MIC-3620 8-port RS-232 cPCI card from Advantech Co. Ltd.
>>
>> Signed-off-by: Michael Bramer <grisu@deb-support.de>
>> --- a/drivers/serial/8250_pci.c
>> +++ b/drivers/serial/8250_pci.c
>> @@ -31,6 +31,7 @@
>>  #include "8250.h"
>>
>>  #undef SERIAL_DEBUG_PCI
>> +#define SERIAL_DEBUG_PCI
>=20
> NAK.
>=20
>>  /*
>>   * init function returns:
>> @@ -768,6 +769,8 @@
>>  #define PCI_SUBDEVICE_ID_OCTPRO422     0x0208
>>  #define PCI_SUBDEVICE_ID_POCTAL232     0x0308
>>  #define PCI_SUBDEVICE_ID_POCTAL422     0x0408
>> +#define PCI_VENDOR_ID_ADVANTECH         0x13fe
>> +#define PCI_DEVICE_ID_ADVANTECH_PCI3620 0x3620

Should this not be in <include/linux/pci_ids.h>?


>>  /*
>>   * Master list of serial port init/setup/exit quirks.
>> @@ -2041,6 +2054,9 @@
>>  #endif
>>
>>  static struct pci_device_id serial_pci_tbl[] =3D {
>> +       {       PCI_VENDOR_ID_ADVANTECH, PCI_DEVICE_ID_ADVANTECH_PCI36=
20,
>> +               0x3620, PCI_ANY_ID, 0, 0,

Why not use PCI_VENDOR_ID_ADVANTECH as PCI_SUBVENDOR_ID too?

Cheers,
Niels


--------------enig8776343EEEEB49F777443A99
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFJdt9w5KAkGQPO/QoRAp07AKDVJt15fdir28NtOvYinxuoBmLldACg4KbE
I+958CFuS74leypDsmiOq0s=
=Km+1
-----END PGP SIGNATURE-----

--------------enig8776343EEEEB49F777443A99--
