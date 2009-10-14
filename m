Return-Path: <linux-kernel-owner+w=401wt.eu-S1751772AbZJNEfh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751772AbZJNEfh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 00:35:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751640AbZJNEff
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 00:35:35 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:58897 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751588AbZJNEfd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 00:35:33 -0400
Date: Wed, 14 Oct 2009 15:34:50 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "David S. Miller" <davem@davemloft.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: linux-next: net tree build warnings
Message-Id: <20091014153450.3110e34c.sfr@canb.auug.org.au>
In-Reply-To: <20091014152000.15312908.sfr@canb.auug.org.au>
References: <20091014152000.15312908.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__14_Oct_2009_15_34_50_+1100_qD_BqPXM5SSBP9k8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__14_Oct_2009_15_34_50_+1100_qD_BqPXM5SSBP9k8
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Wed, 14 Oct 2009 15:20:00 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> Today's linux-next build (powerpc ppc44x_defconfig) produced these
> warnings:
>=20
> In file included from net/socket.c:94:
> include/net/compat.h:45: warning: 'struct compat_mmsghdr' declared inside=
 parameter list
> include/net/compat.h:45: warning: its scope is only this definition or de=
claration, which is probably not what you want
> In file included from net/core/scm.c:36:
> include/net/compat.h:45: warning: 'struct compat_mmsghdr' declared inside=
 parameter list
> include/net/compat.h:45: warning: its scope is only this definition or de=
claration, which is probably not what you want
> In file included from net/ipv4/ip_sockglue.c:37:
> include/net/compat.h:45: warning: 'struct compat_mmsghdr' declared inside=
 parameter list
> include/net/compat.h:45: warning: its scope is only this definition or de=
claration, which is probably not what you want
> In file included from net/ipv6/ipv6_sockglue.c:53:
> include/net/compat.h:45: warning: 'struct compat_mmsghdr' declared inside=
 parameter list
> include/net/compat.h:45: warning: its scope is only this definition or de=
claration, which is probably not what you want
>=20
> CONFIG_COMPAT is not set.
>=20
> Caused by commit a2e2725541fad72416326798c2d7fa4dafb7d337 ("net:
> Introduce recvmmsg socket syscall").

I also get these for i386 and sparc32 defconfig builds.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__14_Oct_2009_15_34_50_+1100_qD_BqPXM5SSBP9k8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkrVVOoACgkQjjKRsyhoI8zJZwCgo8rTBijcTHA/OsvPrnalcL+F
vyUAoIc3lZTKth1pjYoeofLqgtY5GZca
=etJO
-----END PGP SIGNATURE-----

--Signature=_Wed__14_Oct_2009_15_34_50_+1100_qD_BqPXM5SSBP9k8--
