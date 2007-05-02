Return-Path: <linux-kernel-owner+w=401wt.eu-S1767177AbXEBW4p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767177AbXEBW4p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 18:56:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767138AbXEBW4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 18:56:45 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60623 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767177AbXEBW4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 18:56:44 -0400
Message-ID: <4639171A.3050004@redhat.com>
Date: Wed, 02 May 2007 15:56:26 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Why ssse3?
References: <46391392.4070706@redhat.com> <200705030046.07152.ak@suse.de>
In-Reply-To: <200705030046.07152.ak@suse.de>
X-Enigmail-Version: 0.94.3.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig15DE4C6F75EBEF8CD656A160"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig15DE4C6F75EBEF8CD656A160
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Andi Kleen wrote:
> Nope. SSE3 !=3D SSSE3. The additional S means Supplemential.
>=20
> It's probably because the few changes didn't justify a SSE4

OK, the problem is that the actual sse3 bit is misnamed.  According to
Intel's docs bit 0 of ECX is "sse", the kernel uses "pni".  Too bad.

--=20
=E2=9E=A7 Ulrich Drepper =E2=9E=A7 Red Hat, Inc. =E2=9E=A7 444 Castro St =
=E2=9E=A7 Mountain View, CA =E2=9D=96


--------------enig15DE4C6F75EBEF8CD656A160
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFGORca2ijCOnn/RHQRAgqMAJ9UzpLqOxZEE5PBIAvtjNtl7xZhLgCfYArG
AwUCq7wXEMAIVcHljcSAEPs=
=DBbY
-----END PGP SIGNATURE-----

--------------enig15DE4C6F75EBEF8CD656A160--
