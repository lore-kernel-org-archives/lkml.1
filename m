Return-Path: <linux-kernel-owner+w=401wt.eu-S1754583AbYHMLm2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583AbYHMLm2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 07:42:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752337AbYHMLmT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 07:42:19 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:33815 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751848AbYHMLmS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 07:42:18 -0400
Date: Wed, 13 Aug 2008 21:42:10 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for August 13
Message-Id: <20080813214210.02609f00.sfr@canb.auug.org.au>
In-Reply-To: <s5h7ial9nvm.wl%tiwai@suse.de>
References: <20080813172452.14b0775c.sfr@canb.auug.org.au>
	<s5h7ial9nvm.wl%tiwai@suse.de>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__13_Aug_2008_21_42_10_+1000_D1xg+CoQq=w=GMKW"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__13_Aug_2008_21_42_10_+1000_D1xg+CoQq=w=GMKW
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Takashi,

On Wed, 13 Aug 2008 13:05:01 +0200 Takashi Iwai <tiwai@suse.de> wrote:
>
> I got a problem regarding tty with today's tree.
> When re-starting X, it complains that it cannot change to VT7.
> Via strace,=20
>=20
>   open("/dev/tty0", O_WRONLY)             =3D 7
>   ioctl(7, VIDIOC_QUERYCAP or VT_OPENQRY, 0x81e80c4) =3D 0
>   close(7)                                =3D 0
>   write(0, "(--) using VT number 7\n\n", 24) =3D 24
>   getppid()                               =3D 3240
>   getpgid(0xca8)                          =3D 3240
>   setpgid(0, 3240)                        =3D 0
>   setsid()                                =3D 3241
>   open("/dev/vc/7", O_RDWR|O_NONBLOCK)    =3D -1 ENOENT (No such file or =
directory)
>   open("/dev/tty7", O_RDWR|O_NONBLOCK)    =3D -1 EIO (Input/output error)
>   write(2, "\nFatal server error:\n", 21) =3D 21
>=20
> A similar error can be seen at shutdown, complains about the tty error
> and the halt process hangs up.
>=20
> Unfortunately it's hard to bisect since Aug 11 and Aug 12 trees don't
> boot, and Aug 8 tree has a problem regarding cred...

But does -rc3 work?  If so, then could you bisect from there to
next-20080813?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__13_Aug_2008_21_42_10_+1000_D1xg+CoQq=w=GMKW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkiiyJIACgkQjjKRsyhoI8yKRgCfbJo9G9TciKeg42aINo4uQPTJ
k2kAn0NzLvpArO863ZCVnvoPyIVH+HIt
=HkOi
-----END PGP SIGNATURE-----

--Signature=_Wed__13_Aug_2008_21_42_10_+1000_D1xg+CoQq=w=GMKW--
