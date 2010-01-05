Return-Path: <linux-kernel-owner+w=401wt.eu-S1754109Ab0AEMrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109Ab0AEMrY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 07:47:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753402Ab0AEMrX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 07:47:23 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:34633 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186Ab0AEMrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 07:47:21 -0500
Date: Tue, 5 Jan 2010 12:47:14 +0000
From: Eric B Munson <ebmunson@us.ibm.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>, David Howells <dhowells@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] nommu: reject MAP_HUGETLB
Message-ID: <20100105124714.GA6620@us.ibm.com>
References: <alpine.LSU.2.00.0912302009040.30390@sister.anvils>
 <20100104123858.GA5045@us.ibm.com>
 <alpine.LSU.2.00.1001051232530.1055@sister.anvils>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AhhlLboLdkugWU4S"
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1001051232530.1055@sister.anvils>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AhhlLboLdkugWU4S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 05 Jan 2010, Hugh Dickins wrote:

> We've agreed to restore the rejection of MAP_HUGETLB to nommu.
> Mimic what happens with mmu when hugetlb is not configured in:
> say -ENOSYS, but -EINVAL if MAP_ANONYMOUS was not given too.
>=20
> Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>

Acked-by: Eric B Munson <ebmunson@us.ibm.com>

--AhhlLboLdkugWU4S
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAktDNNIACgkQsnv9E83jkzov9QCgpLESFDrJNrx/RpS+jZvj/F/8
gx4AoJDMHW02SXGFtMZFpOQphDDTO5mN
=avtv
-----END PGP SIGNATURE-----

--AhhlLboLdkugWU4S--
