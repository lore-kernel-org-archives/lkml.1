Return-Path: <linux-kernel-owner+w=401wt.eu-S1756236AbYK3WuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236AbYK3WuV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 17:50:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753493AbYK3WuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 17:50:06 -0500
Received: from server.drzeus.cx ([85.8.24.28]:46144 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753457AbYK3WuF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 17:50:05 -0500
Date: Sun, 30 Nov 2008 23:49:57 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: Philip Langdale <philipl@overt.org>
Cc: linux kernel <linux-kernel@vger.kernel.org>, sdhci-devel@list.drzeus.cx,
       Matthew Garrett <mjg59@srcf.ucam.org>, Frans Pop <elendil@planet.nl>
Subject: Re: [PATCH] ricoh_mmc: Use suspend/resume_noirq
Message-ID: <20081130234957.426ded07@mjolnir.drzeus.cx>
In-Reply-To: <492DFB39.1050503@overt.org>
References: <492DFB39.1050503@overt.org>
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-24551-1228085403-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-24551-1228085403-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 26 Nov 2008 17:43:21 -0800
Philip Langdale <philipl@overt.org> wrote:

> If ricoh_mmc suspends before sdhci_pci, it will pull the card
> out from under the controller, which could leave the system in
> a very confused state.
>=20
> Using suspend/resume_noirq ensures that sdhci_pci suspends first
> and resumes second.
>=20
> Signed-off-by: Philip Langdale <philipl@overt.org>
> ---

You get some odd whitespace damage on your patches. Please see if you
can get that fixed, or resend the patch as an attachment.

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-24551-1228085403-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkkzGJoACgkQ7b8eESbyJLhOAACgwX4K2flyjR0fGj72Apo4LIrS
bd0AoOuDf+O1rXvzEbuYduum653PnoGd
=6wwA
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-24551-1228085403-0001-2--
