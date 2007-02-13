Return-Path: <linux-kernel-owner+w=401wt.eu-S1751425AbXBMW7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751425AbXBMW7U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 17:59:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751421AbXBMW7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 17:59:20 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53086 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751425AbXBMW7T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 17:59:19 -0500
Message-ID: <45D242BB.9040004@redhat.com>
Date: Tue, 13 Feb 2007 14:59:07 -0800
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 00/11] ANNOUNCE: "Syslets", generic asynchronous system
 call support
References: <20070213142010.GA638@elte.hu> <Pine.LNX.4.64.0702131219240.32055@alien.or.mcafeemobile.com> <20070213215724.GD22104@elte.hu>
In-Reply-To: <20070213215724.GD22104@elte.hu>
X-Enigmail-Version: 0.94.1.2.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig57FCBB38D30A8E586E87CE7F"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig57FCBB38D30A8E586E87CE7F
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Ingo Molnar wrote:
> really, what's the point behind aio_cancel()?

- sequence

     aio_write()
     aio_cancel()
     aio_write()

  with both writes going to the same place must be predictably

- think beyond files.  Writes to sockets, ttys, they  can block and
cancel must abort them.  Even for files the same applies in some
situations, e.g., for network filesystems.

--=20
=E2=9E=A7 Ulrich Drepper =E2=9E=A7 Red Hat, Inc. =E2=9E=A7 444 Castro St =
=E2=9E=A7 Mountain View, CA =E2=9D=96


--------------enig57FCBB38D30A8E586E87CE7F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFF0kK72ijCOnn/RHQRAjp+AJ4iSwnqQXxv5YYefrVJH+D2drftVQCfSbl7
9QP7SL/NjouDB1zJtNFYfvA=
=0kry
-----END PGP SIGNATURE-----

--------------enig57FCBB38D30A8E586E87CE7F--
