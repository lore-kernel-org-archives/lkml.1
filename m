Return-Path: <linux-kernel-owner+w=401wt.eu-S1756769AbZECTJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756769AbZECTJ0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 15:09:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754518AbZECTJR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 15:09:17 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:45375 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754018AbZECTJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 15:09:16 -0400
Date: Sun, 3 May 2009 21:09:10 +0200
From: Pierre Ossman <pierre@ossman.eu>
To: "Cai, Cliff" <Cliff.Cai@analog.com>
Cc: linux-kernel@vger.kernel.org, "Cliff Cai" <cliffcai.sh@gmail.com>
Subject: Re: [PATCH][RESEND][mmc/host]:Blackfin SD Host Controller Driver
Message-ID: <20090503210910.42a78397@mjolnir.ossman.eu>
In-Reply-To: <0F1B54C89D5F954D8535DB252AF412FA03F20154@chinexm1.ad.analog.com>
References: <1239903641-14342-1-git-send-email-cliffcai.sh@gmail.com>
	<20090426215030.582a6fbb@mjolnir.ossman.eu>
	<0F1B54C89D5F954D8535DB252AF412FA03F20154@chinexm1.ad.analog.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-10308-1241377753-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-10308-1241377753-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 27 Apr 2009 09:47:15 +0800
"Cai, Cliff" <Cliff.Cai@analog.com> wrote:

> >
> >If the controller can only do DAT3-detection, then I think=20
> >it's best if we put it into polling mode.
>=20
> What did you mean the polling mode,using a timer?
>=20

The MMC core handles it for you. Just set MMC_CAP_NEEDS_POLL.

> >
> >You cannot index sg lists directly anymore. You have to=20
> >iterate over them using the iteration helpers.
>=20
> Why?
>=20

Because you'll read bogus data otherwise and can even cause a oops. The
sg lists can be linked, which introduces special entries.

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-10308-1241377753-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkn969kACgkQ7b8eESbyJLiozwCgrMi2oYEABSdPt1OUWqa1+tJJ
+jUAoJep2OdTJxnvkOrgRIMxW/p2gVlA
=lb+K
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-10308-1241377753-0001-2--
