Return-Path: <linux-kernel-owner+w=401wt.eu-S965744AbXDCRR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965744AbXDCRR1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 13:17:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965752AbXDCRR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 13:17:26 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50223 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965744AbXDCRR0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 13:17:26 -0400
Message-ID: <46128C1B.1090900@redhat.com>
Date: Tue, 03 Apr 2007 10:17:15 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: getting processor numbers
References: <461286D6.2040407@redhat.com> <p73abxpz5u1.fsf@bingen.suse.de>
In-Reply-To: <p73abxpz5u1.fsf@bingen.suse.de>
X-Enigmail-Version: 0.94.3.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig4218832C4AE76C3F90A5D6BD"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig4218832C4AE76C3F90A5D6BD
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Andi Kleen wrote:
> There was a proposal some time ago to put that into the ELF aux vector
> Unfortunately there was disagreement on what information to put=20
> there exactly (full topology, only limited numbers etc.)=20

Topology, yes, I'm likely in favor of it.

Processor number: no.  Unless you want to rip out hotpluging.  I'm
certainly in favor of that, it creates huge problems for  no real
benefit for the common use cases.  But as it is, the number of
processors is not necessarily constant over the lifetime of a process.
The machine architecture is.

--=20
=E2=9E=A7 Ulrich Drepper =E2=9E=A7 Red Hat, Inc. =E2=9E=A7 444 Castro St =
=E2=9E=A7 Mountain View, CA =E2=9D=96


--------------enig4218832C4AE76C3F90A5D6BD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFGEowb2ijCOnn/RHQRAvMdAJ0SwaiNwDpGGZk8ss1UgGwhMDiJsQCdGeht
ywQ+iKTnsoEAkj1txauAVxY=
=B/sj
-----END PGP SIGNATURE-----

--------------enig4218832C4AE76C3F90A5D6BD--
