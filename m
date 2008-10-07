Return-Path: <linux-kernel-owner+w=401wt.eu-S1754133AbYJGL3y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133AbYJGL3y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 07:29:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752860AbYJGL3q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 07:29:46 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:6320 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781AbYJGL3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 07:29:46 -0400
Date: Tue, 7 Oct 2008 14:30:51 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Ingo Molnar <mingo@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH, RFC] shmat: introduce flag SHM_MAP_HINT
Message-ID: <20081007113050.GD5126@localhost.localdomain>
References: <20081007195837.5A6B.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20081007112119.GG20740@one.firstfloor.org> <20081007202127.5A74.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AbQceqfdZEv+FvjW"
Content-Disposition: inline
In-Reply-To: <20081007202127.5A74.KOSAKI.MOTOHIRO@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-29)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AbQceqfdZEv+FvjW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 07, 2008 at 08:26:03PM +0900, KOSAKI Motohiro wrote:
> > > Honestly, I don't like that qemu specific feature insert into shmem c=
ore.
> >=20
> > I wouldn't say it's a qemu specific interface.  While qemu would=20
> > be the first user I would expect more in the future. It's a pretty
> > obvious extension. In fact it nearly should be default, if the
> > risk of breaking old applications wasn't too high.
>=20
> hm, ok, i understand your intension.
> however, I think following code isn't self describing.
>=20
> 	addr =3D shmat(shmid, addr, SHM_MAP_HINT);
>=20
> because HINT is too generic word.
> I think we should find better word.
>=20
> SHM_MAP_NO_FIXED ?

I like it.
Andi?

--=20
Regards,  Kirill A. Shutemov
 + Belarus, Minsk
 + ALT Linux Team, http://www.altlinux.com/

--AbQceqfdZEv+FvjW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkjrSGoACgkQbWYnhzC5v6oIrQCePh44jlU2+Rsdcpbw64WI3ejV
/2EAnjCuatvL6n54pDz+8YlsAgJ+OK2i
=FF+l
-----END PGP SIGNATURE-----

--AbQceqfdZEv+FvjW--
