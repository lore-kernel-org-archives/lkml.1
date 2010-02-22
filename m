Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043Ab0BVQg1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 11:36:27 -0500
Received: from gabe.freedesktop.org ([131.252.210.177]:35666 "EHLO
	gabe.freedesktop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126Ab0BVQg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 11:36:26 -0500
From: Eric Anholt <eric@anholt.net>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pedro Ribeiro <pedrib@gmail.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       linux-kernel@vger.kernel.org,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH] i915 / PM: Fix hibernate regression caused by
 suspend/resume splitting
In-Reply-To: <alpine.LFD.2.00.1002220746260.4141@localhost.localdomain>
References: <74fd948d1002171047g70d2bba0l957e264dfbc8ea23@mail.gmail.com>
	<201002172320.57491.rjw@sisk.pl>
	<74fd948d1002171629v7e86371cna4441e8feb27c326@mail.gmail.com>
	<201002182306.28052.rjw@sisk.pl>
	<alpine.LFD.2.00.1002220746260.4141@localhost.localdomain>
Date: Mon, 22 Feb 2010 11:36:36 -0500
Message-ID: <87hbp9b52j.fsf@pollan.anholt.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Mon, 22 Feb 2010 07:47:53 -0800 (PST), Linus Torvalds <torvalds@linux-fo=
undation.org> wrote:
>=20
> Jesse, Eric, what's the status of this patch?=20
>=20
> Should I take it directly (I'd really like an Ack) or is it queued up in=
=20
> some tree waiting for me to pull? Or is there some reason not to have it,=
=20
> despite it fixing things for some people?

Acked-by: Eric Anholt <eric@anholt.net>

I just reviewed the rest of my tag:todo and I don't think I have
anything else I want to pull request for this kernel (finally), so if
you could just grab this patch it would be great.

(Well, there's also "quit trying to _LID on 855 because it's always a
pack of lies", but I'd rather do it as a backport later in case someone
screams)

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuCspQACgkQHUdvYGzw6ve4ugCeOGhREYyfd4NszfhiKiGda/OP
usIAnRQkBw81tfG3bmEGBNruqqmWJQ4t
=0Nxr
-----END PGP SIGNATURE-----
--=-=-=--
