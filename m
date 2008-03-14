Return-Path: <linux-kernel-owner+w=401wt.eu-S1755513AbYCNAvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513AbYCNAvw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 20:51:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752284AbYCNAvn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 20:51:43 -0400
Received: from adsl-67-113-118-6.dsl.sndg02.pacbell.net ([67.113.118.6]:60853
	"EHLO multivac.one-eyed-alien.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751998AbYCNAvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 20:51:42 -0400
Date: Thu, 13 Mar 2008 17:51:39 -0700
From: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
To: matthieu castet <castet.matthieu@free.fr>
Cc: linux-usb@vger.kernel.org,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]  mass storage : emulation of sat scsi_pass_thru with ATACB
Message-ID: <20080314005139.GP2820@one-eyed-alien.net>
Mail-Followup-To: matthieu castet <castet.matthieu@free.fr>,
	linux-usb@vger.kernel.org,
	Linux Kernel list <linux-kernel@vger.kernel.org>
References: <47D2CD95.9070701@free.fr> <20080308183125.GB2820@one-eyed-alien.net> <47D2F23A.4020103@free.fr> <20080308212148.GC2820@one-eyed-alien.net> <47D39E14.9050900@free.fr> <20080309184524.GF2820@one-eyed-alien.net> <47D459DA.20207@free.fr> <20080310012014.GG2820@one-eyed-alien.net> <47D99B01.1030709@free.fr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KM+e2hnYAO+MCJ5e"
Content-Disposition: inline
In-Reply-To: <47D99B01.1030709@free.fr>
User-Agent: Mutt/1.4.2.3i
Organization: One Eyed Alien Networks
X-Copyright: (C) 2008 Matthew Dharm, all rights reserved.
X-Message-Flag: Get a real e-mail client.  http://www.mutt.org/
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (multivac.one-eyed-alien.net [127.0.0.1]); Thu, 13 Mar 2008 17:51:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KM+e2hnYAO+MCJ5e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 13, 2008 at 10:22:09PM +0100, matthieu castet wrote:
> Matthew Dharm wrote:
> >On Sun, Mar 09, 2008 at 10:42:50PM +0100, matthieu castet wrote:
> >>Hi
> >>
> >>here an update version of the patch
> >
> >We're getting very close here.

> +		unsigned char sk, asc, ascq;

> +		sk =3D RECOVERED_ERROR;
> +		asc =3D 0; /* ATA PASS THROUGH INFORMATION AVAILABLE */
> +		ascq =3D 0x1D;

> +		/* XXX we should generate sk, asc, ascq from status and error
> +		 * regs
> +		 * (see 11.1 Error translation ? ATA device error to SCSI error map)
> +		 * and ata_to_sense_error from libata.
> +		 */
> +		sb[1] =3D sk;
> +		sb[2] =3D asc;
> +		sb[3] =3D ascq;

I may have missed this in an earlier patch, but why to you declare and use
these 3 variables like this?  Seems odd and confusing to me....

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

It was a new hope.
					-- Dust Puppy
User Friendly, 12/25/1998

--KM+e2hnYAO+MCJ5e
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFH2cwbHL9iwnUZqnkRAvziAJwLry8RhkENb63c4IoEj6guCwd4fQCgiB6C
Zsmi0Md6R2OFnWGbJUOf+LY=
=Q0FQ
-----END PGP SIGNATURE-----

--KM+e2hnYAO+MCJ5e--
