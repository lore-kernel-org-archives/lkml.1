Return-Path: <linux-kernel-owner+w=401wt.eu-S1766850AbXDSQYk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766850AbXDSQYk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 12:24:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766852AbXDSQYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 12:24:40 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:40306 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1766850AbXDSQYj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 12:24:39 -0400
Message-ID: <462797EE.2050808@drzeus.cx>
Date: Thu, 19 Apr 2007 18:25:18 +0200
From: Pierre Ossman <drzeus@drzeus.cx>
User-Agent: Thunderbird 2.0.0.0 (X11/20070414)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_hera.drzeus.cx-14213-1176999875-0001-2"
To: Madhusudhan c <cr.madhusudhan@gmail.com>
CC: linux-kernel@vger.kernel.org, philipl@overt.org
Subject: Re: MMCv4 support (8-bit support missing)
References: <ff1613620704162359w62df9e0ao6c43215a767bd706@mail.gmail.com>	 <4625DAFC.4000208@drzeus.cx>	 <ff1613620704180453t69585e21h5c31a4fe908d0aac@mail.gmail.com>	 <46262953.3040801@drzeus.cx> <ff1613620704190704n2cf37c9dv43536bb8fc0d4c79@mail.gmail.com>
In-Reply-To: <ff1613620704190704n2cf37c9dv43536bb8fc0d4c79@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_hera.drzeus.cx-14213-1176999875-0001-2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Madhusudhan c wrote:
>=20
> The bus test procedure from this patch can be adopted to the MMCv4
> support in the MMC core with small changes to do bus testing procedure
> only if the host sets the capability to support 8-bit. That way we
> dont break the legacy code. What do you think?
>=20

Until 8-bit SD shows up, at which point things go to hell again.

You need to present a valid case for why we need this bus testing stuff. =
The
spec never requires it, and neither does any cards. So this is just crud =
that we
know causes problems and doesn't give us anything back.

Rgds
Pierre



--=_hera.drzeus.cx-14213-1176999875-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFGJ5fu7b8eESbyJLgRAoEQAJ4qScn3pmuuq/IfnlAUs3sURl2p2QCg1OeQ
+7z69l8R2DthjmiyDqoalxM=
=tsWC
-----END PGP SIGNATURE-----

--=_hera.drzeus.cx-14213-1176999875-0001-2--
