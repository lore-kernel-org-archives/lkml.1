Return-Path: <linux-kernel-owner+w=401wt.eu-S1753916AbYKZOqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916AbYKZOqT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 09:46:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752251AbYKZOqK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 09:46:10 -0500
Received: from server.drzeus.cx ([85.8.24.28]:38748 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752168AbYKZOqJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 09:46:09 -0500
Date: Wed, 26 Nov 2008 15:45:52 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: Philip Langdale <philipl@overt.org>
Cc: Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org,
       sdhci-devel@list.drzeus.cx, fseidel@suse.de, weyland@library.ethz.ch,
       Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH] ricoh_mmc: Handle newer models of Ricoh controllers
Message-ID: <20081126154552.6ec5ec47@mjolnir.drzeus.cx>
In-Reply-To: <492D604C.10707@overt.org>
References: <492BBA91.5010302@overt.org>
	<200811261436.57946.elendil@planet.nl>
	<492D604C.10707@overt.org>
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-17142-1227710764-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-17142-1227710764-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 26 Nov 2008 06:42:20 -0800
Philip Langdale <philipl@overt.org> wrote:

> Frans Pop wrote:
> >> The latest generation of laptops are shipping with a newer
> >> model of Ricoh chip where the firewire controller is the
> >> primary PCI function but a cardbus controller is also present.
> >=20
> > Note that the current separate ricoh_mmc disabling module approach has=
=20
> > been shown to break during suspend/resume. Matthew Garret proposed a=20
> > patch for that which (with minor fixups) I tested successfully.
>=20
> Hmm. Well, I'm interested as to what Pierre thinks. He explicitly didn't
> want a quirk when we originally looked at the problem and that's why
> ricoh_mmc exists - but maybe this is a good enough reason to revisit that
> decision.
>=20

Actually, what I didn't want was a _sdhci_ quirk. I'm fine with a PCI one. =
In fact,
that's probably the best approach as that register fiddling hides some
PCI devices, so it's best if it is done before enumeration.

(Side note: sdhci has now undergone the architectural change that would
allow a quirk like this, but the PCI version is probably still best)

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-17142-1227710764-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkktYSUACgkQ7b8eESbyJLhYyACfaevhweNf04ihMlsmsPuBnVYA
CSkAoJkh4jQOjhhnWAH0JYAKHp5gw+xq
=dxoK
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-17142-1227710764-0001-2--
