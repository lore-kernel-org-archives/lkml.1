Return-Path: <linux-kernel-owner+w=401wt.eu-S933518AbXCEPYd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933518AbXCEPYd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 10:24:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932963AbXCEPYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 10:24:32 -0500
Received: from mx1.redhat.com ([66.187.233.31]:53750 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932848AbXCEPYa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 10:24:30 -0500
Message-ID: <45EC32B2.1000802@redhat.com>
Date: Mon, 05 Mar 2007 07:09:38 -0800
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
References: <20070117094658.GA17390@amitarora.in.ibm.com> <1172789056.11165.42.camel@kleikamp.austin.ibm.com> <20070301233819.GB31072@infradead.org> <200703032345.33137.arnd@arndb.de> <0DA8B217-DDD4-4E05-B000-DEBE3BE55B94@cam.ac.uk> <45EB4A55.3060908@redhat.com> <20070305001621.GB18691@lazybastard.org> <CDA7A0DF-D744-416F-83B1-76C148B46A5F@cam.ac.uk> <20070305114945.GB454@lazybastard.org>
In-Reply-To: <20070305114945.GB454@lazybastard.org>
X-Enigmail-Version: 0.94.1.2.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig3DED4E7BCB80D8342A0D9A86"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig3DED4E7BCB80D8342A0D9A86
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

J=C3=B6rn Engel wrote:
> The bad news for posix_fallocate() is that even if libc is smart enough=

> to write random data, mmap() can still cause problems.

This is not smart, quite to the contrary.  The standard guarantees that
all not-yet-written-to places in the file are zero.  And if a block has
already been written posix_fallocate cannot change it.

--=20
=E2=9E=A7 Ulrich Drepper =E2=9E=A7 Red Hat, Inc. =E2=9E=A7 444 Castro St =
=E2=9E=A7 Mountain View, CA =E2=9D=96


--------------enig3DED4E7BCB80D8342A0D9A86
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFF7DKy2ijCOnn/RHQRAmODAKCG1Y6pSR7he9Nl3SMAN7RzQHoR1gCgmfRd
W3+WDlKW/x/J6f7fHH4KvMw=
=Jj6G
-----END PGP SIGNATURE-----

--------------enig3DED4E7BCB80D8342A0D9A86--
