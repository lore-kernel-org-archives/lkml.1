Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756802Ab0CKKdx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 05:33:53 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:34793 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756747Ab0CKKdt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 05:33:49 -0500
Date: Thu, 11 Mar 2010 21:33:42 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, Eric Miao <eric.y.miao@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kbuild: Do not unnecessarily regenerate modules.builtin
Message-Id: <20100311213342.82494e22.sfr@canb.auug.org.au>
In-Reply-To: <20100311081246.GA13932@sepie.suse.cz>
References: <1268047222-13218-1-git-send-email-mmarek@suse.cz>
	<20100311160326.bad1500e.sfr@canb.auug.org.au>
	<20100311081246.GA13932@sepie.suse.cz>
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.18.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__11_Mar_2010_21_33_42_+1100_2EIqKYGLWU_s3C=="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__11_Mar_2010_21_33_42_+1100_2EIqKYGLWU_s3C==
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Michal,

On Thu, 11 Mar 2010 09:12:46 +0100 Michal Marek <mmarek@suse.cz> wrote:
>
> On Thu, Mar 11, 2010 at 04:03:26PM +1100, Stephen Rothwell wrote:
> > This breaks a "make modules modules_install" type build:
> [...]
> > $ make O=3D../ntest.obj INSTALL_MOD_PATH=3D../ -s modules modules_insta=
ll
> > cp: cannot stat `/home/sfr/kernels/ntest.obj/modules.builtin': No such =
file or directory
>=20
> Andrew reported this yesterday, too. The followin patch should fix it
> (added to the for-next branch):

Great, thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__11_Mar_2010_21_33_42_+1100_2EIqKYGLWU_s3C==
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuYxwYACgkQjjKRsyhoI8x2oQCfRQLrExfiibiUq9oRuyUnmIZr
9KsAoIdUoSHIiJ2Ijflq0IyQjyQfEC1W
=Vpka
-----END PGP SIGNATURE-----

--Signature=_Thu__11_Mar_2010_21_33_42_+1100_2EIqKYGLWU_s3C==--
