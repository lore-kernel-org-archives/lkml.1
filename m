Return-Path: <linux-kernel-owner+w=401wt.eu-S1755124AbZJ3FN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755124AbZJ3FN3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 01:13:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754822AbZJ3FN2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 01:13:28 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:47051 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754806AbZJ3FN2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 01:13:28 -0400
Date: Fri, 30 Oct 2009 16:13:20 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "Joseph S. Myers" <joseph@codesourcery.com>, linux-api@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <onestero@redhat.com>,
       Stephane Eranian <eranian@googlemail.com>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Roland McGrath <roland@redhat.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: F_SETOWN_EX and F_GETLK64 conflict
Message-Id: <20091030161320.17d07dc9.sfr@canb.auug.org.au>
In-Reply-To: <1254691822.21044.9.camel@laptop>
References: <Pine.LNX.4.64.0910041229300.20203@digraph.polyomino.org.uk>
	<1254691822.21044.9.camel@laptop>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__30_Oct_2009_16_13_20_+1100_D3NqZ+.Fp_O8cjYi"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__30_Oct_2009_16_13_20_+1100_D3NqZ+.Fp_O8cjYi
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Peter,

On Sun, 04 Oct 2009 23:30:22 +0200 Peter Zijlstra <a.p.zijlstra@chello.nl> =
wrote:
>
> On Sun, 2009-10-04 at 12:35 +0000, Joseph S. Myers wrote:
> > In asm-generic/fcntl.h, F_SETOWN_EX and F_GETLK64 both have value 12, a=
nd=20
> > F_GETOWN_EX and F_SETLK64 both have value 13.  I don't see how this is=
=20
> > going to work correctly.  See=20
> > <http://sourceware.org/ml/libc-ports/2009-10/msg00013.html>.
>=20
>=20
> Ugh,.. yeah, non obvious collision that.

This is why we have F_LINUX_SPECIFIC_BASE and use it in
include/linux/fcntl.h ... it should be used as a base for any new fcntl
types since they don't require backward compatibility.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__30_Oct_2009_16_13_20_+1100_D3NqZ+.Fp_O8cjYi
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkrqdfAACgkQjjKRsyhoI8wR6ACdEKs7znjR8nNcvA2ZaCLZNR0c
wmYAoI3XL92cSFc3MHyMDgsUo/nfpcEa
=813U
-----END PGP SIGNATURE-----

--Signature=_Fri__30_Oct_2009_16_13_20_+1100_D3NqZ+.Fp_O8cjYi--
