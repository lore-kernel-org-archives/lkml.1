Return-Path: <linux-kernel-owner+w=401wt.eu-S934329AbYEUMwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934329AbYEUMwe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 08:52:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762701AbYEUMwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 08:52:24 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:42018 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760847AbYEUMwX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 08:52:23 -0400
Date: Wed, 21 May 2008 22:52:14 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       netfilter-devel@vger.kernel.org, apw@shadowen.org
Subject: Re: [PATCH] linux-next: Tree for May 21 - build failure with
 netfilter on __nf_ct_helper_find()
Message-Id: <20080521225214.507eb400.sfr@canb.auug.org.au>
In-Reply-To: <20080521113230.GA10830@linux.vnet.ibm.com>
References: <20080521155936.466bbe86.sfr@canb.auug.org.au>
	<20080521113230.GA10830@linux.vnet.ibm.com>
X-Mailer: Sylpheed 2.5.0beta3 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__21_May_2008_22_52_14_+1000_rBaH_X1/r62uLNH."
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__21_May_2008_22_52_14_+1000_rBaH_X1/r62uLNH.
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Kamalesh,

On Wed, 21 May 2008 17:02:30 +0530 Kamalesh Babulal <kamalesh@linux.vnet.ib=
m.com> wrote:
>
> The next-20080521 kernel build fails, on x86_64 machine=20
>=20
> CC net/netfilter/nf_conntrack_helper.o
> net/netfilter/nf_conntrack_helper.c: In function =E2=80=98__nf_ct_helper_=
find=E2=80=99:
> net/netfilter/nf_conntrack_helper.c:58: error: implicit declaration of fu=
nction =E2=80=98hlist_for_each_entry_rcu=E2=80=99
> net/netfilter/nf_conntrack_helper.c:58: error: =E2=80=98hnode=E2=80=99 un=
declared (first use in this function)
> net/netfilter/nf_conntrack_helper.c:58: error: (Each undeclared identifie=
r is reported only once
> net/netfilter/nf_conntrack_helper.c:58: error: for each function it appea=
rs in.)
> net/netfilter/nf_conntrack_helper.c:58: error: expected =E2=80=98;=E2=80=
=99 before =E2=80=98{=E2=80=99 token
> net/netfilter/nf_conntrack_helper.c:50: warning: unused variable =E2=80=
=98mask=E2=80=99
> net/netfilter/nf_conntrack_helper.c: In function =E2=80=98__nf_conntrack_=
helper_find_byname=E2=80=99:
> net/netfilter/nf_conntrack_helper.c:74: error: =E2=80=98hnode=E2=80=99 un=
declared (first use in this function)
> net/netfilter/nf_conntrack_helper.c:74: error: expected =E2=80=98;=E2=80=
=99 before =E2=80=98{=E2=80=99 token
> net/netfilter/nf_conntrack_helper.c: In function =E2=80=98nf_conntrack_he=
lper_register=E2=80=99:
> net/netfilter/nf_conntrack_helper.c:117: error: implicit declaration of f=
unction =E2=80=98hlist_add_head_rcu=E2=80=99
> net/netfilter/nf_conntrack_helper.c: In function =E2=80=98nf_conntrack_he=
lper_unregister=E2=80=99:
> net/netfilter/nf_conntrack_helper.c:133: error: implicit declaration of f=
unction =E2=80=98hlist_del_rcu=E2=80=99
> make[2]: *** [net/netfilter/nf_conntrack_helper.o] Error 1
> make[1]: *** [net/netfilter] Error 2
> make: *** [net] Error 2

Thanks for the report and patch.  This looks like it is probably broken in
Linus' kernel.  What config did you use to get the error?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__21_May_2008_22_52_14_+1000_rBaH_X1/r62uLNH.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFINBsDTgG2atn1QN8RAhb2AJ4xGMMpLnPPLFeDJwmXYNi+snWeLwCfchDo
nPxdtdMErTq6mJztE+lS2v4=
=pl8f
-----END PGP SIGNATURE-----

--Signature=_Wed__21_May_2008_22_52_14_+1000_rBaH_X1/r62uLNH.--
