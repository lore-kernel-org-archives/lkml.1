Return-Path: <linux-kernel-owner+w=401wt.eu-S1751295AbXBUO5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751295AbXBUO5Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 09:57:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751297AbXBUO5Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 09:57:24 -0500
Received: from lazybastard.de ([212.112.238.170]:55937 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbXBUO5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 09:57:23 -0500
Date: Wed, 21 Feb 2007 14:54:21 +0000
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: Vijay Sampath <vsampath@gmail.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>
Subject: Re: [PATCH] [MTD] CHIPS: oops in cfi_amdstd_sync
Message-ID: <20070221145420.GD464@lazybastard.org>
References: <758a2bbf0702201746p3959235ele3db9b600a9f8104@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KsGdsel6WgEHnImy"
Content-Disposition: inline
In-Reply-To: <758a2bbf0702201746p3959235ele3db9b600a9f8104@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 20 February 2007 17:46:13 -0800, Vijay Sampath wrote:
>=20
> The files cfi_cmdset_0002.c and cfi_cmdset_0020.c do not initialize
> their wait queues like is done in cfi_cmdset_0001.c. This causes an
> oops when the wait queue is accessed. I have copied the code from
> cfi_cmdset_0001.c that is pertinent to initialization of the wait
> queue.

Patch looks good, but I can no longer test it.  Josh may still have
access to some commandset 20 chips.  Josh, any objections?

J=C3=B6rn

--=20
The only real mistake is the one from which we learn nothing.
-- John Powell

--KsGdsel6WgEHnImy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFF3F0cfbqVtkXfjukRAgZ4AJ0ZhvnXphTMtxe/Nt5/0hXDe0EdxACeOwZN
+6XSKNg7CKkV1+2e5NvEtHo=
=qs7F
-----END PGP SIGNATURE-----

--KsGdsel6WgEHnImy--
