Return-Path: <linux-kernel-owner+w=401wt.eu-S1757338AbYGPNIc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757338AbYGPNIc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 09:08:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755185AbYGPNIY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 09:08:24 -0400
Received: from bohort.kerlabs.com ([62.160.40.57]:56815 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753608AbYGPNIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 09:08:23 -0400
Date: Wed, 16 Jul 2008 15:08:21 +0200
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: Joel Becker <Joel.Becker@oracle.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [BUGFIX][PATCH v2 0/2] configfs: Fix cleanup after mkdir()
	failure
Message-ID: <20080716130821.GF3801@hawkmoon.kerlabs.com>
Reply-To: Louis.Rilling@kerlabs.com
References: <1215183366-17479-1-git-send-email-louis.rilling@kerlabs.com> <20080711220740.GC22577@mail.oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_bohort-7428-1216213593-0001-2"
Content-Disposition: inline
In-Reply-To: <20080711220740.GC22577@mail.oracle.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_bohort-7428-1216213593-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 11, 2008 at 03:07:40PM -0700, Joel Becker wrote:
> On Fri, Jul 04, 2008 at 04:56:04PM +0200, Louis Rilling wrote:
> > This patchset fixes two kinds of bugs happening when
> > configfs_attach_group()/configfs_attach_item() fail and userspace races=
 with
> > mkdir() or symlink().
>=20
> 	Ok, I've merged all this work.  Please check out my configfs-ALL
> branch and make sure I have everything we've worked on.
>=20
> http://oss.oracle.com/git/?p=3Djlbec/linux-2.6.git;a=3Dshortlog;h=3Dconfi=
gfs-ALL
> git://oss.oracle.com/git/jlbec/linux-2.6.git configfs-ALL

Looks complete.

There is still a few things in flight:
- error handling in config_*_init_type_name(): has rather low priority in my
  TODO list, will come back to it probably in a few weeks.
- silencing lockdep: hope to get something in the next few days.
- a small locking cleanup in configfs_rmdir(): will do at the same time as
  lockdep stuff.

Thanks,

Louis

--=20
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

--=_bohort-7428-1216213593-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIffLFVKcRuvQ9Q1QRAtUQAKCozyGtaUNCuzcxu6lTUPE07ankNgCfQcbP
Ym64KbuceTtuhFqFuBgGF4w=
=IhNv
-----END PGP SIGNATURE-----

--=_bohort-7428-1216213593-0001-2--
