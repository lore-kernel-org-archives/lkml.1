Return-Path: <linux-kernel-owner+w=401wt.eu-S1754195AbXJWQ7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195AbXJWQ7X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 12:59:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752199AbXJWQ7O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 12:59:14 -0400
Received: from partizan.velesys.com ([213.184.230.195]:59676 "EHLO
	partizan.velesys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425AbXJWQ7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 12:59:13 -0400
Date: Tue, 23 Oct 2007 19:59:52 +0300
From: "Kirill A. Shutemov" <k.shutemov@velesys.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Do not export PAGE_SIZE to userspace.
Message-ID: <20071023165951.GA5685@localhost.localdomain>
References: <20071023103304.GA10209@localhost.localdomain> <8bd0f97a0710230922t57699cc3o7f1eda45c488a053@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DocE+STaALJfprDB"
Content-Disposition: inline
In-Reply-To: <8bd0f97a0710230922t57699cc3o7f1eda45c488a053@mail.gmail.com>
X-Operating-System: ALT Linux Sisyphus (20070101) (Kernel
	2.6.18-std-smp-alt8)
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--DocE+STaALJfprDB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On [Tue, 23.10.2007 12:22], Mike Frysinger wrote:
> On 10/23/07, Kirill A. Shutemov <k.shutemov@velesys.com> wrote:
> > Userspace should use getpagesize() or sysconf(_SC_PAGESIZE) to get memo=
ry
> > page size.
>=20
> please go back through the archives and read the history here.  we
> should work at dropping page.h completely, not making it an empty
> file.

Do you mean page.h shouldn't be exported to userspace or should be dropped
=66rom kernelspace too?

--=20
Regards,  Kirill A. Shutemov
 + Belarus, Minsk
 + Velesys LLC, http://www.velesys.com/
 + ALT Linux Team, http://www.altlinux.com/

--DocE+STaALJfprDB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHHiiHbWYnhzC5v6oRAke6AKCPOvm5DkF3V28u1tEzDCQK7MIaAACdEIiq
6lcdhuzpNQpQUAVM4+/JXgI=
=Zd2m
-----END PGP SIGNATURE-----

--DocE+STaALJfprDB--
