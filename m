Return-Path: <linux-kernel-owner+w=401wt.eu-S1757340AbZFBAck@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757340AbZFBAck (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 20:32:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755578AbZFBAcX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 20:32:23 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:39799 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754204AbZFBAcW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 20:32:22 -0400
Date: Tue, 2 Jun 2009 10:32:16 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Steven Rostedt <srostedt@redhat.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the kmemcheck tree with the tracing
 tree
Message-Id: <20090602103216.dab209a1.sfr@canb.auug.org.au>
In-Reply-To: <1243866799.18138.9.camel@localhost.localdomain>
References: <20090601175539.67317265.sfr@canb.auug.org.au>
	<1243866799.18138.9.camel@localhost.localdomain>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__2_Jun_2009_10_32_16_+1000_P_KUxx2GG9st.TqK"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__2_Jun_2009_10_32_16_+1000_P_KUxx2GG9st.TqK
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Steve,

On Mon, 01 Jun 2009 10:33:19 -0400 Steven Rostedt <srostedt@redhat.com> wro=
te:
>
> >  +	/*
> >  +	 * The actual tail page has moved forward.
> >  +	 */
> >  +	if (tail < BUF_PAGE_SIZE) {
> >  +		/* Mark the rest of the page with padding */
> >  +		event =3D __rb_page_index(tail_page, tail);
> > ++		kmemcheck_annotate_bitfield(event, bitfield);
>=20
> Is this...

Just this (since the code was outdented and moved slightly).

> > @@@ -1311,12 -1289,9 +1313,13 @@@
> >   		return NULL;
> >  =20
> >   	event =3D __rb_page_index(tail_page, tail);
> > + 	kmemcheck_annotate_bitfield(event, bitfield);
>=20
> and this the only changes you needed to fix?

This one git merged on its own.

The "++" is the clue.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__2_Jun_2009_10_32_16_+1000_P_KUxx2GG9st.TqK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkokcxAACgkQjjKRsyhoI8yQuACgtCg5JrwVNt9QEyfD+Xcq6mcf
9KAAoLub4gy2VH/yrnd0e3QRLw+FGBiJ
=Z0/H
-----END PGP SIGNATURE-----

--Signature=_Tue__2_Jun_2009_10_32_16_+1000_P_KUxx2GG9st.TqK--
