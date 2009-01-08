Return-Path: <linux-kernel-owner+w=401wt.eu-S1763253AbZAHWXn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763253AbZAHWXn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 17:23:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756026AbZAHWXf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 17:23:35 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:35830 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752011AbZAHWXe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 17:23:34 -0500
Date: Fri, 9 Jan 2009 09:23:22 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: linux-next: Tree for January 8 (percpu)
Message-Id: <20090109092322.fd43b3b6.sfr@canb.auug.org.au>
In-Reply-To: <496636AB.9000903@oracle.com>
References: <20090108171730.19a41e14.sfr@canb.auug.org.au>
	<496636AB.9000903@oracle.com>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__9_Jan_2009_09_23_22_+1100_Yh5tKqj5SN8LCorI"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__9_Jan_2009_09_23_22_+1100_Yh5tKqj5SN8LCorI
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

(Forward to Rusty)

On Thu, 08 Jan 2009 09:23:55 -0800 Randy Dunlap <randy.dunlap@oracle.com> w=
rote:
>
> Stephen Rothwell wrote:
> > Hi all,
> >=20
> > Changes since 20090107:
> >=20
> > Undropped tree:
> > 	rr
> >=20
> > Dropped trees (temporarily):
> > 	ocfs2 (build problem)
> > 	cpu_alloc (build problem)
>=20
>=20
> When CONFIG_SMP=3Dn, both arch/x86/include/asm/percpu.h and
> include/asm-generic/percpu.h define both of
> read_percpu_ptr() and read_percpu_var().
>=20
>=20
> build-r8079.out:linux-next-20090108/include/asm-generic/percpu.h:124:1: w=
arning: "read_percpu_ptr" redefined
> build-r8079.out:linux-next-20090108/arch/x86/include/asm/percpu.h:107:1: =
warning: this is the location of the previous definition
> build-r8079.out:linux-next-20090108/include/asm-generic/percpu.h:120:1: w=
arning: "read_percpu_var" redefined
> build-r8079.out:linux-next-20090108/arch/x86/include/asm/percpu.h:106:1: =
warning: this is the location of the previous definition
>=20
>=20
>=20
> --=20
> ~Randy
>=20


--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__9_Jan_2009_09_23_22_+1100_Yh5tKqj5SN8LCorI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAklmfNoACgkQjjKRsyhoI8yH6ACeJM+3wDXiHGkPodUJfnLSdXk7
xwkAoLg+thAsDdcavPHEtGLV0578nN+r
=rK6C
-----END PGP SIGNATURE-----

--Signature=_Fri__9_Jan_2009_09_23_22_+1100_Yh5tKqj5SN8LCorI--
