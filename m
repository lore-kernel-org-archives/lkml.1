Return-Path: <linux-kernel-owner+w=401wt.eu-S1753094Ab0ADMjJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753094Ab0ADMjJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 07:39:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752244Ab0ADMjG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 07:39:06 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:49302 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219Ab0ADMjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 07:39:04 -0500
Date: Mon, 4 Jan 2010 12:38:58 +0000
From: Eric B Munson <ebmunson@us.ibm.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>, David Howells <dhowells@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm: move sys_mmap_pgoff from util.c
Message-ID: <20100104123858.GA5045@us.ibm.com>
References: <alpine.LSU.2.00.0912302009040.30390@sister.anvils>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NzB8fVQJ5HfG6fxh"
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.0912302009040.30390@sister.anvils>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 30 Dec 2009, Hugh Dickins wrote:

> Move sys_mmap_pgoff() from mm/util.c to mm/mmap.c and mm/nommu.c,
> where we'd expect to find such code: especially now that it contains
> the MAP_HUGETLB handling.  Revert mm/util.c to how it was in 2.6.32.
>=20
> This patch just ignores MAP_HUGETLB in the nommu case, as in 2.6.32,
> whereas 2.6.33-rc2 reported -ENOSYS.  Perhaps validate_mmap_request()
> should reject it with -EINVAL?  Add that later if necessary.
>=20
> Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>

I think that -ENOSYS is the correcet response in the nommu case, but
I that can be added in a later patch.

Acked-by: Eric B Munson <ebmunson@us.ibm.com>

--NzB8fVQJ5HfG6fxh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAktB4WIACgkQsnv9E83jkzrx6gCfVC8k0PisgYMmLXl7JWGdiZfc
SnMAoIOoLNpwp9IzaEWBZErmlyO4gwL/
=t3b1
-----END PGP SIGNATURE-----

--NzB8fVQJ5HfG6fxh--
