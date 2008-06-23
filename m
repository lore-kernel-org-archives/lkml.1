Return-Path: <linux-kernel-owner+w=401wt.eu-S1755838AbYFWMGA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838AbYFWMGA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 08:06:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753010AbYFWMFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 08:05:52 -0400
Received: from bohort.kerlabs.com ([62.160.40.57]:45923 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787AbYFWMFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 08:05:51 -0400
Date: Mon, 23 Jun 2008 14:05:49 +0200
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: Joel Becker <Joel.Becker@oracle.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH] configfs: Fix failing symlink() making rmdir() fail
Message-ID: <20080623120548.GT30804@localhost>
Reply-To: Louis.Rilling@kerlabs.com
References: <20080619221605.GE10888@mail.oracle.com> <1213963762-11678-1-git-send-email-louis.rilling@kerlabs.com> <20080620224420.GF21416@mail.oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_bohort-6583-1214222656-0001-2"
Content-Disposition: inline
In-Reply-To: <20080620224420.GF21416@mail.oracle.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_bohort-6583-1214222656-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 20, 2008 at 03:44:20PM -0700, Joel Becker wrote:
> On Fri, Jun 20, 2008 at 02:09:22PM +0200, Louis Rilling wrote:
> > What about this other solution? By the way, it does not even need to
> > rename CONFIGFS_USET_IN_MKDIR.
>=20
> 	We don't need the check for USET_DROPPING either.  I like a lot!

I hope that you wasn't speaking about checking USET_DROPPING on the target.=
 We
still need to check it, of course. I'm resending the updated, hopefully fin=
al,
patchset.

Louis

--=20
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

--=_bohort-6583-1214222656-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIX5GcVKcRuvQ9Q1QRApfwAKCOXgWUX+MXZBHGuwgzZlnaFXj10QCgiG3O
oV5X0Tw4s4nGny0IWbADMrU=
=4DoZ
-----END PGP SIGNATURE-----

--=_bohort-6583-1214222656-0001-2--
