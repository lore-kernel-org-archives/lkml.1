Return-Path: <linux-kernel-owner+w=401wt.eu-S1754734AbZBUP7J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734AbZBUP7J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 10:59:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755142AbZBUP6l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 10:58:41 -0500
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:50459 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755093AbZBUP6k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 10:58:40 -0500
Date: Sat, 21 Feb 2009 16:58:33 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Pierre Ossman <drzeus-sdhci@drzeus.cx>, Ben Dooks <ben-linux@fluff.org>,
       Arnd Bergmann <arnd@arndb.de>, Kumar Gala <galak@kernel.crashing.org>,
       Liu Dave <DaveLiu@freescale.com>, sdhci-devel@list.drzeus.cx,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 07/13] sdhci: Add support for hosts with strict 32 bit
 addressing
Message-ID: <20090221165833.6dec220a@mjolnir.ossman.eu>
In-Reply-To: <20090213144722.GG23889@oksana.dev.rtsoft.ru>
References: <20090213144630.GA13436@oksana.dev.rtsoft.ru>
	<20090213144722.GG23889@oksana.dev.rtsoft.ru>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.15.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.drzeus.cx-15419-1235231918-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-15419-1235231918-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 13 Feb 2009 17:47:22 +0300
Anton Vorontsov <avorontsov@ru.mvista.com> wrote:

> SDHCI driver must take special care when working with "triggering"
> registers on hosts with strict 32 bit addressing.
>=20
> In FSL eSDHC hosts all registers are 32 bit width, writing to the
> first half of any register will cause [undefined?] write the second
> half of the register. That is, 16 bit write to the TRANSFER_MODE
> register, makes hardware see a bogus write to the COMMAND register
> (these two registers are adjacent).
>=20
> This patch adds SDHCI_QUIRK_32BIT_REGISTERS quirk. When specified,
> the sdhci driver will try to "pack" all dangerous writes into single
> 32 bit write transaction.
>=20
> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> ---

What about the other places where we have 16 and 8 bit registers?

--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-15419-1235231918-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.10 (GNU/Linux)

iEYEARECAAYFAkmgJK0ACgkQ7b8eESbyJLjyKACgzC2anefb2CIywcvAzFxxOOy8
d9wAn143aHZoPApTiQOxXDIqFMkmDPtk
=dsV3
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-15419-1235231918-0001-2--
