Return-Path: <linux-kernel-owner+w=401wt.eu-S1946204AbXBIIab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946204AbXBIIab (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 03:30:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946213AbXBIIab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 03:30:31 -0500
Received: from posthamster.phnxsoft.com ([195.227.45.4]:4080 "EHLO
	posthamster.phnxsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946204AbXBIIaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 03:30:30 -0500
Message-ID: <45CC3109.1010502@imap.cc>
Date: Fri, 09 Feb 2007 09:30:01 +0100
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de-AT; rv:1.8.0.9) Gecko/20061211 SeaMonkey/1.0.7 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: Jiri Kosina <jikos@jikos.cz>
CC: Jeff Garzik <jeff@garzik.org>, Greg KH <greg@kroah.com>, hjlipp@web.de,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: gigaset build broken on current linux-2.6.git
References: <45CBA41D.3000406@garzik.org> <Pine.LNX.4.64.0702082344100.25686@twin.jikos.cz>
In-Reply-To: <Pine.LNX.4.64.0702082344100.25686@twin.jikos.cz>
X-Enigmail-Version: 0.94.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig8187271FE10BEF0D8224ED7C"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig8187271FE10BEF0D8224ED7C
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Jiri Kosina schrieb:
> On Thu, 8 Feb 2007, Jeff Garzik wrote:
>=20
>> [jgarzik@pretzel linux-2.6]$ make -sj4
>>   CHK     include/linux/version.h
>>   CHK     include/linux/utsrelease.h
>>   CHK     include/linux/compile.h
>> drivers/isdn/gigaset/bas-gigaset.c: In function 'dump_urb':
>> drivers/isdn/gigaset/bas-gigaset.c:258: error: 'struct urb' has no mem=
ber
>> named 'bandwidth'
>=20
> ISDN: gigaset - remove forgotten urb->bandwidth reference
>=20
> Recent changes in usbcore removed the bandwidth field from struct urb.
> Remove the forgotten occurence in bas-gigaset.c
>=20
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Tilman Schmidt <tilman@imap.cc>

Use this or one of the two identical patches I already submitted for that=
=2E

> ---
>=20
>  drivers/isdn/gigaset/bas-gigaset.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/isdn/gigaset/bas-gigaset.c b/drivers/isdn/gigaset/=
bas-gigaset.c
> index b5e7f9c..63e51dd 100644
> --- a/drivers/isdn/gigaset/bas-gigaset.c
> +++ b/drivers/isdn/gigaset/bas-gigaset.c
> @@ -257,10 +257,10 @@ static inline void dump_urb(enum debuglevel level=
, const char *tag,
>  			urb->transfer_flags);
>  		gig_dbg(level,
>  			"  transfer_buffer=3D0x%08lx[%d], actual_length=3D%d, "
> -			"bandwidth=3D%d, setup_packet=3D0x%08lx,",
> +			"setup_packet=3D0x%08lx,",
>  			(unsigned long) urb->transfer_buffer,
>  			urb->transfer_buffer_length, urb->actual_length,
> -			urb->bandwidth, (unsigned long) urb->setup_packet);
> +			(unsigned long) urb->setup_packet);
>  		gig_dbg(level,
>  			"  start_frame=3D%d, number_of_packets=3D%d, interval=3D%d, "
>  			"error_count=3D%d,",
>=20


--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig8187271FE10BEF0D8224ED7C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.4 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFFzDEQMdB4Whm86/kRAjt+AJ4yRffYH/n7LcEeQkW1UbwX5G/gbQCfXGS8
M7oepQqf4kSpmPE916Odrus=
=E/4W
-----END PGP SIGNATURE-----

--------------enig8187271FE10BEF0D8224ED7C--
