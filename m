Return-Path: <linux-kernel-owner+w=401wt.eu-S1754375AbYIJLtE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754375AbYIJLtE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 07:49:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752135AbYIJLsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 07:48:53 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:27101 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbYIJLsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 07:48:52 -0400
Date: Wed, 10 Sep 2008 14:49:24 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-ext4@vger.kernel.org, David Howells <dhowells@redhat.com>,
       Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] include <linux/fs.h> into linux/ext2_fs.h
Message-ID: <20080910114923.GC3757@localhost.localdomain>
References: <1221045726-5674-1-git-send-email-kirill@shutemov.name> <20080910112709.GA11742@infradead.org> <20080910114011.GB3757@localhost.localdomain> <20080910114042.GA15996@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1SQmhf2mF2YjsYvc"
Content-Disposition: inline
In-Reply-To: <20080910114042.GA15996@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-29)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1SQmhf2mF2YjsYvc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 10, 2008 at 07:40:42AM -0400, Christoph Hellwig wrote:
> On Wed, Sep 10, 2008 at 02:40:12PM +0300, Kirill A. Shutemov wrote:
> > On Wed, Sep 10, 2008 at 07:27:09AM -0400, Christoph Hellwig wrote:
> > > On Wed, Sep 10, 2008 at 02:22:03PM +0300, Kirill A. Shutemov wrote:
> > > > linux/fs.h defines FS_IOC* needed by linux/ext2_fs.h
> > >=20
> > > And who cares? =20

Do you think it isn't error?

> > It breaks building pam_mktemp at least.
>=20
> pam_mktemp should not use <linux/ext2_fs.h>, but rather
> <ext2fs/ext2_fs.h>.

Why linux/ext2_fs.h does export to userspace?


--=20
Regards,  Kirill A. Shutemov
 + Belarus, Minsk
 + ALT Linux Team, http://www.altlinux.com/

--1SQmhf2mF2YjsYvc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkjHtEMACgkQbWYnhzC5v6rh5gCdGdIT0xkimZvRmRPEUmyWi14d
jn8An2zHJUEBabtmUzfo6Agr5f1t9eDt
=Efdu
-----END PGP SIGNATURE-----

--1SQmhf2mF2YjsYvc--
