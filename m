Return-Path: <linux-kernel-owner+w=401wt.eu-S1756469AbZGDBfA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756469AbZGDBfA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 21:35:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754187AbZGDBev
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 21:34:51 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:35093 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753823AbZGDBet (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 21:34:49 -0400
Date: Sat, 4 Jul 2009 11:34:48 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org
Subject: linux-next submission requirements (Was: [RFC PATCH] linker script:
 unify usage of discard definition)
Message-Id: <20090704113448.49a722d2.sfr@canb.auug.org.au>
In-Reply-To: <4A4E9638.20304@kernel.org>
References: <4A4E9638.20304@kernel.org>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__4_Jul_2009_11_34_48_+1000_QBZZTiTMXj1Oap5R"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__4_Jul_2009_11_34_48_+1000_QBZZTiTMXj1Oap5R
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tejun,

[This is not aimed just at you ... this patch just gave me an
opportunity to point this out again.]

On Sat, 04 Jul 2009 08:37:28 +0900 Tejun Heo <tj@kernel.org> wrote:
>
> This patch is on top of the current percpu#for-next.
>=20
>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git for-next
>=20
> Thanks.
>=20
> NOT_SIGNED_OFF_YET

Well, given no SOB and that this is a RFC patch, it should *not* be in a
branch that is pulled into linux-next.

This is what I send to any maintainer that submits a tree for linux-next
inclusion (and before anyone else points it out: this was not true early
on):

"all patches/commits in the tree/series must have been:

	posted to a relevant mailing list
	reviewed
	unit tested
	destined for the next merge window (or the current release)

*before* they are included.  The linux-next tree is for integration
testing and to lower the impact of conflicts between subsystems in the
next merge window.

Basically, this should be just what you would send to Linus (or ask him
to fetch).  It is allowed to be rebased if you deem it necessary."

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__4_Jul_2009_11_34_48_+1000_QBZZTiTMXj1Oap5R
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpOsbgACgkQjjKRsyhoI8zDlQCffuNpjxFX4EkBaMMY5yRd8jDA
/VAAn2ToZp0b2MgZJ0KP4bcUgvPcB/Ri
=c8C+
-----END PGP SIGNATURE-----

--Signature=_Sat__4_Jul_2009_11_34_48_+1000_QBZZTiTMXj1Oap5R--
