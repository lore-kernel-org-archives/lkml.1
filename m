Return-Path: <linux-kernel-owner+w=401wt.eu-S1753531AbYIEFHJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531AbYIEFHJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 01:07:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751216AbYIEFG5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 01:06:57 -0400
Received: from server.drzeus.cx ([85.8.24.28]:57769 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750848AbYIEFG4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 01:06:56 -0400
Date: Fri, 5 Sep 2008 07:06:48 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: sasin@solomon-systech.com, linux-kernel@vger.kernel.org
Subject: Re: mmc/card/block.c : mmc_blk_open readonly mount bug?
Message-ID: <20080905070648.1e46fa35@mjolnir.drzeus.cx>
In-Reply-To: <20080904160808.a23a2197.akpm@linux-foundation.org>
References: <6334E09627481B4AA5C8DE1E69E19D3B09D1F13A@SSLEXCHANGE.solomonsystech.com>
	<20080904160808.a23a2197.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-14816-1220591214-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-14816-1220591214-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 4 Sep 2008 16:08:08 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> From: Andrew Morton <akpm@linux-foundation.org>
>=20
> mmc_block_open() increments md->usage although it returns with -EROFS when
> default mounting a MMC/SD card with write protect switch on.  This
> reference counting bug prevents /dev/mmcblkX from being released on card
> removal, and situation worsen with reinsertion until the minor number
> range runs out.
>=20
> Reported-by: <sasin@solomon-systech.com>
> Cc: Pierre Ossman <drzeus-list@drzeus.cx>
> Cc: <stable@kernel.org>		[2.6.25.x, 2.6.26.x]
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---

I wonder how that bug has been able to go unnoticed for so long...

Acked-by: Pierre Ossman <drzeus@drzeus.cx>

--=20
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-14816-1220591214-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkjAvmwACgkQ7b8eESbyJLh17ACfa0g2cOYL/hiDvBphxyiwjmcx
pG4Anj7FaU/HoKXxe9kUBOiHYF279p2p
=yNim
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-14816-1220591214-0001-2--
