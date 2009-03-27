Return-Path: <linux-kernel-owner+w=401wt.eu-S1757144AbZC0OQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757144AbZC0OQv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 10:16:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755385AbZC0OQj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 10:16:39 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:50886 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752351AbZC0OQi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 10:16:38 -0400
Date: Sat, 28 Mar 2009 01:16:26 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] btrfs: fix __ucmpdi2 compile bug on 32 bit builds
Message-Id: <20090328011626.5d6f94f4.sfr@canb.auug.org.au>
In-Reply-To: <20090327134252.0f24773b@osiris.boeblingen.de.ibm.com>
References: <20090327134252.0f24773b@osiris.boeblingen.de.ibm.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__28_Mar_2009_01_16_26_+1100_WHulv8ILr9rWv=Yw"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__28_Mar_2009_01_16_26_+1100_WHulv8ILr9rWv=Yw
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Heiko,

On Fri, 27 Mar 2009 13:42:52 +0100 Heiko Carstens <heiko.carstens@de.ibm.co=
m> wrote:
>
\> @@ -2884,25 +2884,19 @@ int extent_fiemap(struct inode *inode, s
>  		disko =3D 0;
>  		flags =3D 0;
> =20
> -		switch (em->block_start) {
> -		case EXTENT_MAP_LAST_BYTE:
> +		if (em->block_start =3D=3D EXTENT_MAP_LAST_BYTE) {

I might be a good idea to put a comment there about why this isn't a
switch statement so that someone doesn't "clean up" this code in the
future.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__28_Mar_2009_01_16_26_+1100_WHulv8ILr9rWv=Yw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAknM37oACgkQjjKRsyhoI8xmDQCgmCDESZmBdT+/RT1OOj1N1Xsi
MxYAoLtIThEDTp+WnvAMRqLeICyioMDO
=z4zk
-----END PGP SIGNATURE-----

--Signature=_Sat__28_Mar_2009_01_16_26_+1100_WHulv8ILr9rWv=Yw--
