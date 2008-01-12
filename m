Return-Path: <linux-kernel-owner+w=401wt.eu-S1756103AbYALPWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103AbYALPWT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 10:22:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750968AbYALPWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 10:22:07 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:43303 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750873AbYALPWG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 10:22:06 -0500
Date: Sat, 12 Jan 2008 16:21:50 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: Pavel Machek <pavel@suse.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Ondrej Zary <linux@rainbow-software.org>,
       Jaroslav Kysela <perex@perex.cz>,
       ALSA development <alsa-devel@alsa-project.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, Andrew Morton <akpm@osdl.org>,
       Takashi Iwai <tiwai@suse.de>, linux-pm@lists.linux-foundation.org
Subject: Re: [alsa-devel] PNP_DRIVER_RES_DISABLE breaks swsusp at least with
 snd_cs4236
Message-ID: <20080112162150.1ec9cad0@poseidon.drzeus.cx>
In-Reply-To: <4788C323.6090206@keyaccess.nl>
References: <200801092343.48726.linux@rainbow-software.org>
	<20080111080141.75aaad5f@poseidon.drzeus.cx>
	<47877B83.5040604@keyaccess.nl>
	<200801111940.22023.linux@rainbow-software.org>
	<4788168F.8070403@keyaccess.nl>
	<20080112121256.0f2e96ad@poseidon.drzeus.cx>
	<4788C323.6090206@keyaccess.nl>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_hera.drzeus.cx-4890-1200151324-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_hera.drzeus.cx-4890-1200151324-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 12 Jan 2008 14:39:47 +0100
Rene Herman <rene.herman@keyaccess.nl> wrote:

> On 12-01-08 12:12, Pierre Ossman wrote:
>=20
> > I'm a bit confused here. Bjorn Helgaas wanted to remove the pnp_start/s=
top_dev() calls completely, and you want them called all the time. :)
>=20
> Wanted where? Haven't seen a coment from Bjorn? But -- while removing the=
m=20
> both looks (as) sensible from a mirror-image viewpoint, this wouldn't fix=
=20
> the problem.
>=20

Ah, sorry. It was a different thread. Look for a mail with the subject "PNP=
: do not stop/start devices in suspend/resume path" in the LKML och linux-p=
m archives.

>=20
> But we certainly need the pnp_start_dev() in the current flow of things. =
It=20
> not being called is the problem this fixes...
>=20

I think the previous suggestion was that the drivers should call this, not =
the core, so that it behaved more like other parts of the kernel (e.g. PCI).

Rgds
Pierre

--=_hera.drzeus.cx-4890-1200151324-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)

iEYEARECAAYFAkeI2w8ACgkQ7b8eESbyJLjRVACgnkH1P1ypKhQ57QRfWCHJcp8T
ej4AnjEEuZ7v+44+fSpQOwUFQ65jcOFn
=2sNB
-----END PGP SIGNATURE-----

--=_hera.drzeus.cx-4890-1200151324-0001-2--
