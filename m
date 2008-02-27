Return-Path: <linux-kernel-owner+w=401wt.eu-S1755320AbYB0GG2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320AbYB0GG2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 01:06:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751360AbYB0GGV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 01:06:21 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:41888 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750974AbYB0GGU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 01:06:20 -0500
Date: Wed, 27 Feb 2008 17:06:16 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: -next build logs
Message-Id: <20080227170616.d4bc2262.sfr@canb.auug.org.au>
In-Reply-To: <47C45749.3010001@s5r6.in-berlin.de>
References: <47C45749.3010001@s5r6.in-berlin.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__27_Feb_2008_17_06_16_+1100_Ar.c8yhcfm7ruhJo"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__27_Feb_2008_17_06_16_+1100_Ar.c8yhcfm7ruhJo
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 26 Feb 2008 19:15:37 +0100 Stefan Richter <stefanr@s5r6.in-berlin.d=
e> wrote:
>
> Stephen,
>=20
> the allmodconfig builds at http://kisskb.ellerman.id.au/kisskb/branch/9/=
=20
> seem to lack a few drivers even though they are properly enabled in the=20
> respective config.  Is it simply because everything is rebuilt on top of=
=20
> a previous build?

The build system will now remove the object tree after each build, so
everything should now get built every time.  It was doing a "make clean"
but only if the build succeeded.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__27_Feb_2008_17_06_16_+1100_Ar.c8yhcfm7ruhJo
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHxP3cTgG2atn1QN8RAr1VAJ44Jul38Ap/O/EgFDkgJTBGLLu+FwCff8eM
cOaWhNwI0T0uRdu+CwqWQg0=
=fGTf
-----END PGP SIGNATURE-----

--Signature=_Wed__27_Feb_2008_17_06_16_+1100_Ar.c8yhcfm7ruhJo--
