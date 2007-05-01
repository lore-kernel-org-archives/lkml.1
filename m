Return-Path: <linux-kernel-owner+w=401wt.eu-S1422740AbXEAVIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422740AbXEAVIS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 17:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423608AbXEAVIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 17:08:18 -0400
Received: from mail4.sea5.speakeasy.net ([69.17.117.6]:49603 "EHLO
	mail4.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422740AbXEAVIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 17:08:16 -0400
X-Greylist: delayed 328 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 May 2007 17:08:16 EDT
Message-ID: <4637AC3D.6000008@freedesktop.org>
Date: Tue, 01 May 2007 14:08:13 -0700
From: Josh Triplett <josh@freedesktop.org>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: linux-sparse@vger.kernel.org, linux-kernel@vger.kernel.org
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>
Subject: sparse -Wptr-subtraction-blows: still needed?
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigB4918FE0C92B6DA879A8A310"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigB4918FE0C92B6DA879A8A310
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable


Sparse has a warning -Wptr-subtraction-blows (off by default) which gener=
ates
a warning for any pointer subtractions.  This warning relates to GCC
shortcomings observed in 2005; the original log message:

> commit 6889bd0f84939675c743229d6fe623513b95e057
> Author: Linus Torvalds <torvalds@ppc970.osdl.org>
> Date:   Fri Jan 7 15:06:24 2005 -0700
>
>     Add option "-Wptr-subtraction-blows" to warn about expensive
>     pointer subtractions.
>    =20
>     Not only does it generate bad code (that can often be rewritten
>     to not do that), it also causes gcc to go into horrible contortions=
,
>     and Al Viro reports that it can make a factor of 2.5 difference in
>     kernel build times to have just a few of these in common header
>     file inline functions.

Does this still apply?  Do current versions of GCC still have this proble=
m?
If not, can the option and warning go away?

- Josh Triplett


--------------enigB4918FE0C92B6DA879A8A310
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGN6w9GJuZRtD+evsRApgfAJwKYQfnnqh8Bfo5nCbHEt8Tkwb2RwCgg+gT
NqaAwXE0PwVwX8XcSe89rF0=
=v0VU
-----END PGP SIGNATURE-----

--------------enigB4918FE0C92B6DA879A8A310--
