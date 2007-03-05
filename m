Return-Path: <linux-kernel-owner+w=401wt.eu-S933047AbXCEPYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933047AbXCEPYQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 10:24:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932928AbXCEPYQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 10:24:16 -0500
Received: from mx1.redhat.com ([66.187.233.31]:53671 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932458AbXCEPYO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 10:24:14 -0500
Message-ID: <45EC3253.2030206@redhat.com>
Date: Mon, 05 Mar 2007 07:08:03 -0800
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@lazybastard.org>
CC: Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@infradead.org>,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Amit K. Arora" <aarora@linux.vnet.ibm.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, suparna@in.ibm.com, cmm@us.ibm.com,
       alex@clusterfs.com, suzuki@in.ibm.com
Subject: Re: [RFC] Heads up on sys_fallocate()
References: <20070117094658.GA17390@amitarora.in.ibm.com> <45EB4A55.3060908@redhat.com> <20070305001621.GB18691@lazybastard.org> <200703050136.37181.arnd@arndb.de> <20070305114109.GA454@lazybastard.org>
In-Reply-To: <20070305114109.GA454@lazybastard.org>
X-Enigmail-Version: 0.94.1.2.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigCB77F626157931776D7FF5C3"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigCB77F626157931776D7FF5C3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

J=C3=B6rn Engel wrote:
> Does the allocation have to be persistent beyond lifetime of the file
> descriptor?

Of course.  You call posix_fallocate once for the lifetime of the file
when it is created to ensure that all future uses will work.

It seems your filesystem will not be able to support this unless
compression is turned off.

--=20
=E2=9E=A7 Ulrich Drepper =E2=9E=A7 Red Hat, Inc. =E2=9E=A7 444 Castro St =
=E2=9E=A7 Mountain View, CA =E2=9D=96


--------------enigCB77F626157931776D7FF5C3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFF7DJU2ijCOnn/RHQRAikNAKCSTITOxrvZjN+2zjXT+Hlk1qsP7QCfdX9J
DjbOV19q8j1ZZbkFb/RYBpA=
=+gzR
-----END PGP SIGNATURE-----

--------------enigCB77F626157931776D7FF5C3--
