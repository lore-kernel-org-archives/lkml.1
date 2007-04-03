Return-Path: <linux-kernel-owner+w=401wt.eu-S965654AbXDCRK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965654AbXDCRK3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 13:10:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965656AbXDCRK2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 13:10:28 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47802 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965654AbXDCRK2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 13:10:28 -0400
Message-ID: <46128A77.4080008@redhat.com>
Date: Tue, 03 Apr 2007 10:10:15 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Jakub Jelinek <jakub@redhat.com>
Subject: Re: missing madvise functionality
References: <46128051.9000609@redhat.com> <46128708.9030900@redhat.com>
In-Reply-To: <46128708.9030900@redhat.com>
X-Enigmail-Version: 0.94.3.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigF0A3BDF995F011D58844B357"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigF0A3BDF995F011D58844B357
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Rik van Riel wrote:
> I already started looking into implementing this.
>=20
> Basically:
> [...]

Sounds good.  Except:


> 1) on MADV_DONTNEED, mark pages clean, not accessed and move them
>    to some "dontneed" LRU list.

LRU is likely the wrong answer.  The longer a page has not been reused
the more likely it won't be.  So, the dontneed-list  should be a simple
FIFO.

--=20
=E2=9E=A7 Ulrich Drepper =E2=9E=A7 Red Hat, Inc. =E2=9E=A7 444 Castro St =
=E2=9E=A7 Mountain View, CA =E2=9D=96


--------------enigF0A3BDF995F011D58844B357
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFGEop32ijCOnn/RHQRAtxwAKCBUHkaxTVwh91ovGvDRg6wAM42wACgvSR7
NECukCED3otQdSOqejaOPXk=
=An8H
-----END PGP SIGNATURE-----

--------------enigF0A3BDF995F011D58844B357--
