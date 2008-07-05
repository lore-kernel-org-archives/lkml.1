Return-Path: <linux-kernel-owner+w=401wt.eu-S1756133AbYGEXYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133AbYGEXYu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 19:24:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753081AbYGEXYn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 19:24:43 -0400
Received: from server.drzeus.cx ([85.8.24.28]:44070 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752614AbYGEXYm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 19:24:42 -0400
Date: Sun, 6 Jul 2008 01:24:35 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Sascha Sommer <saschasommer@freenet.de>
Cc: sdricohcs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: Status of Ricoh Bay1Controller driver?
Message-ID: <20080706012435.016358d6@mjolnir.drzeus.cx>
In-Reply-To: <200807052111.49807.saschasommer@freenet.de>
References: <20080705115039.77bf7e1c@mjolnir.drzeus.cx>
	<200807052111.49807.saschasommer@freenet.de>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-16098-1215300280-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-16098-1215300280-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 5 Jul 2008 21:11:49 +0200
Sascha Sommer <saschasommer@freenet.de> wrote:

>=20
> There is still some hack for ACMDs. I know you won't like that but I did =
not =20
> get the SD_APP_SEND_SCR command to work without it.
>=20
> MMC_SEND_EXT_CSD does not work (also not with that ACMD hack) and prints =
out=20
> something like:
>=20

The SCR and EXT_CSD are both the only data transfers that are done in
1-bit mode in the respective init paths. Are you sure that hack you
have for ACMDs is really for ACMDs and not for 1-bit transfers?

(And you're right about me not liking that hack, but I can let that one
slide as long as you agree it is important to get rid off ;))

> mmc0: unable to read EXT_CSD, performance might suffer.
>=20
> The card works without problems after this message.
>=20

Yeah, it works for older MMC cards. The newer, larger ones will fail
when it can't read the EXT_CSD though.

Rgds
--=20
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-16098-1215300280-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkhwArcACgkQ7b8eESbyJLi7fACg6UIFuus4TkUE/P0TfdLGLVpV
RS0AoKUF9najpGrSOzq2Ykhh+EYFHeu1
=Lvzm
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-16098-1215300280-0001-2--
