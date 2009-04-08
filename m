Return-Path: <linux-kernel-owner+w=401wt.eu-S1764392AbZDHSjl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764392AbZDHSjl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 14:39:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764394AbZDHSjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 14:39:08 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:34686 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764329AbZDHSjG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 14:39:06 -0400
Date: Wed, 8 Apr 2009 20:39:01 +0200
From: Pierre Ossman <pierre@ossman.eu>
To: Wolfgang =?UTF-8?B?TcO8ZXM=?= <wolfgang.mues@auerswald.de>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Matt Fleming" <matt@console-pimps.org>,
       "David Brownell" <dbrownell@users.sourceforge.net>,
       "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/7 revised II] mmc_spi: do not check CID and CSD blocks
 with CRC16
Message-ID: <20090408203901.4aa8dffc@mjolnir.ossman.eu>
In-Reply-To: <200904071548.17091.wolfgang.mues@auerswald.de>
References: <200904071548.17091.wolfgang.mues@auerswald.de>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-25952-1239215941-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-25952-1239215941-0001-2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 7 Apr 2009 14:48:16 +0100
Wolfgang M=C3=BCes <wolfgang.mues@auerswald.de> wrote:

> From: Wolfgang Muees <wolfgang.mues@auerswald.de>
>=20
> o Some cards are not able to calculate a valid CRC16 value
>   for CID and CSD reads (CRC for 512 byte data blocks is OK).
>   By moving the CRC enable after the read of CID and CSD, these
>   cards can be used. This patch was tested with a faulty 8 GByte
>   takeMS Class 6 SDHC card. This patch was suggested by
>   Pierre Ossman <drzeus@drzeus.cx>.
>=20
> Signed-off-by: Wolfgang Muees <wolfgang.mues@auerswald.de>
>=20

Queued.

Thanks
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-25952-1239215941-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAknc70cACgkQ7b8eESbyJLizcQCgy5qDvEApgR2QsRmj9tfZnPSD
+zAAnip+xjfQeFlGzFgHQXX/qmWYiP28
=yxN7
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-25952-1239215941-0001-2--
