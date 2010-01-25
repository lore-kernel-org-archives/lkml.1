Return-Path: <linux-kernel-owner+w=401wt.eu-S1754653Ab0AYTUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653Ab0AYTUz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 14:20:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753827Ab0AYTUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 14:20:55 -0500
Received: from gabe.freedesktop.org ([131.252.210.177]:54213 "EHLO
	gabe.freedesktop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753663Ab0AYTUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 14:20:54 -0500
From: Eric Anholt <eric@anholt.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       dri-devel@lists.sourceforge.net
Subject: Re: [PATCH] PM / i915: Skip kernel VT switch during suspend/resume
 if KMS is used
In-Reply-To: <201001240055.59479.rjw@sisk.pl>
References: <201001240055.59479.rjw@sisk.pl>
Date: Mon, 25 Jan 2010 09:22:11 -0800
Message-ID: <87k4v63xrw.fsf@pollan.anholt.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Sun, 24 Jan 2010 00:55:59 +0100, "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
>=20
> If a non-KMS graphics driver is used, the kernel carries out a VT
> switch during suspend/resume to avoid possible problems with freezing
> X at a wrong time and to cause X to repaint everything after resume.
>=20
> This is not necessary any more if the KMS is used, so skip the kernel
> VT switch during suspend/resume for i915 in the KMS mode.
>=20
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>=20
> Hi,
>=20
> I've been testing this patch for over a week and haven't seen a single pr=
oblem
> related to it during this time.
>=20
> Are there any objections to it?
>=20
> Rafael

Love it!

Acked-by: Eric Anholt <eric@anholt.net>

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktd00MACgkQHUdvYGzw6vdJxgCeLFdnO9dl9KMH8Lh+3k3ti8iq
shgAn0mj5xFmLxtaXnYFyHpDoH67cDAa
=DG7D
-----END PGP SIGNATURE-----
--=-=-=--
