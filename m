Return-Path: <linux-kernel-owner+w=401wt.eu-S1758497AbXLRPXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758497AbXLRPXA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 10:23:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756514AbXLRPWw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 10:22:52 -0500
Received: from chello089077114002.chello.pl ([89.77.114.2]:46837 "EHLO
	astralstorm.puszkin.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753136AbXLRPWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 10:22:52 -0500
Date: Tue, 18 Dec 2007 16:22:28 +0100
From: Radoslaw Szkodzinski (AstralStorm) <lkml@astralstorm.puszkin.org>
To: Al Boldi <a1426z@gawab.com>
Cc: "Indan Zupancic" <indan@nul.nu>,
       "Tetsuo Handa" <penguin-kernel@i-love.sakura.ne.jp>,
       david@davidnewall.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/2] [RFC] Simple tamper-proof device filesystem.
Message-ID: <20071218162228.79f75395@astralstorm.puszkin.org>
In-Reply-To: <200712171605.31084.a1426z@gawab.com>
References: <47650A4C.4000708@davidnewall.com>
	<200712170040.lBH0e6sf099887@www262.sakura.ne.jp>
	<54137.81.207.0.53.1197891890.squirrel@secure.samage.net>
	<200712171605.31084.a1426z@gawab.com>
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/Dj+tqoofQEliyGOuA6BjJ.d";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Dj+tqoofQEliyGOuA6BjJ.d
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 17 Dec 2007 16:05:31 +0300
Al Boldi <a1426z@gawab.com> wrote:

> Indan Zupancic wrote:
> > On Mon, December 17, 2007 01:40, Tetsuo Handa wrote:
> > I think you can better spend your time on read-only bind mounts.
>=20
> That would be too coarse.
>=20

Actually, who needs to create device nodes? Just prohibit everyone from
creating them, except "installer" and "udev" personality.
This means removing CAP_MKNOD on a global scale.
(OTOH, both don't need CAP_SYS_ADMIN. Maybe udev needs
CAP_SYS_MODULE...)

Now, stopping people from faking hotplug events is totally another
story. Is that currently possible?

--Sig_/Dj+tqoofQEliyGOuA6BjJ.d
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQFHZ+W8BlhXA0ALOYMRArJLAKDGSzgFHGYfbanFqdZqnbvAiU1GeQCghdsS
YF2IEkcJkGbHf64ZdIEBnkI=
=tzOb
-----END PGP SIGNATURE-----

--Sig_/Dj+tqoofQEliyGOuA6BjJ.d--
