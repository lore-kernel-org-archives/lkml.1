Return-Path: <linux-kernel-owner+w=401wt.eu-S1759404AbYALLNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759404AbYALLNT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 06:13:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761572AbYALLNG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 06:13:06 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:45226 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761794AbYALLNE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 06:13:04 -0500
Date: Sat, 12 Jan 2008 12:12:56 +0100
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
Message-ID: <20080112121256.0f2e96ad@poseidon.drzeus.cx>
In-Reply-To: <4788168F.8070403@keyaccess.nl>
References: <200801092343.48726.linux@rainbow-software.org>
	<20080111080141.75aaad5f@poseidon.drzeus.cx>
	<47877B83.5040604@keyaccess.nl>
	<200801111940.22023.linux@rainbow-software.org>
	<4788168F.8070403@keyaccess.nl>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_hera.drzeus.cx-2038-1200136380-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_hera.drzeus.cx-2038-1200136380-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 12 Jan 2008 02:23:27 +0100
Rene Herman <rene.herman@keyaccess.nl> wrote:

>=20
> Pavel, Rafael -- the attached fixes snd-cs4236 not coming back to life fo=
r=20
> Ondrej after hibernation due to the PNP_DRIVER_RES_DO_NOT_CHANGE test=20
> triggering in pnp_bus_resume() and keeping the card in a suspended state.
>=20

I'm a bit confused here. Bjorn Helgaas wanted to remove the pnp_start/stop_=
dev() calls completely, and you want them called all the time. :)

Rgds
Pierre

--=_hera.drzeus.cx-2038-1200136380-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)

iEYEARECAAYFAkeIoLgACgkQ7b8eESbyJLj/VgCfSrl42/rrBKsA/+nRBO1yzxVE
A3kAn3pJcADnfR1Py/DHdfz825zIOdqe
=UYs2
-----END PGP SIGNATURE-----

--=_hera.drzeus.cx-2038-1200136380-0001-2--
