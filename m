Return-Path: <linux-kernel-owner+w=401wt.eu-S1756994AbZAXR5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756994AbZAXR5j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 12:57:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752814AbZAXR5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 12:57:31 -0500
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:55792 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752482AbZAXR5a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 12:57:30 -0500
Date: Sat, 24 Jan 2009 18:57:23 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: philipl@overt.org, rjw@sisk.pl
Cc: "linux kernel" <linux-kernel@vger.kernel.org>, sdhci-devel@list.drzeus.cx
Subject: Re: [PATCH] ricoh_mmc: Use suspend_late/resume_early
Message-ID: <20090124185723.7dc9a875@mjolnir.drzeus.cx>
In-Reply-To: <39393.98.210.152.237.1232305880.squirrel@overt.org>
References: <39393.98.210.152.237.1232305880.squirrel@overt.org>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-5352-1232819846-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-5352-1232819846-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 18 Jan 2009 14:11:20 -0500 (EST)
philipl@overt.org wrote:

> If ricoh_mmc suspends before sdhci_pci, it will pull the card
> out from under the controller, which could leave the system in
> a very confused state.
>=20
> Using suspend_late/resume_early ensures that sdhci_pci suspends first
> and resumes second.
>=20
> Signed-off-by: Philip Langdale <philipl@overt.org>
> ---

What's the plan here? Apply for .29?

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-5352-1232819846-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkl7VocACgkQ7b8eESbyJLj2CgCfZTljwxa41sGUUPiV7GwMhhLD
ICkAmwUgnYzEaY8C4VOU+y4hMnJutVQz
=h9Jx
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-5352-1232819846-0001-2--
