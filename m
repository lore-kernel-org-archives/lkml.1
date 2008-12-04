Return-Path: <linux-kernel-owner+w=401wt.eu-S1757605AbYLDGrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757605AbYLDGrW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 01:47:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754874AbYLDGrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 01:47:12 -0500
Received: from server.drzeus.cx ([85.8.24.28]:32888 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754362AbYLDGrK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 01:47:10 -0500
Date: Thu, 4 Dec 2008 07:47:02 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: philipl@overt.org
Cc: "linux kernel" <linux-kernel@vger.kernel.org>, sdhci-devel@list.drzeus.cx,
       "Matthew Garrett" <mjg59@srcf.ucam.org>,
       "Frans Pop" <elendil@planet.nl>
Subject: Re: [PATCH] ricoh_mmc: Use suspend/resume_noirq (v2)
Message-ID: <20081204074702.63308010@mjolnir.drzeus.cx>
In-Reply-To: <54240.67.164.5.76.1228323573.squirrel@overt.org>
References: <54240.67.164.5.76.1228323573.squirrel@overt.org>
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-13934-1228373228-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-13934-1228373228-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 3 Dec 2008 11:59:33 -0500 (EST)
philipl@overt.org wrote:

> If ricoh_mmc suspends before sdhci_pci, it will pull the card
> out from under the controller, which could leave the system in
> a very confused state.
>=20
> Using suspend/resume_noirq ensures that sdhci_pci suspends first
> and resumes second.
>=20
> Signed-off-by: Philip Langdale <philipl@overt.org>
> ---

It's probably easier if this is carried in rafael's tree, where the PM
change is. Add a

Acked-by: Pierre Ossman <drzeus@drzeus.cx>

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-13934-1228373228-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkk3fOsACgkQ7b8eESbyJLjSdwCffc/stIRAeJLH3o6VwalTVt8y
BYAAoPyS5slcr49YB8uhjlkYf7ryJ+oa
=OY+t
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-13934-1228373228-0001-2--
