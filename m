Return-Path: <linux-kernel-owner+w=401wt.eu-S1758192AbYGPR5K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758192AbYGPR5K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 13:57:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752932AbYGPR44
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 13:56:56 -0400
Received: from bohort.kerlabs.com ([62.160.40.57]:49608 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018AbYGPR44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 13:56:56 -0400
Date: Wed, 16 Jul 2008 19:56:54 +0200
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: Joel Becker <Joel.Becker@oracle.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [BUGFIX][PATCH v2 0/2] configfs: Fix cleanup after mkdir()
	failure
Message-ID: <20080716175654.GA19577@hawkmoon.kerlabs.com>
Reply-To: Louis.Rilling@kerlabs.com
References: <1215183366-17479-1-git-send-email-louis.rilling@kerlabs.com> <20080711220740.GC22577@mail.oracle.com> <20080716130821.GF3801@hawkmoon.kerlabs.com> <20080716172703.GA18105@ca-server1.us.oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_bohort-11417-1216230906-0001-2"
Content-Disposition: inline
In-Reply-To: <20080716172703.GA18105@ca-server1.us.oracle.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_bohort-11417-1216230906-0001-2
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 16, 2008 at 10:27:03AM -0700, Joel Becker wrote:
> On Wed, Jul 16, 2008 at 03:08:21PM +0200, Louis Rilling wrote:
> > There is still a few things in flight:
> > - error handling in config_*_init_type_name(): has rather low priority =
in my
> >   TODO list, will come back to it probably in a few weeks.
>=20
> 	I thought we did this already.  Perhaps I didn't include it?
> Did we have another change to make?

You requested me to move a BUG_ON() earlier (before the actual memory
allocation), and to update documentation. I'm quite in a hurry on other thi=
ngs,
so I'm delaying this (especially the documentation part for which I feel li=
ke a
new paragraph is needed).

>=20
> > - a small locking cleanup in configfs_rmdir(): will do at the same time=
 as
> >   lockdep stuff.
>=20
> 	What sort of change?  I suppose I'll see it when it arrives.

You may look at the retry loop in configfs_rmdir() and see=A0that locks nee=
d only
to be taken inside the loop, not outside. This would result in fewer lines =
for
exactly the same behavior.

> 	I figure this new stuff will probably miss the .27 window, but
> it sounds like that's fine - nothing too serious, and it will make .28.

Sorry for not being responsive enough. As mentioned above, I have more urge=
nt
things to work on right now.

Thanks,

Louis

--=20
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

--=_bohort-11417-1216230906-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIfjZmVKcRuvQ9Q1QRAp1HAKCYKCwF3HDpy+YsL+nqfN1rJzLQcwCgzzOp
fzY32aZdJ84ZEcczQHxySgI=
=2/uW
-----END PGP SIGNATURE-----

--=_bohort-11417-1216230906-0001-2--
