Return-Path: <linux-kernel-owner+w=401wt.eu-S1756735AbXJJTub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756735AbXJJTub (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 15:50:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755533AbXJJTuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 15:50:24 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:37974 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755372AbXJJTuX (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 15:50:23 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Gustavo Chain <g@0xff.cl>
Cc: David Newall <david@davidnewall.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Reserve N process to root
In-Reply-To: Your message of "Wed, 10 Oct 2007 09:46:22 EDT."
             <20071010094622.7b8121cf@0xff.cl>
From: Valdis.Kletnieks@vt.edu
References: <20071009194820.6c8d6e8d@0xff.cl> <470C2FA7.5030207@davidnewall.com> <20071010011523.7d6cca12@0xff.cl> <470C66A6.2060801@davidnewall.com>
            <20071010094622.7b8121cf@0xff.cl>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1192045814_2784P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 10 Oct 2007 15:50:14 -0400
Message-ID: <27658.1192045814@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1192045814_2784P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

On Wed, 10 Oct 2007 09:46:22 EDT, Gustavo Chain said:
> El Wed, 10 Oct 2007 15:14:06 +0930
> David Newall <david=40davidnewall.com> escribi=F3:
> > That was what I thought you had in mind; it protects from some kind
> > of fork bomb, right?  But it doesn't seem useful unless you guarantee=
=20
> > having a process already running (with CAP_SYS_ADMIN) *before* the
> > bomb goes off.
>=20
> Not really, because fork bomb will never reach maximum pid possible.
> And root will always have a =22slot=22 to kill desired processes.

What David meant was that =22root will always have a slot=22 doesn't *act=
ually*
help unless you *also* have a way to actually *spawn* such a process.  In=
 order
to do the ps, kill, and so on that you need to recover, you need to alrea=
dy
have either a root shell available, or a way to *get* a root shell that d=
oesn't
rely on a non-root process (so /bin/su doesn't help here).

Many distros will leave a /sbin/mingetty running on tty1 through tty6, an=
d
you *can* use those to get a root shell.  David's point is that without
something like that already in place, the patch doesn't help....


--==_Exmh_1192045814_2784P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHDSz2cC3lWbTT17ARAipSAKDZFnvHSbNQnXt4kuvvqMSVIrLkXQCfe73o
qQtk5S60qmYu8JOV56nwPiQ=
=0ZO6
-----END PGP SIGNATURE-----

--==_Exmh_1192045814_2784P--
