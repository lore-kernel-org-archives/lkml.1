Return-Path: <linux-kernel-owner+w=401wt.eu-S1754446AbZC2RX2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446AbZC2RX2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 13:23:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751436AbZC2RXS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 13:23:18 -0400
Received: from mta-1.ms.rz.RWTH-Aachen.DE ([134.130.7.72]:48131 "EHLO
	mta-1.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751390AbZC2RXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 13:23:18 -0400
MIME-version: 1.0
X-IronPort-AV: E=Sophos;i="4.38,442,1233529200";   d="asc'?scan'208";a="6432307"
Message-id: <49CFAE83.5080700@archlinux.org>
Date: Sun, 29 Mar 2009 19:23:15 +0200
From: =?ISO-8859-15?Q?Thomas_B=E4chler?= <thomas@archlinux.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090319)
To: Arjan van de Ven <arjan@infradead.org>
Cc: =?ISO-8859-15?Q?Thomas_B=E4chler?= <thomas@archlinux.org>,
       linux-kernel@vger.kernel.org
Subject: Re: fastboot/async and initramfs: How am I supposed to know when
 devices are finished initializing?
References: <49CF9BA1.5030400@archlinux.org>
 <20090329091148.16a618bf@infradead.org> <49CFA2CC.9080506@archlinux.org>
 <20090329094220.4e80c267@infradead.org>
In-reply-to: <20090329094220.4e80c267@infradead.org>
X-Enigmail-Version: 0.95.6
Content-type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary=------------enigBE22C70BD7AB19BA1176C1A9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigBE22C70BD7AB19BA1176C1A9
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: quoted-printable

Arjan van de Ven schrieb:
>> Thanks, I will integrate that into our initramfs. Will that also work =

>> for USB mass storage (which was already problematic with older
>> kernels, you load the module you don't know how long it takes until
>> the sdX devices are created)?
>=20
> in part.
>=20
> The problem with USB probing is that devices come online whenever they
> feel like it; there is no way to wait for that.

Yes, that is a problem when trying to make bootable USB pen drives.

>> Can I load that module before loading the actual SCSI/SATA/PATA
>> driver?
>=20
> it's the loading of the driver that causes the wait. Not the act
> of having the driver loaded.
>=20
> so the way to wait for things to settle is to load the driver...
>=20
> ... I take it the answer to your question is "no". Yes you can load it
> earlier, but no it has no effect. You can however load/unload it
> multiple times.

I understand the logic now, works as expected on my machine. Many thanks =

for your quick help.


--------------enigBE22C70BD7AB19BA1176C1A9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEAREIAAYFAknProMACgkQEda5KzHP/VCDLQCeLv3gQ7vapgUfdgaTqDheJSTF
qssAn0q0Cdh7eCGv0qxIcBTYWa4hOoCa
=5DlV
-----END PGP SIGNATURE-----

--------------enigBE22C70BD7AB19BA1176C1A9--
