Return-Path: <linux-kernel-owner+w=401wt.eu-S1753465AbYKZPNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465AbYKZPNT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 10:13:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752188AbYKZPNJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 10:13:09 -0500
Received: from server.drzeus.cx ([85.8.24.28]:40645 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752132AbYKZPNI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 10:13:08 -0500
Date: Wed, 26 Nov 2008 16:12:54 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: Philip Langdale <philipl@overt.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Frans Pop <elendil@planet.nl>,
       linux-kernel@vger.kernel.org, sdhci-devel@list.drzeus.cx,
       fseidel@suse.de, weyland@library.ethz.ch
Subject: Re: [PATCH] ricoh_mmc: Handle newer models of Ricoh controllers
Message-ID: <20081126161254.25ee531f@mjolnir.drzeus.cx>
In-Reply-To: <492D6300.2060401@overt.org>
References: <492BBA91.5010302@overt.org>
	<200811261436.57946.elendil@planet.nl>
	<492D604C.10707@overt.org>
	<20081126145039.GA31043@srcf.ucam.org>
	<492D6300.2060401@overt.org>
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-18541-1227712385-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-18541-1227712385-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 26 Nov 2008 06:53:52 -0800
Philip Langdale <philipl@overt.org> wrote:

> Matthew Garrett wrote:
> >=20
> > Thinking about it, it could possibly be handled by changing to=20
> > suspend_noirq and resume_noirq rather than the normal suspend and resum=
e=20
> > functions? That ought to get the ordering constraints right. The proble=
m=20
> > occurs when ricoh_mmc suspends before sdhci and resumes after it.
>=20
> I'll investigate that and see what happens.
>=20

Or you integrate it into sdhci_pci. Look at the register fiddling for
JMicron chips in there.

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-18541-1227712385-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkktZ3sACgkQ7b8eESbyJLjZcQCeNuMSpIjTI+o00WN3UVyeOtaY
qjUAoJFsQdGaKKZhFWcLRn/GhVx0Ayeg
=s11R
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-18541-1227712385-0001-2--
