Return-Path: <linux-kernel-owner+w=401wt.eu-S1755288AbYAHS3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288AbYAHS3l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 13:29:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751462AbYAHS3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 13:29:32 -0500
Received: from systemlinux.org ([83.151.29.59]:52254 "EHLO m18s25.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752644AbYAHS3c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 13:29:32 -0500
Date: Tue, 8 Jan 2008 19:29:04 +0100
From: Andre Noll <maan@systemlinux.org>
To: Tuomo Valkonen <tuomov@iki.fi>
Cc: linux-kernel@vger.kernel.org
Subject: Re: The ext3 way of journalling
Message-ID: <20080108182904.GB16462@skl-net.de>
References: <slrnfo77tv.2rr.tuomov@jolt.modeemi.cs.tut.fi> <20080108164847.GA16462@skl-net.de> <slrnfo7e3i.c37.tuomov@jolt.modeemi.cs.tut.fi>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/NkBOFFp2J2Af1nK"
Content-Disposition: inline
In-Reply-To: <slrnfo7e3i.c37.tuomov@jolt.modeemi.cs.tut.fi>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/NkBOFFp2J2Af1nK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 17:52, Tuomo Valkonen wrote:
> On 2008-01-08, Andre Noll <maan@systemlinux.org> wrote:
> > Use tune2fs to deactivate checking.
>=20
> So, a workaround is the answer to a clear bug. Typical FOSS.

It's not a workaround. The ext3 maintainers argue that every file
system should be checked from time to time. Therefore it's the
default. You do not agree with them, so change the default and be
happy. Or use another fs which claims that no check is necessary.

> Another typical FOSS answer. "You have the source, you can fix it."

Indeed, and I think it's a very good answer.

> With what time?

Use the time you are currently using for whining on mailing lists.

> > Don't use udev then. Good old static dev works fine if you have a fixed
> > set of devices.
>=20
> It doesn't, with the unpredictable SCSI mapping insanity.

Then write a set of udev rules for your SCSI devices. It's easy.

> > Check your tool-chain. Many people compile recent kernels with no probl=
ems.
>=20
> And recompile and recompile and recompile ad infinitum, because always
> some option was missing or wrong, there being far too many of them and
> hidden all over the place.

If you're not willing to compile, you'll have to use what other
people provide. It's your choice, but at least there _is_ a choice.

> > You're not ranting about Linux but about your Distro. Complain on
> > the corresponding distro-specific mailing list, use another distro
> > and and stop whining.
>=20
> I don't use a distro kernel. I use a kernel I compiled myself over
> two years ago. I have tried compiling newer ones, but it's too much
> work to get all the options right.

I tend to disagree. It's not hard at all to configure a kernel if
you know the hardware. It's even easier if you already have a working
config for some kernel version. Just use "make oldconfig" to upgrade
=66rom one version to the next as already suggested by others and me.

> And then there's the problem that the "good" driver for my SATA disk
> may not be there anymore in the latest kernels, and so on.

That is clearly a regression and I'm sure Jeff and other maintainers
of the driver would be interested in details on this matter.

Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--/NkBOFFp2J2Af1nK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFHg8DwWto1QDEAkw8RAopkAJ9GOcrcivlBxBoff1O6oBfQzdIH1ACePA2M
pEkTuEQ44GTS4dhdqchNZ2c=
=nTQr
-----END PGP SIGNATURE-----

--/NkBOFFp2J2Af1nK--
