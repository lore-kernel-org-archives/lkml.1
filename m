Return-Path: <linux-kernel-owner+w=401wt.eu-S1754681AbYLUQ7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681AbYLUQ7h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 11:59:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753063AbYLUQ73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 11:59:29 -0500
Received: from server.drzeus.cx ([85.8.24.28]:57915 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752370AbYLUQ73 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 11:59:29 -0500
Date: Sun, 21 Dec 2008 17:59:20 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: David =?UTF-8?B?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: linux-kernel@vger.kernel.org, tbm@cyrius.com
Subject: Re: Is the Ricoh R5C822 documentation available?
Message-ID: <20081221175920.7c6be16c@mjolnir.drzeus.cx>
In-Reply-To: <20081208215458.GI14254@hardeman.nu>
References: <20081208215458.GI14254@hardeman.nu>
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-28098-1229878766-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-28098-1229878766-0001-2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 8 Dec 2008 22:54:58 +0100
David H=C3=A4rdeman <david@hardeman.nu> wrote:

> The Ricoh R5C822 card reader in my laptop includes a smart card reader=20
> (http://www.ricoh.com/LSI/product_pcif/pcc/5c821/index.html) but it=20
> doesn't seem supported by the kernel.
>=20
> So I was wondering whether the documentation for the Ricoh card reader is=
=20
> available from somewhere (or is the sdhci support the result of reverse=20
> engineering?).
>=20
> Ricoh told me to ask HP and HP hasn't answered at all...
>=20

In which case you've gotten further than most of us. Ricoh are not an
helpful vendor so getting their hardware up and running is always an
uphill battle.

sdhci was the result of reverse engineering yes, but that is hardly
relevant here as it is not a ricoh interface but a standardised one.
The fixes in ricoh_mmc were based on information received from an OEM,
not from Ricoh directly.

So right now I'd say reverse engineering is your only option if you
want to support that piece of hardware.

Rgds
--=20
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-28098-1229878766-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAklOde0ACgkQ7b8eESbyJLj83wCdFlTTHfQxQ6VK1IeKtOADAqjE
OpwAn2Kdhvx2w6/9pi1oRjAOH4iQbahT
=cHzK
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-28098-1229878766-0001-2--
