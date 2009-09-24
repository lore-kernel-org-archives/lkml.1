Return-Path: <linux-kernel-owner+w=401wt.eu-S1752233AbZIXLvl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233AbZIXLvl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 07:51:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751633AbZIXLvj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 07:51:39 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:34342 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196AbZIXLvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 07:51:39 -0400
Date: Thu, 24 Sep 2009 05:51:38 -0600
From: Eric B Munson <ebmunson@us.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, akpm@linux-foundation.org, rientjes@google.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HugeTLB: Fix unused variable warning
Message-ID: <20090924115138.GA7136@us.ibm.com>
References: <20090924100232.19291.70594.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Qxx1br4bt0+wmkIi"
Content-Disposition: inline
In-Reply-To: <20090924100232.19291.70594.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Qxx1br4bt0+wmkIi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 24 Sep 2009, David Howells wrote:

> Fix an unused variable warning:
>=20
> 	mm/mmap.c: In function 'do_mmap_pgoff':
> 	mm/mmap.c:953: warning: unused variable 'user'
>=20
> by converting the CONFIG_HUGETLBFS=3Dn version of hugetlb_file_setup() in=
to an
> inline function instead of a macro.
>=20
> Introduced by:
>=20
> 	commit 4e52780d41a741fb4861ae1df2413dd816ec11b1
> 	Author: Eric B Munson <ebmunson@us.ibm.com>
> 	Date:   Mon Sep 21 17:03:47 2009 -0700
> 	hugetlb: add MAP_HUGETLB for mmaping pseudo-anonymous huge page regions
>=20
> Signed-off-by: David Howells <dhowells@redhat.com>

Acked-by: Eric B Munson <ebmunson@us.ibm.com>

--Qxx1br4bt0+wmkIi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkq7XUoACgkQsnv9E83jkzr3bgCgtodtSjx/+aJBl7VqyIZwByrJ
JgMAoOionyk73oBmBZdc/iWndzUCkhmD
=hWda
-----END PGP SIGNATURE-----

--Qxx1br4bt0+wmkIi--
