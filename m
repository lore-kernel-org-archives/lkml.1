Return-Path: <linux-kernel-owner+w=401wt.eu-S1758554AbYGDQcw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758554AbYGDQcw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 12:32:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754041AbYGDQcn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 12:32:43 -0400
Received: from bohort.kerlabs.com ([62.160.40.57]:52795 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754070AbYGDQcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 12:32:42 -0400
Date: Fri, 4 Jul 2008 18:32:40 +0200
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: Joel Becker <Joel.Becker@oracle.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [BUGFIX][PATCH v2 0/2] configfs: Fix cleanup after mkdir()
	failure
Message-ID: <20080704163240.GQ30545@hawkmoon.kerlabs.com>
Reply-To: Louis.Rilling@kerlabs.com
References: <1215183366-17479-1-git-send-email-louis.rilling@kerlabs.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_bohort-9550-1215189060-0001-2"
Content-Disposition: inline
In-Reply-To: <1215183366-17479-1-git-send-email-louis.rilling@kerlabs.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_bohort-9550-1215189060-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Joel,

Sorry for posting to a wrong address (really fun to see you working at Kerl=
abs
;)). I've just discovered that git-send-email is case-sensitive with email
aliases while mutt is not...

Cheers,

Louis

On Fri, Jul 04, 2008 at 04:56:04PM +0200, Louis Rilling wrote:
>  [ applies on top of http://lkml.org/lkml/2008/6/23/145 aka symlink() fix=
es ]
>=20
> Hi,
>=20
> This patchset fixes two kinds of bugs happening when
> configfs_attach_group()/configfs_attach_item() fail and userspace races w=
ith
> mkdir() or symlink().
>=20
> Please read the first patch header for a detailed scenario explaining the=
 bugs.
>=20
> Louis
>=20
> Changelog:
>   - Few code reworks as requested by Joel (details in patch headers)
>=20
> Summary (2):
>   configfs: Prevent userspace from creating new entries under attaching
>     directories
>   configfs: Lock new directory inodes before removing on cleanup after
>     failure
>=20
>  fs/configfs/configfs_internal.h |    2 +
>  fs/configfs/dir.c               |  141 ++++++++++++++++++++++++++++++++-=
------
>  fs/configfs/symlink.c           |   15 ++++
>  3 files changed, 133 insertions(+), 25 deletions(-)
>=20
> --=20
> Dr Louis Rilling			Kerlabs
> Skype: louis.rilling			Batiment Germanium
> Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
> http://www.kerlabs.com/			35700 Rennes
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--=20
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

--=_bohort-9550-1215189060-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIblCoVKcRuvQ9Q1QRAtTZAKDGqDjmxrVLK85W9cZwBrGltJzJtACg0eCc
gt+3Hy5cu9JBrFWoFkXJxvE=
=/y9I
-----END PGP SIGNATURE-----

--=_bohort-9550-1215189060-0001-2--
