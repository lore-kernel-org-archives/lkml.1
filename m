Return-Path: <linux-kernel-owner+w=401wt.eu-S1760464AbZE2OhD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760464AbZE2OhD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 10:37:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759304AbZE2Ogz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 10:36:55 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:54499 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758466AbZE2Ogy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 10:36:54 -0400
Date: Fri, 29 May 2009 16:36:46 +0200
From: Pierre Ossman <pierre@ossman.eu>
To: Ben Dooks <ben-linux@fluff.org>
Cc: linux-kernel@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>
Subject: Re: [PATCH] sdhci: consider ADMA error interrupt as data interrupt
Message-ID: <20090529163646.3bd6a596@mjolnir.ossman.eu>
In-Reply-To: <1243604159-17526-1-git-send-email-ben-linux@fluff.org>
References: <1243604159-17526-1-git-send-email-ben-linux@fluff.org>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-25353-1243607814-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-25353-1243607814-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 29 May 2009 14:35:59 +0100
Ben Dooks <ben-linux@fluff.org> wrote:

> Currently any SDHCI_INT_ADMA_ERROR response is processed by
> sdhci_data_irq() producing an -EIO for the transfer, but is
> not in the SDHCI_INT_DATA_MASK so sdhci_irq() produces a
> warning of "Unexpected interrupt 0x02000000".
>=20
> Signed-off-by: Ben Dooks <ben-linux@fluff.org>

http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux-2.6.git;a=3Dcomm=
itdiff;h=3D4accfe2577fab83e41db02282570e849f24ddf53

;)

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-25353-1243607814-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkof8wIACgkQ7b8eESbyJLi8/ACgxc7mwvtKzpk291S7BiQvEslL
kpkAn1mhWgVvr6UoT1CFYDgd+LrRL31t
=C1YX
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-25353-1243607814-0001-2--
