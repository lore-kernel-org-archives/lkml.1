Return-Path: <linux-kernel-owner+w=401wt.eu-S1754219AbYIJLju@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219AbYIJLju (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 07:39:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752219AbYIJLjm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 07:39:42 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:36631 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002AbYIJLjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 07:39:41 -0400
Date: Wed, 10 Sep 2008 14:40:12 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-ext4@vger.kernel.org, David Howells <dhowells@redhat.com>,
       Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] include <linux/fs.h> into linux/ext2_fs.h
Message-ID: <20080910114011.GB3757@localhost.localdomain>
References: <1221045726-5674-1-git-send-email-kirill@shutemov.name> <20080910112709.GA11742@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9zSXsLTf0vkW971A"
Content-Disposition: inline
In-Reply-To: <20080910112709.GA11742@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-29)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9zSXsLTf0vkW971A
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 10, 2008 at 07:27:09AM -0400, Christoph Hellwig wrote:
> On Wed, Sep 10, 2008 at 02:22:03PM +0300, Kirill A. Shutemov wrote:
> > linux/fs.h defines FS_IOC* needed by linux/ext2_fs.h
>=20
> And who cares? =20

It breaks building pam_mktemp at least.

It's regression introduced by commit 36695673b.

--=20
Regards,  Kirill A. Shutemov
 + Belarus, Minsk
 + ALT Linux Team, http://www.altlinux.com/

--9zSXsLTf0vkW971A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkjHshsACgkQbWYnhzC5v6rAZACeOu6dJN2J4FAU791UYghiVJMq
IYkAnAos59VGUJK+XW28DlY4lUF92c6h
=/YlD
-----END PGP SIGNATURE-----

--9zSXsLTf0vkW971A--
