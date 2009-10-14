Return-Path: <linux-kernel-owner+w=401wt.eu-S1751211AbZJNEUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751211AbZJNEUq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 00:20:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750982AbZJNEUp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 00:20:45 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:51465 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750765AbZJNEUo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 00:20:44 -0400
Date: Wed, 14 Oct 2009 15:20:00 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "David S. Miller" <davem@davemloft.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: linux-next: net tree build warnings
Message-Id: <20091014152000.15312908.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__14_Oct_2009_15_20_00_+1100_KonpCOOA996HHN6Q"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__14_Oct_2009_15_20_00_+1100_KonpCOOA996HHN6Q
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

Today's linux-next build (powerpc ppc44x_defconfig) produced these
warnings:

In file included from net/socket.c:94:
include/net/compat.h:45: warning: 'struct compat_mmsghdr' declared inside p=
arameter list
include/net/compat.h:45: warning: its scope is only this definition or decl=
aration, which is probably not what you want
In file included from net/core/scm.c:36:
include/net/compat.h:45: warning: 'struct compat_mmsghdr' declared inside p=
arameter list
include/net/compat.h:45: warning: its scope is only this definition or decl=
aration, which is probably not what you want
In file included from net/ipv4/ip_sockglue.c:37:
include/net/compat.h:45: warning: 'struct compat_mmsghdr' declared inside p=
arameter list
include/net/compat.h:45: warning: its scope is only this definition or decl=
aration, which is probably not what you want
In file included from net/ipv6/ipv6_sockglue.c:53:
include/net/compat.h:45: warning: 'struct compat_mmsghdr' declared inside p=
arameter list
include/net/compat.h:45: warning: its scope is only this definition or decl=
aration, which is probably not what you want

CONFIG_COMPAT is not set.

Caused by commit a2e2725541fad72416326798c2d7fa4dafb7d337 ("net:
Introduce recvmmsg socket syscall").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__14_Oct_2009_15_20_00_+1100_KonpCOOA996HHN6Q
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkrVUXAACgkQjjKRsyhoI8yLAACfTxhMS1cfJWwFvR0t3AiL0fae
64YAn0quNkFMDkp8lnFoYIuZUJvODx8h
=S7QU
-----END PGP SIGNATURE-----

--Signature=_Wed__14_Oct_2009_15_20_00_+1100_KonpCOOA996HHN6Q--
