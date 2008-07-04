Return-Path: <linux-kernel-owner+w=401wt.eu-S1754123AbYGDTmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123AbYGDTmj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 15:42:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751865AbYGDTm1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 15:42:27 -0400
Received: from adsl-67-113-118-6.dsl.sndg02.pacbell.net ([67.113.118.6]:42223
	"EHLO multivac.one-eyed-alien.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751757AbYGDTm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 15:42:26 -0400
Date: Fri, 4 Jul 2008 12:42:07 -0700
From: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-usb@vger.kernel.org, gregkh@suse.de
Subject: Re: usb-storage: quirk around v1.11 firmware on Nikon D4
Message-ID: <20080704194207.GE24665@one-eyed-alien.net>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-usb@vger.kernel.org, gregkh@suse.de
References: <20080704193323.GA19712@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PGNNI9BzQDUtgA2J"
Content-Disposition: inline
In-Reply-To: <20080704193323.GA19712@redhat.com>
User-Agent: Mutt/1.4.2.3i
Organization: One Eyed Alien Networks
X-Copyright: (C) 2008 Matthew Dharm, all rights reserved.
X-Message-Flag: Get a real e-mail client.  http://www.mutt.org/
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (multivac.one-eyed-alien.net [127.0.0.1]); Fri, 04 Jul 2008 12:42:08 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PGNNI9BzQDUtgA2J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

NAK.

Two entries should not have overlapping version ranges, unless
configuration options are involved.

Why not just extend the range of the existing entry?

Matt

On Fri, Jul 04, 2008 at 03:33:23PM -0400, Dave Jones wrote:
> usb-storage: quirk around v1.11 firmware on Nikon D40
>=20
> https://bugzilla.redhat.com/show_bug.cgi?id=3D454028
> Just as in earlier firmware versions, we need to perform this
> quirk for the latest version too.
>=20
> Signed-off-by: Dave Jones <davej@redhat.com>
>=20
> diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unu=
sual_devs.h
> index 45fe366..cf03af1 100644
> --- a/drivers/usb/storage/unusual_devs.h
> +++ b/drivers/usb/storage/unusual_devs.h
> @@ -364,6 +364,13 @@ UNUSUAL_DEV(  0x04b0, 0x0411, 0x0100, 0x0110,
>  		US_SC_DEVICE, US_PR_DEVICE, NULL,
>  		US_FL_FIX_CAPACITY),
> =20
> +/* Reported by https://bugzilla.redhat.com/show_bug.cgi?id=3D454028 */
> +UNUSUAL_DEV(  0x04b0, 0x0413, 0x0110, 0x0111,
> +		"NIKON",
> +		"NIKON DSC D40",
> +		US_SC_DEVICE, US_PR_DEVICE, NULL,
> +		US_FL_FIX_CAPACITY),
> +
>  /* Reported by Ortwin Glueck <odi@odi.ch> */
>  UNUSUAL_DEV(  0x04b0, 0x0413, 0x0110, 0x0110,
>  		"NIKON",
>=20
>=20
> --=20
> http://www.codemonkey.org.uk
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

P:  How about "Web Designer"?
DP: I'd like a name that people won't laugh at.
					-- Pitr and Dust Puppy
User Friendly, 12/6/1997

--PGNNI9BzQDUtgA2J
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFIbn0PHL9iwnUZqnkRAoj0AKCr4FNedGUwFzLSPF43c2AfpHoi0wCfdkh8
BiOu5dsS59KEPprdf0sRIOc=
=fRWb
-----END PGP SIGNATURE-----

--PGNNI9BzQDUtgA2J--
