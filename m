Return-Path: <linux-kernel-owner+w=401wt.eu-S1756538AbYFXNa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756538AbYFXNa0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 09:30:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752674AbYFXNaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 09:30:13 -0400
Received: from bohort.kerlabs.com ([62.160.40.57]:48308 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705AbYFXNaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 09:30:12 -0400
Date: Tue, 24 Jun 2008 15:30:10 +0200
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: Joel Becker <Joel.Becker@oracle.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH 0/5][BUGFIX] configfs: Fix deadlock of rename() vs
	rmdir()
Message-ID: <20080624133010.GG7621@hawkmoon.kerlabs.com>
Reply-To: Louis.Rilling@kerlabs.com
References: <20080616170057.399713501@kerlabs.com> <20080616232657.GE6441@mail.oracle.com> <20080623223450.GH592@mail.oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_bohort-24437-1214314117-0001-2"
Content-Disposition: inline
In-Reply-To: <20080623223450.GH592@mail.oracle.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_bohort-24437-1214314117-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 23, 2008 at 03:34:50PM -0700, Joel Becker wrote:
> On Mon, Jun 16, 2008 at 04:26:57PM -0700, Joel Becker wrote:
> > 	Ok, this is in-tree for the next merge.  Thanks.
>=20
> 	Btw, we still need to solve the lockdep issue.  I'm leaning
> towards turning it off for attach/detach_groups(), because any CHILD+N
> level won't mesh with the VFS anyway.

Yes, and the same for depend_prep()/depend_rollback().

> 	We also need a comment on detach_group() pointing out its
> recursive locking.  It's there in the code, but it's not obvious.

Will do all of this after we are sure not to change things again (see my
separate email on a possible bug in attach_group()).

Louis

--=20
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

--=_bohort-24437-1214314117-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIYPbiVKcRuvQ9Q1QRApvjAJ9eXvHFmd2phiI/Tl/5EA0wLToERgCdEOkS
ha+316wTa3v9oA0ZG436i24=
=ueBh
-----END PGP SIGNATURE-----

--=_bohort-24437-1214314117-0001-2--
