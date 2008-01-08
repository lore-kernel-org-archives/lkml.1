Return-Path: <linux-kernel-owner+w=401wt.eu-S1755353AbYAHTog@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353AbYAHTog (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 14:44:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750962AbYAHTo3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 14:44:29 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:44327 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750707AbYAHTo2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 14:44:28 -0500
Date: Tue, 8 Jan 2008 20:44:24 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: "raki john" <raki4652@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Crash in Kernel 2.6.22.1 after calling mmc_register_card
Message-ID: <20080108204424.19f4f414@poseidon.drzeus.cx>
In-Reply-To: <d2a348dd0801071531u5ecabd43i260639aae39b3ae@mail.gmail.com>
References: <d2a348dd0801071531u5ecabd43i260639aae39b3ae@mail.gmail.com>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_hera.drzeus.cx-1359-1199821466-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_hera.drzeus.cx-1359-1199821466-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 7 Jan 2008 15:31:32 -0800
"raki john" <raki4652@gmail.com> wrote:

> Hi All,
>=20
> Please CC me on responses.
>=20
> I am working on a SD/MMC Host driver .
>=20
> I am getting kerenl oops after mmc_register_card () is called.
> i working on  LINUX 2.6.22.1 kerenl.
>=20
> What might be the reason for this.
>=20

That's a rather central place for it to crash, so I'm doubtful it's a bug t=
here. I'd guess some kind of memory corruption (an all to easy mistake to m=
ake when writing a new driver). Are you using DMA for the controller? If so=
, try using PIO and see if it stops oopsing.

Rgds
Pierre

--=_hera.drzeus.cx-1359-1199821466-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)

iEYEARECAAYFAkeD0pgACgkQ7b8eESbyJLjGEwCg+numWOBJokAyOyy0Bv97e03D
SLsAoO/XJN9iHfAW/DZ1dujPUe9eoGd4
=rdbz
-----END PGP SIGNATURE-----

--=_hera.drzeus.cx-1359-1199821466-0001-2--
