Return-Path: <linux-kernel-owner+w=401wt.eu-S1756171AbYLDMqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171AbYLDMqj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 07:46:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752056AbYLDMqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 07:46:13 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:39353 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752034AbYLDMqL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 07:46:11 -0500
Date: Thu, 4 Dec 2008 23:46:03 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Christoph Hellwig <hch@infradead.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       Eric Sandeen <sandeen@sandeen.net>, Christoph Hellwig <hch@lst.de>,
       Lachlan McIlroy <lachlan@sgi.com>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: XFS breakage on m68k (was: Re: linux-next: Tree for December 3)
Message-Id: <20081204234603.b5a28cd6.sfr@canb.auug.org.au>
In-Reply-To: <20081204121330.GA18815@infradead.org>
References: <20081203183602.c06f8c39.sfr@canb.auug.org.au>
	<Pine.LNX.4.64.0812040956370.10635@anakin>
	<20081204121330.GA18815@infradead.org>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__4_Dec_2008_23_46_03_+1100_Y4i_FBnC6Lw+PbDs"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__4_Dec_2008_23_46_03_+1100_Y4i_FBnC6Lw+PbDs
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Christoph,

On Thu, 4 Dec 2008 07:13:30 -0500 Christoph Hellwig <hch@infradead.org> wro=
te:
>
> On Thu, Dec 04, 2008 at 10:02:15AM +0100, Geert Uytterhoeven wrote:
> > On Wed, 3 Dec 2008, Stephen Rothwell wrote:
> > > Status of my local build tests will be at
> > > http://kisskb.ellerman.id.au/linux-next .  If maintainers want to give
> > > advice about cross compilers/configs that work, we are always open to=
 add
> > > more builds.
> >=20
> > On m68k (32-bit only, no compat32), XFS fails to build in linux-next:
>=20
> Yeah, it's broken on all 32bit platforms.  Today's xfs tree has a fix
> for it.

I tried that tree but got this error from a powerpc ppc64_defconfig build
(which is 64 bit):

fs/xfs/linux-2.6/xfs_file.c:365: error: 'xfs_file_compat_invis_ioctl' undec=
lared here (not in a function)

Eric mentioned that your patch "had a problem of its own", so I assumed
that was it and left it removed from today's linux-next.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__4_Dec_2008_23_46_03_+1100_Y4i_FBnC6Lw+PbDs
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkk30QsACgkQjjKRsyhoI8x5WACgmRsYcHOOMlUMk0zCz8iRXkm5
OB4An3bYWlAaP8j5dF+vffc9iKvlEtmh
=YjVi
-----END PGP SIGNATURE-----

--Signature=_Thu__4_Dec_2008_23_46_03_+1100_Y4i_FBnC6Lw+PbDs--
