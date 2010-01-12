Return-Path: <linux-kernel-owner+w=401wt.eu-S1754727Ab0ALWdM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727Ab0ALWdM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 17:33:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754233Ab0ALWdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 17:33:12 -0500
Received: from gabe.freedesktop.org ([131.252.210.177]:50315 "EHLO
	gabe.freedesktop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753959Ab0ALWdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 17:33:11 -0500
From: Eric Anholt <eric@anholt.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Zhenyu Wang <zhenyuw@linux.intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       dri-devel@lists.sourceforge.net
Subject: Re: [PATCH] DRM / i915: Fix resume regression on MSI Wind U100 w/o
 KMS
In-Reply-To: <201001090045.33784.rjw@sisk.pl>
References: <201001090045.33784.rjw@sisk.pl>
Date: Tue, 12 Jan 2010 14:33:21 -0800
Message-ID: <878wc3j6mm.fsf@pollan.anholt.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Sat, 9 Jan 2010 00:45:33 +0100, "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
>=20
> Commit cbda12d77ea590082edb6d30bd342a67ebc459e0 (drm/i915: implement
> new pm ops for i915), among other things, removed the .suspend and
> .resume pointers from the struct drm_driver object in i915_drv.c,
> which broke resume without KMS on my MSI Wind U100.
>=20
> Fix this by reverting that part of commit cbda12d77ea59.
>=20
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Applied, with a little comment for the next poor person having to figure
out the difference between these two suspend/resume paths.

(And yes, I'd love to see the stealth mode die sometime soonish.  It's
not like attaching intelfb didn't make the user-mode 2D driver fail
frequently, so it's not a great "feature" for us to be maintaining
support for.  From what I understand most distros blacklisted the
intelfb driver anyway.)

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktM+LEACgkQHUdvYGzw6vesswCeLTaBN2l2S9rNp3o9iGb5KAdx
NTMAoI1JZ40C+9GuZzrEualWRbkCWror
=lIez
-----END PGP SIGNATURE-----
--=-=-=--
