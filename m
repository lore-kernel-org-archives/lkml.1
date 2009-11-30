Return-Path: <linux-kernel-owner+w=401wt.eu-S1753428AbZK3GlB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428AbZK3GlB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 01:41:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751077AbZK3GlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 01:41:00 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:54732 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751062AbZK3GlA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 01:41:00 -0500
Date: Mon, 30 Nov 2009 17:41:03 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: =?UTF-8?B?QW3DqXJpY28=?= Wang <xiyou.wangcong@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Vlad Yasevich <vladislav.yasevich@hp.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: linux-next: manual merge of the sysctl tree with the net tree
Message-Id: <20091130174103.b5c05570.sfr@canb.auug.org.au>
In-Reply-To: <2375c9f90911292151t2deb8530idd96ce50ced74d80@mail.gmail.com>
References: <20091130164415.f418834b.sfr@canb.auug.org.au>
	<2375c9f90911292151t2deb8530idd96ce50ced74d80@mail.gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__30_Nov_2009_17_41_03_+1100_qFiFGV4_U7LVuceV"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__30_Nov_2009_17_41_03_+1100_qFiFGV4_U7LVuceV
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Am=C3=A9rico,

On Mon, 30 Nov 2009 13:51:03 +0800 Am=C3=A9rico Wang <xiyou.wangcong@gmail.=
com> wrote:
>
> > diff --cc net/sctp/sysctl.c
> > index ae03ded,d50a042..0000000
> > --- a/net/sctp/sysctl.c
> > +++ b/net/sctp/sysctl.c
> > @@@ -285,19 -241,7 +242,17 @@@ static ctl_table sctp_table[] =3D
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.extra1 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =3D &zero,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.extra2 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =3D &addr_scope_max,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0},
> > =C2=A0+ =C2=A0 =C2=A0 =C2=A0{
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .ctl_name =C2=A0 =C2=
=A0 =C2=A0 =3D CTL_UNNUMBERED,
> > =C2=A0+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.procname =C2=
=A0 =C2=A0 =C2=A0 =3D "rwnd_update_shift",
> > =C2=A0+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.data =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =3D &sctp_rwnd_upd_shift,
> > =C2=A0+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.maxlen =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =3D sizeof(int),
> > =C2=A0+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.mode =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =3D 0644,
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .proc_handler =C2=A0=
 =3D &proc_dointvec_minmax,
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .strategy =C2=A0 =C2=
=A0 =C2=A0 =3D &sysctl_intvec,
> > ++ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.proc_handler =C2=A0=
 =3D proc_dointvec_minmax,
>=20
> Hey, what's this??

If you mean "what is this strange looking patch", then it is the output
from "git diff --cc" after a merge conflict has been fixed up, but before
it is committed.  The '-' lines were added by one side of the merge or
the other, but removed from the final result.  The line with '++' did not
appear in either branch, but is in the final result.  The lines with a
single '+' appear in one of the branches or the other and in the final
result as well.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__30_Nov_2009_17_41_03_+1100_qFiFGV4_U7LVuceV
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksTaP8ACgkQjjKRsyhoI8wjbgCeLjuuxQ/ooHyYmnMiOUwea2Ut
hesAnjP222rbFhxB/mO0UkxOGnZCvQf0
=GOPL
-----END PGP SIGNATURE-----

--Signature=_Mon__30_Nov_2009_17_41_03_+1100_qFiFGV4_U7LVuceV--
